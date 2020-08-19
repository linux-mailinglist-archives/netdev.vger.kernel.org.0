Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E394A249353
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 05:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgHSDNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 23:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727793AbgHSDNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 23:13:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 707852065F;
        Wed, 19 Aug 2020 03:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597806832;
        bh=6/kg0lAPZtBohkbjIHOUSCLWkwG9hOLDvtGgGljWvEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B5BvjPqEV5InWMZGo1QSvS+EEY3uCAeF2bA5+jzxVntDF670CJwsSz1eNiUAJEQwI
         gzrZkhI1048//C+dv1P85xX5PMBBfz3snEw9C/ygLtF0AYrLp4fqcf0KRrv5vaJd/k
         bQq9oNsFTqHNZK5Kfa5ByfS1F+jf2pYKZ6YE7b+g=
Date:   Tue, 18 Aug 2020 20:13:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next 05/18] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
Message-ID: <20200818201350.58024c28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818194417.2003932-6-awogbemila@google.com>
References: <20200818194417.2003932-1-awogbemila@google.com>
        <20200818194417.2003932-6-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 12:44:04 -0700 David Awogbemila wrote:
> From: Kuo Zhao <kuozhao@google.com>
> 
> Changes:
> - Add a new flag in service_task_flags. Check both this flag and
> ethtool flag when handle report stats. Update the stats when user turns
> ethtool flag on.
> 
> - In order to expose the NIC stats to the guest even when the ethtool flag
> is off, share the address and length of report at setup. When the
> ethtool flag turned off, zero off the gve stats instead of detaching the
> report. Only detach the report in free_stats_report.
> 
> - Adds the NIC stats to ethtool stats. These stats are always
> exposed to guest no matter the report stats flag is turned
> on or off.
> 
> - Update gve stats once every 20 seconds.
> 
> - Add a field for the interval of updating stats report to the AQ
> command. It will be exposed to USPS so that USPS can use the same
> interval to update its stats in the report.
> 
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Kuo Zhao <kuozhao@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>

This patch is quite hard to parse, please work on improving its
readability. Perhaps start by splitting changes to the stats from
hypervisor from the stats to hypervisor.

> +enum gve_stat_names {
> +	// stats from gve
> +	TX_WAKE_CNT			= 1,
> +	TX_STOP_CNT			= 2,
> +	TX_FRAMES_SENT			= 3,
> +	TX_BYTES_SENT			= 4,
> +	TX_LAST_COMPLETION_PROCESSED	= 5,
> +	RX_NEXT_EXPECTED_SEQUENCE	= 6,
> +	RX_BUFFERS_POSTED		= 7,

Just out of curiosity - what's the use for the stats reported by VM to
the hypervisor? 

> +	// stats from NIC
> +	RX_QUEUE_DROP_CNT		= 65,
> +	RX_NO_BUFFERS_POSTED		= 66,
> +	RX_DROPS_PACKET_OVER_MRU	= 67,
> +	RX_DROPS_INVALID_CHECKSUM	= 68,

Most of these look like a perfect match for members of struct
rtnl_link_stats64. Please use the standard stats to report the errors,
wherever possible.

> +};
> +
>  union gve_adminq_command {
>  	struct {
>  		__be32 opcode;

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
> +				memset(priv->stats_report->stats, 0,
> +				       (tx_stats_num + rx_stats_num) *
> +				       sizeof(struct stats));

I don't quite get why you need the knob to disable some statistics.
Please remove or explain this in the cover letter. Looks unnecessary.

> +			}
> +		}
> +	}
> +
> +	return 0;
> +}

> @@ -880,6 +953,10 @@ static void gve_handle_status(struct gve_priv *priv, u32 status)
>  		dev_info(&priv->pdev->dev, "Device requested reset.\n");
>  		gve_set_do_reset(priv);
>  	}
> +	if (GVE_DEVICE_STATUS_REPORT_STATS_MASK & status) {
> +		dev_info(&priv->pdev->dev, "Device report stats on.\n");

How often is this printed?

> +		gve_set_do_report_stats(priv);
> +	}
>  }
