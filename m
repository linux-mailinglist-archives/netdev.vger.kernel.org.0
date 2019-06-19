Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6284BF23
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfFSRAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:00:09 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:47563 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfFSRAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:00:08 -0400
Received: by mail-yw1-f73.google.com with SMTP id 77so104127ywp.14
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KESt1YMCgEpYbvtvketbmAIj09uDDroaTTEMEO312Bs=;
        b=J1dVVIVE5xMlBOHyTNrhC37PVsoOkKPWwTkQTo7eNqMbJt3O+8fT6o6lwwMa3ZO4Aa
         3kBG3UKKQTygI34WS7ql9v619pI5FBoHcQCDQpBWUi9bheOvFBN3RGVNLNo+HzpV32pd
         uf2/HhgcdjD6ZgHRXbb+EMxX+AtDcTph7mYTh6nGLgkNGEAoOSRxQbIWwvZV1dNcx/hd
         HCi1brBOEQJ8DN9epkmiSGuRkxOmtFJB+2agc5OJeGRTQkl0ppSqjHHWXFtMVTibH9JY
         0hK7Kb1Hn7Rs25eOogNg6Jfy5ArjYlTmS+xigoQ0VC7N8Sq3ebLZkqxEYdPlB7aeiW7x
         lX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KESt1YMCgEpYbvtvketbmAIj09uDDroaTTEMEO312Bs=;
        b=oM8tp1e/qKpOSqAHTVJrjHvotHqsAjPWFVSPbQf25kfabeKJFqY1EjZ8EyU2Y4/Q+s
         PFOLRYbQKM14ZeLoLL2G0ubk21sjFKLzUWENdOmCdLBsFSM1zJmZp0i03v2QDcH4o7qj
         cMYgRv3piYGVcOOgTdslu3Dt3tmvHrre/Ko3Aqpq5eQp38014CWn/jkv7Lj3hFQ6W7U5
         dw0ZvvPGEaq+9rq9TdGzMcqSOrLn79m3FcVsaEk6vp+rEJy+8MjhS3dzn7fAOEaBeqIp
         HSsepkPuP0AjfjENCIutueazaUULdqHlBQ95ej4nQskEj33PyCo+ceL6ON9MhFKaZYkj
         wY5A==
X-Gm-Message-State: APjAAAUdrJgEBfmPHlEpKMsfAiaG9pzHzSq8YEu0U5xfYTIOuO4GAKOX
        Ec7UjoZIc0kpbRVPZpUfvLqTXCdxQeHVeQGlM17MdG4Am7xypfgrCxXhzoawIgpyXDIhkOkQ4Q8
        BCxFlTos5fK4NZpV9O8Sd5Bia97cx8AWc0muuhuVzzZXpExr68yNm9g==
X-Google-Smtp-Source: APXvYqxkhKtHh7ogBfBTh2QvFRI88HkftxYe6ICUbXt9CZkNLQAc61/V9OAOOWfa8tFLPX6C+xt1Y7M=
X-Received: by 2002:a81:2fc2:: with SMTP id v185mr18318988ywv.119.1560963607309;
 Wed, 19 Jun 2019 10:00:07 -0700 (PDT)
Date:   Wed, 19 Jun 2019 09:59:51 -0700
In-Reply-To: <20190619165957.235580-1-sdf@google.com>
Message-Id: <20190619165957.235580-4-sdf@google.com>
Mime-Version: 1.0
References: <20190619165957.235580-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v7 3/9] libbpf: support sockopt hooks
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

