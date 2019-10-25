Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4515BE4758
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438730AbfJYJcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:32:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34050 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbfJYJcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:32:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id k7so959568pll.1;
        Fri, 25 Oct 2019 02:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RMWe0n3x6S4X3BKlEdpwQaU1tD5j4F4KqNTGoocQo+U=;
        b=fjBCRKAx3V3QQlWfCwrK3skDRWW3NxLNkVcvkM4U6IAIBFnMSi2GLAJFjACSFrwYBh
         x1AIcJHXMm1FKxQS0oQS16AxVcuwIMxfQgpP4ZgnPd7I7kiIV0RW0GHHQKDvkwshW7MY
         9R8gETGncLd6R1yvr8wFDkL6u373T+G7WPCyccV7hWXHMNi3NJPXJDX+iHbkDZT+Qzns
         5yfzP5Xm2VK4kN9CtO27xSGJT7hs/HS95IH2BVjKhrCFOLpb9OSP7+rzDgvAzmsgMLXe
         SrfYjwijyHk/V0whtI5xv49nCroSCmP6H7LTdvqOxWap0H2RwqWMwrODsFR+BZ3oeS8O
         T14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RMWe0n3x6S4X3BKlEdpwQaU1tD5j4F4KqNTGoocQo+U=;
        b=Edr99Kcy+M4866nM2cJ12bx/lbyBfAWE2cFyLk1q8nmY+iAhQqrthejOCdVeq3po9j
         FvXDbZ6GISJcgC7Hw0MVWFGYKkmoHEa6fO9WmOxe7GlptJXtRuD2A91PsvibifKe3kzR
         80ZPMPj5FEQvVQeaHimv0ldjuxu3T7BlStHo6ZQvadrBXHrzD/I2xiVWUOUWteFcXCEK
         uJlSY7yZXsRyZyS78kmypqPco/4HqFm553f0c6/J3KBw9myl5kJDFdBfDCzBkobYyXvu
         XZGAS1QJpxsvxAHUNPpL+ab+OnkSep+fmXeq28AU/p7HZK0PelP9ktF/bbURomowtLc/
         MCQw==
X-Gm-Message-State: APjAAAX4PjT3iDIrw5A7FCLTIV9P/KqKo2qL6kO9mzZ8IFR8SgDBPyfc
        d14IRV5cuMF4QB0DjhOOebfTy1EZAVw15g==
X-Google-Smtp-Source: APXvYqyleOsApi6ZCMnKGwYOk2qQUSayXui/Byje61Fdad6lzCCHq+EROB+jhOTeGsqFyk05W/OHOw==
X-Received: by 2002:a17:902:d68f:: with SMTP id v15mr2655730ply.206.1571995972363;
        Fri, 25 Oct 2019 02:32:52 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id k24sm1110557pgl.6.2019.10.25.02.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 02:32:51 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        toke@redhat.com
Subject: [PATCH bpf-next v3 2/2] bpf: implement map_gen_lookup() callback for XSKMAP
Date:   Fri, 25 Oct 2019 11:32:19 +0200
Message-Id: <20191025093219.10290-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025093219.10290-1-bjorn.topel@gmail.com>
References: <20191025093219.10290-1-bjorn.topel@gmail.com>
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

