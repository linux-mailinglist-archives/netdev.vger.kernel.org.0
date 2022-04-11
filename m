Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914584FC4ED
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiDKTVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239422AbiDKTVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810F61033
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94AA861534
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A338C385AC;
        Mon, 11 Apr 2022 19:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704764;
        bh=terWoSUp0I9AuTy/rdiETBht9HiilqqTwMzTraiOIJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbMNTrrQTAotWDbmg66F3h1vbPTB6SeIG7esdsMVp6ChCGf5av8LUOazdYWUH2Cac
         b43pgbDqsA7IVT4eDpkYYqw+pM2kJvOx4BxfpDn07fetS+aRZ2aXUcIPemvbkvbY3R
         VTE/RqNTZYQuS5TYovGytJd8oW2t2yUlKQdEy+a1DGZPndEzmmOKIqXkPfqDyQNccj
         VUq+Ydf7lmM1hWuUBnpPma62zRGwew2rrVSEk4WQh/H7zi8rwaSJqYuWOrhRYXxICG
         iRs/OaUCSgeMPEzY8XAlJjzflUBLzHTHP0Eld3xOQ9nzNsS/wW1zC6wuNE3wjqwOOD
         P/BZUg4gkra1A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/10] tls: rx: treat process_rx_list() errors as transient
Date:   Mon, 11 Apr 2022 12:19:13 -0700
Message-Id: <20220411191917.1240155-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220411191917.1240155-1-kuba@kernel.org>
References: <20220411191917.1240155-1-kuba@kernel.org>
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

process_rx_list() only fails if it can't copy data to user
space. There is no point recording the error onto sk->sk_err
or giving up on the data which was read partially. Treat
the return value like a normal socket partial read.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fcecf4ef8922..bba69706aea9 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1650,7 +1650,7 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 		err = tls_record_content_type(msg, tlm, control);
 		if (err <= 0)
-			return err;
+			goto out;
 
 		if (skip < rxm->full_len)
 			break;
@@ -1668,13 +1668,13 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 		err = tls_record_content_type(msg, tlm, control);
 		if (err <= 0)
-			return err;
+			goto out;
 
 		if (!zc || (rxm->full_len - skip) > len) {
 			err = skb_copy_datagram_msg(skb, rxm->offset + skip,
 						    msg, chunk);
 			if (err < 0)
-				return err;
+				goto out;
 		}
 
 		len = len - chunk;
@@ -1707,8 +1707,10 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 		skb = next_skb;
 	}
+	err = 0;
 
-	return copied;
+out:
+	return copied ? : err;
 }
 
 int tls_sw_recvmsg(struct sock *sk,
@@ -1747,10 +1749,8 @@ int tls_sw_recvmsg(struct sock *sk,
 
 	/* Process pending decrypted records. It must be non-zero-copy */
 	err = process_rx_list(ctx, msg, &control, 0, len, false, is_peek);
-	if (err < 0) {
-		tls_err_abort(sk, err);
+	if (err < 0)
 		goto end;
-	}
 
 	copied = err;
 	if (len <= copied)
@@ -1902,11 +1902,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      decrypted, true, is_peek);
-		if (err < 0) {
-			tls_err_abort(sk, err);
-			copied = 0;
-			goto end;
-		}
+		decrypted = max(err, 0);
 	}
 
 	copied += decrypted;
-- 
2.34.1

