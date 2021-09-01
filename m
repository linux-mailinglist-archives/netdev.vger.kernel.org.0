Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1513FD0F4
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241652AbhIAB7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231567AbhIAB7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 21:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1223D61057;
        Wed,  1 Sep 2021 01:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630461505;
        bh=TRDfaY62oSVS+E5EgOaLRv1XHlM4Egv+xhPBm6XVKIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mNWpQHNO8Kic/1zNCOl2iAcZPzO/KLVdzSXBZNXr3YL2Yor/uSID4/XI9uiutL9ws
         9QOsou5HaFGu323xq5qZYzTZ+NXimUMcZLvkKF3ndWqqmPrEIVW3kgT4nBODhRzl4x
         +fGnmDMxHZsnn7+TeoL37KuYpJRRQvLmsueBNzAkGHC1mVjsTyzvJXnD9CTraxGB5v
         BDVKS9NEHp1edBknIOVfgIAy/7AcVYri6hnvWj9VOOwWAnVny4jWcPkzoKbc8I+/08
         x8kN6ottCjsfHe1arGtHk0buxDF4X743XiEw+Qf6rSUaXtxpMgPfxk+zvyInL1MyeU
         QS8bpoDVcA8Uw==
Date:   Tue, 31 Aug 2021 18:58:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        bsd@fb.com
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210831185824.5021e847@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210831161927.GA10747@hoboy.vegasvil.org>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
        <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210831161927.GA10747@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 09:19:27 -0700 Richard Cochran wrote:
> As you said later on in this thread, any API we merge now will have to
> last.  That is why I'm being so picky here.  We want new APIs to cover
> current HW _and_ be reasonable for the future.
> 
> I don't see a DPLL as either a PTP Hardware Clock or a Network
> Device.  It is a PLL.
> 
> The kernel can and should have a way to represent the relationship
> between these three different kind of IP block.  We already have a
> way to get from PHC to netdev interface.

Makes sense to me. I was wondering how to split things at high level
into the areas you mentioned, but TBH the part I'm struggling with is
the delineation of what falls under PTP. PLL by itself seems like an
awfully small unit to create a subsystem for, and PTP already has aux
stuff like PIN control. Then there's the whole bunch of stuff that Jonathan
is adding via driver specific sysfs interfaces [1]. I was hoping the
"new API" would cover his need but PLL would be a tiny part of it.

IOW after looking at the code I'm not so sure how to reasonably divide
things.

[1]
https://lore.kernel.org/netdev/20210830235236.309993-1-jonathan.lemon@gmail.com/
