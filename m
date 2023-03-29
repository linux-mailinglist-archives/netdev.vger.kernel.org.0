Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5536CD946
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjC2MVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjC2MVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:21:35 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E0249DA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:21:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqi+3qIE2vEIZSPsEXPyXAcM7S73TmPnVUGdv9MZnSh0FyqI6egrX8LO3oJJ46QAh4VSiKy4btCOWXYM3I0exCM+vS2GrvFzFF3M3ONXZ0vwDOmhHvt15qKb/f8mJ9zCSgYedgxcNPmqzKXnVcLigjW1W7OLxLDJTj7oQa+cFw+Q9WRnRzgpFgeROLI+sUIr7rWr2iUN6dbCTaTjrHsiU6r50cwvD/HXq0bHauXsLkxQLOiOBkQTSC4HhUydOMhlgcIco+GRjk8MzkVxYgN/0DeKti6QWA9LxSd44KWkn0BFxdBsAsWmff2gdgY/R9cgDF3C2PA3IvktV+Ctd/YoPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTKJY8GVstErpOk5X+ZFRdHegZbd/2UAviXfO3q4Vuk=;
 b=TR2mW/vF1XW5ak09+8Mops11X7vWBIKXArkAyAXhfy+r/4R6AdHe8lKBgxEXgVKB/I1uAncP1Vg+NJ/stUi42WmaYcnaw2aR5D5aqMkAIb/iobYZ4MG25G8RGFdfN4R5Tet3q57Dm0zwOEk69W+piZib57DRUMkm31E2hzz8w0Ncr5odtPc0ediksv4Cty//mhDNcqxgOPD4bt8OUPbK4HU/VJOKOnR8gu0VRgYUP7HoQAKdhloDuUmSRRRkFsHqbJdmXuyXCWquSi9F5rEMVB1s2lDD/Z3tKXicEIPghYoTKVsUGzGyh2uzkO7nk2owIWV9LYeOtg67sEfP0i0TvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTKJY8GVstErpOk5X+ZFRdHegZbd/2UAviXfO3q4Vuk=;
 b=URqwdSwXqBsle6HCkcFMckS7kMlu2YJNbWzklySkyO6ATHdPKG/pEubmZaZXWNNQN0sEAmxWofRdqaY4RRLcHJkJAFPw9hIxqzaXKSEnv0RJlzVIt6F71yNvvCjN1YN7vWHPORV39N+IYOakMPzMTQXvGgCN/iJ1XoQHbxiw2rhE1se8BjlUE9R2y1bgTcvdf4hTDHzK0ET8f7tp0bn1TuJrdAQXf32+EFGeM9O7n9R0hsZQf1LRkKiq0pvif2NvToRBt90P08nQMmtZDO9f4hRBSGBjkLtM4Q5RkLTu3yhHg+rBMQ+SK3pKbazV3TBfLg1DOgPuycNJ4/Qs/7+NVA==
Received: from MW4PR03CA0338.namprd03.prod.outlook.com (2603:10b6:303:dc::13)
 by DM4PR12MB7600.namprd12.prod.outlook.com (2603:10b6:8:108::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.31; Wed, 29 Mar
 2023 12:21:31 +0000
Received: from CO1NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::33) by MW4PR03CA0338.outlook.office365.com
 (2603:10b6:303:dc::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.21 via Frontend
 Transport; Wed, 29 Mar 2023 12:21:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT076.mail.protection.outlook.com (10.13.174.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.21 via Frontend Transport; Wed, 29 Mar 2023 12:21:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 29 Mar 2023
 05:21:24 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 29 Mar 2023 05:21:24 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Wed, 29 Mar
 2023 05:21:22 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 4/4] macsec: Add MACsec rx_handler change support
Date:   Wed, 29 Mar 2023 15:21:07 +0300
Message-ID: <20230329122107.22658-5-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230329122107.22658-1-ehakim@nvidia.com>
References: <20230329122107.22658-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT076:EE_|DM4PR12MB7600:EE_
X-MS-Office365-Filtering-Correlation-Id: 261c5fea-b3d2-4c07-c058-08db3050213c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+ZYK8Wd6Oqk21dotU3yaA+Qe3+TiMNpEuoKVkauiRQ8QlO9WBXQvYCH8VyWVeqMa5eNAkjG7aURiiLlrcUrDVstt7Iqm+7rh2dEZlumCXKPksgSmDQfsoyjYeRDMbYfeICrb1qclmllLCvWOe5qTitiCfjZzBMgnvg1vAvGaJXh01Qg++Sf5goBAgrmrlqSD43DcIsKG8UedUI/1iooWjLRKHaqzFbX5NXbDvPj6QOUtRrl/yNWJneByzePqbCCD3t7tGgvVBFd8MU4h69iiqdqJomKv1DjN83apWKeyJOFjxd2YfqgbXj1V1VTfrHGtuMtL0uKxbNbDeBwiAlP/rjX4aWAyj2n/bsLHz7bUVQRM+eKCvAoukkObxiPYbP38DnbtwEgDkE/Yns7aQpnw21vSsxKg8P75LdRVZwXz+uCwi1k3FjVWV3YncopNu8lalcp/75vRVk7lGgzpQd2QJpT+X2zAwVKv8htTRaFTWA2D54dOn6NHgoREVTbOoZ1aTmyHMz8v3W4Bf7C3PwHYRi50yxoVC1RYY3I2Jky5NTWjYVp4j1BTVo72XVrfyiobR2aCUTFgJlq5KkWzXAjxpZ0DROXOdQeTQGaFcLmV6PmXWyAdUF69HmwrXgCbZfEkm9h3SHNpBYYTozLtnfuuZnIxqKFQSlKH16VK21+IF57O+kqReFEId+q3PB2fl3eki/3e05UIHKjfFy6p788MOOn5PIOLDibHf23VMjoFF1EmBb7JX6lg2qRHYRMz9p2fRFCq0oKNRsN8HdrxV79CLrwd0T3da4ioHbfWhVe9KU=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199021)(46966006)(40470700004)(36840700001)(2906002)(40480700001)(36756003)(82310400005)(86362001)(40460700003)(478600001)(107886003)(5660300002)(426003)(6666004)(336012)(47076005)(8676002)(2616005)(7696005)(110136005)(34020700004)(4326008)(70586007)(70206006)(316002)(186003)(36860700001)(8936002)(1076003)(356005)(7636003)(54906003)(82740400003)(26005)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 12:21:31.5266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 261c5fea-b3d2-4c07-c058-08db3050213c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7600
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

