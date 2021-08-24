Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648093F6AA9
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 22:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhHXUwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 16:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231411AbhHXUwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 16:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5AB0611C9;
        Tue, 24 Aug 2021 20:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629838279;
        bh=T7jeklW73WtmhJ1+zmiWNQDRR5pBH/HBxRpffRugi/M=;
        h=From:To:Cc:Subject:Date:From;
        b=CB5fwzQA6I8chW6tqlPAkiHwVud7c0gISHsRyWExvDnFVHfnLo0P3FZjaUEQeUhiB
         JR3Y7ifK+h+YYqb3xK348QaIW2hY921IbYTBCYJSaNpS8Wg5XA/JmWdQ0EHeN/hRWo
         M6VlJq3tXcuC9KaDhNb92tvBHKb9Hv6Bn95TKFJKK3tubaiRV/CmP2IuhbO/Sv9YIQ
         shz2iuw8ddR33kEvhn3XfqtLQjGxPsalwjyeFkAq4BPvfcCoTh5Y0IY/hzm4wyaWBA
         C2xXoXDlREj5sPw8FP6v0vgrFHlSB3SUS1GvplsIl5Z214yoFeTvOt6AcBijQsVLke
         W8vNUAFvi4ooA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] cxgb4: Properly revert VPD changes
Date:   Tue, 24 Aug 2021 13:51:04 -0700
Message-Id: <20210824205104.2778110-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2785:2: error: variable 'kw_offset' is uninitialized when used here [-Werror,-Wuninitialized]
        FIND_VPD_KW(i, "RV");
        ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2776:39: note: expanded from macro 'FIND_VPD_KW'
        var = pci_vpd_find_info_keyword(vpd, kw_offset, vpdr_len, name); \
                                             ^~~~~~~~~
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2748:34: note: initialize the variable 'kw_offset' to silence this warning
        unsigned int vpdr_len, kw_offset, id_len;
                                        ^
                                         = 0
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2785:2: error: variable 'vpdr_len' is uninitialized when used here [-Werror,-Wuninitialized]
        FIND_VPD_KW(i, "RV");
        ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2776:50: note: expanded from macro 'FIND_VPD_KW'
        var = pci_vpd_find_info_keyword(vpd, kw_offset, vpdr_len, name); \
                                                        ^~~~~~~~
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2748:23: note: initialize the variable 'vpdr_len' to silence this warning
        unsigned int vpdr_len, kw_offset, id_len;
                             ^
                              = 0
2 errors generated.

The series "PCI/VPD: Convert more users to the new VPD API functions"
was applied to net-next when it should have been applied to the PCI tree
because of build errors. However, commit 82e34c8a9bdf ("Revert "Revert
"cxgb4: Search VPD with pci_vpd_find_ro_info_keyword()""") reapplied a
change, resulting in the warning above.

Properly revert commit 8d63ee602da3 ("cxgb4: Search VPD with
pci_vpd_find_ro_info_keyword()") to fix the warning and restore proper
functionality. This also reverts commit 3a93bedea050 ("cxgb4: Remove
unused vpd_param member ec") to avoid future merge conflicts, as that
change has been applied to the PCI tree.

Link: https://lore.kernel.org/r/20210823120929.7c6f7a4f@canb.auug.org.au/
Link: https://lore.kernel.org/r/1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h |  2 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 44 +++++++++++++++++++---
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index ecea3cdd30b3..9058f09f921e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -84,6 +84,7 @@ extern struct mutex uld_mutex;
 enum {
 	MAX_NPORTS	= 4,     /* max # of ports */
 	SERNUM_LEN	= 24,    /* Serial # length */
+	EC_LEN		= 16,    /* E/C length */
 	ID_LEN		= 16,    /* ID length */
 	PN_LEN		= 16,    /* Part Number length */
 	MACADDR_LEN	= 12,    /* MAC Address length */
@@ -390,6 +391,7 @@ struct tp_params {
 
 struct vpd_params {
 	unsigned int cclk;
+	u8 ec[EC_LEN + 1];
 	u8 sn[SERNUM_LEN + 1];
 	u8 id[ID_LEN + 1];
 	u8 pn[PN_LEN + 1];
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 70bb057320e4..6606fb8b3e42 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2744,6 +2744,7 @@ int t4_seeprom_wp(struct adapter *adapter, bool enable)
 int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 {
 	int i, ret = 0, addr;
+	int ec, sn, pn, na;
 	u8 *vpd, csum, base_val = 0;
 	unsigned int vpdr_len, kw_offset, id_len;
 
@@ -2771,6 +2772,23 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 	}
 
 	id_len = pci_vpd_lrdt_size(vpd);
+	if (id_len > ID_LEN)
+		id_len = ID_LEN;
+
+	i = pci_vpd_find_tag(vpd, VPD_LEN, PCI_VPD_LRDT_RO_DATA);
+	if (i < 0) {
+		dev_err(adapter->pdev_dev, "missing VPD-R section\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	vpdr_len = pci_vpd_lrdt_size(&vpd[i]);
+	kw_offset = i + PCI_VPD_LRDT_TAG_SIZE;
+	if (vpdr_len + kw_offset > VPD_LEN) {
+		dev_err(adapter->pdev_dev, "bad VPD-R length %u\n", vpdr_len);
+		ret = -EINVAL;
+		goto out;
+	}
 
 #define FIND_VPD_KW(var, name) do { \
 	var = pci_vpd_find_info_keyword(vpd, kw_offset, vpdr_len, name); \
@@ -2793,14 +2811,28 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 		goto out;
 	}
 
+	FIND_VPD_KW(ec, "EC");
+	FIND_VPD_KW(sn, "SN");
+	FIND_VPD_KW(pn, "PN");
+	FIND_VPD_KW(na, "NA");
+#undef FIND_VPD_KW
+
+	memcpy(p->id, vpd + PCI_VPD_LRDT_TAG_SIZE, id_len);
+	strim(p->id);
+	memcpy(p->ec, vpd + ec, EC_LEN);
+	strim(p->ec);
+	i = pci_vpd_info_field_size(vpd + sn - PCI_VPD_INFO_FLD_HDR_SIZE);
+	memcpy(p->sn, vpd + sn, min(i, SERNUM_LEN));
+	strim(p->sn);
+	i = pci_vpd_info_field_size(vpd + pn - PCI_VPD_INFO_FLD_HDR_SIZE);
+	memcpy(p->pn, vpd + pn, min(i, PN_LEN));
+	strim(p->pn);
+	memcpy(p->na, vpd + na, min(i, MACADDR_LEN));
+	strim((char *)p->na);
+
 out:
 	vfree(vpd);
-	if (ret < 0) {
-		dev_err(adapter->pdev_dev, "error reading VPD\n");
-		return ret;
-	}
-
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 /**

base-commit: 3a62c333497b164868fdcd241842a1dd4e331825
-- 
2.33.0

