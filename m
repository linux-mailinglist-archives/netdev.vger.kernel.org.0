Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55BE57CC47
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiGUNny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiGUNnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:43:12 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7FE7CB75;
        Thu, 21 Jul 2022 06:43:01 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f24-20020a1cc918000000b003a30178c022so3345792wmb.3;
        Thu, 21 Jul 2022 06:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KomJc3EzWq1t7KXJbv19gWXLzaKJz4MGzmYYx1H9s0g=;
        b=LU3yqetnBIxeH1OM/iuGKrsBaEsPWie/heLVy4XpAb4gKS30Z3vAZnKi3p00epwECn
         cleAtybetQC7CSqiWfIHHFlaP0UX1wcyW0lKanCbIzFoztfrHMY3R0udUaCaySz+exbe
         YJOgn6cVFAD6Y972XmPp7foKkb1/iyw+I3GlHfRiRPJZoAEQecUsoTQmJc6DWA0OT2F5
         GHC7d7z/4Zsh/fXc0v6hFgIXVB80C1HWK2sshToQoHwcEMimv3Mvo0sJRw4G4h1YQFZt
         RvDpH6NP487fKFotbdboYe5XA9ia+cCg+nsWjSFVUWBTfaXl3GPNAivcds95Xv0Z44NT
         3Ihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KomJc3EzWq1t7KXJbv19gWXLzaKJz4MGzmYYx1H9s0g=;
        b=8Gx3YPgh9lz3xus/NAo8jTtdBeIMQfX7ubdeojLnsL9eVEMEE99XTv1TG5DymTaKdT
         X19U9ZWVjmO/hDs2iihn3WIxfk2imq57L3AieA/VHFwBJGTPfkecAXYsRLtqBAjwBalV
         /FPwaJuVCOTYyUE8ahJel6tFgczY2EnW1KDXGWVla2gfZTy1opZJsSc4lyQ+RUvAnixo
         Bpuc0G+JapVheF109R1J7r5KChhn7l5JzFdOPkGE/CtiS1NbW/9J3LKkqfCqMmydgbXW
         +U6XwUQrX1ZoguZSkMwprKCo7LZ0A8GTOQx5aIu/PC3zvt/lvfyXcqotXx0dXkI8nxVo
         n0Vw==
X-Gm-Message-State: AJIora+tEKldcMxdTzd+0Fbra7ftLfwbn+GtXpPA9Ut0BtgmwcLoJKW2
        DriQBEot0NekgoSAqQfAGwaxaNgP1ZuZtQ==
X-Google-Smtp-Source: AGRyM1vH3lyexiayn0YwEaYRmJ5HtTX3joZY1skTDs5u9cEx2NhU8Bd4l2eYGsqg+FDuY4eO5TJtuw==
X-Received: by 2002:a05:600c:17d5:b0:3a3:576:21ba with SMTP id y21-20020a05600c17d500b003a3057621bamr8236545wmo.176.1658410979244;
        Thu, 21 Jul 2022 06:42:59 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id l3-20020a1c7903000000b003a320e6f011sm2250188wme.1.2022.07.21.06.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:42:58 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 09/13] net: netfilter: Add kfuncs to set and change CT status
Date:   Thu, 21 Jul 2022 15:42:41 +0200
Message-Id: <20220721134245.2450-10-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7069; i=memxor@gmail.com; h=from:subject; bh=JQGi4triSc0P8VO80gyqRsn2oEtALfT5a4oI1C9dlMU=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfOtZAzjjYFjXidUNtQ99aPNZYvvUO2Ci9GDRBz X3eCxE+JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzgAKCRBM4MiGSL8Rys5dD/ 4rKxPgBBMqnICMWgBapptsV0BnyrANk/fyJSi3++cbiEdz4QoF3rXI+Kq6fsBPakGUaYe5RqYzCD9s qaN31/38L40goquseOhEoO4J/GsszHUhgNt/SFi6yR4imVq+zRVrkswnBdHe1sO6CgsiAcCWLEr741 81P7zwhe8KMGjOyyq4cFShXmw7dDlyh/REW7BVRXALIenhpF/3nMn7KKJSdovEpdr8k5go2+ygciJL 46UM8laEj1SIF5voEYXgJsdtf5w3wcTh17ezqMwYdKwdlDq0o6rDysq1ber6EyBweUctbTuw67YGPl xNSn+D6nLNZHZHGGT4I2i9bugs7AHBFwp+bBdS0Y+pzI7GGRfvMwiHc/EA5wsPe5gnGApfYoCovzzc 6xAoROgktbYyOYbXI8PlCbKciX7DKL32vVohoKANNtcknNWUHQ0nITajVoxcYa1q2jFm+G8OKXjapK 8pCDP0pX3/LyjNnl4+O6FRaT5/lRbBVzDHmMsveHIZKnX45ZRYFx9O3QZi005FaiaUZvGifarUNFqk bAfbeJ+Zrdmb9bm99yS4hLtRIClpCTtNFQOg+IPY1AI62W8kLMWYxz2M2xMjVRDzgn8LyiJhKirPnL rhiUwPbPP+Gx3WbN71tBJr7Xd2b0Oe64ET0MxAcEZGl+6oBvs6s3rFsb/ocw==
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce bpf_ct_set_status and bpf_ct_change_status kfunc helpers in
order to set nf_conn field of allocated entry or update nf_conn status
field of existing inserted entry. Use nf_ct_change_status_common to
share the permitted status field changes between netlink and BPF side
by refactoring ctnetlink_change_status.

It is required to introduce two kfuncs taking nf_conn___init and nf_conn
instead of sharing one because KF_TRUSTED_ARGS flag causes strict type
checking. This would disallow passing nf_conn___init to kfunc taking
nf_conn, and vice versa. We cannot remove the KF_TRUSTED_ARGS flag as we
only want to accept refcounted pointers and not e.g. ct->master.

Hence, bpf_ct_set_* kfuncs are meant to be used on allocated CT, and
bpf_ct_change_* kfuncs are meant to be used on inserted or looked up
CT entry.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/netfilter/nf_conntrack_core.h |  2 ++
 net/netfilter/nf_conntrack_bpf.c          | 32 ++++++++++++++++++
 net/netfilter/nf_conntrack_core.c         | 40 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c      | 39 ++--------------------
 4 files changed, 76 insertions(+), 37 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 3b0f7d0eebae..3cd3a6e631aa 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -98,6 +98,8 @@ static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
 }
 
 int __nf_ct_change_timeout(struct nf_conn *ct, u64 cta_timeout);
+void __nf_ct_change_status(struct nf_conn *ct, unsigned long on, unsigned long off);
+int nf_ct_change_status_common(struct nf_conn *ct, unsigned int status);
 
 #endif
 
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index b8912e15082f..1cd87b28c9b0 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -394,6 +394,36 @@ int bpf_ct_change_timeout(struct nf_conn *nfct, u32 timeout)
 	return __nf_ct_change_timeout(nfct, msecs_to_jiffies(timeout));
 }
 
+/* bpf_ct_set_status - Set status field of allocated nf_conn
+ *
+ * Set the status field of the newly allocated nf_conn before insertion.
+ * This must be invoked for referenced PTR_TO_BTF_ID to nf_conn___init.
+ *
+ * Parameters:
+ * @nfct	 - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
+ * @status       - New status value.
+ */
+int bpf_ct_set_status(const struct nf_conn___init *nfct, u32 status)
+{
+	return nf_ct_change_status_common((struct nf_conn *)nfct, status);
+}
+
+/* bpf_ct_change_status - Change status of inserted nf_conn
+ *
+ * Change the status field of the provided connection tracking entry.
+ * This must be invoked for referenced PTR_TO_BTF_ID to nf_conn.
+ *
+ * Parameters:
+ * @nfct	 - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_ct_insert_entry, bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
+ * @status       - New status value.
+ */
+int bpf_ct_change_status(struct nf_conn *nfct, u32 status)
+{
+	return nf_ct_change_status_common(nfct, status);
+}
+
 __diag_pop()
 
 BTF_SET8_START(nf_ct_kfunc_set)
@@ -405,6 +435,8 @@ BTF_ID_FLAGS(func, bpf_ct_insert_entry, KF_ACQUIRE | KF_RET_NULL | KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_ct_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_ct_set_status, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_ct_change_status, KF_TRUSTED_ARGS)
 BTF_SET8_END(nf_ct_kfunc_set)
 
 static const struct btf_kfunc_id_set nf_conntrack_kfunc_set = {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 572f59a5e936..66a0aa8dbc3b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2807,4 +2807,44 @@ int __nf_ct_change_timeout(struct nf_conn *ct, u64 timeout)
 }
 EXPORT_SYMBOL_GPL(__nf_ct_change_timeout);
 
+void __nf_ct_change_status(struct nf_conn *ct, unsigned long on, unsigned long off)
+{
+	unsigned int bit;
+
+	/* Ignore these unchangable bits */
+	on &= ~IPS_UNCHANGEABLE_MASK;
+	off &= ~IPS_UNCHANGEABLE_MASK;
+
+	for (bit = 0; bit < __IPS_MAX_BIT; bit++) {
+		if (on & (1 << bit))
+			set_bit(bit, &ct->status);
+		else if (off & (1 << bit))
+			clear_bit(bit, &ct->status);
+	}
+}
+EXPORT_SYMBOL_GPL(__nf_ct_change_status);
+
+int nf_ct_change_status_common(struct nf_conn *ct, unsigned int status)
+{
+	unsigned long d;
+
+	d = ct->status ^ status;
+
+	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
+		/* unchangeable */
+		return -EBUSY;
+
+	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
+		/* SEEN_REPLY bit can only be set */
+		return -EBUSY;
+
+	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
+		/* ASSURED bit can only be set */
+		return -EBUSY;
+
+	__nf_ct_change_status(ct, status, 0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_ct_change_status_common);
+
 #endif
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b1de07c73845..e02832ef9b9f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1890,45 +1890,10 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 }
 #endif
 
-static void
-__ctnetlink_change_status(struct nf_conn *ct, unsigned long on,
-			  unsigned long off)
-{
-	unsigned int bit;
-
-	/* Ignore these unchangable bits */
-	on &= ~IPS_UNCHANGEABLE_MASK;
-	off &= ~IPS_UNCHANGEABLE_MASK;
-
-	for (bit = 0; bit < __IPS_MAX_BIT; bit++) {
-		if (on & (1 << bit))
-			set_bit(bit, &ct->status);
-		else if (off & (1 << bit))
-			clear_bit(bit, &ct->status);
-	}
-}
-
 static int
 ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 {
-	unsigned long d;
-	unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
-	d = ct->status ^ status;
-
-	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
-		/* unchangeable */
-		return -EBUSY;
-
-	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
-		/* SEEN_REPLY bit can only be set */
-		return -EBUSY;
-
-	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
-		/* ASSURED bit can only be set */
-		return -EBUSY;
-
-	__ctnetlink_change_status(ct, status, 0);
-	return 0;
+	return nf_ct_change_status_common(ct, ntohl(nla_get_be32(cda[CTA_STATUS])));
 }
 
 static int
@@ -2825,7 +2790,7 @@ ctnetlink_update_status(struct nf_conn *ct, const struct nlattr * const cda[])
 	 * unchangeable bits but do not error out. Also user programs
 	 * are allowed to clear the bits that they are allowed to change.
 	 */
-	__ctnetlink_change_status(ct, status, ~status);
+	__nf_ct_change_status(ct, status, ~status);
 	return 0;
 }
 
-- 
2.34.1

