Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EE83AC31A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 08:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhFRGJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 02:09:41 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:57226 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232746AbhFRGJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 02:09:36 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 0D34C398D1;
        Thu, 17 Jun 2021 23:07:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 0D34C398D1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1623996448;
        bh=FXoH3desuYhS0iIpXJChmZk4LTpAH11GBb2wO/bMpic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANP0o+tHNjAa6ISTEObluvd3TEJCr/bHAIzksKF1TTPxYsPcPLYEy5pRkATnD39QH
         HpJEQ3+UrPTLo+0QvU/qjzF5zL3cRzmCJS4iMN1kN9QQ4Ak30HB0GnBysb8xDfaaux
         +p96KvCnlij6nVh/kibXBuQ6N2ShHb931dRijtOk=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 2/3] bnxt_en: Fix TQM fastpath ring backing store computation
Date:   Fri, 18 Jun 2021 02:07:26 -0400
Message-Id: <1623996447-28958-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1623996447-28958-1-git-send-email-michael.chan@broadcom.com>
References: <1623996447-28958-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rukhsana Ansari <rukhsana.ansari@broadcom.com>

TQM fastpath ring needs to be sized to store both the requester
and responder side of RoCE QPs in TQM for supporting bi-directional
tests.  Fix bnxt_alloc_ctx_mem() to multiply the RoCE QPs by a factor of
2 when computing the number of entries for TQM fastpath ring.  This
fixes an RX pipeline stall issue when running bi-directional max
RoCE QP tests.

Fixes: c7dd7ab4b204 ("bnxt_en: Improve TQM ring context memory sizing formulas.")
Signed-off-by: Rukhsana Ansari <rukhsana.ansari@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3685db6dc93d..c913cb1f2a72 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7308,7 +7308,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	entries_sp = ctx->vnic_max_vnic_entries + ctx->qp_max_l2_entries +
 		     2 * (extra_qps + ctx->qp_min_qp1_entries) + min;
 	entries_sp = roundup(entries_sp, ctx->tqm_entries_multiple);
-	entries = ctx->qp_max_l2_entries + extra_qps + ctx->qp_min_qp1_entries;
+	entries = ctx->qp_max_l2_entries + 2 * (extra_qps + ctx->qp_min_qp1_entries);
 	entries = roundup(entries, ctx->tqm_entries_multiple);
 	entries = clamp_t(u32, entries, min, ctx->tqm_max_entries_per_ring);
 	for (i = 0; i < ctx->tqm_fp_rings_count + 1; i++) {
-- 
2.18.1

