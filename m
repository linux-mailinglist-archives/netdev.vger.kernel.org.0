Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05274F9CC1
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbiDHSdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbiDHSdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:33:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8E4ED92E
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 852BF6223D
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5C5C385A6;
        Fri,  8 Apr 2022 18:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442698;
        bh=q74vs6GYJNnDwWZQHXVGriTrGanjaMo2sVW/OJ/8D4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPn3eEYTdfvgYX3sxClVFEsn0I/amXs2o61hpUj9KRdlk7iaUMoODNMoN811WBdZW
         i7Wyxe7UJYy5n3OaqG9rhCAXnmiAWtmkXD+veQVI6GKe8lmJGPOcsQ3XK+CJokldBQ
         fYJIEiTPw5cL0dyY9jByxp3C4WVGobRXtUSXUIIrtVeJzIAOf4WeYb4jFFrSemDtXs
         sjY0zbl0KuTv1F/Dmcu0Ib3gC91Gqutcvr23Qrq6tCalRVZgDbgjP/tMWjeOJrb6La
         HNzGKgyn0/pkhNvgLLbRrVXSYS7/2e9PucJpFTdnbcSA8MSjPOIB0geJTjuxosTEGU
         VfZEppWzYTBCA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/11] tls: rx: drop unnecessary arguments from tls_setup_from_iter()
Date:   Fri,  8 Apr 2022 11:31:24 -0700
Message-Id: <20220408183134.1054551-2-kuba@kernel.org>
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

sk is unused, remove it to make it clear the function
doesn't poke at the socket.

size_used is always 0 on input and @length on success.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 3a0a120f9c56..86f77f8b825e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1345,15 +1345,14 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 	return skb;
 }
 
-static int tls_setup_from_iter(struct sock *sk, struct iov_iter *from,
+static int tls_setup_from_iter(struct iov_iter *from,
 			       int length, int *pages_used,
-			       unsigned int *size_used,
 			       struct scatterlist *to,
 			       int to_max_pages)
 {
 	int rc = 0, i = 0, num_elem = *pages_used, maxpages;
 	struct page *pages[MAX_SKB_FRAGS];
-	unsigned int size = *size_used;
+	unsigned int size = 0;
 	ssize_t copied, use;
 	size_t offset;
 
@@ -1396,8 +1395,7 @@ static int tls_setup_from_iter(struct sock *sk, struct iov_iter *from,
 		sg_mark_end(&to[num_elem - 1]);
 out:
 	if (rc)
-		iov_iter_revert(from, size - *size_used);
-	*size_used = size;
+		iov_iter_revert(from, size);
 	*pages_used = num_elem;
 
 	return rc;
@@ -1523,12 +1521,12 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			sg_init_table(sgout, n_sgout);
 			sg_set_buf(&sgout[0], aad, prot->aad_size);
 
-			*chunk = 0;
-			err = tls_setup_from_iter(sk, out_iov, data_len,
-						  &pages, chunk, &sgout[1],
+			err = tls_setup_from_iter(out_iov, data_len,
+						  &pages, &sgout[1],
 						  (n_sgout - 1));
 			if (err < 0)
 				goto fallback_to_reg_recv;
+			*chunk = data_len;
 		} else if (out_sg) {
 			memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
 		} else {
-- 
2.34.1

