Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536F645DE0D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356392AbhKYPzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:55:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhKYPxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 10:53:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21B2F610D1;
        Thu, 25 Nov 2021 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637855390;
        bh=y+FsVswUfu9wkFmXREI3ZDwQZ72b63X5+FsshXIQ0Hc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KCoSRh7faioLazqQGW84xvvL6HItmAwAB6VC0mFy5yoxWbl+gX0Z+vAW/VbLbZ8KB
         ZtTpGOtcnDuf1vmBqjvrGP1H1p1UEfPkKuP0VVQ9Cqq31mbA1YxG6yUpfhJIPF/vQE
         u1r2OhxvgO5eT1M11bJUdBNi1yDs6zZm13LWD805D+NWcNMul0qgMb/EaXURyjPqUD
         Lfvnu+4kQ2py7GAce5A4kazk1rb6yRJjNG1lQoCf1OWho4kHmCgdY08muqXvCwk+wr
         2E4EBP7xmAz7+OOE5rjJbPhjJnk1J8cOlCnLE/BWVB3MuBjcydtgG/VHuIiU61KoLG
         c1dZX6AJb4xTA==
Date:   Thu, 25 Nov 2021 07:49:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        netdev@vger.kernel.org, ath10k@lists.infradead.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [Bug 215129] New: Linux kernel hangs during power down
Message-ID: <20211125074949.5f897431@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1849b7a3-cdfe-f9dc-e4d1-172e8b1667d2@gmail.com>
References: <20211124144505.31e15716@hermes.local>
        <20211124164648.43c354f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1849b7a3-cdfe-f9dc-e4d1-172e8b1667d2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 08:32:18 +0100 Heiner Kallweit wrote:
> I think the reference to ath10k_pci is misleading, Kalle isn't needed here.
> The actual issue is a RTNL deadlock in igb_resume(). See log snippet:
> 
> Nov 24 18:56:19 MartinsPc kernel:  igb_resume+0xff/0x1e0 [igb 21bf6a00cb1f20e9b0e8434f7f8748a0504e93f8]
> Nov 24 18:56:19 MartinsPc kernel:  pci_pm_runtime_resume+0xa7/0xd0
> Nov 24 18:56:19 MartinsPc kernel:  ? pci_pm_freeze_noirq+0x110/0x110
> Nov 24 18:56:19 MartinsPc kernel:  __rpm_callback+0x41/0x120
> Nov 24 18:56:19 MartinsPc kernel:  ? pci_pm_freeze_noirq+0x110/0x110
> Nov 24 18:56:19 MartinsPc kernel:  rpm_callback+0x35/0x70
> Nov 24 18:56:19 MartinsPc kernel:  rpm_resume+0x567/0x810
> Nov 24 18:56:19 MartinsPc kernel:  __pm_runtime_resume+0x4a/0x80
> Nov 24 18:56:19 MartinsPc kernel:  dev_ethtool+0xd4/0x2d80
> 
> We have at least two places in net core where runtime_resume() is called
> under RTNL. This conflicts with the current structure in few Intel drivers
> that have something like the following in their resume path.
> 
> 	rtnl_lock();
> 	if (!err && netif_running(netdev))
> 		err = __igb_open(netdev, true);
> 
> 	if (!err)
> 		netif_device_attach(netdev);
> 	rtnl_unlock();
> 
> Other drivers don't do this, so it's the question whether it's actually
> needed here to take RTNL. Some discussion was started [0], but it ended
> w/o tangible result and since then it has been surprisingly quiet.
> 
> [0] https://www.spinics.net/lists/netdev/msg736880.html

Ah, that makes perfect sense, I didn't see that stack trace. 
Dropping Kalle from CC. Let's hear what Intel folks have to say..
