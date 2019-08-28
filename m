Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79589FB8A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfH1HXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:23:16 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:34426 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfH1HXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:23:15 -0400
Received: by mail-lj1-f176.google.com with SMTP id x18so1625670ljh.1
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cIi3T+DD1cNIheijxT8j0Jlj8aILon/mqp7oQVFyNjE=;
        b=h+TufrpIzxlQcdY3L05jrXcf72ATMcG8h/fvzFdiFLMBc7+26/V0dLRfQxQGnxHmiy
         lNkHvh+MIkJ4i1ykUF+yvxdybh5xu9To1mi069UVn0gK9qjiJg4epbDsoMrNXf4fnUYr
         VJk7uk9Xb4Z4cTh0g86yB2AvWfxX1aPPuTNP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cIi3T+DD1cNIheijxT8j0Jlj8aILon/mqp7oQVFyNjE=;
        b=nsxtMWKufNEeeGmgrL0VhI9+2SYbb963A5tHxcI6AvO9EsMntND1QlDStDpvsA7OcS
         rfgGoHnXpfuu8iWXSI53XRUHZGqzAbYe/gdKWn291Kb2y5BVVC28VfbYp0DFi7r0CzyX
         vuuBTs0QOobpEaeA+XOTELBzk9sfGOObnzbtjQ/O5FGztGxgDV9xA9p0p66eVkuHRAY8
         9DtrzrDM2wTOpIRbm6yigj8ntnd0VGHJhVMOKdYKjJlksaARGrYFeeV6TG/ml3R2hc+O
         r5iTjDG2cHF0wv7lomY2DKVjVyenPoQuzPPPelxZvVlLrDnvpYTcaNC/vma1uPRsjllD
         g/fQ==
X-Gm-Message-State: APjAAAXqYjn4uzKBAXDkZQ7hhlM4EePmik3dDDSSUuNOORGJzcRfcv8u
        PqRd4CJ+905gaS4IL/VEb8aszQ==
X-Google-Smtp-Source: APXvYqxYO8OUkZ/SRwGCEtZ8u5H9MylZIzXftPBQJeu9MPJGPvhKB9bvk24LJeB3BZOt7ohr6BMEhw==
X-Received: by 2002:a2e:3c1a:: with SMTP id j26mr1141901lja.163.1566976993042;
        Wed, 28 Aug 2019 00:23:13 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b30sm573461lfq.59.2019.08.28.00.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:23:12 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFCv2 bpf-next 11/12] libbpf: Add support for inet_lookup program type
Date:   Wed, 28 Aug 2019 09:22:49 +0200
Message-Id: <20190828072250.29828-12-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828072250.29828-1-jakub@cloudflare.com>
References: <20190828072250.29828-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make libbpf aware of the newly added program type. Reserve a section name
for it.

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/lib/bpf/libbpf.c        | 4 ++++
 tools/lib/bpf/libbpf.h        | 2 ++
 tools/lib/bpf/libbpf.map      | 2 ++
 tools/lib/bpf/libbpf_probes.c | 1 +
 4 files changed, 9 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2233f919dd88..addb9762e965 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3580,6 +3580,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_INET_LOOKUP:
 		return false;
 	case BPF_PROG_TYPE_KPROBE:
 	default:
@@ -4447,6 +4448,7 @@ BPF_PROG_TYPE_FNS(tracepoint, BPF_PROG_TYPE_TRACEPOINT);
 BPF_PROG_TYPE_FNS(raw_tracepoint, BPF_PROG_TYPE_RAW_TRACEPOINT);
 BPF_PROG_TYPE_FNS(xdp, BPF_PROG_TYPE_XDP);
 BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
+BPF_PROG_TYPE_FNS(inet_lookup, BPF_PROG_TYPE_INET_LOOKUP);
 
 void bpf_program__set_expected_attach_type(struct bpf_program *prog,
 					   enum bpf_attach_type type)
@@ -4542,6 +4544,8 @@ static const struct {
 						BPF_CGROUP_GETSOCKOPT),
 	BPF_EAPROG_SEC("cgroup/setsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 						BPF_CGROUP_SETSOCKOPT),
+	BPF_EAPROG_SEC("inet_lookup",		BPF_PROG_TYPE_INET_LOOKUP,
+						BPF_INET_LOOKUP),
 };
 
 #undef BPF_PROG_SEC_IMPL
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e8f70977d137..937d6da9430a 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -262,6 +262,7 @@ LIBBPF_API int bpf_program__set_sched_cls(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_sched_act(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_xdp(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
+LIBBPF_API int bpf_program__set_inet_lookup(struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
 				      enum bpf_prog_type type);
 LIBBPF_API void
@@ -276,6 +277,7 @@ LIBBPF_API bool bpf_program__is_sched_cls(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_sched_act(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_xdp(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_inet_lookup(const struct bpf_program *prog);
 
 /*
  * No need for __attribute__((packed)), all members of 'bpf_map_def'
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 664ce8e7a60e..57564ad458ba 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -67,6 +67,7 @@ LIBBPF_0.0.1 {
 		bpf_prog_test_run;
 		bpf_prog_test_run_xattr;
 		bpf_program__fd;
+		bpf_program__is_inet_lookup;
 		bpf_program__is_kprobe;
 		bpf_program__is_perf_event;
 		bpf_program__is_raw_tracepoint;
@@ -84,6 +85,7 @@ LIBBPF_0.0.1 {
 		bpf_program__priv;
 		bpf_program__set_expected_attach_type;
 		bpf_program__set_ifindex;
+		bpf_program__set_inet_lookup;
 		bpf_program__set_kprobe;
 		bpf_program__set_perf_event;
 		bpf_program__set_prep;
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 4b0b0364f5fc..c365223a2d1e 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -102,6 +102,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_INET_LOOKUP:
 	default:
 		break;
 	}
-- 
2.20.1

