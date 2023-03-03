Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0DA6AA5D1
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjCCXut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjCCXuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:50:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3412C65044
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 15:50:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 521A3B819A2
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 23:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36237C433D2;
        Fri,  3 Mar 2023 23:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677887441;
        bh=QZppnOSTvtOfLfZNHJV3YsvJIih/rys7Z6Zjlt9kI9g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cL3C5RthrT73uh1cJSdf43k7DBIpOj2P2VVxz4/XBMdCzLG0+3aysToglL45cZgzO
         kK/G26fb7O65IthAYbD6DIk4AOcUdUypUjwYbzTx6gLyX8JJx2L8/vNRR26sMV6wSk
         B/Lo37E2RorEgdBNTa74p3OCEyOXYusfx9qLrA98LuCxnlZCb3ES/GYuwU8h3+Cdm1
         AjfqNpzUbBc6Ef0L4jQxR+sD3gvAZOmTdb5nUog3wJPOzqIJu8mv4HL5Xi1QdJepQr
         LMUlZHbl/masgZXVvld9sZNACS0zJ9jpIJyVVK3PrTKqFoTOBEX0U6OMtHEHhOwxAO
         bKIx1sYUJxBpA==
Date:   Fri, 3 Mar 2023 15:50:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v2 net-next 4/4] net: ena: Add support to changing
 tx_push_buf_len
Message-ID: <20230303155039.5f6c99af@kernel.org>
In-Reply-To: <20230302203045.4101652-5-shayagr@amazon.com>
References: <20230302203045.4101652-1-shayagr@amazon.com>
        <20230302203045.4101652-5-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Mar 2023 22:30:45 +0200 Shay Agroskin wrote:
> @@ -496,11 +509,40 @@ static int ena_set_ringparam(struct net_device *netdev,
>  			ENA_MIN_RING_SIZE : ring->rx_pending;
>  	new_rx_size = rounddown_pow_of_two(new_rx_size);
>  
> -	if (new_tx_size == adapter->requested_tx_ring_size &&
> -	    new_rx_size == adapter->requested_rx_ring_size)
> +	changed |= new_tx_size != adapter->requested_tx_ring_size ||
> +		   new_rx_size != adapter->requested_rx_ring_size;
> +
> +	/* This value is ignored if LLQ is not supported */
> +	new_tx_push_buf_len = 0;
> +	if (adapter->ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_HOST)
> +		goto no_llq_supported;

Are you rejecting the unsupported config in this case or just ignoring
it? You need to return an error if user tries to set something the
device does not support/allow.

BTW your use of gotos to skip code is against the kernel coding style.
gotos are only for complex cases and error handling, you're using them
to save indentation it seems. Factor the code out to a helper instead,
or some such.

> +	new_tx_push_buf_len = kernel_ring->tx_push_buf_len;
> +
> +	/* support for ENA_LLQ_LARGE_HEADER is tested in the 'get' command */
> +	if (new_tx_push_buf_len != ENA_LLQ_HEADER &&
> +	    new_tx_push_buf_len != ENA_LLQ_LARGE_HEADER) {
> +		bool large_llq_sup = adapter->large_llq_header_supported;
> +		char large_llq_size_str[40];
> +
> +		snprintf(large_llq_size_str, 40, ", %lu", ENA_LLQ_LARGE_HEADER);
> +
> +		NL_SET_ERR_MSG_FMT_MOD(extack,
> +				       "Only [%lu%s] tx push buff length values are supported",
> +				       ENA_LLQ_HEADER,
> +				       large_llq_sup ? large_llq_size_str : "");
> +
> +		return -EINVAL;
> +	}
> +
> +	changed |= new_tx_push_buf_len != adapter->ena_dev->tx_max_header_size;
> +
> +no_llq_supported:
> +	if (!changed)
>  		return 0;
>  
> -	return ena_update_queue_sizes(adapter, new_tx_size, new_rx_size);
> +	return ena_update_queue_params(adapter, new_tx_size, new_rx_size,
> +				       new_tx_push_buf_len);
