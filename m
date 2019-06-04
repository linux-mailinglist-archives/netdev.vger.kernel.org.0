Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93B5351F2
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfFDVfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:35:37 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:54643 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFDVfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:35:37 -0400
Received: by mail-qt1-f201.google.com with SMTP id r57so11829692qtj.21
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CU+Wum/bihwDTWLVJmYTACBXxoMM3npiy+H9eNDd5/8=;
        b=F2t57f54iSXWHC/EjZN3TgEeBmskXCQNFDhkzDhmokN0pgxPrJCWospSq5AUcjMtKR
         ErXG1tTxaB7rijLCOoM11zJNRYLLZ5evUIOLKuwgRmvDd7xPciQqUoQZkxC0xIp37+v+
         fQ1rhkDeHgTFChKcguKwETYvFdlw5nz4j3wuq/scBOrZGJT+y8D6DruIflG9z7VRilwA
         /iXmEBMjorfz/60jFF4FhN5GUmu3+FPt06wRGvMbLEAJ2y8t4OW0DmnCCH7suuCUfvpq
         El4OvpBqLLFZg7ZaavzTujnS1JWeRwZN22402af6diVaNThu4n5mgFb7VHF/2KJE5L3L
         k88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CU+Wum/bihwDTWLVJmYTACBXxoMM3npiy+H9eNDd5/8=;
        b=pCWMv4vrCiLWTJzmIGofKYkeeRzWuAbkixbCaV5S2VrSw+vrXzZfl57ZpA18lmhWGu
         dvT+RBZrckeIEHqwTNj98NTk6ETXDNUeoGmLaExhxBQlNc1+WoUPLVPlrEH1ntXuMQzz
         rCjTA98GsH5r1iCvxM6IGnBZiMw+unGob9BbzPNjnzFfc4Fz+7luJjy2QqkBYHwpa1Fc
         7LG2zp4slGyAs2i0aQQTvn7EguVK0QW9LOy2mzvmbj+sGWypkMTK92jtHugVAPN/l25d
         u1rtAsUPkKleBlt+dIAElYIDLnJs2DHaFC4HruOXmxxdQRDv0TUEnNSHH2FxyPIF4Tk3
         X8ng==
X-Gm-Message-State: APjAAAWAcgmXamjwWIc/wweDyObo2b7M1AzIXN2NpB4u/oL2Qat827cs
        Uew2ubdx89ypghDcX3AQBZcgRdLsHqGBT+AKLMSwRzudm7e8ABeWP0t8uEc7HXEaRVwddAXEwLS
        1v+BEEPg3K7doXyuctfAkgqKzx7Og9doVE4DlCMik0xh+zFe6JGHCeg==
X-Google-Smtp-Source: APXvYqz3oLXvATMspIEGMwlYkZ+GpsToFbo5NMC1KzRwRFCAjdBbLSt18/fuEIPMCIL4yWXhmM7K2u0=
X-Received: by 2002:a0c:d003:: with SMTP id u3mr15942129qvg.112.1559684136458;
 Tue, 04 Jun 2019 14:35:36 -0700 (PDT)
Date:   Tue,  4 Jun 2019 14:35:20 -0700
In-Reply-To: <20190604213524.76347-1-sdf@google.com>
Message-Id: <20190604213524.76347-4-sdf@google.com>
Mime-Version: 1.0
References: <20190604213524.76347-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH bpf-next 3/7] libbpf: support sockopt hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make libbpf aware of new sockopt hooks so it can derive prog type
and hook point from the section names.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c        | 5 +++++
 tools/lib/bpf/libbpf_probes.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ba89d9727137..cd3c692a8b5d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2243,6 +2243,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 		return false;
 	case BPF_PROG_TYPE_KPROBE:
 	default:
@@ -3196,6 +3197,10 @@ static const struct {
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
2.22.0.rc1.311.g5d7573a151-goog

