Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2204F8EAD
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbiDHDkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiDHDkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC46084EF7
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33EA9B829BA
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9059CC385AA;
        Fri,  8 Apr 2022 03:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389108;
        bh=fdogpYI0YfMlNdxhuLCsFxFWa4DFDv08rdMpjCoqgDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOGGkjpXzQAyJ1P96IviLnhFu3Wv2rle4uN3btRJm+kqTrnN/ZsZ2GgskFBZZ9T+d
         JKgNrCakP483zUcP9+LaccjS6qiMToU0t/UIPQ788wgB6+uW0DXkbY4xLXq3JW0tR5
         weDle3SMovhvOl7T55pEt+Mn+ZO118Dn7hw1ghAM9B0bZJO+65HB2Pgs/mIf8TeVkP
         qYLhvyYeG6jiFxOieBlgfhB/mgjQpUsWPgD6nAceXQsw42ZnhMrtAYwPU88RRCmJLQ
         LRGSN/Rm2aRzn2HxoIvQBukc23CjdyM6U3KmNLzGTmIzEH+3t+bGO4A30BrcUIs4qg
         2IMWGyL+EXDCQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/10] tls: rx: use a define for tag length
Date:   Thu,  7 Apr 2022 20:38:19 -0700
Message-Id: <20220408033823.965896-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408033823.965896-1-kuba@kernel.org>
References: <20220408033823.965896-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS 1.3 has to strip padding, and it starts out 16 bytes
from the end of the record. Make it clear this is because
of the auth tag.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/tls.h | 1 +
 net/tls/tls_sw.c  | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index f040edc97c50..a01c264e5f15 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -64,6 +64,7 @@
 #define TLS_AAD_SPACE_SIZE		13
 
 #define MAX_IV_SIZE			16
+#define TLS_TAG_SIZE			16
 #define TLS_MAX_REC_SEQ_SIZE		8
 
 /* For CCM mode, the full 16-bytes of IV is made of '4' fields of given sizes.
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index eb2e8495aa62..579ccfd011a1 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -136,9 +136,9 @@ static int padding_length(struct tls_prot_info *prot, struct sk_buff *skb)
 
 	/* Determine zero-padding length */
 	if (prot->version == TLS_1_3_VERSION) {
+		int back = TLS_TAG_SIZE + 1;
 		char content_type = 0;
 		int err;
-		int back = 17;
 
 		while (content_type == 0) {
 			if (back > rxm->full_len - prot->prepend_size)
@@ -2496,7 +2496,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 
 	/* Sanity-check the sizes for stack allocations. */
 	if (iv_size > MAX_IV_SIZE || nonce_size > MAX_IV_SIZE ||
-	    rec_seq_size > TLS_MAX_REC_SEQ_SIZE) {
+	    rec_seq_size > TLS_MAX_REC_SEQ_SIZE || tag_size != TLS_TAG_SIZE) {
 		rc = -EINVAL;
 		goto free_priv;
 	}
-- 
2.34.1

