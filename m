Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD21848B25
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfFQSBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:01:51 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:33857 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfFQSBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:01:51 -0400
Received: by mail-yb1-f201.google.com with SMTP id v6so11478125ybs.1
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KESt1YMCgEpYbvtvketbmAIj09uDDroaTTEMEO312Bs=;
        b=YcPdsMN3kwimWHq1bvDamEso7qkIzVFU1NsGe75DEZuyysANB4sQgNQy9JvyGmNA8L
         6YGkAuYmwK8yy8Lo/WxhOdiAorPvxZilxyj0oflV870vkWS26eHiQw43lZzLkXm+Rlbe
         0asyDvcgmrmAwAVsw+VbVg4pFsAohQ006nS7SBrdZU6SosDGns4SS70LWAyRidGBAN4b
         xnmfYSwnyizoq83Zf83MkbFyMiMRWFBjU/0hJBOPmY2BYiByzTmiu0nbd8LZRqccfEBU
         CEcFgiXiwIE7nnost8koHAQlG/RnINbYQcGnlaCvAKjqIG1K7PycfGRETti3f2etGVsZ
         kmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KESt1YMCgEpYbvtvketbmAIj09uDDroaTTEMEO312Bs=;
        b=APFNCQ9B16VLWB1QX+s9PMqY5dmCdQh0ikkiZQ8AhSprn8IokncvsHiSJKQAFSIF3Q
         3tDVTpE6AEiuiycTyGyvMNAPqVFSLgBNEZQdUT+0BItjiLrj4O/3BD409AxEWzRMBRO3
         PoOp4ERdYM53fdZA+4Ld2Mp5FtdkcKhyqYmz10qZZfUeyKnh6dru9ye0b5CN+fYfVrX/
         hjPJUSPpYrjyjM/JT6y/CCaKZf9pL41ByOHGHSqJ0MICfZLfTz9+Au2sOw8vEYtS2g8/
         BnyQjQjLkxHseL6kF1FkVHkt9QMC9NYifsSwPaT49Ak6nb/TY0gtlApNUe+k6KxKiRYe
         XjDQ==
X-Gm-Message-State: APjAAAWmtgM7sNTxHWWH0lBlCBs1XqxG0xvkMM50392ZDtErc6cLL5Se
        JLrFJeUWJTvNPP6JCVjCmePr3PmNFdt9SfIgLd3Eg9MApqcL0M59oVxTCvtc0tNhGLlbbNg01s0
        nQn0X+nkRc/XrKCOGg7kaeGNUI9vNCiKbwarCcotHNMtW39gmc8CKRw==
X-Google-Smtp-Source: APXvYqyi0loDKAmiUV4MQ1FA9+kUNUBiCRCkKPQIMxyhVLwEmG17V7wf+Mc/L+5zO4UoQXix2HYtlBM=
X-Received: by 2002:a25:3c4:: with SMTP id 187mr59401766ybd.337.1560794510154;
 Mon, 17 Jun 2019 11:01:50 -0700 (PDT)
Date:   Mon, 17 Jun 2019 11:01:03 -0700
In-Reply-To: <20190617180109.34950-1-sdf@google.com>
Message-Id: <20190617180109.34950-4-sdf@google.com>
Mime-Version: 1.0
References: <20190617180109.34950-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v6 3/9] libbpf: support sockopt hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make libbpf aware of new sockopt hooks so it can derive prog type
and hook point from the section names.

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c        | 5 +++++
 tools/lib/bpf/libbpf_probes.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e725fa86b189..98457fc6bb76 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2244,6 +2244,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 		return false;
 	case BPF_PROG_TYPE_KPROBE:
 	default:
@@ -3197,6 +3198,10 @@ static const struct {
 						BPF_CGROUP_UDP6_SENDMSG),
 	BPF_EAPROG_SEC("cgroup/sysctl",		BPF_PROG_TYPE_CGROUP_SYSCTL,
 						BPF_CGROUP_SYSCTL),
+	BPF_EAPROG_SEC("cgroup/getsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+						BPF_CGROUP_GETSOCKOPT),
+	BPF_EAPROG_SEC("cgroup/setsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+						BPF_CGROUP_SETSOCKOPT),
 };
 
 #undef BPF_PROG_SEC_IMPL
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 5e2aa83f637a..7e21db11dde8 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -101,6 +101,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_SK_REUSEPORT:
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	default:
 		break;
 	}
-- 
2.22.0.410.gd8fdbe21b5-goog

