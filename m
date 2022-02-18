Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70334BBEB1
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 18:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbiBRRvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 12:51:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238846AbiBRRuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 12:50:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F03A66604
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645206636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RpV1EzK6NqZpSqOlfHeXkxYDh18aJpJ+bK/njkfrFHk=;
        b=eHZ03RQK7V4Jb8KMGlOxB0cqIQHRk8tbvta4iLWqzzHKC3E1QMnJfbNaFmHtld6HdE4g0e
        WKYeb0sPH87S7madNSFdETQEFe/HF8dq2DCTOQ6nWPsee+J32zObx+V3Sy+/5KwOBmlwwf
        cEPPXSETJsYlJRfN6W6Ns6ocpG1tixM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-mxI8At1MOVmQdJJAeVxUOg-1; Fri, 18 Feb 2022 12:50:35 -0500
X-MC-Unique: mxI8At1MOVmQdJJAeVxUOg-1
Received: by mail-ej1-f71.google.com with SMTP id sa22-20020a1709076d1600b006ce78cacb85so3413349ejc.2
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:50:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RpV1EzK6NqZpSqOlfHeXkxYDh18aJpJ+bK/njkfrFHk=;
        b=pfeij67JPukiZzjEOH9O2d/7w0sydNvg9r+4c0vIUN0eOwbPSdV0XrTJk8FF13Sq1G
         K3UcskA0/l1pA/PLHJqB2+2ocVo1bLcHAE+o/wWwpamz7k5ht8OcpXGPuCXOXavCHakB
         RadGr9NdMasrilddSPUMqa4ChUZJ53/Qw8lZYOQ5sx6Ri+mCxCXIRaWwVCIh+P6Qmojo
         Z6acyTR2mWx2kmghDSxmD5C4FN+LzNkKWYYKUTN7Q9SV5WJ1Zv3L2e/OLAoRheYMvVz0
         eD/f7cd9Ko6yxpgIiJqyr9R0JiSVgdqvhE8fZWi5i+8nJiN8sgRMQBRVm5SbC7vtjxsr
         HsWg==
X-Gm-Message-State: AOAM5300INOzv7C3Yj+D4gfZ9Kkrx0owVL948BtXnY4wCSdvSrUrk3MA
        9/Yw6Yf6e3NZD2nVrd4Z7w567s73wQvae63exoEHyHcJ/YSOzUWT1lOA05hA3T/iXUN8zPXFLbw
        p0UfHBDbyu6wLT6Kl
X-Received: by 2002:a17:906:5950:b0:6b3:65b7:82d3 with SMTP id g16-20020a170906595000b006b365b782d3mr7215933ejr.636.1645206634023;
        Fri, 18 Feb 2022 09:50:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6RMdtjL4BLpokb/4tKxAFqUkA7AJv9sCqaPSgk80oPrQoeYK4UBKFOr3qebiRXk58M/SwgQ==
X-Received: by 2002:a17:906:5950:b0:6b3:65b7:82d3 with SMTP id g16-20020a170906595000b006b365b782d3mr7215903ejr.636.1645206633628;
        Fri, 18 Feb 2022 09:50:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id jz17sm2449998ejb.195.2022.02.18.09.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 09:50:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5982F13023E; Fri, 18 Feb 2022 18:50:31 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v8 2/5] Documentation/bpf: Add documentation for BPF_PROG_RUN
Date:   Fri, 18 Feb 2022 18:50:26 +0100
Message-Id: <20220218175029.330224-3-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218175029.330224-1-toke@redhat.com>
References: <20220218175029.330224-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds documentation for the BPF_PROG_RUN command; a short overview of
the command itself, and a more verbose description of the "live packet"
mode for XDP introduced in the previous commit.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 Documentation/bpf/bpf_prog_run.rst | 120 +++++++++++++++++++++++++++++
 Documentation/bpf/index.rst        |   1 +
 2 files changed, 121 insertions(+)
 create mode 100644 Documentation/bpf/bpf_prog_run.rst

diff --git a/Documentation/bpf/bpf_prog_run.rst b/Documentation/bpf/bpf_prog_run.rst
new file mode 100644
index 000000000000..c561677081de
--- /dev/null
+++ b/Documentation/bpf/bpf_prog_run.rst
@@ -0,0 +1,120 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Running BPF programs from userspace
+===================================
+
+This document describes the ``BPF_PROG_RUN`` facility for running BPF programs
+from userspace.
+
+.. contents::
+    :local:
+    :depth: 2
+
+
+Overview
+--------
+
+The ``BPF_PROG_RUN`` command can be used through the ``bpf()`` syscall to
+execute a BPF program in the kernel and return the results to userspace. This
+can be used to unit test BPF programs against user-supplied context objects, and
+as way to explicitly execute programs in the kernel for their side effects. The
+command was previously named ``BPF_PROG_TEST_RUN``, and both constants continue
+to be defined in the UAPI header, aliased to the same value.
+
+The ``BPF_PROG_RUN`` command can be used to execute BPF programs of the
+following types:
+
+- ``BPF_PROG_TYPE_SOCKET_FILTER``
+- ``BPF_PROG_TYPE_SCHED_CLS``
+- ``BPF_PROG_TYPE_SCHED_ACT``
+- ``BPF_PROG_TYPE_XDP``
+- ``BPF_PROG_TYPE_SK_LOOKUP``
+- ``BPF_PROG_TYPE_CGROUP_SKB``
+- ``BPF_PROG_TYPE_LWT_IN``
+- ``BPF_PROG_TYPE_LWT_OUT``
+- ``BPF_PROG_TYPE_LWT_XMIT``
+- ``BPF_PROG_TYPE_LWT_SEG6LOCAL``
+- ``BPF_PROG_TYPE_FLOW_DISSECTOR``
+- ``BPF_PROG_TYPE_STRUCT_OPS``
+- ``BPF_PROG_TYPE_RAW_TRACEPOINT``
+- ``BPF_PROG_TYPE_SYSCALL``
+
+When using the ``BPF_PROG_RUN`` command, userspace supplies an input context
+object and (for program types operating on network packets) a buffer containing
+the packet data that the BPF program will operate on. The kernel will then
+execute the program and return the results to userspace. Note that programs will
+not have any side effects while being run in this mode; in particular, packets
+will not actually be redirected or dropped, the program return code will just be
+returned to userspace. A separate mode for live execution of XDP programs is
+provided, documented separately below.
+
+Running XDP programs in "live frame mode"
+-----------------------------------------
+
+The ``BPF_PROG_RUN`` command has a separate mode for running live XDP programs,
+which can be used to execute XDP programs in a way where packets will actually
+be processed by the kernel after the execution of the XDP program as if they
+arrived on a physical interface. This mode is activated by setting the
+``BPF_F_TEST_XDP_LIVE_FRAMES`` flag when supplying an XDP program to
+``BPF_PROG_RUN``. Earlier versions of the kernel did not reject invalid flags
+supplied to ``BPF_PROG_RUN`` for XDP programs. For this reason, another new
+flag, ``BPF_F_TEST_XDP_RESERVED`` is defined, which will simply be rejected if
+set. Userspace can use this for feature probing: if the reserved flag is
+rejected, live frame mode is supported by the running kernel.
+
+The live packet mode is optimised for high performance execution of the supplied
+XDP program many times (suitable for, e.g., running as a traffic generator),
+which means the semantics are not quite as straight-forward as the regular test
+run mode. Specifically:
+
+- When executing an XDP program in live frame mode, the result of the execution
+  will not be returned to userspace; instead, the kernel will perform the
+  operation indicated by the program's return code (drop the packet, redirect
+  it, etc). For this reason, setting the ``data_out`` or ``ctx_out`` attributes
+  in the syscall parameters when running in this mode will be rejected. In
+  addition, not all failures will be reported back to userspace directly;
+  specifically, only fatal errors in setup or during execution (like memory
+  allocation errors) will halt execution and return an error. If an error occurs
+  in packet processing, like a failure to redirect to a given interface,
+  execution will continue with the next repetition; these errors can be detected
+  via the same trace points as for regular XDP programs.
+
+- Userspace can supply an ifindex as part of the context object, just like in
+  the regular (non-live) mode. The XDP program will be executed as though the
+  packet arrived on this interface; i.e., the ``ingress_ifindex`` of the context
+  object will point to that interface. Furthermore, if the XDP program returns
+  ``XDP_PASS``, the packet will be injected into the kernel networking stack as
+  though it arrived on that ifindex, and if it returns ``XDP_TX``, the packet
+  will be transmitted *out* of that same interface. Do note, though, that
+  because the program execution is not happening in driver context, an
+  ``XDP_TX`` is actually turned into the same action as an ``XDP_REDIRECT`` to
+  that same interface (i.e., it will only work if the driver has support for the
+  ``ndo_xdp_xmit`` driver op).
+
+- When running the program with multiple repetitions, the execution will happen
+  in batches, where the program is executed multiple times in a loop, the result
+  is saved, and other actions (like redirecting the packet or passing it to the
+  networking stack) will happen for the whole batch after the execution. This is
+  similar to how execution happens in driver-mode XDP for each hardware NAPI
+  cycle. The batch size defaults to 64 packets (which is same as the NAPI batch
+  size), but the batch size can be specified by userspace through the
+  ``batch_size`` parameter, up to a maximum of 256 packets.
+
+- When setting up the test run, the kernel will initialise a pool of memory
+  pages of the same size as the batch size. Each memory page will be initialised
+  with the initial packet data supplied by userspace at ``BPF_PROG_RUN``
+  invocation. When possible, the pages will be recycled on future program
+  invocations, to improve performance. Pages will generally be recycled a full
+  batch at a time, except when a packet is dropped (by return code or because
+  of, say, a redirection error), in which case that page will be recycled
+  immediately. If a packet ends up being passed to the regular networking stack
+  (because the XDP program returns ``XDP_PASS``, or because it ends up being
+  redirected to an interface that injects it into the stack), the page will be
+  released and a new one will be allocated when the pool is empty.
+
+  When recycling, the page content is not rewritten; only the packet boundary
+  pointers (``data``, ``data_end`` and ``data_meta``) in the context object will
+  be reset to the original values. This means that if a program rewrites the
+  packet contents, it has to be prepared to see either the original content or
+  the modified version on subsequent invocations.
diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index ef5c996547ec..96056a7447c7 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -21,6 +21,7 @@ that goes into great technical depth about the BPF Architecture.
    helpers
    programs
    maps
+   bpf_prog_run
    classic_vs_extended.rst
    bpf_licensing
    test_debug
-- 
2.35.1

