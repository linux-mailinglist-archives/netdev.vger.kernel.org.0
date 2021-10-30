Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445B9440684
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 02:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhJ3A5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 20:57:10 -0400
Received: from mail-cusazon11021027.outbound.protection.outlook.com ([52.101.62.27]:23128
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231286AbhJ3A5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 20:57:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzgUtaHDrsq6q7+3Mle8pXp1G3iViv52HHLywokl2lKe4qYT0fJscWxKjOgQ5waAU186JWlwa4f39jjusxa32t+kqgcLSZXMemQgVBrsrPhqCSSKuJpqEYZwHOLbCe8xaIoddMU9uPSu/XQvfz2a206epqeQbyWR/QeaYu+i0nJldNel+Chb5SJ2PKE/gFtWgRiQ55ilLy+MlYdY27vGAnLAbS8g6sZyN3HUpiGq+LK0qH0Luy6aBAH6/jtZ7skdu3zPbfKB8MYIn3OSy1tz8lEexlDy0xajDN2fpAP5GTpU7E95NKLmtHmB2/HAFkxxxODNDfEmkrF5Tm9eQVOE+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCSF9oJ0wneBcePeooOP0wgTGzUn2QDAqbjau00PpZA=;
 b=Nn03XZZ29dVwsBfpOaOMprMwfEmFUvYV1OsVC5jaAIB7hwcO4XFikv3y53n4scEFRwSb4KTd6Ukj60re0XGTUX3TsiL3LIbOLtdGcIJG959YR5C8N9Tft+exeHJqJIq60U4rYNPqA47RMrO4Kj0m3A65jW7rT9gSXpUSZKcFKFwnPOEPSyKHnr9Mhubo4DBvBcfnvgWS7esYcAEHK9A5jAjF101Z2CAfrFexHNzF3D+VbAk8122Q4RTqZFTfmX07vbbX4z09UsJA6MVil0kInw5EZWeH30QgNXLlm4D3kctB8g17enml4NAUHoPUjpKN+EhtHbCkcMWXzFgnncM2Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCSF9oJ0wneBcePeooOP0wgTGzUn2QDAqbjau00PpZA=;
 b=FXD5EQrBRVORih3erEIKesz9iPy0n8JHfdZdPY8TLrGqK9S4cDsJEbuwob74A7ldqE8/RBGudYSQjdNWZQ5g2rVuWfqPLnneZjpcwRJ+mlz5yyfMljFT4fhlGwfAtYq4gyq/1iN5VdE00Cnz+SGrGt3NvE7WqCLo08afd8HK6eQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com (2603:10b6:4:a2::17)
 by DM5PR21MB0827.namprd21.prod.outlook.com (2603:10b6:3:a3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.6; Sat, 30 Oct 2021 00:54:30 +0000
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828]) by DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828%4]) with mapi id 15.20.4649.010; Sat, 30 Oct 2021
 00:54:29 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        haiyangz@microsoft.com, netdev@vger.kernel.org
Cc:     kys@microsoft.com, stephen@networkplumber.org, wei.liu@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        shacharr@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next 1/4] net: mana: Fix the netdev_err()'s vPort argument in mana_init_port()
Date:   Fri, 29 Oct 2021 17:54:05 -0700
Message-Id: <20211030005408.13932-2-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211030005408.13932-1-decui@microsoft.com>
References: <20211030005408.13932-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:300:ef::12) To DM5PR2101MB1095.namprd21.prod.outlook.com
 (2603:10b6:4:a2::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:f:7661:5dff:fe6a:8a2b) by MWHPR22CA0002.namprd22.prod.outlook.com (2603:10b6:300:ef::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Sat, 30 Oct 2021 00:54:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bf7f011-8c84-4d92-ff04-08d99b3fd426
X-MS-TrafficTypeDiagnostic: DM5PR21MB0827:
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB0827DD250724CEFDA45656CCBF889@DM5PR21MB0827.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gAPhdp5rdgDRoEals4jOkiK3BFjgKx0+ogcHuDyhQMKom5FY7yjhElJoKH38K3Y+h69x4ppezr2xUs+g551rzPgF0vNL6VeHjFqBkO/0oImqNgrS7Q9tgjWnL8AGiaDh+voQvMISt6JrgCBPX8/2lgNeJrdK70iugLO2MNGOvfFaxLBqDLwAQxswiFuwM4jr+RK7tcQa2Boq9OmssmzQ68Y3wtLL6lNVLuDI3jwCC3KpHWBpjbmyKjYygOmEnbDfTAyj8I5hGiPjSHQQMVMM306ESUK3Xen8pF9sUZY7cIsNnWAyMtwuNrSZr47V9TTUtQRkeA/1Fu6CtBus8yH5TkDTYzWYT3D9liTWetu/mHC0grvVR8oSftE5jMbrvAoVhRWUp0pPhI7Yp8da5t0U9mBeMZwJ75sl0V/JfrZFbynRvT/vC3/aDv+2Gl7aQ4y6BmLGoEO+ImYeqdIoVtdRV7/TnXqtvUR52hOxmqLZVMGKS95M5AFO7z4OiLYLijgkW+ygsIx7LQpFu1uVDMPy7gDYwzsULRbao77fdg6bD9EPsjuMEidFwr1oaSzJRp+gSbJKuA0YqH1YsZzNLsr7xObSMxdVk/izgWAMfpOyzwOdDuEOvqvDrUTCqa8NxGVtNJoHO1cByAE5J/hdeR28JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB1095.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(52116002)(7696005)(86362001)(6486002)(1076003)(83380400001)(66556008)(66476007)(4326008)(107886003)(66946007)(8676002)(2616005)(5660300002)(6666004)(10290500003)(38100700002)(82950400001)(82960400001)(7416002)(36756003)(316002)(2906002)(186003)(8936002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WGbHwOOiD/VljS9JMNBOlg5pNM6Wh3oknzY0FLg/y6TUzCR27C0IpcYWOm6O?=
 =?us-ascii?Q?umkcGR/d63wOxUliZdBCHoAIeybrt/NDeRMOf6XE0BhmWbfBwBfAZRz5dOt7?=
 =?us-ascii?Q?rNoZflaDsd7ThVUWyPW5NXq1172mm1DVZWj2PXf0n9G2UmKm8TRCChDZZPa5?=
 =?us-ascii?Q?oi9ihUrnkdTEr98AU9cka0Q7NUIrHo9I3Zpq2WzSEPrn5d+Ss10EPUj3/W7+?=
 =?us-ascii?Q?QxCL4SmBZUM7SiMwKEgnSZynSxO1tukxLeTcXVb80Z6XVxsPYh9y5skNcuF8?=
 =?us-ascii?Q?M25ioVzpb92y6Zyhnbc5eUYuRXJJ/nbQt1e5n/5hEk3tDMHcFkyv3oBADAwU?=
 =?us-ascii?Q?Y5CBd8u7JpKIt6wDiUJIQwibGjfqcKgtLm4Pujh/xslvIk0wUYMdympmL7/X?=
 =?us-ascii?Q?EUwvtZA9owB9Kg32DT/UFkOXlDLa9FDaXx1wwAMy4kzRxvRaiNKDPye+0iia?=
 =?us-ascii?Q?cXA3EYI9fkL4i8kij2gkD5UnQbpA5S6TQueltEXLB3umngx6gsJ+tXc8OmIn?=
 =?us-ascii?Q?MXf3OGWyLDXw9XqgyM3LLe7DY4+Px/JL0u/+t1tO13BUFeRbTY4l4/xprxTI?=
 =?us-ascii?Q?5dodcgg1HBrD4JFHrom4VWeDilNM3/n2owXnD5mjbMIDhljxxAORExV97xgg?=
 =?us-ascii?Q?hyNt+vXrOU+Q8XL2XJGkeU4H1xJmbi5/Qz4Ibz/9l5JCuu32jbQb/Oty4yDd?=
 =?us-ascii?Q?ZUAsxWA6g/7QjFpUeeGlUm8DoNKHeJZHmhk+ruJ7ENiirA+ZVEay9AdtD2nE?=
 =?us-ascii?Q?Uo3PkY8FFPVjIYUIrAT5bOMrM9j3+vvVV/Fxe9N5jHdU1FuFvDqhAGQ2y2n/?=
 =?us-ascii?Q?EiIfKQMqfvXtXqVI7OfvWVlz5Z2qmgXHFt9Yry2ce46XDRpLKU19a38wOazD?=
 =?us-ascii?Q?A5pudwG4kVwolUTv3QXq7aOUMO3OMFsqkhp4A9aMc/PgIysGiH6o8gqBt1+N?=
 =?us-ascii?Q?wSBiZ++RIIkLpnOo+R/THQi6KAOMLv6VXj+QXLzhFSZ8CTk6HHSwq2AWg8Rz?=
 =?us-ascii?Q?NBsi5ZuVlv9OLPG+JDbu5rJ5EraWbwTzgRAkTpcRmVoIqI7fFVWI/cG3VkEA?=
 =?us-ascii?Q?YuiZRRW9uXFrvoY+Iv2Khd2qExrozONt9UYdfBuB43W2kThSvBhuqcvXeylF?=
 =?us-ascii?Q?3XjBv67wn6v4+hs40DKNdG2Q8seFl8paHGCdqzQQahNrIgnBJoJgtxSPYLrS?=
 =?us-ascii?Q?ta1thUt21O9G5XJppn3PzUWQ1TtcUqIbYpGvWODij5TRsN9yeGsTr3XcFSQc?=
 =?us-ascii?Q?IXrJRwN+fhIA85/7dgmjNvSTEY+fsFJrSwiKv4HmM62Mq247iHcJQAMMgSgZ?=
 =?us-ascii?Q?o965iUz4T/7oTnfZlrTNvINDonJtCI/+WhfUWMKx7oyPgLx6WEOVVB7wjhHO?=
 =?us-ascii?Q?nxGt0Bsa6ARYucta5w0D7apnDIFJ/D2DoqgGCS5PeCe4lL8cr9BoEuYyFCTL?=
 =?us-ascii?Q?5P+Nx4wYruf2PkK5gq+64Gp52Bh29/i3BXhf08Li8siF59Q1ZES7c1gKQYBT?=
 =?us-ascii?Q?dDSSyTTVSAXxpb/vLlZ7f6FOXeW+Pd1bul2zrk4THRyPWd0Hv2nab8WpphF/?=
 =?us-ascii?Q?bqWIb3ngjcwNzt45vAYv4vjSDS22hzeMl1FCa0RCOlrXD+RZ4/7nect+2snh?=
 =?us-ascii?Q?05E+6YhrsNbVbwG3mQKh8m1y9Yxbw0L23xy1VnI83T70++dv/LBCPSdoFWLa?=
 =?us-ascii?Q?bgoj2dtwgsZX3l21kmqoKQBqCOk=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf7f011-8c84-4d92-ff04-08d99b3fd426
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB1095.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2021 00:54:29.8063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qJxM53+vnT+eAeJjMNdy+jdwf2lwV3xdRPgV1qy7rgqK6QlqKL57T66c5x2hhAA3Q6mES9+I89hVAQ92jX/Jew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the correct port index rather than 0.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 1417d1e72b7b..4ff5a1fc506f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1599,7 +1599,8 @@ static int mana_init_port(struct net_device *ndev)
 	err = mana_query_vport_cfg(apc, port_idx, &max_txq, &max_rxq,
 				   &num_indirect_entries);
 	if (err) {
-		netdev_err(ndev, "Failed to query info for vPort 0\n");
+		netdev_err(ndev, "Failed to query info for vPort %d\n",
+			   port_idx);
 		goto reset_apc;
 	}
 
-- 
2.17.1

