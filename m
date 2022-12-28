Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FB865867E
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiL1ToM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiL1ToD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:44:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B715011160
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D6BE615FD
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C130C433D2;
        Wed, 28 Dec 2022 19:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256630;
        bh=RJolfkOriOVngNEaugIQjSkHpemIYnmLC3isRB/6l/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJZbPhv9jae0gNDDLTaxsDI1UUy1zzRisfM58GbsGN8XKyUKcdOjc93TdltPqeamI
         gpAxWTOB05Oi66u20IVlTwSy5fjGzEps/hcnGTZCDaLy97jgC2x30Nx/26Pm3H9Gw3
         uj0FXAHtjOWrbeLCmQqhUM++grnokVI0dPzvd5tsGbzm72oH5Dt33mV45HDXSX/dqn
         gBJbY5m49WVOsmUh9cdxMdikmAXI2r6j4NkHCeF3MIQ+EEuOtm3fPsZBGBg1NepTY6
         WIRuK5nJznQ/6kkvtr+yVF3AKFPQ+03aWYolmSSvYw2GDmafWSlLBwYAp0Nu3eVES4
         aIxlxiu1nK6wA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 12/12] net/mlx5: Lag, fix failure to cancel delayed bond work
Date:   Wed, 28 Dec 2022 11:43:31 -0800
Message-Id: <20221228194331.70419-13-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Commit 0d4e8ed139d8 ("net/mlx5: Lag, avoid lockdep warnings")
accidentally removed a call to cancel delayed bond work thus it may
cause queued delay to expire and fall on an already destroyed work
queue.

Fix by restoring the call cancel_delayed_work_sync() before
destroying the workqueue.

This prevents call trace such as this:

[  329.230417] BUG: kernel NULL pointer dereference, address: 0000000000000000
 [  329.231444] #PF: supervisor write access in kernel mode
 [  329.232233] #PF: error_code(0x0002) - not-present page
 [  329.233007] PGD 0 P4D 0
 [  329.233476] Oops: 0002 [#1] SMP
 [  329.234012] CPU: 5 PID: 145 Comm: kworker/u20:4 Tainted: G OE      6.0.0-rc5_mlnx #1
 [  329.235282] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 [  329.236868] Workqueue: mlx5_cmd_0000:08:00.1 cmd_work_handler [mlx5_core]
 [  329.237886] RIP: 0010:_raw_spin_lock+0xc/0x20
 [  329.238585] Code: f0 0f b1 17 75 02 f3 c3 89 c6 e9 6f 3c 5f ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 0f 1f 44 00 00 31 c0 ba 01 00 00 00 <f0> 0f b1 17 75 02 f3 c3 89 c6 e9 45 3c 5f ff 0f 1f 44 00 00 0f 1f
 [  329.241156] RSP: 0018:ffffc900001b0e98 EFLAGS: 00010046
 [  329.241940] RAX: 0000000000000000 RBX: ffffffff82374ae0 RCX: 0000000000000000
 [  329.242954] RDX: 0000000000000001 RSI: 0000000000000014 RDI: 0000000000000000
 [  329.243974] RBP: ffff888106ccf000 R08: ffff8881004000c8 R09: ffff888100400000
 [  329.244990] R10: 0000000000000000 R11: ffffffff826669f8 R12: 0000000000002000
 [  329.246009] R13: 0000000000000005 R14: ffff888100aa7ce0 R15: ffff88852ca80000
 [  329.247030] FS:  0000000000000000(0000) GS:ffff88852ca80000(0000) knlGS:0000000000000000
 [  329.248260] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  329.249111] CR2: 0000000000000000 CR3: 000000016d675001 CR4: 0000000000770ee0
 [  329.250133] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [  329.251152] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [  329.252176] PKRU: 55555554

Fixes: 0d4e8ed139d8 ("net/mlx5: Lag, avoid lockdep warnings")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 32c3e0a649a7..ad32b80e8501 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -228,6 +228,7 @@ static void mlx5_ldev_free(struct kref *ref)
 	if (ldev->nb.notifier_call)
 		unregister_netdevice_notifier_net(&init_net, &ldev->nb);
 	mlx5_lag_mp_cleanup(ldev);
+	cancel_delayed_work_sync(&ldev->bond_work);
 	destroy_workqueue(ldev->wq);
 	mlx5_lag_mpesw_cleanup(ldev);
 	mutex_destroy(&ldev->lock);
-- 
2.38.1

