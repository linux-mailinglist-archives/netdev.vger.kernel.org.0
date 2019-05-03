Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7CC12BB1
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfECKnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:43:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53684 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfECKnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:43:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id q15so6528569wmf.3
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b4GJQTWDVBJq1m3fxHOO42uDLODxtF5vCgGQ8/DfFII=;
        b=S5kRzRY+QfxvmfipSRFh+a3ONIYB86FVux7cp0xsmRw94SVs7xNQzD4hORPzSZQpDF
         2ZJhbhQSQC9hM+pfUho/KAggUvNNe2IJ8c06HMHP5qU6zM6XngN5jzIoWHvk1EPot4xN
         X/6+4avm0uaYDLk/gq5+txkCEPW6hIEcbI2h8TVAZaAciNlkrjAe61xXkYiWWQZT6mN1
         iFUy1nhbhbkYFRoYJF1h7PTwgLS9odaOo8Jj9R1Zmew10b0DDKEauZQmLkgI/b7J75DV
         Ojqrz/aV8bTF6P0OUO9AUr7WefAnkt3bJ90VPIHIe+nRLIX6orxN5BQkBwTEHAfddcTY
         /xLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b4GJQTWDVBJq1m3fxHOO42uDLODxtF5vCgGQ8/DfFII=;
        b=cCdj0AxRSXdmqQ+joDXjybwb46m50nl7MYqGDHJdfQjaqaYIQowTa7qouvALr/XD5d
         hqWGtYqfD1xr42/vhDzbOekWTcwRXsr0sqDZ3GM40tbbeYMzvfKObMee+mJunaZE5FN9
         byMNM2yolUr+fN1vgDodi+zhpi2mL6kNZbrLn3OmzRkYciQPTrE2YzyHp1zG9qafYKlE
         vMnYR+ldApqGU3a0o5WFQT3dU0Vg92/FG5SXeQYSyjpCLACO+uz7uNnpxgY73eYG1c56
         OSl58oVKeJRqSS6AmUz1nRZiy34ToCVid0ECh3PGaAcvIzGp8d2zzsr0+RjatTBOAeVZ
         GcnA==
X-Gm-Message-State: APjAAAXJCas68SiysgNqxUj/Z89kgnyyKe28uwVMLMpnhrA3z+Uxvwnc
        gcR8NbN0LAy+6njwxQWClphJjaddt5E=
X-Google-Smtp-Source: APXvYqy6DY1350w3NQQn+1v8y34u3WPyrMeqTT1xIjB94hwXMLEAGF+Wap4+2h+8M2FMJ2govK7+og==
X-Received: by 2002:a7b:cb04:: with SMTP id u4mr5755752wmj.0.1556880229541;
        Fri, 03 May 2019 03:43:49 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:48 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v6 bpf-next 06/17] bpf: introduce new bpf prog load flags "BPF_F_TEST_RND_HI32"
Date:   Fri,  3 May 2019 11:42:33 +0100
Message-Id: <1556880164-10689-7-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

x86_64 and AArch64 perhaps are two arches that running bpf testsuite
frequently, however the zero extension insertion pass is not enabled for
them because of their hardware support.

It is critical to guarantee the pass correction as it is supposed to be
enabled at default for a couple of other arches, for example PowerPC,
SPARC, arm, NFP etc. Therefore, it would be very useful if there is a way
to test this pass on for example x86_64.

The test methodology employed by this set is "poisoning" useless bits. High
32-bit of a definition is randomized if it is identified as not used by any
later instruction. Such randomization is only enabled under testing mode
which is gated by the new bpf prog load flags "BPF_F_TEST_RND_HI32".

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/uapi/linux/bpf.h       | 18 ++++++++++++++++++
 kernel/bpf/syscall.c           |  4 +++-
 tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 22ccdf4..1bf32c3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -263,6 +263,24 @@ enum bpf_attach_type {
  */
 #define BPF_F_ANY_ALIGNMENT	(1U << 1)
 
+/* BPF_F_TEST_RND_HI32 is used in BPF_PROG_LOAD command for testing purpose.
+ * Verifier does sub-register def/use analysis and identifies instructions whose
+ * def only matters for low 32-bit, high 32-bit is never referenced later
+ * through implicit zero extension. Therefore verifier notifies JIT back-ends
+ * that it is safe to ignore clearing high 32-bit for these instructions. This
+ * saves some back-ends a lot of code-gen. However such optimization is not
+ * necessary on some arches, for example x86_64, arm64 etc, whose JIT back-ends
+ * hence hasn't used verifier's analysis result. But, we really want to have a
+ * way to be able to verify the correctness of the described optimization on
+ * x86_64 on which testsuites are frequently exercised.
+ *
+ * So, this flag is introduced. Once it is set, verifier will randomize high
+ * 32-bit for those instructions who has been identified as safe to ignore them.
+ * Then, if verifier is not doing correct analysis, such randomization will
+ * regress tests to expose bugs.
+ */
+#define BPF_F_TEST_RND_HI32	(1U << 2)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
  *
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ad3ccf8..ec1b42c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1601,7 +1601,9 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (CHECK_ATTR(BPF_PROG_LOAD))
 		return -EINVAL;
 
-	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT | BPF_F_ANY_ALIGNMENT))
+	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT |
+				 BPF_F_ANY_ALIGNMENT |
+				 BPF_F_TEST_RND_HI32))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 22ccdf4..1bf32c3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -263,6 +263,24 @@ enum bpf_attach_type {
  */
 #define BPF_F_ANY_ALIGNMENT	(1U << 1)
 
+/* BPF_F_TEST_RND_HI32 is used in BPF_PROG_LOAD command for testing purpose.
+ * Verifier does sub-register def/use analysis and identifies instructions whose
+ * def only matters for low 32-bit, high 32-bit is never referenced later
+ * through implicit zero extension. Therefore verifier notifies JIT back-ends
+ * that it is safe to ignore clearing high 32-bit for these instructions. This
+ * saves some back-ends a lot of code-gen. However such optimization is not
+ * necessary on some arches, for example x86_64, arm64 etc, whose JIT back-ends
+ * hence hasn't used verifier's analysis result. But, we really want to have a
+ * way to be able to verify the correctness of the described optimization on
+ * x86_64 on which testsuites are frequently exercised.
+ *
+ * So, this flag is introduced. Once it is set, verifier will randomize high
+ * 32-bit for those instructions who has been identified as safe to ignore them.
+ * Then, if verifier is not doing correct analysis, such randomization will
+ * regress tests to expose bugs.
+ */
+#define BPF_F_TEST_RND_HI32	(1U << 2)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
  *
-- 
2.7.4

