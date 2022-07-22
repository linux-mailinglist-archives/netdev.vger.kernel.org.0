Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7235B57EA73
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 01:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiGVXuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 19:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236488AbiGVXus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 19:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98973BB5F4
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 16:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33B94622B8
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 23:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BB5C341CF;
        Fri, 22 Jul 2022 23:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658533845;
        bh=CPZieBpAiOC2mR2PxjbcpgvGuqJTENxSQn1a0u09D6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0zM/v/pzF5ndsWpudEzwSKNgtHDYVLiwY/8tBZvPEVRlVshMiYip4JSVKPwKSeZ0
         /G3LhqSoxg+UeNN/LSnVqLSIwsYGLdFQKgo+dez8QphVeDNosQZ9/k06UUbTLpwlJ6
         y7veXUZV+sQ22keDMUN++nhZD0SS6haYQYp5eRsfLk9Ub66M+eD1bgC70JKhM4k6pA
         YQ4orR/x2Cf1ArdBLyfMQpCdoB5L43LDIS1GlJGiOgBLwV4TRli1QtANQ1EmcW5imm
         Ua6qR+eY1PQzccp4Msn2bI68H5E7k277oEmt0YFrpnkZoWdBKxiexrNCE4brsfWgnG
         Lkhiw5TNfmXig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 6/7] tls: rx: device: add input CoW helper
Date:   Fri, 22 Jul 2022 16:50:32 -0700
Message-Id: <20220722235033.2594446-7-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722235033.2594446-1-kuba@kernel.org>
References: <20220722235033.2594446-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrap the remaining skb_cow_data() into a helper, so it's easier
to replace down the lane. The new version will change the skb
so make sure relevant pointers get reloaded after the call.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
---
 net/tls/tls.h        |  1 +
 net/tls/tls_device.c | 19 +++++++++----------
 net/tls/tls_strp.c   | 11 +++++++++++
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 78c5d699bf75..154a3773e785 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -127,6 +127,7 @@ int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_offload_context_tx *offload_ctx,
 			 struct tls_crypto_info *crypto_info);
 
+int tls_strp_msg_cow(struct tls_sw_context_rx *ctx);
 struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx);
 int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
 		      struct sk_buff_head *dst);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b1fcd61836d1..fc513c1806a0 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -894,27 +894,26 @@ static void tls_device_core_ctrl_rx_resync(struct tls_context *tls_ctx,
 static int
 tls_device_reencrypt(struct sock *sk, struct tls_sw_context_rx *sw_ctx)
 {
-	int err = 0, offset, copy, nsg, data_len, pos;
-	struct sk_buff *skb, *skb_iter, *unused;
+	int err, offset, copy, data_len, pos;
+	struct sk_buff *skb, *skb_iter;
 	struct scatterlist sg[1];
 	struct strp_msg *rxm;
 	char *orig_buf, *buf;
 
-	skb = tls_strp_msg(sw_ctx);
-	rxm = strp_msg(skb);
-	offset = rxm->offset;
-
+	rxm = strp_msg(tls_strp_msg(sw_ctx));
 	orig_buf = kmalloc(rxm->full_len + TLS_HEADER_SIZE +
 			   TLS_CIPHER_AES_GCM_128_IV_SIZE, sk->sk_allocation);
 	if (!orig_buf)
 		return -ENOMEM;
 	buf = orig_buf;
 
-	nsg = skb_cow_data(skb, 0, &unused);
-	if (unlikely(nsg < 0)) {
-		err = nsg;
+	err = tls_strp_msg_cow(sw_ctx);
+	if (unlikely(err))
 		goto free_buf;
-	}
+
+	skb = tls_strp_msg(sw_ctx);
+	rxm = strp_msg(skb);
+	offset = rxm->offset;
 
 	sg_init_table(sg, 1);
 	sg_set_buf(&sg[0], buf,
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 40b177366121..d9bb4f23f01a 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -13,6 +13,17 @@ struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx)
 	return skb;
 }
 
+int tls_strp_msg_cow(struct tls_sw_context_rx *ctx)
+{
+	struct sk_buff *unused;
+	int nsg;
+
+	nsg = skb_cow_data(ctx->recv_pkt, 0, &unused);
+	if (nsg < 0)
+		return nsg;
+	return 0;
+}
+
 int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
 		      struct sk_buff_head *dst)
 {
-- 
2.37.1

