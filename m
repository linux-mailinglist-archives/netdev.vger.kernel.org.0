Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816BAFBF99
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfKNF1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:20 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33027 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfKNF1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:19 -0500
Received: by mail-pg1-f194.google.com with SMTP id h27so2969326pgn.0
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FePsmM6RKDV0Ap2hRHYsH3iyQOg+1tTst3z4u9JGy9k=;
        b=Piitup2phdAq8ei3qlaasVmKHybBrCS6BSUxlEa64Hbuw99IJ82a64StXLgUPqfh8v
         ooFy9cipBbz99zKcAUmpIqZpDmK9XPANwfbQC85AE6ZW/klAzZnhXK4wxiwo6pImAYjq
         gbiaqrBC6BnQBt5TOJj/XR9eFYnc4KRgtcwn+zM40cT1tCpOrmFCzcTZ6EcC3IvSvkvp
         s6ad/K9eHWQTbETPKO5N7b5S8QnouJambM02RkWP13r6qvljkzMvk1i/hFWoWb9lJBKP
         KijWkjRuful8cwKc1P8LqnoMBwhg2JpUCMdRf6DvF6Q/sT5Ux5Ks4iWzRkzmCiSFQn35
         AWpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FePsmM6RKDV0Ap2hRHYsH3iyQOg+1tTst3z4u9JGy9k=;
        b=ipfMYyuNLwkwYM7x1E8oti03YKjf9YMMOk/QEJ6Xz99wrU+DSH9ahozayRKUvOWEu2
         IQoKNHt7WbVo2HVunpuXSEsjl3BXEoqLquOR8Hrfa038kJZPMUpfnIT1jr75MlOZsWCy
         KjwBkf1CV+7MNwv6s9S6mw5cz8ogA7ElHUzfPWg5XZQELwPmeR9Rg1ZbHgm6+2Ti24xS
         NIBFnPMcYPs07+Eoq3zvEgGUgh+TV2rn2weRV83YYS5WBdVw+yNQG2gctv1n9DcLSmtF
         GdFdshk9gN15K+lWn9glIxb10yy+NVMSdOicTM++Q9vbnKs4h/UTbqSxCiESqefyG3dz
         7bTw==
X-Gm-Message-State: APjAAAU9VQW7m8UXnxtSrZN8WK/kR0/CpxywCBGsFGlVJYpySOxLBj5J
        ll+t0JYkIU8BCNGP0sTinuw/8XqzeiU=
X-Google-Smtp-Source: APXvYqy1hs0f2N0fktmlqr5DaAiBwFVu25KCv1hXBklmifmBDcQ2vHclIx/Z8X8a/XUQdhqqySXW9w==
X-Received: by 2002:a63:db15:: with SMTP id e21mr7982502pgg.21.1573709237650;
        Wed, 13 Nov 2019 21:27:17 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:17 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Prakash Brahmajyosyula <bprakash@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 03/18] octeontx2-af: Add NIX RQ, SQ and CQ contexts to debugfs
Date:   Thu, 14 Nov 2019 10:56:18 +0530
Message-Id: <1573709193-15446-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prakash Brahmajyosyula <bprakash@marvell.com>

To aid in debugging NIX block related issues, added support to dump
NIX block LF's RQ, SQ and CQ hardware contexts in debugfs. User can
check which contexts are enabled currently and dump it's current HW
context.

Four new files 'qsize', 'rq_ctx', 'sq_ctx' and 'cq_ctx' are added to the
debugfs at 'sys/kernel/debug/octeontx2/nix/'

'echo <nixlf index> > qsize' will display current enabled CQ/SQ/RQs.
'echo <nixlf> [rq number/all] > rq_ctx',
'echo <nixlf> [sq number/all] > sq_ctx' &
'echo <nixlf> [cq number/all] > cq_ctx' will dump RQ/SQ/CQ's current
hardware context.

Signed-off-by: Prakash Brahmajyosyula <bprakash@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 500 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   4 +-
 3 files changed, 507 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 3ca2bfe..269c43f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -45,9 +45,14 @@ struct dump_ctx {
 struct rvu_debugfs {
 	struct dentry *root;
 	struct dentry *npa;
+	struct dentry *nix;
 	struct dump_ctx npa_aura_ctx;
 	struct dump_ctx npa_pool_ctx;
+	struct dump_ctx nix_cq_ctx;
+	struct dump_ctx nix_rq_ctx;
+	struct dump_ctx nix_sq_ctx;
 	int npa_qsize_id;
+	int nix_qsize_id;
 };
 #endif
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index c84a501..125b94f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -46,6 +46,8 @@ static const struct file_operations rvu_dbg_##name##_fops = { \
 	.write = rvu_dbg_##write_op \
 }
 
+static void print_nix_qsize(struct seq_file *filp, struct rvu_pfvf *pfvf);
+
 /* Dumps current provisioning status of all RVU block LFs */
 static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 					  char __user *buffer,
@@ -209,6 +211,12 @@ static int rvu_dbg_qsize_display(struct seq_file *filp, void *unsused,
 		qsize_id = rvu->rvu_dbg.npa_qsize_id;
 		print_qsize = print_npa_qsize;
 		break;
+
+	case BLKTYPE_NIX:
+		qsize_id = rvu->rvu_dbg.nix_qsize_id;
+		print_qsize = print_nix_qsize;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -262,6 +270,8 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 	}
 	if (blktype  == BLKTYPE_NPA)
 		rvu->rvu_dbg.npa_qsize_id = lf;
+	else
+		rvu->rvu_dbg.nix_qsize_id = lf;
 
 qsize_write_done:
 	kfree(cmd_buf_tmp);
@@ -599,6 +609,495 @@ static int rvu_dbg_npa_pool_ctx_display(struct seq_file *filp, void *unused)
 
 RVU_DEBUG_SEQ_FOPS(npa_pool_ctx, npa_pool_ctx_display, npa_pool_ctx_write);
 
+/* Dumps given nix_sq's context */
+static void print_nix_sq_ctx(struct seq_file *m, struct nix_aq_enq_rsp *rsp)
+{
+	struct nix_sq_ctx_s *sq_ctx = &rsp->sq;
+
+	seq_printf(m, "W0: sqe_way_mask \t\t%d\nW0: cq \t\t\t\t%d\n",
+		   sq_ctx->sqe_way_mask, sq_ctx->cq);
+	seq_printf(m, "W0: sdp_mcast \t\t\t%d\nW0: substream \t\t\t0x%03x\n",
+		   sq_ctx->sdp_mcast, sq_ctx->substream);
+	seq_printf(m, "W0: qint_idx \t\t\t%d\nW0: ena \t\t\t%d\n\n",
+		   sq_ctx->qint_idx, sq_ctx->ena);
+
+	seq_printf(m, "W1: sqb_count \t\t\t%d\nW1: default_chan \t\t%d\n",
+		   sq_ctx->sqb_count, sq_ctx->default_chan);
+	seq_printf(m, "W1: smq_rr_quantum \t\t%d\nW1: sso_ena \t\t\t%d\n",
+		   sq_ctx->smq_rr_quantum, sq_ctx->sso_ena);
+	seq_printf(m, "W1: xoff \t\t\t%d\nW1: cq_ena \t\t\t%d\nW1: smq\t\t\t\t%d\n\n",
+		   sq_ctx->xoff, sq_ctx->cq_ena, sq_ctx->smq);
+
+	seq_printf(m, "W2: sqe_stype \t\t\t%d\nW2: sq_int_ena \t\t\t%d\n",
+		   sq_ctx->sqe_stype, sq_ctx->sq_int_ena);
+	seq_printf(m, "W2: sq_int \t\t\t%d\nW2: sqb_aura \t\t\t%d\n",
+		   sq_ctx->sq_int, sq_ctx->sqb_aura);
+	seq_printf(m, "W2: smq_rr_count \t\t%d\n\n", sq_ctx->smq_rr_count);
+
+	seq_printf(m, "W3: smq_next_sq_vld\t\t%d\nW3: smq_pend\t\t\t%d\n",
+		   sq_ctx->smq_next_sq_vld, sq_ctx->smq_pend);
+	seq_printf(m, "W3: smenq_next_sqb_vld \t\t%d\nW3: head_offset\t\t\t%d\n",
+		   sq_ctx->smenq_next_sqb_vld, sq_ctx->head_offset);
+	seq_printf(m, "W3: smenq_offset\t\t%d\nW3: tail_offset\t\t\t%d\n",
+		   sq_ctx->smenq_offset, sq_ctx->tail_offset);
+	seq_printf(m, "W3: smq_lso_segnum \t\t%d\nW3: smq_next_sq\t\t\t%d\n",
+		   sq_ctx->smq_lso_segnum, sq_ctx->smq_next_sq);
+	seq_printf(m, "W3: mnq_dis \t\t\t%d\nW3: lmt_dis \t\t\t%d\n",
+		   sq_ctx->mnq_dis, sq_ctx->lmt_dis);
+	seq_printf(m, "W3: cq_limit\t\t\t%d\nW3: max_sqe_size\t\t%d\n\n",
+		   sq_ctx->cq_limit, sq_ctx->max_sqe_size);
+
+	seq_printf(m, "W4: next_sqb \t\t\t%llx\n\n", sq_ctx->next_sqb);
+	seq_printf(m, "W5: tail_sqb \t\t\t%llx\n\n", sq_ctx->tail_sqb);
+	seq_printf(m, "W6: smenq_sqb \t\t\t%llx\n\n", sq_ctx->smenq_sqb);
+	seq_printf(m, "W7: smenq_next_sqb \t\t%llx\n\n",
+		   sq_ctx->smenq_next_sqb);
+
+	seq_printf(m, "W8: head_sqb\t\t\t%llx\n\n", sq_ctx->head_sqb);
+
+	seq_printf(m, "W9: vfi_lso_vld\t\t\t%d\nW9: vfi_lso_vlan1_ins_ena\t%d\n",
+		   sq_ctx->vfi_lso_vld, sq_ctx->vfi_lso_vlan1_ins_ena);
+	seq_printf(m, "W9: vfi_lso_vlan0_ins_ena\t%d\nW9: vfi_lso_mps\t\t\t%d\n",
+		   sq_ctx->vfi_lso_vlan0_ins_ena, sq_ctx->vfi_lso_mps);
+	seq_printf(m, "W9: vfi_lso_sb\t\t\t%d\nW9: vfi_lso_sizem1\t\t%d\n",
+		   sq_ctx->vfi_lso_sb, sq_ctx->vfi_lso_sizem1);
+	seq_printf(m, "W9: vfi_lso_total\t\t%d\n\n", sq_ctx->vfi_lso_total);
+
+	seq_printf(m, "W10: scm_lso_rem \t\t%llu\n\n",
+		   (u64)sq_ctx->scm_lso_rem);
+	seq_printf(m, "W11: octs \t\t\t%llu\n\n", (u64)sq_ctx->octs);
+	seq_printf(m, "W12: pkts \t\t\t%llu\n\n", (u64)sq_ctx->pkts);
+	seq_printf(m, "W14: dropped_octs \t\t%llu\n\n",
+		   (u64)sq_ctx->dropped_octs);
+	seq_printf(m, "W15: dropped_pkts \t\t%llu\n\n",
+		   (u64)sq_ctx->dropped_pkts);
+}
+
+/* Dumps given nix_rq's context */
+static void print_nix_rq_ctx(struct seq_file *m, struct nix_aq_enq_rsp *rsp)
+{
+	struct nix_rq_ctx_s *rq_ctx = &rsp->rq;
+
+	seq_printf(m, "W0: wqe_aura \t\t\t%d\nW0: substream \t\t\t0x%03x\n",
+		   rq_ctx->wqe_aura, rq_ctx->substream);
+	seq_printf(m, "W0: cq \t\t\t\t%d\nW0: ena_wqwd \t\t\t%d\n",
+		   rq_ctx->cq, rq_ctx->ena_wqwd);
+	seq_printf(m, "W0: ipsech_ena \t\t\t%d\nW0: sso_ena \t\t\t%d\n",
+		   rq_ctx->ipsech_ena, rq_ctx->sso_ena);
+	seq_printf(m, "W0: ena \t\t\t%d\n\n", rq_ctx->ena);
+
+	seq_printf(m, "W1: lpb_drop_ena \t\t%d\nW1: spb_drop_ena \t\t%d\n",
+		   rq_ctx->lpb_drop_ena, rq_ctx->spb_drop_ena);
+	seq_printf(m, "W1: xqe_drop_ena \t\t%d\nW1: wqe_caching \t\t%d\n",
+		   rq_ctx->xqe_drop_ena, rq_ctx->wqe_caching);
+	seq_printf(m, "W1: pb_caching \t\t\t%d\nW1: sso_tt \t\t\t%d\n",
+		   rq_ctx->pb_caching, rq_ctx->sso_tt);
+	seq_printf(m, "W1: sso_grp \t\t\t%d\nW1: lpb_aura \t\t\t%d\n",
+		   rq_ctx->sso_grp, rq_ctx->lpb_aura);
+	seq_printf(m, "W1: spb_aura \t\t\t%d\n\n", rq_ctx->spb_aura);
+
+	seq_printf(m, "W2: xqe_hdr_split \t\t%d\nW2: xqe_imm_copy \t\t%d\n",
+		   rq_ctx->xqe_hdr_split, rq_ctx->xqe_imm_copy);
+	seq_printf(m, "W2: xqe_imm_size \t\t%d\nW2: later_skip \t\t\t%d\n",
+		   rq_ctx->xqe_imm_size, rq_ctx->later_skip);
+	seq_printf(m, "W2: first_skip \t\t\t%d\nW2: lpb_sizem1 \t\t\t%d\n",
+		   rq_ctx->first_skip, rq_ctx->lpb_sizem1);
+	seq_printf(m, "W2: spb_ena \t\t\t%d\nW2: wqe_skip \t\t\t%d\n",
+		   rq_ctx->spb_ena, rq_ctx->wqe_skip);
+	seq_printf(m, "W2: spb_sizem1 \t\t\t%d\n\n", rq_ctx->spb_sizem1);
+
+	seq_printf(m, "W3: spb_pool_pass \t\t%d\nW3: spb_pool_drop \t\t%d\n",
+		   rq_ctx->spb_pool_pass, rq_ctx->spb_pool_drop);
+	seq_printf(m, "W3: spb_aura_pass \t\t%d\nW3: spb_aura_drop \t\t%d\n",
+		   rq_ctx->spb_aura_pass, rq_ctx->spb_aura_drop);
+	seq_printf(m, "W3: wqe_pool_pass \t\t%d\nW3: wqe_pool_drop \t\t%d\n",
+		   rq_ctx->wqe_pool_pass, rq_ctx->wqe_pool_drop);
+	seq_printf(m, "W3: xqe_pass \t\t\t%d\nW3: xqe_drop \t\t\t%d\n\n",
+		   rq_ctx->xqe_pass, rq_ctx->xqe_drop);
+
+	seq_printf(m, "W4: qint_idx \t\t\t%d\nW4: rq_int_ena \t\t\t%d\n",
+		   rq_ctx->qint_idx, rq_ctx->rq_int_ena);
+	seq_printf(m, "W4: rq_int \t\t\t%d\nW4: lpb_pool_pass \t\t%d\n",
+		   rq_ctx->rq_int, rq_ctx->lpb_pool_pass);
+	seq_printf(m, "W4: lpb_pool_drop \t\t%d\nW4: lpb_aura_pass \t\t%d\n",
+		   rq_ctx->lpb_pool_drop, rq_ctx->lpb_aura_pass);
+	seq_printf(m, "W4: lpb_aura_drop \t\t%d\n\n", rq_ctx->lpb_aura_drop);
+
+	seq_printf(m, "W5: flow_tagw \t\t\t%d\nW5: bad_utag \t\t\t%d\n",
+		   rq_ctx->flow_tagw, rq_ctx->bad_utag);
+	seq_printf(m, "W5: good_utag \t\t\t%d\nW5: ltag \t\t\t%d\n\n",
+		   rq_ctx->good_utag, rq_ctx->ltag);
+
+	seq_printf(m, "W6: octs \t\t\t%llu\n\n", (u64)rq_ctx->octs);
+	seq_printf(m, "W7: pkts \t\t\t%llu\n\n", (u64)rq_ctx->pkts);
+	seq_printf(m, "W8: drop_octs \t\t\t%llu\n\n", (u64)rq_ctx->drop_octs);
+	seq_printf(m, "W9: drop_pkts \t\t\t%llu\n\n", (u64)rq_ctx->drop_pkts);
+	seq_printf(m, "W10: re_pkts \t\t\t%llu\n", (u64)rq_ctx->re_pkts);
+}
+
+/* Dumps given nix_cq's context */
+static void print_nix_cq_ctx(struct seq_file *m, struct nix_aq_enq_rsp *rsp)
+{
+	struct nix_cq_ctx_s *cq_ctx = &rsp->cq;
+
+	seq_printf(m, "W0: base \t\t\t%llx\n\n", cq_ctx->base);
+
+	seq_printf(m, "W1: wrptr \t\t\t%llx\n", (u64)cq_ctx->wrptr);
+	seq_printf(m, "W1: avg_con \t\t\t%d\nW1: cint_idx \t\t\t%d\n",
+		   cq_ctx->avg_con, cq_ctx->cint_idx);
+	seq_printf(m, "W1: cq_err \t\t\t%d\nW1: qint_idx \t\t\t%d\n",
+		   cq_ctx->cq_err, cq_ctx->qint_idx);
+	seq_printf(m, "W1: bpid \t\t\t%d\nW1: bp_ena \t\t\t%d\n\n",
+		   cq_ctx->bpid, cq_ctx->bp_ena);
+
+	seq_printf(m, "W2: update_time \t\t%d\nW2:avg_level \t\t\t%d\n",
+		   cq_ctx->update_time, cq_ctx->avg_level);
+	seq_printf(m, "W2: head \t\t\t%d\nW2:tail \t\t\t%d\n\n",
+		   cq_ctx->head, cq_ctx->tail);
+
+	seq_printf(m, "W3: cq_err_int_ena \t\t%d\nW3:cq_err_int \t\t\t%d\n",
+		   cq_ctx->cq_err_int_ena, cq_ctx->cq_err_int);
+	seq_printf(m, "W3: qsize \t\t\t%d\nW3:caching \t\t\t%d\n",
+		   cq_ctx->qsize, cq_ctx->caching);
+	seq_printf(m, "W3: substream \t\t\t0x%03x\nW3: ena \t\t\t%d\n",
+		   cq_ctx->substream, cq_ctx->ena);
+	seq_printf(m, "W3: drop_ena \t\t\t%d\nW3: drop \t\t\t%d\n",
+		   cq_ctx->drop_ena, cq_ctx->drop);
+	seq_printf(m, "W3: bp \t\t\t\t%d\n\n", cq_ctx->bp);
+}
+
+static int rvu_dbg_nix_queue_ctx_display(struct seq_file *filp,
+					 void *unused, int ctype)
+{
+	void (*print_nix_ctx)(struct seq_file *filp,
+			      struct nix_aq_enq_rsp *rsp) = NULL;
+	struct rvu *rvu = filp->private;
+	struct nix_aq_enq_req aq_req;
+	struct nix_aq_enq_rsp rsp;
+	char *ctype_string = NULL;
+	int qidx, rc, max_id = 0;
+	struct rvu_pfvf *pfvf;
+	int nixlf, id, all;
+	u16 pcifunc;
+
+	switch (ctype) {
+	case NIX_AQ_CTYPE_CQ:
+		nixlf = rvu->rvu_dbg.nix_cq_ctx.lf;
+		id = rvu->rvu_dbg.nix_cq_ctx.id;
+		all = rvu->rvu_dbg.nix_cq_ctx.all;
+		break;
+
+	case NIX_AQ_CTYPE_SQ:
+		nixlf = rvu->rvu_dbg.nix_sq_ctx.lf;
+		id = rvu->rvu_dbg.nix_sq_ctx.id;
+		all = rvu->rvu_dbg.nix_sq_ctx.all;
+		break;
+
+	case NIX_AQ_CTYPE_RQ:
+		nixlf = rvu->rvu_dbg.nix_rq_ctx.lf;
+		id = rvu->rvu_dbg.nix_rq_ctx.id;
+		all = rvu->rvu_dbg.nix_rq_ctx.all;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (!rvu_dbg_is_valid_lf(rvu, BLKTYPE_NIX, nixlf, &pcifunc))
+		return -EINVAL;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	if (ctype == NIX_AQ_CTYPE_SQ && !pfvf->sq_ctx) {
+		seq_puts(filp, "SQ context is not initialized\n");
+		return -EINVAL;
+	} else if (ctype == NIX_AQ_CTYPE_RQ && !pfvf->rq_ctx) {
+		seq_puts(filp, "RQ context is not initialized\n");
+		return -EINVAL;
+	} else if (ctype == NIX_AQ_CTYPE_CQ && !pfvf->cq_ctx) {
+		seq_puts(filp, "CQ context is not initialized\n");
+		return -EINVAL;
+	}
+
+	if (ctype == NIX_AQ_CTYPE_SQ) {
+		max_id = pfvf->sq_ctx->qsize;
+		ctype_string = "sq";
+		print_nix_ctx = print_nix_sq_ctx;
+	} else if (ctype == NIX_AQ_CTYPE_RQ) {
+		max_id = pfvf->rq_ctx->qsize;
+		ctype_string = "rq";
+		print_nix_ctx = print_nix_rq_ctx;
+	} else if (ctype == NIX_AQ_CTYPE_CQ) {
+		max_id = pfvf->cq_ctx->qsize;
+		ctype_string = "cq";
+		print_nix_ctx = print_nix_cq_ctx;
+	}
+
+	memset(&aq_req, 0, sizeof(struct nix_aq_enq_req));
+	aq_req.hdr.pcifunc = pcifunc;
+	aq_req.ctype = ctype;
+	aq_req.op = NIX_AQ_INSTOP_READ;
+	if (all)
+		id = 0;
+	else
+		max_id = id + 1;
+	for (qidx = id; qidx < max_id; qidx++) {
+		aq_req.qidx = qidx;
+		seq_printf(filp, "=====%s_ctx for nixlf:%d and qidx:%d is=====\n",
+			   ctype_string, nixlf, aq_req.qidx);
+		rc = rvu_mbox_handler_nix_aq_enq(rvu, &aq_req, &rsp);
+		if (rc) {
+			seq_puts(filp, "Failed to read the context\n");
+			return -EINVAL;
+		}
+		print_nix_ctx(filp, &rsp);
+	}
+	return 0;
+}
+
+static int write_nix_queue_ctx(struct rvu *rvu, bool all, int nixlf,
+			       int id, int ctype, char *ctype_string)
+{
+	struct rvu_pfvf *pfvf;
+	int max_id = 0;
+	u16 pcifunc;
+
+	if (!rvu_dbg_is_valid_lf(rvu, BLKTYPE_NIX, nixlf, &pcifunc))
+		return -EINVAL;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+	if (ctype == NIX_AQ_CTYPE_SQ) {
+		if (!pfvf->sq_ctx) {
+			dev_warn(rvu->dev, "SQ context is not initialized\n");
+			return -EINVAL;
+		}
+		max_id = pfvf->sq_ctx->qsize;
+	} else if (ctype == NIX_AQ_CTYPE_RQ) {
+		if (!pfvf->rq_ctx) {
+			dev_warn(rvu->dev, "RQ context is not initialized\n");
+			return -EINVAL;
+		}
+		max_id = pfvf->rq_ctx->qsize;
+	} else if (ctype == NIX_AQ_CTYPE_CQ) {
+		if (!pfvf->cq_ctx) {
+			dev_warn(rvu->dev, "CQ context is not initialized\n");
+			return -EINVAL;
+		}
+		max_id = pfvf->cq_ctx->qsize;
+	}
+
+	if (id < 0 || id >= max_id) {
+		dev_warn(rvu->dev, "Invalid %s_ctx valid range 0-%d\n",
+			 ctype_string, max_id - 1);
+		return -EINVAL;
+	}
+	switch (ctype) {
+	case NIX_AQ_CTYPE_CQ:
+		rvu->rvu_dbg.nix_cq_ctx.lf = nixlf;
+		rvu->rvu_dbg.nix_cq_ctx.id = id;
+		rvu->rvu_dbg.nix_cq_ctx.all = all;
+		break;
+
+	case NIX_AQ_CTYPE_SQ:
+		rvu->rvu_dbg.nix_sq_ctx.lf = nixlf;
+		rvu->rvu_dbg.nix_sq_ctx.id = id;
+		rvu->rvu_dbg.nix_sq_ctx.all = all;
+		break;
+
+	case NIX_AQ_CTYPE_RQ:
+		rvu->rvu_dbg.nix_rq_ctx.lf = nixlf;
+		rvu->rvu_dbg.nix_rq_ctx.id = id;
+		rvu->rvu_dbg.nix_rq_ctx.all = all;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static ssize_t rvu_dbg_nix_queue_ctx_write(struct file *filp,
+					   const char __user *buffer,
+					   size_t count, loff_t *ppos,
+					   int ctype)
+{
+	struct seq_file *m = filp->private_data;
+	struct rvu *rvu = m->private;
+	char *cmd_buf, *ctype_string;
+	int nixlf, id = 0, ret;
+	bool all = false;
+
+	if ((*ppos != 0) || !count)
+		return -EINVAL;
+
+	switch (ctype) {
+	case NIX_AQ_CTYPE_SQ:
+		ctype_string = "sq";
+		break;
+	case NIX_AQ_CTYPE_RQ:
+		ctype_string = "rq";
+		break;
+	case NIX_AQ_CTYPE_CQ:
+		ctype_string = "cq";
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
+
+	if (!cmd_buf)
+		return count;
+
+	ret = parse_cmd_buffer_ctx(cmd_buf, &count, buffer,
+				   &nixlf, &id, &all);
+	if (ret < 0) {
+		dev_info(rvu->dev,
+			 "Usage: echo <nixlf> [%s number/all] > %s_ctx\n",
+			 ctype_string, ctype_string);
+		goto done;
+	} else {
+		ret = write_nix_queue_ctx(rvu, all, nixlf, id, ctype,
+					  ctype_string);
+	}
+done:
+	kfree(cmd_buf);
+	return ret ? ret : count;
+}
+
+static ssize_t rvu_dbg_nix_sq_ctx_write(struct file *filp,
+					const char __user *buffer,
+					size_t count, loff_t *ppos)
+{
+	return rvu_dbg_nix_queue_ctx_write(filp, buffer, count, ppos,
+					    NIX_AQ_CTYPE_SQ);
+}
+
+static int rvu_dbg_nix_sq_ctx_display(struct seq_file *filp, void *unused)
+{
+	return rvu_dbg_nix_queue_ctx_display(filp, unused, NIX_AQ_CTYPE_SQ);
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_sq_ctx, nix_sq_ctx_display, nix_sq_ctx_write);
+
+static ssize_t rvu_dbg_nix_rq_ctx_write(struct file *filp,
+					const char __user *buffer,
+					size_t count, loff_t *ppos)
+{
+	return rvu_dbg_nix_queue_ctx_write(filp, buffer, count, ppos,
+					    NIX_AQ_CTYPE_RQ);
+}
+
+static int rvu_dbg_nix_rq_ctx_display(struct seq_file *filp, void  *unused)
+{
+	return rvu_dbg_nix_queue_ctx_display(filp, unused,  NIX_AQ_CTYPE_RQ);
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_rq_ctx, nix_rq_ctx_display, nix_rq_ctx_write);
+
+static ssize_t rvu_dbg_nix_cq_ctx_write(struct file *filp,
+					const char __user *buffer,
+					size_t count, loff_t *ppos)
+{
+	return rvu_dbg_nix_queue_ctx_write(filp, buffer, count, ppos,
+					    NIX_AQ_CTYPE_CQ);
+}
+
+static int rvu_dbg_nix_cq_ctx_display(struct seq_file *filp, void *unused)
+{
+	return rvu_dbg_nix_queue_ctx_display(filp, unused, NIX_AQ_CTYPE_CQ);
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_cq_ctx, nix_cq_ctx_display, nix_cq_ctx_write);
+
+static void print_nix_qctx_qsize(struct seq_file *filp, int qsize,
+				 unsigned long *bmap, char *qtype)
+{
+	char *buf;
+
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	bitmap_print_to_pagebuf(false, buf, bmap, qsize);
+	seq_printf(filp, "%s context count : %d\n", qtype, qsize);
+	seq_printf(filp, "%s context ena/dis bitmap : %s\n",
+		   qtype, buf);
+	kfree(buf);
+}
+
+static void print_nix_qsize(struct seq_file *filp, struct rvu_pfvf *pfvf)
+{
+	if (!pfvf->cq_ctx)
+		seq_puts(filp, "cq context is not initialized\n");
+	else
+		print_nix_qctx_qsize(filp, pfvf->cq_ctx->qsize, pfvf->cq_bmap,
+				     "cq");
+
+	if (!pfvf->rq_ctx)
+		seq_puts(filp, "rq context is not initialized\n");
+	else
+		print_nix_qctx_qsize(filp, pfvf->rq_ctx->qsize, pfvf->rq_bmap,
+				     "rq");
+
+	if (!pfvf->sq_ctx)
+		seq_puts(filp, "sq context is not initialized\n");
+	else
+		print_nix_qctx_qsize(filp, pfvf->sq_ctx->qsize, pfvf->sq_bmap,
+				     "sq");
+}
+
+static ssize_t rvu_dbg_nix_qsize_write(struct file *filp,
+				       const char __user *buffer,
+				       size_t count, loff_t *ppos)
+{
+	return rvu_dbg_qsize_write(filp, buffer, count, ppos,
+				   BLKTYPE_NIX);
+}
+
+static int rvu_dbg_nix_qsize_display(struct seq_file *filp, void *unused)
+{
+	return rvu_dbg_qsize_display(filp, unused, BLKTYPE_NIX);
+}
+
+RVU_DEBUG_SEQ_FOPS(nix_qsize, nix_qsize_display, nix_qsize_write);
+
+static void rvu_dbg_nix_init(struct rvu *rvu)
+{
+	const struct device *dev = &rvu->pdev->dev;
+	struct dentry *pfile;
+
+	rvu->rvu_dbg.nix = debugfs_create_dir("nix", rvu->rvu_dbg.root);
+	if (!rvu->rvu_dbg.nix) {
+		dev_err(rvu->dev, "create debugfs dir failed for nix\n");
+		return;
+	}
+
+	pfile = debugfs_create_file("sq_ctx", 0600, rvu->rvu_dbg.nix, rvu,
+				    &rvu_dbg_nix_sq_ctx_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("rq_ctx", 0600, rvu->rvu_dbg.nix, rvu,
+				    &rvu_dbg_nix_rq_ctx_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cq_ctx", 0600, rvu->rvu_dbg.nix, rvu,
+				    &rvu_dbg_nix_cq_ctx_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("qsize", 0600, rvu->rvu_dbg.nix, rvu,
+				    &rvu_dbg_nix_qsize_fops);
+	if (!pfile)
+		goto create_failed;
+
+	return;
+create_failed:
+	dev_err(dev, "Failed to create debugfs dir/file for NIX\n");
+	debugfs_remove_recursive(rvu->rvu_dbg.nix);
+}
+
 static void rvu_dbg_npa_init(struct rvu *rvu)
 {
 	const struct device *dev = &rvu->pdev->dev;
@@ -646,6 +1145,7 @@ void rvu_dbg_init(struct rvu *rvu)
 		goto create_failed;
 
 	rvu_dbg_npa_init(rvu);
+	rvu_dbg_nix_init(rvu);
 
 	return;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index f920dac..92aac44 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -474,9 +474,9 @@ struct nix_cq_ctx_s {
 	u64 ena			: 1;
 	u64 drop_ena		: 1;
 	u64 drop		: 8;
-	u64 dp			: 8;
+	u64 bp			: 8;
 #else
-	u64 dp			: 8;
+	u64 bp			: 8;
 	u64 drop		: 8;
 	u64 drop_ena		: 1;
 	u64 ena			: 1;
-- 
2.7.4

