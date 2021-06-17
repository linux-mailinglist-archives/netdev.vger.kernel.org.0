Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6315B3ABFB2
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhFQXsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:13470 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232969AbhFQXsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:38 -0400
IronPort-SDR: eW4hBDBn0cFPBdpNPVHv8QfIg3TivLmCMwh5+Bz3Cq1C+97Sf62OfcOEK9npx10g0cnBUVfQvv
 DMm2zodQWsFA==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506634"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506634"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:29 -0700
IronPort-SDR: vlixTUoHSeA+MutS2Tdq+wLDAqn0NRVHX2gwBOeezMPYfzYXr/TXVFYbNCB031fLBRvNjX/cAj
 49CigskX0nEw==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943901"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/16] mptcp: send out checksum for MP_CAPABLE with data
Date:   Thu, 17 Jun 2021 16:46:10 -0700
Message-Id: <20210617234622.472030-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

If the checksum is enabled, send out the data checksum with the
MP_CAPABLE suboption with data.

In mptcp_established_options_mp, save the data checksum in
opts->ext_copy.csum. In mptcp_write_options, adjust the option length and
send it out with the MP_CAPABLE suboption.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 52 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index bb3a1f3b6e99..b4da08db1221 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -439,6 +439,7 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	struct mptcp_ext *mpext;
 	unsigned int data_len;
+	u8 len;
 
 	/* When skb is not available, we better over-estimate the emitted
 	 * options len. A full DSS option (28 bytes) is longer than
@@ -474,10 +475,16 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 		 * packets that start the first subflow of an MPTCP connection,
 		 * as well as the first packet that carries data
 		 */
-		if (data_len > 0)
-			*size = ALIGN(TCPOLEN_MPTCP_MPC_ACK_DATA, 4);
-		else
+		if (data_len > 0) {
+			len = TCPOLEN_MPTCP_MPC_ACK_DATA;
+			if (opts->csum_reqd) {
+				opts->ext_copy.csum = mpext->csum;
+				len += TCPOLEN_MPTCP_DSS_CHECKSUM;
+			}
+			*size = ALIGN(len, 4);
+		} else {
 			*size = TCPOLEN_MPTCP_MPC_ACK;
+		}
 
 		pr_debug("subflow=%p, local_key=%llu, remote_key=%llu map_len=%d",
 			 subflow, subflow->local_key, subflow->remote_key,
@@ -1122,6 +1129,25 @@ static void mptcp_set_rwin(const struct tcp_sock *tp)
 		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
 }
 
+static u16 mptcp_make_csum(const struct mptcp_ext *mpext)
+{
+	struct csum_pseudo_header header;
+	__wsum csum;
+
+	/* cfr RFC 8684 3.3.1.:
+	 * the data sequence number used in the pseudo-header is
+	 * always the 64-bit value, irrespective of what length is used in the
+	 * DSS option itself.
+	 */
+	header.data_seq = cpu_to_be64(mpext->data_seq);
+	header.subflow_seq = htonl(mpext->subflow_seq);
+	header.data_len = htons(mpext->data_len);
+	header.csum = 0;
+
+	csum = csum_partial(&header, sizeof(header), ~csum_unfold(mpext->csum));
+	return (__force u16)csum_fold(csum);
+}
+
 void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			 struct mptcp_out_options *opts)
 {
@@ -1129,14 +1155,17 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 	     OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
 		u8 len, flag = MPTCP_CAP_HMAC_SHA256;
 
-		if (OPTION_MPTCP_MPC_SYN & opts->suboptions)
+		if (OPTION_MPTCP_MPC_SYN & opts->suboptions) {
 			len = TCPOLEN_MPTCP_MPC_SYN;
-		else if (OPTION_MPTCP_MPC_SYNACK & opts->suboptions)
+		} else if (OPTION_MPTCP_MPC_SYNACK & opts->suboptions) {
 			len = TCPOLEN_MPTCP_MPC_SYNACK;
-		else if (opts->ext_copy.data_len)
+		} else if (opts->ext_copy.data_len) {
 			len = TCPOLEN_MPTCP_MPC_ACK_DATA;
-		else
+			if (opts->csum_reqd)
+				len += TCPOLEN_MPTCP_DSS_CHECKSUM;
+		} else {
 			len = TCPOLEN_MPTCP_MPC_ACK;
+		}
 
 		if (opts->csum_reqd)
 			flag |= MPTCP_CAP_CHECKSUM_REQD;
@@ -1159,8 +1188,13 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 		if (!opts->ext_copy.data_len)
 			goto mp_capable_done;
 
-		put_unaligned_be32(opts->ext_copy.data_len << 16 |
-				   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
+		if (opts->csum_reqd) {
+			put_unaligned_be32(opts->ext_copy.data_len << 16 |
+					   mptcp_make_csum(&opts->ext_copy), ptr);
+		} else {
+			put_unaligned_be32(opts->ext_copy.data_len << 16 |
+					   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
+		}
 		ptr += 1;
 	}
 
-- 
2.32.0

