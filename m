Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86C464447
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346141AbhLAAz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:55:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50284 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346089AbhLAAyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:54:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A496CE1D4F
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 00:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A355C53FC7;
        Wed,  1 Dec 2021 00:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638319872;
        bh=603hQGx7M3Fo6rynDEeE7WkR9kjjmrt0v24vGZPo3qg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mco++8171NAKa7VIuKVmGkcJSCV1AfBGEmFZec9Fomak+0VH24ySk9lWybztbfd6b
         kILXl2DhHu1NV6CxmhUfn5Y8ykx3UVE5lbW4+LyrzYmokV4G/s5xrea18wHzwLno0Y
         5CMGcTtvhE+RQnKoaIe7kajKfhm1AvUGl5sff4a/IkW6npywtcvnfxtfhT/KTlQEKS
         n9bjz3srrkxU++iob81zoUPMeHyHBA2VxeZfXP37/fzpjvguzFI52l/452zFqgzetz
         VnPcm+0F85MsnnXkWCGldTq+8gwMGrviB7xMRBta/oETR64xM9sQYmpmmWX9QZK3HO
         pqBHH6gzHOPYQ==
Date:   Tue, 30 Nov 2021 16:51:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM
 resume path
Message-ID: <20211130165110.291af62a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c6f3caef-dac2-cc4a-b5b5-70e7fa54d73f@gmail.com>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
        <20211129171712.500e37cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6edc23a1-5907-3a41-7b46-8d53c5664a56@gmail.com>
        <20211130091206.488a541f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c6f3caef-dac2-cc4a-b5b5-70e7fa54d73f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 22:35:27 +0100 Heiner Kallweit wrote:
> On 30.11.2021 18:12, Jakub Kicinski wrote:
> >> Not sure whether igb uses RPM the same way as r8169. There the device
> >> is runtime-suspended (D3hot) w/o link. Once cable is plugged in the PHY
> >> triggers a PME, and PCI core runtime-resumes the device (MAC).
> >> In this case RTNL isn't held by the caller. Therefore I don't think
> >> it's safe to assume that all callers hold RTNL.  
> > 
> > No, no - I meant to leave the locking in but add ASSERT_RTNL() to catch
> > if rpm == true && rtnl_held() == false.
> >   
> This is a valid case. Maybe it's not my day today, I still don't get
> how we would benefit from adding an ASSERT_RTNL().
> 
> Based on the following I think that RPM resume and device open()
> can't collide, because RPM resume is finished before open()
> starts its actual work.
> 
> static int __igb_open(struct net_device *netdev, bool resuming)
> {
> ...
> if (!resuming)
> 		pm_runtime_get_sync(&pdev->dev);

Ah, thanks, gotta start looking at the code before I say things..
