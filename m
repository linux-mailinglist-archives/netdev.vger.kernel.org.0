Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBC256AF94
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiGHBDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236795AbiGHBDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:03:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB7E38AD
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 18:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD02FB824C1
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BFDC341CA;
        Fri,  8 Jul 2022 01:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242206;
        bh=hyZNqGaylhapRFHG5P4icoGFcsN1qUwevMdNm9I1iok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlIRk5FTIYYznPI6gNeMlqQyGOjHnKCvC2AsmWFwNKrbJmjLsrLjCG9PNDzo1bqRt
         G0F8hpWrOHIMfWdiRQPsK3ZLyQH576DoVzj3/r2C23Eu93ejsDF3SlkbumjmksSYuj
         DhQEczH2wi/h/xHhGAXDuvqyqSqLYvlB/K8d1YyRhfIyPqhT5igvJTguP15nLz7BMI
         mr6zgYenplRCGPsp7NYPi9o/wTnH1XX1JA6pc+aSFQDrlSxJI9NW0zgM/s36IaJTX2
         5/EfZyAbjF5UpAEO8a5EtNV2gD9PqGvQyg81R8mQcL401YRVPkFLRwtacX3y1xLfYu
         r+sUaQd7llbZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/6] strparser: pad sk_skb_cb to avoid straddling cachelines
Date:   Thu,  7 Jul 2022 18:03:09 -0700
Message-Id: <20220708010314.1451462-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708010314.1451462-1-kuba@kernel.org>
References: <20220708010314.1451462-1-kuba@kernel.org>
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

