Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B51569789
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiGGBfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbiGGBfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:35:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A482E9FB
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 18:35:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FED8B81FA9
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6372FC341CB;
        Thu,  7 Jul 2022 01:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657157716;
        bh=hyZNqGaylhapRFHG5P4icoGFcsN1qUwevMdNm9I1iok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJre2CQb17T5zX4JzpEg9SVH4Geb4WMvJbqOc3YdyaHb1rxBmM/f+71WBo6q3a6WG
         FPcq4ziTGCClqyRjRhDr2mPLUC1b8v/HxOnk/oRu0lpNSlw9cvPgzR6/TSRb10zN+k
         kpnIN8+y8gkkYdRP/ZybB3jVe7LVbvmMUCWN56vTuBHbPLUa2UVEjxebXw+Yffn/JH
         15AMzkm/KQGlNx0vfaO2OctV3ZtqlNEkhIhwA3UxoF9a4Zcko3l3kqQ87PPgwuZ+pc
         Tw/DLzq1SaP/q8+WlgYlYdAZKABuUVi7LAJu9lHUBfkevR4bS4A+ZYvV4VPjY2gVhq
         csmOVOwgCnSGQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/6] strparser: pad sk_skb_cb to avoid straddling cachelines
Date:   Wed,  6 Jul 2022 18:35:05 -0700
Message-Id: <20220707013510.1372695-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707013510.1372695-1-kuba@kernel.org>
References: <20220707013510.1372695-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_skb_cb lives within skb->cb[]. skb->cb[] straddles
2 cache lines, each containing 24B of data.
The first cache line does not contain much interesting
information for users of strparser, so pad things a little.
Previously strp_msg->full_len would live in the first cache
line and strp_msg->offset in the second.

We need to reorder the 8 byte temp_reg with struct tls_msg
to prevent a 4B hole which would push the struct over 48B.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/strparser.h   | 12 ++++++++----
 net/strparser/strparser.c |  3 +++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index a191486eb1e4..88900b05443e 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -65,15 +65,19 @@ struct _strp_msg {
 struct sk_skb_cb {
 #define SK_SKB_CB_PRIV_LEN 20
 	unsigned char data[SK_SKB_CB_PRIV_LEN];
+	/* align strp on cache line boundary within skb->cb[] */
+	unsigned char pad[4];
 	struct _strp_msg strp;
-	/* temp_reg is a temporary register used for bpf_convert_data_end_access
-	 * when dst_reg == src_reg.
-	 */
-	u64 temp_reg;
+
+	/* strp users' data follows */
 	struct tls_msg {
 		u8 control;
 		u8 decrypted;
 	} tls;
+	/* temp_reg is a temporary register used for bpf_convert_data_end_access
+	 * when dst_reg == src_reg.
+	 */
+	u64 temp_reg;
 };
 
 static inline struct strp_msg *strp_msg(struct sk_buff *skb)
diff --git a/net/strparser/strparser.c b/net/strparser/strparser.c
index 1a72c67afed5..8299ceb3e373 100644
--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -533,6 +533,9 @@ EXPORT_SYMBOL_GPL(strp_check_rcv);
 
 static int __init strp_dev_init(void)
 {
+	BUILD_BUG_ON(sizeof(struct sk_skb_cb) >
+		     sizeof_field(struct sk_buff, cb));
+
 	strp_wq = create_singlethread_workqueue("kstrp");
 	if (unlikely(!strp_wq))
 		return -ENOMEM;
-- 
2.36.1

