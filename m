Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE88F2D5B85
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 14:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733200AbgLJNWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 08:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbgLJNWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 08:22:52 -0500
X-Greylist: delayed 1321 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Dec 2020 05:22:11 PST
Received: from mail.rfc2324.org (mail.rfc2324.org [IPv6:2a01:a700:4621:867::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF39C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 05:22:11 -0800 (PST)
Received: from rfc2324.org ([31.172.8.84] helo=principal.rfc2324.org)
        by mail.rfc2324.org with esmtp rfc2324.org Mailserver
        id 1knLYF-00009e-Db
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 14:00:09 +0100
Received: by principal.rfc2324.org (Postfix, from userid 666)
        id 4031B8F32F; Thu, 10 Dec 2020 14:00:07 +0100 (CET)
Date:   Thu, 10 Dec 2020 14:00:07 +0100
From:   Maximilian Wilhelm <max@rfc2324.org>
To:     netdev@vger.kernel.org
Message-ID: <20201210130007.GX22874@principal.rfc2324.org>
Mail-Followup-To: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Warning: This message may contain ironic / sarcastic elements.
X-GC-3.12: GCM/CS/IT/MU d+(--) s: a C++$ UL++++$ P++ L++++ E--- W+ N o+ K- w
 O? M V? PS+ PE Y+(++) PGP++ t 5+ X- R* !tv b+(++) DI+(++) !D G+ e+++*
 h>-(---) r++ y?
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 31.172.8.84
X-SA-Exim-Mail-From: max@principal.rfc2324.org
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.rfc2324.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00 autolearn=ham
        autolearn_force=no version=3.4.2
Subject: Regression in igb / bonding / VLAN between 5.8.10 and 5.9.6?
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mail.rfc2324.org)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear netdev people,

I updated one of my APU2 boxes yesterday and was confronted with an
interesting problem: With (Debian) Kernel 5.9.6 VLAN interfaces on top
of a bond on top of two I210 NICs are working only one way (outbound)
unless the VLAN interface is in promisc mode.

The setup looks like this

        enp1s0       enp2s0
           \           /
            \         /
	     \       /
               bond0 (LACP L3+4)
             /       \
            /         \
           /           \
        vlan23       vlan42

Traffic leaving the box (ARP, ND, OSPF Hellos, ...) works fine
according to tcpdump on a connected device, but inbound traffic only
seems to reach the system when vlanXX is in promisc mode.  If I do a
tcpdump on vlanXX with --no-promiscuous-mode, I can confirm that there
only are outbound packets and none of the ARP replies etc. sent by the
remote box.  On bond0 as well as on the physical NICs I see the same
behaviour (+ LACP frames on the NICs).

I did some tests to pinpoint the problem:
 * VLAN interfaces on top of the physical NIC work fine
 * LACP seems to work fine, slow/fast don't make a difference
 * Disabling all offloading I could disable didn't make it work
   (especially rxvlan)
 * With (Debian) kernel 5.8.10 it works
 * /proc/net/dev shows no rx errors or drops at all only one TX drop
   on the VLAN interfaces

I couldn't find anything suspicous on the box neither in the logs nor
in  ip -d link  etc. Is this a know bug? If not should I test anything
specific or maybe do a git bisect between the kernel versions?

Kind regards
Max
-- 
"Does it bother me, that people hurt others, because they are to weak to face the truth? Yeah. Sorry 'bout that."
 -- Thirteen, House M.D.
