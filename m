Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576323BE14
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389909AbfFJVIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:08:42 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:37958 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389884AbfFJVIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:08:41 -0400
Received: by mail-yb1-f202.google.com with SMTP id a13so10944417ybm.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s4cYkdfXLpURz/IJz9ubZSdFhBas+UHvrTOfo6AKN98=;
        b=hNSNc8tbLY97n37AsLcY0htkPvtoOJe3fsk05WJTnbXcveW/GbEkKBMx27lAJLQ0vy
         D8QD9Axa2QWnICltEFgsIz9fogXdN8jzIz2NRfVJn+Iw2vO3ocglyzTrvUy2jn6/6fh/
         E4mwj2jrkA5tohr1GZ20xsP0dkfZma59z07oaMDyo++hH1zi+oMlY5hh/O1JITQn33rC
         Tff4k2UEYgCUrN6dlfrf6PfrKxBhZoSBpL3lNEZEwh8HP+dD0I+QiZv/p82x2R+61Igs
         6/E5yFJgUJv4UTbHq1HlawtxK8T1q7iNKv5Kz6DQ/YjDNAqPSykaU5+Oy7BsazmNayx0
         ITFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s4cYkdfXLpURz/IJz9ubZSdFhBas+UHvrTOfo6AKN98=;
        b=WOStjyzp7xNX94bCc+f3hGnpysy8smF0HP7z0B4SU3QAFTjTMBWzho5RetYTwpsJ8t
         1AX7RTsc7pwZibrT7Ldvn6yqMWp9aCluzw6Gyfy2lJr7ebOp3fO/pVIob7qoiQCmaTRl
         ob8jhrGAi3o1LOyCsLkbbw6g5YMrgwgzk600A3ah/vjReom3qgOBJTw6FCu3Q6/lRZ/X
         OOc7e8zr+m2LsnBmZI066org+X+xGr8zk4A4QzsSHMcHJKI/B7KUOSURbOeQMA5BQk65
         dCuppjgLI6DpCV2PDjQrj/PervOHrm8Jj14YcdkXstdSJkRs9mgANsF9YYoIy3UTDJLg
         87Vw==
X-Gm-Message-State: APjAAAV/rfEwCc1ZZyJQBBNe/vB7+/PpL65abmrIN+rt/F54ZrZdWG0v
        NZGRjoZJKqhHa3B23uvi0yTa29phR6J9dVoIStAROnivXQpkwoAZaquljtKjeWtZTQQmZXa5nEB
        ijFqAcV20fEabVCVB3+2OHrIs56fOi1lqKg/jbQLVrf2MkhhEVRQhsQ==
X-Google-Smtp-Source: APXvYqx3UaFCxh33W1WshrGbcECb4oMYNrRnITdHqFeLpcf8xJodSUuFqcZzXG8p2SA2ytH5+NAA3po=
X-Received: by 2002:a25:458:: with SMTP id 85mr34818984ybe.167.1560200920359;
 Mon, 10 Jun 2019 14:08:40 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:08:25 -0700
In-Reply-To: <20190610210830.105694-1-sdf@google.com>
Message-Id: <20190610210830.105694-4-sdf@google.com>
Mime-Version: 1.0
References: <20190610210830.105694-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v5 3/8] libbpf: support sockopt hooks
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
2.22.0.rc2.383.gf4fbbf30c2-goog

