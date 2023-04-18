Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894AA6E605F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjDRLtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjDRLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF646A248;
        Tue, 18 Apr 2023 04:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D64FA62CDB;
        Tue, 18 Apr 2023 11:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9F8C433EF;
        Tue, 18 Apr 2023 11:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681818456;
        bh=hF5srHhGnVubFYKGy6gt95dlRe4xzC55sgy5w3GdgdE=;
        h=From:To:Cc:Subject:Date:From;
        b=Pu7EsVWW6KN8l4XdS7ObjsFpLgL28DsnhGalbcRrHrC+nh78H9i9mGpn2ddlWBCHQ
         cqxNLbZDznoi8kdXxtDNZHTaf+wtCUXz5aE7ARsZJ+Lrmkni36dSS6jOQrLog0fRGB
         ATFLjWdqU16Bcl9xkiefUxgrTVM0FARWVHwII6MKKqSCqTfwLZ828LrfGk/8thUATi
         HAm6exx7vEUNlUMiGhryDHaBRbnsH91ntQAhmoPLoVrlaS6evi5Yy6rINzx0a1WuaN
         H/v8Y5Wa1KfSY+AnITXBUZVME12g4jBS0Pc5XfE/lhH03X//a4nlbHGt5TzYs0k91g
         v0pF0Ibr6HZSQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net/mlx4: fix build error from usercopy size check
Date:   Tue, 18 Apr 2023 13:47:11 +0200
Message-Id: <20230418114730.3674657-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The array_size() helper is used here to prevent accidental overflow in
mlx4_init_user_cqes(), but as this returns SIZE_MAX in case an overflow
would happen, the logic in copy_to_user() now detects that as overflowing
the source:

In file included from arch/x86/include/asm/preempt.h:9,
                 from include/linux/preempt.h:78,
                 from include/linux/percpu.h:6,
                 from include/linux/context_tracking_state.h:5,
                 from include/linux/hardirq.h:5,
                 from drivers/net/ethernet/mellanox/mlx4/cq.c:37:
In function 'check_copy_size',
    inlined from 'copy_to_user' at include/linux/uaccess.h:190:6,
    inlined from 'mlx4_init_user_cqes' at drivers/net/ethernet/mellanox/mlx4/cq.c:317:9,
    inlined from 'mlx4_cq_alloc' at drivers/net/ethernet/mellanox/mlx4/cq.c:394:10:
include/linux/thread_info.h:244:4: error: call to '__bad_copy_from' declared with attribute error: copy source size is too small
  244 |    __bad_copy_from();
      |    ^~~~~~~~~~~~~~~~~

Move the size logic out, and instead use the same size value for the
comparison and the copy.

Fixes: f69bf5dee7ef ("net/mlx4: Use array_size() helper in copy_to_user()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx4/cq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 4d4f9cf9facb..020cb8e2883f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -290,6 +290,7 @@ static void mlx4_cq_free_icm(struct mlx4_dev *dev, int cqn)
 static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
 {
 	int entries_per_copy = PAGE_SIZE / cqe_size;
+	size_t copy_size = array_size(entries, cqe_size);
 	void *init_ents;
 	int err = 0;
 	int i;
@@ -304,7 +305,7 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
 	 */
 	memset(init_ents, 0xcc, PAGE_SIZE);
 
-	if (entries_per_copy < entries) {
+	if (copy_size > PAGE_SIZE) {
 		for (i = 0; i < entries / entries_per_copy; i++) {
 			err = copy_to_user((void __user *)buf, init_ents, PAGE_SIZE) ?
 				-EFAULT : 0;
@@ -315,7 +316,7 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
 		}
 	} else {
 		err = copy_to_user((void __user *)buf, init_ents,
-				   array_size(entries, cqe_size)) ?
+				   copy_size) ?
 			-EFAULT : 0;
 	}
 
-- 
2.39.2

