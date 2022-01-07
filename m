Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADEE487CF8
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 20:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiAGTZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 14:25:54 -0500
Received: from mga04.intel.com ([192.55.52.120]:42367 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbiAGTZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 14:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641583554; x=1673119554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YKzjUf+5IIZ8MDyCvXc+81rmE6lK1eAM7jrYT8awB10=;
  b=PHoENAuESq6jkhA5967MO9N/7jXFXsaTvvTNv7vT1iB+8V7ay9yGmk7t
   VHCIX9Lz2PEvdt2J++ZtSxnhxPYomjwohLdU0DH2l5vxNttwqWgdE31Dj
   zabzEno5Mm+iTMOtKLiUvDGJX1Kjn+Vhv334e78R1WWCdncI0HRj20vgE
   FhGzaUl+dArtU6g8fOaL3sfljpngSiz4JNIKBRfvu/1dMKOkcL51Z4NLz
   Zz2/WMugYUTVDZCTJMjmj7u7ND8LNQqz/EZ2ALBrt0wZ6UwarLPHmN8Fy
   qba20NiKJBZAXIjQcc13iDc9jwav/z9q8PKcowk4xXWygMX5AKJlcyPUL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="241742148"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="241742148"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 11:25:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="527478588"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.36.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 11:25:53 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/3] mptcp: change the parameter of __mptcp_make_csum
Date:   Fri,  7 Jan 2022 11:25:23 -0800
Message-Id: <20220107192524.445137-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107192524.445137-1-mathew.j.martineau@linux.intel.com>
References: <20220107192524.445137-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch changed the type of the last parameter of __mptcp_make_csum()
from __sum16 to __wsum. And export this function in protocol.h.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 8 ++++----
 net/mptcp/protocol.h | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 38e34a1fb2dd..8ed2d9f4a84d 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1233,7 +1233,7 @@ static void mptcp_set_rwin(const struct tcp_sock *tp)
 		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
 }
 
-static u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __sum16 sum)
+u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum)
 {
 	struct csum_pseudo_header header;
 	__wsum csum;
@@ -1248,14 +1248,14 @@ static u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __sum1
 	header.data_len = htons(data_len);
 	header.csum = 0;
 
-	csum = csum_partial(&header, sizeof(header), ~csum_unfold(sum));
+	csum = csum_partial(&header, sizeof(header), sum);
 	return (__force u16)csum_fold(csum);
 }
 
 static u16 mptcp_make_csum(const struct mptcp_ext *mpext)
 {
 	return __mptcp_make_csum(mpext->data_seq, mpext->subflow_seq, mpext->data_len,
-				 mpext->csum);
+				 ~csum_unfold(mpext->csum));
 }
 
 void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
@@ -1376,7 +1376,7 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 					   __mptcp_make_csum(opts->data_seq,
 							     opts->subflow_seq,
 							     opts->data_len,
-							     opts->csum), ptr);
+							     ~csum_unfold(opts->csum)), ptr);
 		} else {
 			put_unaligned_be32(opts->data_len << 16 |
 					   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a77f512d5ad7..0e6b42c76ea0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -725,6 +725,7 @@ void mptcp_token_destroy(struct mptcp_sock *msk);
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
 
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
+u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum);
 
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
-- 
2.34.1

