Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791D41F48D4
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgFIVZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:25:22 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:47572 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFIVZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:25:22 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 059LOn5P030078;
        Tue, 9 Jun 2020 14:25:16 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, manojmalviya@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 2/2] Crypto/chcr: Checking cra_refcnt before unregistering the algorithms
Date:   Wed, 10 Jun 2020 02:54:32 +0530
Message-Id: <20200609212432.2467-3-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
In-Reply-To: <20200609212432.2467-1-ayush.sawal@chelsio.com>
References: <20200609212432.2467-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch puts a check for algorithm unregister, to avoid removal of
driver if the algorithm is under use.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index f8b55137cf7d..4c2553672b6f 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -4391,22 +4391,32 @@ static int chcr_unregister_alg(void)
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
 		switch (driver_algs[i].type & CRYPTO_ALG_TYPE_MASK) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
-			if (driver_algs[i].is_registered)
+			if (driver_algs[i].is_registered && refcount_read(
+			    &driver_algs[i].alg.skcipher.base.cra_refcnt)
+			    == 1) {
 				crypto_unregister_skcipher(
 						&driver_algs[i].alg.skcipher);
+				driver_algs[i].is_registered = 0;
+			}
 			break;
 		case CRYPTO_ALG_TYPE_AEAD:
-			if (driver_algs[i].is_registered)
+			if (driver_algs[i].is_registered && refcount_read(
+			    &driver_algs[i].alg.aead.base.cra_refcnt) == 1) {
 				crypto_unregister_aead(
 						&driver_algs[i].alg.aead);
+				driver_algs[i].is_registered = 0;
+			}
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
-			if (driver_algs[i].is_registered)
+			if (driver_algs[i].is_registered && refcount_read(
+			    &driver_algs[i].alg.hash.halg.base.cra_refcnt)
+			    == 1) {
 				crypto_unregister_ahash(
 						&driver_algs[i].alg.hash);
+				driver_algs[i].is_registered = 0;
+			}
 			break;
 		}
-		driver_algs[i].is_registered = 0;
 	}
 	return 0;
 }
-- 
2.26.0.rc1.11.g30e9940

