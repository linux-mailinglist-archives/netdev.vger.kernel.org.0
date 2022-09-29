Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3115EF492
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 13:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbiI2LqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 07:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiI2Lpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 07:45:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B72142E04;
        Thu, 29 Sep 2022 04:45:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 209FA1F894;
        Thu, 29 Sep 2022 11:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664451926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=7bvuulWDxXJ0RP1Sxh0zIbvWapcXVvdLYOPFIo+WtzY=;
        b=N9g5hlFHwmc4jF1XmH5alJaH7i6vM/pdcSIjjaOq9r2ubHDOQN03GDdgRAGIVtZVAfDKya
        MdYgfSk9snobKAzini06bTtbxHp4Cy27+vxyjCYoikbzUC1dLL7y4a3/ukubhOfzFrNnkv
        RNfFMd9QvMWpfmzDwhXa3tpO7gTrR9o=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F11BF1348E;
        Thu, 29 Sep 2022 11:45:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WYj1OVWFNWNGdgAAMHmgww
        (envelope-from <petr.pavlu@suse.com>); Thu, 29 Sep 2022 11:45:25 +0000
From:   Petr Pavlu <petr.pavlu@suse.com>
To:     saeedm@nvidia.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Pavlu <petr.pavlu@suse.com>
Subject: [PATCH] net/mlx5: Remove unused ctx variables
Date:   Thu, 29 Sep 2022 13:45:08 +0200
Message-Id: <20220929114508.1903-1-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove mlx5_priv.ctx_list and ctx_lock which are no longer used after
commit 601c10c89cbb ("net/mlx5: Delete custom device management logic").

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 --
 include/linux/mlx5/driver.h                    | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 89b2d9cea33f..233082c32673 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1547,8 +1547,6 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	int err;
 
 	memcpy(&dev->profile, &profile[profile_idx], sizeof(dev->profile));
-	INIT_LIST_HEAD(&priv->ctx_list);
-	spin_lock_init(&priv->ctx_lock);
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c32de987fa71..8536de1073b3 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -606,8 +606,6 @@ struct mlx5_priv {
 	struct list_head        pgdir_list;
 	/* end: alloc staff */
 
-	struct list_head        ctx_list;
-	spinlock_t              ctx_lock;
 	struct mlx5_adev       **adev;
 	int			adev_idx;
 	int			sw_vhca_id;
-- 
2.35.3

