Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EC1231569
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbgG1WMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:2589 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729803AbgG1WMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:19 -0400
IronPort-SDR: k4U9Fc9eHJRR4tObEbc7t3ajdMvShqozXqBzytrHci9aloHMvfVRq9qrokKuVUMBHpaQpxindX
 3elGI+Rtz5tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342697"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342697"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:16 -0700
IronPort-SDR: TpyjGIMfIRPaU/Bn42UCdEMrhbGOToSoN2WmTfSjDQrSaQFcZgadxU+V+IiZe6Vz9N4s8fqLYB
 pDTOs+OGCr0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468899"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:16 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 12/12] mptcp: Safely store sequence number when sending data
Date:   Tue, 28 Jul 2020 15:12:10 -0700
Message-Id: <20200728221210.92841-13-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP socket's write_seq member can be read without the msk lock
held, so use WRITE_ONCE() to store it.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f2455a68d231..687f0bea2b35 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -793,7 +793,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 out:
 	if (!retransmission)
 		pfrag->offset += frag_truesize;
-	*write_seq += ret;
+	WRITE_ONCE(*write_seq, *write_seq + ret);
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
 	return ret;
-- 
2.28.0

