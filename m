Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738B524224B
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 00:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHKWF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 18:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgHKWF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 18:05:27 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D222CC06174A;
        Tue, 11 Aug 2020 15:05:27 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o13so7371815pgf.0;
        Tue, 11 Aug 2020 15:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=3SMhDZAfWf+TiFUIYCUj3t3zyF7WwExUximLFCJREII=;
        b=F+zYUh66PG+HahWO4lmRcZwUZCnKJPHbEI7luhqpD9u+3fTJNoII6IllG4gmQ+TsCa
         pBgtCj4yVIBEQ8Zpb93RKdKx8+9nZLNioR8t1AYuXe3sUJnepCzP8Rr7TddzUmdGpMi1
         Aew870TLte3Xld0dfT1pFsfGTLip7b7cl/6xVcGBVggKQkjI27ZStFp5OqZXMyVeLEAY
         HaHQq5Jt3Hgaan9NPXqcBbHmusz9rBWiQL5wbhNvQQ69K7HMz6mXG4UQtFozB8Y0BVz4
         BxcOXB2J95YTl4oAj7XxTngMLtrmqgQEcWeKv1fl++BOWZqMj+ppKWQ3oBT2phNxdRlN
         0j1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3SMhDZAfWf+TiFUIYCUj3t3zyF7WwExUximLFCJREII=;
        b=Tvf7uNs9uy041eHbKnszgWjdmj0uGeU/Ky3L28HQ8OLFy3+uxcWKOLpLRrHCvkxu/O
         6j3tf9Ef8yd6sbjDxE+VeKbGlUsI1M0brp+586+EXtGRRVlicJ9idHzwspsbYMx6XwhS
         VHdA0g4l+YWHi/mRVFeDUlowAUfXDxPycMTrC/5dHntNFGzPZGlVWMlRI1rE/t7wX/Qz
         gZj9pkAOqb3sZopwiYavmZranKzAft5fL2+sm2UOtNpg2EAAp+SRr4eS+eDV8U2teuGe
         doDHS8vWvgzvqT9izrdp0XBa+40RQP3By/6kiKZC+hUfp+yHvkcSi5IEs6mJ8DyFDo+K
         8C0A==
X-Gm-Message-State: AOAM530mAwWeEoP5etZ71kU/+H0ozDBoAqYMAkwS7f7/uyR/FXrKxBxE
        kvGi8/+QF/4g+XgijeYhmGQ=
X-Google-Smtp-Source: ABdhPJyzbcHi8rrkUjynOO+PLWW1Nnj54vPmDNBmO0moEo3EWHhSKg+TeV9FQLNHSApsNgrpFqLibA==
X-Received: by 2002:a62:764e:: with SMTP id r75mr8179889pfc.234.1597183527457;
        Tue, 11 Aug 2020 15:05:27 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id gj2sm6138pjb.21.2020.08.11.15.05.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2020 15:05:26 -0700 (PDT)
Subject: [bpf PATCH v3 3/5] bpf,
 selftests: Add tests for ctx access in sock_ops with single register
From:   John Fastabend <john.fastabend@gmail.com>
To:     songliubraving@fb.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 11 Aug 2020 15:05:14 -0700
Message-ID: <159718351457.4728.3295119261717842496.stgit@john-Precision-5820-Tower>
In-Reply-To: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
References: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To verify fix ("bpf: sock_ops ctx access may stomp registers in corner case")
we want to force compiler to generate the following code when accessing a
field with BPF_TCP_SOCK_GET_COMMON,

     r1 = *(u32 *)(r1 + 96) // r1 is skops ptr

Rather than depend on clang to do this we add the test with inline asm to
the tcpbpf test. This saves us from having to create another runner and
ensures that if we break this again test_tcpbpf will crash.

With above code we get the xlated code,

  11: (7b) *(u64 *)(r1 +32) = r9
  12: (61) r9 = *(u32 *)(r1 +28)
  13: (15) if r9 == 0x0 goto pc+4
  14: (79) r9 = *(u64 *)(r1 +32)
  15: (79) r1 = *(u64 *)(r1 +0)
  16: (61) r1 = *(u32 *)(r1 +2348)
  17: (05) goto pc+1
  18: (79) r9 = *(u64 *)(r1 +32)

We also add the normal case where src_reg != dst_reg so we can compare
code generation easily from llvm-objdump and ensure that case continues
to work correctly. The normal code is xlated to,

  20: (b7) r1 = 0
  21: (61) r1 = *(u32 *)(r3 +28)
  22: (15) if r1 == 0x0 goto pc+2
  23: (79) r1 = *(u64 *)(r3 +0)
  24: (61) r1 = *(u32 *)(r1 +2348)

Where the temp variable is not used.

Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index 1f1966e..f8b13682 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -54,6 +54,7 @@ SEC("sockops")
 int bpf_testcb(struct bpf_sock_ops *skops)
 {
 	char header[sizeof(struct ipv6hdr) + sizeof(struct tcphdr)];
+	struct bpf_sock_ops *reuse = skops;
 	struct tcphdr *thdr;
 	int good_call_rv = 0;
 	int bad_call_rv = 0;
@@ -62,6 +63,18 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 	int v = 0;
 	int op;
 
+	/* Test reading fields in bpf_sock_ops using single register */
+	asm volatile (
+		"%[reuse] = *(u32 *)(%[reuse] +96)"
+		: [reuse] "+r"(reuse)
+		:);
+
+	asm volatile (
+		"%[op] = *(u32 *)(%[skops] +96)"
+		: [op] "+r"(op)
+		: [skops] "r"(skops)
+		:);
+
 	op = (int) skops->op;
 
 	update_event_map(op);

