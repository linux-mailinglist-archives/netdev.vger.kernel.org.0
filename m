Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8143B58BC6
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfF0UjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:39:08 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:40742 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbfF0UjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:39:07 -0400
Received: by mail-qt1-f201.google.com with SMTP id z6so3695395qtj.7
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k7A7l4ZbNB5h7er1WtyOS2vLQKwgAWRCbj5qceMdrCw=;
        b=Rc2XLaYAn5a3NANW1+CmmhyYSfNvowcxKDxpLu5CItJ/RUQA4ZdE0cTY58p7x4O3ut
         ONPWoPf+KKHJqi+deIaS8iD6WepPWja2gxBJfsRXddxdrxL05FnC17Iim7rFB7ryvVzZ
         nArJXg+IfYPCL5PSYdprqkgBi0gWJg39PsAuRLQmnaPOfbx1j11UbPwqjejsKfjy/r+c
         OgL6Nt1ql6p8JFdMoa6vkcU0/CtC3sK9ceJqj6uKe6WAAAf31FEAc9ZuL3ZQMT6UwiCn
         t5oNqt5JqP4tRmHHvjBcA2tPr9vy2ighobjtVxB2GTALYVKWKH+r6+BnJyWyOQCCR5Yt
         aEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k7A7l4ZbNB5h7er1WtyOS2vLQKwgAWRCbj5qceMdrCw=;
        b=J7tg9sNiJNK6Vs/IYm4g31RMVj9vK6+xn/SsT6lBBGSzv/sCFJLsgKx/1TBfB1cpg7
         J4XjPaOpTRTfKA/bZSBqa8wSswHBmtWGLfdJ8UTG3RDyaVqTutHj1/TZ2Ra0NqtylNHZ
         Z0VsEEf3Mq+lbg+Wdb900EXCNRmc47werZgWBGs0gW8+KFHp91V4K+vmZhNBHdnOvNkl
         NldpD0VJvkwmYBLn0LIE6/uFF7jelWuKSkmm5z7w798Y/hklmNbnbIaDwo/rgOpa3Ygs
         MneOmfSi0CO2LVhwQhtunpOTKeOJksnSylZGGjp3GHsROlYCHcojAf4LP5QH6/KgjnBN
         WGEA==
X-Gm-Message-State: APjAAAU31ImZmavHC2MyVWWYM18OYJij98ZdgvohNUrh0aaiBOCIu9Mz
        jutB5BbAR1dubEjDHiB7NjexBo77o/6N+h7trw+na/+rTAH/7HxHwkRvoJAPt2/UkQEuYqdmGTU
        rJ3pnajzgMureBx8pJEzxngXC/hHT1UqSiZTtA9OltuKIPSce+5E0hw==
X-Google-Smtp-Source: APXvYqyLSHw/2MeuCqWntX5bAAEXYcDU5kRQ4UzuuKIS3lbUfhnNHZjFjB+y9EnbdC0V/VMYt4jSP4M=
X-Received: by 2002:a0c:acab:: with SMTP id m40mr5291855qvc.52.1561667945959;
 Thu, 27 Jun 2019 13:39:05 -0700 (PDT)
Date:   Thu, 27 Jun 2019 13:38:49 -0700
In-Reply-To: <20190627203855.10515-1-sdf@google.com>
Message-Id: <20190627203855.10515-4-sdf@google.com>
Mime-Version: 1.0
References: <20190627203855.10515-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v9 3/9] libbpf: support sockopt hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make libbpf aware of new sockopt hooks so it can derive prog type
and hook point from the section names.

Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c        | 5 +++++
 tools/lib/bpf/libbpf_probes.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5186b7710430..6e6ebef11ba3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2646,6 +2646,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 		return false;
 	case BPF_PROG_TYPE_KPROBE:
 	default:
@@ -3604,6 +3605,10 @@ static const struct {
 						BPF_CGROUP_UDP6_RECVMSG),
 	BPF_EAPROG_SEC("cgroup/sysctl",		BPF_PROG_TYPE_CGROUP_SYSCTL,
 						BPF_CGROUP_SYSCTL),
+	BPF_EAPROG_SEC("cgroup/getsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+						BPF_CGROUP_GETSOCKOPT),
+	BPF_EAPROG_SEC("cgroup/setsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+						BPF_CGROUP_SETSOCKOPT),
 };
 
 #undef BPF_PROG_SEC_IMPL
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 6635a31a7a16..ace1a0708d99 100644
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

