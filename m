Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3B34F8E2E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiDHDks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiDHDkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6596B093
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEAE5B829B7
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EC3C385A4;
        Fri,  8 Apr 2022 03:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389110;
        bh=4PqtN1XfJEydeNfSgyQOGSLlKZe62/pVltl+vZ22sOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHWh8vwG4BASnV4ynzj63cwBiz1tonDmJFDhVrJGu6Aw/i0ihbHAGEZtPRO5Idl7o
         tIuy/Kff5InlAOAr4/WzkGDdKLJzcV3jGViATdpdJwO/q+Cw5CpgrPC+M4ghF4Wh81
         qqFNlL9aapF8bAAdu8YbSr0l6kqCUPDZNuZ/+xMxamNXnRa9dzMJjCwpzWBzXHEc/x
         UKoQiA7T5QsQeXnXM6pyfohcTtOHg8Vw47865i3W90icusdn55KB4ccqYRqajT7GS6
         JF2QqKMYJxUBI/iNHhOYQX/sEVA/HNbIcJf5VHMuP9VqOn36lkXVTMcELdydvoCszJ
         wo/lBq1PyLg9g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/10] tls: rx: refactor decrypt_skb_update()
Date:   Thu,  7 Apr 2022 20:38:22 -0700
Message-Id: <20220408033823.965896-10-kuba@kernel.org>
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

Use early return and a jump label to remove two indentation levels.
No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 66 ++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1f6bb1f67f41..d6ac9deede7b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1564,46 +1564,46 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm = strp_msg(skb);
 	struct tls_msg *tlm = tls_msg(skb);
-	int pad, err = 0;
+	int pad, err;
 
-	if (!tlm->decrypted) {
-		if (tls_ctx->rx_conf == TLS_HW) {
-			err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
-			if (err < 0)
-				return err;
-		}
+	if (tlm->decrypted) {
+		*zc = false;
+		return 0;
+	}
 
-		/* Still not decrypted after tls_device */
-		if (!tlm->decrypted) {
-			err = decrypt_internal(sk, skb, dest, NULL, chunk, zc,
-					       async);
-			if (err < 0) {
-				if (err == -EINPROGRESS)
-					tls_advance_record_sn(sk, prot,
-							      &tls_ctx->rx);
-				else if (err == -EBADMSG)
-					TLS_INC_STATS(sock_net(sk),
-						      LINUX_MIB_TLSDECRYPTERROR);
-				return err;
-			}
-		} else {
+	if (tls_ctx->rx_conf == TLS_HW) {
+		err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
+		if (err < 0)
+			return err;
+
+		/* skip SW decryption if NIC handled it already */
+		if (tlm->decrypted) {
 			*zc = false;
+			goto decrypt_done;
 		}
+	}
 
-		pad = padding_length(prot, skb);
-		if (pad < 0)
-			return pad;
-
-		rxm->full_len -= pad;
-		rxm->offset += prot->prepend_size;
-		rxm->full_len -= prot->overhead_size;
-		tls_advance_record_sn(sk, prot, &tls_ctx->rx);
-		tlm->decrypted = 1;
-	} else {
-		*zc = false;
+	err = decrypt_internal(sk, skb, dest, NULL, chunk, zc, async);
+	if (err < 0) {
+		if (err == -EINPROGRESS)
+			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
+		else if (err == -EBADMSG)
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
+		return err;
 	}
 
-	return err;
+decrypt_done:
+	pad = padding_length(prot, skb);
+	if (pad < 0)
+		return pad;
+
+	rxm->full_len -= pad;
+	rxm->offset += prot->prepend_size;
+	rxm->full_len -= prot->overhead_size;
+	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
+	tlm->decrypted = 1;
+
+	return 0;
 }
 
 int decrypt_skb(struct sock *sk, struct sk_buff *skb,
-- 
2.34.1

