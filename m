Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775084A15C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfFRNBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:01:04 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:37011 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfFRNBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:01:01 -0400
Received: by mail-lj1-f169.google.com with SMTP id 131so13052299ljf.4
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OXRC7kUqjRaCwEb4wkf/WJQfsQbHmGkQk8MkzG7nDWg=;
        b=LWICZYMOa58ip98qcRYJT2pob7UHwwfa5yUOL041MY6lDljQKBV79BFAF2QWTkjXqY
         SyfBEpg0rcM0FFVLMC98CLIPAzFcrFbMWm6yfh1iVIPBwWvOTEdrKQBgTniyjbVnCPwW
         gv/DC278cwtlZdWfO2ulIe+3v+NlRawbh6UWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OXRC7kUqjRaCwEb4wkf/WJQfsQbHmGkQk8MkzG7nDWg=;
        b=o5TPguIUcvKSUjF4VTeN97UFZ4qdjcxoKiKOLFco+MC1zYvfZpigUa3KDnCkbYCnsV
         AJS5qBA/3CqLYCt3BdlNG6zTH+7qIwr/neIHaIOSA0snp+N3ulOfaq8MPK+XyMXamBes
         oN8gEqcR+YfCKN87VlOqwL6pRKlDgXcmwYI1c0rM4ZKZ15+S2zpX0kDIEvq/qTzNcwYS
         85f3ThVU+z1evIvdozH0ODyUuLTAHZEU87GIjtCrdPRZipUmvpxMSoJ9HfteV3PEV4u/
         nFQla1MB5bbz+FBTu0hhlkC2u9h9Ozmtcxban8vS5PAYyq0ytqleARhSUhRGKRQOAfi/
         0dCA==
X-Gm-Message-State: APjAAAWO5oUMOJN9PmAYevRh8mQ2JW3fcCy4fKZRUFbPsmjhI0dOLQgQ
        RiiEGd70SA3tROet2T9VNgtntpLkeyIU3A==
X-Google-Smtp-Source: APXvYqwRD9JWRuCdTkY07FyjPDf3gnbSDyZ54QyNNzy4Nusmygd6pBFXQgQREc3YzIB2ZHwUAeIZPQ==
X-Received: by 2002:a2e:50e:: with SMTP id 14mr44389112ljf.5.1560862858462;
        Tue, 18 Jun 2019 06:00:58 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id y62sm2581949lje.100.2019.06.18.06.00.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 06:00:57 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com
Subject: [RFC bpf-next 5/7] libbpf: Add support for inet_lookup program type
Date:   Tue, 18 Jun 2019 15:00:48 +0200
Message-Id: <20190618130050.8344-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618130050.8344-1-jakub@cloudflare.com>
References: <20190618130050.8344-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make libbpf aware of the newly added program type. Reserve a section name
for it.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/lib/bpf/libbpf.c        | 4 ++++
 tools/lib/bpf/libbpf.h        | 2 ++
 tools/lib/bpf/libbpf.map      | 2 ++
 tools/lib/bpf/libbpf_probes.c | 1 +
 4 files changed, 9 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e725fa86b189..84dfdfc0a971 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2244,6 +2244,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_INET_LOOKUP:
 		return false;
 	case BPF_PROG_TYPE_KPROBE:
 	default:
@@ -3110,6 +3111,7 @@ BPF_PROG_TYPE_FNS(tracepoint, BPF_PROG_TYPE_TRACEPOINT);
 BPF_PROG_TYPE_FNS(raw_tracepoint, BPF_PROG_TYPE_RAW_TRACEPOINT);
 BPF_PROG_TYPE_FNS(xdp, BPF_PROG_TYPE_XDP);
 BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
+BPF_PROG_TYPE_FNS(inet_lookup, BPF_PROG_TYPE_INET_LOOKUP);
 
 void bpf_program__set_expected_attach_type(struct bpf_program *prog,
 					   enum bpf_attach_type type)
@@ -3197,6 +3199,8 @@ static const struct {
 						BPF_CGROUP_UDP6_SENDMSG),
 	BPF_EAPROG_SEC("cgroup/sysctl",		BPF_PROG_TYPE_CGROUP_SYSCTL,
 						BPF_CGROUP_SYSCTL),
+	BPF_EAPROG_SEC("inet_lookup",		BPF_PROG_TYPE_INET_LOOKUP,
+						BPF_INET_LOOKUP),
 };
 
 #undef BPF_PROG_SEC_IMPL
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 2e594a0fa961..283dac0f6d13 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -240,6 +240,7 @@ LIBBPF_API int bpf_program__set_sched_cls(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_sched_act(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_xdp(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
+LIBBPF_API int bpf_program__set_inet_lookup(struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
 				      enum bpf_prog_type type);
 LIBBPF_API void
@@ -254,6 +255,7 @@ LIBBPF_API bool bpf_program__is_sched_cls(struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_sched_act(struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_xdp(struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_perf_event(struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_inet_lookup(struct bpf_program *prog);
 
 /*
  * No need for __attribute__((packed)), all members of 'bpf_map_def'
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2c6d835620d2..e55d8e5d6fd4 100644
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
index 5e2aa83f637a..5094f32d33a7 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -101,6 +101,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_SK_REUSEPORT:
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_INET_LOOKUP:
 	default:
 		break;
 	}
-- 
2.20.1

