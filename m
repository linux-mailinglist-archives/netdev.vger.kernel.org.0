Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAF761E599
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiKFTkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiKFTkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:40:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A20B2DC0
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 11:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6F84B80B72
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 19:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E7CC433D6;
        Sun,  6 Nov 2022 19:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667763596;
        bh=EELHcXROajApIqSKKc/sYyqdUMsnq1Rq0ePZFmMj3Ws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hRUvoSlRtctffMux2JURG6Y84XIeiGmEtsQZMOviDZ1/0P0aEps8OWpqWrz/2Jp+r
         cT0OYgHIQz03/NluJS3iyqIP4r+g78VRlqsrnyiPomq59EMtzMeujhJbMcrNk9pmI2
         z6WyUFpiRqWuywWYZJEeqM6LHTrB0DM/tGGtUdGm1mPSSoOllRDi/oFjAIU8gaijZX
         PgzoYwDuS/rVKLtXJaQtqHUm5MPlvDDZUA2Suf7rXFBWZCaQddOSckd785uz12G4dx
         l36lzIm/y5dYsycK0TJR1w6QmtmKvxH/78B10pF/NCoNt1c/Xlo9v8wj7NSHVWS1y9
         B89yTO90ARG/Q==
Date:   Sun, 6 Nov 2022 21:39:51 +0200
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
Subject: Re: [PATCH net-next v3 2/3] nfp: add framework to support ipsec
 offloading
Message-ID: <Y2gNh3QvaK7MX9pp@unreal>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-3-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101110248.423966-3-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 12:02:47PM +0100, Simon Horman wrote:
> From: Huanhuan Wang <huanhuan.wang@corigine.com>
> 
> A new metadata type and config structure are introduced to
> interact with firmware to support ipsec offloading. This
> feature relies on specific firmware that supports ipsec
> encrypt/decrypt by advertising related capability bit.
> 
> The xfrm callbacks which interact with upper layer are
> implemented in the following patch.
> 
> Based on initial work of Norm Bagley <norman.bagley@netronome.com>.
> 
> Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/Kconfig        |  11 ++
>  drivers/net/ethernet/netronome/nfp/Makefile   |   2 +
>  .../ethernet/netronome/nfp/crypto/crypto.h    |  23 ++++
>  .../net/ethernet/netronome/nfp/crypto/ipsec.c | 105 ++++++++++++++++++
>  drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  58 ++++++++--
>  .../net/ethernet/netronome/nfp/nfd3/ipsec.c   |  18 +++
>  .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |   8 ++
>  drivers/net/ethernet/netronome/nfp/nfp_net.h  |   9 ++
>  .../ethernet/netronome/nfp/nfp_net_common.c   |   3 +
>  .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +
>  10 files changed, 231 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
>  create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c

<...>

> +void nfp_net_ipsec_clean(struct nfp_net *nn)
> +{
> +	if (!(nn->cap_w1 & NFP_NET_CFG_CTRL_IPSEC))
> +		return;
> +	xa_destroy(&nn->xa_ipsec);

You shouldn't use xa_destroy() here as if you have entries in xa_ipsec,
you won't release them and leak memory without any warning. Most likely,
the WARN_ON(!xa_empty(&nn->xa_ipsec)) is what you want here.

The rest code is ok.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
