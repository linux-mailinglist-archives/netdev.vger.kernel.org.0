Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E679430BBA7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 11:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBBKAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 05:00:47 -0500
Received: from goliath.siemens.de ([192.35.17.28]:55171 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhBBKAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 05:00:43 -0500
X-Greylist: delayed 3382 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 05:00:42 EST
Received: from mail2.siemens.de (mail2.siemens.de [139.25.208.11])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 11293VAn025591
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Feb 2021 10:03:31 +0100
Received: from md2k7s8c.ad001.siemens.net ([10.220.72.69])
        by mail2.siemens.de (8.15.2/8.15.2) with ESMTP id 11293UBe011169;
        Tue, 2 Feb 2021 10:03:31 +0100
From:   Andreas Oetken <ennoerlangen@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andreas Oetken <ennoerlangen@gmail.com>,
        Andreas Oetken <andreas.oetken@siemens.com>
Subject: [PATCH v1] net: hsr: align sup_multicast_addr in struct hsr_priv to u16 boundary
Date:   Tue,  2 Feb 2021 10:03:04 +0100
Message-Id: <20210202090304.2740471-1-ennoerlangen@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Oetken <andreas.oetken@siemens.com>

sup_multicast_addr is passed to ether_addr_equal for address comparison
which casts the address inputs to u16 leading to an unaligned access.
Aligning the sup_multicast_addr to u16 boundary fixes the issue.

Signed-off-by: Andreas Oetken <andreas.oetken@siemens.com>
---
 net/hsr/hsr_main.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 7dc92ce5a134..a9c30a608e35 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -217,7 +217,10 @@ struct hsr_priv {
 	u8 net_id;		/* for PRP, it occupies most significant 3 bits
 				 * of lan_id
 				 */
-	unsigned char		sup_multicast_addr[ETH_ALEN];
+	unsigned char		sup_multicast_addr[ETH_ALEN] __aligned(sizeof(u16));
+				/* Align to u16 boundary to avoid unaligned access
+				 * in ether_addr_equal
+				 */
 #ifdef	CONFIG_DEBUG_FS
 	struct dentry *node_tbl_root;
 #endif
-- 
2.30.0

