Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23922174389
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgB1Xr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 18:47:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:3769 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgB1Xr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 18:47:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 15:47:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="351031534"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.18.184])
  by fmsmga001.fm.intel.com with ESMTP; 28 Feb 2020 15:47:56 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/3] mptcp: Only send DATA_FIN with final mapping
Date:   Fri, 28 Feb 2020 15:47:41 -0800
Message-Id: <20200228234741.57086-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200228234741.57086-1-mathew.j.martineau@linux.intel.com>
References: <20200228234741.57086-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a DATA_FIN is sent in a MPTCP DSS option that contains a data
mapping, the DATA_FIN consumes one byte of space in the mapping. In this
case, the DATA_FIN should only be included in the DSS option if its
sequence number aligns with the end of the mapped data. Otherwise the
subflow can send an incorrect implicit sequence number for the DATA_FIN,
and the DATA_ACK for that sequence number would not close the
MPTCP-level connection correctly.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 90c81953ec2c..b9a8305bd934 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -304,21 +304,22 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
 				 struct mptcp_ext *ext)
 {
-	ext->data_fin = 1;
-
 	if (!ext->use_map) {
 		/* RFC6824 requires a DSS mapping with specific values
 		 * if DATA_FIN is set but no data payload is mapped
 		 */
+		ext->data_fin = 1;
 		ext->use_map = 1;
 		ext->dsn64 = 1;
 		ext->data_seq = subflow->data_fin_tx_seq;
 		ext->subflow_seq = 0;
 		ext->data_len = 1;
-	} else {
-		/* If there's an existing DSS mapping, DATA_FIN consumes
-		 * 1 additional byte of mapping space.
+	} else if (ext->data_seq + ext->data_len == subflow->data_fin_tx_seq) {
+		/* If there's an existing DSS mapping and it is the
+		 * final mapping, DATA_FIN consumes 1 additional byte of
+		 * mapping space.
 		 */
+		ext->data_fin = 1;
 		ext->data_len++;
 	}
 }
-- 
2.25.1

