Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295A973470
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfGXRAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:00:21 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:51511 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfGXRAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 13:00:21 -0400
Received: by mail-pf1-f202.google.com with SMTP id 145so28957537pfv.18
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 10:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1xPEXMDkLELWIGaSMmOMYvDd/EFGlRxWlFEHpHsk6fU=;
        b=FJi7WmtRWpa7GH2wOtF5ooh9n7vlVNN4fQuQW/pFfXdiBHnSemRqWPTKh34Anr/acL
         /iq8uchMtVdEG/AYNTC6Eb9+Qc1cuSbAA1HA0WhPLe5KgqdWtwps6pg5BNMvmfmhFheh
         bioYzPTRreDyfTXhA43yHdRY4hg5JggQYoH2O0cRyiNcqD5zY1iVxfoXeaV4FcKgVrAQ
         RKJAI5uvfJaP9ZdbLAivvHPu1iEipzD4O6kiJx4XqUcuAWdLxUURzEcfg8CWSnnmyFgl
         Pc3NZhv4/j03R564hNG99bs2d+Hd9MaQwfwCZ4h7/piuflNfRhfofV78+iAVMXDsERgC
         slIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1xPEXMDkLELWIGaSMmOMYvDd/EFGlRxWlFEHpHsk6fU=;
        b=nvDrbDI3jFPSqcKAScVmP9wnt9D3Wy0/Nzd96P4pFcN71CGMTzDu3skmjEZ933qZ7p
         bAlTgAN3rYKNZHzN9raWzXQOBon8T8N8m0FAhhondHd3RA+1wNEkZyvxvRNVKFW84ACD
         iZHSxSIpW6zs2KxwokUFQZhP6R+8MlcDtQA4LL6FZyTL/zGlQrMyVtcop8xo+3xNxs9I
         v6InvKeT5pIRTSi4IXGFntmE866nmXZnQnRYmJGlXhqFfwwIyoSRq/pNiNIfrYG7V4uo
         RtoqmSWGUgbowoS5YdxQliFxqtb8nusQiJrYZKRn8QSCtVvgep5CBCZME+HVp+PCSX0q
         ocIg==
X-Gm-Message-State: APjAAAWDZmlVBOMAg+/1WjZX2zZSpXDuVgknxHNzY9SMsWKTpRLxHdMF
        CGwnjE/o9UATLOGqm2eXiYclxFbHEa9tuyu6lgYDFrU96fK3yniWjYs9/vLzdSVH138Ujnl9yHg
        bNbdH2k3pd5Qp0Lwy4Yjs4FPpFiR1TjJ7FxwciXANrJg1InmdZ98xig==
X-Google-Smtp-Source: APXvYqwpMLZ86VgJOfJVCkwACEnTjwzBt2hOKmktyaDaBVZ7+/iIvzFxcqrCupyT84JxvNgl+8TthxM=
X-Received: by 2002:a65:55c7:: with SMTP id k7mr51084981pgs.305.1563987620511;
 Wed, 24 Jul 2019 10:00:20 -0700 (PDT)
Date:   Wed, 24 Jul 2019 10:00:11 -0700
Message-Id: <20190724170018.96659-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next 0/7] bpf/flow_dissector: support input flags
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
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

Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>

Stanislav Fomichev (7):
  bpf/flow_dissector: pass input flags to BPF flow dissector program
  bpf/flow_dissector: document flags
  bpf/flow_dissector: support flags in BPF_PROG_TEST_RUN
  tools/bpf: sync bpf_flow_keys flags
  sefltests/bpf: support FLOW_DISSECTOR_F_PARSE_1ST_FRAG
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
 .../selftests/bpf/prog_tests/flow_dissector.c | 235 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  46 +++-
 9 files changed, 353 insertions(+), 17 deletions(-)

-- 
2.22.0.657.g960e92d24f-goog
