Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFA835AD7E
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 15:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbhDJNQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 09:16:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:64539 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234262AbhDJNQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Apr 2021 09:16:30 -0400
IronPort-SDR: ygiHZWxWLYCp4PxYRUkYNwnWhQwvO1KlKuQlqXG1SXwYe6wVgZDCmIlEv1+qja4ombxy/HZcM/
 G1Xz4zg/xkng==
X-IronPort-AV: E=McAfee;i="6000,8403,9950"; a="173409214"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="173409214"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 06:16:16 -0700
IronPort-SDR: K9zar4f0vNOGus1eGQXEBDsrvlbQ2NnorowaLzI/5TOGNIA6PF243l/U4Mkiep86Z7go7fx+s8
 60kNxwsxmwgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="388085254"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga007.fm.intel.com with ESMTP; 10 Apr 2021 06:16:15 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 862245808EA;
        Sat, 10 Apr 2021 06:16:12 -0700 (PDT)
Date:   Sat, 10 Apr 2021 21:16:09 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: stmmac: Add support for external
 trigger timestamping
Message-ID: <20210410131609.GA12931@linux.intel.com>
References: <20210407170442.1641-1-vee.khee.wong@linux.intel.com>
 <20210409175004.2fceacdd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409175004.2fceacdd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 05:50:04PM -0700, Jakub Kicinski wrote:
> Other than the minor nit below LGTM. Let's give Richard one more day.
> 
> On Thu,  8 Apr 2021 01:04:42 +0800 Wong Vee Khee wrote:
> > +static void timestamp_interrupt(struct stmmac_priv *priv)
> > +{
> > +	struct ptp_clock_event event;
> > +	unsigned long flags;
> > +	u32 num_snapshot;
> > +	u32 ts_status;
> > +	u32 tsync_int;
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
> > +
> > +	if (priv->plat->ext_snapshot_en) {
> 
> Are you intending to add more code after this if? Otherwise you could
> flip the condition and return early instead of having the extra level
> of indentation.
>

Thanks fo the suggestion.
There's no plan to add more code after this as per STMMAC features that
required this interrupt. I will flip the condition.

> > +		num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
> > +			       GMAC_TIMESTAMP_ATSNS_SHIFT;
> > +
> > +		for (i = 0; i < num_snapshot; i++) {
> > +			spin_lock_irqsave(&priv->ptp_lock, flags);
> > +			get_ptptime(priv->ptpaddr, &ptp_time);
> > +			spin_unlock_irqrestore(&priv->ptp_lock, flags);
> > +			event.type = PTP_CLOCK_EXTTS;
> > +			event.index = 0;
> > +			event.timestamp = ptp_time;
> > +			ptp_clock_event(priv->ptp_clock, &event);
> > +		}
> > +	}
> > +}
> 
> Not really related to this patch but how does stmmac set IRQF_SHARED
> and yet not track if it indeed generated the interrupt? Isn't that
> against the rules?
>

Good point! Thanks for pointing that out. I looked at how STMMAC
interrupt handlers are coded, and indeed there are no tracking. Will
work on that and send as a seperate patch in near future.


