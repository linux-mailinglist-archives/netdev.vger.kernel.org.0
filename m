Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6667C4D2D73
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 11:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiCIKyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 05:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiCIKyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 05:54:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 659B0109A78
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 02:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646823232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VjXi0yetuRcNC+6LhXHTr8Ys2xt6TP3sU5g1QXQ/UPs=;
        b=Eyd2TEHHNbokglAZ/CYkCJCIQjcbT/nFUwquCncXXEG6N1BnIH4OoQYBVOuI1P/fLcewU8
        OcH4xqp1bQJ60csXtTxzRCTd8E6uaKZA1gEjjzav9+tE9RWKiFw0Mi5TUGU12fhtPnzhuJ
        lBfUs8sePYTM3p+w+Kp/glcZ6jPMuGE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-BB0zus-5N16GCQoMYdfEcw-1; Wed, 09 Mar 2022 05:53:51 -0500
X-MC-Unique: BB0zus-5N16GCQoMYdfEcw-1
Received: by mail-ej1-f70.google.com with SMTP id d7-20020a1709061f4700b006bbf73a7becso1077209ejk.17
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 02:53:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VjXi0yetuRcNC+6LhXHTr8Ys2xt6TP3sU5g1QXQ/UPs=;
        b=F8qPrbwJbnqIVtWrqxMXL38hnA59KjpCtUs9JFTuic6CWaM6Rxdl3HdxO1N7k03K0Z
         cVFEwLDHc+dtZWn2xUPKQHplrsi0m3DJ9lDorVk7t9zGwQnKIrWtUjSEnV9NvnO/Oy0O
         DBqbZnouKrSSkvxJr26vaCMLpYqUqKz9iLA9MzfHcXmE1nd9689b6LNhWGaorNnFInY3
         uIeOPXYag1+3We0jX+hMsFmxAdHmR/CI89XV6YA5z2MsRL6r3ItA0maIbq5sB81uA3aW
         GUx8G0PljtjnqT0GI5YkqjYb/PxWzrvAftPE5kETSUAZ5gr5LouxO6Q2F06yHxa+0roj
         +g9Q==
X-Gm-Message-State: AOAM530QEiORict0htLinjoQtQ2j4SbF9JhOMM95eROpEqjOa7KFcmbq
        sDtkP/J5x5jiSWlNrf5qRutkIkSB6ci8yziJOkNKFS2LXElZ0pC7BZf153yfqTASPhg+J4jTmLG
        CXdAnNcprDF+TW5Jz
X-Received: by 2002:a05:6402:1507:b0:415:f3c7:60fe with SMTP id f7-20020a056402150700b00415f3c760femr20712439edw.350.1646823229975;
        Wed, 09 Mar 2022 02:53:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpsezsbi1YaEImv8GNRn71DRgP5uKImUBsPZnOzxKILaUUveNW2d0aVEdZSHKuWgJM+bX+bg==
X-Received: by 2002:a05:6402:1507:b0:415:f3c7:60fe with SMTP id f7-20020a056402150700b00415f3c760femr20712392edw.350.1646823229488;
        Wed, 09 Mar 2022 02:53:49 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d2-20020a50cf42000000b004135b6eef60sm652643edk.94.2022.03.09.02.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 02:53:48 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 55BD5192AA9; Wed,  9 Mar 2022 11:53:48 +0100 (CET)
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
Subject: [PATCH bpf-next v11 2/5] Documentation/bpf: Add documentation for BPF_PROG_RUN
Date:   Wed,  9 Mar 2022 11:53:43 +0100
Message-Id: <20220309105346.100053-3-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309105346.100053-1-toke@redhat.com>
References: <20220309105346.100053-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds documentation for the BPF_PROG_RUN command; a short overview of
the command itself, and a more verbose description of the "live packet"
mode for XDP introduced in the previous commit.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 Documentation/bpf/bpf_prog_run.rst | 117 +++++++++++++++++++++++++++++
 Documentation/bpf/index.rst        |   1 +
 2 files changed, 118 insertions(+)
 create mode 100644 Documentation/bpf/bpf_prog_run.rst

diff --git a/Documentation/bpf/bpf_prog_run.rst b/Documentation/bpf/bpf_prog_run.rst
new file mode 100644
index 000000000000..4868c909df5c
--- /dev/null
+++ b/Documentation/bpf/bpf_prog_run.rst
@@ -0,0 +1,117 @@
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
+``BPF_PROG_RUN``.
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
+  in batches. The batch size defaults to 64 packets (which is same as the
+  maximum NAPI receive batch size), but can be specified by userspace through
+  the ``batch_size`` parameter, up to a maximum of 256 packets. For each batch,
+  the kernel executes the XDP program repeatedly, each invocation getting a
+  separate copy of the packet data. For each repetition, if the program drops
+  the packet, the data page is immediately recycled (see below). Otherwise, the
+  packet is buffered until the end of the batch, at which point all packets
+  buffered this way during the batch are transmitted at once.
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

