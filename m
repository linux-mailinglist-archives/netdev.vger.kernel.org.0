Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D7B5608CB
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 20:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiF2SN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 14:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiF2SNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 14:13:55 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70053.outbound.protection.outlook.com [40.107.7.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D81429C92
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 11:13:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7odoRO2Idb2n4g2Muz40okpvaJauCTbbZKzuwGXCoUBHiqArOdHAezYoy6BBQKGro4ILvnhFsTkq278Gnq4YOsQKtETCpxKIkCmdxkedLIMw3WZ4s53exqGtrxnQDNjAmoFQFf43KzfEYgV754x4y+QjDjPhC6yTVYfr7DP83KUtlyhBLlAR7ZhjSKAbVXj/9YGs83MXgVi6SCVTAWdCdYLzif9N/ErHeTwwOXiFH4Aq8sJJTIj/rEUDC7BqhWCZlFRKN0R3f/d+iMVRCBvqwoES+ZQlVkES/O3XcVhQWwE+fJy/67PH+2F0B9cAbgov3kMKBsHw6LP/BrONja7oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsfJgD/8RSswMCCqd3hmJx0nWs0PiZuAUJ5R7abouKQ=;
 b=nj1V/gDyLuUwVq9OwjqUjXmDO4k8/8d2cNO8KVXV1GYPZDqwddTCaYF86VPnhKasNPzpl198t7N9FwE7TVkAv/RV8SfLFsnKxQ85l+V2yc+IbBY4ngQndSV2RtJAQWYQa0A5fPYDzK9sAO0MWFmCRFz1iI7zoZ5rFNK31R8TO0s+V5OcmC/5D29YlO9kfpTZCEajgSqbqqS6awfX/K51ZzH1JACju35sWm9f9W5PZGOo+RHx0Fme3yqFtTB9s4Cgd44qpa3mnUKmZC/fvGzCEDSQGGK8ftTGtj/2P4a7FpKWgogSUgdWmyNMczr/XQnrtrk+HOwzIM1oTlhTLmfIVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsfJgD/8RSswMCCqd3hmJx0nWs0PiZuAUJ5R7abouKQ=;
 b=hHetUsmGvbvmdbPKAqtx9qHy+hkFfFpxCufOuYqz9SVyLKkeNM9hpcMi36qUbsJC3/ubDnEPtQTueTQW4JbkjMySKyPzwODBP/3TNThY9ZsD1UAzWBDUJNq0i/6Lu1CJ3Wri73LFd+maXbLdGUfHbHSe15PxIwMHCrGO2mmipEA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3604.eurprd04.prod.outlook.com (2603:10a6:208:1c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 18:13:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 18:13:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next] net: gianfar: add support for software TX timestamping
Date:   Wed, 29 Jun 2022 21:13:35 +0300
Message-Id: <20220629181335.3800821-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0003.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e0e071c-5fc1-43cc-b765-08da59fb1ed1
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3604:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fg/AJt5i7sqLzqrrB0WhDi+tLIiqHAfm/UPGlymgtqXGPCvkU96ujgIne975hlltGin/ItwEmN6XGIlJofodbjn103665/j3LZTkJkR4NK/F0hLrmhhUXCiQQU5AC14kVzRu7L9ZkLh0RLK42JRO7u7Xqxd73UK1LGmOxJK0uobLdV6iic3SE0XElX2+0Rzz0dP9RgUwwRbMToap42vU0nuZ40ZEJ0WMgFPA/d3I3IHUO5ItVI1xbBLTs26L6FYIK79Ri00Z3ysOjJlR2hwQzH1TJ8lYoXdyaywFoNmqr+izpmOd9+sNVYqyMaf+HRLtiyE4PexwzHRWc6iWhYi/OoeNm3oNj9UNI4QwPMVG/5pNa3pxm4mJsYRSdyOKIt4guJBG/auGvnuI5qpqeIneWBdIgMOjXG4LQ6r/BkXIdcD4lJru961+QEie+GGvbeIwOichzEybq4H0YREKkszKPNWKACHWHxvekRFpoVba98mMBIDCOirvAXsOyP2yL4Igqb/dgxx4uRazmG0mm4XR7DvlPzOAR4BBEb3tNqBnsbEUOLN1GxASHW4R+Mv3Sa7km/nFSWref6MRsbmFDYM2VBtk7ScaOur0MuIxzVmaBdAE2bUAYp0jO5vZsAeHJ3eiPhfumZDym567tQc5XVfLjgC9WGQD5MVvfllEuR/xcT/rTGWZiDSFgdxO6dOOli0eXgPf3RC4Wvyq+DKogvVP5Jmu8ogqODYiNGxk8tHU7hSrJEiFLPQDVgG5jvJo/6UrqsVB58LxFgX9OXH+mYRVmWNa03KDR4uaJHpyHQ+Eht4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(86362001)(6916009)(6506007)(2906002)(6666004)(5660300002)(41300700001)(83380400001)(186003)(38350700002)(52116002)(54906003)(36756003)(6486002)(38100700002)(66556008)(66946007)(2616005)(6512007)(8676002)(478600001)(26005)(44832011)(316002)(66476007)(1076003)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ns1RBgNGLhvb2uecATUEf9p79wwylehiKBOTQASVhM94C4K2Z9htQBi5+sAl?=
 =?us-ascii?Q?5NQX1uAZJfCyZ0i0+tkHzaqj4Tf3NzZ6pp/f9URdFwhfgHolbe7Lso9qHDaP?=
 =?us-ascii?Q?dlKm/3PqAzbCUv3DR+qdcwlrEdr5zBFuTffjyWZCQBQpSk4skRAiqq1gDeME?=
 =?us-ascii?Q?Ydz5JZX3Kcwo4VR0upIIxV2TodhkbGe3n7/XZp8LzJs4ai01Is+ORc2iIM6e?=
 =?us-ascii?Q?z9Truzj+C1u41EG/Hs+miWwjQPUx6qgFI4v09NSQ8ny5wDdpb6JrXfwnpxC1?=
 =?us-ascii?Q?oh3hCQizzK508dXYdFV3vO9LscT1j6o8kZ6Pjak2sw4OTFtB9LpUi1szf7ie?=
 =?us-ascii?Q?Lsm0d7NYMwOXegANVxzXYyrgMwHkofh2NXuB/0yPXQVcLjU1R8CMpNmpsOYm?=
 =?us-ascii?Q?BWUHVHBmhWUXzOzidtH6GEbq23M8xy0aGaOUjPPIQFpSkxvnjbs9qRthgwab?=
 =?us-ascii?Q?njyora91MypS2RXT57BvAtmthsIOx+bYdzfbEtSavlgKh6A+POKDN5F09IHo?=
 =?us-ascii?Q?Tw8fhf3xsoCw4OOB3DcKEe1sXePniPAPX3tq4y261wpYwgtsfcu80o5jbRvz?=
 =?us-ascii?Q?gyKDWnyvqTb+MHqrKzNK21f7+nBdalnOwtJsWk0DIgaiIAKDS2Laxov2+9On?=
 =?us-ascii?Q?7pIxgz/Br3Q4U02O6BCC6wmGB1XJ7RluLiQDATeGRF5ILBztinpcLtGlvmFd?=
 =?us-ascii?Q?pmWfB7ZomOsgN1zw7EIZ1nDTvF98rNOjsGCnr6Af9ktRC30B+eVsE6kTWw5b?=
 =?us-ascii?Q?3KKPZyR1aFEWh14C74bRRY2b9s/unnxe9Aq/F+FRDY3Ei44soy0xoQ3jqD0D?=
 =?us-ascii?Q?UT/LgzzEnGbbTFclrXpGSflLuwH3o8KBx/a4RiACzynNK+fDmQ8VxZXIl60i?=
 =?us-ascii?Q?gJtqnglwty4nrzygt5rmDRI/k9+QbfyVDhbEdCa4/Y6q7G1TKJg5/an8OHtx?=
 =?us-ascii?Q?C7UYmZNdCFHoqRaHvMNZGlXvAQ8IwpgjaWbPIrt8T6v1P8riPGcUss5istFD?=
 =?us-ascii?Q?E3awBwDrm/BS0mEPjAuAr2HWmTAxiU/uf+BrfIpcd7q2TaeLs0uPLvPh67nN?=
 =?us-ascii?Q?NJjrVwyMkXGO8Ev+aMYDRbW6RjbEEKYhl+ss//XZ66m0s4BCuIiiTcWGVwBv?=
 =?us-ascii?Q?SCjCOjk3dygvSpV0P2eYLwU/uNsj5/SaL6ZDwaid+NBiJum4FC7SZOWcV/Hu?=
 =?us-ascii?Q?jgwv5TcT9Gn+i9d5HDeVkUAGsxb2jjz5BD9vbDFRaA6F75tAVwYfkGbaHnPu?=
 =?us-ascii?Q?U91Gl2XYBdMPXDIo3oon3sKj9Sbk/cpoE9p2iYVE5yoBdPia+q4iJEaRP0fs?=
 =?us-ascii?Q?ZiprxyoIA07jvPDm+2I4RZgvNot4U8+9kRcGfcBDHSnUqF9yu86WR02HNbln?=
 =?us-ascii?Q?NYhp7wES76Zvd/JNyLnLbm4k6a6CydFpaUO5/9dOV8zFzj8tKqkWeY3+zc7D?=
 =?us-ascii?Q?JQX4cW/nxCQ3Q/X9FjAn+KGxAiHw7Vhiuko5MspLRUeYstVDQgm+0iYWENHX?=
 =?us-ascii?Q?jQ/gbzl3D0Jl7EiaCtdRILO8aDH5r5OilDKCeOefrO519vi0nGB0jV5h1+4I?=
 =?us-ascii?Q?MIYbnE9OHAyYoarV0a+Z5e0r3tuWUYBJp9PZj+yXYF4F000ulojmqQMQ8TEJ?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e0e071c-5fc1-43cc-b765-08da59fb1ed1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 18:13:51.7726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NWxnTz+wJbGS81BwjAdF1XWWm27haUaLVzTJeefBp8lgPPc7mCLvKRFEs8A53Gywsyx5ovKrEQrni11rU8DCiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3604
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are required by certain network profiling applications in order to
measure delays.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/gianfar.c         | 1 +
 drivers/net/ethernet/freescale/gianfar_ethtool.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 3dc9369a33f7..e7bf1524b68e 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1944,6 +1944,7 @@ static netdev_tx_t gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		lstatus |= BD_LFLAG(TXBD_CRC | TXBD_READY) | skb_headlen(skb);
 	}
 
+	skb_tx_timestamp(skb);
 	netdev_tx_sent_queue(txq, bytes_sent);
 
 	gfar_wmb();
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 9a2c16d69e2c..81fb68730138 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1457,6 +1457,7 @@ static int gfar_get_ts_info(struct net_device *dev,
 
 	if (!(priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)) {
 		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+					SOF_TIMESTAMPING_TX_SOFTWARE |
 					SOF_TIMESTAMPING_SOFTWARE;
 		return 0;
 	}
@@ -1474,7 +1475,10 @@ static int gfar_get_ts_info(struct net_device *dev,
 
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
-				SOF_TIMESTAMPING_RAW_HARDWARE;
+				SOF_TIMESTAMPING_RAW_HARDWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE;
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
 			 (1 << HWTSTAMP_TX_ON);
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
-- 
2.25.1

