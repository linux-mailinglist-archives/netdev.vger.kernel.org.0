Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F4C6E03D5
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDMBtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDMBtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:49:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1079527A
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 18:49:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B706217E
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDC5C4339B;
        Thu, 13 Apr 2023 01:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681350568;
        bh=s+iSGmmFthrFsMR3WNPtI81ft50SG9JHGTDBIgPN2yc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rBRoMsHBjNnf7uI3pNZQ9Qcjp0Twh9zCTYukCutiT0+d/ZmynZa0nvMFFJE0KgiTR
         HVAUf2kov1bKWpJOniq6Nx+tuE/q93oVO8eWkyYGLFAlyED8kySXXbWyuZs70OCYs8
         V3fr7XesAwmlcllh5lbXJs/kkCB1Jl+gQz0fn4fi5eLIDHUJ94T6K58d3h3U8HUakl
         UwWTq4gyjvS49ofaVzukKmJSC1q7XlbVfJjbZ//zG0AhwwdfrPvoYSJZSOp00ON27c
         dV4E8JOmdjDI4JeJRDtoPrGVD0Uv2+MNLfSzDaq3b9nSwEf1kD+Y5a521Jx1S8Eg71
         +/tL+PUOTyIKg==
Date:   Wed, 12 Apr 2023 18:49:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: Re: [RFC PATCH v2 net-next 3/7] net: ethtool: record custom RSS
 contexts in the IDR
Message-ID: <20230412184927.63800565@kernel.org>
In-Reply-To: <5ac2860f8936b95cf873b6dcfd624c530a83ff2d.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
        <5ac2860f8936b95cf873b6dcfd624c530a83ff2d.1681236653.git.ecree.xilinx@gmail.com>
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

On Tue, 11 Apr 2023 19:26:11 +0100 edward.cree@amd.com wrote:
>  	if (rxfh.rss_context)
>  		ret = ops->set_rxfh_context(dev, indir, hkey, rxfh.hfunc,
>  					    &rxfh.rss_context, delete);
> @@ -1350,6 +1377,40 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
>  		else if (rxfh.indir_size != ETH_RXFH_INDIR_NO_CHANGE)
>  			dev->priv_flags |= IFF_RXFH_CONFIGURED;
>  	}

This is probably transient but I think we're potentially leaking @ctx
in a goto out hiding inside the context here, and...

> +	/* Update rss_ctx tracking */
> +	if (create) {
> +		/* Ideally this should happen before calling the driver,
> +		 * so that we can fail more cleanly; but we don't have the
> +		 * context ID until the driver picks it, so we have to
> +		 * wait until after.
> +		 */
> +		if (WARN_ON(idr_find(&dev->ethtool->rss_ctx, rxfh.rss_context)))
> +			/* context ID reused, our tracking is screwed */
> +			goto out;

here.
