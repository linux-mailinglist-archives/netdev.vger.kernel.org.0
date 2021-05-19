Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EA738970D
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhESTw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232256AbhESTw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 15:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D16B600D1;
        Wed, 19 May 2021 19:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621453868;
        bh=a2/7cLCct144jQogd07ksgL3fT8xb+rKaGyWceqc11o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=udmiB4Bq8ux14aT9m77ofNb+D6XCvzFjWmm9u45yzONNvs/O0TmyuPFYecaDHdSlh
         AgJl1q9208ChTGFwFP9nhZA5WJKySjCxbiiO4dkDw0P7/EjpsdRMP4sGl1LGIjiqhA
         dLGA4dtNT4PoSmcxg1PgB92nvpwe3FVI7ylHwM/El01OpXwHDDYCiGeaD8YqZ6p6r8
         Cn4jhIKTys+498+aUQm/k/vUkmQWjGVEos9cW2Ryb7grCz+YSyo8dXueQ3SFfXmemp
         rJmjeYj078jHT/xFRKmL+dloP2e41vc+O30UiTPvCYhNIVeSbOuteL2XqCDvV73YuO
         QmH2dQoNAKMAQ==
Date:   Wed, 19 May 2021 12:51:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     saeedm@nvidia.com, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mlx5: count all link events
Message-ID: <20210519125107.578f9c7d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <155D8D8E-C0FE-4EF9-AD7F-B496A8279F92@linux.vnet.ibm.com>
References: <20210519171825.600110-1-kuba@kernel.org>
        <155D8D8E-C0FE-4EF9-AD7F-B496A8279F92@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 14:34:34 -0500 Lijun Pan wrote:
> Is it possible to integrate netif_carrier_event into netif_carrier_on? like,
> 
> 
> void netif_carrier_on(struct net_device *dev)
> {
> 	if (test_and_clear_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
> 		if (dev->reg_state == NETREG_UNINITIALIZED)
> 			return;
> 		atomic_inc(&dev->carrier_up_count);
> 		linkwatch_fire_event(dev);
> 		if (netif_running(dev))
> 			__netdev_watchdog_up(dev);
> 	} else {
> 		if (dev->reg_state == NETREG_UNINITIALIZED)
> 			return;
> 		atomic_inc(&dev->carrier_down_count);
> 		atomic_inc(&dev->carrier_up_count);
> 	}
> }
> EXPORT_SYMBOL(netif_carrier_on);

Ah, I meant to address that in the commit message, thanks for bringing
this up. I suspect drivers may depend on the current behavior of
netif_carrier_on()/off() being idempotent. We have no real reason for
removing that assumption.

I assumed netif_carrier_event() would be used specifically in places
driver is actually servicing a link event from the device, and
therefore is relatively certain that _something_ has happened.
