Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28E945399
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 06:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbfFNEbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 00:31:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:36143 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfFNEbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 00:31:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 21:31:02 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2019 21:31:00 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hbdrf-0004z3-Ul; Fri, 14 Jun 2019 12:30:59 +0800
Date:   Fri, 14 Jun 2019 12:30:17 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     kbuild-all@01.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] bpf: optimize constant blinding
Message-ID: <201906141213.LXZteGuk%lkp@intel.com>
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Naveen,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]
[also build test WARNING on v5.2-rc4 next-20190613]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Naveen-N-Rao/bpf-optimize-constant-blinding/20190614-023948
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   kernel/bpf/core.c:210:49: sparse: sparse: arithmetics on pointers to functions
   include/linux/rbtree.h:120:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   include/linux/rbtree.h:120:9: sparse:    struct rb_node [noderef] <asn:4> *
   include/linux/rbtree.h:120:9: sparse:    struct rb_node *
   include/linux/rbtree.h:120:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   include/linux/rbtree.h:120:9: sparse:    struct rb_node [noderef] <asn:4> *
   include/linux/rbtree.h:120:9: sparse:    struct rb_node *
>> kernel/bpf/core.c:1122:59: sparse: sparse: Using plain integer as NULL pointer
   kernel/bpf/core.c:1122:62: sparse: sparse: Using plain integer as NULL pointer
   include/trace/events/xdp.h:28:1: sparse: sparse: Using plain integer as NULL pointer
   include/trace/events/xdp.h:53:1: sparse: sparse: Using plain integer as NULL pointer
   include/trace/events/xdp.h:111:1: sparse: sparse: Using plain integer as NULL pointer
   include/trace/events/xdp.h:126:1: sparse: sparse: Using plain integer as NULL pointer
   include/trace/events/xdp.h:161:1: sparse: sparse: Using plain integer as NULL pointer
   include/trace/events/xdp.h:196:1: sparse: sparse: Using plain integer as NULL pointer
   include/trace/events/xdp.h:231:1: sparse: sparse: Using plain integer as NULL pointer

vim +1122 kernel/bpf/core.c

  1101	
  1102	struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
  1103	{
  1104		int i, j, rewritten, new_len, insn_cnt, ret = 0;
  1105		struct bpf_insn insn_buff[16], aux[2];
  1106		struct bpf_prog *clone, *tmp;
  1107		struct bpf_insn *insn;
  1108		u32 *clone_index;
  1109	
  1110		if (!bpf_jit_blinding_enabled(prog) || prog->blinded)
  1111			return prog;
  1112	
  1113		/* Dry run to figure out the final number of instructions */
  1114		clone_index = vmalloc(prog->len * sizeof(u32));
  1115		if (!clone_index)
  1116			return ERR_PTR(-ENOMEM);
  1117	
  1118		insn_cnt = prog->len;
  1119		insn = prog->insnsi;
  1120		rewritten = 0;
  1121		for (i = 0; i < insn_cnt; i++, insn++) {
> 1122			clone_index[i] = bpf_jit_blind_insn(insn, 0, 0);
  1123			if (clone_index[i] > 1)
  1124				rewritten += clone_index[i] - 1;
  1125		}
  1126	
  1127		if (rewritten) {
  1128			/* Needs new allocation, branch adjustment, et al... */
  1129			clone = bpf_prog_clone_create(prog, GFP_USER);
  1130			if (!clone) {
  1131				ret = -ENOMEM;
  1132				goto err;
  1133			}
  1134	
  1135			new_len = prog->len + rewritten;
  1136			tmp = bpf_prog_realloc(clone, bpf_prog_size(new_len), GFP_USER);
  1137			if (!tmp) {
  1138				ret = -ENOMEM;
  1139				goto err;
  1140			}
  1141			clone = tmp;
  1142			clone->len = new_len;
  1143	
  1144			/* rewrite instructions with constant blinding */
  1145			insn_cnt = prog->len;
  1146			insn = prog->insnsi;
  1147			for (i = 0, j = 0; i < insn_cnt; i++, j++, insn++) {
  1148				/* capture new instruction index in clone_index */
  1149				clone_index[i] = j;
  1150	
  1151				/* We temporarily need to hold the original ld64 insn
  1152				 * so that we can still access the first part in the
  1153				 * second blinding run.
  1154				 */
  1155				if (insn[0].code == (BPF_LD | BPF_IMM | BPF_DW) &&
  1156				    insn[1].code == 0)
  1157					memcpy(aux, insn, sizeof(aux));
  1158	
  1159				rewritten = bpf_jit_blind_insn(insn, aux, insn_buff);
  1160				if (!rewritten) {
  1161					memcpy(clone->insnsi + j, insn,
  1162						sizeof(struct bpf_insn));
  1163				} else {
  1164					memcpy(clone->insnsi + j, insn_buff,
  1165						sizeof(struct bpf_insn) * rewritten);
  1166					j += rewritten - 1;
  1167				}
  1168			}
  1169	
  1170			/* adjust branches */
  1171			for (i = 0; i < insn_cnt; i++) {
  1172				int next_insn_idx = clone->len;
  1173	
  1174				if (i < insn_cnt - 1)
  1175					next_insn_idx = clone_index[i + 1];
  1176	
  1177				insn = clone->insnsi + clone_index[i];
  1178				for (j = clone_index[i]; j < next_insn_idx; j++, insn++) {
  1179					ret = bpf_jit_blind_adj_imm_off(insn, i, j, clone_index);
  1180					if (ret) {
  1181						goto err;
  1182					}
  1183				}
  1184			}
  1185	
  1186			/* adjust linfo */
  1187			if (clone->aux->nr_linfo) {
  1188				struct bpf_line_info *linfo = clone->aux->linfo;
  1189	
  1190				for (i = 0; i < clone->aux->nr_linfo; i++)
  1191					linfo[i].insn_off = clone_index[linfo[i].insn_off];
  1192			}
  1193		} else {
  1194			/* if prog length remains same, not much work to do */
  1195			clone = bpf_prog_clone_create(prog, GFP_USER);
  1196			if (!clone) {
  1197				ret = -ENOMEM;
  1198				goto err;
  1199			}
  1200	
  1201			insn_cnt = clone->len;
  1202			insn = clone->insnsi;
  1203	
  1204			for (i = 0; i < insn_cnt; i++, insn++) {
  1205				if (clone_index[i]) {
  1206					bpf_jit_blind_insn(insn, aux, insn_buff);
  1207					memcpy(insn, insn_buff, sizeof(struct bpf_insn));
  1208				}
  1209			}
  1210		}
  1211	
  1212		clone->blinded = 1;
  1213	
  1214	err:
  1215		vfree(clone_index);
  1216	
  1217		if (ret) {
  1218			if (clone)
  1219				bpf_jit_prog_release_other(prog, clone);
  1220			return ERR_PTR(ret);
  1221		}
  1222	
  1223		return clone;
  1224	}
  1225	#endif /* CONFIG_BPF_JIT */
  1226	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
