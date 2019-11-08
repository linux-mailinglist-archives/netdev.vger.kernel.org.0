Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 747DBF59F3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbfKHVdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:33:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732170AbfKHVdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 16:33:12 -0500
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7ED14DB1F
        for <netdev@vger.kernel.org>; Fri,  8 Nov 2019 21:33:11 +0000 (UTC)
Received: by mail-lf1-f69.google.com with SMTP id a4so1542153lfg.23
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:33:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hPfHFcv37CDnOMOC+xTSrHQZULPPVPLWMXuGoJtoK4c=;
        b=StlixSak8rCqgWbfxommMyKg6POMJaAbVSkQe8kGC9Qd4cF0xiwc/dIxtvkqmm6D4q
         knbY6/PJzPxUJDQQkRYs0/qHP0Gc1gbSDkcKymnd0wbnLrgN+VJah69XqLJoymet0b5e
         tnoLZx9TVIk7WEWvBYhzXA+dUO8VcENTQoH4c3QjAFxh6InY5nwaDmnAZx2obcukXtKs
         0sW8BQXWz6v9JbZtN5vrUKJ1muxvStbIFiuPxSBx7wHv3wOXJxCK+VflYxG5qtMqrdi3
         4DEqE62v3zQjg8d+86ZPzFF4NrP1iPFrXzbktaHoOKQnJeTWWtsG7HmRg80SrBqYOecX
         UMWQ==
X-Gm-Message-State: APjAAAV83VtUojN0Fj2yS+aZFfL8HfXp8Aq5lcUFqm9D1ABLA00bBaWM
        vyQOhbStn35/6Kf/ms/X9FCtjCoHo9uKSqonQJaTiTkcMykTBywIsHQ0A2j0ya2aTRbobcmtTvQ
        gwK2sNxZsRN7y9Kzr
X-Received: by 2002:a2e:575c:: with SMTP id r28mr8131059ljd.245.1573248790228;
        Fri, 08 Nov 2019 13:33:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqyAi43npY0faZsZZ6teo9y2V3AZS6Vj9mcY+7NfpUkkq1/GvTFroNpp36SBngBr+vb+HXn5ig==
X-Received: by 2002:a2e:575c:: with SMTP id r28mr8131051ljd.245.1573248789967;
        Fri, 08 Nov 2019 13:33:09 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id r22sm2970828ljk.31.2019.11.08.13.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:33:09 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8925A1800CB; Fri,  8 Nov 2019 22:33:08 +0100 (CET)
Subject: [PATCH bpf-next v2 3/6] libbpf: Propagate EPERM to caller on program
 load
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 08 Nov 2019 22:33:08 +0100
Message-ID: <157324878850.910124.10106029353677591175.stgit@toke.dk>
In-Reply-To: <157324878503.910124.12936814523952521484.stgit@toke.dk>
References: <157324878503.910124.12936814523952521484.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

When loading an eBPF program, libbpf overrides the return code for EPERM
errors instead of returning it to the caller. This makes it hard to figure
out what went wrong on load.

In particular, EPERM is returned when the system rlimit is too low to lock
the memory required for the BPF program. Previously, this was somewhat
obscured because the rlimit error would be hit on map creation (which does
return it correctly). However, since maps can now be reused, object load
can proceed all the way to loading programs without hitting the error;
propagating it even in this case makes it possible for the caller to react
appropriately (and, e.g., attempt to raise the rlimit before retrying).

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cea61b2ec9d3..582c0fd16697 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3721,7 +3721,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 		free(log_buf);
 		goto retry_load;
 	}
-	ret = -LIBBPF_ERRNO__LOAD;
+	ret = (errno == EPERM) ? -errno : -LIBBPF_ERRNO__LOAD;
 	cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
 	pr_warn("load bpf program failed: %s\n", cp);
 
@@ -3749,7 +3749,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 			}
 		}
 
-		if (log_buf)
+		if (log_buf && ret != -EPERM)
 			ret = -LIBBPF_ERRNO__KVER;
 	}
 

