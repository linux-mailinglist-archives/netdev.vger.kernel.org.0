Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08CD5741E5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiGNDdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiGNDdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:33:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB3225EA0
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9780361E29
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A654CC341CF;
        Thu, 14 Jul 2022 03:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657769599;
        bh=IbMjb3lRE6PXcU8FS4J/TgPYLQb6KEgXIusxOGc8KpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEWnXbhf4FnlRDapeXVZ+Ck2+bJ0PDSMoU9Vgn0ANCG3i1MjcB+j3NbC5J9RwjbfK
         XH30k/286LP9idMbtLeDJ8ui5vQ9+g98yQh/fgMsjuW+5oyv7UBmIZGFFU+UeDx3ta
         KA0TdV5A6Fz52GahRaJlrQJxwsIJ3zW3vYIt6aRGeDh7cOTe2LssxWnTQrjC0BwX0p
         WgU2tza2K7twmDiHAnDMH24eDPh/HSzEwCU8A1gUJ1YQ268I+zBMfyCaOH0RoZaEj4
         dmrNvld07pnyK9Aj3qu6kMAeDC+iJzBFcam0FSzkJHUeLoqaNVd4yKjq2dkH1sBAYL
         u5kV9IUkoRucw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/11] tls: rx: remove the message decrypted tracking
Date:   Wed, 13 Jul 2022 20:33:03 -0700
Message-Id: <20220714033310.1273288-5-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220714033310.1273288-1-kuba@kernel.org>
References: <20220714033310.1273288-1-kuba@kernel.org>
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

We no longer allow a decrypted skb to remain linked to ctx->recv_pkt.
Anything on the list is decrypted, anything on ctx->recv_pkt needs
to be decrypted.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/strparser.h |  1 -
 net/tls/tls_sw.c        | 10 ----------
 2 files changed, 11 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index 88900b05443e..41e2ce9e9e10 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -72,7 +72,6 @@ struct sk_skb_cb {
 	/* strp users' data follows */
 	struct tls_msg {
 		u8 control;
-		u8 decrypted;
 	} tls;
 	/* temp_reg is a temporary register used for bpf_convert_data_end_access
 	 * when dst_reg == src_reg.
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f5f06d1ba024..49cfaa8119c6 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1563,21 +1563,13 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm = strp_msg(skb);
-	struct tls_msg *tlm = tls_msg(skb);
 	int pad, err;
 
-	if (tlm->decrypted) {
-		darg->zc = false;
-		darg->async = false;
-		return 0;
-	}
-
 	if (tls_ctx->rx_conf == TLS_HW) {
 		err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
 		if (err < 0)
 			return err;
 		if (err > 0) {
-			tlm->decrypted = 1;
 			darg->zc = false;
 			darg->async = false;
 			goto decrypt_done;
@@ -1610,7 +1602,6 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	rxm->full_len -= pad;
 	rxm->offset += prot->prepend_size;
 	rxm->full_len -= prot->overhead_size;
-	tlm->decrypted = 1;
 decrypt_next:
 	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 
@@ -2130,7 +2121,6 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 	if (ret < 0)
 		goto read_failure;
 
-	tlm->decrypted = 0;
 	tlm->control = header[0];
 
 	data_len = ((header[4] & 0xFF) | (header[3] << 8));
-- 
2.36.1

