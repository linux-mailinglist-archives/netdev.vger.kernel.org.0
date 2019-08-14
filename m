Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AC68C581
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 03:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfHNBTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 21:19:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:45614 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbfHNBTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 21:19:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 18:19:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,382,1559545200"; 
   d="scan'208";a="170575833"
Received: from tsduncan-ubuntu.jf.intel.com ([10.7.169.130])
  by orsmga008.jf.intel.com with ESMTP; 13 Aug 2019 18:19:07 -0700
From:   "Terry S. Duncan" <terry.s.duncan@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
        William Kennington <wak@google.com>,
        Joel Stanley <joel@jms.id.au>
Cc:     "Terry S. Duncan" <terry.s.duncan@linux.intel.com>
Subject: [PATCH] net/ncsi: Ensure 32-bit boundary for data cksum
Date:   Tue, 13 Aug 2019 18:18:40 -0700
Message-Id: <20190814011840.9387-1-terry.s.duncan@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NCSI spec indicates that if the data does not end on a 32 bit
boundary, one to three padding bytes equal to 0x00 shall be present to
align the checksum field to a 32-bit boundary.

Signed-off-by: Terry S. Duncan <terry.s.duncan@linux.intel.com>
---
 net/ncsi/internal.h |  1 +
 net/ncsi/ncsi-cmd.c |  2 +-
 net/ncsi/ncsi-rsp.c | 12 ++++++++----
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 0b3f0673e1a2..468a19fdfd88 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -185,6 +185,7 @@ struct ncsi_package;
 #define NCSI_TO_CHANNEL(p, c)	(((p) << NCSI_PACKAGE_SHIFT) | (c))
 #define NCSI_MAX_PACKAGE	8
 #define NCSI_MAX_CHANNEL	32
+#define NCSI_ROUND32(x)		(((x) + 3) & ~3) /* Round to 32 bit boundary */
 
 struct ncsi_channel {
 	unsigned char               id;
diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index 5c3fad8cba57..c12f2183b460 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -54,7 +54,7 @@ static void ncsi_cmd_build_header(struct ncsi_pkt_hdr *h,
 	checksum = ncsi_calculate_checksum((unsigned char *)h,
 					   sizeof(*h) + nca->payload);
 	pchecksum = (__be32 *)((void *)h + sizeof(struct ncsi_pkt_hdr) +
-		    nca->payload);
+		    NCSI_ROUND32(nca->payload));
 	*pchecksum = htonl(checksum);
 }
 
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 7581bf919885..10a142d0422f 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -47,7 +47,8 @@ static int ncsi_validate_rsp_pkt(struct ncsi_request *nr,
 	if (ntohs(h->code) != NCSI_PKT_RSP_C_COMPLETED ||
 	    ntohs(h->reason) != NCSI_PKT_RSP_R_NO_ERROR) {
 		netdev_dbg(nr->ndp->ndev.dev,
-			   "NCSI: non zero response/reason code\n");
+			   "NCSI: non zero response/reason code %04xh, %04xh\n",
+			    ntohs(h->code), ntohs(h->reason));
 		return -EPERM;
 	}
 
@@ -55,15 +56,18 @@ static int ncsi_validate_rsp_pkt(struct ncsi_request *nr,
 	 * sender doesn't support checksum according to NCSI
 	 * specification.
 	 */
-	pchecksum = (__be32 *)((void *)(h + 1) + payload - 4);
+	pchecksum = (__be32 *)((void *)(h + 1) + NCSI_ROUND32(payload) - 4);
 	if (ntohl(*pchecksum) == 0)
 		return 0;
 
 	checksum = ncsi_calculate_checksum((unsigned char *)h,
-					   sizeof(*h) + payload - 4);
+					   sizeof(*h) +
+					       NCSI_ROUND32(payload) - 4);
 
 	if (*pchecksum != htonl(checksum)) {
-		netdev_dbg(nr->ndp->ndev.dev, "NCSI: checksum mismatched\n");
+		netdev_dbg(nr->ndp->ndev.dev,
+			   "NCSI: checksum mismatched; recd: %08x calc: %08x\n",
+			   *pchecksum, htonl(checksum));
 		return -EINVAL;
 	}
 
-- 
2.17.1

