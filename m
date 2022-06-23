Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1E755892F
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiFWTiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiFWTiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:38:22 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B3453A6A;
        Thu, 23 Jun 2022 12:27:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id dw10-20020a17090b094a00b001ed00a16eb4so590942pjb.2;
        Thu, 23 Jun 2022 12:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cf9jfPE0KUQfW0TmHoXpv9qVShsG0l1SK4kcg8rsWcI=;
        b=Ns6bi0lljbt9SC4uU1QxWHSrDKFrYslQuByco3JyEA0XsqpNywXp9TIEzfoxu1zCHm
         YQZX72ScKdsywuDOXMEAkM5LknmhCNTowRCG7OltNzd+5VDv9bwLlomuQPnW6c/zO15r
         1FtUJajKucZh7ia/9F27yCimNhhoXtMUqOMFebtXHXAYE9DXAf6Wv3B3Agc+mFTSCy82
         rzJ4DIF9tloG5d10PCmLQaZCdc1cXPMiEbyhHuVGe8D7XDoAsa+bAx5mxqeZhv/eHs1t
         vgEUrebTlfLR86kpHVntPQLfFL92qNAtRsdQDHtYTjDLspt1YoE37LxKvejsAeJvGBZ5
         42Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cf9jfPE0KUQfW0TmHoXpv9qVShsG0l1SK4kcg8rsWcI=;
        b=OMj2PSZxi0KVhT9KBDjeBbH1FeWvVMGpHprIEkyRnS2iUqECzsGKHzxRch37qCsXjY
         bpI2ZqPRWiFXdlJgiFd3ied8dd06k4hbzkAvIW0NEAxtv45/fsUr3x6aD5tWkxG7RYll
         1QXSON/Ufpoaj/9KwlhazsUD+vXZAafq+jeRKdUGaMteRAbvNpOTQmEifdHNz5N/wiep
         VBsZITLWVR39MzYLS9+8w+RM2zvY0WnM/Tg83SW5Eov9qnyhMzQASFW1nIndCASMFgH2
         Z5KPeeMqHcMHilN1Mc96cl+lNzyK3rbWw7XzOqPTlpLJ4z94QqMQgPptkhlMuz3/K1cB
         7mpg==
X-Gm-Message-State: AJIora/7475+qnFEmoi5zkZeBX3mptw+iuqgiCeQi8JYUHnWODWIV3Of
        XiSmWedPfpQ7+omV0OLVby47cuO6WC2J5g==
X-Google-Smtp-Source: AGRyM1s/yNg01K0eZFNPqjpF1a6OaVr4gCwGNo2q5OvOMHTUodhQeVcWbC1kKA8PwiZvsNMjs4F/Cw==
X-Received: by 2002:a17:90b:4a03:b0:1ed:2071:e8c with SMTP id kk3-20020a17090b4a0300b001ed20710e8cmr95274pjb.216.1656012421676;
        Thu, 23 Jun 2022 12:27:01 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902714200b0016a522915e5sm171626plm.83.2022.06.23.12.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:27:01 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v5 4/8] net: netfilter: Add kfuncs to set and change CT timeout
Date:   Fri, 24 Jun 2022 00:56:33 +0530
Message-Id: <20220623192637.3866852-5-memxor@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623192637.3866852-1-memxor@gmail.com>
References: <20220623192637.3866852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5949; h=from:subject; bh=ySnF+G+6LwgKSTObyB0g4BIoqOTOTtTq9uiqd3AsGhQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBitL5Lgd3XReg7YFry+H1lUKRd3qTHybPrW/r1ZZlJ d1LzSISJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYrS+SwAKCRBM4MiGSL8RyhjsD/ 4p6xquXyds3xMMXlAdgffQmE7X99RkdPJq9dvcO0OAZThxr6cSghhjDAlp9Gb6Bqm6rwrd39/7RHrv szz/CmS2H3SR5FMhI/9ufOnhgKI0b4PT2j9AknalZycQljKIYs8op45vDxucFeEyZSKSk9urXKJmNP h8AG9/YnywNahqQiQDyAZFbnX+EoVrBZQZA/J8LVN6wgZtESxNZpU5TaOjSabJmmz7yLOp10w2xzZj q2Sr9hbAmUG6/saS8sRros9Dmp6qWA0DEZsvn1OHMxmMgDNyW9spYR5RfrqHQo9SfA9JFv/KCNZWx3 3T2zUb7yCA+XMEAd9K33OhsDj3kv11alTdPGxRNlGsxpx6kPKS80QO+dvB0GoR9AIC3o9t9wmEdULk Xifx3j6bprs4GlzTFNgYUdRAcldzpVIi0ZY97qk0T+kjDc6A6RaCBtp7ym/r4lrIpSDT/BX2eG0Pyc GRoA2vBAKPttWzC7W8g/iaI42Qw4fOn2TJA8UmghOvt37fzVsluHNU2Yvfb5U0ZGh/kX4O4Y7TV78Q aygSqOwPy7NN8a9ChbTdiY2LmhtggxIl0EFTkOKgww/NI+eCL3xCG8dzkTrmETQ/2Z6sIP7sB5mIsr oNfq7FppMjFiNnhUL//8qki66zsqKtAHPJnB3J4fkgA4HkkwPcrJxpWNvF6Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

Introduce bpf_ct_set_timeout and bpf_ct_change_timeout kfunc helpers in
order to change nf_conn timeout. This is same as ctnetlink_change_timeout,
hence code is shared between both by extracting it out to
__nf_ct_change_timeout. It is also updated to return an error when it
sees IPS_FIXED_TIMEOUT_BIT bit in ct->status, as that check was missing.

It is required to introduce two kfuncs taking nf_conn___init and nf_conn
instead of sharing one because __ref suffix on the parameter name causes
strict type checking. This would disallow passing nf_conn___init to
kfunc taking nf_conn, and vice versa. We cannot remove the __ref suffix
as we only want to accept refcounted pointers and not e.g. ct->master.

Apart from this, bpf_ct_set_timeout is only called for newly allocated
CT so it doesn't need to inspect the status field just yet. Sharing the
helpers even if it was possible would make timeout setting helper
sensitive to order of setting status and timeout after allocation.

Hence, bpf_ct_set_* kfuncs are meant to be used on allocated CT, and
bpf_ct_change_* kfuncs are meant to be used on inserted or looked up
CT entry.

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/netfilter/nf_conntrack_core.h |  2 ++
 net/netfilter/nf_conntrack_bpf.c          | 34 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c         | 22 +++++++++++++++
 net/netfilter/nf_conntrack_netlink.c      |  9 +-----
 4 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 83a60c684e6c..3b0f7d0eebae 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -97,6 +97,8 @@ static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
 	WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
 }
 
+int __nf_ct_change_timeout(struct nf_conn *ct, u64 cta_timeout);
+
 #endif
 
 #endif /* _NF_CONNTRACK_CORE_H */
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 1d3c1d1e2d8b..db04874da950 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -364,6 +364,36 @@ void bpf_ct_release(struct nf_conn *nfct)
 	nf_ct_put(nfct);
 }
 
+/* bpf_ct_set_timeout - Set timeout of allocated nf_conn
+ *
+ * Sets the default timeout of newly allocated nf_conn before insertion.
+ * This helper must be invoked for refcounted pointer to nf_conn___init.
+ *
+ * Parameters:
+ * @nfct__ref    - Pointer to referenced nf_conn object, obtained using
+ *                 bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
+ * @timeout      - Timeout in msecs.
+ */
+void bpf_ct_set_timeout(struct nf_conn___init *nfct__ref, u32 timeout)
+{
+	__nf_ct_set_timeout((struct nf_conn *)nfct__ref, msecs_to_jiffies(timeout));
+}
+
+/* bpf_ct_change_timeout - Change timeout of inserted nf_conn
+ *
+ * Change timeout associated of the inserted or looked up nf_conn.
+ * This helper must be invoked for refcounted pointer to nf_conn.
+ *
+ * Parameters:
+ * @nfct__ref    - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_ct_insert_entry, bpf_xdp_ct_lookup, or bpf_skb_ct_lookup.
+ * @timeout      - New timeout in msecs.
+ */
+int bpf_ct_change_timeout(struct nf_conn *nfct__ref, u32 timeout)
+{
+	return __nf_ct_change_timeout(nfct__ref, msecs_to_jiffies(timeout));
+}
+
 __diag_pop()
 
 BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
@@ -371,6 +401,8 @@ BTF_ID(func, bpf_xdp_ct_alloc)
 BTF_ID(func, bpf_xdp_ct_lookup)
 BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
+BTF_ID(func, bpf_ct_set_timeout);
+BTF_ID(func, bpf_ct_change_timeout);
 BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_tc_check_kfunc_ids)
@@ -378,6 +410,8 @@ BTF_ID(func, bpf_skb_ct_alloc)
 BTF_ID(func, bpf_skb_ct_lookup)
 BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
+BTF_ID(func, bpf_ct_set_timeout);
+BTF_ID(func, bpf_ct_change_timeout);
 BTF_SET_END(nf_ct_tc_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_acquire_kfunc_ids)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 082a2fd8d85b..572f59a5e936 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2786,3 +2786,25 @@ int nf_conntrack_init_net(struct net *net)
 	free_percpu(net->ct.stat);
 	return ret;
 }
+
+#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
+    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
+    IS_ENABLED(CONFIG_NF_CT_NETLINK))
+
+/* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
+
+int __nf_ct_change_timeout(struct nf_conn *ct, u64 timeout)
+{
+	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
+		return -EPERM;
+
+	__nf_ct_set_timeout(ct, timeout);
+
+	if (test_bit(IPS_DYING_BIT, &ct->status))
+		return -ETIME;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__nf_ct_change_timeout);
+
+#endif
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0729b2f0d44f..b1de07c73845 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2023,14 +2023,7 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 static int ctnetlink_change_timeout(struct nf_conn *ct,
 				    const struct nlattr * const cda[])
 {
-	u64 timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
-
-	__nf_ct_set_timeout(ct, timeout);
-
-	if (test_bit(IPS_DYING_BIT, &ct->status))
-		return -ETIME;
-
-	return 0;
+	return __nf_ct_change_timeout(ct, (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ);
 }
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-- 
2.36.1

