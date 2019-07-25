Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51219752AB
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388941AbfGYPdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 11:33:46 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:44970 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387422AbfGYPdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:33:46 -0400
Received: by mail-pf1-f201.google.com with SMTP id j22so31076080pfe.11
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 08:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JXZL8O7+Ny9KufAmHovMTntdK68YTy/GrGGZHk3basc=;
        b=YNvSAO1jnS595Js7/guXuvD93UvBbbdd/JC8m0CgIueiB7TvYFUefgINGwGu2q8pwg
         JDJd8TbjAwjmRyc/vShO+aY29yTiDAZz11rA8Z5mhHR6zFSEHtCcjWdVj1l/rtb6AUex
         IxCO6Pzw9ZSWwKC5iTcegGzp8YhjkTXaD4p5eC2ECIirLXtlJmqWzLm2HdZdRd15U7B1
         FJ3N68b5599jkrnLryJTc8VVjnefSkRF1kZNRYW00ptFUKqq8inxDlnebBg/8Gefkc+g
         A/POf5qme7iAPy0Whu+vIkALEaS0+/t74dWFuYMPtuxzoFTUmoclHyg4DZpkWsePe6vO
         482Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JXZL8O7+Ny9KufAmHovMTntdK68YTy/GrGGZHk3basc=;
        b=gM9V4BapNTF2nZG7e8sycYegs5acXCqbbVuF38eiLDp0FFFwJaOS/AqhnhB45QoYk1
         lwr12kZPwGENQ1C/EKMAt4n0/XTO4Zctpze5kjUyNfx70oJff/IQUljPtYWtsQEHIgq1
         xGLrFjOWJhIwbt/hSUBxhBMOKt2+1pgXlsca2wro1biCUGfsrASQX0/pH2CM7wrE4bMn
         njQbc6mX/jAh+ZbXtLQbb4zfn3kLqlmCerxX1UCocNpDdPE717A6NRJh+Sy8xzd0wBLc
         nQXkMb7iac8F2vTCJvlYEBYnu4tCIr0REGiYAfFvs6XG4t5KDrpEfY4FpYKckAOsm5/7
         UEhA==
X-Gm-Message-State: APjAAAVdoU6ECtnjj39gN876yNkK2NVQIWhGtPnEqCkmmSt2XX0XNbxL
        fyh7hRuvfw86KNuTcJyll2r2imVZc6V6jPnuYiehc5QB/nPF+CuQKtUvoIr6h4TlbVm5tMjqgQG
        h0UnNndKDExovHBqFgFqsyzCwkT7Ley29gcNURzvuhk7zeJnvjOeqzw==
X-Google-Smtp-Source: APXvYqwVUu5VVXovpC4YNjW6B/73K1rdfrJa4t4iMdK0HFrEz7n9Ekd0UgnlKWZG7emkqKgYUXgIAfY=
X-Received: by 2002:a63:6154:: with SMTP id v81mr53597390pgb.296.1564068824620;
 Thu, 25 Jul 2019 08:33:44 -0700 (PDT)
Date:   Thu, 25 Jul 2019 08:33:35 -0700
Message-Id: <20190725153342.3571-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next v2 0/7] bpf/flow_dissector: support input flags
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Song Liu <songliubraving@fb.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

C flow dissector supports input flags that tell it to customize parsing
by either stopping early or trying to parse as deep as possible.
BPF flow dissector always parses as deep as possible which is sub-optimal.
Pass input flags to the BPF flow dissector as well so it can make the same
decisions.

Series outline:
* remove unused FLOW_DISSECTOR_F_STOP_AT_L3 flag
* export FLOW_DISSECTOR_F_XXX flags as uapi and pass them to BPF
  flow dissector
* add documentation for the export flags
* support input flags in BPF_PROG_TEST_RUN via ctx_{in,out}
* sync uapi to tools
* support FLOW_DISSECTOR_F_PARSE_1ST_FRAG in selftest
* support FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL in kernel and selftest
* support FLOW_DISSECTOR_F_STOP_AT_ENCAP in selftest

Pros:
* makes BPF flow dissector faster by avoiding burning extra cycles
* existing BPF progs continue to work by ignoring the flags and always
  parsing as deep as possible

Cons:
* new UAPI which we need to support (OTOH, if we need to deprecate some
  flags, we can just stop setting them upon calling BPF programs)

Some numbers (with .repeat = 4000000 in test_flow_dissector):
        test_flow_dissector:PASS:ipv4-frag 35 nsec
        test_flow_dissector:PASS:ipv4-frag 35 nsec
        test_flow_dissector:PASS:ipv4-no-frag 32 nsec
        test_flow_dissector:PASS:ipv4-no-frag 32 nsec

        test_flow_dissector:PASS:ipv6-frag 39 nsec
        test_flow_dissector:PASS:ipv6-frag 39 nsec
        test_flow_dissector:PASS:ipv6-no-frag 36 nsec
        test_flow_dissector:PASS:ipv6-no-frag 36 nsec

        test_flow_dissector:PASS:ipv6-flow-label 36 nsec
        test_flow_dissector:PASS:ipv6-flow-label 36 nsec
        test_flow_dissector:PASS:ipv6-no-flow-label 33 nsec
        test_flow_dissector:PASS:ipv6-no-flow-label 33 nsec

        test_flow_dissector:PASS:ipip-encap 38 nsec
        test_flow_dissector:PASS:ipip-encap 38 nsec
        test_flow_dissector:PASS:ipip-no-encap 32 nsec
        test_flow_dissector:PASS:ipip-no-encap 32 nsec

The improvement is around 10%, but it's in a tight cache-hot
BPF_PROG_TEST_RUN loop.

Cc: Song Liu <songliubraving@fb.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>

Stanislav Fomichev (7):
  bpf/flow_dissector: pass input flags to BPF flow dissector program
  bpf/flow_dissector: document flags
  bpf/flow_dissector: support flags in BPF_PROG_TEST_RUN
  tools/bpf: sync bpf_flow_keys flags
  selftests/bpf: support FLOW_DISSECTOR_F_PARSE_1ST_FRAG
  bpf/flow_dissector: support ipv6 flow_label and
    FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL
  selftests/bpf: support FLOW_DISSECTOR_F_STOP_AT_ENCAP

 Documentation/bpf/prog_flow_dissector.rst     |  18 ++
 include/linux/skbuff.h                        |   2 +-
 include/net/flow_dissector.h                  |   4 -
 include/uapi/linux/bpf.h                      |   6 +
 net/bpf/test_run.c                            |  39 ++-
 net/core/flow_dissector.c                     |  14 +-
 tools/include/uapi/linux/bpf.h                |   6 +
 .../selftests/bpf/prog_tests/flow_dissector.c | 242 +++++++++++++++++-
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  46 +++-
 9 files changed, 359 insertions(+), 18 deletions(-)

-- 
2.22.0.657.g960e92d24f-goog
