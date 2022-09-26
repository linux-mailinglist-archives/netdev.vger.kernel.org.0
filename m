Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783485EB06F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiIZSpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiIZSpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:45:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1BC101E3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F18F5B80D6D
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69374C433D7;
        Mon, 26 Sep 2022 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664217889;
        bh=1igbHFie/sIO55k1sjmp5kr6sxgIhbPrO/wCgz50ec4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O20TzWv4iTJxf94uQDFHjFnJgfxpg74EK13cA5KkqENTcuE3XTXfcHGMYgWsMKyDZ
         C5XHcZSdSLXQgi0CmElQwVGK2ghT7gzeiCC6sGfEuaEuCKRrPz/QoUc7GgPaGW2qJ8
         Eg7O+bltA5xTfXbkAPIeIrjTWYjHfaPxVDFLDHEqW16OU8scPEfDlJFbBnR4ROmf/h
         Lpkhm/Gx5Fwurt74pFm1wkgt5fs2CVNY9Xk2iWZB10OGurky5NtlG57FNMiiLluT/V
         wVQA9LYJGj1CQy2AtGTeptq8hkY9FO8Flu1Uf91qaJJSqaRfzGq4OuF6QLM0tUxZdP
         vOMTfFM62NhKw==
Date:   Mon, 26 Sep 2022 11:44:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com, mmc@linux.ibm.com
Subject: Re: [PATCH net-next 3/3] ibmveth: Ethtool set queue support
Message-ID: <20220926114448.10434fba@kernel.org>
In-Reply-To: <20220921215056.113516-3-nnac123@linux.ibm.com>
References: <20220921215056.113516-1-nnac123@linux.ibm.com>
        <20220921215056.113516-3-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 16:50:56 -0500 Nick Child wrote:
> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index 7abd67c2336e..2c5ded4f3b67 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -141,6 +141,13 @@ static inline int ibmveth_rxq_csum_good(struct ibmveth_adapter *adapter)
>  	return ibmveth_rxq_flags(adapter) & IBMVETH_RXQ_CSUM_GOOD;
>  }
>  
> +static unsigned int ibmveth_real_max_tx_queues(void)
> +{
> +	unsigned int n_cpu =  num_online_cpus();

nit: double space after =

> +	return n_cpu > IBMVETH_MAX_QUEUES ? IBMVETH_MAX_QUEUES : n_cpu;

min()

> +static void ibmveth_get_channels(struct net_device *netdev,
> +				 struct ethtool_channels *channels)
> +{
> +	channels->max_tx = ibmveth_real_max_tx_queues();
> +	channels->tx_count = netdev->real_num_tx_queues;
> +
> +	channels->max_rx = netdev->real_num_rx_queues;
> +	channels->rx_count = netdev->real_num_rx_queues;

Which is 1, right?

> +	channels->max_other = 0;
> +	channels->other_count = 0;
> +	channels->max_combined = 0;
> +	channels->combined_count = 0;

AFAIR the core zeros the input, no need to explicitly set to 0 here.

> +static int ibmveth_set_channels(struct net_device *netdev,
> +				struct ethtool_channels *channels)
> +{
> +	struct ibmveth_adapter *adapter = netdev_priv(netdev);
> +	int rc, rc2, i;
> +	unsigned int fallback_num, goal;
> +
> +	/* Higher levels will catch basic input errors */
> +	if (channels->tx_count > ibmveth_real_max_tx_queues())
> +		return -EINVAL;

AFAIR core validates this.

> +	if (channels->tx_count == netdev->real_num_tx_queues)
> +		return 0;

And this.

> +	/* We have IBMVETH_MAX_QUEUES netdev_queue's allocated
> +	 * but we may need to alloc/free the ltb's.
> +	 */
> +	netif_tx_stop_all_queues(netdev);

What if the device is not UP?

> +	fallback_num = netdev->real_num_tx_queues;

fallback is not great naming. Why not old or prev?

> +	goal = channels->tx_count;
> +
> +setup_tx_queues:
> +	/* Allocate any queue that we need */
> +	for (i = 0; i < goal; i++) {
> +		if (adapter->tx_ltb_ptr[i])
> +			continue;
> +
> +		rc = ibmveth_allocate_tx_ltb(adapter, i);
> +		if (!rc)
> +			continue;

I don't understand why you start from zero here. The first real_num_tx
should already be allocated. If you assume this it removes the need for
the error handling below. Either the number of queues is increased and
on failure we go back to the old one, or it's decreased which can't
fail.

> +		if (goal == fallback_num)
> +			goto full_restart;
> +
> +		netdev_err(netdev, "Failed to allocate more tx queues, returning to %d queues\n",
> +			   fallback_num);
> +		goal = fallback_num;
> +		goto setup_tx_queues;
> +	}
> +	/* Free any that are no longer needed */
> +	for (; i < fallback_num; i++) {
> +		if (adapter->tx_ltb_ptr[i])
> +			ibmveth_free_tx_ltb(adapter, i);
> +	}
> +
> +	rc = netif_set_real_num_tx_queues(netdev, goal);

You can assume this doesn't fail on decrease.

> +	if (rc) {
> +		if (goal == fallback_num)
> +			goto full_restart;
> +		netdev_err(netdev, "Failed to set real tx queues, returning to %d queues\n",
> +			   fallback_num);
> +		goal = fallback_num;
> +		goto setup_tx_queues;
> +	}

>  #define IBMVETH_MAX_BUF_SIZE (1024 * 128)
>  #define IBMVETH_MAX_TX_BUF_SIZE (1024 * 64)
> -#define IBMVETH_MAX_QUEUES 8
> +#define IBMVETH_MAX_QUEUES 16

Why does the same series introduce the max as 8 and then bump to 16?
Why can't patch 1 just use 16 from the start?
