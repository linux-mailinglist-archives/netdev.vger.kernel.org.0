Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8616D0772
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjC3N54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjC3N5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:57:50 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466E64EFF
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:57:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWgKEWJszH05duy79E66knaiadovk/IKANIljQdMj1X2kCoDAzWRfQ7XS0XiBtlRaa1qJaBQMCv+cGHWCewAd/5FR+euN4Jvuxr926DtgTSzWGi6U66JuqzYrSn7VD5NI+3Sw51X6RwKGAJRtRIwfOn1YMtU5B4zOyXQJ7Zx9ceIvpgMXnxePOxXUgzx+/OB+938YTI0q2YFtq/orjFTSOskAqEUfVQiw3/hYc+THIdyOayWW4/4XqyaXe45rnSjluz1JwqU9uMigf8AyDO8a4IeYLzm3bWhnYxFrmfiXpUx0lUIRv5yisg9/7zvEC6XwT9r01gddMhiXmGeYbZnRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTKJY8GVstErpOk5X+ZFRdHegZbd/2UAviXfO3q4Vuk=;
 b=dPH7qVO+RvyuhvB7IC6Srdm70Qz7C4dRXHq7V1mmT0jqCMELV/UmYKTHsRyM11t/qB85PlXEqUd1Aaf8iOVcKHA7hebw5ego/3v4gL/exs/AZlatuMsAhWk2TrPfvH90kfFMxZ8LJ30lV4bG1rgB7S5y0hFTN9/cxkQqMw8c8mLTFcnI93cyOib7aEJD3yfk3iO9japXdYfFEBsOp/eNrl/YB0wFJMdu3A5LGqSy2Dcud+O+tPpLhtdBTSzqYNIqztT3ouvDMsX2QbxmevuH2OYbo1FjZM1M/zY9f3nNV91IVEKO58xm/FJ6GKhn2/9u8WMIW/GpS0S6U5Rl1QMBnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTKJY8GVstErpOk5X+ZFRdHegZbd/2UAviXfO3q4Vuk=;
 b=njkuuJ6Z/X5u4IYHHUtJCzoypCBgJUUxhPjGB0Zjtn0xb4lkqbiFntXYm2ENAdbpLEa6Av5pK3jfjEDKP6G6NCyBBHp7oynq947PQLDCPEakgkWrWEjg0DmO7uNmPXu+j7WzE6Rt73edJ5eWVNrQDLqg3ZolaiFu5zNwTZrC63b25NcQyYQfp0XqOjOOWMUHtDS8DnetWlgApDQobtLOGiHHcj5/uKropJH2P3z9dHqWv2cIswgRlHR6GPw91CgZqJGYoueGNilHXarz1JtMeTmzgTa/mtcDPyZ2KPcZyfnrAhMjmZQFj6wA+6pUiRnPQW1PKBFyQR+tR/IvXuyIvg==
Received: from CY5PR22CA0025.namprd22.prod.outlook.com (2603:10b6:930:16::13)
 by DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Thu, 30 Mar
 2023 13:57:47 +0000
Received: from CY4PEPF0000C96F.namprd02.prod.outlook.com
 (2603:10b6:930:16:cafe::58) by CY5PR22CA0025.outlook.office365.com
 (2603:10b6:930:16::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 13:57:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C96F.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 13:57:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 30 Mar 2023
 06:57:36 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 30 Mar
 2023 06:57:35 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 30 Mar
 2023 06:57:33 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v3 4/4] macsec: Add MACsec rx_handler change support
Date:   Thu, 30 Mar 2023 16:57:15 +0300
Message-ID: <20230330135715.23652-5-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230330135715.23652-1-ehakim@nvidia.com>
References: <20230330135715.23652-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96F:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: eabb014f-c70f-45ad-525b-08db3126be21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVvq7YmSVmoqCiuf10fkttzD5fVEhr9ZiyeSI9xHjilY8pBqTDqCzgH0J29hnRGcIjYF/79Za5N9fzTA/1qgaJonzk+Ov/f68AE+U1zANpVlukOPjCG87Lbk9mBs0fwwsYYR356rVQiOTXU8DVOXVEMWaJSuwhQDkvAT6ORWWULjE4TRmBAZokdJtdX7zHOHs7Mq5/UxhjrgeMx4dxuKIwc51yvZPKIyEp6apekQ1SlYJOMwgequGaVrsN8FIWjqwilclqVIDFgELUmLkwiYddkFwaa7jmWvuR0RFZt8aaNV6tDBgrOSP6H11kabSA8gNGfqVV9WJy6KDI67T6BcNEv6fgALxGQv2kgCmPU1vpXkxS5h5YZjKnGxDxTD5qqbMtOy2r9wfYmqxuCQmmEs6U57C5de1VMGrNwP7u/h0W/7rFAaUEmFnEYxUenoUlvbE+vT9hbggG4LCnKHRLRmAb+0rK4aDi/nhjwpBP2G+IKBhsdqMer0iFbXEUjwteUwMjZ9sHhLqV4iaYTlsEnZD9K7WOZoc6VDAIZcYh/0JqsPI1sGbpLffjUyyKrBQs8UKvok439T8XAVpKkHxgqROW14dZuo28aYrfm+ZizMMXLHwHKsllbFSP9Zrd0dbY2EABbZ1Tqc5iQfD8IKp65K3c9d+KfCx8w788gdjDkekoFmg3gvn9GPDnz+CHjTDz82q0zyLWi+vrPyDkZ7eQ2el8ZL1wF7Dra5fiEt0Rus4/yAXFaIX0AlXP/CgvaFRIPt
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199021)(46966006)(40470700004)(36840700001)(7696005)(6666004)(336012)(426003)(478600001)(2616005)(107886003)(26005)(1076003)(316002)(47076005)(186003)(36860700001)(54906003)(110136005)(70586007)(70206006)(8936002)(2906002)(7636003)(82740400003)(8676002)(5660300002)(356005)(41300700001)(4326008)(40460700003)(36756003)(86362001)(40480700001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 13:57:46.9867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eabb014f-c70f-45ad-525b-08db3126be21
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607
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

