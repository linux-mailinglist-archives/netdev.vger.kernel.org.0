Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4454862C56A
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbiKPQvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239097AbiKPQus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:50:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504821112;
        Wed, 16 Nov 2022 08:49:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E13D861EEE;
        Wed, 16 Nov 2022 16:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E8AC43470;
        Wed, 16 Nov 2022 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668617372;
        bh=qvQKpvLNHVXrB7+8IiQETTMMyyG0jxiPHRO3yv3NGeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANYxNHBCK+3ptBc0Q7XznL1jDwyzPsSoTxs+evIacNUxebzuC/LZTteEaU9DEWbit
         GIYnMdJCpq6n6QPwuplWul7GiAKSkSQAGskQLG7mPqUfzMAOo9xRZl7Nr1oVE7g7SZ
         aWCGtwi36aK+2QfOmvWflT4ft81C0z732rEqRCbta9gUrFRIUU4Lvcl5xSRGiWOviS
         iMkUOSgrwwuC2ktvIsRTq1G0CIRNm7P4B2BQTb2hqNelq8bxqhxs6zWwkPpo7eD2FQ
         7qyWD+oBngSS2a/93aQLLg5oca8BiEyhOEEbqzevf86/mteZgbyB1ogBT+7W6rCYlK
         2NoCFlOBOzgYA==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 4/4] net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()
Date:   Wed, 16 Nov 2022 18:49:15 +0200
Message-Id: <20221116164915.13236-5-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221116164915.13236-1-rogerq@kernel.org>
References: <20221116164915.13236-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an entry was FREE then we don't have to restore it.
This will make the restore faster in most cases.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
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

