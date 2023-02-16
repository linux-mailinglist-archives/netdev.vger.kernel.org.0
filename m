Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DA3699B99
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjBPRx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBPRx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:53:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2252D68
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 09:53:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA7BFB82951
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 17:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA22C433EF;
        Thu, 16 Feb 2023 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676570005;
        bh=mkaRd70HE0HlHLE0WkJUlfiUg3vav81u80SRABpr6Lg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YItXvXSPLbI+qAz43EoMWQrO9hQ8lIwDcv44NqgTm+kZTUdRuTIKdlVF+T/5+bVED
         KRls/zUi0cvBfTnmYQpbn8I7bnfugCIE4a7r3cqJ4jon1cHMM5qbP7B4ExUT47RPTg
         kMK2PBcN75HI9emSMa7ub/R+9z5g13+WBZ3I6V154f0cyoJ/x1OhqngkbaFwfTR5Jt
         MK4CmF65NONkuWa9VIrrj8GPABB51YI4fJHJFBJgQnNXQs+KLM+YRH4L3BhGPfGtYX
         zvqv7snOHMpz7MbMW6Zbz4rupnJht3pwSolvWKsLrVXLkoz48FTAija1rX1fUpfx1l
         0lWD+ElWX51OQ==
Date:   Thu, 16 Feb 2023 09:53:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 1/9] net/mlx5e: Switch to using napi_build_skb()
Message-ID: <20230216095324.4fa4f6fb@kernel.org>
In-Reply-To: <07a89ee6-2886-65b8-d2cb-ca154f1f1f4f@intel.com>
References: <20230216000918.235103-1-saeed@kernel.org>
        <20230216000918.235103-2-saeed@kernel.org>
        <07a89ee6-2886-65b8-d2cb-ca154f1f1f4f@intel.com>
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

On Thu, 16 Feb 2023 18:26:19 +0100 Alexander Lobakin wrote:
> > Before: 26.5 Gbits/sec
> > After:  30.1 Gbits/sec (+13.6%)  
> 
> +14%, gosh! Happy to see more and more vendors switching to it, someone
> told me back then we have so fast RAM nowadays that it won't make any
> sense to directly recycle kmem-cached objects. Maybe it's fast, but
> seems like not *so* fast :D

Interestingly I had a similar patch in my tree when testing the skb_ext
cache and enabling slow_gro kills this gain.

IOW without adding an skb_ext using napi_build_skb() gives me ~12%
boost. If I start adding skb_ext (with the cache and perfect reuse) 
I'm back to the baseline (26.5Gbps in this case).

But without using napi_build_skb() adding skb_ext (with the cache)
doesn't change anything, skb_ext or not, I'll get 26.5Gbps.

Very finicky. Not sure why this happens. Perhaps napi_build_skb() 
let's us fit under some CPU resource constraint and additional
functionality knocks us back over the line?
