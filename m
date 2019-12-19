Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117A61270C9
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfLSWfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:35:19 -0500
Received: from mga04.intel.com ([192.55.52.120]:29335 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbfLSWe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 17:34:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 14:34:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,333,1571727600"; 
   d="scan'208";a="248484458"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.1.107])
  by fmsmga002.fm.intel.com with ESMTP; 19 Dec 2019 14:34:57 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next v5 02/11] sock: Make sk_protocol a 16-bit value
Date:   Thu, 19 Dec 2019 14:34:25 -0800
Message-Id: <20191219223434.19722-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Match the 16-bit width of skbuff->protocol. Fills an 8-bit hole so
sizeof(struct sock) does not change.

v2 -> v3:
 - keep 'sk_type' 2 bytes aligned (Eric)
v1 -> v2:
 - preserve sk_pacing_shift as bit field (Eric)

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/sock.h          | 10 +++++-----
 include/trace/events/sock.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 81dc811aad2e..b93cadba1a3b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -451,15 +451,15 @@ struct sock {
 #define SK_FL_TYPE_MASK    0xffff0000
 #endif
 
-	unsigned int		sk_padding : 1,
+	u8			sk_padding : 1,
 				sk_kern_sock : 1,
 				sk_no_check_tx : 1,
 				sk_no_check_rx : 1,
-				sk_userlocks : 4,
-				sk_protocol  : 8,
-				sk_type      : 16;
-	u16			sk_gso_max_segs;
+				sk_userlocks : 4;
 	u8			sk_pacing_shift;
+	u16			sk_type;
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

