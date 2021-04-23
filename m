Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A102336974A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243216AbhDWQli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:41:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:13567 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242687AbhDWQlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:41:31 -0400
IronPort-SDR: h2Sohiu+IUieHoIrBxcnr5YfTc3aYzddL7wsHHE1iH6HdOcwUlo/UvCQZ5xBuEEEH6yH3JvIzh
 WweHyJKiCmrg==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="176218641"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="176218641"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 09:40:53 -0700
IronPort-SDR: BoH7gZ9HoYWQ9SEmt4bj4Shz1lbKhXokjbj8RwS9CY3brlvKYmWOlpOWY21okCSOw3ozoD4QFg
 CqTAYYCbqh4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="456285980"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2021 09:40:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 8/8] iavf: redefine the magic number for FDIR GTP-U header fields
Date:   Fri, 23 Apr 2021 09:42:47 -0700
Message-Id: <20210423164247.3252913-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
References: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

The flex-byte for GTP-U protocol header fields uses the magic number,
which is hard to maintain and understand, define the interested fields
with meaningful macro name, based on the GTP-U protocol stack:

GTP-U header
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     | 0x1 |1|0|1|0|0|     0xff      |           Length              |
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     |                           TEID = 1654                         |
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     |    Sequence Number = 0        |N-PDU Number=0 |NextExtHdr=0x85|
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

GTP-U Extension Header (PDU Session Container)
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     |  ExtHdrLen=2  |Type=0 | Spare |0|0|   QFI     | PPI |  Spare  |
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     |                    Padding                    |NextExtHdr=0x0 |
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_fdir.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.c b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
index af872ea3163f..6146203efd84 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_fdir.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
@@ -54,8 +54,13 @@ iavf_fill_fdir_gtpu_hdr(struct iavf_fdir_fltr *fltr,
 #define IAVF_GTPU_HDR_TEID_OFFS0	4
 #define IAVF_GTPU_HDR_TEID_OFFS1	6
 #define IAVF_GTPU_HDR_N_PDU_AND_NEXT_EXTHDR_OFFS	10
+#define IAVF_GTPU_HDR_NEXT_EXTHDR_TYPE_MASK		0x00FF /* skip N_PDU */
+/* PDU Session Container Extension Header (PSC) */
+#define IAVF_GTPU_PSC_EXTHDR_TYPE			0x85
 #define IAVF_GTPU_HDR_PSC_PDU_TYPE_AND_QFI_OFFS		13
-#define IAVF_GTPU_PSC_EXTHDR_TYPE	0x85 /* PDU Session Container Extension Header */
+#define IAVF_GTPU_HDR_PSC_PDU_QFI_MASK			0x3F /* skip Type */
+#define IAVF_GTPU_EH_QFI_IDX				1
+
 		if (fltr->flex_words[i].offset < adj_offs)
 			return -EINVAL;
 
@@ -71,7 +76,9 @@ iavf_fill_fdir_gtpu_hdr(struct iavf_fdir_fltr *fltr,
 			}
 			break;
 		case IAVF_GTPU_HDR_N_PDU_AND_NEXT_EXTHDR_OFFS:
-			if ((fltr->flex_words[i].word & 0xff) != IAVF_GTPU_PSC_EXTHDR_TYPE)
+			if ((fltr->flex_words[i].word &
+			     IAVF_GTPU_HDR_NEXT_EXTHDR_TYPE_MASK) !=
+						IAVF_GTPU_PSC_EXTHDR_TYPE)
 				return -EOPNOTSUPP;
 			if (!ehdr)
 				ehdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
@@ -80,7 +87,9 @@ iavf_fill_fdir_gtpu_hdr(struct iavf_fdir_fltr *fltr,
 		case IAVF_GTPU_HDR_PSC_PDU_TYPE_AND_QFI_OFFS:
 			if (!ehdr)
 				return -EINVAL;
-			ehdr->buffer[1] = fltr->flex_words[i].word & 0x3F;
+			ehdr->buffer[IAVF_GTPU_EH_QFI_IDX] =
+					fltr->flex_words[i].word &
+						IAVF_GTPU_HDR_PSC_PDU_QFI_MASK;
 			VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(ehdr, GTPU_EH, QFI);
 			break;
 		default:
-- 
2.26.2

