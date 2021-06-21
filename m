Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412913AF8D9
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhFUW5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:57:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:11255 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232335AbhFUW5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:57:02 -0400
IronPort-SDR: pb4EHOYIn0febxNMA9fvbh/arvtNT86y6R3joCzYtDLy++C9cpYCplulme7V5CvjA8kx0yug4H
 TDzo0A/ixfKg==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="206768520"
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="206768520"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
IronPort-SDR: vh6VkRll+EEvDaoq/BV8IyDWVvvmtWb61/eEhojz5txu0RhzkaOmRCv0wZtERcG7bylqTLRKhK
 rues0IfIp6dg==
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="486673972"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.74.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/6] mptcp: drop redundant test in move_skbs_to_msk()
Date:   Mon, 21 Jun 2021 15:54:36 -0700
Message-Id: <20210621225438.10777-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
References: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently we check the msk state to avoid enqueuing new
skbs at msk shutdown time.

Such test is racy - as we can't acquire the msk socket lock -
and useless, as the caller already checked the subflow
field 'disposable', covering the same scenario in a race
free manner - read and updated under the ssk socket lock.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3e088e9d20fd..cf75be02eb00 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -686,9 +686,6 @@ static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 	struct sock *sk = (struct sock *)msk;
 	unsigned int moved = 0;
 
-	if (inet_sk_state_load(sk) == TCP_CLOSE)
-		return false;
-
 	__mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 	__mptcp_ofo_queue(msk);
 	if (unlikely(ssk->sk_err)) {
-- 
2.32.0

