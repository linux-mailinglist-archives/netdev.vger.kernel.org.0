Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177E452E4EB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345784AbiETGUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344159AbiETGUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:20:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FF014C751
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 23:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 363C4CE282D
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D72C385A9;
        Fri, 20 May 2022 06:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653027598;
        bh=zlZjtuG6yTtz+ERHcUcrDxczMz7atYDsVj/noU2euhk=;
        h=From:To:Cc:Subject:Date:From;
        b=KFttGeIB96CEQLbgg/mcA+fOOx+6kARgqMiNoqf+zowWTGAxjU8gh16o2yIArWKOZ
         DHm9SDxjh0uGiWxP5OhjPsV5OzDxbeYRweGDTBcgaxGsLFrOvQ81tEdRxMHJEnnd8w
         eZW69nurqP3BbSzFN/270xSvMPv2thter+3ulpLbMTpF2rAo9Ama1BIwJCFHli14I3
         icokJdU0Y2YnIxr26+Me0X4C3yNdbZG0Br84Vp1PKaPGqovfqD7HhL7PfmB4aa44Tj
         56bva9oTLLZ6qVqHR38fqUa33DDdhf7NUsb7EcAoPDwt9GYAdazTd9Y2lNDVurAuIu
         9YaPufF/A4qRA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, michael.chan@broadcom.com
Subject: [PATCH net-next] eth: bnxt: make ulp_id unsigned to make GCC 12 happy
Date:   Thu, 19 May 2022 23:19:55 -0700
Message-Id: <20220520061955.2312968-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC array bounds checking complains that ulp_id is validated
only against upper bound. Make it unsigned.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: michael.chan@broadcom.com
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 12 ++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index fde0c3e8ac57..2e54bf4fc7a7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -25,7 +25,7 @@
 #include "bnxt_hwrm.h"
 #include "bnxt_ulp.h"
 
-static int bnxt_register_dev(struct bnxt_en_dev *edev, int ulp_id,
+static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
 			     struct bnxt_ulp_ops *ulp_ops, void *handle)
 {
 	struct net_device *dev = edev->net;
@@ -62,7 +62,7 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, int ulp_id,
 	return 0;
 }
 
-static int bnxt_unregister_dev(struct bnxt_en_dev *edev, int ulp_id)
+static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -115,7 +115,7 @@ static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 	}
 }
 
-static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
+static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 			      struct bnxt_msix_entry *ent, int num_msix)
 {
 	struct net_device *dev = edev->net;
@@ -179,7 +179,7 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 	return avail_msix;
 }
 
-static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, int ulp_id)
+static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -233,7 +233,7 @@ int bnxt_get_ulp_stat_ctxs(struct bnxt *bp)
 	return 0;
 }
 
-static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
+static int bnxt_send_msg(struct bnxt_en_dev *edev, unsigned int ulp_id,
 			 struct bnxt_fw_msg *fw_msg)
 {
 	struct net_device *dev = edev->net;
@@ -447,7 +447,7 @@ void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl)
 	rcu_read_unlock();
 }
 
-static int bnxt_register_async_events(struct bnxt_en_dev *edev, int ulp_id,
+static int bnxt_register_async_events(struct bnxt_en_dev *edev, unsigned int ulp_id,
 				      unsigned long *events_bmap, u16 max_id)
 {
 	struct net_device *dev = edev->net;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 54d59f681b86..42b50abc3e91 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -77,15 +77,15 @@ struct bnxt_en_dev {
 };
 
 struct bnxt_en_ops {
-	int (*bnxt_register_device)(struct bnxt_en_dev *, int,
+	int (*bnxt_register_device)(struct bnxt_en_dev *, unsigned int,
 				    struct bnxt_ulp_ops *, void *);
-	int (*bnxt_unregister_device)(struct bnxt_en_dev *, int);
-	int (*bnxt_request_msix)(struct bnxt_en_dev *, int,
+	int (*bnxt_unregister_device)(struct bnxt_en_dev *, unsigned int);
+	int (*bnxt_request_msix)(struct bnxt_en_dev *, unsigned int,
 				 struct bnxt_msix_entry *, int);
-	int (*bnxt_free_msix)(struct bnxt_en_dev *, int);
-	int (*bnxt_send_fw_msg)(struct bnxt_en_dev *, int,
+	int (*bnxt_free_msix)(struct bnxt_en_dev *, unsigned int);
+	int (*bnxt_send_fw_msg)(struct bnxt_en_dev *, unsigned int,
 				struct bnxt_fw_msg *);
-	int (*bnxt_register_fw_async_events)(struct bnxt_en_dev *, int,
+	int (*bnxt_register_fw_async_events)(struct bnxt_en_dev *, unsigned int,
 					     unsigned long *, u16);
 };
 
-- 
2.34.3

