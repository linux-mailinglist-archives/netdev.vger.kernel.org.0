Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4FB6D53CF
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbjDCVpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbjDCVpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:45:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907B24EC1
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:44:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0504362CC4
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 21:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16109C4339B;
        Mon,  3 Apr 2023 21:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680558238;
        bh=G2EDORMVK1lTytUwq32sUYaO0rmV6UIT/+We/CwF3u0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rZ5xmHm1PzbvV+YFYnGmV6hT+LizFhtgVRvuF5/T7kp7fbMceWWzxqfY9M5oyMxIm
         o0bNPoiE2FtwisHVTSrP0O9QCe/OrHdJXzjWaYx77VpbHzsESNZAUQqy/5tMnUD17e
         iYt3fxU5rdRrmvk8jepq3HcZw9smp5ssUGneMBpYeuGi/R8ILiom2uAkD1SD8hcItx
         FPbf7nnX+ZrMmWvHBB2+r5hJXjiD1rpGtlhRciLuv6uZpLUJhORKN12eMt+WcPTRfs
         7DY191oOgFjM1XkFoWU3WXtfDntGprE6U0UGVcck13P5U3DBqgNIvTbQSc3jy2Hr5K
         5melh28+4Zo0w==
Date:   Mon, 3 Apr 2023 14:43:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: Re: [RFC PATCH net-next 1/6] net: ethtool: attach an IDR of custom
 RSS contexts to a netdevice
Message-ID: <20230403144357.2434352d@kernel.org>
In-Reply-To: <671909f108e480d961b2c170122520dffa166b77.1680538846.git.ecree.xilinx@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
        <671909f108e480d961b2c170122520dffa166b77.1680538846.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 17:32:58 +0100 edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Each context stores the RXFH settings (indir, key, and hfunc) as well
>  as optionally some driver private data.
> Delete any still-existing contexts at netdev unregister time.

> +/**
> + * struct ethtool_rxfh_context - a custom RSS context configuration
> + * @indir_size: Number of u32 entries in indirection table
> + * @key_size: Size of hash key, in bytes
> + * @hfunc: RSS hash function identifier.  One of the %ETH_RSS_HASH_*
> + * @priv_size: Size of driver private data, in bytes
> + */
> +struct ethtool_rxfh_context {
> +	u32 indir_size;
> +	u32 key_size;
> +	u8 hfunc;
> +	u16 priv_size;
> +	/* private: indirection table, hash key, and driver private data are
> +	 * stored sequentially in @data area.  Use below helpers to access
> +	 */
> +	u8 data[];

I think that something needs to get aligned here...
Driver priv needs to guarantee ulong alignment in case someone puts 
a pointer in it.

> +};
> +
> +static inline u32 *ethtool_rxfh_context_indir(struct ethtool_rxfh_context *ctx)
> +{
> +	return (u32 *)&ctx->data;
> +}
> +
> +static inline u8 *ethtool_rxfh_context_key(struct ethtool_rxfh_context *ctx)
> +{
> +	return (u8 *)(ethtool_rxfh_context_indir(ctx) + ctx->indir_size);
> +}
> +
> +static inline void *ethtool_rxfh_context_priv(struct ethtool_rxfh_context *ctx)
> +{
> +	return ethtool_rxfh_context_key(ctx) + ctx->key_size;

ALIGN_PTR() ... ?
Or align data[] and reorder..

> +}
> +
>  /* declare a link mode bitmap */
>  #define __ETHTOOL_DECLARE_LINK_MODE_MASK(name)		\
>  	DECLARE_BITMAP(name, __ETHTOOL_LINK_MODE_MASK_NBITS)

> +	u32			rss_ctx_max_id;
> +	struct idr		rss_ctx;

noob question, why not xarray?
Isn't IDR just a legacy wrapper around xarray anyway?

