Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C046C3749
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjCUQpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjCUQpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:45:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2270552903
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:45:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j125-20020a25d283000000b008f257b16d71so16735824ybg.15
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679417123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=150wRO08s2ATfCW4AgI9VYuct0r7Ly5wfxjYkBgD/v0=;
        b=Z4CoQqjJm7fqU5/72mgPEe9YCFkvPpmuruPXPpq5NQ/cGAew5xGTjviofZQT0ztMM/
         6BrFWcZQ3spx0fI2wTGmErZc2+UzDKAsMyf1KUjOzzgPjBcvnW29hzLsFIUSlD+Q1vQ3
         lPOAmYUZ+Y0YB7jdjo94kTLJU+lod9M+nrRpxkZQwoStAc+foJgmTWmlwiFd6uxd2ODo
         lFeTIziRaqVIFcIIg1IxNhWqvF6pMdSz0TJnUj2nR32qVQYQuVvpCqvn1tWuBRu4g+TU
         6J0A1gWFPe2gsHG1kHiIpsCVDPl0nFDQyIA2Kb1FlfuUwwcGhWIfmuh4KDPEW66Bk92j
         cxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679417123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=150wRO08s2ATfCW4AgI9VYuct0r7Ly5wfxjYkBgD/v0=;
        b=C7uyzO4kmIEeOcX25Z/6o8mDYzYPG4D7VNvnPmBjAgePbYScZ8pLEVfgx0qMj629jU
         UsRWFcdDSsJRj4bB2Ru3Nvi3HwQRP6avvFhA+BMLZ5MHRpKhG4+uA8rjHCXSEtfTHXkD
         2nsppaSN0pINbu9gkYb2l1FEi+3lQhocSwyjJ4Z2CvlLVUP2iLzo+s7gbdl9Gwd6D5/r
         vkGg+7N8FtRz0V1JKkHce6em9A1FKhBgmRINi11JNB8iaXfUrZ766BjcmRCoL4dIxLY+
         61ktP49TSn16RyWgCod8Kv/zrIRuF4tJ2PwPP/ic7XxL81taAXPL6s9V2HbktLJ6jRQ1
         6+eQ==
X-Gm-Message-State: AAQBX9eXKSp2nFIp5OisNWR4kmfh9uvJxcjzVfEeM/y4ZjHIC/CzTdxN
        nPuSkQdL5FFwuvI9+qpVgw8hDH+3pfSPnQ==
X-Google-Smtp-Source: AKy350b2k+fYzzbKghnqlTq6R/NNl+wn1w5U9wGEwnE86BxNalo1Teo2ijwoE5wDIO9Fbsn4JZRcIhMiFJSb4g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:4326:0:b0:536:38b4:f50 with SMTP id
 q38-20020a814326000000b0053638b40f50mr1501754ywa.1.1679417123127; Tue, 21 Mar
 2023 09:45:23 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:45:17 +0000
In-Reply-To: <20230321164519.1286357-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230321164519.1286357-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321164519.1286357-2-edumazet@google.com>
Subject: [PATCH net-next 1/3] net: do not use skb_mac_header() in qdisc_pkt_len_init()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
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

We want to remove our use of skb_mac_header() in tx paths,
eg remove skb_reset_mac_header() from __dev_queue_xmit().

Idea is that ndo_start_xmit() can get the mac header
simply looking at skb->data.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c7853192563d2ee6cd43293c84b9ae5073346580..c610efc5fcd60247799c6ee7fd1b3fb429cabfb5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3733,25 +3733,25 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
 	 * we add to pkt_len the headers size of all segments
 	 */
 	if (shinfo->gso_size && skb_transport_header_was_set(skb)) {
-		unsigned int hdr_len;
 		u16 gso_segs = shinfo->gso_segs;
+		unsigned int hdr_len;
 
 		/* mac layer + network layer */
-		hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
+		hdr_len = skb_transport_offset(skb);
 
 		/* + transport layer */
 		if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
 			const struct tcphdr *th;
 			struct tcphdr _tcphdr;
 
-			th = skb_header_pointer(skb, skb_transport_offset(skb),
+			th = skb_header_pointer(skb, hdr_len,
 						sizeof(_tcphdr), &_tcphdr);
 			if (likely(th))
 				hdr_len += __tcp_hdrlen(th);
 		} else {
 			struct udphdr _udphdr;
 
-			if (skb_header_pointer(skb, skb_transport_offset(skb),
+			if (skb_header_pointer(skb, hdr_len,
 					       sizeof(_udphdr), &_udphdr))
 				hdr_len += sizeof(struct udphdr);
 		}
-- 
2.40.0.rc2.332.ga46443480c-goog

