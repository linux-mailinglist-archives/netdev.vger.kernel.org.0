Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85844231564
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgG1WMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:2589 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbgG1WMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:19 -0400
IronPort-SDR: /jiMdQ34wsWTwyu0TRaEJFJr1L5TUmfCJ8WmSJ6a6nu34BjpaP0c8D1nHB2eFrDLTQ/ba1U7NI
 RIhEqHVGa51A==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342693"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342693"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:15 -0700
IronPort-SDR: wq0mY1CpY5uPgQ0pdFmwwHq/qW/m58SvewZQv7SUqejRgYbIK9phbo0afYzFkj3Xp4zAsVaGlg
 QmA8K5Q/qZqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468893"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:15 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 10/12] mptcp: Skip unnecessary skb extension allocation for bare acks
Date:   Tue, 28 Jul 2020 15:12:08 -0700
Message-Id: <20200728221210.92841-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bare TCP ack skbs are freed right after MPTCP sees them, so the work to
allocate, zero, and populate the MPTCP skb extension is wasted. Detect
these skbs and do not add skb extensions to them.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index b4458ecd01f8..7fa822b55c34 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -868,15 +868,18 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 	if (mp_opt.use_ack)
 		update_una(msk, &mp_opt);
 
-	/* Zero-length packets, like bare ACKs carrying a DATA_FIN, are
-	 * dropped by the caller and not propagated to the MPTCP layer.
-	 * Copy the DATA_FIN information now.
+	/* Zero-data-length packets are dropped by the caller and not
+	 * propagated to the MPTCP layer, so the skb extension does not
+	 * need to be allocated or populated. DATA_FIN information, if
+	 * present, needs to be updated here before the skb is freed.
 	 */
 	if (TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		if (mp_opt.data_fin && mp_opt.data_len == 1 &&
 		    mptcp_update_rcv_data_fin(msk, mp_opt.data_seq) &&
 		    schedule_work(&msk->work))
 			sock_hold(subflow->conn);
+
+		return;
 	}
 
 	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
-- 
2.28.0

