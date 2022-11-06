Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57561E5B2
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiKFTsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKFTsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:48:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102A11057A
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 11:48:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6F06B80B72
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 19:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9732AC433D6;
        Sun,  6 Nov 2022 19:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667764095;
        bh=d/yr2RTBsTEjFCj/pnWubkKF+zP1hSgsEDeqQy+zZaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OKnVES7nWBD+FI+AGmvu34edREdC2GljAijZIqMF7WPsSoh5wxKvQRfiirBYMa20p
         zgycAC0x8BPLgwaL63bUg9j1hNNa4P7QbkxBJnOId8bp5zBvW0XGp5Uy4mps3P3CkZ
         2d1iHLJp1wWxPbFn5RcggqXbvi7q5G+AqyTisZ9oTn+4f3kdlVQaN8DHt2YvQNwhok
         EG6H1Qc3IVFnbHHUsDNzuLmOJlXdevaU8AS8oYmjaT5dmxFRuxEnlnIF3QfYU2hSNv
         I4k0SS/hqWODGz6ESQqYq6Kz2ByFPuyQlIjNPxOtsjofgamKyIRiPdqvPkx+Fr+Lsz
         L5sUKeAha8aaA==
Date:   Sun, 6 Nov 2022 21:48:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Message-ID: <Y2gPelnt3xfgDGYd@unreal>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101110248.423966-4-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 12:02:48PM +0100, Simon Horman wrote:
> From: Huanhuan Wang <huanhuan.wang@corigine.com>
> 
> Xfrm callbacks are implemented to offload SA info into firmware
> by mailbox. It supports 16K SA info in total.
> 
> Expose ipsec offload feature to upper layer, this feature will
> signal the availability of the offload.
> 
> Based on initial work of Norm Bagley <norman.bagley@netronome.com>.
> 
> Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  .../net/ethernet/netronome/nfp/crypto/ipsec.c | 532 +++++++++++++++++-
>  .../ethernet/netronome/nfp/nfp_net_common.c   |   6 +
>  .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +-
>  3 files changed, 538 insertions(+), 4 deletions(-)

<...>

>  static int nfp_net_xfrm_add_state(struct xfrm_state *x)
>  {
> -	return -EOPNOTSUPP;
> +	struct net_device *netdev = x->xso.dev;
> +	struct nfp_ipsec_cfg_mssg msg = {0};

I think that I already wrote it {0} -> {};

> +	int i, key_len, trunc_len, err = 0;
> +	struct nfp_ipsec_cfg_add_sa *cfg;
> +	struct nfp_net *nn;
> +	unsigned int saidx;
> +	__be32 *p;

<...>

> +		if (trunc_len == 96)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_MD5_96;
> +		else if (trunc_len == 128)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_MD5_128;
> +		else
> +			trunc_len = 0;

IMHO, this is better to write as switch-case in separate function.

> +		break;
> +	case SADB_AALG_SHA1HMAC:
> +		if (trunc_len == 96)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA1_96;
> +		else if (trunc_len == 80)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA1_80;
> +		else
> +			trunc_len = 0;
> +		break;

Ditto.

> +	case SADB_X_AALG_SHA2_256HMAC:
> +		if (trunc_len == 96)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA256_96;
> +		else if (trunc_len == 128)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA256_128;
> +		else
> +			trunc_len = 0;
> +		break;
> +	case SADB_X_AALG_SHA2_384HMAC:
> +		if (trunc_len == 96)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA384_96;
> +		else if (trunc_len == 192)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA384_192;
> +		else
> +			trunc_len = 0;
> +		break;
> +	case SADB_X_AALG_SHA2_512HMAC:
> +		if (trunc_len == 96)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA512_96;
> +		else if (trunc_len == 256)
> +			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA512_256;
> +		else
> +			trunc_len = 0;
> +		break;
> +	default:
> +		nn_err(nn, "Unsupported authentication algorithm\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!trunc_len) {
> +		nn_err(nn, "Unsupported authentication algorithm trunc length\n");
> +		return -EINVAL;
> +	}
> +
> +	if (x->aalg) {
> +		p = (__be32 *)x->aalg->alg_key;
> +		key_len = DIV_ROUND_UP(x->aalg->alg_key_len, BITS_PER_BYTE);
> +		if (key_len > sizeof(cfg->auth_key)) {
> +			nn_err(nn, "Insufficient space for offloaded auth key\n");
> +			return -EINVAL;
> +		}
> +		for (i = 0; i < key_len / sizeof(cfg->auth_key[0]) ; i++)
> +			cfg->auth_key[i] = ntohl(*p++);

I wonder if you can't declare p as u32 and use memcpy here instead of
u32->__be32->u32 conversions.

Thanks
