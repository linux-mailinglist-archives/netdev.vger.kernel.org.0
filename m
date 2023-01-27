Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B431967EA2B
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbjA0QAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbjA0QAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:04 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2448660D
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:01 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id g16so4369388qtu.2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tl5Hvsf/bhbzo4TjITsPEwXtRmHZPlZaj/ryQGs8Zww=;
        b=SH9RcQM9TnI9XyzH6t13UlVw/Hjl/S3j2aRuXsmLPKuT0Jf1B99BnMJrJFnc5RQJj/
         MF/J29BC91NZ1cqjuw2/ImV5AGzqvOoqQ7ae5sjIn67U5QhPlUukFQW0VDJIZiqOWcnY
         PhynjpfFcBP/DHWvFob5NkAnCdgzVndC9aXCEZLYguDXxnKtUdSTwQp6m3atxvAQ4C5X
         1HHMW18OCLgyEdaFjrYI8txab4jeiZFVy0EqunhTkrc/wEJHPsJ6xpnaoeUCwECQtsqP
         2BOLN6lnQcmmZzA2JHbJBTQargKURZmaADgh0CCaYa5pWDGCvWKnBc41033hYu3bi12f
         eswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tl5Hvsf/bhbzo4TjITsPEwXtRmHZPlZaj/ryQGs8Zww=;
        b=U8CNbU0TE4V+Mw486ir0OwoW+gcHvOqZ0nCm85cPtZI44zScTmeTuNswUXg2rmXAPy
         YeV0t60ULNMAZJ5Uv0jCM2Nrf0X2C8dlPrB34nDfOnbnJxTXjDhw6f6dD3pbTAZTP+gy
         sLnofkacssAl8XgtAXqMzxllVW0q5zLc6p8j5uDb1uAzjVxI0oyB3i383PgxNy2m1Pak
         IxXgXHUgSsq3XB0oXeUT0vvVGj5X+jaMyZPBflaLqXl1vTqG26KzRjyuK32G8b42I5Rp
         gEhJkNlWbiQv2KiWeiUlbYBHxJdC7oz1d5oRu1y+Ii+Oa/uZC1KS4v24jsyuLSVaQeRe
         kg4A==
X-Gm-Message-State: AFqh2kpfwZp0FF9hxJZrTMahVsuQ9M5BRvDckm8Ikm5fjHMfyU8klE7r
        s9JTPmxSftDYMmdV2W02ryOOrKKpFr765Q==
X-Google-Smtp-Source: AMrXdXuofNTDzS7P0CaB7TS2lacppCl/aw5ApXHS4hL/BIxQ40U0gPFHqGO1HRxKBK7+pgMbLevedQ==
X-Received: by 2002:ac8:4d02:0:b0:3b4:63d8:bcbb with SMTP id w2-20020ac84d02000000b003b463d8bcbbmr56210837qtv.28.1674835200877;
        Fri, 27 Jan 2023 08:00:00 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.07.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:00:00 -0800 (PST)
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
Subject: [PATCHv3 net-next 02/10] bridge: use skb_ip_totlen in br netfilter
Date:   Fri, 27 Jan 2023 10:59:48 -0500
Message-Id: <f882977642f2cec5c6c75a18e8594a21d9b7f028.1674835106.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674835106.git.lucien.xin@gmail.com>
References: <cover.1674835106.git.lucien.xin@gmail.com>
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

These 3 places in bridge netfilter are called on RX path after GRO
and IPv4 TCP GSO packets may come through, so replace iph tot_len
accessing with skb_ip_totlen() in there.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/bridge/br_netfilter_hooks.c            | 2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index f20f4373ff40..b67c9c98effa 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -214,7 +214,7 @@ static int br_validate_ipv4(struct net *net, struct sk_buff *skb)
 	if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl)))
 		goto csum_error;
 
-	len = ntohs(iph->tot_len);
+	len = skb_ip_totlen(skb);
 	if (skb->len < len) {
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 5c5dd437f1c2..71056ee84773 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -212,7 +212,7 @@ static int nf_ct_br_ip_check(const struct sk_buff *skb)
 	    iph->version != 4)
 		return -1;
 
-	len = ntohs(iph->tot_len);
+	len = skb_ip_totlen(skb);
 	if (skb->len < nhoff + len ||
 	    len < (iph->ihl * 4))
                 return -1;
@@ -256,7 +256,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 			return NF_ACCEPT;
 
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		if (pskb_trim_rcsum(skb, len))
 			return NF_ACCEPT;
 
-- 
2.31.1

