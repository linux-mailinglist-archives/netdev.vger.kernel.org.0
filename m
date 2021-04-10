Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7696135A9B5
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 02:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhDJAuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 20:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235215AbhDJAuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 20:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50E4E610CB;
        Sat, 10 Apr 2021 00:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618015805;
        bh=hEcu5UgpDUaV8nxve49onnz1+/sBjbrN8vvQuZFAQQo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VwxM0DtA3/QOrvAmrWtoFBChFFBgW5WOtg6u8lYj3oVmSxXwfFqg5cyBj1utXuM3o
         620Jim1FGRHFWkDb5NyQs8fQ3iVskLax5Hp7nnkDJLyekfk/GPxyOHf8RFjIy9ySf8
         aDTq/PiKZz7ghvlW9EoJoAqsILG0sEkXIJjNssJsRC3bIREV5nYF/gMdmXJKx35RcQ
         W/UbREFfBcM9JIRbC5cFvfODtpjMygtdMNhf3rmEzUh/MXfYevvyD/S7o/RBhjoegL
         /UbLOVpK3dMui5FAFwTjWKsAgxoxPiG6vNPGtxrUPTRhW3sR86Ikdp+kn5yl+TcU94
         jMAsmq6N+JUjw==
Date:   Fri, 9 Apr 2021 17:50:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
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
Message-ID: <20210409175004.2fceacdd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210407170442.1641-1-vee.khee.wong@linux.intel.com>
References: <20210407170442.1641-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Other than the minor nit below LGTM. Let's give Richard one more day.

On Thu,  8 Apr 2021 01:04:42 +0800 Wong Vee Khee wrote:
> +static void timestamp_interrupt(struct stmmac_priv *priv)
> +{
> +	struct ptp_clock_event event;
> +	unsigned long flags;
> +	u32 num_snapshot;
> +	u32 ts_status;
> +	u32 tsync_int;
> +	u64 ptp_time;
> +	int i;
> +
> +	tsync_int = readl(priv->ioaddr + GMAC_INT_STATUS) & GMAC_INT_TSIE;
> +
> +	if (!tsync_int)
> +		return;
> +
> +	/* Read timestamp status to clear interrupt from either external
> +	 * timestamp or start/end of PPS.
> +	 */
> +	ts_status = readl(priv->ioaddr + GMAC_TIMESTAMP_STATUS);
> +
> +	if (priv->plat->ext_snapshot_en) {

Are you intending to add more code after this if? Otherwise you could
flip the condition and return early instead of having the extra level
of indentation.

> +		num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
> +			       GMAC_TIMESTAMP_ATSNS_SHIFT;
> +
> +		for (i = 0; i < num_snapshot; i++) {
> +			spin_lock_irqsave(&priv->ptp_lock, flags);
> +			get_ptptime(priv->ptpaddr, &ptp_time);
> +			spin_unlock_irqrestore(&priv->ptp_lock, flags);
> +			event.type = PTP_CLOCK_EXTTS;
> +			event.index = 0;
> +			event.timestamp = ptp_time;
> +			ptp_clock_event(priv->ptp_clock, &event);
> +		}
> +	}
> +}

Not really related to this patch but how does stmmac set IRQF_SHARED
and yet not track if it indeed generated the interrupt? Isn't that
against the rules?

