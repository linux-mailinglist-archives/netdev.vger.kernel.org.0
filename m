Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7407145F6A0
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 22:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbhKZVsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 16:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhKZVqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 16:46:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772F9C061574
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 13:42:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0E226238C
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 21:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A73C004E1;
        Fri, 26 Nov 2021 21:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637962976;
        bh=TEBkmfnT1xZExho7GiLyxPst+TPSR4KlPsUWGWtSIXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gfRQqp5acyC0Szp47V1DICWi9eY2jLuECYwPVohzWnzwbHE/EVQZHt9RUoafuDlSx
         ySP3O3rDPWHnYJZmUg6okZ/U4gCMg9d+9O53WwSQ69eVLxcKlXO+JOsumYBNUOq4KV
         3GkiUefaIyArV2TSaW5hf0fVU4C/NHgiARa9X4moHcS2ORvYifIsmaXy4A2BG5YjWR
         LTTuJgEZ1RxhDur1e/MRYskdC78rV+zBKU0rT0fTyy1js89/H4i9tljvoTCkV13x3P
         1YFYTcV+D7PA/Zk/ffAt1CA1SvR4O1yWpHfXW1YlT++GoR2hPWG9rRP6Eti+mfRrFB
         OdlUwcXjkkaTw==
Date:   Fri, 26 Nov 2021 13:42:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [net-next v2] net: ifb: support ethtools stats
Message-ID: <20211126134254.45bd82c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126032305.13571-1-xiangxia.m.yue@gmail.com>
References: <20211126032305.13571-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 11:23:05 +0800 xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> With this feature, we can use the ethtools to get tx/rx
> queues stats. This patch, introduce the ifb_update_q_stats
> helper to update the queues stats, and ifb_q_stats to simplify
> the codes. In future, we can add more metrics in ifb_q_stats.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

>  static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev);
>  static int ifb_open(struct net_device *dev);
>  static int ifb_close(struct net_device *dev);
>  
> +static inline void ifb_update_q_stats(struct ifb_q_stats *stats, int len)

Please remove the "inline" keywords, we prefer to leave the choice to
the compiler (plus it hides "unused function" warnings if the caller 
is ever removed).

> +static void ifb_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
> +{
> +	u8 *p = buf;
> +	int i, j;
> +
> +	switch(stringset) {
> +	case ETH_SS_STATS:
> +		for (i = 0; i < dev->real_num_rx_queues; i++)
> +			for (j = 0; j < IFB_Q_STATS_LEN; j++)
> +				ethtool_sprintf(&p, "rx_queue_%u_%.18s",
> +						i, ifb_q_stats_desc[j].desc);
> +
> +		for (i = 0; i < dev->real_num_tx_queues; i++)
> +			for (j = 0; j < IFB_Q_STATS_LEN; j++)
> +				ethtool_sprintf(&p, "tx_queue_%u_%.18s",
> +						i, ifb_q_stats_desc[j].desc);
> +
> +		break;
> +	}
> +}
> +
> +static int ifb_get_sset_count(struct net_device *dev, int sset)
> +{
> +	switch (sset) {
> +	case ETH_SS_STATS:
> +		return IFB_Q_STATS_LEN * (dev->real_num_rx_queues +
> +		       dev->real_num_tx_queues);

Needs to align under opening bracket, try checkpatch --strict.

> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static inline void ifb_fill_stats_data(u64 **data,
> +				       struct ifb_q_stats *q_stats)

another inline

The logic itself LGTM.
