Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC086E5C12
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjDRIcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjDRIcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:32:15 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2041.outbound.protection.outlook.com [40.107.102.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB7D6A7B
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:31:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glGht1ek9Oyou7RxPhofhPT7MQRGZuIS/OIH3RUrZtehjlfm3PNyrVieIAy6kNLlE61E64ZBRE4zuG4kIv3Zd81N2Vz2zhzV8JPaJrqjCGUypG1+cR8Gr4z43uHFSDc0i2u9ryCzsHawo48kDI5QfFZ7ESxhHZDa0P8WYKHCBJl6z744fD0Z0Cg0kzNQvnrNgAKsWxOJq+Fx/N+B6h23ny69Xx6Z6uiYRfbrQcqQSRmV/Fu2LZ9AaQjHypxtMrto/kwq29Ap8Ik5BO4SI2PNaalKeJdQHmt7eNVohzui7tPj2B63ppMM4nLK3PSmDEgMIysYbayPp0Sk9U2amT+30Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83+GWXbdaZMWc/+1wFHQk8OcLD1ewmDI/zCIYqyZNUY=;
 b=dsVxAWGa9i8Ufm3XkEz1Jm4bkEsB8Z5vqoiDmh/X6rsj5hULjv6jsGxCv38CgJxAziDtIegaGXahFuBAT/bOLk1I2iVJqukxnhWsNPMocMlHTBjyvx/71ogbhV2ZB3jVL5SteigBCBEi73WnscFH7ktWBI5ehSEa3ObO8NUICTE6TrcUdHG6r6/61cqR05Ete2jt+019TIc6wEz+oOzlbP7h6dzQc7VE29o6Sf9l6YHq8NAi8B8l7GjzN/NS02HSXK4FCJpA8+ceNZ5X5ucPLCmZUG95NrBoqej3gL/IuWYPnngF/K9LEcw5MxB+V0Plq5/okVG0WRyOUMiljYpn6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83+GWXbdaZMWc/+1wFHQk8OcLD1ewmDI/zCIYqyZNUY=;
 b=GB27VJWHMXZRd2KbW6ZpOuDgXKoC1OCuXtsMe0ky/+wksYjkApsHZ82pjQsNjEKQxjDNgMi9Bd3qLJJAkekNc5UuhUMaL5/FDfiy+iKnRJOBaDKErwK0cjuTx+fTnSL3E1hcSxYmjSIZ0vN6QdVCZYhnN04UCb9u078flRQoZCCCad8MkVcQ5LH9WlWmnGse5EehHfoWIEkB0tIAMre6k4B2fP6JL19FglxdXpIx96cGqJBieYc+JxDkuCygPNMS48U07mIJcksW/PJ4xiCohLhcCIZAeLdZ1VhX9EUOOU8OQM7K2H8130LZ2C4CVcPbcsu/ntpm1bv3fwkjdTrAdA==
Received: from BN9PR03CA0285.namprd03.prod.outlook.com (2603:10b6:408:f5::20)
 by BL1PR12MB5173.namprd12.prod.outlook.com (2603:10b6:208:308::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 08:31:38 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::f9) by BN9PR03CA0285.outlook.office365.com
 (2603:10b6:408:f5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 08:31:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 08:31:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 18 Apr 2023
 01:31:22 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 18 Apr
 2023 01:31:21 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Tue, 18 Apr
 2023 01:31:19 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 5/5] macsec: Don't rely solely on the dst MAC address to identify destination MACsec device
Date:   Tue, 18 Apr 2023 11:31:02 +0300
Message-ID: <20230418083102.14326-6-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230418083102.14326-1-ehakim@nvidia.com>
References: <20230418083102.14326-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|BL1PR12MB5173:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fd1cbca-b46c-49a5-1a25-08db3fe753f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBn1btBiXutekeG5n5ktrqV29KBRFy7Kv13558zbjkOk5F6E7QQ8AhnNdZ7RrC3CTMcWuqB9DOJXGn3PYiOWsML2N1RVs+Jx0EOh92opxqaGf0MY5+O+Iy/CrNKcT18vqrllXPASOsi9s9LG5yAOPO04qozu7aO4yS8CwOyCXgdIKmoaBwDBikmzNCOnDeozeHui9vsxU0OYBOf4GlEYTQcmoiDU0Dg6jFNKOAZUDHYHj5iy4/E11gotmCG0MB5C1ZdFPMkHczy09+//eXpRQRQ9RZE9GP4gJAubuyUsa2+PjQX42FH/PJ6w4JsWYio7+WCN81bTxRJ2Nyobz/IWjOZz4NkfO2JtnxHZw4Ntzm/+8BJacWrwdnUPOr6wlT3+egP3OUYyXtStIQ7RDEA1MMMHEzO6M/oaWQZ3mksqg+YegPAykMtIgLVWGqv9Zys4GaCmf9vVvRya3p157gbEV/9YfCTno/ZKyZmW/bFzSg4dWWrD9laJUkyokdPtt1nG5cQG7xIzY12Z9Cmp5tTkZE7Ipqn+ULinro3UxWSScf4A0WU+GuB/WK04dbOfLp5+vzriq7LZcLSdHr/taLEHQCIC7DLD0hJPByH6mbh4BYN27zSDgYCaQHqoLvGUwOZy7qlm2L6TPimrQNZZRR+hov9nHBf5eZ/2PbaXmdIpyrITq86MUw2n6WvlKqimmqKoTFUy44KxdjrzQU5Sh3zmPBb554ZZR8ZRaYrl4GoLLKsykasVW68vk+XfncI8xcreMmJhcWRc1Wz8qpnX615vL1G3QjK3rQAES518UX0iiWE=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(36756003)(8936002)(8676002)(40460700003)(5660300002)(2906002)(82310400005)(86362001)(40480700001)(34020700004)(478600001)(7696005)(6666004)(54906003)(110136005)(186003)(107886003)(2616005)(36860700001)(1076003)(70586007)(70206006)(26005)(41300700001)(356005)(82740400003)(316002)(7636003)(83380400001)(4326008)(47076005)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 08:31:37.9855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd1cbca-b46c-49a5-1a25-08db3fe753f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5173
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
 drivers/net/macsec.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 25616247d7a5..3427993f94f7 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1021,8 +1021,12 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 		 * the SecTAG, so we have to deduce which port to deliver to.
 		 */
 		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
-			if (md_dst && md_dst->type == METADATA_MACSEC &&
-			    (!find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci)))
+			struct macsec_rx_sc *rx_sc = NULL;
+
+			if (md_dst && md_dst->type == METADATA_MACSEC)
+				rx_sc = find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci);
+
+			if (md_dst && md_dst->type == METADATA_MACSEC && !rx_sc)
 				continue;
 
 			if (ether_addr_equal_64bits(hdr->h_dest,
@@ -1047,7 +1051,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 					nskb->pkt_type = PACKET_MULTICAST;
 
 				__netif_rx(nskb);
+			} else if (rx_sc || ndev->flags & IFF_PROMISC) {
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

