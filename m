Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4302F235A48
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 21:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgHBTxn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 2 Aug 2020 15:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgHBTxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 15:53:43 -0400
X-Greylist: delayed 710 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 02 Aug 2020 12:53:40 PDT
Received: from herc.mirbsd.org (herc.mirbsd.org [IPv6:2001:470:1f15:10c:202:b3ff:feb7:54e8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A64DBC06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 12:53:40 -0700 (PDT)
Received: from herc.mirbsd.org (tg@herc.mirbsd.org [192.168.0.82])
        by herc.mirbsd.org (8.14.9/8.14.5) with ESMTP id 072JTpZm011316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Sun, 2 Aug 2020 19:29:53 GMT
Date:   Sun, 2 Aug 2020 19:29:50 +0000 (UTC)
From:   Thorsten Glaser <t.glaser@tarent.de>
X-X-Sender: tg@herc.mirbsd.org
To:     Ben Hutchings <ben@decadent.org.uk>
cc:     966459@bugs.debian.org, netdev <netdev@vger.kernel.org>
Subject: Re: Bug#966459: linux: traffic class socket options (both IPv4/IPv6)
 inconsistent with docs/standards
In-Reply-To: <e67190b7de22fff20fb4c5c084307e0b76001248.camel@decadent.org.uk>
Message-ID: <Pine.BSM.4.64L.2008021919500.2148@herc.mirbsd.org>
References: <159596111771.2639.6929056987566441726.reportbug@tglase-nb.lan.tarent.de>
 <e67190b7de22fff20fb4c5c084307e0b76001248.camel@decadent.org.uk>
Content-Language: de-DE-1901, en-GB
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ben Hutchings dixit:

>ip(7) also doesn't document IP_PKTOPIONS.

Hmm, I don’t use IP_PKTOPIONS though. I’m not exactly sure I found
the correct place in the kernel for what I do.

On the sending side, I use setsockopt with either
IPPROTO_IP,IP_TOS or IPPROTO_IPV6,IPV6_TCLASS to
set the default traffic class on outgoing packets.

On the receiving side I use setsockopt with either
IPPROTO_IP,IP_RECVTOS or IPPROTO_IPV6,IPV6_RECVTCLASS
to set up the socket then recvmsg to get a cmsg(3) of
IPPROTO_IP,IP_TOS/IPPROTO_IPV6,IPV6_TCLASS from which
I read the traffic class octet.

These are where I believe I found inconsistencies
between code and documentation.

>Those are two different APIs though: recvmsg() for datagram sockets, vs
>getsockopt(... IP_PKTOPTIONS ...) for stream sockets.  They obviously
>ought to be consistent, but mistakes happen.

OK, I’m currently looking at the datagram case only.
This may change later if there’s enough time.

>I see no point in changing the IPv6 behaviour: it seems to be
>consistent with itself and with the standard

Not really: if the kernel writes an int and userspace reads
its first byte, it only works by accident on little endian,
but not elsewhere.

>so only risks breaking user-space that works today.

Hrm. It risks breaking userspace that reads an int. But the
RFC clearly says it should read the first byte, not an int.

>But you should know that the highest priority for Linux API
>compatibility is to avoid breaking currently working user-space.  That
>means that ugly and inconsistent APIs won't get fixed if it causes a
>regression for the programs people actually use.  If the API never
>worked like it was supposed to on some architectures, that's not a
>regression, and is lower priority.

This is why I just put this up for discussion instead of
requesting a specific change.

That being said, given that the IPv6 API is *only* documented
in the RFC and *not* documented in the Linux manpages…

(Perhaps codesearching for IPV6_TCLASS might also help.
It’s unclear how many users this has…)



In the end, what I really want, is clear documentation for
how I should implement the following file that it works on
Linux, and ideally also other systems implementing the RFC
API (FreeBSD supposedly does but needs testing):

https://github.com/tarent/ECN-Bits/blob/master/linux-c/lib/ecn.c

Given that there’s no documentation, trying to read the
coffee grounds from the kernel source, finding it doesn’t
even match the RFC (which, again, doesn’t match what itojun
proposed, for some reason), does not instigate trust in the
things I *think* I’ve found.

bye,
//mirabilos
-- 
tarent solutions GmbH
Rochusstraße 2-4, D-53123 Bonn • http://www.tarent.de/
Tel: +49 228 54881-393 • Fax: +49 228 54881-235
HRB 5168 (AG Bonn) • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg
