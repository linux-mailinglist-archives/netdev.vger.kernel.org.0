Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0FCE4443
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406803AbfJYHTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:19:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41199 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733140AbfJYHTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:19:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id q7so964190pfh.8;
        Fri, 25 Oct 2019 00:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mo8rOOqPFlG4QlkfJoaqtn8M+VuNhB7qr9CO3I9Sol8=;
        b=onmWZbYmFNyW/W17hYRLHnG/39H4xsFvpzypuaxpe2138vh0/bGEqboDtAgxfoGyHl
         OnHtPhZqRGrfgl9VQ0zDFMbNREf2KjYWqiCgnJqufF0L8gjhfqHD5/uXVRXq6a1O6U8A
         oMpOOo1/dsTMS7qkrsiu15uXX/fpArz5NEKhhwDqMRmmo0H9EB7BK1qFBqzVlhZGiE2+
         dPCgjOkQanFyeVsJcN0cUCuYoGWGAWhLoYPLhDzxOH2BiFG797tUiasNxGrMhILCrw0H
         V5tTYe5yxoRbBbEe1bpEKFSjbhY6W0kgoEGXwiP8LTk2qC1g6qZOkLFqj9OJJ+H3Ic/S
         LOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mo8rOOqPFlG4QlkfJoaqtn8M+VuNhB7qr9CO3I9Sol8=;
        b=tn1lUaO5THc9QH+petLf2xv+IcZps3I7hhs8GT/6mnUtoaJLGnI0czncpwvgRKv2k0
         u9vnOVH6lGbpYqJCzxZQAieGvzPNn8/6lQh4UayhXytkQCzsrcUtt9kaSMJAEizElCt0
         j5WeO9o/D5mlV8TUEKKBKzl5BNfwcTSg2g8erakOPvP3azNzwdR/9I+62zxsq1fW0LDJ
         Xa0bwJamxCHI/jxguALwiruYxKqd5hBppUHjq+6j70pB9RZfCn+WCuMJYw/kXtuQXWJ6
         hS1NsLsyfZn71cj1wlSac/DLiMoCiRbDcBoDD3Etgw3oZ9lrFXCimFc8dSYeTwKPOnzS
         Bp9w==
X-Gm-Message-State: APjAAAV8on93QHD0Fjj2Ag0Bdtjybk7dfi8lOU02xahovEgmBNaeb8ym
        6XlDRrOPUfV0W9qnmOymJe8cEd6hg7Q=
X-Google-Smtp-Source: APXvYqxYVEvur7K0NcoEgailuf8bB1/YBUuKU9e8ZQDp+SgDpuyQZgF3qckzirQdQB2nsxKlEkzIGg==
X-Received: by 2002:a17:90a:a401:: with SMTP id y1mr2208493pjp.118.1571987949461;
        Fri, 25 Oct 2019 00:19:09 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t27sm1165065pfq.169.2019.10.25.00.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 00:19:09 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, toke@redhat.com
Subject: [PATCH bpf-next v2 2/2] bpf: implement map_gen_lookup() callback for XSKMAP
Date:   Fri, 25 Oct 2019 09:18:41 +0200
Message-Id: <20191025071842.7724-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025071842.7724-1-bjorn.topel@gmail.com>
References: <20191025071842.7724-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

I gave a shot for implementing map_gen_lookup() for xskmap just to wipe
away the tears from the bulk redirect struggle... not sure whether it's
still needed anyway since Bjorn posted a patch where he removes the
bpf_map_lookup_elem call from XDP program that libbpf is attaching for
AF_XDP socks.

Let me know what you think, tested it out and seems to do the job,
didn't check the perf difference. If that's useful, then devmap would
have mostly the same implementation.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 kernel/bpf/xskmap.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index a83e92fe2971..62ce88e57d98 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -163,6 +163,22 @@ struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
 	return xs;
 }
 
+static u32 xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
+{
+	const int ret = BPF_REG_0, mp = BPF_REG_1, index = BPF_REG_2;
+	struct bpf_insn *insn = insn_buf;
+
+	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
+	*insn++ = BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 5);
+	*insn++ = BPF_ALU64_IMM(BPF_LSH, ret, ilog2(sizeof(struct xsk_sock *)));
+	*insn++ = BPF_ALU64_IMM(BPF_ADD, mp, offsetof(struct xsk_map, xsk_map));
+	*insn++ = BPF_ALU64_REG(BPF_ADD, ret, mp);
+	*insn++ = BPF_LDX_MEM(BPF_DW, ret, ret, 0);
+	*insn++ = BPF_JMP_IMM(BPF_JA, 0, 0, 1);
+	*insn++ = BPF_MOV64_IMM(ret, 0);
+	return insn - insn_buf;
+}
+
 int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
 		       struct xdp_sock *xs)
 {
@@ -303,6 +319,7 @@ const struct bpf_map_ops xsk_map_ops = {
 	.map_free = xsk_map_free,
 	.map_get_next_key = xsk_map_get_next_key,
 	.map_lookup_elem = xsk_map_lookup_elem,
+	.map_gen_lookup = xsk_map_gen_lookup,
 	.map_lookup_elem_sys_only = xsk_map_lookup_elem_sys_only,
 	.map_update_elem = xsk_map_update_elem,
 	.map_delete_elem = xsk_map_delete_elem,
-- 
2.20.1

