Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D168952B9
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfHTAZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:25:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:2132 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728698AbfHTAZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 20:25:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 17:25:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,406,1559545200"; 
   d="scan'208";a="189691872"
Received: from tsduncan-ubuntu.jf.intel.com ([10.7.169.130])
  by orsmga002.jf.intel.com with ESMTP; 19 Aug 2019 17:25:00 -0700
From:   "Terry S. Duncan" <terry.s.duncan@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     openbmc@lists.ozlabs.org, William Kennington <wak@google.com>,
        Joel Stanley <joel@jms.id.au>,
        "Terry S. Duncan" <terry.s.duncan@linux.intel.com>
Subject: [PATCH v2] net/ncsi: Ensure 32-bit boundary for data cksum
Date:   Mon, 19 Aug 2019 17:24:02 -0700
Message-Id: <20190820002402.39001-1-terry.s.duncan@linux.intel.com>
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
 net/ncsi/ncsi-cmd.c | 2 +-
 net/ncsi/ncsi-rsp.c | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index 5c3fad8cba57..eab4346b0a39 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -54,7 +54,7 @@ static void ncsi_cmd_build_header(struct ncsi_pkt_hdr *h,
 	checksum = ncsi_calculate_checksum((unsigned char *)h,
 					   sizeof(*h) + nca->payload);
 	pchecksum = (__be32 *)((void *)h + sizeof(struct ncsi_pkt_hdr) +
-		    nca->payload);
+		    ALIGN(nca->payload, 4));
 	*pchecksum = htonl(checksum);
 }
 
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 7581bf919885..d876bd55f356 100644
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
 
@@ -55,7 +56,7 @@ static int ncsi_validate_rsp_pkt(struct ncsi_request *nr,
 	 * sender doesn't support checksum according to NCSI
 	 * specification.
 	 */
-	pchecksum = (__be32 *)((void *)(h + 1) + payload - 4);
+	pchecksum = (__be32 *)((void *)(h + 1) + ALIGN(payload, 4) - 4);
 	if (ntohl(*pchecksum) == 0)
 		return 0;
 
@@ -63,7 +64,9 @@ static int ncsi_validate_rsp_pkt(struct ncsi_request *nr,
 					   sizeof(*h) + payload - 4);
 
 	if (*pchecksum != htonl(checksum)) {
-		netdev_dbg(nr->ndp->ndev.dev, "NCSI: checksum mismatched\n");
+		netdev_dbg(nr->ndp->ndev.dev,
+			   "NCSI: checksum mismatched; recd: %08x calc: %08x\n",
+			   *pchecksum, htonl(checksum));
 		return -EINVAL;
 	}
 
-- 
2.17.1

