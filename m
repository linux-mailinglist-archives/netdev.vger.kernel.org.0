Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F50231562
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgG1WMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:2588 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729793AbgG1WMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:18 -0400
IronPort-SDR: Zrtn4HmCjwGeqeAgriytD/Mi/eJ0ZD9hLWkT4LV/ZsrjJ6nTxLLlZYB/L5PDZE0aW0jqZNVD+/
 VdsOVKAhWk7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342692"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342692"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:15 -0700
IronPort-SDR: hQfVOwOl5SN0nDtdGDveOHoLxpASj0QYoNm3gjVZGsLOUnKcYCrGv8CoYDdMu7DEOtC35dqkBP
 8qf5TFokROsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468892"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:15 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 09/12] mptcp: Only use subflow EOF signaling on fallback connections
Date:   Tue, 28 Jul 2020 15:12:07 -0700
Message-Id: <20200728221210.92841-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP state machine handles disconnections on non-fallback connections,
but the mptcp_sock still needs to get notified when fallback subflows
disconnect.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 7ab2a52ad150..1c8482bc2ce5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1159,7 +1159,8 @@ static void subflow_state_change(struct sock *sk)
 	if (mptcp_subflow_data_available(sk))
 		mptcp_data_ready(parent, sk);
 
-	if (!(parent->sk_shutdown & RCV_SHUTDOWN) &&
+	if (__mptcp_check_fallback(mptcp_sk(parent)) &&
+	    !(parent->sk_shutdown & RCV_SHUTDOWN) &&
 	    !subflow->rx_eof && subflow_is_done(sk)) {
 		subflow->rx_eof = 1;
 		mptcp_subflow_eof(parent);
-- 
2.28.0

