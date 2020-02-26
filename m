Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38156170C0D
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 23:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBZW7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 17:59:42 -0500
Received: from gateway32.websitewelcome.com ([192.185.145.122]:46994 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbgBZW7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 17:59:42 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 8FDDBC8975
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 16:59:38 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 75eUjHluOXVkQ75eUjcyS8; Wed, 26 Feb 2020 16:59:38 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Fz9nyQX1QkRblZo9LVjcferorg1WW+A764pYyoMSgXc=; b=UBDmf4j1iPov9iNECuYuxAHvqm
        YICs8KcV0wgaeLhVJKQGiC+igAbaT1TTfmkRSqdZHmYg/3dmU8FCcfao72tpbYCF+BCDx39r5/HDo
        QvB9T23Z64LNvMvyY+8eJdxuRuNvwRv136G2hgCWKlc1H4rhJCG470NnFLQhyTI8rSQxrBvdNitx6
        2ibKVo6GMA4PwO1Nqb9wQLuJooRtQoKZc76u9Et8WD8dZinrY7oYEGKkJs8Ohsf5l8YHrxab8nq+2
        Hpjtstn2zpH7bFpu+gpRVMEXURUl2pGDZpDPbAR7DmilgmadDKnEDtS7VRK2U6xq3zOpbJM4PPLJ4
        yO/N8d1g==;
Received: from [200.76.83.69] (port=53168 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j75eR-001aM6-Pd; Wed, 26 Feb 2020 16:59:36 -0600
Date:   Wed, 26 Feb 2020 17:02:27 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] Bluetooth: Replace zero-length array with
 flexible-array member
Message-ID: <20200226230227.GA31639@embeddedor>
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
X-Source-IP: 200.76.83.69
X-Source-L: No
X-Exim-ID: 1j75eR-001aM6-Pd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.76.83.69]:53168
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 40
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
 drivers/bluetooth/btqca.h        |  6 +++---
 drivers/bluetooth/btrtl.h        |  4 ++--
 include/net/bluetooth/hci.h      | 30 +++++++++++++++---------------
 include/net/bluetooth/hci_sock.h |  6 +++---
 include/net/bluetooth/l2cap.h    |  8 ++++----
 include/net/bluetooth/rfcomm.h   |  2 +-
 net/bluetooth/a2mp.h             | 10 +++++-----
 net/bluetooth/bnep/bnep.h        |  6 +++---
 8 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index f5795b1a3779..e16a4d650597 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -79,7 +79,7 @@ struct qca_fw_config {
 struct edl_event_hdr {
 	__u8 cresp;
 	__u8 rtype;
-	__u8 data[0];
+	__u8 data[];
 } __packed;
 
 struct qca_btsoc_version {
@@ -112,12 +112,12 @@ struct tlv_type_nvm {
 	__le16 tag_len;
 	__le32 reserve1;
 	__le32 reserve2;
-	__u8   data[0];
+	__u8   data[];
 } __packed;
 
 struct tlv_type_hdr {
 	__le32 type_len;
-	__u8   data[0];
+	__u8   data[];
 } __packed;
 
 enum qca_btsoc_type {
diff --git a/drivers/bluetooth/btrtl.h b/drivers/bluetooth/btrtl.h
index 10ad40c3e42c..2a582682136d 100644
--- a/drivers/bluetooth/btrtl.h
+++ b/drivers/bluetooth/btrtl.h
@@ -38,13 +38,13 @@ struct rtl_epatch_header {
 struct rtl_vendor_config_entry {
 	__le16 offset;
 	__u8 len;
-	__u8 data[0];
+	__u8 data[];
 } __packed;
 
 struct rtl_vendor_config {
 	__le32 signature;
 	__le16 total_len;
-	struct rtl_vendor_config_entry entry[0];
+	struct rtl_vendor_config_entry entry[];
 } __packed;
 
 #if IS_ENABLED(CONFIG_BT_RTL)
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 6293bdd7d862..d878bf8dce20 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -935,7 +935,7 @@ struct hci_cp_sniff_subrate {
 struct hci_cp_set_event_flt {
 	__u8     flt_type;
 	__u8     cond_type;
-	__u8     condition[0];
+	__u8     condition[];
 } __packed;
 
 /* Filter types */
@@ -1335,7 +1335,7 @@ struct hci_rp_read_local_amp_assoc {
 	__u8     status;
 	__u8     phy_handle;
 	__le16   rem_len;
-	__u8     frag[0];
+	__u8     frag[];
 } __packed;
 
 #define HCI_OP_WRITE_REMOTE_AMP_ASSOC	0x140b
@@ -1343,7 +1343,7 @@ struct hci_cp_write_remote_amp_assoc {
 	__u8     phy_handle;
 	__le16   len_so_far;
 	__le16   rem_len;
-	__u8     frag[0];
+	__u8     frag[];
 } __packed;
 struct hci_rp_write_remote_amp_assoc {
 	__u8     status;
@@ -1613,7 +1613,7 @@ struct hci_cp_le_set_ext_scan_params {
 	__u8    own_addr_type;
 	__u8    filter_policy;
 	__u8    scanning_phys;
-	__u8    data[0];
+	__u8    data[];
 } __packed;
 
 #define LE_SCAN_PHY_1M		0x01
@@ -1641,7 +1641,7 @@ struct hci_cp_le_ext_create_conn {
 	__u8      peer_addr_type;
 	bdaddr_t  peer_addr;
 	__u8      phys;
-	__u8      data[0];
+	__u8      data[];
 } __packed;
 
 struct hci_cp_le_ext_conn_param {
@@ -1693,7 +1693,7 @@ struct hci_rp_le_set_ext_adv_params {
 struct hci_cp_le_set_ext_adv_enable {
 	__u8  enable;
 	__u8  num_of_sets;
-	__u8  data[0];
+	__u8  data[];
 } __packed;
 
 struct hci_cp_ext_adv_set {
@@ -1775,14 +1775,14 @@ struct hci_cp_le_set_cig_params {
 	__le16  m_latency;
 	__le16  s_latency;
 	__u8    num_cis;
-	struct hci_cis_params cis[0];
+	struct hci_cis_params cis[];
 } __packed;
 
 struct hci_rp_le_set_cig_params {
 	__u8    status;
 	__u8    cig_id;
 	__u8    num_handles;
-	__le16  handle[0];
+	__le16  handle[];
 } __packed;
 
 #define HCI_OP_LE_CREATE_CIS			0x2064
@@ -1793,7 +1793,7 @@ struct hci_cis {
 
 struct hci_cp_le_create_cis {
 	__u8    num_cis;
-	struct hci_cis cis[0];
+	struct hci_cis cis[];
 } __packed;
 
 #define HCI_OP_LE_REMOVE_CIG			0x2065
@@ -1937,7 +1937,7 @@ struct hci_comp_pkts_info {
 
 struct hci_ev_num_comp_pkts {
 	__u8     num_hndl;
-	struct hci_comp_pkts_info handles[0];
+	struct hci_comp_pkts_info handles[];
 } __packed;
 
 #define HCI_EV_MODE_CHANGE		0x14
@@ -2170,7 +2170,7 @@ struct hci_comp_blocks_info {
 struct hci_ev_num_comp_blocks {
 	__le16   num_blocks;
 	__u8     num_hndl;
-	struct hci_comp_blocks_info handles[0];
+	struct hci_comp_blocks_info handles[];
 } __packed;
 
 #define HCI_EV_SYNC_TRAIN_COMPLETE	0x4F
@@ -2226,7 +2226,7 @@ struct hci_ev_le_advertising_info {
 	__u8	 bdaddr_type;
 	bdaddr_t bdaddr;
 	__u8	 length;
-	__u8	 data[0];
+	__u8	 data[];
 } __packed;
 
 #define HCI_EV_LE_CONN_UPDATE_COMPLETE	0x03
@@ -2302,7 +2302,7 @@ struct hci_ev_le_ext_adv_report {
 	__u8  	 direct_addr_type;
 	bdaddr_t direct_addr;
 	__u8  	 length;
-	__u8	 data[0];
+	__u8	 data[];
 } __packed;
 
 #define HCI_EV_LE_ENHANCED_CONN_COMPLETE    0x0a
@@ -2362,7 +2362,7 @@ struct hci_evt_le_cis_req {
 #define HCI_EV_STACK_INTERNAL	0xfd
 struct hci_ev_stack_internal {
 	__u16    type;
-	__u8     data[0];
+	__u8     data[];
 } __packed;
 
 #define HCI_EV_SI_DEVICE	0x01
@@ -2409,7 +2409,7 @@ struct hci_sco_hdr {
 struct hci_iso_hdr {
 	__le16	handle;
 	__le16	dlen;
-	__u8	data[0];
+	__u8	data[];
 } __packed;
 
 /* ISO data packet status flags */
diff --git a/include/net/bluetooth/hci_sock.h b/include/net/bluetooth/hci_sock.h
index 8e9138acdae1..9352bb1bf34c 100644
--- a/include/net/bluetooth/hci_sock.h
+++ b/include/net/bluetooth/hci_sock.h
@@ -144,19 +144,19 @@ struct hci_dev_req {
 
 struct hci_dev_list_req {
 	__u16  dev_num;
-	struct hci_dev_req dev_req[0];	/* hci_dev_req structures */
+	struct hci_dev_req dev_req[];	/* hci_dev_req structures */
 };
 
 struct hci_conn_list_req {
 	__u16  dev_id;
 	__u16  conn_num;
-	struct hci_conn_info conn_info[0];
+	struct hci_conn_info conn_info[];
 };
 
 struct hci_conn_info_req {
 	bdaddr_t bdaddr;
 	__u8     type;
-	struct   hci_conn_info conn_info[0];
+	struct   hci_conn_info conn_info[];
 };
 
 struct hci_auth_info_req {
diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 093aedebdf0c..61dc731d5666 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -299,14 +299,14 @@ struct l2cap_conn_rsp {
 struct l2cap_conf_req {
 	__le16     dcid;
 	__le16     flags;
-	__u8       data[0];
+	__u8       data[];
 } __packed;
 
 struct l2cap_conf_rsp {
 	__le16     scid;
 	__le16     flags;
 	__le16     result;
-	__u8       data[0];
+	__u8       data[];
 } __packed;
 
 #define L2CAP_CONF_SUCCESS	0x0000
@@ -322,7 +322,7 @@ struct l2cap_conf_rsp {
 struct l2cap_conf_opt {
 	__u8       type;
 	__u8       len;
-	__u8       val[0];
+	__u8       val[];
 } __packed;
 #define L2CAP_CONF_OPT_SIZE	2
 
@@ -392,7 +392,7 @@ struct l2cap_info_req {
 struct l2cap_info_rsp {
 	__le16      type;
 	__le16      result;
-	__u8        data[0];
+	__u8        data[];
 } __packed;
 
 struct l2cap_create_chan_req {
diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 8d65d2a0b9b4..99d26879b02a 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -355,7 +355,7 @@ struct rfcomm_dev_info {
 
 struct rfcomm_dev_list_req {
 	u16      dev_num;
-	struct   rfcomm_dev_info dev_info[0];
+	struct   rfcomm_dev_info dev_info[];
 };
 
 int  rfcomm_dev_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
diff --git a/net/bluetooth/a2mp.h b/net/bluetooth/a2mp.h
index 0029d5119be6..2fd253a61a2a 100644
--- a/net/bluetooth/a2mp.h
+++ b/net/bluetooth/a2mp.h
@@ -36,14 +36,14 @@ struct a2mp_cmd {
 	__u8	code;
 	__u8	ident;
 	__le16	len;
-	__u8	data[0];
+	__u8	data[];
 } __packed;
 
 /* A2MP command codes */
 #define A2MP_COMMAND_REJ         0x01
 struct a2mp_cmd_rej {
 	__le16	reason;
-	__u8	data[0];
+	__u8	data[];
 } __packed;
 
 #define A2MP_DISCOVER_REQ        0x02
@@ -62,7 +62,7 @@ struct a2mp_cl {
 struct a2mp_discov_rsp {
 	__le16     mtu;
 	__le16     ext_feat;
-	struct a2mp_cl cl[0];
+	struct a2mp_cl cl[];
 } __packed;
 
 #define A2MP_CHANGE_NOTIFY       0x04
@@ -93,7 +93,7 @@ struct a2mp_amp_assoc_req {
 struct a2mp_amp_assoc_rsp {
 	__u8	id;
 	__u8	status;
-	__u8	amp_assoc[0];
+	__u8	amp_assoc[];
 } __packed;
 
 #define A2MP_CREATEPHYSLINK_REQ  0x0A
@@ -101,7 +101,7 @@ struct a2mp_amp_assoc_rsp {
 struct a2mp_physlink_req {
 	__u8	local_id;
 	__u8	remote_id;
-	__u8	amp_assoc[0];
+	__u8	amp_assoc[];
 } __packed;
 
 #define A2MP_CREATEPHYSLINK_RSP  0x0B
diff --git a/net/bluetooth/bnep/bnep.h b/net/bluetooth/bnep/bnep.h
index 24f18b133959..9680473ed7ef 100644
--- a/net/bluetooth/bnep/bnep.h
+++ b/net/bluetooth/bnep/bnep.h
@@ -74,14 +74,14 @@ struct bnep_setup_conn_req {
 	__u8 type;
 	__u8 ctrl;
 	__u8 uuid_size;
-	__u8 service[0];
+	__u8 service[];
 } __packed;
 
 struct bnep_set_filter_req {
 	__u8 type;
 	__u8 ctrl;
 	__be16 len;
-	__u8 list[0];
+	__u8 list[];
 } __packed;
 
 struct bnep_control_rsp {
@@ -93,7 +93,7 @@ struct bnep_control_rsp {
 struct bnep_ext_hdr {
 	__u8 type;
 	__u8 len;
-	__u8 data[0];
+	__u8 data[];
 } __packed;
 
 /* BNEP ioctl defines */
-- 
2.25.0

