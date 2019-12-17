Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851C9121FAC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfLQAY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:24:58 -0500
Received: from mga07.intel.com ([134.134.136.100]:21147 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfLQAY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 19:24:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 16:24:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="217599728"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2019 16:24:58 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v2 02/11] sock: Make sk_protocol a 16-bit value
Date:   Mon, 16 Dec 2019 16:24:46 -0800
Message-Id: <20191217002455.24849-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217002455.24849-1-mathew.j.martineau@linux.intel.com>
References: <20191217002455.24849-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Match the 16-bit width of skbuff->protocol. Fills an 8-bit hole so
sizeof(struct sock) does not change.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---

Changes for v2:

Moved sk_pacing_shift back to a regular struct member, adjacent to the
bitfield. gcc then packs the bitfield and the u8 in a single 32-bit word.


 include/net/sock.h          | 4 ++--
 include/trace/events/sock.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 81dc811aad2e..0930f46c600c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -456,10 +456,10 @@ struct sock {
 				sk_no_check_tx : 1,
 				sk_no_check_rx : 1,
 				sk_userlocks : 4,
-				sk_protocol  : 8,
 				sk_type      : 16;
-	u16			sk_gso_max_segs;
 	u8			sk_pacing_shift;
+	u16			sk_protocol;
+	u16			sk_gso_max_segs;
 	unsigned long	        sk_lingertime;
 	struct proto		*sk_prot_creator;
 	rwlock_t		sk_callback_lock;
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 51fe9f6719eb..3ff12b90048d 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -147,7 +147,7 @@ TRACE_EVENT(inet_sock_set_state,
 		__field(__u16, sport)
 		__field(__u16, dport)
 		__field(__u16, family)
-		__field(__u8, protocol)
+		__field(__u16, protocol)
 		__array(__u8, saddr, 4)
 		__array(__u8, daddr, 4)
 		__array(__u8, saddr_v6, 16)
-- 
2.24.1

