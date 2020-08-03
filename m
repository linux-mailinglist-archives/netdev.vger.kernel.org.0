Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DA623B01E
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgHCWSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbgHCWSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 18:18:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1A7020775;
        Mon,  3 Aug 2020 22:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596493100;
        bh=yAVe4Kbbd20BRvHF/s6K+gBM74VJRriXBoyIAu9x8HI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sio5d3kvpN28s09vDWAQ2+LXpSoXf0TUqZ82ujm/P3An1Wa4nfz6iRfM7U/rgcEjs
         XRp7NUBHdSmxMKG75hHbyNek9XsGY/Nmxlr2G2ZoAszZ7sd4FpEMNgEHQY/JE3wSMQ
         DMw6zEqYcmG7GmjK40OnJNQTmS5I721jR1Mrij2w=
Date:   Mon, 3 Aug 2020 15:18:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V1 net-next 1/3] net: ena: ethtool: Add new device
 statistics
Message-ID: <20200803151818.5a2e5616@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200801142130.6537-2-sameehj@amazon.com>
References: <20200801142130.6537-1-sameehj@amazon.com>
        <20200801142130.6537-2-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Aug 2020 14:21:28 +0000 sameehj@amazon.com wrote:
> +	if (eni_stats_needed) {
> +		ena_update_hw_stats(adapter);
> +		for (i = 0; i < ENA_STATS_ARRAY_ENI(adapter); i++) {
> +			ena_stats = &ena_stats_eni_strings[i];
> +
> +			ptr = (u64 *)((uintptr_t)&adapter->eni_stats +
> +				(uintptr_t)ena_stats->stat_offset);

In the kernel unsigned long is the type for doing maths on pointers.

> +			ena_safe_update_stat(ptr, data++, &adapter->syncp);
> +		}
> +	}
> +
>  	ena_queue_stats(adapter, &data);
>  	ena_dev_admin_queue_stats(adapter, &data);
>  }
>  
> +static void ena_get_ethtool_stats(struct net_device *netdev,
> +				  struct ethtool_stats *stats,
> +				  u64 *data)
> +{
> +	struct ena_adapter *adapter = netdev_priv(netdev);
> +
> +	ena_get_stats(adapter, data, adapter->eni_stats_supported);
> +}

Why the indirections? You always pass adapter->eni_stats_supported as a
parameter, why not just use it directly?

Other than the two nits, the set LGTM.
