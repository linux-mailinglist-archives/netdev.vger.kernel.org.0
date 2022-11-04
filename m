Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF11B6197BE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbiKDNXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiKDNXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:23:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C5EDF06;
        Fri,  4 Nov 2022 06:23:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65C76B82C14;
        Fri,  4 Nov 2022 13:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9A5C433C1;
        Fri,  4 Nov 2022 13:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667568206;
        bh=DA8JZ/2X3KGw4Y7+Dh8tNasiOGgwiYWiRnZPET6RuiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8sLs6HuYXLqCzCEz2tPcCpmX2bo4tPhaDlckgQsf0IKZagDFvkBlT5h6WvhSED0r
         uMTClVoQtVp9g/x3F6zHLUVwbp4BUA+hXfE0X51DpSsEmy9GdvkSdzr0wJSPk9kgQN
         3X7TQCEFtFU0+nT7tyDAEX+kReFj6jYxzMnuJ2qLT2e7FmjeLzCznoC8ur2Q5jdOIs
         TFfj0bKJQL6RXjMcAElmFnIKfQlU0eaM61TNTGYPAu6kSL5lMM0kivaGYREkC4lK4b
         uYX3EpjRQ8fgku0ouhv9A0nMR0YJZ4JQYFHmst3fEtclWpV05PXdCUwK6L4zNH89TH
         grWPdr4919Lmg==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vigneshr@ti.com, vibhore@ti.com, srk@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 3/5] net: ethernet: ti: cpsw_ale: Add cpsw_ale_restore() helper
Date:   Fri,  4 Nov 2022 15:23:08 +0200
Message-Id: <20221104132310.31577-4-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104132310.31577-1-rogerq@kernel.org>
References: <20221104132310.31577-1-rogerq@kernel.org>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be used by device driver to restore ALE context.
The data produced by cpsw_ale_dump() can be passed to
cpsw_ale_restore().

This is required as on certain platforms the ALE context
is lost on low power suspend/resume.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 10 ++++++++++
 drivers/net/ethernet/ti/cpsw_ale.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 231370e9a801..0c5e783e574c 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -1452,6 +1452,16 @@ void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data)
 	}
 }
 
+void cpsw_ale_restore(struct cpsw_ale *ale, u32 *data)
+{
+	int i;
+
+	for (i = 0; i < ale->params.ale_entries; i++) {
+		cpsw_ale_write(ale, i, data);
+		data += ALE_ENTRY_WORDS;
+	}
+}
+
 u32 cpsw_ale_get_num_entries(struct cpsw_ale *ale)
 {
 	return ale ? ale->params.ale_entries : 0;
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index aba4572cfa3b..6779ee111d57 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -127,6 +127,7 @@ int cpsw_ale_control_get(struct cpsw_ale *ale, int port, int control);
 int cpsw_ale_control_set(struct cpsw_ale *ale, int port,
 			 int control, int value);
 void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data);
+void cpsw_ale_restore(struct cpsw_ale *ale, u32 *data);
 u32 cpsw_ale_get_num_entries(struct cpsw_ale *ale);
 
 static inline int cpsw_ale_get_vlan_p0_untag(struct cpsw_ale *ale, u16 vid)
-- 
2.17.1

