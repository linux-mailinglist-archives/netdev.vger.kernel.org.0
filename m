Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BF710962
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfEAOoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38873 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfEAOoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id k16so24840439wrn.5
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bFUvv35ufEZvkXkPHvBLDe5lZpgODNVDdkEpJrmoqTU=;
        b=nVbtYKH+ZK9vn6OVV86K6kJuyqP/UHl9CVeLxdpE/MQbeu9AxsrbR/NarVHlabJLSt
         i0TrWOYQXCGJcAWKN9pDREVfoatKNYYrDXoPTiJ2npBVwiZ1MReQg8DiGjBa4zPvGCKK
         G2zbL/FkDY1sRn8np7LEFrjANICO83yz1ROc+UF0wEXWcxqioWOrr012Qjp3MlN4SDE9
         VUISyAvL3Wn85mWo1/bFPTTftJaqSXWpSH2y3mwHbjEhJBuT3dt52vQRlCzPtJIBW0EK
         Rb8u2HvBMLA6K1hGoX1y97NB6ThQfH6Fn7lVLmPG67yBpFZrBvRDvll/QDYtvJno9wtC
         GFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bFUvv35ufEZvkXkPHvBLDe5lZpgODNVDdkEpJrmoqTU=;
        b=eInYdrII+xjg/e282f9JS/IOdbr9jz/ZFG58bswMeYpIqwF66XV9yRlRnvZvTht9U/
         aOHJ7/RPLGiIYsFdnE5zLqSGxiD3bR474yoFsXpJ4XsIVZLzBvdJF3gCVv7MFne7KDH+
         zCawvXd+Hiu1fsI/sNPogvbkXVK52Xh3ZoHDbJx1o4j+kPddNCEJ+EEhtpyUokewjSF3
         LCknDQXctMXsQ86u2Wi2PTXAL4Y8YAOlgTLVtNdrZMDx6rdkzBrTQi7fEyGNafkT1U27
         N7FRnZVtjGhQsf+0TOiwdFM9MNde6K9jYA6Kbqnl4YCcdxn5cVN/8OXXBGcI9OGGl719
         9FmA==
X-Gm-Message-State: APjAAAUkD8QdjxuWmQWhayGoXiRvXSgT8pkUN73npZYIZNis0VxG4Olz
        tR8K4+AKbYfIBxOAbuf290n3fQ==
X-Google-Smtp-Source: APXvYqxqaxo1CJW9JlO4rZVw29vjIMKifM6w84BQCPeO9dR61drugy/RCA2f7vI28S/aAw4+M0HZ+g==
X-Received: by 2002:adf:b458:: with SMTP id v24mr51433250wrd.46.1556721855998;
        Wed, 01 May 2019 07:44:15 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:15 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v5 bpf-next 06/17] bpf: introduce new bpf prog load flags "BPF_F_TEST_RND_HI32"
Date:   Wed,  1 May 2019 15:43:51 +0100
Message-Id: <1556721842-29836-7-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
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
later instructions. Such randomization is only enabled under testing mode
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

