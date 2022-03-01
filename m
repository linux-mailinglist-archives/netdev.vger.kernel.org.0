Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB4B4C84C0
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiCAHQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiCAHQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:16:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFC166FA9;
        Mon, 28 Feb 2022 23:16:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5BF6B8123F;
        Tue,  1 Mar 2022 07:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD1BC340EE;
        Tue,  1 Mar 2022 07:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646118961;
        bh=gj7jL+hp06quOWj/OMODI68jNcHw9EORNDyPBLvYcAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qf+A9cpQ+9rZY/fL2VEyozZqaOlOMkLYI7P3imjxSnJe+HbfCNHlSYpSSD8/Zw6/f
         U0wsd+cWl8Zf+ioA/qAum+8FUaH4QzzYv4FhzKVYgQK25SwgAj+9SorveYOjlTf2DQ
         /1+J7XoXA549E9cGfaFpwTZt5Z15Xp3uWApOpZnpt7cwwPWi3LB0AvLA88GIybYCSS
         pqzyRTUCesgWFQLKw6XoEA3l7UXpKnXN/rwQuch9UN8+NmNc3vAaQVu9Mhj1+YAQU/
         WtPCZU2iwiytCFAo+wz4HJCF+YKoq/aUnPhSs1pw0EmLOro3uPNX3Iv2ZqPL12rOUd
         XDjSFCXFzbW7g==
Date:   Mon, 28 Feb 2022 23:16:00 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: TC, Fix use after free in
 mlx5e_clone_flow_attr_for_post_act()
Message-ID: <20220301071600.uuzk334p4tw6eq25@sx1>
References: <20220224145325.GA6793@kili>
 <5024bc30-d872-3861-a6fd-0a7dba5fbf3e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5024bc30-d872-3861-a6fd-0a7dba5fbf3e@nvidia.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25 Feb 14:18, Roi Dayan wrote:
>
>
>On 2022-02-24 4:53 PM, Dan Carpenter wrote:
>>This returns freed memory leading to a use after free.  It's supposed to
>>return NULL.
>>
>>Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
>>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>---
>>This goes through Saeed's tree not the net tree.
>>
>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>index 76a015dfc5fc..c0776a4a3845 100644
>>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>@@ -3398,7 +3398,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
>>  	if (!attr2 || !parse_attr) {
>>  		kvfree(parse_attr);
>>  		kfree(attr2);
>>-		return attr2;
>>+		return NULL;
>>  	}
>>  	memcpy(attr2, attr, attr_sz);
>
>hi, I noticed your fix now and already reviewed same fix from Colin
>
>https://patchwork.kernel.org/project/netdevbpf/patch/20220224221525.147744-1-colin.i.king@gmail.com/
>
>so just need to take either one.
>thanks
>

Ok this one arrived first, will take this one :).
applied to net-next-mlx5.

>Reviewed-by: Roi Dayan <roid@nvidia.com>


