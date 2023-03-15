Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0956BA96C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjCOHgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjCOHf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:35:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1076A79B17;
        Wed, 15 Mar 2023 00:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9112AB81C9E;
        Wed, 15 Mar 2023 07:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A5FC433EF;
        Wed, 15 Mar 2023 07:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678865566;
        bh=FwOyZQ0zbDowL3G8WaiPuXocNYQRCYn0YDUMD0eKhgo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=scta9WaoNLYt+EFqwehsVQhfZZe2nHiPWRcyiI+KQRpJ4HBnAjo/5vj/r5h053jnU
         TCOHV/s1mUACZ8GkdEcXnuvIFG5j505sDfcffiq76anpyDYGRu+R4yBFB112ZcK93U
         hYBxylp5iqMdFEZpUHfpiJN7TQTB71+mK2odusYtr7Eq1QNH+czc8U5bamTYA9Oduo
         ypEq1Q2PzN4vhYvhE+ArW4cQBSZ8/NbL2h5/Ue6UC8d+B63fJxzX3r3EA5ZMcSIRSu
         8HB27xp2vD6uTQdCcH86Rbcio/a7f7yRrrVgGZ9XJj7pfEWSMmzr8hMh98N+l9/9up
         kLk36louRZ0Tw==
Date:   Wed, 15 Mar 2023 00:32:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <roopa@nvidia.com>, <eng.alaamohamedsoliman.am@gmail.com>,
        <bigeasy@linutronix.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gavi@nvidia.com>,
        <roid@nvidia.com>, <maord@nvidia.com>, <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v7 5/5] net/mlx5e: TC, Add support for VxLAN
 GBP encap/decap flows offload
Message-ID: <20230315003244.52bb841d@kernel.org>
In-Reply-To: <20230313075107.376898-6-gavinl@nvidia.com>
References: <20230313075107.376898-1-gavinl@nvidia.com>
        <20230313075107.376898-6-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 09:51:07 +0200 Gavin Li wrote:
> +	if (memchr_inv(&enc_opts.mask->data, 0, sizeof(enc_opts.mask->data)) &&
> +	    !MLX5_CAP_ESW_FT_FIELD_SUPPORT_2(priv->mdev, tunnel_header_0_1)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Matching on VxLAN GBP is not supported");
> +		netdev_warn(priv->netdev, "Matching on VxLAN GBP is not supported\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
> +		NL_SET_ERR_MSG_MOD(extack, "Wrong VxLAN option type: not GBP");
> +		netdev_warn(priv->netdev, "Wrong VxLAN option type: not GBP\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (enc_opts.key->len != sizeof(*gbp) ||
> +	    enc_opts.mask->len != sizeof(*gbp_mask)) {
> +		NL_SET_ERR_MSG_MOD(extack, "VxLAN GBP option/mask len is not 32 bits");
> +		netdev_warn(priv->netdev, "VxLAN GBP option/mask len is not 32 bits\n");
> +		return -EINVAL;
> +	}
> +
> +	gbp = (u32 *)&enc_opts.key->data[0];
> +	gbp_mask = (u32 *)&enc_opts.mask->data[0];
> +
> +	if (*gbp_mask & ~VXLAN_GBP_MASK) {
> +		NL_SET_ERR_MSG_FMT_MOD(extack, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
> +		netdev_warn(priv->netdev, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
> +		return -EINVAL;

extack only please, there's no excuse to be using both any more
