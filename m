Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6087039209
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfFGQ3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 12:29:31 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:43769 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730661AbfFGQ33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 12:29:29 -0400
Received: by mail-yw1-f74.google.com with SMTP id b188so2490624ywb.10
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 09:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CU+Wum/bihwDTWLVJmYTACBXxoMM3npiy+H9eNDd5/8=;
        b=OmSHvnckM8/kQx4C4wGR5PBZmfcaSfKhBiGmJEUihqFB/mOT72h5s6s5Wc0wkrN1Ab
         cI6Z3+8C2BSF6Nez6xTiTKDergSOPPdBOC/T5bhHcQe+nWglkLDZ9cs+n1GyKJfBbw7t
         UypEc2mpFiB6Cs+6ixyEVwkUZgSmM6LZzYkFJ4dQHwyHT32cVO9VzHHyxoKHRZo3b/2s
         Z32ONE25zgYs15RWDwHmfYr+E+vsRbbenjU70WCfsgrQrrTZH7ExZAmEb7bg6nXqUsNz
         v3CswHipy1gwNNcPC4VSdXMhiagL8iJ/dWQ9nY/WRp2h4b8oraASVJ408HELltqXtcxA
         O/IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CU+Wum/bihwDTWLVJmYTACBXxoMM3npiy+H9eNDd5/8=;
        b=kuKn8r+RmyCHPg2mTw5+Z6eWe9dOx416nCPPw5thbVE1bVWNepsO7GVDApTNvbRqm8
         VQIBTvip6yffbHc9hf5yYNnccJxr8hiazWlB9R6wutw0v6HfqQkAfwbgt46JTHi9U5Fg
         sn4/95IigZbYmkB1QSvc4PWNrCwkYu70UXCWlYn5f7qNlEk1QuGhVberhzj40xLfdLCD
         nBUXX9jY8nM/TlocfnXIjO2X/DMw2yp8xRYOR3I4tksoJ0d93gpo1zeJ3b5+iJchfw/n
         GtRavo2Mu1V0raEqgOUowc+TQL9z98d3dgmoOuQJzpew595PuRfjRHZzHhgCIErpKBwN
         uSgQ==
X-Gm-Message-State: APjAAAUmb4tPbQP+XWFQ/n4n5FiInHRicvZAQT+JStLcvPB7zTds8x+V
        dldLZW7oOwNehFuV68sSmFwiXvsMbqQeJdgCDfc6ux6aAyMA1a+lrBCjKWmk1jzXwC2u2PxL6ob
        y2LIsD6I0Xyj9IR4Q2Roa+XI9RxzQsLhP3igzQLWur49DYNjwRkWYUA==
X-Google-Smtp-Source: APXvYqwoc5ZaQx9NJ9FBbFgWnQg2m8XzxRJEFQmDcpdfructb3T9tzxtz8PnRxaNmyeld/NeRPkJThA=
X-Received: by 2002:a25:cf89:: with SMTP id f131mr25969629ybg.301.1559924968763;
 Fri, 07 Jun 2019 09:29:28 -0700 (PDT)
Date:   Fri,  7 Jun 2019 09:29:15 -0700
In-Reply-To: <20190607162920.24546-1-sdf@google.com>
Message-Id: <20190607162920.24546-4-sdf@google.com>
Mime-Version: 1.0
References: <20190607162920.24546-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH bpf-next v3 3/8] libbpf: support sockopt hooks
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

