Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEC66E8537
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 00:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjDSWtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 18:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjDSWtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 18:49:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914201721
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 15:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28B4864114
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45652C433D2;
        Wed, 19 Apr 2023 22:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681944531;
        bh=xDC5+0fgt/OCNCx0xNXLzvasRWbNMOtugvP8XJdIA7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b8pXaUueAAFd67PoTv0v/CRdC5bN/Uq4JkvQiipdmqc7pgZE3SKAUoQzUN2NOa9cM
         hea2d0pCsRxytgqpiFmpEZyRHJXgGmI8njypxwnd2f5QajOqwm4cwmbgqrhVf+1d5m
         dfQ/4cq2WKI6ZfKYPts6rhX3ZTeT7qEsGZ5uyY5nSWYAiyYRKt7v+DWwrr1Wb8uBtq
         ++RYTDvxyCeZT/pj3hhlC1uKGlDreE3flS74u9qICPtZZGwXF8VK6qYh8gEa0qioax
         +TJA+4exm9nQ59wmc5uCA2dNFARda+kklHHOmkH7bmZLZkgtpeKcisTo+xdGiYgT6B
         un7Wkko2ueudg==
Date:   Wed, 19 Apr 2023 15:48:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Berliner <alexberliner@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jeroen de Borst <jeroendb@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next] gve: Add modify ring size support
Message-ID: <20230419154850.5fec4c1d@kernel.org>
In-Reply-To: <20230418221313.39112-1-alexberliner@google.com>
References: <20230418221313.39112-1-alexberliner@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Apr 2023 22:13:13 +0000 Alex Berliner wrote:
> +		err = gve_close(priv->dev);
> +		if (err)
> +			return err;
> +		priv->tx_desc_cnt = new_tx_desc_cnt;
> +		priv->rx_desc_cnt = new_rx_desc_cnt;
> +
> +		err = gve_open(priv->dev);
> +		if (err)
> +			goto err;

please don't close / open. if the machine is low on memory it will 
fall off the network. I think I had a similar complaint about xdp
patches for gve, it'd be great if people working on gve within google
talked to each other.
