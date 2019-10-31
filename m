Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF175EABBE
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfJaIsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:48:25 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42330 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfJaIsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:48:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id j12so451734plt.9;
        Thu, 31 Oct 2019 01:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Afs+oYKB6daK/7S+/ZmIJiYvdLM+2EFsaro6TAKUy8=;
        b=Ah8vC38Rotqz4qO8RKDFqOgRUUj16sR0OmMgRsqa8ZzH19PhgLtMHSAolkz6J8dHoI
         DI0Zp0HzI6XlJzsQ6V7Nb4x2c99lYGTVVHaDGt2FVonL1Lh4TmXeNjVTJIBL/juN/X9q
         d7G32S2NzxSoL9O6SFS6QnZo2+PZc0jdUjOCG6nGuD5KbJocPTbedhEwI/Hk3bqfMXan
         5pZjO2idCVaBR2VTa6nBnvZvZMrafy2R7cxWvCYlxBtfoo9MTnVmK1TLxLg3omhJROcZ
         F0lkvbhhROCk0mWUJlruH8Xpv7sQkZMEvDaMA7ls/4ts5JjknTpg176EHYh15KutCBfd
         JqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Afs+oYKB6daK/7S+/ZmIJiYvdLM+2EFsaro6TAKUy8=;
        b=SX5MOVh2bQoqUkTtlkXrBauLfUOGIHjHFok9N7Z+BRFdtX2qxhS1znGmizisxUwvMS
         ATuZMiD6XnM/m28lzY68XTjZnXeYi7zqbqKB+B7rXRbvsxqHGeMS+XxGMQXT6Mm4mb2g
         gGhEdMG8Ti9x86jGHdlRKyjis1thITqij6zNfkiyyqYJXR5mD98SYxgz1bfntbNG/yda
         w1+0Q+Wqy/gPLSs3U4BHN1hg0FNzvNa5IwGoswJlZg4ouGa3nvGMigvA0WUfSOwsGFBz
         twPBBzoV204NG3xCxRhzIZn9jKKWvMGNe5r51snba0FaUGenqoK2qhNn1ZeJa1ffsBKG
         2mWw==
X-Gm-Message-State: APjAAAVwhzKuZPeb+PRXGJA9jCJzb/bRBjJZpuAVCh9G3uVRTvJE06cb
        kNLwhMrjCmcPQsc2tKp6QXBpZTgYBi1Z2w==
X-Google-Smtp-Source: APXvYqwUb5RgIOa1Os2WQi7WuHx0QrxmABwuU3QTrEk7mUPBdP/H68D+q/TD36W3R4mC03u1+35cwg==
X-Received: by 2002:a17:902:5997:: with SMTP id p23mr5146322pli.302.1572511703847;
        Thu, 31 Oct 2019 01:48:23 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 4sm3335507pfz.185.2019.10.31.01.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 01:48:23 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        toke@redhat.com
Subject: [PATCH bpf-next v4 2/3] bpf: implement map_gen_lookup() callback for XSKMAP
Date:   Thu, 31 Oct 2019 09:47:48 +0100
Message-Id: <20191031084749.14626-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191031084749.14626-1-bjorn.topel@gmail.com>
References: <20191031084749.14626-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Inline the xsk_map_lookup_elem() via implementing the map_gen_lookup()
callback. This results in emitting the bpf instructions in place of
bpf_map_lookup_elem() helper call and better performance of bpf
programs.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 kernel/bpf/xskmap.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index edcbd863650e..fa32f775b4de 100644
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

