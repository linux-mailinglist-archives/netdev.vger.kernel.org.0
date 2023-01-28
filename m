Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CC167F955
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbjA1P65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbjA1P6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:58:54 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8514130B1A
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:43 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id ll10so4878334qvb.6
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPo2A8/WyRg0uZtMgMrJXTBrF2bqp+xJsCXZ+utu8AQ=;
        b=bAY+cUHXwYrY8TWyEPo7qAwYVGbVc8SeroagwyR+TekNCmaIiSNMtiuE+Q9LiUol+A
         5ccA4bk8He8EnawA6rAAHj8ZJdSNQr+fOcq0ehv0sHQ+woJZBikE7KMiQvaTymYoUZW8
         elEUR5j2/SCulGejumMQ7lHjHAMMA6oYYJ5JPQ9uHynmUP9KExAQC9Va3KK7RABU3WrK
         dKP24tQ4e/wQGrL+q5sBxqd3rFCxvldXJ0xczoFy10QE5yqXuoJVyPQb5r52Nl+7Ce4n
         6TDBq5qosRxkrjuP+5kDuMqnI+V6KHtvxm5hjJxQidZWdurwLI/gR/V7kTjnlUeVDKry
         he/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPo2A8/WyRg0uZtMgMrJXTBrF2bqp+xJsCXZ+utu8AQ=;
        b=3j6lXMiAAwZWUGs7udJqMxqNjJ3+XNEYK79fZYElQmjkEiPSzAixP0AV6wLKB66yjA
         LQhKnNwhxzG+fl6dl8LYXyXWAL+WHDsrcHKAAODaXJ4gmwtni9qUmmMtFNerjHWXVovo
         ntAmt6ocNVMFnqaVMZugWwkKv1dDN8yEKBx93R3/ZLP7tGxn93wiiNBX/iacIQb2rq8p
         3TRl0NPcx7IkvO7/Zvo1563D0HEhlfpmQ3rfr7rybfS/DnRkuX3iMMuWk4QFtKSYAPuy
         eAJnzdYILyUXBqoWxJzq0PR2/s007neZhZz5EakamBwgMRB7+Mql3SaG57eT/SnnwBYA
         TPIQ==
X-Gm-Message-State: AO0yUKUMfWQWxfyTH0lja4kxz1JGQiEN3GggWTTppB+Ebf3De2Pa7kE3
        p9ADKy2/VCTBQAkmcmpLIG7IILp+fuNv3Q==
X-Google-Smtp-Source: AK7set+EYCXAlvAOMFD68ir0VQV0WpFaQ8mPs0IjY5LueEscMrnsvtd2IN6hoGhFiiy4hMlt/SJ7NA==
X-Received: by 2002:a05:6214:190f:b0:537:7c16:1775 with SMTP id er15-20020a056214190f00b005377c161775mr14271427qvb.44.1674921522219;
        Sat, 28 Jan 2023 07:58:42 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:42 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv4 net-next 01/10] net: add a couple of helpers for iph tot_len
Date:   Sat, 28 Jan 2023 10:58:30 -0500
Message-Id: <9a810d8265b12d95e6effff76e2ec722f283b094.1674921359.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674921359.git.lucien.xin@gmail.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds three APIs to replace the iph->tot_len setting
and getting in all places where IPv4 BIG TCP packets may reach,
they will be used in the following patches.

Note that iph_totlen() will be used when iph is not in linear
data of the skb.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/ip.h  | 21 +++++++++++++++++++++
 include/net/route.h |  3 ---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/ip.h b/include/linux/ip.h
index 3d9c6750af62..d11c25f5030a 100644
--- a/include/linux/ip.h
+++ b/include/linux/ip.h
@@ -35,4 +35,25 @@ static inline unsigned int ip_transport_len(const struct sk_buff *skb)
 {
 	return ntohs(ip_hdr(skb)->tot_len) - skb_network_header_len(skb);
 }
+
+static inline unsigned int iph_totlen(const struct sk_buff *skb, const struct iphdr *iph)
+{
+	u32 len = ntohs(iph->tot_len);
+
+	return (len || !skb_is_gso(skb) || !skb_is_gso_tcp(skb)) ?
+	       len : skb->len - skb_network_offset(skb);
+}
+
+static inline unsigned int skb_ip_totlen(const struct sk_buff *skb)
+{
+	return iph_totlen(skb, ip_hdr(skb));
+}
+
+/* IPv4 datagram length is stored into 16bit field (tot_len) */
+#define IP_MAX_MTU	0xFFFFU
+
+static inline void iph_set_totlen(struct iphdr *iph, unsigned int len)
+{
+	iph->tot_len = len <= IP_MAX_MTU ? htons(len) : 0;
+}
 #endif	/* _LINUX_IP_H */
diff --git a/include/net/route.h b/include/net/route.h
index 6e92dd5bcd61..fe00b0a2e475 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -35,9 +35,6 @@
 #include <linux/cache.h>
 #include <linux/security.h>
 
-/* IPv4 datagram length is stored into 16bit field (tot_len) */
-#define IP_MAX_MTU	0xFFFFU
-
 #define RTO_ONLINK	0x01
 
 #define RT_CONN_FLAGS(sk)   (RT_TOS(inet_sk(sk)->tos) | sock_flag(sk, SOCK_LOCALROUTE))
-- 
2.31.1

