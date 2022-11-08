Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB1C621416
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiKHN5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiKHN5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:57:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC1E60EB1;
        Tue,  8 Nov 2022 05:57:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E0FAB816DD;
        Tue,  8 Nov 2022 13:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA918C433D7;
        Tue,  8 Nov 2022 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667915824;
        bh=tQ72T7lQxJkgX/x3mTSKvAAkisGq4na2N+MSF2k1IYY=;
        h=From:To:Cc:Subject:Date:From;
        b=rarAumq7Os55EgdCMr4oiL1ZaPvjcTFkoRgoClYflI+J2eso3fj/gOs/7NcFtEBuR
         tCnrMEOMpCrrK/vXxMdSco0tIDtJ0nh8Z3vefWysV/jc2j20LwVAFk1YczIPHWhzqx
         2tPmVqNlJiAgL0kejIhO9igqnHwNBk5CQDMREI6vTkT87uj5q/OWOxiljk008e6DJm
         Wyc6NPHblK6OkQA2eqoXvfA8T+wNMRvqUjrr6KiM6UhfUrkcHS+Fn3DvPKyuRUygYP
         cBbHJpibmvWk92v0BX5xiv55xz/kVaFJOnuTlQFqd1a08xJvZ1kkQe/A/5wh9XRPks
         Qcv0qINm1Y9Vw==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vigneshr@ti.com, srk@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH] net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()
Date:   Tue,  8 Nov 2022 15:56:43 +0200
Message-Id: <20221108135643.15094-1-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an entry was FREE then we don't have to restore it.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---

Patch depends on
https://lore.kernel.org/netdev/20221104132310.31577-3-rogerq@kernel.org/T/

 drivers/net/ethernet/ti/cpsw_ale.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 0c5e783e574c..41bcf34a22f8 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -1452,12 +1452,15 @@ void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data)
 	}
 }
 
+/* ALE table should be cleared (ALE_CLEAR) before cpsw_ale_restore() */
 void cpsw_ale_restore(struct cpsw_ale *ale, u32 *data)
 {
-	int i;
+	int i, type;
 
 	for (i = 0; i < ale->params.ale_entries; i++) {
-		cpsw_ale_write(ale, i, data);
+		type = cpsw_ale_get_entry_type(data);
+		if (type != ALE_TYPE_FREE)
+			cpsw_ale_write(ale, i, data);
 		data += ALE_ENTRY_WORDS;
 	}
 }
-- 
2.17.1

