Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C09534BE2
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346708AbiEZIpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiEZIpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:45:41 -0400
X-Greylist: delayed 18895 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 May 2022 01:45:39 PDT
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 344BBEF;
        Thu, 26 May 2022 01:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=0ZyEQ
        /bJBhAiNQ0J1gBwUOgg0ihgin014Qd7tlwiVpk=; b=gyOXPhj89b6wvRWdVQKfp
        CeGzUBl8mcBbFNdt+92cAHvlrxGd+G0HKhJXpatY6bOHbb9JCygbwIVK4PW22F4S
        KH/g5nqL4nf9voz2Idyr5gqsxLEkLo2ma5jZGPwKd9apP+bq5iRcY8vftRgMDqsD
        HBXWB+qBeh2eSpy8fJwL8c=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp1 (Coremail) with SMTP id GdxpCgC3t7_dPY9inGY1EQ--.48759S4;
        Thu, 26 May 2022 16:44:28 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        parav@nvidia.com, vuhuong@nvidia.com, shayd@nvidia.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] net/mlx5: Fix memory leak in mlx5_sf_dev_add()
Date:   Thu, 26 May 2022 16:44:11 +0800
Message-Id: <20220526084411.480472-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgC3t7_dPY9inGY1EQ--.48759S4
X-Coremail-Antispam: 1Uf129KBjvJXoWruFyDKw43Zry5tF1ftFy8uFg_yoW8JF1kpF
        47Wa45Wryxuw4jga1UZrWfXFn8GanrKayv9rWxZ34fCr9avayUAr98tryYkw13CrWUXFy7
        tFnruw1DZFn8Jw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRID7fUUUUU=
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiPgwNjFxBsV-PzwAAsA
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable id is allocated by mlx5_adev_idx_alloc(). When some error
happens, the id should be freed by mlx5_adev_idx_free().But when
auxiliary_device_add() and xa_insert() fail, the id is not freed,which
will lead to a potential memory leak.

We can fix it by calling mlx5_sf_dev_add() when auxiliary_device_add()
and xa_insert() fail.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index 7da012ff0d41..9f222061a1c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -125,13 +125,16 @@ static void mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u16 fn_id,
 
 	err = auxiliary_device_add(&sf_dev->adev);
 	if (err) {
+		mlx5_adev_idx_free(id);
 		put_device(&sf_dev->adev.dev);
 		goto add_err;
 	}
 
 	err = xa_insert(&table->devices, sf_index, sf_dev, GFP_KERNEL);
-	if (err)
+	if (err) {
+		mlx5_adev_idx_free(id);
 		goto xa_err;
+	}
 	return;
 
 xa_err:
-- 
2.25.1

