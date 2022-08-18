Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF6559840F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245039AbiHRNYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245032AbiHRNYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:24:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F31B48CA8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:24:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q44GVwoEkdKpb7vU9HJbGClryg5bCo9BqKg79QJqbpF5WkBtZDrebmMxO6p2pWi6TmhQmL1KMLoPaGuvQouo5prLm4I7hxGaC2hTPE4DwC2Tl12Vbc0TVz/HjrsSMSLp4jwCHr0KYHTD8XnWOOvvFcxPmogORUDUl0xOWovKv//+nIaS1UPF7Uh3JwomFqReS6/QqhZhe6upKRSa1XnhSROM/+1IU/3ngUcmUK3gzFJp5WcbP8SJlqh/Hiaa6bTTyJ6fGcJ5AEbBme7NOAJjBTG3FXE5sC+lUY0TZQHFIN3EJdjeSaxlJMYD1M0i49wX5T3e7VvkJTVzpQ23zaGcfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wCoEyXJAKCrj7eYPnRHWmv1TlvYD7Bbc1AsiUWWPjg=;
 b=mTQ4GICxdt5jxNNNXuFzZ0dRuSOJmZVAXn0lrwVJizJXELpKHQBXbUHKz9K7OMCvxnN9rTEKusCsKNRFec6vJwoVwrJqujbQiIlSjV6lTYP1dMFDQwGc5q4g1SvOl5CIfpEWl++nGhloulFfCYwAO6bRUe28baVrkDHqhJJlvkyXiNuS3shjLvStTMN6puKVdlxKnuTpNgujJgu08tOgjOtThfaBfgY4uUegcHWuVNc9zgv/WAUFKnn4YwQWlL8Z58mtsHEZ54kpvF6cubs1AtjVFvwMGHaM2kkhJH0j2rxg8AX7MpAn4hzwROPNC4OQjUJssa+Xr0jTUABVmk8plg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wCoEyXJAKCrj7eYPnRHWmv1TlvYD7Bbc1AsiUWWPjg=;
 b=oNf8wA0/Fd6VpbGFz6s19lOzT8g1tjq2NOrB0iZ390kUmgOGYaqFX/kuNDqJrmM0CjeicFu0cJ++P2sOPDT2PgNkryRDk/aOyrH1ZGMjV1YqaZaTq+pgNDy4tU9VqEGY/m6IfOmHh/BAX+izl7tIS+p/Z+SAeLBuiQme56eNxKYjYINCFsQ0RHcvS4xA/scRRfaN3tGiAbDDAaX8ur3rzpwmT0diZ1OyLXi5j3Ws9HxG02i1Y763gkSd4kDpHkBROWbjJ/g8xZ4KJ9jDL1TRkqu5njPx8QFjxwxs8ST/R2SgygmwERpHNzn+KJGaeSa/tg8rgmZaciQtrHI+CqROQg==
Received: from MWH0EPF00056D19.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:1a) by BY5PR12MB3745.namprd12.prod.outlook.com
 (2603:10b6:a03:1ae::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 13:24:30 +0000
Received: from CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eab::208) by MWH0EPF00056D19.outlook.office365.com
 (2603:1036:d20::b) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.9 via Frontend
 Transport; Thu, 18 Aug 2022 13:24:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT105.mail.protection.outlook.com (10.13.175.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Thu, 18 Aug 2022 13:24:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 18 Aug
 2022 13:24:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 18 Aug
 2022 06:24:28 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 18 Aug 2022 06:24:25 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 3/3] net/macsec: Move some code for sharing with various drivers that implements offload
Date:   Thu, 18 Aug 2022 16:24:11 +0300
Message-ID: <20220818132411.578-4-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220818132411.578-1-liorna@nvidia.com>
References: <20220818132411.578-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23b4e0f7-0948-4de5-c66a-08da811cfae0
X-MS-TrafficTypeDiagnostic: BY5PR12MB3745:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qgb4V7tdMfP4aEmt0ZgdYz2QmskAOWlMC/VCU740RV6XcnxAsSP4wiZhFD5JsPFgujcfg/VdKV8H5xAFXgmKoi/1mKNHlVm+UC+YL7//YeziFVuM1bpa2ahpd8/p/fx7H9JEUck8SCvWRrrpyykbMElQFvhuzFDNM+DvAZ8IEi1hsKNIhVsb6sd/BbrTFvm6lc4UxDIiqzmOa+Ve3J7FBFXdj1/H1XuA45wXs56PuC2mUat7LHyKViB8b1WRSnETTCVbTGUnoqxsZ3JrIDp2cxGVVO5JqqRYBS9/UXNUh+s6P/a7AqHWcfyD3e2BQhdkVRKsmNnGzH0JwYakxHB2Z/yst67VPDTXydBJJ8IYblwYJuOJytaKWhtcM7rmJu0VWbWLe7GYUrDgUZY87A9SWsdJV8vLn5lyvK4IxssNjAHUHsVK2eplZc/MZVncr/+pc4JotOKX8u0vAIQhoepQqa+12Lce7k1Rs2LyJ95vVt4NPTN4s0Yj91bFeWxIrToiNyNZs5D1VQdpEdBEbQklxu+Hmvdxj9MbQ5EyHlxth8t5EzhbhyLHAUsAdN7Mi6N8EagFLvWQ7zXImnnSmRW7Xi7bIZruXchn1ZKUmg4mJbEdhmCM4GXhH3hVSdIFR0aostQ0XdiZ9FfqjPGB1V/j6FBY8/Cpjl+Mk3RRBxSAgvk+wN2mlWT+V+hs8ovsN1Fb2E4mrKd2N5X8TiuECbuk3tstQmVwhOMCZli+gQkLMYbwi0hgPqHRXzQrAoZAUo76J7GWRhaZ3aKQWPBjacsTKtcS6CT8kGDyURtrxgB0q373AUiUhMuPgdnJdJzjK7Z2
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(40470700004)(46966006)(36840700001)(316002)(54906003)(110136005)(5660300002)(8936002)(478600001)(36756003)(41300700001)(6666004)(47076005)(426003)(2906002)(336012)(186003)(1076003)(107886003)(2616005)(26005)(356005)(40480700001)(40460700003)(86362001)(36860700001)(83380400001)(70586007)(70206006)(8676002)(4326008)(82310400005)(82740400003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:24:29.3198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b4e0f7-0948-4de5-c66a-08da811cfae0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3745
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move some MACsec infrastructure like defines and functions,
in order to avoid code duplication for future drivers which
implements MACsec offload.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/macsec.c | 33 ++++++---------------------------
 include/net/macsec.h | 21 +++++++++++++++++++++
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 534459dbc956..0b898469fc18 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -25,8 +25,6 @@
 
 #include <uapi/linux/if_macsec.h>
 
-#define MACSEC_SCI_LEN 8
-
 /* SecTAG length = macsec_eth_header without the optional SCI */
 #define MACSEC_TAG_LEN 6
 
@@ -47,20 +45,10 @@ struct macsec_eth_header {
 	u8 secure_channel_id[8]; /* optional */
 } __packed;
 
-#define MACSEC_TCI_VERSION 0x80
-#define MACSEC_TCI_ES      0x40 /* end station */
-#define MACSEC_TCI_SC      0x20 /* SCI present */
-#define MACSEC_TCI_SCB     0x10 /* epon */
-#define MACSEC_TCI_E       0x08 /* encryption */
-#define MACSEC_TCI_C       0x04 /* changed text */
-#define MACSEC_AN_MASK     0x03 /* association number */
-#define MACSEC_TCI_CONFID  (MACSEC_TCI_E | MACSEC_TCI_C)
-
 /* minimum secure data length deemed "not short", see IEEE 802.1AE-2006 9.7 */
 #define MIN_NON_SHORT_LEN 48
 
 #define GCM_AES_IV_LEN 12
-#define DEFAULT_ICV_LEN 16
 
 #define for_each_rxsc(secy, sc)				\
 	for (sc = rcu_dereference_bh(secy->rx_sc);	\
@@ -231,7 +219,6 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 	return (struct macsec_cb *)skb->cb;
 }
 
-#define MACSEC_PORT_ES (htons(0x0001))
 #define MACSEC_PORT_SCB (0x0000)
 #define MACSEC_UNDEF_SCI ((__force sci_t)0xffffffffffffffffULL)
 #define MACSEC_UNDEF_SSCI ((__force ssci_t)0xffffffff)
@@ -246,14 +233,6 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 #define DEFAULT_ENCODING_SA 0
 #define MACSEC_XPN_MAX_REPLAY_WINDOW (((1 << 30) - 1))
 
-static bool send_sci(const struct macsec_secy *secy)
-{
-	const struct macsec_tx_sc *tx_sc = &secy->tx_sc;
-
-	return tx_sc->send_sci ||
-		(secy->n_rx_sc > 1 && !tx_sc->end_station && !tx_sc->scb);
-}
-
 static sci_t make_sci(const u8 *addr, __be16 port)
 {
 	sci_t sci;
@@ -318,7 +297,7 @@ static void macsec_fill_sectag(struct macsec_eth_header *h,
 	/* with GCM, C/E clear for !encrypt, both set for encrypt */
 	if (tx_sc->encrypt)
 		h->tci_an |= MACSEC_TCI_CONFID;
-	else if (secy->icv_len != DEFAULT_ICV_LEN)
+	else if (secy->icv_len != MACSEC_DEFAULT_ICV_LEN)
 		h->tci_an |= MACSEC_TCI_C;
 
 	h->tci_an |= tx_sc->encoding_sa;
@@ -636,7 +615,7 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 
 	unprotected_len = skb->len;
 	eth = eth_hdr(skb);
-	sci_present = send_sci(secy);
+	sci_present = macsec_send_sci(secy);
 	hh = skb_push(skb, macsec_extra_len(sci_present));
 	memmove(hh, eth, 2 * ETH_ALEN);
 
@@ -1270,7 +1249,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	/* 10.6.1 if the SC is not found */
 	cbit = !!(hdr->tci_an & MACSEC_TCI_C);
 	if (!cbit)
-		macsec_finalize_skb(skb, DEFAULT_ICV_LEN,
+		macsec_finalize_skb(skb, MACSEC_DEFAULT_ICV_LEN,
 				    macsec_extra_len(macsec_skb_cb(skb)->has_sci));
 
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
@@ -4027,7 +4006,7 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	rx_handler_func_t *rx_handler;
-	u8 icv_len = DEFAULT_ICV_LEN;
+	u8 icv_len = MACSEC_DEFAULT_ICV_LEN;
 	struct net_device *real_dev;
 	int err, mtu;
 	sci_t sci;
@@ -4151,7 +4130,7 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 				struct netlink_ext_ack *extack)
 {
 	u64 csid = MACSEC_DEFAULT_CIPHER_ID;
-	u8 icv_len = DEFAULT_ICV_LEN;
+	u8 icv_len = MACSEC_DEFAULT_ICV_LEN;
 	int flag;
 	bool es, scb, sci;
 
@@ -4163,7 +4142,7 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 
 	if (data[IFLA_MACSEC_ICV_LEN]) {
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
-		if (icv_len != DEFAULT_ICV_LEN) {
+		if (icv_len != MACSEC_DEFAULT_ICV_LEN) {
 			char dummy_key[DEFAULT_SAK_LEN] = { 0 };
 			struct crypto_aead *dummy_tfm;
 
diff --git a/include/net/macsec.h b/include/net/macsec.h
index aae6c510df05..752374efab83 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -17,6 +17,20 @@
 #define MACSEC_SALT_LEN 12
 #define MACSEC_NUM_AN 4 /* 2 bits for the association number */
 
+#define MACSEC_SCI_LEN 8
+#define MACSEC_PORT_ES (htons(0x0001))
+
+#define MACSEC_TCI_VERSION 0x80
+#define MACSEC_TCI_ES      0x40 /* end station */
+#define MACSEC_TCI_SC      0x20 /* SCI present */
+#define MACSEC_TCI_SCB     0x10 /* epon */
+#define MACSEC_TCI_E       0x08 /* encryption */
+#define MACSEC_TCI_C       0x04 /* changed text */
+#define MACSEC_AN_MASK     0x03 /* association number */
+#define MACSEC_TCI_CONFID  (MACSEC_TCI_E | MACSEC_TCI_C)
+
+#define MACSEC_DEFAULT_ICV_LEN 16
+
 typedef u64 __bitwise sci_t;
 typedef u32 __bitwise ssci_t;
 
@@ -292,5 +306,12 @@ struct macsec_ops {
 };
 
 void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa);
+static inline bool macsec_send_sci(const struct macsec_secy *secy)
+{
+	const struct macsec_tx_sc *tx_sc = &secy->tx_sc;
+
+	return tx_sc->send_sci ||
+		(secy->n_rx_sc > 1 && !tx_sc->end_station && !tx_sc->scb);
+}
 
 #endif /* _NET_MACSEC_H_ */
-- 
2.21.3

