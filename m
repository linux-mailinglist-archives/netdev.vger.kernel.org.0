Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0BC2E3589
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502853AbfJXOZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:25:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:38088 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732393AbfJXOZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 10:25:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 07:25:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="373233625"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 24 Oct 2019 07:25:17 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 2/2] xsk: implement map_gen_lookup() callback for XSKMAP
Date:   Thu, 24 Oct 2019 09:19:31 +0200
Message-Id: <20191024071931.3628-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024071931.3628-1-maciej.fijalkowski@intel.com>
References: <20191024071931.3628-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inline the xsk_map_lookup_elem() via implementing the map_gen_lookup()
callback. This results in emitting the bpf instructions in place of
bpf_map_lookup_elem() helper call and better performance of bpf
programs.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 kernel/bpf/xskmap.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 86e3027d4605..0103405f639a 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -165,6 +165,22 @@ struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
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
@@ -305,6 +321,7 @@ const struct bpf_map_ops xsk_map_ops = {
 	.map_free = xsk_map_free,
 	.map_get_next_key = xsk_map_get_next_key,
 	.map_lookup_elem = xsk_map_lookup_elem,
+	.map_gen_lookup = xsk_map_gen_lookup,
 	.map_lookup_elem_sys_only = xsk_map_lookup_elem_sys_only,
 	.map_update_elem = xsk_map_update_elem,
 	.map_delete_elem = xsk_map_delete_elem,
-- 
2.20.1

