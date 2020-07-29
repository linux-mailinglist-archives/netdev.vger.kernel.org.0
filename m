Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B34F23228C
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgG2QXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2QXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:23:45 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6B7C061794;
        Wed, 29 Jul 2020 09:23:45 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c16so8111251ils.8;
        Wed, 29 Jul 2020 09:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lHcu/L7FcFxRMGJU+8YueSbZhkiUnO5f9pnqYrcV6Yw=;
        b=iaZxIiX/+z1QRV8VJ3wB0twiky2werDLl4zcxwqTZGLxti+KbHnv/lDxf0ggNV8wRm
         YOy5bJg8RWfr3+kho3jW7D4ueuj+HJJvFzoUMMvbDwWs+cdaytZr0i7S3aYMigLvBHoh
         Ph+8QVB6y02daWiEuZufyIz6xkL2mu3tQidwrKMgRXE0L/1j8yM2qmFU6I4ympLjiEOE
         c/JeMBi7wwAtuIwV39qw8jDTPDNGdGjJi7kS4nMowOHdV1ZwXtw7BCes4ACO7EROjLQE
         txcJOtqjg0PgkOdIh2bZbD2A+milmDvM1ORWn5vgHV1frcpyp85PhYk63tu9gYZe4rPe
         DkSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lHcu/L7FcFxRMGJU+8YueSbZhkiUnO5f9pnqYrcV6Yw=;
        b=srLXFHlGNG3QFM27pbMO8SEtbXYa7X1W24eejN4LfZiRmgJYcWsrDQ70A1zpS22Sm5
         I333xaJ8bRN8VTBmKCJI+jIbbIqCcX/VtAFB9N+4BSiFLZ+lxbBS0J2/fu3clrsxiTaT
         jebqL6znEps4qtdOBecDf9L4FtjAPeAQ54vB58oI2A+yBw9qnq6+iT0G6koO3ejW/2Jb
         cU9Td8iXyyvKZK56i/0sMd9rG2soJFRaLuzP4luHdxsFXdpoOgjttaMqF6tqbpDPvY/9
         nFEEOuiFVBlWKjRh5ET9GWd2lcLlkBlC31hCACLxeAOVKOvOFeyOHz2ARvlMxu/zgI+B
         H26A==
X-Gm-Message-State: AOAM532MFPXepixWKR55y/78e+l59MA82TqifVaEWfwIR9jCfY/L+sCa
        HglZcOcDNcKO72OTx8XsbJE=
X-Google-Smtp-Source: ABdhPJxVIo3CjKXyKKoW/56XUgpmbjTiDkmIwsvM5hZTVaEvUxtpGITr2z3n0Wl5ZNagSE14E//dXg==
X-Received: by 2002:a92:89c9:: with SMTP id w70mr27226880ilk.250.1596039824434;
        Wed, 29 Jul 2020 09:23:44 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h11sm1392616ilh.69.2020.07.29.09.23.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2020 09:23:43 -0700 (PDT)
Subject: [bpf PATCH v2 3/5] bpf,
 selftests: Add tests for ctx access in sock_ops with single register
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 29 Jul 2020 09:23:32 -0700
Message-ID: <159603981285.4454.14040533307191666685.stgit@john-Precision-5820-Tower>
In-Reply-To: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
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

