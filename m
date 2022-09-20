Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881BE5BD9A3
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiITBr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiITBr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:47:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D42550B0
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:47:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8469AB82355
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40EEC433C1;
        Tue, 20 Sep 2022 01:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663638474;
        bh=tPl6FQejZcUcs/p5uU7+s3yMcEVJhxBFCP88QH+siJc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GQLpbLfTr+QTOIQamqJy1MsxYeQ3ZILfxPs5D9TtLqI7Q+TDVdM841oOnZnk6bGMs
         YCPj8Pr0NAV8HmNMrazW5pCAAKnubePrrmH3U/setIbdLIEM08ub/NTw4v/Z2RDLXQ
         3mqKTaTWON4Pv+ip2ghcg2GRJokf0ECYPWPmEjmSAhYH1iE4Aj9HmZ4cJt5MnvUIbE
         lYJl0Elxl5rdk7WouQe8LH6+heP2OMvsNDTbdFkz7jQxIUC4YlGPFnGEB5BaEvE0rU
         UT+uOArrTucLgG9YtZc+qs3mEclsTe8T7QrjoA7rcS5eFtYDq9O+iJekTefEayJTzT
         mSItdydUhLKgw==
Date:   Mon, 19 Sep 2022 18:47:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 4/4] net/mlx5e: Support 256 bit keys with kTLS
 device offload
Message-ID: <20220919184753.49e598ae@kernel.org>
In-Reply-To: <20220914090520.4170-5-gal@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
        <20220914090520.4170-5-gal@nvidia.com>
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

On Wed, 14 Sep 2022 12:05:20 +0300 Gal Pressman wrote:
>  	spin_lock_bh(&ktls_resync->lock);
>  	spin_lock_bh(&priv_rx->lock);
> -	memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be, sizeof(info->rec_seq));
> +	switch (priv_rx->crypto_info.crypto_info.cipher_type) {
> +	case TLS_CIPHER_AES_GCM_128: {

...

> +	default:
> +		WARN_ONCE(1, "Unsupported cipher type %u\n",
> +			  priv_rx->crypto_info.crypto_info.cipher_type);
> +		return;

Sparse suggests releasing the locks.
