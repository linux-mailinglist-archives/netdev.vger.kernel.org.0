Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AEF575ADF
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiGOFWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGOFWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:22:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3E4796A2
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FB6062266
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E7AC34115;
        Fri, 15 Jul 2022 05:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657862563;
        bh=94QZRYo3EF3vDayeSGDrOHWCvKXA6TtzmN7HIivrV9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpLWAelp5bl9CaA1MaEaHJkd6s2JvCg+M6G0wV+DheB+ZBzn6D5s/RyTlX4LSpsuX
         7+G2UNTzkYyeCv2Goh27aJGxRlNb12t0fnm6M27/4Zzq1UPq9oCqMfsp/t5Vc+XLuf
         c7HLfpxzxZWCe6Rf2s3XZBt2x0Xrysa26iO1tNsqpWg6nnjZExDWEolwRJrZRwe7Xv
         kre+TvT72VC3OU9HOv4s1b1Nl/vq05gHrLsVFMnZfnwVmfZaePyuMVFfePYJcD84vO
         ivLQQ/cfN0b/S1rvdczgi+8CDs6LHD7I2Ppq5TyZ/dSQdD/6Rn7N9NFMmkgCbAjWXS
         2OfUG/XU1XA8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 02/11] tls: rx: don't try to keep the skbs always on the list
Date:   Thu, 14 Jul 2022 22:22:26 -0700
Message-Id: <20220715052235.1452170-3-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220715052235.1452170-1-kuba@kernel.org>
References: <20220715052235.1452170-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I thought that having the skb either always on the ctx->rx_list
or ctx->recv_pkt will simplify the handling, as we would not
have to remember to flip it from one to the other on exit paths.

This became a little harder to justify with the fix for BPF
sockmaps. Subsequent changes will make the situation even worse.
Queue the skbs only when really needed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 761a63751616..acf65992aaca 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1861,8 +1861,11 @@ int tls_sw_recvmsg(struct sock *sk,
 			if (psock) {
 				chunk = sk_msg_recvmsg(sk, psock, msg, len,
 						       flags);
-				if (chunk > 0)
-					goto leave_on_list;
+				if (chunk > 0) {
+					decrypted += chunk;
+					len -= chunk;
+					continue;
+				}
 			}
 			goto recv_end;
 		}
@@ -1908,14 +1911,14 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		ctx->recv_pkt = NULL;
 		__strp_unpause(&ctx->strp);
-		__skb_queue_tail(&ctx->rx_list, skb);
 
 		if (async) {
 			/* TLS 1.2-only, to_decrypt must be text length */
 			chunk = min_t(int, to_decrypt, len);
-leave_on_list:
+put_on_rx_list:
 			decrypted += chunk;
 			len -= chunk;
+			__skb_queue_tail(&ctx->rx_list, skb);
 			continue;
 		}
 		/* TLS 1.3 may have updated the length by more than overhead */
@@ -1925,8 +1928,6 @@ int tls_sw_recvmsg(struct sock *sk,
 			bool partially_consumed = chunk > len;
 
 			if (bpf_strp_enabled) {
-				/* BPF may try to queue the skb */
-				__skb_unlink(skb, &ctx->rx_list);
 				err = sk_psock_tls_strp_read(psock, skb);
 				if (err != __SK_PASS) {
 					rxm->offset = rxm->offset + rxm->full_len;
@@ -1935,7 +1936,6 @@ int tls_sw_recvmsg(struct sock *sk,
 						consume_skb(skb);
 					continue;
 				}
-				__skb_queue_tail(&ctx->rx_list, skb);
 			}
 
 			if (partially_consumed)
@@ -1943,23 +1943,24 @@ int tls_sw_recvmsg(struct sock *sk,
 
 			err = skb_copy_datagram_msg(skb, rxm->offset,
 						    msg, chunk);
-			if (err < 0)
+			if (err < 0) {
+				__skb_queue_tail(&ctx->rx_list, skb);
 				goto recv_end;
+			}
 
 			if (is_peek)
-				goto leave_on_list;
+				goto put_on_rx_list;
 
 			if (partially_consumed) {
 				rxm->offset += chunk;
 				rxm->full_len -= chunk;
-				goto leave_on_list;
+				goto put_on_rx_list;
 			}
 		}
 
 		decrypted += chunk;
 		len -= chunk;
 
-		__skb_unlink(skb, &ctx->rx_list);
 		consume_skb(skb);
 
 		/* Return full control message to userspace before trying
-- 
2.36.1

