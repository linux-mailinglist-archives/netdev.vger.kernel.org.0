Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74B46BC321
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCPBKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCPBKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:31 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49E64E5F4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:29 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5447558ae68so808357b3.13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T+fJT8slP+tfHRMvjiOBu/t1pFKBGMNeUyL0vphuXOA=;
        b=myy7QaxblKSO4HO5SXFgRXhdg+lyfUS2d2G+ZlcgvrZdRmvD1J4biEof8I8TUCqUwA
         TitQ9eZIiTYhouBCDTkBjYyXluKWh4XQvXO/AI92QunFGxW3cChiRJywhm+QqthyU7hT
         2Eo+pvRHTxOd9aU0X5nW69uq3Ud9I9a6j/Gqg0sqwz+i67nloi1MS7y8/j6NkNI0pK1b
         qCNPUsWxr3JnE3rsZ75EcXhXPQl1GC9jsWtgacmtxqvTObQfoVFuHzrvPwxhP5Inajkt
         RfL7vUidXa6vbfbT2LLfclef34SZ5cHaS3a3+fXrhAHD688za+GwhRwVyMm6fRj3G/W4
         Hggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T+fJT8slP+tfHRMvjiOBu/t1pFKBGMNeUyL0vphuXOA=;
        b=iCTXjHI65vV5i4hAj5drz/ivcKYVYs1u4YI3cfzw9PWciLiVFMe8Nl3RHIpVnpN2q4
         tf2waYFtoZfXD7L1fljzdLREozH0T+xWeQGkW33jxkhG1zeFLgcERmEtVRLSxvUvqJ82
         9jgYlW9VkhDIqmLOJFhAqjOA9NvnSvviNekb8zS3FTyM0kqYFAzpiB1crfL03b/OxnE2
         4gZdjoMWYTmbSk5GO7WhrJO3WHoCxGyOhVGe6UN3JtXyz430s869k50n0EiFKOfGWAVa
         HG++xCXubvwAmTQQgk8yXYiLxfgM0jl9dQMPlf0sVj7gcPSo5uN8hrIclA43ThA9+TlU
         3bng==
X-Gm-Message-State: AO0yUKVaHUGyOCyC3XWxC3N2X7P/QlvaJMeo0Uzkq3LP8M86fA+4b9EY
        zfjNxSstIWnfxyejXzFILJWUDuKsw/FqVg==
X-Google-Smtp-Source: AK7set+y8f6Kk8TZrO+2+APAqylwAsFRVwzetGWRWr+Eg4LX9I8CjmWlhn1oiytMm+Zd0N8mKgWd8buSBvOzuQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:2cc:0:b0:a02:a3a6:78fa with SMTP id
 h12-20020a5b02cc000000b00a02a3a678famr21549868ybp.12.1678929028901; Wed, 15
 Mar 2023 18:10:28 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:10 +0000
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-6-edumazet@google.com>
Subject: [PATCH net-next 5/9] net/packet: convert po->tp_tx_has_off to an
 atomic flag
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to use existing space in po->flags, and reclaim
the storage used by the non atomic bit fields.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 6 +++---
 net/packet/internal.h  | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a27a811fa2b0d0b267cf42d5b411503587e2dccb..7800dc622ff37d059e43c96d2d7f293905b3d5af 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2672,7 +2672,7 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
 		return -EMSGSIZE;
 	}
 
-	if (unlikely(po->tp_tx_has_off)) {
+	if (unlikely(packet_sock_flag(po, PACKET_SOCK_TX_HAS_OFF))) {
 		int off_min, off_max;
 
 		off_min = po->tp_hdrlen - sizeof(struct sockaddr_ll);
@@ -3993,7 +3993,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 
 		lock_sock(sk);
 		if (!po->rx_ring.pg_vec && !po->tx_ring.pg_vec)
-			po->tp_tx_has_off = !!val;
+			packet_sock_flag_set(po, PACKET_SOCK_TX_HAS_OFF, val);
 
 		release_sock(sk);
 		return 0;
@@ -4120,7 +4120,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 		lv = sizeof(rstats);
 		break;
 	case PACKET_TX_HAS_OFF:
-		val = po->tp_tx_has_off;
+		val = packet_sock_flag(po, PACKET_SOCK_TX_HAS_OFF);
 		break;
 	case PACKET_QDISC_BYPASS:
 		val = packet_use_direct_xmit(po);
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 3bae8ea7a36f523d554177acfb6b6e960ba6965c..0d16a581e27132988942bcc71da223f7c30ac00c 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -119,8 +119,7 @@ struct packet_sock {
 	unsigned long		flags;
 	unsigned int		running;	/* bind_lock must be held */
 	unsigned int		has_vnet_hdr:1, /* writer must hold sock lock */
-				tp_loss:1,
-				tp_tx_has_off:1;
+				tp_loss:1;
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
@@ -146,6 +145,7 @@ static inline struct packet_sock *pkt_sk(struct sock *sk)
 enum packet_sock_flags {
 	PACKET_SOCK_ORIGDEV,
 	PACKET_SOCK_AUXDATA,
+	PACKET_SOCK_TX_HAS_OFF,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.40.0.rc2.332.ga46443480c-goog

