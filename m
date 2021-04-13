Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A97F35D6CA
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 07:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239351AbhDMFIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 01:08:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:52778 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhDMFIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 01:08:09 -0400
IronPort-SDR: 0LvSAp69fkk+As5PkAI/F08JJGyQ6i0HkGVW1PmbOaKj6G/lISDgkuM5LglynueKNQBhTMGtrb
 1vSJQk4HwYFA==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="192207938"
X-IronPort-AV: E=Sophos;i="5.82,218,1613462400"; 
   d="scan'208";a="192207938"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 22:07:49 -0700
IronPort-SDR: 9tT+16Lue95sfJbPlF2LFbVo9BriNYcjTt3//K5Rd/uajIgAYTMMvI1Lz3ZNUEKBNbjsFodvWt
 A/UOHBcnheDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,218,1613462400"; 
   d="scan'208";a="383181445"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 12 Apr 2021 22:07:49 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 84E81580782;
        Mon, 12 Apr 2021 22:07:46 -0700 (PDT)
Date:   Tue, 13 Apr 2021 13:07:43 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
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
Subject: Re: [PATCH net-next v3 1/1] net: stmmac: Add support for external
 trigger timestamping
Message-ID: <20210413050743.GA10274@linux.intel.com>
References: <20210411024028.14586-1-vee.khee.wong@linux.intel.com>
 <20210411151055.GA5719@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411151055.GA5719@hoboy.vegasvil.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 08:10:55AM -0700, Richard Cochran wrote:
> On Sun, Apr 11, 2021 at 10:40:28AM +0800, Wong Vee Khee wrote:
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > index 60566598d644..60e17fd24aba 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > @@ -296,6 +296,13 @@ static int intel_crosststamp(ktime_t *device,
> >  
> >  	intel_priv = priv->plat->bsp_priv;
> >  
> > +	/* Both internal crosstimestamping and external triggered event
> > +	 * timestamping cannot be run concurrently.
> > +	 */
> > +	if (priv->plat->ext_snapshot_en)
> > +		return -EBUSY;
> > +
> > +	mutex_lock(&priv->aux_ts_lock);
> 
> Lock, then ...
> 
> >  	/* Enable Internal snapshot trigger */
> >  	acr_value = readl(ptpaddr + PTP_ACR);
> >  	acr_value &= ~PTP_ACR_MASK;
> > @@ -321,6 +328,7 @@ static int intel_crosststamp(ktime_t *device,
> >  	acr_value = readl(ptpaddr + PTP_ACR);
> >  	acr_value |= PTP_ACR_ATSFC;
> >  	writel(acr_value, ptpaddr + PTP_ACR);
> > +	mutex_unlock(&priv->aux_ts_lock);
> 
> unlock, then ...
>   
> >  	/* Trigger Internal snapshot signal
> >  	 * Create a rising edge by just toggle the GPO1 to low
> > @@ -355,6 +363,8 @@ static int intel_crosststamp(ktime_t *device,
> >  		*system = convert_art_to_tsc(art_time);
> >  	}
> >  
> > +	/* Release the mutex */
> > +	mutex_unlock(&priv->aux_ts_lock);
> 
> unlock again?  Huh?
>

Nice catch. Fix in v4.
 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > index c49debb62b05..abadcd8cdc41 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > @@ -239,6 +239,9 @@ struct stmmac_priv {
> >  	int use_riwt;
> >  	int irq_wake;
> >  	spinlock_t ptp_lock;
> > +	/* Mutex lock for Auxiliary Snapshots */
> > +	struct mutex aux_ts_lock;
> 
> In the comment, please be specific about which data are protected.
> For example:
> 
> 	/* Protects auxiliary snapshot registers from concurrent access. */
> 
> > @@ -163,6 +166,43 @@ static void get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)
> >  	*ptp_time = ns;
> >  }
> >  
> > +static void timestamp_interrupt(struct stmmac_priv *priv)
> > +{
> > +	struct ptp_clock_event event;
> > +	unsigned long flags;
> > +	u32 num_snapshot;
> > +	u32 ts_status;
> > +	u32 tsync_int;
> 
> Please group same types together (u32) in a one-line list.
> 
> > +	u64 ptp_time;
> > +	int i;
> > +
> > +	tsync_int = readl(priv->ioaddr + GMAC_INT_STATUS) & GMAC_INT_TSIE;
> > +
> > +	if (!tsync_int)
> > +		return;
> > +
> > +	/* Read timestamp status to clear interrupt from either external
> > +	 * timestamp or start/end of PPS.
> > +	 */
> > +	ts_status = readl(priv->ioaddr + GMAC_TIMESTAMP_STATUS);
> 
> Reading this register has a side effect of clearing status?  If so,
> doesn't it need protection against concurrent access?
> 
> The function, intel_crosststamp() also reads this bit.
>

The following check is introduced in intel_crosststamp() to avoid this:

/* Both internal crosstimestamping and external triggered event
 * timestamping cannot be run concurrently.
 */
 if (priv->plat->ext_snapshot_en)
	return -EBUSY;

 
> > +	if (!priv->plat->ext_snapshot_en)
> > +		return;
> 
> Doesn't this test come too late?  Setting ts_status just cleared the
> bit used by the other code path.
>

As per Synopsys's design, all bits except Bits[27:25] gets cleared when
this register is read.

> > +	num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
> > +		       GMAC_TIMESTAMP_ATSNS_SHIFT;
> > +
> > +	for (i = 0; i < num_snapshot; i++) {
> > +		spin_lock_irqsave(&priv->ptp_lock, flags);
> > +		get_ptptime(priv->ptpaddr, &ptp_time);
> > +		spin_unlock_irqrestore(&priv->ptp_lock, flags);
> > +		event.type = PTP_CLOCK_EXTTS;
> > +		event.index = 0;
> > +		event.timestamp = ptp_time;
> > +		ptp_clock_event(priv->ptp_clock, &event);
> > +	}
> > +}
> > +
> 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> > index b164ae22e35f..d668c33a0746 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> > @@ -135,9 +135,13 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
> >  {
> >  	struct stmmac_priv *priv =
> >  	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
> > +	void __iomem *ptpaddr = priv->ptpaddr;
> > +	void __iomem *ioaddr = priv->hw->pcsr;
> >  	struct stmmac_pps_cfg *cfg;
> >  	int ret = -EOPNOTSUPP;
> >  	unsigned long flags;
> > +	u32 intr_value;
> > +	u32 acr_value;
> 
> Please group same types together.
>

Fix in v4.
 
> Thanks,
> Richard
