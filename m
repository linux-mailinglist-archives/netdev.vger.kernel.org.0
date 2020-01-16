Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2AD313F4AF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389494AbgAPRIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389473AbgAPRIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F4120663;
        Thu, 16 Jan 2020 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194522;
        bh=T+FQIVTKiTyZ3ngH8ZTMP53N4ehYF3Kts2vYdU+aX0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dh9JizSbMXyvL2Nw8F8btack77CszDSjenm+OBdVk38m96Du4a2N20Aa4eC7zoU71
         eIiVGB5odaf6m8m61oSGwdJeNkDKjCjc7pExYpHC8Xr8TKepxkwMfdczuJ7h9wqFip
         HkYrGcwMN1428gWlTLStus0NYdnPtudViItW/XMI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 413/671] qed: iWARP - Use READ_ONCE and smp_store_release to access ep->state
Date:   Thu, 16 Jan 2020 12:00:51 -0500
Message-Id: <20200116170509.12787-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 6117561e1bb30b2fe7f51e1961f34dbedd0bec8a ]

Destroy QP waits for it's ep object state to be set to CLOSED
before proceeding. ep->state can be updated from a different
context. Add smp_store_release/READ_ONCE to synchronize.

Fixes: fc4c6065e661 ("qed: iWARP implement disconnect flows")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 7002a660b6b4..c77babd0ef95 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -532,7 +532,8 @@ int qed_iwarp_destroy_qp(struct qed_hwfn *p_hwfn, struct qed_rdma_qp *qp)
 
 	/* Make sure ep is closed before returning and freeing memory. */
 	if (ep) {
-		while (ep->state != QED_IWARP_EP_CLOSED && wait_count++ < 200)
+		while (READ_ONCE(ep->state) != QED_IWARP_EP_CLOSED &&
+		       wait_count++ < 200)
 			msleep(100);
 
 		if (ep->state != QED_IWARP_EP_CLOSED)
@@ -1023,8 +1024,6 @@ qed_iwarp_mpa_complete(struct qed_hwfn *p_hwfn,
 
 	params.ep_context = ep;
 
-	ep->state = QED_IWARP_EP_CLOSED;
-
 	switch (fw_return_code) {
 	case RDMA_RETURN_OK:
 		ep->qp->max_rd_atomic_req = ep->cm_info.ord;
@@ -1084,6 +1083,10 @@ qed_iwarp_mpa_complete(struct qed_hwfn *p_hwfn,
 		break;
 	}
 
+	if (fw_return_code != RDMA_RETURN_OK)
+		/* paired with READ_ONCE in destroy_qp */
+		smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
+
 	ep->event_cb(ep->cb_context, &params);
 
 	/* on passive side, if there is no associated QP (REJECT) we need to
@@ -2828,7 +2831,9 @@ static void qed_iwarp_qp_in_error(struct qed_hwfn *p_hwfn,
 	params.status = (fw_return_code == IWARP_QP_IN_ERROR_GOOD_CLOSE) ?
 			 0 : -ECONNRESET;
 
-	ep->state = QED_IWARP_EP_CLOSED;
+	/* paired with READ_ONCE in destroy_qp */
+	smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
+
 	spin_lock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
 	list_del(&ep->list_entry);
 	spin_unlock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
@@ -2917,7 +2922,8 @@ qed_iwarp_tcp_connect_unsuccessful(struct qed_hwfn *p_hwfn,
 	params.event = QED_IWARP_EVENT_ACTIVE_COMPLETE;
 	params.ep_context = ep;
 	params.cm_info = &ep->cm_info;
-	ep->state = QED_IWARP_EP_CLOSED;
+	/* paired with READ_ONCE in destroy_qp */
+	smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
 
 	switch (fw_return_code) {
 	case IWARP_CONN_ERROR_TCP_CONNECT_INVALID_PACKET:
-- 
2.20.1

