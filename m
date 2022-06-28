Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455ED55EE2D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiF1TvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiF1Tut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE853A70C;
        Tue, 28 Jun 2022 12:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445746; x=1687981746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sgjOMZvqwy3/sgeJmIw/5jGoi4GaZrbkmWa1wRm6tdY=;
  b=AONLCuT4qgIwK4zUm6RFmNB5ns3q/SZHwV36K52ChsFU04ak0jh7N8qI
   wc8gH6MuqT4Zok5oDPKkvut+ZrEHrhKZex0d8NqG+uI7ryPxSi6+lo8AR
   UrCYt5lfvDHn6Z4vdivr5L9VNNztk7s15iiRxMSV+2ENezs3kowd6DWa2
   h4eTG9QhqBXp5ad9+C5zdbgr/OXlDTvdoL6w/Oeu96B8Z/RxltyUkYqg0
   CX7fkerH8e+AKQGQcBlgPcfnYX9uS8ng9chm98+IgGQ4C+j75bUH9l9Lk
   rqIv+v/8r0D0cfdZjg6GSakNKaKMXbwiTfHsN0oa3ZaFIDpFhPBEl/Kql
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="345828299"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="345828299"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="836809320"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jun 2022 12:49:00 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr94022013;
        Tue, 28 Jun 2022 20:48:59 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 04/52] libbpf: patch module BTF ID into BPF insns
Date:   Tue, 28 Jun 2022 21:47:24 +0200
Message-Id: <20220628194812.1453059-5-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Larysa Zaremba <larysa.zaremba@intel.com>

Return both type id and BTF id from bpf_core_type_id_kernel().
Earlier only type id was returned despite the fact that llvm
has enabled the 64 return type for this instruction [1].
This was done as a preparation to the patch [2], which
also strongly served as a inspiration for this implementation.

[1] https://reviews.llvm.org/D91489
[2] https://lore.kernel.org/all/20201205025140.443115-1-andrii@kernel.org

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/bpf_core_read.h | 3 ++-
 tools/lib/bpf/relo_core.c     | 8 +++++++-
 tools/lib/bpf/relo_core.h     | 1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index fd48b1ff59ca..2b7d675b2dd0 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -167,7 +167,8 @@ enum bpf_enum_value_kind {
  * Convenience macro to get BTF type ID of a target kernel's type that matches
  * specified local type.
  * Returns:
- *    - valid 32-bit unsigned type ID in kernel BTF;
+ *    - valid 64-bit unsigned integer: the upper 32 bits is the BTF ID
+ *      and the lower 32 bits is the type ID within the BTF.
  *    - 0, if no matching type was found in a target kernel BTF.
  */
 #define bpf_core_type_id_kernel(type)					    \
diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index e070123332cd..020f0f81374c 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -884,6 +884,7 @@ static int bpf_core_calc_relo(const char *prog_name,
 	res->fail_memsz_adjust = false;
 	res->orig_sz = res->new_sz = 0;
 	res->orig_type_id = res->new_type_id = 0;
+	res->btf_obj_id = 0;
 
 	if (core_relo_is_field_based(relo->kind)) {
 		err = bpf_core_calc_field_relo(prog_name, relo, local_spec,
@@ -934,6 +935,8 @@ static int bpf_core_calc_relo(const char *prog_name,
 	} else if (core_relo_is_type_based(relo->kind)) {
 		err = bpf_core_calc_type_relo(relo, local_spec, &res->orig_val, &res->validate);
 		err = err ?: bpf_core_calc_type_relo(relo, targ_spec, &res->new_val, NULL);
+		if (!err && relo->kind == BPF_CORE_TYPE_ID_TARGET)
+			res->btf_obj_id = btf_obj_id(targ_spec->btf);
 	} else if (core_relo_is_enumval_based(relo->kind)) {
 		err = bpf_core_calc_enumval_relo(relo, local_spec, &res->orig_val);
 		err = err ?: bpf_core_calc_enumval_relo(relo, targ_spec, &res->new_val);
@@ -1125,7 +1128,10 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 		}
 
 		insn[0].imm = new_val;
-		insn[1].imm = new_val >> 32;
+		/* For type IDs, upper 32 bits are used for BTF ID */
+		insn[1].imm = relo->kind == BPF_CORE_TYPE_ID_TARGET ?
+					    res->btf_obj_id :
+					    (new_val >> 32);
 		pr_debug("prog '%s': relo #%d: patched insn #%d (LDIMM64) imm64 %llu -> %llu\n",
 			 prog_name, relo_idx, insn_idx,
 			 (unsigned long long)imm, (unsigned long long)new_val);
diff --git a/tools/lib/bpf/relo_core.h b/tools/lib/bpf/relo_core.h
index 3fd3842d4230..f026ea36140e 100644
--- a/tools/lib/bpf/relo_core.h
+++ b/tools/lib/bpf/relo_core.h
@@ -66,6 +66,7 @@ struct bpf_core_relo_res {
 	__u32 orig_type_id;
 	__u32 new_sz;
 	__u32 new_type_id;
+	__u32 btf_obj_id;
 };
 
 int __bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
-- 
2.36.1

