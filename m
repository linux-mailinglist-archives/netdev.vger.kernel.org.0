Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA7566A8FD
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjANDcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjANDcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:32:11 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655368F8CB
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:49 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id fd15so10755448qtb.9
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/UeqT4DY2zDY3VtP4bF5KQAgTN1r5Nv8/OY6W808rs=;
        b=PQv3TkD/mZtx1fDtgj9bqeNbA84WB2YOjYgo8j+uKImfNEhVXN1QA4aoybffEPfGTL
         jIM/RzruhjUr4DOaoaOVlOrm5jDJii8e+qyH5Fqg0ueD9y0BnH8TVLjglPXxTTRACQo6
         /5zA0rvgN0qWVPuAY2Ca5dc9WTrN+AO1pNbgWK7IDr/vJWFyGBszSiiwUNipW+B5m3/4
         mqpGYZxpASzro3wutvPDZUJPKUY/SDv6P056rKCU/1uYewC3g95pzoYmL0ukItZm4T4F
         7ihdtPwC6LeDF36rOuu725cxOXN6yY8dolvKMRXgExta3ai5ZX1lc+D+B0fBgD5Vm34B
         VFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/UeqT4DY2zDY3VtP4bF5KQAgTN1r5Nv8/OY6W808rs=;
        b=S6VS0HFtrHFmE+rOEz/sY42GoBkpAXzS9AXbIMdeM7+VL9krJpRQAx8mmkAamO/zyO
         vFZ9mIcxMa8xhs7jj+SUuzLI+SRPpAYO0PFWtmDsrg3sGF2vuPpnlY+YTDnUkcOKSh+V
         f0l0V+oHWxm4hEPQ77p3padQpjiLdrrhjQl6Sa2byf69vfsw0rvdGn/90GE57LZxsMNN
         RrfKusZE/cxaeJv9PMiY5s626X6pUH6yHdpniL/1LT4Idt2gsTFfsgttaaaoDqqyn+r3
         lyqzkB2UEkdVXrVhHGM6vhMd+AjH9FDSLgEQ627gDqvtISfd98pLfQcXiH+ffOYdTU4N
         EwQA==
X-Gm-Message-State: AFqh2kozxnVB4OjvTsA1aBDOjmej9IoNeTImwfC7nHkFWNqgXonuxIDW
        SE771d2J82vhcyU5g1WHKApnMxMDwQ4q7g==
X-Google-Smtp-Source: AMrXdXsXm1zOxlYkDu2Su1Hog3IJZ5s/d3VX8MMucsnqXDwnaPmccbufXBj/vgCQHeYCgdkmewtBUw==
X-Received: by 2002:a05:622a:514:b0:3ab:d187:9e7 with SMTP id l20-20020a05622a051400b003abd18709e7mr62642655qtx.44.1673667108350;
        Fri, 13 Jan 2023 19:31:48 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm7878846qtb.66.2023.01.13.19.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:31:48 -0800 (PST)
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
Subject: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
Date:   Fri, 13 Jan 2023 22:31:33 -0500
Message-Id: <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1673666803.git.lucien.xin@gmail.com>
References: <cover.1673666803.git.lucien.xin@gmail.com>
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

For IPv6 jumbogram packets, the packet size is bigger than 65535,
it's not right to get it from payload_len and save it to an u16
variable.

This patch only fixes it for IPv6 BIG TCP packets, so instead of
parsing IPV6_TLV_JUMBO exthdr, which is quite some work, it only
gets the pktlen via 'skb->len - skb_network_offset(skb)' when
skb_is_gso_v6() and saves it to an u32 variable, similar to IPv4
BIG TCP packets.

This fix will also help us add selftest for IPv6 BIG TCP in the
following patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/ipv6.h      | 9 +++++++++
 net/netfilter/xt_length.c | 3 +--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 37dfdcfcdd54..b8edd6c599eb 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -175,6 +175,15 @@ static inline bool inet6_is_jumbogram(const struct sk_buff *skb)
 	return !!(IP6CB(skb)->flags & IP6SKB_JUMBOGRAM);
 }
 
+static inline unsigned int skb_ipv6_totlen(const struct sk_buff *skb)
+{
+	u32 pl = ntohs(ipv6_hdr(skb)->payload_len);
+
+	return pl ? pl + sizeof(struct ipv6hdr)
+		  : (skb_is_gso_v6(skb) ? skb->len - skb_network_offset(skb)
+					: pl + sizeof(struct ipv6hdr));
+}
+
 /* can not be used in TCP layer after tcp_v6_fill_cb */
 static inline int inet6_sdif(const struct sk_buff *skb)
 {
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index b3d623a52885..61518ec05c6e 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -30,8 +30,7 @@ static bool
 length_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_length_info *info = par->matchinfo;
-	const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
-				 sizeof(struct ipv6hdr);
+	u32 pktlen = skb_ipv6_totlen(skb);
 
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
-- 
2.31.1

