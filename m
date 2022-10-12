Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A935FCEA3
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 00:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJLWz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 18:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLWz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 18:55:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10028D73FF
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 15:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A029A6164F
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 22:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C5AC433D6;
        Wed, 12 Oct 2022 22:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665615324;
        bh=69/PQh+cOvSS0EdQoi88q8EUmcsDFfVRBHMBeGbH2M8=;
        h=From:To:Cc:Subject:Date:From;
        b=n9LtF6JxaN7cAb8ffHQE88on36PKXrNnPYDyUijLKwgiXT/JolUezRC7fg/ebaTan
         NKllHICWapOV45V52B02/Jb5apENv7SkOhi/3bva2IXXeCAftefQJZwFe2CWx0+5XM
         ZMld4k6EyRrVMhcOfTr4D8zGDHnyuD0+fko5RqaN1399eM5PfD/UKcAq2QFPIwJiHJ
         q2wR9kmaICtzg5bHjf5qBz+AUI2yvhqOYBpu0673glmn7HhykvuJSKl7+dSE9MBaQ3
         jj1MfpE4lXtwV5ygsinTU619cebqDRAZpcvNye4kjrA5QRTW0LY4P+3ut0rm2JyLCW
         sEjFOErcWGQrA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] tls: strp: make sure the TCP skbs do not have overlapping data
Date:   Wed, 12 Oct 2022 15:55:20 -0700
Message-Id: <20221012225520.303928-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS tries to get away with using the TCP input queue directly.
This does not work if there is duplicated data (multiple skbs
holding bytes for the same seq number range due to retransmits).
Check for this condition and fall back to copy mode, it should
be rare.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 9b79e334dbd9..955ac3e0bf4d 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -273,7 +273,7 @@ static int tls_strp_read_copyin(struct tls_strparser *strp)
 	return desc.error;
 }
 
-static int tls_strp_read_short(struct tls_strparser *strp)
+static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 {
 	struct skb_shared_info *shinfo;
 	struct page *page;
@@ -283,7 +283,7 @@ static int tls_strp_read_short(struct tls_strparser *strp)
 	 * to read the data out. Otherwise the connection will stall.
 	 * Without pressure threshold of INT_MAX will never be ready.
 	 */
-	if (likely(!tcp_epollin_ready(strp->sk, INT_MAX)))
+	if (likely(qshort && !tcp_epollin_ready(strp->sk, INT_MAX)))
 		return 0;
 
 	shinfo = skb_shinfo(strp->anchor);
@@ -315,6 +315,27 @@ static int tls_strp_read_short(struct tls_strparser *strp)
 	return 0;
 }
 
+static bool tls_strp_check_no_dup(struct tls_strparser *strp)
+{
+	unsigned int len = strp->stm.offset + strp->stm.full_len;
+	struct sk_buff *skb;
+	u32 seq;
+
+	skb = skb_shinfo(strp->anchor)->frag_list;
+	seq = TCP_SKB_CB(skb)->seq;
+
+	while (skb->len < len) {
+		seq += skb->len;
+		len -= skb->len;
+		skb = skb->next;
+
+		if (TCP_SKB_CB(skb)->seq != seq)
+			return false;
+	}
+
+	return true;
+}
+
 static void tls_strp_load_anchor_with_queue(struct tls_strparser *strp, int len)
 {
 	struct tcp_sock *tp = tcp_sk(strp->sk);
@@ -373,7 +394,7 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 		return tls_strp_read_copyin(strp);
 
 	if (inq < strp->stm.full_len)
-		return tls_strp_read_short(strp);
+		return tls_strp_read_copy(strp, true);
 
 	if (!strp->stm.full_len) {
 		tls_strp_load_anchor_with_queue(strp, inq);
@@ -387,9 +408,12 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 		strp->stm.full_len = sz;
 
 		if (!strp->stm.full_len || inq < strp->stm.full_len)
-			return tls_strp_read_short(strp);
+			return tls_strp_read_copy(strp, true);
 	}
 
+	if (!tls_strp_check_no_dup(strp))
+		return tls_strp_read_copy(strp, false);
+
 	strp->msg_ready = 1;
 	tls_rx_msg_ready(strp);
 
-- 
2.37.3

