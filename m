Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467B163B991
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 06:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbiK2FvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 00:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiK2FvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 00:51:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFAC391EE
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 21:51:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 911F8B80EAC
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 05:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330A1C433D6;
        Tue, 29 Nov 2022 05:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669701070;
        bh=wGf0S/7qr5Umj/jhgDAOPfp9WfHTAPjBCYIje3LSYlw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GekANpw7giaSjI6GU2y16NNpDC3bnLSj9sK5gyYDsvneKqdZALzbS9THtLTo5BLqc
         INFOCLGNHq8kCN5HI/s5QkcDpiQUxAXuScw6SmqTbh3q9m0recKGP8BgLHUFbUEHD8
         oa1MopAn2MGfJO2YGo8HPyvHNxp2ps7lsDUWAhj87phxmeNR7vHYMPcC3y6mJkeunj
         957hwyjnVa2yX9QvjIB1frQgheKn6jUCqx4cn7xrT4AC1Tif5XNfX1QMzbZaNQ2C+o
         T84CakzRj+QluDBq8HLjP72+wHrF97NJrrtHq1dKelwjyMHGEeZ9Ugd6GDJqV4iUWD
         1wwTEsqQzpbOA==
Date:   Mon, 28 Nov 2022 21:51:09 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [net 03/15] net/mlx5: E-switch, Fix duplicate lag creation
Message-ID: <Y4WdzWNVcLMvsYyF@fedora>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-4-saeed@kernel.org>
 <f0f7f0c1-e7c5-1083-2511-c94bde3814a0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f0f7f0c1-e7c5-1083-2511-c94bde3814a0@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Nov 15:23, Jacob Keller wrote:
>
>
>On 11/24/2022 12:10 AM, Saeed Mahameed wrote:
>>From: Chris Mi <cmi@nvidia.com>
>>
>>If creating bond first and then enabling sriov in switchdev mode,
>>will hit the following syndrome:
>>
>>mlx5_core 0000:08:00.0: mlx5_cmd_out_err:778:(pid 25543): CREATE_LAG(0x840) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x7d49cb), err(-22)
>>
>>The reason is because the offending patch removes eswitch mode
>>none. In vf lag, the checking of eswitch mode none is replaced
>>by checking if sriov is enabled. But when driver enables sriov,
>>it triggers the bond workqueue task first and then setting sriov
>>number in pci_enable_sriov(). So the check fails.
>>
>>Fix it by checking if sriov is enabled using eswitch internal
>>counter that is set before triggering the bond workqueue task.
>>
>>Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
>>Signed-off-by: Chris Mi <cmi@nvidia.com>
>>Reviewed-by: Roi Dayan <roid@nvidia.com>
>>Reviewed-by: Mark Bloch <mbloch@nvidia.com>
>>Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
>>Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>---
>>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 8 ++++++++
>>  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 5 +++--
>>  2 files changed, 11 insertions(+), 2 deletions(-)
>>

[...]

>>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>>index be1307a63e6d..4070dc1d17cb 100644
>>--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>>+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>>@@ -701,8 +701,9 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
>>  #ifdef CONFIG_MLX5_ESWITCH
>>  	dev = ldev->pf[MLX5_LAG_P1].dev;
>>-	if ((mlx5_sriov_is_enabled(dev)) && !is_mdev_switchdev_mode(dev))
>>-		return false;
>>+	for (i = 0; i  < ldev->ports; i++)
>>+		if (mlx5_eswitch_num_vfs(dev->priv.eswitch) && !is_mdev_switchdev_mode(dev))
>>+			return false;
>
>Am I missing something? whats with the for loop iterator here? i isn't 
>used or passed into these functions?
>
>Do you need to check multiple times or do these functions have some 
>side effect? But looking at their implementation neither of them 
>appear to have side effects?
>
>What am I missing?

Great catch! it's a copy/paste bug, here we need to grab each port's
eswitch on every iteration.

something like:
for (i = 0; i  < ldev->ports; i++) {
+     dev = ldev->pf[i].dev;
      if (mlx5_eswitch_num_vfs(dev->priv.eswitch) && !is_mdev_switchdev_mode(dev))
              return false;
}


