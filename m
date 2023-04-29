Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4396F2705
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 00:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjD2Wky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 18:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjD2Wkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 18:40:53 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BC6E63
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 15:40:51 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-74e4f839ae4so54822685a.0
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 15:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682808050; x=1685400050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JdC5vKdhMqXkGLWjKKDVL+KYo0HsVuHVLflZJjoZrwg=;
        b=YXiBSwfGnrtfIbs5qF5CTQZCtt9xbr1H0/JbmQC7BJEyQgcU99obGyojHy6JUp2R/u
         tBNgdD5zbZ3t9A1eWWGVXBu6w56O9yGDl9z34uuvDqDL1Low5RL99SGYpGrzhBMIvSe9
         4pl7f0IbQZhgWRYVETUhG+YQ9WmKNQM8BL/pwl9IwyoKQLpWH/HF8bBfmB8L/ljPUv3R
         M8r/wsUrX0RR+IrlOf7fvgA8+TzybkYahUSxpsUnWah9AS3tYQujUd/BaWIjwQUMmzM0
         5mXOPDfeTce6wi/AGzsCs3r5YiuaQ+eYbGF9hIm0fJfobmJM4Tgi26jLU+te/zq53uj6
         LfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682808050; x=1685400050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JdC5vKdhMqXkGLWjKKDVL+KYo0HsVuHVLflZJjoZrwg=;
        b=LhH3oxmLoFBGxJvU6KfIgr2GyP0SxTx9UbquCob4xeqE3V8a4XEd62NrvWOJlTScUX
         ja8wF4mXk4rBGLieHEbDaw6AGrz3Eb/bpX0TQqoy6ZnyHbuFJigi3LO5QXYzGXeEQtL7
         XPcCC1Dws7Fg45orrhUPo5DK6rRvHoIMNZxIoPmGEUNFdQ4hzUPlcFXDdldypxE8kLS5
         z5MCrlmYRKZpvPw2Y3MvHI7QpNEnSXrAJJMn/KwhQ5Fnv906XvqzdxLrKuPhuVmniFY7
         X/s5QngrEE3f8XdS0skIrLQGCu0lp2F664MY+zeRvTGRc3wW1QUBuc+9t1DCfmiM3D+V
         3VJg==
X-Gm-Message-State: AC+VfDzutdVnh6GvSiujYp4Fdtv6hyF+KnBb1t+m9JokssB3Ty+NZgmn
        XPBIIaTEZlxF3SbEc7EASXDxTc+NW2Vg3g==
X-Google-Smtp-Source: ACHHUZ5ES7Qmaaz74zXkPwG8lwiiTYkbTaajv2hUYChCNJI1/CEhQS0y+j+h1RU63ImVUgro1yM7aw==
X-Received: by 2002:a05:6214:c4d:b0:61a:9107:bac9 with SMTP id r13-20020a0562140c4d00b0061a9107bac9mr51189qvj.33.1682808050063;
        Sat, 29 Apr 2023 15:40:50 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p12-20020a0ce18c000000b00606322241b4sm6595741qvl.27.2023.04.29.15.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 15:40:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Subject: [PATCH net 1/2] tipc: add tipc_bearer_min_mtu to calculate min mtu
Date:   Sat, 29 Apr 2023 18:40:46 -0400
Message-Id: <b73c0deb97ca299207d2197db28f78d3992fbdbf.1682807958.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1682807958.git.lucien.xin@gmail.com>
References: <cover.1682807958.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As different media may requires different min mtu, and even the
same media with different net family requires different min mtu,
add tipc_bearer_min_mtu() to calculate min mtu accordingly.

This API will be used to check the new mtu when doing the link
mtu negotiation in the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/bearer.c    | 13 +++++++++++++
 net/tipc/bearer.h    |  3 +++
 net/tipc/udp_media.c |  5 +++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 35cac7733fd3..c5d2e8c45f88 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -541,6 +541,19 @@ int tipc_bearer_mtu(struct net *net, u32 bearer_id)
 	return mtu;
 }
 
+int tipc_bearer_min_mtu(struct net *net, u32 bearer_id)
+{
+	int mtu = TIPC_MIN_BEARER_MTU;
+	struct tipc_bearer *b;
+
+	rcu_read_lock();
+	b = rcu_dereference(tipc_net(net)->bearer_list[bearer_id]);
+	if (b)
+		mtu += b->encap_hlen;
+	rcu_read_unlock();
+	return mtu;
+}
+
 /* tipc_bearer_xmit_skb - sends buffer to destination over bearer
  */
 void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index 490ad6e5f7a3..bd0cc5c287ef 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -146,6 +146,7 @@ struct tipc_media {
  * @identity: array index of this bearer within TIPC bearer array
  * @disc: ptr to link setup request
  * @net_plane: network plane ('A' through 'H') currently associated with bearer
+ * @encap_hlen: encap headers length
  * @up: bearer up flag (bit 0)
  * @refcnt: tipc_bearer reference counter
  *
@@ -170,6 +171,7 @@ struct tipc_bearer {
 	u32 identity;
 	struct tipc_discoverer *disc;
 	char net_plane;
+	u16 encap_hlen;
 	unsigned long up;
 	refcount_t refcnt;
 };
@@ -232,6 +234,7 @@ int tipc_bearer_setup(void);
 void tipc_bearer_cleanup(void);
 void tipc_bearer_stop(struct net *net);
 int tipc_bearer_mtu(struct net *net, u32 bearer_id);
+int tipc_bearer_min_mtu(struct net *net, u32 bearer_id);
 bool tipc_bearer_bcast_support(struct net *net, u32 bearer_id);
 void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
 			  struct sk_buff *skb,
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index c2bb818704c8..0a85244fd618 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -738,8 +738,8 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 			udp_conf.local_ip.s_addr = local.ipv4.s_addr;
 		udp_conf.use_udp_checksums = false;
 		ub->ifindex = dev->ifindex;
-		if (tipc_mtu_bad(dev, sizeof(struct iphdr) +
-				      sizeof(struct udphdr))) {
+		b->encap_hlen = sizeof(struct iphdr) + sizeof(struct udphdr);
+		if (tipc_mtu_bad(dev, b->encap_hlen)) {
 			err = -EINVAL;
 			goto err;
 		}
@@ -760,6 +760,7 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 		else
 			udp_conf.local_ip6 = local.ipv6;
 		ub->ifindex = dev->ifindex;
+		b->encap_hlen = sizeof(struct ipv6hdr) + sizeof(struct udphdr);
 		b->mtu = 1280;
 #endif
 	} else {
-- 
2.39.1

