Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34B8197F6B
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgC3PTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:19:33 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:57019 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgC3PTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:19:32 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02UFJFT5027024;
        Mon, 30 Mar 2020 08:19:25 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 1/2] Crypto: chelsio - Fixes a hang issue during driver registration
Date:   Mon, 30 Mar 2020 20:48:52 +0530
Message-Id: <20200330151853.32550-2-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
In-Reply-To: <20200330151853.32550-1-ayush.sawal@chelsio.com>
References: <20200330151853.32550-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This issue occurs only when multiadapters are present. Hang
happens because assign_chcr_device returns u_ctx pointer of
adapter which is not yet initialized as for this adapter cxgb_up
is not been called yet.

The last_dev pointer is used to determine u_ctx pointer and it
is initialized two times in chcr_uld_add in chcr_dev_add respectively.

The fix here is don't initialize the last_dev pointer during
chcr_uld_add. Only assign to value to it when the adapter's
initialization is completed i.e in chcr_dev_add.

Fixes: fef4912b66d62 ("crypto: chelsio - Handle PCI shutdown event").

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index 0015810214a9..f1499534a0fe 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -129,8 +129,6 @@ static void chcr_dev_init(struct uld_ctx *u_ctx)
 	atomic_set(&dev->inflight, 0);
 	mutex_lock(&drv_data.drv_mutex);
 	list_add_tail(&u_ctx->entry, &drv_data.inact_dev);
-	if (!drv_data.last_dev)
-		drv_data.last_dev = u_ctx;
 	mutex_unlock(&drv_data.drv_mutex);
 }
 
-- 
2.26.0.rc1.11.g30e9940

