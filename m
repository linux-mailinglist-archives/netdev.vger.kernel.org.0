Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E1868E3A3
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjBGWw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjBGWwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:52:18 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1162BF02
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 14:52:17 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id w3so18746974qts.7
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 14:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IEaLXczlGF6QiWh17Q0HZk+D3OpE/6hVdkCgSrs4VZk=;
        b=VMXzmB15NZ7I+w8HA66jMpS4EuVjHnhvCJMgLjD5ILkCgOAryt9QdXSXYKeXWuQ87w
         ZCjQVrGFIzBse+4BluHTgiWasPbC5RX2Kq79XM8/q4q1+3OWewTwF2F/WxAn6ZJDwCSr
         qeUexgWklr6/Hdwl5uA5K84eB+eh+hg1QtoX90OJH0WTLl3E/0UbX1GiBHhgzzmLUz2m
         LzL/xVrsNpqwXzJg0MvPn6DgsOkD3n3Du8eAt6tTdlZwdSfp+jJEIWYsLecOJ9ipmOvN
         rgUMIb1xyeUbCr9hSqo496l3YYIFEEfCDVcnTPofwnQsptMLSp2l8ZwYIyvQABtC+n78
         QH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IEaLXczlGF6QiWh17Q0HZk+D3OpE/6hVdkCgSrs4VZk=;
        b=b2qozmd3IFzSCoJwd+jLucs3NqiZL2aqXfu/AFZmP9XXKp/Zlzszqw73AeEexsPgOJ
         W9+T1D4f5KEXwI88y1aUU0eXUU2EYQaBksfIHbxEomLjMVzAbXFFPxpTve/d5r4MB35N
         p6scdXKTd1iGXmoZYHW7RlC6KXxR0g6hk4j+DpwV+W6ZAKDDUMSZpQ8Ecmujf4hIwgNG
         vV4Cr+AOVjPRZ20Br0xwy+Aknbd/3f1prRR3whax6eh/2kjrcUdz17uFI79rtgw86VUu
         lnr3lfGe5iGcmMj5Ij+DocT8GuJUS5asIi86+11/MGx+HaloofHOTV5K4MDWMLvK1PKW
         79Yw==
X-Gm-Message-State: AO0yUKU76LZdkv0gyZeHGYrhVLyGhTGE7G2/RMtWC9g6/B0z1NA3ZtFM
        Md3cm63kgGIFrSrwUhGFX0AKrkHC2Z5bmg==
X-Google-Smtp-Source: AK7set9GB19N6dCc27/rGNC0vRbueoBTzCusvfx8UohW4UJbyMt9prNBupceTFwbExHs/jBdoblwTA==
X-Received: by 2002:ac8:57d5:0:b0:3b8:2077:1421 with SMTP id w21-20020ac857d5000000b003b820771421mr9077594qta.32.1675810336364;
        Tue, 07 Feb 2023 14:52:16 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w15-20020a05620a444f00b007296805f607sm10622037qkp.17.2023.02.07.14.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 14:52:16 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv2 net-next 4/5] net: sched: move frag check and tc_skb_cb update out of handle_fragments
Date:   Tue,  7 Feb 2023 17:52:09 -0500
Message-Id: <a73fd95cb3873dd8f94da53487428b44cb2534a2.1675810210.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1675810210.git.lucien.xin@gmail.com>
References: <cover.1675810210.git.lucien.xin@gmail.com>
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

This patch has no functional changes and just moves frag check and
tc_skb_cb update out of handle_fragments, to make it easier to move
the duplicate code from handle_fragments() into nf_conntrack_ovs later.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 71 +++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0a1ecc972a8b..9f133ed93815 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -778,29 +778,10 @@ static int tcf_ct_ipv6_is_fragment(struct sk_buff *skb, bool *frag)
 	return 0;
 }
 
-static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
-				   u8 family, u16 zone, bool *defrag)
+static int handle_fragments(struct net *net, struct sk_buff *skb,
+			    u16 zone, u8 family, u16 *mru)
 {
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-	int err = 0;
-	bool frag;
-	u16 mru;
-
-	/* Previously seen (loopback)? Ignore. */
-	ct = nf_ct_get(skb, &ctinfo);
-	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
-		return 0;
-
-	if (family == NFPROTO_IPV4)
-		err = tcf_ct_ipv4_is_fragment(skb, &frag);
-	else
-		err = tcf_ct_ipv6_is_fragment(skb, &frag);
-	if (err || !frag)
-		return err;
-
-	skb_get(skb);
-	mru = tc_skb_cb(skb)->mru;
+	int err;
 
 	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
@@ -812,10 +793,8 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		if (err && err != -EINPROGRESS)
 			return err;
 
-		if (!err) {
-			*defrag = true;
-			mru = IPCB(skb)->frag_max_size;
-		}
+		if (!err)
+			*mru = IPCB(skb)->frag_max_size;
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
@@ -825,18 +804,14 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		if (err && err != -EINPROGRESS)
 			goto out_free;
 
-		if (!err) {
-			*defrag = true;
-			mru = IP6CB(skb)->frag_max_size;
-		}
+		if (!err)
+			*mru = IP6CB(skb)->frag_max_size;
 #else
 		err = -EOPNOTSUPP;
 		goto out_free;
 #endif
 	}
 
-	if (err != -EINPROGRESS)
-		tc_skb_cb(skb)->mru = mru;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;
@@ -846,6 +821,38 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	return err;
 }
 
+static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
+				   u8 family, u16 zone, bool *defrag)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	int err = 0;
+	bool frag;
+	u16 mru;
+
+	/* Previously seen (loopback)? Ignore. */
+	ct = nf_ct_get(skb, &ctinfo);
+	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
+		return 0;
+
+	if (family == NFPROTO_IPV4)
+		err = tcf_ct_ipv4_is_fragment(skb, &frag);
+	else
+		err = tcf_ct_ipv6_is_fragment(skb, &frag);
+	if (err || !frag)
+		return err;
+
+	skb_get(skb);
+	err = handle_fragments(net, skb, zone, family, &mru);
+	if (err)
+		return err;
+
+	*defrag = true;
+	tc_skb_cb(skb)->mru = mru;
+
+	return 0;
+}
+
 static void tcf_ct_params_free(struct tcf_ct_params *params)
 {
 	if (params->helper) {
-- 
2.31.1

