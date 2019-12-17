Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D26121FA4
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfLQAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:25:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:21147 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbfLQAZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 19:25:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 16:24:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="217599736"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2019 16:24:58 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v2 09/11] tcp: Check for filled TCP option space before SACK
Date:   Mon, 16 Dec 2019 16:24:53 -0800
Message-Id: <20191217002455.24849-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217002455.24849-1-mathew.j.martineau@linux.intel.com>
References: <20191217002455.24849-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the SACK check to work with zero option space available, a case
that's possible with MPTCP but not MD5+TS. Maintained only one
conditional branch for insufficient SACK space.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---

Changes for v2:

Takes recent SACK fix (9424e2e7ad93ffff) in to account, but modifies it
to work in MPTCP scenarios beyond the MD5+TS corner case. Given the
discussion on the v1 patch, we are including this in the patch set
again but can drop it and respin for -net if it qualifies as a bug fix.


 net/ipv4/tcp_output.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9e04d45bc0e4..e797ca6c6d7d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -751,13 +751,17 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 	eff_sacks = tp->rx_opt.num_sacks + tp->rx_opt.dsack;
 	if (unlikely(eff_sacks)) {
 		const unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
+		if (unlikely(remaining < TCPOLEN_SACK_BASE_ALIGNED +
+					 TCPOLEN_SACK_PERBLOCK))
+			return size;
+
 		opts->num_sack_blocks =
 			min_t(unsigned int, eff_sacks,
 			      (remaining - TCPOLEN_SACK_BASE_ALIGNED) /
 			      TCPOLEN_SACK_PERBLOCK);
-		if (likely(opts->num_sack_blocks))
-			size += TCPOLEN_SACK_BASE_ALIGNED +
-				opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
+
+		size += TCPOLEN_SACK_BASE_ALIGNED +
+			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
 	}
 
 	return size;
-- 
2.24.1

