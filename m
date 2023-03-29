Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B6E6CEC11
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjC2OqZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Mar 2023 10:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC2OqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:46:09 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CB010FA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:44:06 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-ljjrkas4OLe2WR278PEXxg-1; Wed, 29 Mar 2023 10:44:03 -0400
X-MC-Unique: ljjrkas4OLe2WR278PEXxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA0AF85A588;
        Wed, 29 Mar 2023 14:44:02 +0000 (UTC)
Received: from hog (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E3D922166B33;
        Wed, 29 Mar 2023 14:44:01 +0000 (UTC)
Date:   Wed, 29 Mar 2023 16:43:59 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <ZCROr7DhsoRyU1qP@hog>
References: <20230329122107.22658-1-ehakim@nvidia.com>
 <20230329122107.22658-2-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230329122107.22658-2-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-03-29, 15:21:04 +0300, Emeel Hakim wrote:
> Add support for MACsec offload operations for VLAN driver
> to allow offloading MACsec when VLAN's real device supports
> Macsec offload by forwarding the offload request to it.
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> ---
> V1 -> V2: - Consult vlan_features when adding NETIF_F_HW_MACSEC.

Uh? You're not actually doing that? You also dropped the
changes to vlan_dev_fix_features without explaining why.

[...]
> @@ -572,6 +573,9 @@ static int vlan_dev_init(struct net_device *dev)
>  			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
>  			   NETIF_F_ALL_FCOE;
>  
> +	if (real_dev->features & NETIF_F_HW_MACSEC)
> +		dev->hw_features |= NETIF_F_HW_MACSEC;
> +
>  	dev->features |= dev->hw_features | NETIF_F_LLTX;
>  	netif_inherit_tso_max(dev, real_dev);
>  	if (dev->features & NETIF_F_VLAN_FEATURES)
> @@ -803,6 +807,100 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
>  	return 0;
>  }
>  
> +#if IS_ENABLED(CONFIG_MACSEC)
> +
> +static const struct macsec_ops *vlan_get_macsec_ops(struct macsec_context *ctx)
                                                       ^ const?

> +{
> +	return vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops;
> +}
> +
> +#define _BUILD_VLAN_MACSEC_MDO(mdo) \
> +	const struct macsec_ops *ops; \
> +	ops =  vlan_get_macsec_ops(ctx); \
> +	return ops ? ops->mdo_ ## mdo(ctx) : -EOPNOTSUPP
> +
> +static int vlan_macsec_add_txsa(struct macsec_context *ctx)
> +{
> +_BUILD_VLAN_MACSEC_MDO(add_txsa);

Shouldn't those be indented?

> +}
> +

[...]
> +
> +#define VLAN_MACSEC_DECLARE_MDO(mdo) .mdo_ ## mdo = vlan_macsec_ ## mdo
> +
> +static const struct macsec_ops macsec_offload_ops = {
> +	VLAN_MACSEC_DECLARE_MDO(add_txsa),

This completely breaks the ability to use cscope when looking for
implementations of mdo_add_txsa. I'm not very fond of the c/p, but I
don't think we should be using macros at all here. At least to me,
being able to navigate directly from mdo_add_txsa to its
implementation without expanding the macro manually is important.

So, IMHO, those should be:

	.mdo_add_txsa = vlan_macsec_add_txsa,

(etc)

-- 
Sabrina

