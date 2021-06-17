Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41273ABFB6
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbhFQXsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:13476 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233071AbhFQXsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:40 -0400
IronPort-SDR: G7lKzUUoBsvjXiaL9kODHSXJG3dojVz4+BkO+b/0sUCznXq0OnofpYl5PzT5hDiU+/ERiU7KxB
 LWG7wB4Ncm1g==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506650"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506650"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:32 -0700
IronPort-SDR: KlxJrevPLV+q0b1r5Gsssow9BhAiWPykfAJ6Ll+Hn3GgPGf8XT4qCaq0/xXU9KZqe9c7JOhFHR
 MN8YTFketEQQ==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943912"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:31 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/16] mptcp: receive checksum for DSS
Date:   Thu, 17 Jun 2021 16:46:15 -0700
Message-Id: <20210617234622.472030-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

In mptcp_parse_option, adjust the expected_opsize, and always parse the
data checksum value from the receiving DSS regardless of csum presence.
Then save it in mp_opt->csum.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 8cbc75868969..1aec01686c1a 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -182,10 +182,8 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 				expected_opsize += TCPOLEN_MPTCP_DSS_MAP32;
 		}
 
-		/* RFC 6824, Section 3.3:
-		 * If a checksum is present, but its use had
-		 * not been negotiated in the MP_CAPABLE handshake,
-		 * the checksum field MUST be ignored.
+		/* Always parse any csum presence combination, we will enforce
+		 * RFC 8684 Section 3.3.0 checks later in subflow_data_ready
 		 */
 		if (opsize != expected_opsize &&
 		    opsize != expected_opsize + TCPOLEN_MPTCP_DSS_CHECKSUM)
@@ -220,9 +218,15 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			mp_opt->data_len = get_unaligned_be16(ptr);
 			ptr += 2;
 
-			pr_debug("data_seq=%llu subflow_seq=%u data_len=%u",
+			if (opsize == expected_opsize + TCPOLEN_MPTCP_DSS_CHECKSUM) {
+				mp_opt->csum_reqd = 1;
+				mp_opt->csum = (__force __sum16)get_unaligned_be16(ptr);
+				ptr += 2;
+			}
+
+			pr_debug("data_seq=%llu subflow_seq=%u data_len=%u csum=%d:%u",
 				 mp_opt->data_seq, mp_opt->subflow_seq,
-				 mp_opt->data_len);
+				 mp_opt->data_len, mp_opt->csum_reqd, mp_opt->csum);
 		}
 
 		break;
-- 
2.32.0

