Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A0354796B
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 11:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbiFLJBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 05:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbiFLJA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 05:00:59 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586D251E70
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 02:00:55 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id j5-20020a05600c1c0500b0039c5dbbfa48so3086407wms.5
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 02:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oZewD39xI/d3cA2lrYzrzbuReF/vvOH6OKqzVd89Vi0=;
        b=I7WHh5fScRUlNuotdc665LoLnMNVifFMFBlEzjUFcKf9gROoXJ845rIiW1Qk+PTxiR
         PtbBonb26DI70Kx2ARKOD7D1WUmUHI/gQp3TkURjBlfMVEc24tG55CXut6lZKgTXhGkZ
         xV/ndMmtPSnsvL4UM8x/2vxsNs0Yfbu6sQJzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oZewD39xI/d3cA2lrYzrzbuReF/vvOH6OKqzVd89Vi0=;
        b=phZcPwyTlSW/khylGZCtcqAqYSv0DIUbQZGWwuE/vs6vpGbUbrtppRWHwUL1jZphZh
         svJDnS6SiQNQqHWZAY1vGvV6bHf5ajYjR7laEU5uzgbw9zYyyQLNBKyoAuS0V0ohYx2W
         gtWBzS/6E8GKc11NEoDcCXsWh+2uj6u+um6LH0ExJrMbaKEklQHD0umibW0P74UNlaAV
         DMe1YvNB+wE9DFbAKiI9P/BZrrJfmHtDsiB1WqxAqnT5km+PKw/ECjvm/AWPIs2IV8uc
         kpe88lnkR0xaxwJcltngKbdv1Oso6JjpIp6TflfCgcX5nqU9dM3s5E7YeDG1o0VPHte1
         63fA==
X-Gm-Message-State: AOAM530dkcnYF6ybcg0DzA+1g2oeuyNzwhrrTel9DXYXOCk2627fbL0n
        wjuss9YMcmCMahyKqqCUnK3UIA==
X-Google-Smtp-Source: ABdhPJyRc2I34omfc6W/l7b3YpL+JA18yp8NmiSPvr3XlLpY4Wwvv7Z0CdG4SFGFbc7ui5FdZrlNTQ==
X-Received: by 2002:a05:600c:1ca0:b0:39c:4dbd:e9ed with SMTP id k32-20020a05600c1ca000b0039c4dbde9edmr8452040wms.40.1655024453936;
        Sun, 12 Jun 2022 02:00:53 -0700 (PDT)
Received: from localhost.localdomain ([178.130.153.185])
        by smtp.gmail.com with ESMTPSA id d34-20020a05600c4c2200b0039c5b4ab1b0sm4798603wmp.48.2022.06.12.02.00.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jun 2022 02:00:53 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [RFC,net-next v2 8/8] net: tcp: Support MSG_NTCOPY
Date:   Sun, 12 Jun 2022 01:57:57 -0700
Message-Id: <1655024280-23827-9-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1655024280-23827-1-git-send-email-jdamato@fastly.com>
References: <1655024280-23827-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support non-temporal copies in the TCP sendmsg path. Previously, the only
way to enable non-temporal copies was to enable them for the entire
interface (via ethtool).

This change allows user programs to request non-temporal copies for
specific sendmsg calls.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/sock.h | 2 +-
 net/ipv4/tcp.c     | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 0063e84..b666ecd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2200,7 +2200,7 @@ static inline int skb_do_copy_data_nocache(struct sock *sk, struct sk_buff *skb,
 		if (!csum_and_copy_from_iter_full(to, copy, &csum, from))
 			return -EFAULT;
 		skb->csum = csum_block_add(skb->csum, csum, offset);
-	} else if (sk->sk_route_caps & NETIF_F_NOCACHE_COPY) {
+	} else if (sk->sk_route_caps & NETIF_F_NOCACHE_COPY || iov_iter_copy_is_nt(from)) {
 		if (!copy_from_iter_full_nocache(to, copy, from))
 			return -EFAULT;
 	} else if (!copy_from_iter_full(to, copy, from))
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 14ebb4e..5b36e00 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1201,6 +1201,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 	flags = msg->msg_flags;
 
+	msg_set_iter_copy_type(msg);
+
 	if (flags & MSG_ZEROCOPY && size && sock_flag(sk, SOCK_ZEROCOPY)) {
 		skb = tcp_write_queue_tail(sk);
 		uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
-- 
2.7.4

