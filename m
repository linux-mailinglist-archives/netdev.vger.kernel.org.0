Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5517A4C22D8
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiBXEEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiBXEEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:04:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A3925A32C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:04:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E880E616F5
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 04:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0523BC340E9;
        Thu, 24 Feb 2022 04:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645675454;
        bh=1bL2wDFvGt56N8HXcbLC1MpS6N/CsaqpssXEUVFpKUA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d1NxQoNcZizpv/rkjNGEZhgx7xwQOubi/z9bVTZ6+c1DRUfgnqwxeGJ0rIuXUgFFL
         z2HsTjkaU737SruCSHro8a1AoWRuhIAZ2d5CiJp3DYXhcj37fEMLDrYjGWzOW9EwlV
         nESLUgLK0qQGEvCRvMrieiE5aLF1u1XZY6GkJiUl7DHbK/7BteJa9id5kyAjfjzgW6
         WRFQcwH/fIod6mLpNF2GTg1PSQDbStkwZ4v8zhYq9V8tj+DaFuJ913nKN2vtEO1jcR
         021blCXBmfi8yBzS7EGyuIDKCPtG9qsE3WISFijp6if22MpyfD7ciKgvYchT47vzOX
         eE09BKnVumFlg==
Date:   Wed, 23 Feb 2022 20:04:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: Re: [PATCH net-next v2 09/12] vxlan: vni filtering support on
 collect metadata device
Message-ID: <20220223200413.6fd5e491@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222025230.2119189-10-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
        <20220222025230.2119189-10-roopa@nvidia.com>
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

On Tue, 22 Feb 2022 02:52:27 +0000 Roopa Prabhu wrote:
> diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
> index 7a946010a204..d697d6c51cb5 100644
> --- a/drivers/net/vxlan/vxlan_private.h
> +++ b/drivers/net/vxlan/vxlan_private.h
> @@ -7,6 +7,8 @@
>  #ifndef _VXLAN_PRIVATE_H
>  #define _VXLAN_PRIVATE_H
>  
> +#include <linux/rhashtable.h>
> +
>  extern unsigned int vxlan_net_id;
>  extern const u8 all_zeros_mac[ETH_ALEN + 2];
>  
> @@ -92,6 +94,38 @@ bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
>  
>  #endif
>  
> +static inline int vxlan_vni_cmp(struct rhashtable_compare_arg *arg,
> +				const void *ptr)
> +{
> +	const struct vxlan_vni_node *vnode = ptr;
> +	__be32 vni = *(__be32 *)arg->key;
> +
> +	return vnode->vni != vni;
> +}

This one is called thru a pointer so can as well move to a C source
with the struct, see below.

> +static const struct rhashtable_params vxlan_vni_rht_params = {
> +	.head_offset = offsetof(struct vxlan_vni_node, vnode),
> +	.key_offset = offsetof(struct vxlan_vni_node, vni),
> +	.key_len = sizeof(__be32),
> +	.nelem_hint = 3,
> +	.max_size = VXLAN_N_VID,
> +	.obj_cmpfn = vxlan_vni_cmp,
> +	.automatic_shrinking = true,
> +};

struct definition in the header? Shouldn't it be an extern and
definition in a C file?

> +static inline struct vxlan_vni_node *
> +vxlan_vnifilter_lookup(struct vxlan_dev *vxlan, __be32 vni)
> +{
> +	struct vxlan_vni_group *vg;
> +
> +	vg = rcu_dereference_rtnl(vxlan->vnigrp);
> +	if (!vg)
> +		return NULL;
> +
> +	return rhashtable_lookup_fast(&vg->vni_hash, &vni,
> +				      vxlan_vni_rht_params);
> +}
