Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0AC53303C
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbiEXSNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240375AbiEXSNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:13:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FEB6C0DF;
        Tue, 24 May 2022 11:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C34B2B817F2;
        Tue, 24 May 2022 18:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D58C34100;
        Tue, 24 May 2022 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653415987;
        bh=6rwhj+FNXWqPtzOtmUwHpc8UehTtQ8TTd4aiRslpLJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=awrrNQMJSMGE0APJacZ9loO4V8nMQJ2pCJZ0PfZEEaetkLdWYb0PdpfbMhn5T2LeP
         j+4q9P7ROB6LBl3xP2kGqHS4MwZE7SzObRSz7fo3jyU4kOtl1NrbX9hkZxLLO8rf2Y
         Jf1dD9UvgtNp+c3chGASwaN2dqnkGXo+E9MLUwnX8zf+uk3uVTf5/H7eelKujGCruw
         rvRbCtIyxsb+Kbo2Y1UVhRsKjn2050ioXXgjEvywiGTZWbqIj5xBkuZnFM2goc0J8w
         7oVS0EPvn3sRq+Z0cdKSJfZ7P2K8yUfXs1Z20YefOyYooVWstiY5wLlEvh/7Dbwx+O
         20yjzZv2oqGiw==
Date:   Tue, 24 May 2022 21:13:02 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     roid@nvidia.com, linux-rdma@vger.kernel.org,
        Mark Bloch <markb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [bug report] net/mlx5: E-Switch, Protect changing mode while
 adding rules
Message-ID: <Yo0gLpMS7CuUII0D@unreal>
References: <YoH3ZVir5UZUgs3R@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoH3ZVir5UZUgs3R@kili>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 10:04:05AM +0300, Dan Carpenter wrote:
> Hello Roi Dayan,
> 
> The patch 7dc84de98bab: "net/mlx5: E-Switch, Protect changing mode
> while adding rules" from Sep 16, 2020, leads to the following Smatch
> static checker warning:
> 
> 	drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:2000 mlx5_esw_unlock()
> 	warn: inconsistent returns '&esw->mode_lock'.
> 
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
>     1996 void mlx5_esw_unlock(struct mlx5_eswitch *esw)
>     1997 {
>     1998         if (!mlx5_esw_allowed(esw))
>     1999                 return;
> 
> Smatch is complaining because how will the caller know if we dropped
> the lock or not.  I thought, "Hm.  I guess the lock function has a
> similar check?  Although, how does that work that mlx5_esw_allowed()
> means that it doesn't need locking?"
> 
> But then when I looked at the lock function, mlx5_esw_try_lock(), and it
> does *NOT* have a similar check.  This probably works because it's
> checked in different layers and this is just a duplicative (layering
> violation) check which is ugly but harmless.

Your analysis is correct and I agree with you, the check should be removed.
However the "problematic" commit is ec2fa47d7b98 ("net/mlx5: Lag, use lag lock"),
where mlx5_esw_lock() was removed.

Thanks

> 
> --> 2000         up_write(&esw->mode_lock);
>     2001 }
> 
> regards,
> dan carpenter
