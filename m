Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A746E0BEC
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjDMK5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjDMK5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:57:04 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89374468D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:57:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ylwi6w+MVfV27/SRSCcqKYDIjpxMHzLdizAg70wCP/0CSpgd3aNuTg83wcZCKphi5VimVsqiaStCDH1o1ZZhlwoDK8UAoljqFveMc/DOhfP4XIKzjQGEo/EtG99jHO8Uxj4tGJBRlh90ZOh8rqIoAfdD35C/PFQ8f2RDL0pD6nOrC1DxZ9xLtJifSGcpDixveHrbd2HxGxCcmoAj2H7JZ8cePnJsqoVfBp5SA54XunUYdKtvYnkNJWinI8bQeACnxTPwEcr0HizRCYnqJ9w718D8Dp2ckEKszJSi5sl80lIsHd8inB+iV31YMTlw9hcbPlzjKPRrguYSvrIMnn2Oqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYIH9EvyFenr29BOT9hBK6yJP7n54zgozpcl8qXyhsA=;
 b=hBn4ukrbeQU6c55Fk5LFt2QDxMKEqNv5Xw1pHhDRsxYOEeLKPxWRWmxb4sgepubUaq+O0+k7/Nkh0SRXk7TyalaLz2WL5p2PNx77WSSrm0sBMzk4roftJm+F35JqVQR5sgb1UXipmJXG6NMX7h5JuVvueiA4HPbIMeR2JXRYoCgqdLy2ZxgCwVyj1z06spacez6/CsT6Nbilqnh2X6x6Ct8V205x/OF16rQqAmV+HMexhdLWZQD1jL1sSDd7sgHevqfGBLz4KaYCehVJKgBeJ9RUpRJ4ODuOv1Hv3nKwOuxHuayyzuNEFl2lazjSYgkgwGIMHBKSBxAW5E43suUV5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYIH9EvyFenr29BOT9hBK6yJP7n54zgozpcl8qXyhsA=;
 b=l273YRWk/8z/GkH4pIjTbCqqGHnroiClmWNF3pHuRB7aMEs2GjuMzs7FTKPrnFBv1yhgfb5LY1hXXFsFiMhUXyd3lIrjbKfFFQow4vsd8ECt+OkuAUCJaNRvDoumdq9Xcg2F0wMemH9wEN/eajOmolAld9TIqt8sYhhz3DMtjIEEjMOJBzeRVxHFKdn9C31Lkon5rIEkQmwNOtdXy8B4fJCbxgUPu69mKPvqpoLo6wxxRpn4ckHF1OCQV5mBes57lCC/MSXv4gKhZcPJxaxoMEcWNnrbGfRlCZw009Bjo7R3Ei2vepHvxaf1RqksMAOybIFnpNr755ycvJRtAAoIqQ==
Received: from DM6PR08CA0042.namprd08.prod.outlook.com (2603:10b6:5:1e0::16)
 by MW4PR12MB7032.namprd12.prod.outlook.com (2603:10b6:303:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 10:56:59 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::37) by DM6PR08CA0042.outlook.office365.com
 (2603:10b6:5:1e0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.32 via Frontend
 Transport; Thu, 13 Apr 2023 10:56:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.31 via Frontend Transport; Thu, 13 Apr 2023 10:56:59 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 13 Apr 2023
 03:56:48 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 13 Apr
 2023 03:56:48 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 13 Apr
 2023 03:56:46 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst MAC address to identify destination MACsec device
Date:   Thu, 13 Apr 2023 13:56:22 +0300
Message-ID: <20230413105622.32697-6-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230413105622.32697-1-ehakim@nvidia.com>
References: <20230413105622.32697-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT064:EE_|MW4PR12MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: daa83c81-d9b0-4924-45cd-08db3c0dce5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7dsKEZ23DDizSeniVO6N5E4BLMpVlrZuVpPV7AS7w29mBSPaL9RNguSdJgBPvF+Z4dT0vwUjkXKYPGjFpuz0i6uTXdMMEzhFuwKDazF2IvWXdHj1BSWPp8ipAwHUwrEnaZm23DdJYQA1F2gXvBKUIaKIGbC8Yvmo8IjKCY2GYllX4vU1KMfkjDtBoHmhbZq2SUyYfRBovzJyC2kvre32l1uEc9zqF3OluoqoO/UXSBl2tGVl696g0/5jSRTUD8eDC518KPUsg5aa+kEENQpALFQ0GXICujJ5mqAe14Y1zJ71rPudfBOB5h0K60eORj6jpg664nL8dB0CMbjJD/dgjr+nxd1q60/BSDpPnvmZ9m4ejArHSmpeKzi7H37qRACFiLNv4tEcHESaSIT7mKYVda6xqa7YX1Dxmtyz4M2slbny/7BWCKFv3Eb5FdlXwAtAHsBmdikKG2dw/Mx73Knte8Eb4acJCpphx6Jvax4nCsIDzK56icUHrZ9us2PTpBbqOvt33QazXrk1pKZi1VylMYYEgQwRY6BZO0h9Lb5kDD5rebB5pjGecFu1zUW4BlkTsOxZN8d+TX1kSLjhEbrkXT0bUOiz0/ZKLqZX6OZI8BJWaNoMlQbtoRhr/GH7lyP2vAi+RTVCAxCMkUE/8ctLO/3LEt7hfoHIfRTIbfDXg/RAzA3k9y9ljH4JkeAK03n1nXCZn947gmX6ZALIKz4RzktrBGDmHzwV6dT3dJ3LVzMB23jRMuyWwqAjHFl3HBdVnPViLSgH71nmeSTsPUYkgJe8kCweyHDAoYqWyw41k8=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(8676002)(36860700001)(34020700004)(83380400001)(47076005)(336012)(426003)(2616005)(7696005)(478600001)(107886003)(6666004)(40460700003)(26005)(54906003)(110136005)(1076003)(186003)(2906002)(5660300002)(36756003)(316002)(7636003)(4326008)(356005)(82310400005)(70586007)(70206006)(41300700001)(82740400003)(8936002)(40480700001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:56:59.6046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: daa83c81-d9b0-4924-45cd-08db3c0dce5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7032
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading device drivers will mark offloaded MACsec SKBs with the
corresponding SCI in the skb_metadata_dst so the macsec rx handler will
know to which interface to divert those skbs, in case of a marked skb
and a mismatch on the dst MAC address, divert the skb to the macsec
net_device where the macsec rx_handler will be called to consider cases
where relying solely on the dst MAC address is insufficient.

One such instance is when using MACsec with a VLAN as an inner
header, where the packet structure is ETHERNET | SECTAG | VLAN.
In such a scenario, the dst MAC address in the ethernet header
will correspond to the VLAN MAC address, resulting in a mismatch.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 25616247d7a5..c19a45dc6977 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1021,8 +1021,11 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 		 * the SecTAG, so we have to deduce which port to deliver to.
 		 */
 		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
-			if (md_dst && md_dst->type == METADATA_MACSEC &&
-			    (!find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci)))
+			struct macsec_rx_sc *rx_sc = (md_dst && md_dst->type == METADATA_MACSEC) ?
+						     find_rx_sc(&macsec->secy,
+								md_dst->u.macsec_info.sci) : NULL;
+
+			if (md_dst && md_dst->type == METADATA_MACSEC && !rx_sc)
 				continue;
 
 			if (ether_addr_equal_64bits(hdr->h_dest,
@@ -1047,7 +1050,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 					nskb->pkt_type = PACKET_MULTICAST;
 
 				__netif_rx(nskb);
+			} else if (rx_sc) {
+				skb->dev = ndev;
+				skb->pkt_type = PACKET_HOST;
+				ret = RX_HANDLER_ANOTHER;
+				goto out;
 			}
+
 			continue;
 		}
 
-- 
2.21.3

