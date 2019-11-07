Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C4BF3511
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389565AbfKGQw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:52:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729895AbfKGQwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 11:52:24 -0500
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D56459451
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 16:52:24 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id h16so622674ljk.20
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:52:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JVaHkUrD5EPd5DZ+FyAOg7wZeJpFBCpNLF9LkAgb1TU=;
        b=hDGYbHVBpKkO+nfUEqtWrSzndBH+9IBN1CeW+abAEQTUtdaPQmEut9xfdptpp98Bkc
         dI75LaNaytkKZOMPnss/QwDr4RroD84bmoRaiTSZ0HorvJu6FN5WQX/M2A7x0DOToouU
         eYDdu6m2HkPeG6ujoBo7QUsa03FKWniQCW7YP1ZHFUJ79ORyH7vMTqnCmwIVyfijOK5b
         Mm84nUvTz/VI799WvVfpEsUN8yrsIuppJLhBBfYC//F1uF2/FQu8W3d+tBKrQmdMZMHT
         Etx64BQOEBlKCPBtmBCTbbCBhPUw54k62RdqRtGbIITHxUv2VYwlacmabebgCZARUS4/
         7s7w==
X-Gm-Message-State: APjAAAViJYcYuK9JxnrDIA0CeyQaCbhPx0G4CxdU45vbfzm4MBB5YRO3
        7m9WWXTZNv2UX5ISY5REX9tYmZE7S6K0e/I53IbVZ7Atspd/r0hV9dYXL+NJXiTGHmNYL65mJIv
        Vs4Xioj7H3eCyz6SL
X-Received: by 2002:a2e:a0ce:: with SMTP id f14mr3256711ljm.241.1573145542968;
        Thu, 07 Nov 2019 08:52:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqyKr5L2Hi38xzbG12+PlRv6Sj7DC3ZkBNW1zTF76Sd32q4oKEj7ehpjZ/eDmnU0VliogaqP/Q==
X-Received: by 2002:a2e:a0ce:: with SMTP id f14mr3256698ljm.241.1573145542802;
        Thu, 07 Nov 2019 08:52:22 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id t14sm1347526lfg.30.2019.11.07.08.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 08:52:22 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 87C731818B5; Thu,  7 Nov 2019 17:52:21 +0100 (CET)
Subject: [PATCH bpf-next 3/6] libbpf: Propagate EPERM to caller on program
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
Date:   Thu, 07 Nov 2019 17:52:21 +0100
Message-ID: <157314554141.693412.14085088717794768890.stgit@toke.dk>
In-Reply-To: <157314553801.693412.15522462897300280861.stgit@toke.dk>
References: <157314553801.693412.15522462897300280861.stgit@toke.dk>
User-Agent: StGit/0.20
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
return it correctly). However, sine maps can now be reused, object load can
proceed all the way to loading programs without hitting the error;
propagating it even in this case makes it possible for the caller to react
appropriately (and, e.g., attempt to raise the rlimit before retrying).

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
 

