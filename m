Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7433230E43
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731046AbgG1PoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730872AbgG1PoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:44:17 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61DFC061794;
        Tue, 28 Jul 2020 08:44:17 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id t15so12293179iob.3;
        Tue, 28 Jul 2020 08:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=hXCYewQgOf1GRj+9AZxGtTdlJFdph8mh/49A0A0mI+4=;
        b=Y5SH6+yYn26+RzKc+mpPNRwUKMAotLpCvJAIpZRdehxFI6H3C/rBAcl64jaGIte9aq
         Lcykdw/eWrIJ7oU1Sh23J0Zy7/xMxxZ1F9+Y5mvWzva50yW1ZVA2SJmamMyhif0qZqS1
         U1KCdIQE8+VRLMDjDgFQp6TVbksxPtXHdC9rqLstXebo755bcT2RdJVJQhucVTAoorv1
         84epcYHOS7LExSnTApOHtrpKZtU3ns8oBgS9+WzNbUuv7RXl/pIJszsuyOepp8hYk4s8
         ume8DSSuJlQ6lcV6yNawsrQz2CX7CyhWENyLJSjGDs1zOqf8xD7OkIBny7iEKeWdlKVv
         9iDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hXCYewQgOf1GRj+9AZxGtTdlJFdph8mh/49A0A0mI+4=;
        b=gEB0di9Lx7GVe6tt7MUurJS8JpahzBMojDD1pMyoE6BnnRIc/W7uFnN+c60gDXlAJx
         xjg43iLdU5M/y7JPeQGeGz0Y9V8gBJdUxEyghcjsAPfu7ltnRN64wFnmP/AQxRGc+fG8
         3c2gp7GCVEsHiTJkA0f/jzyqiJ4YUxHLFTZ0k/7BcM1/94K42Ba2GnkPkBl0ZVkTlY31
         nkjbhuCKfbLHmf7rUpxzeOBF6hTPFPWIi+d2gDOJ3DN7UGPN47ZR/83EzV841HslkQAL
         xxZqL3YlsrmUGR0wrgTnHCxyw5hVlrdmXLIXzzjn7+iGj9WpPsfquApIhrC2xI2RJC0+
         tZ0g==
X-Gm-Message-State: AOAM532mJmso3PnmXsQ41OE9YYIvz/3kVzTFNXD8BFnfrbXkq4dGEbAN
        eunO1JBKJaZqpxQDwD71QVPnVoNO
X-Google-Smtp-Source: ABdhPJyRujMfVA47jQmltLVkcChFFBsxPtU63/BTNRiq7nY97vi0+FSLC0gDqju3gWqWsXZnjZRapw==
X-Received: by 2002:a5d:9051:: with SMTP id v17mr10570527ioq.88.1595951057171;
        Tue, 28 Jul 2020 08:44:17 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s10sm10176762ilh.4.2020.07.28.08.44.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 08:44:16 -0700 (PDT)
Subject: [bpf PATCH 2/3] bpf,
 selftests: Add tests for ctx access in sock_ops with single register
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Tue, 28 Jul 2020 08:44:05 -0700
Message-ID: <159595104508.30613.1613012023546108567.stgit@john-Precision-5820-Tower>
In-Reply-To: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
References: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
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

We also add the normal case where src_reg != dst_reg so we can compare
code generation easily from llvm-objdump and ensure that case continues
to work correctly.

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

