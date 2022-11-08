Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B076210D6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiKHMeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbiKHMeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:34:05 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C146148;
        Tue,  8 Nov 2022 04:34:04 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so11596112wmb.2;
        Tue, 08 Nov 2022 04:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hs6bfBT9BT2l59umVn3/Z7dEM/XIWsGgJi1HUDGerFQ=;
        b=SIHlW8VhlVcLU+yqYNIL4jzxCnNPNjN3wimrOLvLFFNwAW6vcaR/92/b0zJhNpfKT6
         Sfcfkgg3Zqgb3CeClEtI4Y43S30lCh68NC1fjWMr2UNTFmNVLuk/ws60+EgRLZO4LeOT
         t1aE1xljAVtNZkRu3Idc7WLajGC6Wg7feo+Ry3a4KNW4f4ACTyXuorV6GqLZMAzTAFWy
         viXQjQTvtHtgKl+1gFxnnst/VM1mNT/h2XiJnU6ronyJjqk/hkz1P+O6JI/+4CGMY81S
         XNRU2MVStGPZv36pG+IbisMBBZA9mSFHfZyuGO/rZkx4+i5lPSk3kwHZu0qoQWrR/nQA
         RMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hs6bfBT9BT2l59umVn3/Z7dEM/XIWsGgJi1HUDGerFQ=;
        b=HLQ5VX3ca7CMsBnsyIl4mF9KvWKGN42zPR33aSTzChtVOFBXNUyKl3GNtcUJlj67y1
         3rYAW9XDk2zWoMvmsI5laeDrrvpaK8K+IGHLSuXPWvQrjvZZfBX2nnkpA8Pab6BPpcCm
         +63dXPDjSfzvvgVbZLNdOZDJ043THg8DvSPThgg5G39w4yGx9hMXfCMipy1d6FwXwD2X
         M9HlHE2Y83JpAx50Kcvi1EWWCk/E96zlt9BWVD+8dMxzmCJKtOmvLVJ16gsssbv6GsLc
         h962pC+kUUja5rhbpFOs50sEe105jm6KaF13A/ufoNnQu1Fd2ySCum2opWq1DieMAKew
         7Hog==
X-Gm-Message-State: ACrzQf2fRvWw3eDxEB6KHJjkdB+7tITa0tcDRnaDBc5M98j4yQejTxDu
        d18awrA6JLPTOKSMELYtjKk=
X-Google-Smtp-Source: AMsMyM7agjw76/9UWN4TjhHqSTs4AEF9Zol/a6+9dbFR9x6j8OXrSCZ7noMFtyd9NilUr7vJzghAyg==
X-Received: by 2002:a05:600c:2143:b0:3cf:63dc:d011 with SMTP id v3-20020a05600c214300b003cf63dcd011mr37444145wml.194.1667910842756;
        Tue, 08 Nov 2022 04:34:02 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id g17-20020a5d46d1000000b0022efc4322a9sm10171378wrs.10.2022.11.08.04.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 04:34:02 -0800 (PST)
Date:   Tue, 8 Nov 2022 13:33:28 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lixiaoyan@google.com, alexanderduyck@fb.com,
        steffen.klassert@secunet.com, richardbgobert@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] gro: avoid checking for a failed search
Message-ID: <20221108123320.GA59373@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After searching for a protocol handler in dev_gro_receive, checking for
failure is redundant. Skip the failure code after finding the 
corresponding handler.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/core/gro.c | 72 +++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index bc9451743307..8e0fe85a647d 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -489,45 +489,45 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ptype, head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_receive)
-			continue;
-
-		skb_set_network_header(skb, skb_gro_offset(skb));
-		skb_reset_mac_len(skb);
-		BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed) != sizeof(u32));
-		BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
-					 sizeof(u32))); /* Avoid slow unaligned acc */
-		*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
-		NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
-		NAPI_GRO_CB(skb)->is_atomic = 1;
-		NAPI_GRO_CB(skb)->count = 1;
-		if (unlikely(skb_is_gso(skb))) {
-			NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
-			/* Only support TCP at the moment. */
-			if (!skb_is_gso_tcp(skb))
-				NAPI_GRO_CB(skb)->flush = 1;
-		}
-
-		/* Setup for GRO checksum validation */
-		switch (skb->ip_summed) {
-		case CHECKSUM_COMPLETE:
-			NAPI_GRO_CB(skb)->csum = skb->csum;
-			NAPI_GRO_CB(skb)->csum_valid = 1;
-			break;
-		case CHECKSUM_UNNECESSARY:
-			NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
-			break;
-		}
-
-		pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
-					ipv6_gro_receive, inet_gro_receive,
-					&gro_list->list, skb);
-		break;
+		if (ptype->type == type && ptype->callbacks.gro_receive)
+			goto found_ptype;
 	}
 	rcu_read_unlock();
+	goto normal;
 
-	if (&ptype->list == head)
-		goto normal;
+found_ptype:
+	skb_set_network_header(skb, skb_gro_offset(skb));
+	skb_reset_mac_len(skb);
+	BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed) != sizeof(u32));
+	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
+					sizeof(u32))); /* Avoid slow unaligned acc */
+	*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
+	NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
+	NAPI_GRO_CB(skb)->is_atomic = 1;
+	NAPI_GRO_CB(skb)->count = 1;
+	if (unlikely(skb_is_gso(skb))) {
+		NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
+		/* Only support TCP at the moment. */
+		if (!skb_is_gso_tcp(skb))
+			NAPI_GRO_CB(skb)->flush = 1;
+	}
+
+	/* Setup for GRO checksum validation */
+	switch (skb->ip_summed) {
+	case CHECKSUM_COMPLETE:
+		NAPI_GRO_CB(skb)->csum = skb->csum;
+		NAPI_GRO_CB(skb)->csum_valid = 1;
+		break;
+	case CHECKSUM_UNNECESSARY:
+		NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
+		break;
+	}
+
+	pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
+				ipv6_gro_receive, inet_gro_receive,
+				&gro_list->list, skb);
+
+	rcu_read_unlock();
 
 	if (PTR_ERR(pp) == -EINPROGRESS) {
 		ret = GRO_CONSUMED;
-- 
2.20.1

