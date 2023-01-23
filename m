Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12000677FAE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjAWP17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjAWP14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:27:56 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778212683
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 07:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CMNemhX6R5UrMA2QxgFsp3xJlR7h7TImIN+Pyyu0YN4=; b=zHbqtFYTgbqXs6jcLDXi3j0Kta
        BGbsbjZ5n44uJXEj9UVGw1Rw3kQGalAqMF0hslVilnbegh8jGntQgdF8hz7jH8CBN1hAtuMLKyEfV
        vLPA9u7DHyE8sVHr9MMeokJZetew4XXQY3/q/sGVz/bq60TU+KDJo4xBg3mZ/v792T5E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pJyja-002v3t-GI; Mon, 23 Jan 2023 16:27:46 +0100
Date:   Mon, 23 Jan 2023 16:27:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 05/10] net: libwx: Allocate Rx and Tx resources
Message-ID: <Y86ncnPW0ZDfTjye@lunn.ch>
References: <20230118065504.3075474-1-jiawenwu@trustnetic.com>
 <20230118065504.3075474-6-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118065504.3075474-6-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * wx_setup_rx_resources - allocate Rx resources (Descriptors)
> + * @rx_ring: rx descriptor ring (for a specific queue) to setup
> + *
> + * Returns 0 on success, negative on failure
> + **/
> +static int wx_setup_rx_resources(struct wx_ring *rx_ring)
> +{
> +	struct device *dev = rx_ring->dev;
> +	int orig_node = dev_to_node(dev);
> +	int numa_node = -1;
> +	int size, ret;
> +
> +	size = sizeof(struct wx_rx_buffer) * rx_ring->count;
> +
> +	if (rx_ring->q_vector)
> +		numa_node = rx_ring->q_vector->numa_node;
> +
> +	rx_ring->rx_buffer_info = vmalloc_node(size, numa_node);
> +	if (!rx_ring->rx_buffer_info)
> +		rx_ring->rx_buffer_info = vmalloc(size);
> +	if (!rx_ring->rx_buffer_info)
> +		goto err;
> +
> +	/* Round up to nearest 4K */
> +	rx_ring->size = rx_ring->count * sizeof(union wx_rx_desc);
> +	rx_ring->size = ALIGN(rx_ring->size, 4096);
> +
> +	set_dev_node(dev, numa_node);
> +	rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
> +					   &rx_ring->dma, GFP_KERNEL);
> +	set_dev_node(dev, orig_node);
> +	rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
> +					   &rx_ring->dma, GFP_KERNEL);

Is this double allocation correct?

   Andrew
