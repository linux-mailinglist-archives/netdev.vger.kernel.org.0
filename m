Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F9C463C94
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244678AbhK3RPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:15:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54006 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243657AbhK3RP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:15:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFB67B81A87
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 17:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D88DC58321;
        Tue, 30 Nov 2021 17:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638292327;
        bh=c7spWKu8dYoVFR3sXy90R1iv3uTWonZ5PZWCIKcze5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pUqWUp+92OvHF0xIa6x2HEQlbBnmS1+W4kni3BVFa/FL0fR7vL/aqqYSZ9vwtFAjq
         JZuCGUVNb0R89jH6Cuyh+wyXHJgaHCedy2IWT/nnhVvAZQmDNuOOmKVWZ3E8Eo6pNy
         94egXIxdaa3VxskzUGXVTvxfobazh1fqtPZeydvn3aDAkBd2GGs+23c4+zRLNjxrRP
         BlhhByAszE4DZT/4WsitJC3CVguv4R2ukfKIbJ18BrKWROejqZLnEu/6HpI+ygtRqi
         /MbXJkFywW1j2/pOqTlOMA8fC52CDk5MO/DaAZObnjyPZVkih8NzP4FsxqN1bNVRFQ
         1UmDMPJqQBnSg==
Date:   Tue, 30 Nov 2021 09:12:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM
 resume path
Message-ID: <20211130091206.488a541f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6edc23a1-5907-3a41-7b46-8d53c5664a56@gmail.com>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
        <20211129171712.500e37cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6edc23a1-5907-3a41-7b46-8d53c5664a56@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 07:46:22 +0100 Heiner Kallweit wrote:
> On 30.11.2021 02:17, Jakub Kicinski wrote:
> > On Mon, 29 Nov 2021 22:14:06 +0100 Heiner Kallweit wrote:  
> >> -	rtnl_lock();
> >> +	if (!rpm)
> >> +		rtnl_lock();  
> > 
> > Is there an ASSERT_RTNL() hidden in any of the below? Can we add one?
> > Unless we're 100% confident nobody will RPM resume without rtnl held..
> >   
> 
> Not sure whether igb uses RPM the same way as r8169. There the device
> is runtime-suspended (D3hot) w/o link. Once cable is plugged in the PHY
> triggers a PME, and PCI core runtime-resumes the device (MAC).
> In this case RTNL isn't held by the caller. Therefore I don't think
> it's safe to assume that all callers hold RTNL.

No, no - I meant to leave the locking in but add ASSERT_RTNL() to catch
if rpm == true && rtnl_held() == false.
