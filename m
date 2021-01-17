Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EEF2F9604
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 23:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbhAQWzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 17:55:18 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:40913 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbhAQWzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 17:55:15 -0500
Received: by mail-wr1-f42.google.com with SMTP id 91so14744390wrj.7
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 14:54:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1IC7EhsJCEVB8nk6o2Q/1uFPjRZrIlPtCyIE7xN/ecY=;
        b=p8EhgnLMmL+HsezPn/ftIBsVia4/BobX3pZ+0tU9qyIZ/hDu7KzcE6gyg8IOTS5Nwv
         klannIVgWR8aAMJNokxlcsIvjneHilj1LQhiQhuPo7RxFI/Fc5JEuzdjldQUOdrGW3Z7
         QC6CHGzKGkhnk9iXC2lzCefvpNFiLCGGifXi6xVSm67DPaoXfhaAHCteZDlg8GoQDTXZ
         WR45rUDm5DzA6HLXIT+BNo9MrZvaY1fT5MlufSknlPFvRF+2nHT2dBozPHowT8pKQtyP
         FPU7DxtBDs7qAmi3TnWJnzcDP5TrcVSDef/YNzUorWst6hov/wYeu0e6xhR/Pc1T2tm3
         2DtQ==
X-Gm-Message-State: AOAM53268V55fqiEj3CUwq43xh2YAUhmxWL6A34Ha2oG4sDSwUhiJD47
        lyIPEDyRnCECqXyE+ErIJUf90PC4M8+kZg==
X-Google-Smtp-Source: ABdhPJz+p3g92xgJtfEzN85yo64OR+qd2orCcEjdhV6b/ruxxP6GOr0wSq/b0uk3/W+H1ye8L5sk8A==
X-Received: by 2002:a5d:5005:: with SMTP id e5mr22617808wrt.279.1610924072866;
        Sun, 17 Jan 2021 14:54:32 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id b7sm25052067wrv.47.2021.01.17.14.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 14:54:32 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Subject: [PATCH iproute2 2/2] vrf: fix ip vrf exec with libbpf
Date:   Sun, 17 Jan 2021 22:54:27 +0000
Message-Id: <20210117225427.29658-2-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117225427.29658-1-bluca@debian.org>
References: <20210117225427.29658-1-bluca@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The size of bpf_insn is passed to bpf_load_program instead of the number
of elements as it expects, so ip vrf exec fails with:

$ sudo ip link add vrf-blue type vrf table 10
$ sudo ip link set dev vrf-blue up
$ sudo ip/ip vrf exec vrf-blue ls
Failed to load BPF prog: 'Invalid argument'
last insn is not an exit or jmp
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
Kernel compiled with CGROUP_BPF enabled?

https://bugs.debian.org/980046

Reported-by: Emmanuel DECAEN <Emmanuel.Decaen@xsalto.com>

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 lib/bpf_glue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
index fa609bfe..d00a0dc1 100644
--- a/lib/bpf_glue.c
+++ b/lib/bpf_glue.c
@@ -14,7 +14,8 @@ int bpf_program_load(enum bpf_prog_type type, const struct bpf_insn *insns,
 		     size_t size_log)
 {
 #ifdef HAVE_LIBBPF
-	return bpf_load_program(type, insns, size_insns, license, 0, log, size_log);
+	return bpf_load_program(type, insns, size_insns / sizeof(struct bpf_insn),
+				license, 0, log, size_log);
 #else
 	return bpf_prog_load_dev(type, insns, size_insns, license, 0, log, size_log);
 #endif
-- 
2.29.2

