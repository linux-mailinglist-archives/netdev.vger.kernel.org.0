Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F6B3734F0
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 08:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhEEG2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 02:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231676AbhEEG2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 02:28:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2DAD613BE;
        Wed,  5 May 2021 06:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620196031;
        bh=Txxq+eBCg3JRiW+hd+sUJCq0pdFsIewxluaOtxlCbFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=otluHUG23sop1P0hZOTr1eIwU5G+6YF1eexHXfyRwP4nxg3QA5o9zjR+G+wL12zQr
         E2aMaa4hho38u0QDr8dC7U7xNzkT08mL26gcAKqZin2oZHxKjLP6SyJj4I3lJlgwp6
         BPlpOQjJk+fGQN3Xg+LoY9j+nAki6fOoTRWkjiY2XD09E39wYuonAY+qHX2fuAjVvG
         FGW0yQ6h8grbyc73RUG9FG/eq9ygd5WnikeMpJayAIjnkJ2Rxc9F4qsRyHv5EZWukh
         fzPU9fwmJdPJ+tFS5XS5o/5fcW1LCcvMbiwKM4Prn65IGBVHyHOMhDb0PoL+1447CD
         a6qTm4uIeGk/Q==
Date:   Wed, 5 May 2021 09:27:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, drivers@pensando.io
Subject: Re: [PATCH v2 net] ionic: fix ptp support config breakage
Message-ID: <YJI6u+L7Irme/0SX@unreal>
References: <20210505000059.59760-1-snelson@pensando.io>
 <YJIt+cm6dAOQmU0g@unreal>
 <1f59a61f-b358-1248-15cf-d7ffd1446747@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f59a61f-b358-1248-15cf-d7ffd1446747@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 11:13:59PM -0700, Randy Dunlap wrote:
> On 5/4/21 10:32 PM, Leon Romanovsky wrote:
> > On Tue, May 04, 2021 at 05:00:59PM -0700, Shannon Nelson wrote:
> >> Driver link failed with undefined references in some
> >> kernel config variations.
> >>
> >> v2 - added Fixes tag
> > 
> > Changelogs should be below "---" line.
> > We don't need them in commit message history.
> > 
> >>
> >> Fixes: 61db421da31b ("ionic: link in the new hw timestamp code")
> >> Reported-by: kernel test robot <lkp@intel.com>
> >> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> >> ---
> >>  drivers/net/ethernet/pensando/ionic/Makefile    | 3 +--
> >>  drivers/net/ethernet/pensando/ionic/ionic_phc.c | 3 +++
> >>  2 files changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
> >> index 4e7642a2d25f..61c40169cb1f 100644
> >> --- a/drivers/net/ethernet/pensando/ionic/Makefile
> >> +++ b/drivers/net/ethernet/pensando/ionic/Makefile
> >> @@ -5,5 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
> >>  
> >>  ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
> >>  	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
> >> -	   ionic_txrx.o ionic_stats.o ionic_fw.o
> >> -ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
> >> +	   ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o
> >> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> >> index a87c87e86aef..30c78808c45a 100644
> >> --- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> >> +++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> >> @@ -1,6 +1,8 @@
> >>  // SPDX-License-Identifier: GPL-2.0
> >>  /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
> >>  
> >> +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
> > 
> > I'm not sure, but think that IS_ENABLED() is intended to be used inside
> > functions/macros as boolean expression.
> > 
> > For other places like this, "#if CONFIG_PTP_1588_CLOCK" is better fit.
> 
> s/#if/#ifdef/

Sure, thanks.
