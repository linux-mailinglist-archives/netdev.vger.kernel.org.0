Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83D765E4C1
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjAEEmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjAEEma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:42:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C789D3F13B;
        Wed,  4 Jan 2023 20:42:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86834B81928;
        Thu,  5 Jan 2023 04:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CE8C433EF;
        Thu,  5 Jan 2023 04:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672893746;
        bh=3zHod49AgkPwVPTXlCPK5XiYc5AupwwjP6SobojBXCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=feXtONwEShIUJi5XInINKxdp7b+yWd7kQW4CuH1eANd6mxsBFJ9C11rnNe0JJj5f8
         uO/GEGdy4m+aLg/y21AS5yLZRqfgfvVcy0DYMnbaXaN6scEJ+x3JQYd9RZ8IKmL+a6
         pklcMKAYdNKa+UeYuB8UayVT1XgqKDk7lNNAYGxZiE7jKd6UhcHTe37UA6mV2yAyqu
         gHQycLYVMwoVPfOgh5g0j8LJ3ZqeDbHXEVn9GRoqEAPI66Nz283i7LYEtEacQMVKE9
         g8ymDOGT+z+oN3oLJsVlwY4A4Bm2S0dlvcCvrF1PG27lvPyejLO/tDMNvOBdi4VJKk
         nWgNyD9qLLXiQ==
Date:   Wed, 4 Jan 2023 20:42:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, mustafa.ismail@intel.com, jgg@nvidia.com,
        leonro@nvidia.com, linux-rdma@vger.kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net v2 1/3] ice: Prevent set_channel from changing
 queues while RDMA active
Message-ID: <20230104204224.31e3eca9@kernel.org>
In-Reply-To: <20230103230738.1102585-2-anthony.l.nguyen@intel.com>
References: <20230103230738.1102585-1-anthony.l.nguyen@intel.com>
        <20230103230738.1102585-2-anthony.l.nguyen@intel.com>
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

On Tue,  3 Jan 2023 15:07:36 -0800 Tony Nguyen wrote:
> +	mutex_lock(&pf->adev_mutex);
> +	if (pf->adev && pf->adev->dev.driver) {
> +		netdev_err(dev, "Cannot change channels when RDMA is active\n");
> +		ret = -EINVAL;
> +		goto adev_unlock;

Since you're have to respin anyway - perhaps -EBUSY here?
