Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4C0170A4B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 22:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbgBZVRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 16:17:15 -0500
Received: from gateway22.websitewelcome.com ([192.185.46.187]:45476 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727591AbgBZVRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 16:17:13 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 2FFC36B76
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 15:17:11 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 743LjeMuKAGTX743LjndPt; Wed, 26 Feb 2020 15:17:11 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hcbL3GZL7zsDbcF7idZFTlF2lQ3OpBjxU8cd/6ijrTg=; b=fidh2amCT9uWl2kffO/euzuGBx
        UEBpTxuFfCFq9WZOVARghIAnVfVkv1j7SzqN9AecVch+6Kz4jZNxnkm/cu+48NfjSQM5ZSlVNlnjD
        FYoTTlQUiSDLDoaSNBn7sx1nZZpkK+cm0MvhXpdJGS60/05Y7520Y71IIv0lVO8eg4/dVbFsjXo/G
        uRyPUFUr3miIoqER1U7tKfo2yAKSqeEBhLvTMe/mtIb+KBRNQlMAenN7h6iHaKmmKAg7TXqKF6koG
        MtJEK9hLR/migrGJdxeMq949dFojySxzONPVMxCEzT4RsappO8FJmP6jJao1Vv6QTgv075YdDUq1P
        kE62bZeQ==;
Received: from [201.162.161.213] (port=47606 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j743J-000kNj-0S; Wed, 26 Feb 2020 15:17:09 -0600
Date:   Wed, 26 Feb 2020 15:20:00 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] NFC: Replace zero-length array with flexible-array
 member
Message-ID: <20200226212000.GA32231@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.161.213
X-Source-L: No
X-Exim-ID: 1j743J-000kNj-0S
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.161.213]:47606
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 10
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/nfc/fdp/fdp.c      |  2 +-
 drivers/nfc/st21nfca/dep.c |  4 ++--
 include/net/nfc/nci.h      | 14 +++++++-------
 include/net/nfc/nfc.h      |  2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 062535c8251b..d4ff9e6056c2 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -76,7 +76,7 @@ static u8 nci_core_get_config_otp_ram_version[5] = {
 struct nci_core_get_config_rsp {
 	u8 status;
 	u8 count;
-	u8 data[0];
+	u8 data[];
 };
 
 static int fdp_nci_create_conn(struct nci_dev *ndev)
diff --git a/drivers/nfc/st21nfca/dep.c b/drivers/nfc/st21nfca/dep.c
index 137eb3f7dabd..98e73e047e02 100644
--- a/drivers/nfc/st21nfca/dep.c
+++ b/drivers/nfc/st21nfca/dep.c
@@ -66,7 +66,7 @@ struct st21nfca_atr_req {
 	u8 bsi;
 	u8 bri;
 	u8 ppi;
-	u8 gbi[0];
+	u8 gbi[];
 } __packed;
 
 struct st21nfca_atr_res {
@@ -79,7 +79,7 @@ struct st21nfca_atr_res {
 	u8 bri;
 	u8 to;
 	u8 ppi;
-	u8 gbi[0];
+	u8 gbi[];
 } __packed;
 
 struct st21nfca_psl_req {
diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 6ab5a83f597c..0550e0380b8d 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -244,13 +244,13 @@ struct dest_spec_params {
 struct core_conn_create_dest_spec_params {
 	__u8    type;
 	__u8    length;
-	__u8    value[0];
+	__u8    value[];
 } __packed;
 
 struct nci_core_conn_create_cmd {
 	__u8    destination_type;
 	__u8    number_destination_params;
-	struct core_conn_create_dest_spec_params params[0];
+	struct core_conn_create_dest_spec_params params[];
 } __packed;
 
 #define NCI_OP_CORE_CONN_CLOSE_CMD	nci_opcode_pack(NCI_GID_CORE, 0x05)
@@ -321,7 +321,7 @@ struct nci_core_init_rsp_1 {
 	__u8	status;
 	__le32	nfcc_features;
 	__u8	num_supported_rf_interfaces;
-	__u8	supported_rf_interfaces[0];	/* variable size array */
+	__u8	supported_rf_interfaces[];	/* variable size array */
 	/* continuted in nci_core_init_rsp_2 */
 } __packed;
 
@@ -338,7 +338,7 @@ struct nci_core_init_rsp_2 {
 struct nci_core_set_config_rsp {
 	__u8	status;
 	__u8	num_params;
-	__u8	params_id[0];	/* variable size array */
+	__u8	params_id[];	/* variable size array */
 } __packed;
 
 #define NCI_OP_CORE_CONN_CREATE_RSP	nci_opcode_pack(NCI_GID_CORE, 0x04)
@@ -501,18 +501,18 @@ struct nci_rf_nfcee_action_ntf {
 	__u8 nfcee_id;
 	__u8 trigger;
 	__u8 supported_data_length;
-	__u8 supported_data[0];
+	__u8 supported_data[];
 } __packed;
 
 #define NCI_OP_NFCEE_DISCOVER_NTF nci_opcode_pack(NCI_GID_NFCEE_MGMT, 0x00)
 struct nci_nfcee_supported_protocol {
 	__u8	num_protocol;
-	__u8	supported_protocol[0];
+	__u8	supported_protocol[];
 } __packed;
 
 struct nci_nfcee_information_tlv {
 	__u8	num_tlv;
-	__u8	information_tlv[0];
+	__u8	information_tlv[];
 } __packed;
 
 struct nci_nfcee_discover_ntf {
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 5d277d68fd8d..2cd3a261bcbc 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -146,7 +146,7 @@ struct nfc_evt_transaction {
 	u32 aid_len;
 	u8 aid[NFC_MAX_AID_LENGTH];
 	u8 params_len;
-	u8 params[0];
+	u8 params[];
 } __packed;
 
 struct nfc_genl_data {
-- 
2.25.0

