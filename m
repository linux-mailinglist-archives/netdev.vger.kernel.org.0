Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2933FF559
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 23:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346382AbhIBVIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 17:08:52 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42713 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230315AbhIBVIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 17:08:51 -0400
Received: from cust-b66e5d83 ([IPv6:fc0c:c157:b88d:62c6:5e3c:5f07:82d0:1b4])
        by smtp-cloud8.xs4all.net with ESMTPA
        id Ltw6mJRhfy7WyLtw7m8aV6; Thu, 02 Sep 2021 23:07:51 +0200
Received: from localhost (localhost [127.0.0.1])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 5B1FB1632E5;
        Thu,  2 Sep 2021 23:07:50 +0200 (CEST)
Received: from keetweej.vanheusden.com ([127.0.0.1])
        by localhost (mauer.intranet.vanheusden.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5YpzchS-o1s6; Thu,  2 Sep 2021 23:07:49 +0200 (CEST)
Received: from belle.intranet.vanheusden.com (belle.intranet.vanheusden.com [192.168.64.100])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 01213163898;
        Thu,  2 Sep 2021 22:54:24 +0200 (CEST)
Received: by belle.intranet.vanheusden.com (Postfix, from userid 1000)
        id E3FCA162F75; Thu,  2 Sep 2021 22:54:23 +0200 (CEST)
Date:   Thu, 2 Sep 2021 22:54:23 +0200
From:   folkert <folkert@vanheusden.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org
Subject: Re: masquerading AFTER first packet
Message-ID: <20210902205423.GG3350910@belle.intranet.vanheusden.com>
References: <20210901204204.GB3350910@belle.intranet.vanheusden.com>
 <20210902162612.GA23554@breakpoint.cc>
 <20210902174845.GE3350910@belle.intranet.vanheusden.com>
 <20210902200736.GB23554@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902200736.GB23554@breakpoint.cc>
Reply-By: Wed 01 Sep 2021 07:11:01 PM CEST
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Envelope: MS4xfPdXCQbuq6XCUVHOVYEuDrV5KH/QkMTKBtd4Xi3WOihLQr1/29HYeMruQNCOZQOvS9il1T5qSXSD9TEZikoZOjzvNWlGaz0lA4ck2aesI7+B3R/AUqJP
 sJdT/RGlzYyXK3o49aqx9rB3ndPyjI+VjiL18HyKbztLFyWAvNS6t8SUZMZR0Tzb495AMPiEgk6yzhEGXLUWiUik6soOa6ZBnw/C36WKLv9m1rGfATxqPZuy
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > [Thu Sep  2 19:40:54 2021] nf_ct_proto_17: bad checksum IN= OUT= SRC=192.168.4.2 DST=185.243.112.54 LEN=82 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=161 DPT=56523 LEN=61
> 
> So reverse direction packets are deemed invalid and are thus not reverse-translated.
> 
> This is a bug, but not sure where.  What driver/nic is feeding these
> packets to stack?

> sysctl net.netfilter.nf_conntrack_checksum=0
> should make things "work".

Indeed it does!

"The other end", the one feeding the packets, is a toy IP-stack
implementation of myself. I verified the correctness of the IP/UDP
checksums by looking at wireshark (after enabling them) and tcpdump;
they both say all is fine (else I wouldn't bother this mailinglist with
this). https://github.com/folkertvanheusden/myip by the way (not a full
implementation, just the bare essentials to get tcp/udp working).

Now there are also situations (different ISPs/VPS providers) where
no packets at all are received (and situations where all are received!).
I guess that can be explained by that some are less strict than others.

So conclusion: my IP-stack *may* be producing incorrect checksums, or
Linux or tcpdump and wireshark may be incorrectly evaluating them?


Folkert.
