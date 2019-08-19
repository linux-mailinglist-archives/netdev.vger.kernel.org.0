Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D486925D4
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfHSODu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:03:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43501 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfHSODu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:03:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id v12so1223351pfn.10;
        Mon, 19 Aug 2019 07:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=dipR06voHv+s7XI6xdTCBYin6/sC/Hg4a9F6v4EVXe0=;
        b=glJ/0bIA/n43mfNAZA4nAMDSxOTlLzHwj00WNXtfxYEZgorVqo5jXRFUZfx2rcK/hs
         gq1jSfbd/T2jJPhdJejpeSjwr/6UHl854bDU+eM6flumMG+X3sm1Vqg/We/w61F8yeTz
         vzSvTvSmZO6csCnYC7IU14eQ9sFyjROvRCHR6CoFBIcH6UP9IiHt8NKbI3FRmsUT4ovS
         flRk0mMbhr+4a7RpFtAnwKAZ2ezAZnfpLYW848ZTGVxV4VXSwOfPEfeVhNCM6Ms/yhrC
         v4Zy1Q6IvSg2wDlANTO4nv00tJBpmhbxDuVVL+4Aji2Xql8VKeD9fWPz+00KwYk8jYfF
         fd8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=dipR06voHv+s7XI6xdTCBYin6/sC/Hg4a9F6v4EVXe0=;
        b=po2F4blmVpDpB5P5NGd9rEGgMAjlDp0bN2KrjtFjccXxlJwP/BBO4/srBVnsVrDJxZ
         EhCY+UPmo6oUP8CviXnKZrGS4nab4XM8Izwf1cxxJoFR01HpkNqYpz28sr8xEwg3vaJw
         /ztngwiOfuVE5TutyqgFkp7x1XNkRDXszpTYtIOBv85G0XAUkaea/cbCxoMwAnkw1aq1
         bV7LSBitqz3t/nxTEbjMfqj3ox9ypGiN+48aCJcgYWVeDI9k4J7jy3syGn0TcfsL/brf
         byoonCrBlMUgbawMiJ7iqFQvlsdqCFJzDC8kp8E9JP8D2ZEvJCiRCQl0mDoD+ua13hzu
         aaxw==
X-Gm-Message-State: APjAAAWNbMKQFhYkOE24TD4LjZ6PhSNm69tFXFgDphd9QbUxi2cIPcrW
        yxEBWFLo/3H3RxJ05UBLleQxwdS01OQ=
X-Google-Smtp-Source: APXvYqzQvoYEZL/zKgDuVQaDX52Wccv1hd6oas65QEdC0jMGYPKe6smEEfUGJ8kEhnJJh6ckvP3KQQ==
X-Received: by 2002:a17:90a:c403:: with SMTP id i3mr20066132pjt.110.1566223428919;
        Mon, 19 Aug 2019 07:03:48 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 4sm8339705pfe.76.2019.08.19.07.03.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:03:48 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 6/8] sctp: add sctp_auth_init and sctp_auth_free
Date:   Mon, 19 Aug 2019 22:02:48 +0800
Message-Id: <a2e37d8eb5b502e747eca1951e21c3d249bacf06.1566223325.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <db032735abcb20ea14637fa610b9f95fa2710abb.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
 <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
 <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
 <db032735abcb20ea14637fa610b9f95fa2710abb.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to factor out sctp_auth_init and sctp_auth_free
functions, and sctp_auth_init will also be used in the next
patch for SCTP_AUTH_SUPPORTED sockopt.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/auth.h |  2 ++
 net/sctp/auth.c         | 69 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/sctp/endpointola.c  | 61 ++++---------------------------------------
 3 files changed, 76 insertions(+), 56 deletions(-)

diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
index caaae2d..d4b3b2d 100644
--- a/include/net/sctp/auth.h
+++ b/include/net/sctp/auth.h
@@ -107,5 +107,7 @@ int sctp_auth_del_key_id(struct sctp_endpoint *ep,
 			 struct sctp_association *asoc, __u16 key_id);
 int sctp_auth_deact_key_id(struct sctp_endpoint *ep,
 			   struct sctp_association *asoc, __u16 key_id);
+int sctp_auth_init(struct sctp_endpoint *ep, gfp_t gfp);
+void sctp_auth_free(struct sctp_endpoint *ep);
 
 #endif
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 61b0090..4278764 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -1007,3 +1007,72 @@ int sctp_auth_deact_key_id(struct sctp_endpoint *ep,
 
 	return 0;
 }
+
+int sctp_auth_init(struct sctp_endpoint *ep, gfp_t gfp)
+{
+	int err = -ENOMEM;
+
+	/* Allocate space for HMACS and CHUNKS authentication
+	 * variables.  There are arrays that we encode directly
+	 * into parameters to make the rest of the operations easier.
+	 */
+	if (!ep->auth_hmacs_list) {
+		struct sctp_hmac_algo_param *auth_hmacs;
+
+		auth_hmacs = kzalloc(struct_size(auth_hmacs, hmac_ids,
+						 SCTP_AUTH_NUM_HMACS), gfp);
+		if (!auth_hmacs)
+			goto nomem;
+		/* Initialize the HMACS parameter.
+		 * SCTP-AUTH: Section 3.3
+		 *    Every endpoint supporting SCTP chunk authentication MUST
+		 *    support the HMAC based on the SHA-1 algorithm.
+		 */
+		auth_hmacs->param_hdr.type = SCTP_PARAM_HMAC_ALGO;
+		auth_hmacs->param_hdr.length =
+				htons(sizeof(struct sctp_paramhdr) + 2);
+		auth_hmacs->hmac_ids[0] = htons(SCTP_AUTH_HMAC_ID_SHA1);
+		ep->auth_hmacs_list = auth_hmacs;
+	}
+
+	if (!ep->auth_chunk_list) {
+		struct sctp_chunks_param *auth_chunks;
+
+		auth_chunks = kzalloc(sizeof(*auth_chunks) +
+				      SCTP_NUM_CHUNK_TYPES, gfp);
+		if (!auth_chunks)
+			goto nomem;
+		/* Initialize the CHUNKS parameter */
+		auth_chunks->param_hdr.type = SCTP_PARAM_CHUNKS;
+		auth_chunks->param_hdr.length =
+				htons(sizeof(struct sctp_paramhdr));
+		ep->auth_chunk_list = auth_chunks;
+	}
+
+	/* Allocate and initialize transorms arrays for supported
+	 * HMACs.
+	 */
+	err = sctp_auth_init_hmacs(ep, gfp);
+	if (err)
+		goto nomem;
+
+	return 0;
+
+nomem:
+	/* Free all allocations */
+	kfree(ep->auth_hmacs_list);
+	kfree(ep->auth_chunk_list);
+	ep->auth_hmacs_list = NULL;
+	ep->auth_chunk_list = NULL;
+	return err;
+}
+
+void sctp_auth_free(struct sctp_endpoint *ep)
+{
+	kfree(ep->auth_hmacs_list);
+	kfree(ep->auth_chunk_list);
+	ep->auth_hmacs_list = NULL;
+	ep->auth_chunk_list = NULL;
+	sctp_auth_destroy_hmacs(ep->auth_hmacs);
+	ep->auth_hmacs = NULL;
+}
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 38b8d7c..75a407d 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -43,10 +43,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 						gfp_t gfp)
 {
 	struct net *net = sock_net(sk);
-	struct sctp_hmac_algo_param *auth_hmacs = NULL;
-	struct sctp_chunks_param *auth_chunks = NULL;
 	struct sctp_shared_key *null_key;
-	int err;
 
 	ep->digest = kzalloc(SCTP_SIGNATURE_SIZE, gfp);
 	if (!ep->digest)
@@ -55,51 +52,12 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	ep->asconf_enable = net->sctp.addip_enable;
 	ep->auth_enable = net->sctp.auth_enable;
 	if (ep->auth_enable) {
-		/* Allocate space for HMACS and CHUNKS authentication
-		 * variables.  There are arrays that we encode directly
-		 * into parameters to make the rest of the operations easier.
-		 */
-		auth_hmacs = kzalloc(struct_size(auth_hmacs, hmac_ids,
-						 SCTP_AUTH_NUM_HMACS), gfp);
-		if (!auth_hmacs)
-			goto nomem;
-
-		auth_chunks = kzalloc(sizeof(*auth_chunks) +
-				      SCTP_NUM_CHUNK_TYPES, gfp);
-		if (!auth_chunks)
+		if (sctp_auth_init(ep, gfp))
 			goto nomem;
-
-		/* Initialize the HMACS parameter.
-		 * SCTP-AUTH: Section 3.3
-		 *    Every endpoint supporting SCTP chunk authentication MUST
-		 *    support the HMAC based on the SHA-1 algorithm.
-		 */
-		auth_hmacs->param_hdr.type = SCTP_PARAM_HMAC_ALGO;
-		auth_hmacs->param_hdr.length =
-					htons(sizeof(struct sctp_paramhdr) + 2);
-		auth_hmacs->hmac_ids[0] = htons(SCTP_AUTH_HMAC_ID_SHA1);
-
-		/* Initialize the CHUNKS parameter */
-		auth_chunks->param_hdr.type = SCTP_PARAM_CHUNKS;
-		auth_chunks->param_hdr.length =
-					htons(sizeof(struct sctp_paramhdr));
-
-		/* If the Add-IP functionality is enabled, we must
-		 * authenticate, ASCONF and ASCONF-ACK chunks
-		 */
 		if (ep->asconf_enable) {
-			auth_chunks->chunks[0] = SCTP_CID_ASCONF;
-			auth_chunks->chunks[1] = SCTP_CID_ASCONF_ACK;
-			auth_chunks->param_hdr.length =
-					htons(sizeof(struct sctp_paramhdr) + 2);
+			sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
+			sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
 		}
-
-		/* Allocate and initialize transorms arrays for supported
-		 * HMACs.
-		 */
-		err = sctp_auth_init_hmacs(ep, gfp);
-		if (err)
-			goto nomem;
 	}
 
 	/* Initialize the base structure. */
@@ -146,8 +104,6 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	/* Add the null key to the endpoint shared keys list and
 	 * set the hmcas and chunks pointers.
 	 */
-	ep->auth_hmacs_list = auth_hmacs;
-	ep->auth_chunk_list = auth_chunks;
 	ep->prsctp_enable = net->sctp.prsctp_enable;
 	ep->reconf_enable = net->sctp.reconf_enable;
 
@@ -158,11 +114,8 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	return ep;
 
 nomem_shkey:
-	sctp_auth_destroy_hmacs(ep->auth_hmacs);
+	sctp_auth_free(ep);
 nomem:
-	/* Free all allocations */
-	kfree(auth_hmacs);
-	kfree(auth_chunks);
 	kfree(ep->digest);
 	return NULL;
 
@@ -245,11 +198,7 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 	 * chunks and hmacs arrays that were allocated
 	 */
 	sctp_auth_destroy_keys(&ep->endpoint_shared_keys);
-	kfree(ep->auth_hmacs_list);
-	kfree(ep->auth_chunk_list);
-
-	/* AUTH - Free any allocated HMAC transform containers */
-	sctp_auth_destroy_hmacs(ep->auth_hmacs);
+	sctp_auth_free(ep);
 
 	/* Cleanup. */
 	sctp_inq_free(&ep->base.inqueue);
-- 
2.1.0

