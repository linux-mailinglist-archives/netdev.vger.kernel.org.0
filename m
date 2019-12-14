Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD0D11F42E
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 22:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfLNVLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 16:11:06 -0500
Received: from mail.grenz-bonn.de ([178.33.37.38]:53932 "EHLO
        mail.grenz-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfLNVLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 16:11:06 -0500
Received: from cg-notebook.local (unknown [IPv6:2001:41d0:1:c648:b055:ea5:64df:98e7])
        by ks357529.kimsufi.com (Postfix) with ESMTPSA id C438062283;
        Sat, 14 Dec 2019 22:11:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=grenz-bonn.de;
        s=201905; t=1576357864;
        bh=vpLtVM/zXRmIsAQmEcAO99MslPd9rzbzmxrM0cpGLEg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jYWOszCfgi6EY1NvFQuH0mRv41fpb14VhEmx0nJKPzPCicx5zSp9oOW5v5VYcdVu0
         llFBdIsBhSVg6geQ+PbuUbkmO3yXo6zeHNREVDCGzJlkUfb05o83E5nZ7qLJL/CC4p
         rPYS3kM4oEu3NrvjJdtfpb0x7f+z/ZD9/K+T0Qh6jsqqE+XhgTYMVkMuYjukyM5+qq
         QaQpmJvzS8gpMtn5SzCI+TgS6665x4M6Zzn+R6L3EVY2TmBG7vbBYB4OwFrI9RppmU
         iiAh8OMuBwVnKouKF1IFt6ptOMbV1sN3HWVaZyFl87I/Iog+frM0wzGoPnv1s5xHLw
         nW+j3+GTW2/ig==
From:   Christoph Grenz <christophg+lkml@grenz-bonn.de>
To:     Tom Herbert <tom@herbertland.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: IPv6 Destination Options question
Date:   Sat, 14 Dec 2019 22:11:01 +0100
Message-ID: <10108598.co7siHb18S@cg-notebook>
User-Agent: KMail/5.1.3 (Linux/5.4.0cgnotebook+; KDE/5.18.0; x86_64; ; )
In-Reply-To: <CALx6S36PsbRW+Z0Eeh2Dtkb-hzXGekD-PLyML08g4xo5Vddvug@mail.gmail.com>
References: <5975583.vpC7qLWE0j@cg-notebook> <CALx6S36PsbRW+Z0Eeh2Dtkb-hzXGekD-PLyML08g4xo5Vddvug@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom,

my receive code boils down to this Python script:

--------------------------------------------------------------------
#!/usr/bin/env python3

from socket import socket, AF_INET6, IPPROTO_IPV6, IPV6_RECVDSTOPTS, SOCK_RAW

IPPROTO_MH = 135 # IPv6 Mobility Header

sock = socket(AF_INET6, SOCK_RAW, IPPROTO_MH)
sock.setsockopt(IPPROTO_IPV6, IPV6_RECVDSTOPTS, True)

sock.bind(('::',  0))

while True:
	packet, ancdata, msg_flags, address = sock.recvmsg(1800, 512)
	print(address[0], packet.hex(), ancdata)

--------------------------------------------------------------------

Best regards,
Christoph

Am Samstag, 14. Dezember 2019, 12:40:16 CET schrieb Tom Herbert:
> On Sat, Dec 14, 2019 at 8:19 AM Christoph Grenz
> 
> <christophg+lkml@grenz-bonn.de> wrote:
> > Hello,
> > 
> > I'm playing around with Mobile IPv6 and noticed a strange behaviour in the
> > Linux network system when using IPv6 destination options:
> > 
> > I'm able to send destination options on SOCK_DGRAM and SOCK_RAW sockets
> > with sendmsg() and IPV6_DSTOPTS ancillary data. The sent packets also
> > look correct in Wireshark.
> > 
> > But I'm not able to receive packets with destination options on a socket
> > with the IPV6_RECVDSTOPTS socket option enabled. Both a packet with a
> > Home Address Option and a packet with an empty destination options header
> > (only containing padding) won't be received on a socket for the payload
> > protocol.
> 
> Christoph, Can you post your receive code?
> 
> Thanks
> 
> > Only a SOCK_RAW socket for IPPROTO_DSTOPTS receives the packet.
> > 
> > I tested this on a vanilla 5.4.0 kernel and got the same behaviour.
> > Activating dyndbg for everything in net/ipv6 didn't produce any relevant
> > output in dmesg.
> > 
> > Is this expected behaviour or a bug? Or do I maybe need some other socket
> > option or a xfrm policy to receive packets with destination options?
> > 
> > Best regards
> > Christoph


