Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA7725A26A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIBAqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbgIBAqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 20:46:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49FAE206EF;
        Wed,  2 Sep 2020 00:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599007560;
        bh=Xb2wiY56Zas07n/6A86D6vjbxYBDaOi9pEYZ3eVhCHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=biveKY7hJCNmZ89A0HyaKIOEY4+ZrkQ5Q/Kj1QhO8hjQQTapMn6PdkGs1t4DH46Z0
         5kKwoiQO2PxQ9NjYfSEOaoOf7k38L3DbUJaZnxZMQ3ZwJB6abtqfk5D7C0tYVf3aub
         Me35kt0kO98IKInm10yg96hgmaxn+g+elatVWxgo=
Date:   Tue, 1 Sep 2020 17:45:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2 5/9] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
Message-ID: <20200901174558.1745ad28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200901215149.2685117-6-awogbemila@google.com>
References: <20200901215149.2685117-1-awogbemila@google.com>
        <20200901215149.2685117-6-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Sep 2020 14:51:45 -0700 David Awogbemila wrote:

> @@ -297,6 +317,22 @@ static inline void gve_clear_probe_in_progress(struct gve_priv *priv)
>  	clear_bit(GVE_PRIV_FLAGS_PROBE_IN_PROGRESS, &priv->service_task_flags);
>  }
>  
> +static inline bool gve_get_do_report_stats(struct gve_priv *priv)
> +{
> +	return test_bit(GVE_PRIV_FLAGS_DO_REPORT_STATS,
> +			&priv->service_task_flags);
> +}
> +
> +static inline void gve_set_do_report_stats(struct gve_priv *priv)
> +{
> +	set_bit(GVE_PRIV_FLAGS_DO_REPORT_STATS, &priv->service_task_flags);
> +}
> +
> +static inline void gve_clear_do_report_stats(struct gve_priv *priv)
> +{
> +	clear_bit(GVE_PRIV_FLAGS_DO_REPORT_STATS, &priv->service_task_flags);
> +}
> +
>  static inline bool gve_get_admin_queue_ok(struct gve_priv *priv)
>  {
>  	return test_bit(GVE_PRIV_FLAGS_ADMIN_QUEUE_OK, &priv->state_flags);
> @@ -357,6 +393,21 @@ static inline void gve_clear_napi_enabled(struct gve_priv *priv)
>  	clear_bit(GVE_PRIV_FLAGS_NAPI_ENABLED, &priv->state_flags);
>  }
>  
> +static inline bool gve_get_report_stats(struct gve_priv *priv)
> +{
> +	return test_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
> +}
> +
> +static inline void gve_set_report_stats(struct gve_priv *priv)

Please remove the unused helpers.

> +{
> +	set_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
> +}
> +
> +static inline void gve_clear_report_stats(struct gve_priv *priv)
> +{
> +	clear_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
> +}

> @@ -353,6 +377,54 @@ static int gve_set_tunable(struct net_device *netdev,
>  	}
>  }
>  
> +static u32 gve_get_priv_flags(struct net_device *netdev)
> +{
> +	struct gve_priv *priv = netdev_priv(netdev);
> +	u32 i, ret_flags = 0;
> +
> +	for (i = 0; i < GVE_PRIV_FLAGS_STR_LEN; i++) {

Please remove this pointless loop.

> +		if (priv->ethtool_flags & BIT(i))
> +			ret_flags |= BIT(i);
> +	}
> +	return ret_flags;
> +}
> +
> +static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
> +{
> +	struct gve_priv *priv = netdev_priv(netdev);
> +	u64 ori_flags, new_flags;
> +	u32 i;
> +
> +	ori_flags = READ_ONCE(priv->ethtool_flags);
> +	new_flags = ori_flags;
> +
> +	for (i = 0; i < GVE_PRIV_FLAGS_STR_LEN; i++) {

Ditto.

> +		if (flags & BIT(i))
> +			new_flags |= BIT(i);
> +		else
> +			new_flags &= ~(BIT(i));
> +		priv->ethtool_flags = new_flags;
> +		/* set report-stats */
> +		if (strcmp(gve_gstrings_priv_flags[i], "report-stats") == 0) {
> +			/* update the stats when user turns report-stats on */
> +			if (flags & BIT(i))
> +				gve_handle_report_stats(priv);
> +			/* zero off gve stats when report-stats turned off */
> +			if (!(flags & BIT(i)) && (ori_flags & BIT(i))) {
> +				int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
> +					priv->tx_cfg.num_queues;
> +				int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
> +					priv->rx_cfg.num_queues;

new line here

> +				memset(priv->stats_report->stats, 0,
> +				       (tx_stats_num + rx_stats_num) *
> +				       sizeof(struct stats));
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}


> +static int gve_alloc_stats_report(struct gve_priv *priv)
> +{
> +	int tx_stats_num, rx_stats_num;
> +
> +	tx_stats_num = (GVE_TX_STATS_REPORT_NUM) *
> +		       priv->tx_cfg.num_queues;
> +	rx_stats_num = (GVE_RX_STATS_REPORT_NUM) *
> +		       priv->rx_cfg.num_queues;
> +	priv->stats_report_len = sizeof(struct gve_stats_report) +
> +				 (tx_stats_num + rx_stats_num) *
> +				 sizeof(struct stats);
> +	priv->stats_report =
> +		dma_alloc_coherent(&priv->pdev->dev, priv->stats_report_len,
> +				   &priv->stats_report_bus, GFP_KERNEL);
> +	if (!priv->stats_report)
> +		return -ENOMEM;
> +	/* Set up timer for periodic task */
> +	timer_setup(&priv->service_timer, gve_service_timer, 0);
> +	priv->service_timer_period = GVE_SERVICE_TIMER_PERIOD;
> +	/* Start the service task timer */
> +	mod_timer(&priv->service_timer,
> +		  round_jiffies(jiffies +
> +		  msecs_to_jiffies(priv->service_timer_period)));
> +	return 0;
> +}

> @@ -1173,6 +1315,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	priv->db_bar2 = db_bar;
>  	priv->service_task_flags = 0x0;
>  	priv->state_flags = 0x0;
> +	priv->ethtool_flags = 0x0;
>  	priv->dma_mask = dma_mask;

You allocate the memory and start the timer even tho the priv flag
defaults to off?
