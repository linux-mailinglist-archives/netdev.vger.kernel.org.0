Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977426C92F5
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 09:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjCZH16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 03:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCZH15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 03:27:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB682A5D8
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 00:27:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2C8LD6++lI6FxzNeMvcoZsRZ8LDk/iLXLvD7YTck3BHYObB4Rw7du8kTeilVbCkXXRzBPlNOKF6Bez3uCbpPvsRjtF8ip/82wFEXcO4+p6u6wNIrXHw7n19Devplx4+RFHbzGF7Clg7cw5o7tG1JPJsfKcUA5sSO/+Eqxckxy2XMSTBzvDhLER7sNg+k/wrRQ61IuvhLbsmWIiUUvyPJ2jyD+USvROg2I0Inhnc2A19IuTz/5pULoJgiK+DvTcX9930x9dKtwodD0YA0kY7Zs0x52GymyOVeQd/BAhIdEMV7lFGR4onKG9I+mnLqoEIOr4bXXnJIpb4QBGqBHBLZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTKJY8GVstErpOk5X+ZFRdHegZbd/2UAviXfO3q4Vuk=;
 b=mvj2oWva09bnCG49YdBh9F5kK7D8UoxcT54AXev7VDFSgbxfrcgL8ESnq+fN0nNdmFzaHea6Q2K0GMJFrH3hpuEUJzOW02KMIrMMd6yl5/QI9fOO5tVLWoLyrWDG616emmq36Ev3D02UvMcRdJ4/v46PlU5jz6Qr5yWkjEI4PtSV5O/teUYB1aDx4JIj+7VoMkEsKlaWGCyV8bgYfpTetUHf2/nJZl4ybeigFK9KAb+i6EOHmO5Pg5GMHz65Nvm9dMb49DL8XrYX4xpjBVwO237MN/weuNVDO2pqNJ/Y9ZMOwFd1e4mE8LH81cc5GsNAbCNeomNiGiEEy/JUPZQpGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTKJY8GVstErpOk5X+ZFRdHegZbd/2UAviXfO3q4Vuk=;
 b=ghAfuH1Y3c0xYDyHpMLPSoJIRD71jsKIyaYvkibZcGVLIwVTrLzqDwgHgrA7VxcVYeH5I+ZI1xGypCrC5nimEULjU8Adv14AK9DuF/1cxdB4vHSRfL4lV4nt2ZimSZQwT1oQsohf+PbG8ygROZ1KEsuClxN0pxtPIhyw+AE6NWHDEF7iJ3QM3Vy5SyvtLBIsjWCrM5H0gA6aH3Kqj758oI79+irPHs9MbV1mVhlSlDwDe2NdN2sAAP0Gf9jQimzhCNDbPoZgDLRjmy+yZKsCaXfxFBVQh4enOBAQpFMjAYtZk5fpUFat2z6NN9V7DmwPe4my+ReHFfFMz6TQ4cijxw==
Received: from BN0PR04CA0007.namprd04.prod.outlook.com (2603:10b6:408:ee::12)
 by DS0PR12MB8415.namprd12.prod.outlook.com (2603:10b6:8:fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 07:27:49 +0000
Received: from BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::94) by BN0PR04CA0007.outlook.office365.com
 (2603:10b6:408:ee::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Sun, 26 Mar 2023 07:27:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT077.mail.protection.outlook.com (10.13.177.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Sun, 26 Mar 2023 07:27:49 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 26 Mar 2023
 00:27:36 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 26 Mar 2023 00:27:35 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Sun, 26 Mar
 2023 00:27:34 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 4/4] macsec: Add MACsec rx_handler change support
Date:   Sun, 26 Mar 2023 10:26:36 +0300
Message-ID: <20230326072636.3507-5-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230326072636.3507-1-ehakim@nvidia.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT077:EE_|DS0PR12MB8415:EE_
X-MS-Office365-Filtering-Correlation-Id: b871d5d2-4598-4a35-2500-08db2dcb9a66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NmIzGkO51V9OTUAg8IW0Gc7i4X7WGkKc7V1Lwas75A5KTiI0y4J+ArsLG+4Ab7nkkF/A5AhyB6NQDYMnDcKf8Xzp90G6deTzzWzS6T2IFShjA5fU9x+SH1oBaLahq5EqG+hi6uk8BHoE5Lurscl0O7uCWlCMcp+iUYUFTIW0hue2ffyrazXd302qp1vd8/PEfXg8VHKFx9bjVG6tJjcKm0tlue1boZmWykNY4nvZYksP2zskMQYc2QrlJIJxS//5Op1YBsUWAogTF/hLRezamSGW+0mNeZLdWl/EmQgFpj/vWbFumUprBmvYxLFXa1eNhQji2KZUuaZ+3u7sUY0bPAaeDjuuojEx/M8e5LheyWW5DRWP3gAS9m8Ff+hYuBX4IZ8V5ZcpG+7n5RfbVGzlBCmQEIfDdUZ7E/jy5Gyw3Ikh62LXuqBunMT9x3WQ31piIegY6fYgidnT4e8lPoRwXXYt0vwE3X83XHVOP+oFvlFM8zWrkaXtOQGeEikkoIQk/tlC2qIi+/gStudMGHpSo0rgwFJKY3aLfZsOKL5qxburZk1bHjfxqYwu18NcbFc03yphMtyyEsgcxaQDJAArmmqz/QvyMiIsg2AuLc7LQVQcGtKKhu17Q7Zj7JKrp55qz+lLpTAabdVa22qLh9CpJWvF4iK4RBGWIalxLiZGf7BPMABsHTXtSqdh0Kg7WEyAcIcxsrsc9DYCk5KERh9bsUtCaXrmHRxFSlVxkwB6T0kxIFBvIG+LlRE0JuqkMRPpRX/7p8w3ReaA+x5Yd1/mgvHu85eAulmjVEl3erfw9ig=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(40470700004)(46966006)(36840700001)(110136005)(54906003)(7696005)(478600001)(107886003)(40480700001)(1076003)(26005)(316002)(8676002)(70586007)(70206006)(4326008)(41300700001)(40460700003)(2616005)(7636003)(82740400003)(8936002)(186003)(36860700001)(5660300002)(336012)(36756003)(34020700004)(2906002)(82310400005)(86362001)(356005)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 07:27:49.3022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b871d5d2-4598-4a35-2500-08db2dcb9a66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8415
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading device drivers will mark offloaded MACsec SKBs with the
corresponding SCI in the skb_metadata_dst so the macsec rx handler will
know to which interface to divert those skbs, in case of a marked skb
and a mismatch on the dst MAC address, divert the skb to the macsec
net_device where the macsec rx_handler will be called.

Example of such a case is having a MACsec with VLAN as an inner header
ETHERNET | SECTAG | VLAN packet.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 25616247d7a5..88b00ea4af68 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1048,6 +1048,15 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 
 				__netif_rx(nskb);
 			}
+
+			if (md_dst && md_dst->type == METADATA_MACSEC &&
+			    (find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci))) {
+				skb->dev = ndev;
+				skb->pkt_type = PACKET_HOST;
+				ret = RX_HANDLER_ANOTHER;
+				goto out;
+			}
+
 			continue;
 		}
 
-- 
2.21.3

