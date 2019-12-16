Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E7711FCAC
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 02:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLPB7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 20:59:08 -0500
Received: from mail.grenz-bonn.de ([178.33.37.38]:43001 "EHLO
        mail.grenz-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfLPB7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 20:59:07 -0500
Received: from cg-notebook.local (unknown [IPv6:2001:41d0:1:c648:b055:ea5:64df:98e7])
        by ks357529.kimsufi.com (Postfix) with ESMTPSA id D3C8762A09;
        Mon, 16 Dec 2019 02:59:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=grenz-bonn.de;
        s=201905; t=1576461545;
        bh=s9+qNv61LILKd4niEFhKMInzLXCeGuEP3TS7tlPjxkI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=4S3uk9tEWdHFIoGNCAjyDKnU/F+CTMk/aq3EQ6LiJMBqTylZEujsoot0NW23JYl3N
         gfbousb/yM6Ai5IrPl50LI+BxYmnC7exTFnvbdl6uKGa8mqwcR8fCi1BnX1cEvXjdp
         0GjGc407GTpsKiu2Phd7PAI0zgCvOgWVxyJcUtg1CpGIPFeEHBboIxXvbeMF7n6cYf
         7hDykjvNJzxrAE351f4Eb4NV4eMr22R9eYe30mJ5Hp/A0EJZ4XBdPs265EB/s8nkgk
         QxI5BA8Oy9z7oxVJW4ElLcdU2hWq3crZYNLRVlDWziCCFiR6lkD1Hy2HvmKCORvGyH
         W5cVsP/rTxXeA==
From:   Christoph Grenz <christophg+lkml@grenz-bonn.de>
To:     Tom Herbert <tom@herbertland.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: IPv6 Destination Options question
Date:   Mon, 16 Dec 2019 02:59:01 +0100
Message-ID: <98532586.q66oQjG9bA@cg-notebook>
User-Agent: KMail/5.1.3 (Linux/5.4.0cgnotebook+; KDE/5.18.0; x86_64; ; )
In-Reply-To: <10108598.co7siHb18S@cg-notebook>
References: <5975583.vpC7qLWE0j@cg-notebook> <CALx6S36PsbRW+Z0Eeh2Dtkb-hzXGekD-PLyML08g4xo5Vddvug@mail.gmail.com> <10108598.co7siHb18S@cg-notebook>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom,

I narrowed the issue down to a possible bug in the kernel-side IPv6 checksum 
calculation:

A raw socket for IPPROTO_MH has checksum calculation/verification enabled by 
default (as if setsockopt(s, IPPROTO_IPV6, IPV6_CHECKSUM, 4) was used).

I get different checksums for the same packet with and without IPV6_DSTOPTS 
ancillary data. The checksum is independent of the content of the Destination 
Options, but adding multiple IPV6_DSTOPTS anciliary data items changes the 
calculated checksum, even if the resulting packet is otherwise identical.

The checksum verification then discards the packets on the receiving side, 
which is why I didn't get any packets on my IPPROTO_MH socket and suspected a 
problem on the receiving side first.

When I calculate the checksum in userspace and set the IPV6_CHECKSUM socket 
option to -1 to disable the in-kernel calculation on the sending side, I 
receive all packets as expected.

It doesn't happen with IPV6_HOPOPTS or IPV6_RTHDR ancillary data, at least as 
far as I checked.

Could you take a look at it before I submit a bug report?

Best regards
Christoph


Am Samstag, 14. Dezember 2019, 22:11:01 CET schrieb Christoph Grenz:
> Hi Tom,
> 
> my receive code boils down to this Python script:
> 
> --------------------------------------------------------------------
> #!/usr/bin/env python3
> 
> from socket import socket, AF_INET6, IPPROTO_IPV6, IPV6_RECVDSTOPTS,
> SOCK_RAW
> 
> IPPROTO_MH = 135 # IPv6 Mobility Header
> 
> sock = socket(AF_INET6, SOCK_RAW, IPPROTO_MH)
> sock.setsockopt(IPPROTO_IPV6, IPV6_RECVDSTOPTS, True)
> 
> sock.bind(('::',  0))
> 
> while True:
> 	packet, ancdata, msg_flags, address = sock.recvmsg(1800, 512)
> 	print(address[0], packet.hex(), ancdata)
> 
> --------------------------------------------------------------------
> 
> Best regards,
> Christoph
> 
> Am Samstag, 14. Dezember 2019, 12:40:16 CET schrieb Tom Herbert:
> > On Sat, Dec 14, 2019 at 8:19 AM Christoph Grenz
> > 
> > <christophg+lkml@grenz-bonn.de> wrote:
> > > Hello,
> > > 
> > > I'm playing around with Mobile IPv6 and noticed a strange behaviour in
> > > the
> > > Linux network system when using IPv6 destination options:
> > > 
> > > I'm able to send destination options on SOCK_DGRAM and SOCK_RAW sockets
> > > with sendmsg() and IPV6_DSTOPTS ancillary data. The sent packets also
> > > look correct in Wireshark.
> > > 
> > > But I'm not able to receive packets with destination options on a socket
> > > with the IPV6_RECVDSTOPTS socket option enabled. Both a packet with a
> > > Home Address Option and a packet with an empty destination options
> > > header
> > > (only containing padding) won't be received on a socket for the payload
> > > protocol.
> > 
> > Christoph, Can you post your receive code?
> > 
> > Thanks
> > 
> > > Only a SOCK_RAW socket for IPPROTO_DSTOPTS receives the packet.
> > > 
> > > I tested this on a vanilla 5.4.0 kernel and got the same behaviour.
> > > Activating dyndbg for everything in net/ipv6 didn't produce any relevant
> > > output in dmesg.
> > > 
> > > Is this expected behaviour or a bug? Or do I maybe need some other
> > > socket
> > > option or a xfrm policy to receive packets with destination options?
> > > 
> > > Best regards
> > > Christoph


