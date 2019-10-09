Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A476D14D3
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731831AbfJIRFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:05:08 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:25843 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731827AbfJIRFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 13:05:08 -0400
Date:   Wed, 09 Oct 2019 17:05:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=proton;
        t=1570640705; bh=Jfd4IHmbIvAGufv47C4ISi1ZB2G3B8cpDDARPGEhdwo=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=Vj8K32toHruhbtCidEdxQXy78KCQT/uAkA1JYvsspk3NhUw4EhIY1D8zoGgdeC/Qw
         hkHMHCIc8h752kiNKLPumrAdkvZ+k1MTRK+DqOG/Psiz9s1/UR5vyofchs4YYUHBPs
         BeAs7DYa1NZl+JIhdvDZXRQVrQylyPpHchh0XCaHSM9UINtXRB8Ftq+Rab/bLzzqyG
         8PPtP+1LWLkIzTYf+5zj3090MK5MxXUxUyrtpF26CRpl9h8ptnNABbG5jZTbEHsJNx
         thAQp98Aq2IGRoIRlhRbm0W+mQ8gBwzwV9HP5iIEJBkG/0HMBGiMa+ommfi+dGhx5T
         Byx/kHcTo6DEQ==
To:     netdev@vger.kernel.org
From:   Nate Sweet <nathanjsweet@pm.me>
Reply-To: Nate Sweet <nathanjsweet@pm.me>
Subject: UDP Statistics Bug?
Message-ID: <27467ed4-0520-8642-f4c7-6f4aeb54ef2a@pm.me>
Feedback-ID: 1BpzeQ_rwNsv3zO10OzQg9FlPYRTMwmBUdFyj--ieTcLCiCh6lDArvPDYS-HJt46cE6rJChf8i57fwi5SIVOpg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey net devs,

I would like some clarity on a problem I ran into last week. I was=20
diagnosing a DNS issue last week and got very side tracked by how=20
netstat reported stats to me. My issue was that UDP packets were being=20
dropped by all UDP sockets on the host, so when I ran `nestat -naus` and=20
it informed me that UdpInErrors=20
(https://elixir.bootlin.com/linux/v5.4-rc2/source/include/uapi/linux/snmp.h=
#L156)=20
was my main problem I spent a day trying to figure out what=20
application/mechanism was dropping UDP packets on the host. My=20
suspicion, based on the statistic I was seeing, was that it was going to=20
be something like BPF or a security module. To be fair to me, these two=20
mechanisms do indeed report their drops within this statistic=20
(https://elixir.bootlin.com/linux/v5.4-rc2/source/net/ipv4/udp.c#L2051).=20
Imagine my surprise when I discovered that the error that was actually=20
happening, was that the global UDP socket min was being reached, and all=20
the host UDP sockets were, indeed, experiencing buffer errors. The=20
problem is that wihtin the regular UDP socket datapath=20
`UDP_MIB_RCVBUFERRORS` only seem to be set here=20
(https://elixir.bootlin.com/linux/v5.4-rc2/source/net/ipv4/udp.c#L1945)=20
when the error is "ENOMEM". However, when `__sk_mem_raise_allocated`=20
fails=20
(https://elixir.bootlin.com/linux/v5.4-rc2/source/net/ipv4/udp.c#L1455)=20
it reports "ENOBUF". The issue ended up being an application that was=20
not processing it's backlog, because it wasn't closing old UDP sockets.=20
IMO, I would have gotten to this dianosis quicker if when I ran `nestat=20
-naus` I had gotten UdpRcvBuffErrors (`UDP_MIB_RCVBUFERRORS`) instead of=20
UdpInErrors. I realize that it is too late to change this error=20
reporting now, because it would break user space, but I think a new=20
error could be added to the kernel for UDP, such as=20
UdpRcvBuffGlobalErrors, or something like that, which could be double=20
reported. I think this would be a real time saver for folks, because I=20
really think UdpInErrors is counter-intuitively incorrect.

Thanks,

Nate Sweet



