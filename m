Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42C6626470
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiKKWSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiKKWSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:18:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3248369B;
        Fri, 11 Nov 2022 14:17:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17BAE62112;
        Fri, 11 Nov 2022 22:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66646C433D6;
        Fri, 11 Nov 2022 22:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668205070;
        bh=t4EcpQFr+jpqNs3On+lMfNz5mj5CUL0REehr3DiGNlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eBGgzVkvaf4SXcmdqfCCq7km/vOlWf57j+vN0+GPl8jy7POksD3u3DeNUQZxPMLp1
         d4qUTakPUWoPQz8z6twuNCqeLTYBIZW/cxvC+7Olsf9qyGNapjVezqhxIT6kT2Ffqq
         J1Q9/N7+SmRjyuAZE09JHWlBrbRdOLWbCOSw+rEXrDjc7gugxfFkLQBDy9K++0g77A
         SlUQs3WHYFObGbpXtlq0MkANPMcf9QlYSuYKCfyvDs5CmZrwcrli0Kt/T4h29u89w2
         g5OKzr1OofEdxGsLDLfYMhC64wBt3DM16I7eteAuqaqOjalkyJEL935BQR0qZxbZhg
         nb7dsRNO8/z4A==
Date:   Fri, 11 Nov 2022 14:17:46 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lkayal@nvidia.com, tariqt@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net/mlx5e: Use kzalloc() in
 mlx5e_accel_fs_tcp_create()
Message-ID: <Y27KCjxQmqHe4uSM@x130.lan>
References: <20221110134319.47076-1-yuehaibing@huawei.com>
 <939ca9bb-0207-2b14-8d44-09c47deb72c6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <939ca9bb-0207-2b14-8d44-09c47deb72c6@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Nov 17:01, Tariq Toukan wrote:
>
>
>On 11/10/2022 3:43 PM, YueHaibing wrote:
>>'accel_tcp' is allocted by kvzalloc() now, which is a small chunk.
>>Use kzalloc() directly instead of kvzalloc(), fix the mismatch free.
>>
>>Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
>>Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>---
>>v3: use kzalloc() instead of kvzalloc()
>>v2: fix the same issue in mlx5e_accel_fs_tcp_destroy() and a commit log typo
>>---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>>index 285d32d2fd08..88a5aed9d678 100644
>>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>>@@ -377,7 +377,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
>>  	if (!MLX5_CAP_FLOWTABLE_NIC_RX(mlx5e_fs_get_mdev(fs), ft_field_support.outer_ip_version))
>>  		return -EOPNOTSUPP;
>>-	accel_tcp = kvzalloc(sizeof(*accel_tcp), GFP_KERNEL);
>>+	accel_tcp = kzalloc(sizeof(*accel_tcp), GFP_KERNEL);
>>  	if (!accel_tcp)
>>  		return -ENOMEM;
>>  	mlx5e_fs_set_accel_tcp(fs, accel_tcp);
>
>Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>
>Thanks.

applied to net-next-mlx5, Thanks !
