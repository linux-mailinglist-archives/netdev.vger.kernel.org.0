Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D3557A0AA
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238734AbiGSOIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238475AbiGSOIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:02 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2490A545DB;
        Tue, 19 Jul 2022 06:24:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id va17so27230214ejb.0;
        Tue, 19 Jul 2022 06:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MY+4hNAYYI9zx5FeEQL4Nr+h4m9U/8AqUDe6AbROXpw=;
        b=d1XNV0pmhTpqqToTUdPVPgF05pd8Av2jrZ7js6+DXRPm30e6E55ifiZ7mHTgzKfXSf
         ecOgKAyD5CHKGCpxqFkeHx2povX91eiHrB9d6lcZiXgK7HSrgS75rtgcJFzZcgJesRE7
         ZpA5ztndvFxoy6QRJRg8tJNEq6lgeV1J2ljsXEv7Ui1/95qZ+8eB4lpVUZom2cqZOd63
         KY9O/ARQ+sVvPeJAYBcG7ZrFRfHubzdzLXM/5dXx6H+etijDuRAP15Z8HgUavxmTjQy8
         oRoMVIHnQnDew+WQibmP5KHiJNB6ZqHd2mxZaqgW8AGV5UzvFGb95tJvZ8M7n6mI4bBL
         BxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MY+4hNAYYI9zx5FeEQL4Nr+h4m9U/8AqUDe6AbROXpw=;
        b=mX1Zuwsu3xAG2qQzoTRawNsXeDhki7a10QK/uJ8uuoa5qOGwtMNFIY81Bun4OT16JK
         jG5llkVBcRTuZIMb5iexGdqLBGH3setvdwrra0CtTPLoZ87zLtFSYbEKNiDMc8NJFtGb
         9x0c+PIIh5zEfgfeymL0JdS3Sy2mzNjqAIcm/8x20OzPkQag68DV2dKlnP6477edVwZ4
         P6AsVanOvKcbInvhgZ+1vGX4trUEgwgmcKeMo3N+Rd1Nt2CiYyINClVOBYb+WuSFkvR3
         sgPa14dVF4mqsr4bS6Zlg0UWxE6gcWmv/HmUVa8GI59VbYsEiCYGf8UBQ4G5AO55MAwu
         4rmw==
X-Gm-Message-State: AJIora9axDgm0qZ7kU/oWr3S7b29R9eqHJTnwM1U7BI0ScbzBNiC8TTW
        u0UbiisV8E0K7HdV5kFpmWU4bTy63ZxdOw==
X-Google-Smtp-Source: AGRyM1vWmQmx1UADrgJxZGWs8EwWVsuGCD47jzBL2swyWKxtBGkSi0tdLphAEKEnDm2Bd332+Zp+/A==
X-Received: by 2002:a17:907:86a5:b0:72e:fd2e:beb7 with SMTP id qa37-20020a17090786a500b0072efd2ebeb7mr20122526ejc.2.1658237083492;
        Tue, 19 Jul 2022 06:24:43 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id k22-20020a1709063e1600b0072aadbd48c7sm6655956eji.84.2022.07.19.06.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:43 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 08/13] net: netfilter: Add kfuncs to set and change CT timeout
Date:   Tue, 19 Jul 2022 15:24:25 +0200
Message-Id: <20220719132430.19993-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6451; i=memxor@gmail.com; h=from:subject; bh=6948voh0g35fM0kop8GGCsovi8iNkofA8T1dMQUsBFU=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBlIpz6xoc8qQU+HzS8aLqJB1KGXRODxPPx7p3o JSMNJkKJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8Rylz5D/ 9cJDsIO6wYz1baG1lYH01rllkp/Yor1TL76YaRmZvIGI1dFF/QTJA/2X2MQ4RBHDgmf86X+0UQiK69 8telYDB5Q/BB8wsUqNNTsrF7QNDifGVPjZvnaMFxiDZiUuebBqOdlUGNOIDF+f5LOWpGudbFVOoWte VAscIGv+hajAQCgZ/X1qobi3SiGhi1C0iUeUYvnybGPcGzHSdhjVvntWhRvNmWou86g4D6/XkcwAZk 5uv47kLRTux3t5cqOdsOC6oF3Nzd0dDeBcn5Jv0yNs+XLMaqSff3xcUSk85yTysAhjR71smz49FOCM wkyT/sSVC7FfC9UQH6hr4+vVV8dsk0Z9Bjqqr+LEAquXT6OI+gxZbGHS4R2RWK+/pwqypo9gpnqx2j xtz/fEOIYvnkzSNPeqKWzzuR6QH+QEDhNuw/NC/jO9afDgVtXFFtxV0CJInpFlAPa2yJ4mW8WO/857 pud9KIQ/gUJHBqXvqB0egNG9RtCP4K2s42kKr3Lc2qq6qDQE+QH5zOmBALuFyzEh1OdqUJ1Y4DdqRE I2XytR8+wdULtXukzi3LbYqYM4F8UZYJmFKNvleg0qg16hraAMx43h0Ek9UurBW9C/zKxeB5ljqDPi dKbEK1bq0iUB+FVtUHVxkHRjbucpF7uX8B5KLFMiuil6FPFIv5RA09SPW+Hw==
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
index 6c43160ff036..7d7e59441325 100644
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
@@ -373,6 +403,8 @@ BTF_ID_FLAGS(func, bpf_skb_ct_alloc, KF_ACQUIRE, KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_skb_ct_lookup, KF_ACQUIRE, KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_ct_insert_entry, KF_ACQUIRE, KF_RET_NULL, KF_RELEASE)
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

