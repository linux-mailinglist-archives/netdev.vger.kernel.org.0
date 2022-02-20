Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89ACA4BCEC0
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbiBTNsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:48:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiBTNsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:48:41 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4523921813;
        Sun, 20 Feb 2022 05:48:20 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id l8so10858885pls.7;
        Sun, 20 Feb 2022 05:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PzcNo+2Cl6iYUCYcvpUBH3gr0tfx0tpOlkynbpKJJzs=;
        b=gnkR8SFne9AxfmrY6l1U3pCSAtxEEohSpRVSFpn4eHh0ml4Jme0rYQTjuVFoDLakMh
         N4eQNTxJkoRY+/myDHc96XRvuVXV5Jujoy7Cq2Ruk5e00DC5/VQEpl9oXD/Grlf7RbrR
         cPy3ZAFPgyA0l09vRq5MECIRYXovWC3s9sGWkTrBiKElJCKDZjD0nesWncdFN8m39Kar
         uvPvX3XiCwpsduDJ0IineI1MF62YDqT3fAUKwJPUGv9n9Lq3JjlLKCcRFmr0jje4kX69
         UpvDtq0CX6UjbnQxen/FOQYStpjDzyUnbx5iwZughSYpJGRhhpmOncefnA8rXhsmrRHT
         qm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PzcNo+2Cl6iYUCYcvpUBH3gr0tfx0tpOlkynbpKJJzs=;
        b=EgMqZUllYqhhlHhK2l8oP03ADEhScGhM09lo6A6qdAjzPDCn0drRTfHM3HKr9491/n
         x+yx05BCNTANSWR3lqneL7PnKnwQwYUrJLfff/w+bXCJuTZtc/WF0187I9jiW28U7VQd
         kaaq0LnaZS3WwKCsgGG75g+nDE7JoImla/Inl82HYN7LVmIrF1OJL8JngzNa9evpRxjk
         atKNM+3+j0Ut5Djg360CtEPrieAfWgCyVVWqFoZqXdGj825lk6VdD8R6iIBvIfZVp5qG
         iVGDqRzyx8s2vw5IL7qyW7fILI0PpKtmnMA3jXnRb8o5x1ARrocXlSdI9SyqidGbIV80
         6acg==
X-Gm-Message-State: AOAM530NXBrzMJLgLyvWv9FcSlY7FAhiGOI183DW7NtZqSv4tryVEfJ2
        bj+g1ZL7gNs30oDzoeU2Km4Ek0kpfeo=
X-Google-Smtp-Source: ABdhPJxqFb7mKuV/HBOE8jJordIDkenzpU+FOrtk0NuYyxSbBgqwHYFumCCvdIjy4oBUBuMqkzlYeA==
X-Received: by 2002:a17:903:2283:b0:14d:b86b:165b with SMTP id b3-20020a170903228300b0014db86b165bmr15171985plh.41.1645364899656;
        Sun, 20 Feb 2022 05:48:19 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id g63sm9060558pfb.65.2022.02.20.05.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:19 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 01/15] bpf: Factor out fd returning from bpf_btf_find_by_name_kind
Date:   Sun, 20 Feb 2022 19:17:59 +0530
Message-Id: <20220220134813.3411982-2-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2938; h=from:subject; bh=/DfuqiVvvM+Atumhzb4HyEeRwNtGOpOsgZS5ZW8b5tQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZXkMyYe/Lt+F66RQ4bL9Z/mevwOrvjMnzoNuHb UewkETyJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGVwAKCRBM4MiGSL8RyhZEEA C65AeyeTfBXOEkpFn9Eq6xuZtpdc9omJPpWReu529cRJRFrjUYDvFK0KN+F9rNDwJsC2O0Hxicpy6B CX7BOpIrOKrrlbiGluICkOiEB+GiCyndtyJ+UC71Po2tbAaEm2Yz1evJL41M2ovtdUCLHPG/q7QA3O Zql7ooRamhF9UD86tNobw5esP7xJXDa8BCkX+M/8bnIloKXZZvMd4sFeVdhZTPHPUws6jTA88hvNYL AF/S5SVAf2Sa0vz5+yWB5tAQUvKhlVJba4zuaYngd8eq68u36hFhMZLI0j8Us0AUsSIN1aCrzPAgXQ 9s2Qf0nTw3HzBDNwwi6o3ybUvfq7QXTp8Dyp/01x8+EJQSCNt94fCIKbVSxoE+S7j5wrLcx+XJp5O1 A7mQT+eA/GCBFU32NP93PIcqsi0izNtyfNuGPjY2Xj55QxF9/mJMxesFgpvlVU1I89rKvUNgQANaKs MS7ImcUoiz+nA46oQqueVemKYom36FY+Yt8rY60N+yiMuoDuq0dp9wbCRu7TMiEEHtPCwT8CONw2Bq 419k3FJ7RN9oJJ3MQftXr43AZcO7VCnu0V/lV3dCsbD7M8TcQLaTqxk4c2z+Vay+CuKcazISe9Z51a EO0pTAYniMtdqUdRaYX/2WU55kj+Qh4R60p+ubbAx0E1YXDQxkWql+7AnAHA==
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

In next few patches, we need a helper that searches all kernel BTFs
(vmlinux and module BTFs), and finds the type denoted by 'name' and
'kind'. Turns out bpf_btf_find_by_name_kind already does the same thing,
but it instead returns a BTF ID and optionally fd (if module BTF). This
is used for relocating ksyms in BPF loader code (bpftool gen skel -L).

We extract the core code out into a new helper
btf_find_by_name_kind_all, which returns the BTF ID and BTF pointer in
an out parameter. The reference for the returned BTF pointer is only
bumped if it is a module BTF, this needs to be kept in mind when using
this helper.

Hence, the user must release the BTF reference iff btf_is_module is
true, otherwise transfer the ownership to e.g. an fd.

In case of the helper, the fd is only allocated for module BTFs, so no
extra handling for btf_vmlinux case is required.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/btf.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2c4c5dbe2abe..3645d8c14a18 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6545,16 +6545,10 @@ static struct btf *btf_get_module_btf(const struct module *module)
 	return btf;
 }
 
-BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int, flags)
+static s32 btf_find_by_name_kind_all(const char *name, u32 kind, struct btf **btfp)
 {
 	struct btf *btf;
-	long ret;
-
-	if (flags)
-		return -EINVAL;
-
-	if (name_sz <= 1 || name[name_sz - 1])
-		return -EINVAL;
+	s32 ret;
 
 	btf = bpf_get_btf_vmlinux();
 	if (IS_ERR(btf))
@@ -6580,19 +6574,40 @@ BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int
 			spin_unlock_bh(&btf_idr_lock);
 			ret = btf_find_by_name_kind(mod_btf, name, kind);
 			if (ret > 0) {
-				int btf_obj_fd;
-
-				btf_obj_fd = __btf_new_fd(mod_btf);
-				if (btf_obj_fd < 0) {
-					btf_put(mod_btf);
-					return btf_obj_fd;
-				}
-				return ret | (((u64)btf_obj_fd) << 32);
+				*btfp = mod_btf;
+				return ret;
 			}
 			spin_lock_bh(&btf_idr_lock);
 			btf_put(mod_btf);
 		}
 		spin_unlock_bh(&btf_idr_lock);
+	} else {
+		*btfp = btf;
+	}
+	return ret;
+}
+
+BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int, flags)
+{
+	struct btf *btf = NULL;
+	int btf_obj_fd = 0;
+	long ret;
+
+	if (flags)
+		return -EINVAL;
+
+	if (name_sz <= 1 || name[name_sz - 1])
+		return -EINVAL;
+
+	ret = btf_find_by_name_kind_all(name, kind, &btf);
+	if (ret > 0 && btf_is_module(btf)) {
+		/* reference for btf is only raised if module BTF */
+		btf_obj_fd = __btf_new_fd(btf);
+		if (btf_obj_fd < 0) {
+			btf_put(btf);
+			return btf_obj_fd;
+		}
+		return ret | (((u64)btf_obj_fd) << 32);
 	}
 	return ret;
 }
-- 
2.35.1

