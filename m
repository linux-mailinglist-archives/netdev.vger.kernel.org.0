Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D79618F08
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiKDD1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiKDD0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:13 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D25B13C
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:48 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p18-20020a63e652000000b0046b27534651so1865717pgj.17
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/SmIMRH/Y1RlEhU9+aJo9WoglDO0d23IHXz7QGzof4o=;
        b=oWWEdrBP33iyR3WA+I17MgMvutvdn0/iPBiKK5q4K2Nn/nGxsVPsVPqBrDkhuaaRoW
         jY0FQELOqD57dEzlX9cYJVgmnRIVQyOHtuAycjNg7z7CyoklXyevcbR7k19/BKhXngFQ
         L8NHGO2QupByMiipH5OPRb4z8O4umyWVzVXluLWDtkbyF4nZSxO3wJp0DMNI8Kfc57X7
         CMH2JRHRzbcj7GzUFxm933O2lA/dPXZw3S+P84EWgB6EegNk4kXb/Mojjny8zbsgJanX
         mM91Hp2kwt2POgYfk3sKhNu3B4LiQj7Aoe1E67WDul/w0fVoaUATqb6Rz3JQnibSAmRk
         CFtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/SmIMRH/Y1RlEhU9+aJo9WoglDO0d23IHXz7QGzof4o=;
        b=iGKD1QfuF7Z1WRfIp8UKU2i93DiKSbsZU19P0jf+U+9jxMEI+/SkB5enC5zSDle2zf
         UjvmiwmBMxUstAtJGr5A3BFVSGJdp8FSznBObJF3G5swgNTsc/0XaJdMIPleUHtwMu8T
         KAagKzhcgVPQHakErorLlziDM++fCGKpo8kPh1MRjzRc7naFZXHZd4AAp2uabg7b8JIl
         fWeJxM8qpxs7MnMhC6aQhLuh4K0LWoKTluf2yYGtEHdFbV83qCFAqEWIpCRoQRPDJJXM
         e4en2BHJlVHSGurLoHdNxhyNxmr4VSkS5VToQ8OIyVYzfXt9giNaKQ/lgSVKSPf3VPIt
         9TAA==
X-Gm-Message-State: ACrzQf0ii7ywO0OEW/Hn/TsgpTBkENsm+umdlACCinPl27sE/k/snMeX
        5F+85GlZpiqyJ4iXRpWQ8D3WxM4=
X-Google-Smtp-Source: AMsMyM4A5OOe8cbq45cAGa7FY0nMjH57LZI4EDuiMJTcLrV982AD3efX0qrTVub/Ev8SMCSkXhjlsvA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:8e81:0:b0:56b:9ce2:891f with SMTP id
 a1-20020aa78e81000000b0056b9ce2891fmr247317pfr.43.1667532347949; Thu, 03 Nov
 2022 20:25:47 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:26 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-9-sdf@google.com>
Subject: [RFC bpf-next v2 08/14] bpf: Helper to simplify calling kernel
 routines from unrolled kfuncs
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we need to call the kernel function from the unrolled
kfunc, we have to take extra care: r6-r9 belong to the callee,
not us, so we can't use these registers to stash our r1.

We use the same trick we use elsewhere: ask the user
to provide extra on-stack storage.

Also, note, the program being called has to receive and
return the context.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/xdp.h |  4 ++++
 net/core/xdp.c    | 24 +++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 8c97c6996172..09c05d1da69c 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -440,10 +440,14 @@ static inline u32 xdp_metadata_kfunc_id(int id)
 	return xdp_metadata_kfunc_ids.pairs[id].id;
 }
 void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch);
+void xdp_kfunc_call_preserving_r1(struct bpf_patch *patch, size_t r0_offset,
+				  void *kfunc);
 #else
 #define xdp_metadata_magic 0
 static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
 static void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch) { return 0; }
+static void xdp_kfunc_call_preserving_r1(struct bpf_patch *patch, size_t r0_offset,
+					 void *kfunc) {}
 #endif
 
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 8204fa05c5e9..16dd7850b9b0 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -737,6 +737,7 @@ BTF_SET8_START_GLOBAL(xdp_metadata_kfunc_ids)
 XDP_METADATA_KFUNC_xxx
 #undef XDP_METADATA_KFUNC
 BTF_SET8_END(xdp_metadata_kfunc_ids)
+EXPORT_SYMBOL(xdp_metadata_kfunc_ids);
 
 /* Make sure userspace doesn't depend on our layout by using
  * different pseudo-generated magic value.
@@ -756,7 +757,8 @@ static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
  *
  * The above also means we _cannot_ easily call any other helper/kfunc
  * because there is no place for us to preserve our R1 argument;
- * existing R6-R9 belong to the callee.
+ * existing R6-R9 belong to the callee. For the cases where calling into
+ * the kernel is the only option, see xdp_kfunc_call_preserving_r1.
  */
 void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
 {
@@ -832,6 +834,26 @@ void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *p
 
 	bpf_patch_resolve_jmp(patch);
 }
+EXPORT_SYMBOL(xdp_metadata_export_to_skb);
+
+/* Helper to generate the bytecode that calls the supplied kfunc.
+ * The kfunc has to accept a pointer to the context and return the
+ * same pointer back. The user also has to supply an offset within
+ * the context to store r0.
+ */
+void xdp_kfunc_call_preserving_r1(struct bpf_patch *patch, size_t r0_offset,
+				  void *kfunc)
+{
+	bpf_patch_append(patch,
+		/* r0 = kfunc(r1); */
+		BPF_EMIT_CALL(kfunc),
+		/* r1 = r0; */
+		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+		/* r0 = *(r1 + r0_offset); */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, r0_offset),
+	);
+}
+EXPORT_SYMBOL(xdp_kfunc_call_preserving_r1);
 
 static int __init xdp_metadata_init(void)
 {
-- 
2.38.1.431.g37b22c650d-goog

