Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC9E35726E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 18:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbhDGQyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 12:54:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:48896 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235015AbhDGQyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 12:54:23 -0400
IronPort-SDR: tS+sdjdNZ+57/MMjaKtrW4uarkxNth53tettdMSyErGOAtvuTC96jkMHJRtG+uA7hRbna6St1h
 Up/H1ORT3QaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="254689869"
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="254689869"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 09:54:13 -0700
IronPort-SDR: 2a8Kf6WaNd/0kxyeCZqP4ukkq0OmJunrLAZ3NAgBJ+INoMBdilDMdz2NV0XM/GzRMyIYk3jRsG
 wXeqclFq4xGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="530272883"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 07 Apr 2021 09:54:13 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 7BE2E5805A1;
        Wed,  7 Apr 2021 09:54:10 -0700 (PDT)
Date:   Thu, 8 Apr 2021 00:54:07 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: stmmac: Add support for external
 trigger timestamping
Message-ID: <20210407165407.GA27820@linux.intel.com>
References: <20210407141537.2129-1-vee.khee.wong@linux.intel.com>
 <YG2/1fbNNIsbafZp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG2/1fbNNIsbafZp@lunn.ch>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 04:21:09PM +0200, Andrew Lunn wrote:
> On Wed, Apr 07, 2021 at 10:15:37PM +0800, Wong Vee Khee wrote:
> > From: Tan Tee Min <tee.min.tan@intel.com>
> > 
> > The Synopsis MAC controller supports auxiliary snapshot feature that
> > allows user to store a snapshot of the system time based on an external
> > event.
> > 
> > This patch add supports to the above mentioned feature. Users will be
> > able to triggered capturing the time snapshot from user-space using
> > application such as testptp or any other applications that uses the
> > PTP_EXTTS_REQUEST ioctl request.
> 
> You forgot to Cc: the PTP maintainer.
>

Will Cc Richard Cochran on v2.
 
> > @@ -159,6 +163,37 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
> >  					     priv->systime_flags);
> >  		spin_unlock_irqrestore(&priv->ptp_lock, flags);
> >  		break;
> > +	case PTP_CLK_REQ_EXTTS:
> > +		priv->plat->ext_snapshot_en = on;
> > +		mutex_lock(&priv->aux_ts_lock);
> > +		acr_value = readl(ptpaddr + PTP_ACR);
> > +		acr_value &= ~PTP_ACR_MASK;
> > +		if (on) {
> > +			/* Enable External snapshot trigger */
> > +			acr_value |= priv->plat->ext_snapshot_num;
> > +			acr_value |= PTP_ACR_ATSFC;
> > +			pr_info("Auxiliary Snapshot %d enabled.\n",
> > +				priv->plat->ext_snapshot_num >>
> > +				PTP_ACR_ATSEN_SHIFT);
> 
> dev_dbg()?
> 
> > +			/* Enable Timestamp Interrupt */
> > +			intr_value = readl(ioaddr + GMAC_INT_EN);
> > +			intr_value |= GMAC_INT_TSIE;
> > +			writel(intr_value, ioaddr + GMAC_INT_EN);
> > +
> > +		} else {
> > +			pr_info("Auxiliary Snapshot %d disabled.\n",
> > +				priv->plat->ext_snapshot_num >>
> > +				PTP_ACR_ATSEN_SHIFT);
> 
> dev_dbg()?
> 
> Do you really want to spam the kernel log with this?
>

Thanks for the review.
I will switch this to netdev_dbg().
 
