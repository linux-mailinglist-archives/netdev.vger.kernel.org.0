Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66C41E4538
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387942AbgE0OGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbgE0OGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 10:06:24 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61B2C206F1;
        Wed, 27 May 2020 14:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590588384;
        bh=MkIk8HRQfNKTJpeG9uXaBiahdr4DaoqFGscee3N22ss=;
        h=Date:From:To:Cc:Subject:From;
        b=Jj4ei4DG1vGZad9fnUD1l/lcyfWl0H2ZfbsskJwT7Sw5d7Zl9oAzFFE8Od1o2BDAy
         yffwR6kMJB0pTgicdUPZQNZROoS7OPA2VUwLwzn9VrddUAq2xb9AVJntI4eShdIivs
         q5NauugRjY0F296Oapc14WsW/000CevOcQTi8fUM=
Date:   Wed, 27 May 2020 09:11:19 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH net-next v3] ice: Replace one-element arrays with
 flexible-arrays
Message-ID: <20200527141119.GA30849@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of one-element arrays in the following
form:

struct something {
    int length;
    u8 data[1];
};

struct something *instance;

instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
instance->length = size;
memcpy(instance->data, source, size);

but the preferred mechanism to declare variable-length types such as
these ones is a flexible array member[1][2], introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on. So, replace
the one-element array with a flexible-array member.

Also, make use of the offsetof() helper in order to simplify some macros
and properly calculate the size of the structures that contain
flexible-array members.

This issue was found with the help of Coccinelle and, audited _manually_.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - We still can simply the code even more by using offsetof() just once. :)

Changes in v2:
 - Use offsetof(struct ice_aqc_sw_rules_elem, pdata) instead of
   sizeof(struct ice_aqc_sw_rules_elem) - sizeof(((struct ice_aqc_sw_rules_elem *)0)->pdata)
 - Update changelog text.

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  6 ++---
 drivers/net/ethernet/intel/ice/ice_switch.c   | 23 ++++++-------------
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 586d69491268a..faa21830e40d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -570,7 +570,7 @@ struct ice_sw_rule_lkup_rx_tx {
 	 * lookup-type
 	 */
 	__le16 hdr_len;
-	u8 hdr[1];
+	u8 hdr[];
 } __packed;
 
 /* Add/Update/Remove large action command/response entry
@@ -580,7 +580,7 @@ struct ice_sw_rule_lkup_rx_tx {
 struct ice_sw_rule_lg_act {
 	__le16 index; /* Index in large action table */
 	__le16 size;
-	__le32 act[1]; /* array of size for actions */
+	__le32 act[]; /* array of size for actions */
 	/* Max number of large actions */
 #define ICE_MAX_LG_ACT	4
 	/* Bit 0:1 - Action type */
@@ -640,7 +640,7 @@ struct ice_sw_rule_lg_act {
 struct ice_sw_rule_vsi_list {
 	__le16 index; /* Index of VSI/Prune list */
 	__le16 number_vsi;
-	__le16 vsi[1]; /* Array of number_vsi VSI numbers */
+	__le16 vsi[]; /* Array of number_vsi VSI numbers */
 };
 
 /* Query VSI list command/response entry */
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 0156b73df1b1f..191735ac491c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -29,25 +29,16 @@ static const u8 dummy_eth_header[DUMMY_ETH_HDR_LEN] = { 0x2, 0, 0, 0, 0, 0,
 							0x81, 0, 0, 0};
 
 #define ICE_SW_RULE_RX_TX_ETH_HDR_SIZE \
-	(sizeof(struct ice_aqc_sw_rules_elem) - \
-	 sizeof(((struct ice_aqc_sw_rules_elem *)0)->pdata) + \
-	 sizeof(struct ice_sw_rule_lkup_rx_tx) + DUMMY_ETH_HDR_LEN - 1)
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx) + \
+	 DUMMY_ETH_HDR_LEN)
 #define ICE_SW_RULE_RX_TX_NO_HDR_SIZE \
-	(sizeof(struct ice_aqc_sw_rules_elem) - \
-	 sizeof(((struct ice_aqc_sw_rules_elem *)0)->pdata) + \
-	 sizeof(struct ice_sw_rule_lkup_rx_tx) - 1)
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx))
 #define ICE_SW_RULE_LG_ACT_SIZE(n) \
-	(sizeof(struct ice_aqc_sw_rules_elem) - \
-	 sizeof(((struct ice_aqc_sw_rules_elem *)0)->pdata) + \
-	 sizeof(struct ice_sw_rule_lg_act) - \
-	 sizeof(((struct ice_sw_rule_lg_act *)0)->act) + \
-	 ((n) * sizeof(((struct ice_sw_rule_lg_act *)0)->act)))
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lg_act.act) + \
+	 ((n) * sizeof(__le32)))
 #define ICE_SW_RULE_VSI_LIST_SIZE(n) \
-	(sizeof(struct ice_aqc_sw_rules_elem) - \
-	 sizeof(((struct ice_aqc_sw_rules_elem *)0)->pdata) + \
-	 sizeof(struct ice_sw_rule_vsi_list) - \
-	 sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi) + \
-	 ((n) * sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi)))
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.vsi_list.vsi) + \
+	 ((n) * sizeof(__le16)))
 
 /**
  * ice_init_def_sw_recp - initialize the recipe book keeping tables
-- 
2.26.2

