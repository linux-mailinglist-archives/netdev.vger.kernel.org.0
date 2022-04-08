Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151024F9CCB
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238759AbiDHSeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiDHSeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:34:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B335EEE4CD
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB2562247
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF69CC385AD;
        Fri,  8 Apr 2022 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442704;
        bh=jZvOuKYXVGHVKDAQXzZ/c+sBFJPdAYysZblbHypCpk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iABrnIFW0+KFhs1AEhPRA6UL4bRXD+y9gBZ+Mp5iFgNVdAtExgdwofr8idjF5yh1M
         YLfxzXu5Ne6RRLdCKKytu7TRWcKkdbXPW4gTC7CfvSvOkRt1QzL7hk3oflgjPMDOHL
         2JEwiQYlT0gPUyspnSaH52KrVhsO/2usMbYTs0wysCPjPYMzBddJkuNSeFJoqANYsm
         AJFrkNM1W2xs+WLZsQ1e5G7I6CA6I4oj3VIWKPLf8AfEmHSGLr7VMetrpBU6f0mudH
         fwhC2Ovo9Wv77mak1GnpdoVTlBofDx3xpLA7Vg7WF6RJzHVXeTVQFVCnxu8pfT2MzU
         pYNI4rqh2dfVQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/11] tls: rx: jump out for cases which need to leave skb on list
Date:   Fri,  8 Apr 2022 11:31:34 -0700
Message-Id: <20220408183134.1054551-12-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408183134.1054551-1-kuba@kernel.org>
References: <20220408183134.1054551-1-kuba@kernel.org>
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

The current invese logic is harder to follow (and adds extra
tests to the fast path). We have to enumerate all cases which
need to keep the skb before consuming it. It's simpler to
jump out of the full record flow as we detect those cases.

This makes it clear that partial consumption and peek can
only reach end of the function thru the !zc case so move
the code up there.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 71d8082647c8..2e8a896af81a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1773,7 +1773,6 @@ int tls_sw_recvmsg(struct sock *sk,
 	decrypted = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		struct tls_decrypt_arg darg = {};
-		bool retain_skb = false;
 		int to_decrypt, chunk;
 
 		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
@@ -1833,12 +1832,17 @@ int tls_sw_recvmsg(struct sock *sk,
 		if (async) {
 			/* TLS 1.2-only, to_decrypt must be text length */
 			chunk = min_t(int, to_decrypt, len);
-			goto pick_next_record;
+leave_on_list:
+			decrypted += chunk;
+			len -= chunk;
+			continue;
 		}
 		/* TLS 1.3 may have updated the length by more than overhead */
 		chunk = rxm->full_len;
 
 		if (!darg.zc) {
+			bool partially_consumed = chunk > len;
+
 			if (bpf_strp_enabled) {
 				err = sk_psock_tls_strp_read(psock, skb);
 				if (err != __SK_PASS) {
@@ -1851,39 +1855,36 @@ int tls_sw_recvmsg(struct sock *sk,
 				}
 			}
 
-			if (chunk > len) {
-				retain_skb = true;
+			if (partially_consumed)
 				chunk = len;
-			}
 
 			err = skb_copy_datagram_msg(skb, rxm->offset,
 						    msg, chunk);
 			if (err < 0)
 				goto recv_end;
 
-			if (!is_peek) {
-				rxm->offset = rxm->offset + chunk;
-				rxm->full_len = rxm->full_len - chunk;
+			if (is_peek)
+				goto leave_on_list;
+
+			if (partially_consumed) {
+				rxm->offset += chunk;
+				rxm->full_len -= chunk;
+				goto leave_on_list;
 			}
 		}
 
-pick_next_record:
 		decrypted += chunk;
 		len -= chunk;
 
-		/* For async or peek case, queue the current skb */
-		if (!(async || is_peek || retain_skb)) {
-			skb_unlink(skb, &ctx->rx_list);
-			consume_skb(skb);
+		skb_unlink(skb, &ctx->rx_list);
+		consume_skb(skb);
 
-			/* Return full control message to
-			 * userspace before trying to parse
-			 * another message type
-			 */
-			msg->msg_flags |= MSG_EOR;
-			if (control != TLS_RECORD_TYPE_DATA)
-				goto recv_end;
-		}
+		/* Return full control message to userspace before trying
+		 * to parse another message type
+		 */
+		msg->msg_flags |= MSG_EOR;
+		if (control != TLS_RECORD_TYPE_DATA)
+			break;
 	}
 
 recv_end:
-- 
2.34.1

