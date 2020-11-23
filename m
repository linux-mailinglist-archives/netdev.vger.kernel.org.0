Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7162C10F9
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390168AbgKWQmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:42:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390147AbgKWQmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 11:42:45 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE8DA20757;
        Mon, 23 Nov 2020 16:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606149765;
        bh=cPilrH5xGiqNYdjc64WOjkSB0wbIDCfP7pT/Zze32DU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v0DA7ZO/ZmlPL6xp4gBal2lx0TTIaYFXmHHrXDrVhoSv8qfvVWrDFpxxwavXOr21P
         pgkF1vwhRfwh40imvaM/CqAaN0AhS+ZIi2+iOex6zQr0KOFLJtrPMm9ROvtoITpSYP
         fghw80UMbTPAD08K5zqwFW4u8xp3b8m4ZIpZZmZ0=
Date:   Mon, 23 Nov 2020 08:42:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v4] aquantia: Remove the build_skb path
Message-ID: <20201123084243.423b23a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CY4PR1001MB2311E9770EF466FB922CBB27E8FD0@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119221510.GI15137@breakpoint.cc>
        <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119222800.GJ15137@breakpoint.cc>
        <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119225842.GK15137@breakpoint.cc>
        <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201121132204.43f9c4fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201121132324.72d79e94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CY4PR1001MB2311E9770EF466FB922CBB27E8FD0@CY4PR1001MB2311.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Nov 2020 22:36:22 +0000 Ramsay, Lincoln wrote:
> > (Next time please include in the subject the tree that you're targetting
> > the patch)  
> 
> I guess you mean like [PATCH master v5] ? Should I be targeting
> something other than the master branch on the main git repo?
> (https://github.com/torvalds/linux.git)

In this case the patch will be merged into the networking tree, and
then travel downstream to Linus. So you want to target this tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

IOW [PATCH net v5].

> > please add a From: line at the beginning of the mail which matches
> > the signoff (or use git-send-email, it'll get it right).  
> 
> Sure.
> 
> > Ah, one more thing, this is the correct fixes tag, right?
> > Fixes: 018423e90bee ("net: ethernet: aquantia: Add ring support code")
> > Please add it right before the signoff line.  
> 
> I didn't quite understand this header... but yeah, I guess that's the
> commit that adds the fast path I am removing.

Yup, it points to the oldest revision of the code where the bug is
present. In your case oldest revision where:

    When performing IPv6 forwarding, there is an expectation that SKBs
    will have some headroom. When forwarding a packet from the aquantia
    driver, this does not always happen, triggering a kernel warning.

> > > Align continuations of the lines under '(' like:  
> > 
> > I am only changing the leading indent. Am I still expected to satisfy the patch checker?
> > 
> > The current patch is very clear about what is happening if you do a diff -w but if I start
> > changing other things to satisfy the checker, that goes away.  
> 
> Some of the patch checker complaints are only leading whitespace
> (obviously not a problem for diff -w), but 2 of them involve actual
> changes (changing , to ; and moving the first argument from the line
> below to the line above).

I don't think it'll make a huge difference for the review-ability of
this change to heed checkpatch's warnings here.
