Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE709532AC1
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 15:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbiEXNB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 09:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiEXNBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 09:01:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D10201AE;
        Tue, 24 May 2022 06:01:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BFC4615A8;
        Tue, 24 May 2022 13:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DE4C385AA;
        Tue, 24 May 2022 13:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653397283;
        bh=M3xKtMokiDFWNFEIuw3ktU5nFeVmN1Ch2a5N7SDKPQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UtXPQJk5kVUxEIwRRXOV5SPNh7uEBaEFqDsW0ZEiy2BK/j6KTpd/BuagpG8tX4Xh/
         Pn7KYhluP6a63vPyUbaeZlqJHKL9u9jDVM+VCPhWo3Yp0mJPywmakxybXY98kItdGO
         LkBNkjXfRycWjiX548uh2LbyGilBKqSdiW9LjHLXlx3q6ZiDv77Z4oMH5mZkttdhuk
         5z5vu/f6DKDgkaDMB3Wh6ZESB/Gw7WFcQP+CjUNhVq2dR/gNL3RkQdogUB6TYbO0uY
         PLUEfeEGIYGIsbTtxvj7EQqER+7leutA+zdQmeHLlb0Kn1Cm8REy0jUS/jd0HceFlj
         5EldiMmh6r6ZQ==
Date:   Tue, 24 May 2022 16:01:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     maorg@nvidia.com, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [bug report] net/mlx5: Add direct rule fs_cmd implementation
Message-ID: <YozXHxO85GpT+5GK@unreal>
References: <YnvAxF0JO7E0fZvO@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnvAxF0JO7E0fZvO@kili>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 04:57:24PM +0300, Dan Carpenter wrote:
> [ I was reviewing old use after free warnings and stumbled across this
>   one which still needs fixing - dan ]
> 
> Hello Maor Gottlieb,
> 
> The patch 6a48faeeca10: "net/mlx5: Add direct rule fs_cmd
> implementation" from Aug 20, 2019, leads to the following Smatch
> static checker warning:
> 
> 	drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c:53 set_miss_action()
> 	warn: 'action' was already freed.
> 
> drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
>     28 static int set_miss_action(struct mlx5_flow_root_namespace *ns,
>     29                            struct mlx5_flow_table *ft,
>     30                            struct mlx5_flow_table *next_ft)
>     31 {
>     32         struct mlx5dr_action *old_miss_action;
>     33         struct mlx5dr_action *action = NULL;
>     34         struct mlx5dr_table *next_tbl;
>     35         int err;
>     36 
>     37         next_tbl = next_ft ? next_ft->fs_dr_table.dr_table : NULL;
>     38         if (next_tbl) {
>     39                 action = mlx5dr_action_create_dest_table(next_tbl);
>     40                 if (!action)
>     41                         return -EINVAL;
>     42         }
>     43         old_miss_action = ft->fs_dr_table.miss_action;
>     44         err = mlx5dr_table_set_miss_action(ft->fs_dr_table.dr_table, action);
>     45         if (err && action) {
>     46                 err = mlx5dr_action_destroy(action);
>     47                 if (err) {
>     48                         action = NULL;
>     49                         mlx5_core_err(ns->dev, "Failed to destroy action (%d)\n",
>     50                                       err);
>     51                 }
> 
> If "err" is zero then "action" is freed.
> 
>     52         }
> --> 53         ft->fs_dr_table.miss_action = action;
>                                              ^^^^^^
> Use after free.

Thanks for the report.
https://lore.kernel.org/netdev/7fe70bbb120422cc71e6b018531954d58ea2e61e.1653397057.git.leonro@nvidia.com/T/#u

> 
>     54         if (old_miss_action) {
>     55                 err = mlx5dr_action_destroy(old_miss_action);
>     56                 if (err)
>     57                         mlx5_core_err(ns->dev, "Failed to destroy action (%d)\n",
>     58                                       err);
>     59         }
>     60 
>     61         return err;
>     62 }
> 
> regards,
> dan carpenter
