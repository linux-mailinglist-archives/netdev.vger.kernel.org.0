Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8B73AD4F8
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhFRWVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234103AbhFRWVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 18:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE58D61264;
        Fri, 18 Jun 2021 22:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624054782;
        bh=sZaknYZj03Toh662gekYN0SKuf0YEXO8Ei3j33qtXWY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ORwWegHL/apTU4SOUnJ6b6XTUsgVwXzT29HUOJP/HM/X9mc5fYEqb3wEuiDtkWK5T
         Odbr2+qlDJ1WDO87ff3vy4IofPRB/0ccPhiNFBg+A1OCYWLsssaBYR0MN/bx8BNxap
         bQZl8N2egLssd87wlJ/Skyp55jb1XNvntjvZ3TY3DAWwucMgsDViBt3IdbdM5M7/Nd
         PBugYFdXbDBFdfVJSw87k/mWjINIvzbDRiUexTn293XK23dgKTp9QYJJKmvvY6NGPD
         GUXL/PA1P7HWyrLVaX++RaAuB7Dtn9psX9cJENQPw8LvBwOicAzREsgWLrlMZzAyun
         CZdpNPDJBtrSg==
Date:   Fri, 18 Jun 2021 15:19:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arijit De <arijitde@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Ping frame drop
Message-ID: <20210618151941.04a2494d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SJ0PR18MB3994A5156DF9B144838A746ED40D9@SJ0PR18MB3994.namprd18.prod.outlook.com>
References: <SJ0PR18MB3994A5156DF9B144838A746ED40D9@SJ0PR18MB3994.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 15:03:59 +0000 Arijit De wrote:
> Hi,
> 
> In the latest linux kernel (i.e. 5.12.x) I am observing that for my
> Ethernet driver ping test has stopped working, it was working in
> 5.4.x and all the older kernels. I have debugged the issue and root
> caused that it's because of the recent commit
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=8f9a69a92fc63917c9bd921b28e3b2912980becf
> 
> In my Network card HW it supports checksum offload for IPv4 frame,
> but it can't verify checksum for the ICMP frames, so I use
> CHECKSUM_PARTIAL in the skb->ip_summed for this kind of scenario.

Do you mean that your drivers sets up CHECKSUM_PARTIAL on Rx? If HW
hasn't validated the checksum just leave the skb with CHECKSUM_NONE,
the stack will validate.

> But now because of this new logic what you have added ping frames are
> getting dropped.
> 
> My Ping packets skb dump:
> [112241.545219] skb len=88 headroom=78 headlen=0 tailroom=0
> [112241.545219] mac=(64,-64) net=(0,-1) trans=-1
> [112241.545219] shinfo(txflags=0 nr_frags=1 gso(size=0 type=0 segs=0))
> [112241.545219] csum(0x0 ip_summed=3 complete_sw=0 valid=0 level=0)
> [112241.545219] hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=0 iif=0
> [112241.572837] dev name=enp137s0 feat=0x0x0000010000004813
> [112241.578141] skb headroom: 00000000: 4c 00 70 35 09 de b4 e4 00 11
> 22 33 44 01 08 06 [112241.585876] skb headroom: 00000010: 00 01 08 00
> 06 04 00 02 00 11 22 33 44 01 0a 1c [112241.593611] skb headroom:
> 00000020: 28 13 70 35 09 de b4 e4 0a 1c 28 01 00 00 00 00
> [112241.601345] skb headroom: 00000030: 50 04 00 00 55 50 00 00 14 00
> 03 00 00 00 00 00 [112241.609080] skb headroom: 00000040: 00 11 22 33
> 44 01 ac 1f 6b d2 c0 e5 08 00 [112241.616293] skb frag:     00000000:
> 45 00 00 54 87 a2 40 00 40 01 4d e3 0a 1c 28 d9 [112241.624027] skb
> frag:     00000010: 0a 1c 28 13 08 00 fd 50 0c a8 00 03 6a 94 cc 60
> [112241.631762] skb frag:     00000020: 00 00 00 00 f5 3b 03 00 00 00
> 00 00 10 11 12 13 [112241.639496] skb frag:     00000030: 14 15 16 17
> 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 [112241.647230] skb frag:
> 00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
> [112241.654965] skb frag:     00000050: 34 35 36 37 9c b0 19 b9
> 
> Its hitting the check for CHECKSUM_PARTIAL in pskb_trim_rcsum_slow()
> and getting dropped there. Can you please let me know how can I
> satisfy the requirement such that I can keep supporting the
> CHECKSUM_PARTIAL cases for my network card ? I have checked
> include/linux/skbuff.h For the documentation of CHECKSUM_PARTIAL, but
> could not understand what change I have to do to make it working
> again. My network driver is not up streamed yet in the linux kernel.
> For any more information please do let me know.

