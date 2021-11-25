Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582BF45D265
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244798AbhKYBSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:18:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244980AbhKYBQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:16:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AF2061074;
        Thu, 25 Nov 2021 01:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637802808;
        bh=1rYrjs40FlZEXnBlGyjhcetuGKPTUA/WuwDvZB6ibNI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mV/B5NbT1EpFTxOOAGMqQx+QhG5uB5oyKxWgXp3aefZhE90+iwXW5Duzjig1/KoP2
         pCby5eAbRoTdRmvJIVm944bc0OqGI4qGIaVSAsfqas0chtD13jQjWDbv96CZFZ79/U
         2qAS7fwMr2rP5R8qT6c4gPk3bzdyddoKE2rn7yjuGXKQGnzL+BayX33Wq/JR2Ztu3Z
         LnvPfs6JDBvgHCbIxAD4ybnWwbIss6VAr4Ntrp6QR+KC2nstEaMHRmFbR9H09b1neF
         56Rojtg2YLNa2/8o+J0svM7uWNajsRnwHAsbe5rA6wkiZGWISac7ljs1CZDHyFjI9F
         jpGFv+QpRp6MQ==
Date:   Wed, 24 Nov 2021 17:13:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Stefan Dietrich <roots@gmx.de>, Greg KH <greg@kroah.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [REGRESSION] Kernel 5.15 reboots / freezes upon ifup/ifdown
Message-ID: <20211124171327.089e3cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87a6htm4aj.fsf@intel.com>
References: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
        <YZ3q4OKhU2EPPttE@kroah.com>
        <8119066974f099aa11f08a4dad3653ac0ba32cd6.camel@gmx.de>
        <20211124153449.72c9cfcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87a6htm4aj.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 17:07:16 -0800 Vinicius Costa Gomes wrote:
> Hi Stefan,
> 
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Wed, 24 Nov 2021 18:20:40 +0100 Stefan Dietrich wrote:  
> >> Hi all,
> >> 
> >> six exciting hours and a lot of learning later, here it is.
> >> Symptomatically, the critical commit appears for me between 5.14.21-
> >> 051421-generic and 5.15.0-051500rc2-generic - I did not find an amd64
> >> build for rc1.
> >> 
> >> Please see the git-bisect output below and let me know how I may
> >> further assist in debugging!  
> >
> > Well, let's CC those involved, shall we? :)
> >
> > Thanks for working thru the bisection!
> >  
> >> a90ec84837325df4b9a6798c2cc0df202b5680bd is the first bad commit
> >> commit a90ec84837325df4b9a6798c2cc0df202b5680bd
> >> Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >> Date:   Mon Jul 26 20:36:57 2021 -0700
> >> 
> >>     igc: Add support for PTP getcrosststamp()  
> 
> Oh! That's interesting.
> 
> Can you try disabling CONFIG_PCIE_PTM in your kernel config? If it
> works, then it's a point in favor that this commit is indeed the
> problematic one.
> 
> I am still trying to think of what could be causing the lockup you are
> seeing.

Actually we just had another report pointing at commit f32a21376573
("ethtool: runtime-resume netdev parent before ethtool ioctl ops").
That seems more likely :(
