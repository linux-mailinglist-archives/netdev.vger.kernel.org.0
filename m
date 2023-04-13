Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2786E03CA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjDMBja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDMBj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92AE61BE
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 18:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47EBC6342D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50085C4339B;
        Thu, 13 Apr 2023 01:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681349963;
        bh=uhTPrUQ/64c1z0MKOw6bmunCWr+YdpTDdMlxCi9BMvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IlUxQkVERPeBTU81I6CZWTqTwP695hVxCBrqw6sozVmFaCu1DpqcoLm65Gfncnfm3
         tItHg/r6WWUlSQUdcZMDStRw/0+XvWyQIE/YuK8NjQ6rqIqyVZRQHQVVSVDs1G2kE/
         NfEfvDjF1JLyo5REmO88Z3QD0KnL4c8PaoGWCwtgjmOVFbqSF+qMp7vX9WK4yyeIqN
         jylXEFpJy/gJ/lqhX3goScbVaXBDYRNCo57Hth3WEXSKQMwU0gvbz3LVZ4MIf2OW3+
         nXPhiF2OQ62KuWi1GVRzNAFWc0CWZxSd+D08N982RdVF97eQsFrJVwd44uV3WoEtVN
         68nax6fOFP7YQ==
Date:   Wed, 12 Apr 2023 18:39:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: Re: [RFC PATCH v2 net-next 2/7] net: ethtool: attach an IDR of
 custom RSS contexts to a netdevice
Message-ID: <20230412183922.530b471c@kernel.org>
In-Reply-To: <16030cc69a6726cda461290a3d6bed9c48db7562.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
        <16030cc69a6726cda461290a3d6bed9c48db7562.1681236653.git.ecree.xilinx@gmail.com>
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

On Tue, 11 Apr 2023 19:26:10 +0100 edward.cree@amd.com wrote:
> +static void netdev_rss_contexts_free(struct net_device *dev)
> +{
> +	struct ethtool_rxfh_context *ctx;
> +	u32 context;
> +
> +	if (!dev->ethtool_ops->set_rxfh_context)
> +		return;
> +	idr_for_each_entry(&dev->ethtool->rss_ctx, ctx, context) {
> +		u32 *indir = ethtool_rxfh_context_indir(ctx);
> +		u8 *key = ethtool_rxfh_context_key(ctx);
> +
> +		idr_remove(&dev->ethtool->rss_ctx, context);
> +		dev->ethtool_ops->set_rxfh_context(dev, indir, key, ctx->hfunc,
> +						   &context, true);
> +		kfree(ctx);
> +	}
> +}

nit: maybe move the ethtool related code out to a new
net/ethtool/netdev.c ? We can probably put forward declarations 
in net/core/dev.h or a new header among sources?
