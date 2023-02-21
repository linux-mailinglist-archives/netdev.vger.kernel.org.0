Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E3069DAA9
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 07:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbjBUGjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 01:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjBUGjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 01:39:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4560D23679;
        Mon, 20 Feb 2023 22:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC572B8068F;
        Tue, 21 Feb 2023 06:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23631C433EF;
        Tue, 21 Feb 2023 06:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676961584;
        bh=YkFOO9aM1K8Qut5IqFRyX6dRKUEyTubYWucTE1mbxLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=APnLhJFFs9hjDS/jPj8WNQluDdj+BTiX6SwX+dRfBct1/UaSdOxCrr+k8szsMMMFu
         lm4uueZ8xO/nrKIUVQKAtrfdE8xTvn16wwK8B8T0eGGueo3n9lsh5Xdyd/DQY3ZU8W
         MngBp22cq1rmfj437KHzAFS8hUtsyegIychXzRZVhcknesAmS9c8txTVxxwhAKJBko
         IVBXOycbm93a7+wZeUPRDM4J7tX+a+eMazZxCe/Nzj7Rp1XFtBoeiB+2JvEKW7n68p
         X14ZNqBwQhdrzhQibospJTY7GJc2xTozRArnW6eMbltQdswZk3S9IsWx6V7VAiT50I
         XR/ukxwL9eNjw==
Date:   Tue, 21 Feb 2023 08:39:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: Fix memory leak in IPsec RoCE creation
Message-ID: <Y/RnLCPZPaR4WSUC@unreal>
References: <1b414ea3a92aa0d07b6261cf641445f27bc619d8.1676811549.git.leon@kernel.org>
 <20230220165000.1eda0afb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220165000.1eda0afb@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 04:50:00PM -0800, Jakub Kicinski wrote:
> On Sun, 19 Feb 2023 14:59:57 +0200 Leon Romanovsky wrote:
> > -rule_fail:
> > +fail_rule:
> >  	mlx5_destroy_flow_group(roce->g);
> > -fail:
> > +fail_group:
> >  	mlx5_destroy_flow_table(ft);
> > +fail_table:
> > +	kvfree(in);
> >  	return err;
> 
> If you're touching all of them please name them after what they do.
> Much easier to review.

I can change it, but all mlx* drivers and randomly chosen place in ice
use label to show what fail and not what will be done. Such notation
gives an ability to refactor code without changing label names if
failed part of code is not removed.

Thanks
