Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB9457CC59
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiGUNoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiGUNnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:43:18 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051687E332;
        Thu, 21 Jul 2022 06:42:59 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d16so2320795wrv.10;
        Thu, 21 Jul 2022 06:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GWQ4NmbAOvQuVmBJTPsAVw7O9rLUCX2bkGgj4ylNhZ8=;
        b=fbBOZoNsO8mSv4Evw6oGI1+xGam1PzlGF5stlN8tgtann7kfZwDOR/YeUNtOvipk4Z
         LL0BBrXjaf7X5EScZeaj3YXtDz9ue+oVAoMjGMxQQq9oAD5SKYzDIgCFSswYpFkSH2ZT
         61B1mSdb1Er72n/SjZXQUiZ49D5lBTCjlPLa7Eda0bFul/zMVbCubuJnv5PH7f605WJX
         4mUSwTt4Dry2/PSf39lhFPA0lJ1P2Nz5t+R4PDpnwX9/Qyd1cqu7WZNHaQ445CfbeX15
         06YaVf0TzOIdrPOCq99M7u9EIZ/T2rIuJ2pk1JQpJl/stx8XYOUt7fOKVFPIEoztOTce
         7w1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GWQ4NmbAOvQuVmBJTPsAVw7O9rLUCX2bkGgj4ylNhZ8=;
        b=YAgqvD0XcCTgMgELnaIK85wuo0nK67uaMXM1VT8XIg80F4bglYOS8pyFcw0kHa5YYE
         VoKaKoMdOcgoFSXQJmBTK/WlhWo+/Gx8oIh0rdMlgLpOd3W5LNEYcQO3kt3WUWHzXr1K
         zO3YtHSQx+ux68cE6Zg6l2fLK0BJPWu7kQp10gl3dzEE0qytfxpqaipx82tNHQz2KzH/
         fREYoyHkG7FAQHLR0HyTv/DxkqgqeOwS0F4+9ZVBxKsCCK1aUO0ZNwhhp4Gex0KHZnAH
         SMY2ahjXoD+xUiYOEMPxwIR1eeyIc9qzlJwyPKj1/WhQCTKU3KyZJeMO6KgMPRnsIRet
         Rj7w==
X-Gm-Message-State: AJIora8kXOTYISTAyetlfgBaW78TOHRjcm66nr6j5VvSA5qTj0O/g+hT
        /ZO9TlOqfQEZCzKmg2R85iJTb/cRSIArkw==
X-Google-Smtp-Source: AGRyM1tOF1pLUYmhOdTY0J6I+mNo4OKUYzlaQkbnfZxsu008jacrR0FKL5nfnxd1nGXExeuGnqh9xw==
X-Received: by 2002:adf:e30c:0:b0:21e:51b9:113c with SMTP id b12-20020adfe30c000000b0021e51b9113cmr3749535wrj.247.1658410978125;
        Thu, 21 Jul 2022 06:42:58 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id l35-20020a05600c1d2300b003a2fc754313sm2002880wms.10.2022.07.21.06.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:42:57 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 08/13] net: netfilter: Add kfuncs to set and change CT timeout
Date:   Thu, 21 Jul 2022 15:42:40 +0200
Message-Id: <20220721134245.2450-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6455; i=memxor@gmail.com; h=from:subject; bh=OCPTpPWjMSt2W3MIQnedaBDmVawPfw0jQXD/8HmXdkU=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfO0lx+hxtIz3gIrRT8nRWdtErMYxsWXjqOS89v tR/thc+JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzgAKCRBM4MiGSL8Ryj2BD/ 9bRNQ5UeBaN7ug2oC5nPycqCYUl7LM3dAo9iMhvj0OCvvO1sZ51UFd9ru+Pgm3vsNIjpXXVfVz5rUj SnEJDCfF10UZNBU+ApVxc/bQyAg2YxpsERDb0YCRBjRehbyP8Sgi0d7MX3kEPJ9pqeywhI4J6+hGTV ryNDl+d+bn+W3t7qr/HuEv3upcALPA38lgD5A/v1k2eYs3fKe2Nmkpxr/reqzgVqmmjO7ZuDoWV1pt eRO6IXOMTG2I1tLB4V0DSnbcssh13jT1Pi6xPSmG6eLS08DFApDuWo/EszLx75OWRe1MUMV+nDksDI pqFFiHgm8N3tOdVRgDzInoL0UW7y14fKq9KUpUVKZSV7ZiptjR3P1V5WFvzot0Lv0P8jDc0PV6pG5I gMvBGjFo2T4ZtF27cazTAK7VSi9+N8NYrKWJr9hjnJ2T1YTEAQVKqUj8gKVGDLUV5bCSV8gITXMzd9 vMsSOXtT6+rZ+bUBSvLrcF9jM7peGL6vnwcxue69Xf0TNImPjY1wHBs12RxxP/1ezlObid4O8aEsjx nPsVWaiQUbzgNam5YBQCdkz2eiMBzMUPrud9SpaHhg6u01H5w/BX/N8TNeSrNKptmB3Q0chLvDKIuB YaHAbkYyKDNt8RY5Lfe11yL0WOcpy/MTB/qIUOH5xWfIEeXCgCzc2vK4ZQMw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

Introduce bpf_ct_set_timeout and bpf_ct_change_timeout kfunc helpers in
order to change nf_conn timeout. This is same as ctnetlink_change_timeout,
hence code is shared between both by extracting it out to
__nf_ct_change_timeout. It is also updated to return an error when it
sees IPS_FIXED_TIMEOUT_BIT bit in ct->status, as that check was missing.

It is required to introduce two kfuncs taking nf_conn___init and nf_conn
instead of sharing one because KF_TRUSTED_ARGS flag causes strict type
checking. This would disallow passing nf_conn___init to kfunc taking
nf_conn, and vice versa. We cannot remove the KF_TRUSTED_ARGS flag as we
only want to accept refcounted pointers and not e.g. ct->master.

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
 net/netfilter/nf_conntrack_bpf.c          | 38 +++++++++++++++++++++--
 net/netfilter/nf_conntrack_core.c         | 22 +++++++++++++
 net/netfilter/nf_conntrack_netlink.c      |  9 +-----
 4 files changed, 60 insertions(+), 11 deletions(-)

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
index cac4a9558968..b8912e15082f 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -331,12 +331,12 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
  *
  * This must be invoked for referenced PTR_TO_BTF_ID.
  *
- * @nfct__ref	 - Pointer to referenced nf_conn___init object, obtained
+ * @nfct	 - Pointer to referenced nf_conn___init object, obtained
  *		   using bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
  */
-struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
+struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 {
-	struct nf_conn *nfct = (struct nf_conn *)nfct__ref;
+	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
 	err = nf_conntrack_hash_check_insert(nfct);
@@ -364,6 +364,36 @@ void bpf_ct_release(struct nf_conn *nfct)
 	nf_ct_put(nfct);
 }
 
+/* bpf_ct_set_timeout - Set timeout of allocated nf_conn
+ *
+ * Sets the default timeout of newly allocated nf_conn before insertion.
+ * This helper must be invoked for refcounted pointer to nf_conn___init.
+ *
+ * Parameters:
+ * @nfct	 - Pointer to referenced nf_conn object, obtained using
+ *                 bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
+ * @timeout      - Timeout in msecs.
+ */
+void bpf_ct_set_timeout(struct nf_conn___init *nfct, u32 timeout)
+{
+	__nf_ct_set_timeout((struct nf_conn *)nfct, msecs_to_jiffies(timeout));
+}
+
+/* bpf_ct_change_timeout - Change timeout of inserted nf_conn
+ *
+ * Change timeout associated of the inserted or looked up nf_conn.
+ * This helper must be invoked for refcounted pointer to nf_conn.
+ *
+ * Parameters:
+ * @nfct	 - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_ct_insert_entry, bpf_xdp_ct_lookup, or bpf_skb_ct_lookup.
+ * @timeout      - New timeout in msecs.
+ */
+int bpf_ct_change_timeout(struct nf_conn *nfct, u32 timeout)
+{
+	return __nf_ct_change_timeout(nfct, msecs_to_jiffies(timeout));
+}
+
 __diag_pop()
 
 BTF_SET8_START(nf_ct_kfunc_set)
@@ -373,6 +403,8 @@ BTF_ID_FLAGS(func, bpf_skb_ct_alloc, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_skb_ct_lookup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_ct_insert_entry, KF_ACQUIRE | KF_RET_NULL | KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_ct_release, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
 BTF_SET8_END(nf_ct_kfunc_set)
 
 static const struct btf_kfunc_id_set nf_conntrack_kfunc_set = {
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
2.34.1

