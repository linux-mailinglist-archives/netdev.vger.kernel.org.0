Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539226E17D1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 01:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjDMXBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 19:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjDMXBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 19:01:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F89F3AA7;
        Thu, 13 Apr 2023 16:01:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A60766423F;
        Thu, 13 Apr 2023 23:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CC5C433D2;
        Thu, 13 Apr 2023 23:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681426899;
        bh=feFzuPicw7XI4wnXdqG7Ju9PtrYVUQfWpKy8ap1UbOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZNStpGlZpGmlwQnpdX2AloWOoBPbGc0PjTmKRrWaGhUZB5fNbtkcMLOolrC8YIOu2
         p/WLRB+Mmgj1coTZpzbsUfrP9b5ukWstj7LIz1/pGLaZPrHya/Vi3OhtQzYETzeWIP
         vbuKcOjujlwuWDl+t0EekAc1v2wdPI6g/wB5UGsr1Q2ZnkTOwBmf6PAH4am3+vXC6p
         iFTN7d2vtIMe/Tqf323UmsarzEclXRDxXilj1lu3vkJRZQEGy8eHa7yyScXQuYWa+8
         6MLtBnZNfdJZ529ItcLPpLN5xHL0jZXrwYxwITPuKzDoM4R4/Sn/8XfEVUDuwEkJEz
         Ked0sUEcu5gLw==
Date:   Thu, 13 Apr 2023 16:01:37 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Alexander Schmidt <alexs@linux.ibm.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/mlx5: stop waiting for PCI link if reset
 is required
Message-ID: <ZDiJ0f5kxgJ4Bpb7@x130>
References: <20230411105103.2835394-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230411105103.2835394-1-schnelle@linux.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11 Apr 12:51, Niklas Schnelle wrote:
>After an error on the PCI link, the driver does not need to wait
>for the link to become functional again as a reset is required. Stop
>the wait loop in this case to accelerate the recovery flow.
>
>Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
>Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
>Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
>Link: https://lore.kernel.org/r/20230403075657.168294-1-schnelle@linux.ibm.com
>Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
> 1 file changed, 10 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>index f9438d4e43ca..81ca44e0705a 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>@@ -325,6 +325,8 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
> 	while (sensor_pci_not_working(dev)) {
> 		if (time_after(jiffies, end))
> 			return -ETIMEDOUT;
>+		if (pci_channel_offline(dev->pdev))
>+			return -EIO;

We already sent a patch to net not too long a go to break this while loop
when there is a triggered reset:
  
net/mlx5: Stop waiting for PCI up if teardown was triggered
https://lore.kernel.org/netdev/20230314054234.267365-3-saeed@kernel.org/

Usually when the pci goes offline, either the PCI subsystem will detect
that and will trigger the mlx5 teardown or mlx5 health check will detect it
and will initiate the teardown, in both ways the MLX5_BREAK_FW_WAIT flag
will be raised and the loop will quit, please let me know if you think 
the extra check of pci_channel_offline(dev->pdev) is still required here
for your system.


