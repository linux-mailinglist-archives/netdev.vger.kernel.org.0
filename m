Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175B13ABFB1
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhFQXsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:13468 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232984AbhFQXsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:38 -0400
IronPort-SDR: ed977i3tz8TM5eQjOxqDCdcHWRbVHedz/xYZj93J9PQuYGFqWucnZggnZMVY89fB6ngc9CPZZX
 YQQrZxS3sSYA==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506636"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506636"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:30 -0700
IronPort-SDR: RPBjxGjTz3vK5dhvOBymE2RBQNiC2RQhj0Hlm2qJguuyxTb1XVNs4DCkUPbgCukCp1GrYOwUfy
 nelzXAFJ737Q==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943903"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/16] mptcp: send out checksum for DSS
Date:   Thu, 17 Jun 2021 16:46:11 -0700
Message-Id: <20210617234622.472030-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

In mptcp_write_options, if the checksum is enabled, adjust the option
length and send out the data checksum with DSS suboption.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index b4da08db1221..1468774f1f87 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -478,6 +478,9 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 		if (data_len > 0) {
 			len = TCPOLEN_MPTCP_MPC_ACK_DATA;
 			if (opts->csum_reqd) {
+				/* we need to propagate more info to csum the pseudo hdr */
+				opts->ext_copy.data_seq = mpext->data_seq;
+				opts->ext_copy.subflow_seq = mpext->subflow_seq;
 				opts->ext_copy.csum = mpext->csum;
 				len += TCPOLEN_MPTCP_DSS_CHECKSUM;
 			}
@@ -545,18 +548,21 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	bool ret = false;
 	u64 ack_seq;
 
+	opts->csum_reqd = READ_ONCE(msk->csum_enabled);
 	mpext = skb ? mptcp_get_ext(skb) : NULL;
 
 	if (!skb || (mpext && mpext->use_map) || snd_data_fin_enable) {
-		unsigned int map_size;
+		unsigned int map_size = TCPOLEN_MPTCP_DSS_BASE + TCPOLEN_MPTCP_DSS_MAP64;
 
-		map_size = TCPOLEN_MPTCP_DSS_BASE + TCPOLEN_MPTCP_DSS_MAP64;
+		if (mpext) {
+			if (opts->csum_reqd)
+				map_size += TCPOLEN_MPTCP_DSS_CHECKSUM;
 
-		remaining -= map_size;
-		dss_size = map_size;
-		if (mpext)
 			opts->ext_copy = *mpext;
+		}
 
+		remaining -= map_size;
+		dss_size = map_size;
 		if (skb && snd_data_fin_enable)
 			mptcp_write_data_fin(subflow, skb, &opts->ext_copy);
 		ret = true;
@@ -1346,6 +1352,9 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			flags |= MPTCP_DSS_HAS_MAP | MPTCP_DSS_DSN64;
 			if (mpext->data_fin)
 				flags |= MPTCP_DSS_DATA_FIN;
+
+			if (opts->csum_reqd)
+				len += TCPOLEN_MPTCP_DSS_CHECKSUM;
 		}
 
 		*ptr++ = mptcp_option(MPTCPOPT_DSS, len, 0, flags);
@@ -1365,8 +1374,13 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			ptr += 2;
 			put_unaligned_be32(mpext->subflow_seq, ptr);
 			ptr += 1;
-			put_unaligned_be32(mpext->data_len << 16 |
-					   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
+			if (opts->csum_reqd) {
+				put_unaligned_be32(mpext->data_len << 16 |
+						   mptcp_make_csum(mpext), ptr);
+			} else {
+				put_unaligned_be32(mpext->data_len << 16 |
+						   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
+			}
 		}
 	}
 
-- 
2.32.0

