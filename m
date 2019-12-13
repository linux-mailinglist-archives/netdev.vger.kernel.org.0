Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B9C11EE24
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfLMXBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:01:42 -0500
Received: from mga04.intel.com ([192.55.52.120]:64701 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbfLMXBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 18:01:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 15:01:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,311,1571727600"; 
   d="scan'208";a="211506680"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.17.224])
  by fmsmga007.fm.intel.com with ESMTP; 13 Dec 2019 15:01:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/11] tcp: Check for filled TCP option space before SACK
Date:   Fri, 13 Dec 2019 15:00:20 -0800
Message-Id: <20191213230022.28144-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191213230022.28144-1-mathew.j.martineau@linux.intel.com>
References: <20191213230022.28144-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SACK code would potentially add four bytes to the expected
TCP option size even if all option space was already used.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/ipv4/tcp_output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9e04d45bc0e4..710ab45badfa 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -748,6 +748,9 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 		size += TCPOLEN_TSTAMP_ALIGNED;
 	}
 
+	if (size + TCPOLEN_SACK_BASE_ALIGNED >= MAX_TCP_OPTION_SPACE)
+		return size;
+
 	eff_sacks = tp->rx_opt.num_sacks + tp->rx_opt.dsack;
 	if (unlikely(eff_sacks)) {
 		const unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
-- 
2.24.1

