Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719122EF053
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 11:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbhAHJ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:59:47 -0500
Received: from mail-eopbgr70133.outbound.protection.outlook.com ([40.107.7.133]:52228
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727569AbhAHJ7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 04:59:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9TdOEy9+QaBhkfVHnW+ufuSJtHjcmhFXstNAOIs3EFWeWtWEv6u2s/myDMF2TqcbJjkc2DthfKB3oHLdaRefy2azfDjLJ0kH3d5em5nwiV9HPtA3IxREj08l49PLzhG17vzQokLcro6jHfCO+ZnuLxnTedjrKNv+M27GwXBW5Y7jGwB9shq9/UHG9ffNrqcsKOz1fCV573JsT2dBtRaEx1MgJYCVVKLxkkykrXKjcazkSvUB/p+zqZEImWfnfpR91f+EL7/q5CNKB1r5LkNRRXUjkzV3T85kEtMhX6U3UTvntjAeEDJztg2wqey1l8ZzNDJceZuvS2Bf8GVpHDS/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkLDI1hh0P4FmHwbQNp6zpHxl14a+Ul8WJKWcVq6xsw=;
 b=KP16KpG07EpSFPXDKDVZfL3J4PzZGtrT0RvKR3dOrpi4Dz+SXxJ4F9erAm/PPkA8QZ9x6AwWg7zwyM+LX94TqgNCB89rliseUOet1WHlvLKoREfl8sw/Dpw4o9s3JuWdMEkZ3N/UKPiNAja49ORxM2hGAabz/s/w7iDWiGyloqeZTL5IYbmJsyYIB0nP40bfRLuILQcN/t/nNdKE8+FWRwlSJWgVao8gy7EAhbvKGTs6SJxEhHUL3adf1jFlybpjG+40eXp0UJYF26M/M/K2BeJ1+g3y4uZHNwru853EBUa+qORJ6suq8Uwm7EQ2zevgc5PCn8/TkgE/BCpsgUrtKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=leica-geosystems.com; dmarc=pass action=none
 header.from=leica-geosystems.com; dkim=pass header.d=leica-geosystems.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=leica-geosystems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkLDI1hh0P4FmHwbQNp6zpHxl14a+Ul8WJKWcVq6xsw=;
 b=cKwpkO/+36RGX9V6QsmA/tZgrUezHjlGXkOIrNs1xPGkuUtIceWrRQ24qSoSpCxvwNE9FKJthyyMHF6+LXl2avtEX3Oh2m3tXdsjRZAUv18GF/4NYbjrcHkbm6kn3VWJc0QsTD0rQ+4ckZa7V4beIhbWuREMuoze9YLYBuFMP6M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=leica-geosystems.com;
Received: from DB6PR0602MB2886.eurprd06.prod.outlook.com (2603:10a6:4:9b::11)
 by DB7PR06MB5354.eurprd06.prod.outlook.com (2603:10a6:10:30::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 09:58:56 +0000
Received: from DB6PR0602MB2886.eurprd06.prod.outlook.com
 ([fe80::39bd:12df:e0c6:4aee]) by DB6PR0602MB2886.eurprd06.prod.outlook.com
 ([fe80::39bd:12df:e0c6:4aee%11]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 09:58:56 +0000
From:   Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
To:     davem@davemloft.net, kuba@kernel.org, jussi.kivilinna@mbnet.fi,
        dbrownell@users.sourceforge.net, linville@tuxdriver.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Subject: [PATCH] rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request
Date:   Fri,  8 Jan 2021 09:58:39 +0000
Message-Id: <20210108095839.3335-1-andrey.zhizhikin@leica-geosystems.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [193.8.40.112]
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To DB6PR0602MB2886.eurprd06.prod.outlook.com (2603:10a6:4:9b::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from aherlnxbspsrv02.lgs-net.com (193.8.40.112) by FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Fri, 8 Jan 2021 09:58:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23fd21ae-34b7-4b29-ff4d-08d8b3bc0346
X-MS-TrafficTypeDiagnostic: DB7PR06MB5354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR06MB535452133C7D0DE0BCAE4804A6AE0@DB7PR06MB5354.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rj99BSIsNdqPs2cBO1iHxRUgbE/fOgTuxWN77MNome6LNpeLBdxnuVQ8+s3Dtvlomj4kSR2Utqbl2GLqgD3Zk+P2su7wIF28GEgJUI8olAx7tzTLal5UYWIjCE9sywSFtIJna+nnVGZcBkHC+FIIneykkThpssk/hV5B8n9AfinS9gnPgZHtOmxJb6qanf5lsDR1j/bHBnVsvR7dpv29Fh5Mijqs2gCCVLMFTUEK9m2Hqd6YcJ2j56T+oNTZsFyhsFDEm0wDbdNofqvyFg+VluctKOjqWyxFR90MVE6UqAwl0iDxMtzV5srN+Xn7pBC2KKgCs+Dw9oX116ai+VYqtlkdFZ5Wai4tmrQHOVEVPTqMVAEpDm2EFW9qWjZHgmsZHNVHKjHfuxeX1haLNJtWyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0602MB2886.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39850400004)(396003)(346002)(4326008)(2616005)(8936002)(8676002)(36756003)(956004)(6486002)(316002)(107886003)(1076003)(16526019)(86362001)(5660300002)(6512007)(83380400001)(186003)(6506007)(66946007)(66476007)(52116002)(66556008)(478600001)(26005)(6666004)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?02OBKWpkNGbg37PWdOHiBWCQW3DdRw7Dodd4ug8NdulTKbT/i4HLllW0Z/pF?=
 =?us-ascii?Q?BgXg++Y+ZpLYPgL38GfTXrDu2SPFL0sQPQ0flG/4rVCL9cEv2iCKPkB2d3/n?=
 =?us-ascii?Q?BYW0mEWd41gr06e9TGDVwmMFoNRjZiLs2eI8MeHpVfShFECo4BiiGGha4x6H?=
 =?us-ascii?Q?+wrWck6+Q6OVK/eVgbCVJjHVCbK2aNqv7qDD8d4Qj1TufZ3du8/qgJVMeTW5?=
 =?us-ascii?Q?gf8/obOQBQCjgrDmR/C/NrNK5WB85wYlc4/z/anlg8Pn3uiws/XJ7f1fINSN?=
 =?us-ascii?Q?DH3cXEumDzWuneUOLYsn90umtmYlcoX2PASInGOQd9gPgqX39Neo0DhswD6G?=
 =?us-ascii?Q?ueTqamVACvjD4T3KUYv6fsGoT23GViI/mJD+wGVXBubGiLbFAYQC6p2EjgWD?=
 =?us-ascii?Q?CCzdk5BQp7oLkED7UC7MmhAMF6jAI11JWOANFmEet2pO0apkfH3vyfEZJUqm?=
 =?us-ascii?Q?xrMFDvWWpbenzOFIyWV7NseH7yf4tLPEChon5xGUjNliRUsMRm0G6WUXKc6Q?=
 =?us-ascii?Q?ZPtSNB7jc7hYKdi4BpOxUfG45xUdKtm2XbSo+WT1lW9I5A+3l/rHYnS6LEBE?=
 =?us-ascii?Q?RJ8kLcfQQFZ27Rzp7UMqwvgw8W4jTUjHb0LE3dxpBMz1oAgKSiVGwmBJ0B21?=
 =?us-ascii?Q?nHiTvsjJc0aPxgj5fb4ftgLBhSnr9I7YuTJYDUSVqgAz6BZ6QIyY9aNrAIe6?=
 =?us-ascii?Q?N8PRFqAE8B6TRJ19aQpoTv6WKdH5hWbJOVjvRUA5W7hkGqmg78EdNB0gOjd6?=
 =?us-ascii?Q?1wlyUaFfpPMN3owPvCizte4761zH6BzPXNYt6NW1IZy9lMuhd+duAUH4+GUb?=
 =?us-ascii?Q?UA9MDgsrza+BbRH3Sv9+CPtGLdcLcANl5ZChk1a36MzxIgdrdXr5VLayGKBE?=
 =?us-ascii?Q?5t3RlmFzeSIwQ0ouVB88UFIhGngulDX23k8vnrs5IbxgjPtwo1l4TmHJuPqP?=
 =?us-ascii?Q?0b+8ocIFZbDntpwUF8uOqOt61oEBGAgXVa3A5lphcKqXoIBWhbiNo04URmJP?=
 =?us-ascii?Q?jhkq?=
X-OriginatorOrg: leica-geosystems.com
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0602MB2886.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 09:58:56.2593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1b16ab3e-b8f6-4fe3-9f3e-2db7fe549f6a
X-MS-Exchange-CrossTenant-Network-Message-Id: 23fd21ae-34b7-4b29-ff4d-08d8b3bc0346
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ysurkkUAsacbR4s9X8KpisMDtkiVkbJSSq2g/L0AirQkJ8ZgTruwAKcnK3PBG2KdPnYscQrXAgdTWCiTDZZWWdhR8YaAZJG90B+KL2t5UZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB5354
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MSFT ActiveSync implementation requires that the size of the response for
incoming query is to be provided in the request input length. Failure to
set the input size proper results in failed request transfer, where the
ActiveSync counterpart reports the NDIS_STATUS_INVALID_LENGTH (0xC0010014L)
error.

Set the input size for OID_GEN_PHYSICAL_MEDIUM query to the expected size
of the response in order for the ActiveSync to properly respond to the
request.

Fixes: 039ee17d1baa ("rndis_host: Add RNDIS physical medium checking into generic_rndis_bind()")
Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
---
 drivers/net/usb/rndis_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 6609d21ef894..f813ca9dec53 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -387,7 +387,7 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
 	reply_len = sizeof *phym;
 	retval = rndis_query(dev, intf, u.buf,
 			     RNDIS_OID_GEN_PHYSICAL_MEDIUM,
-			     0, (void **) &phym, &reply_len);
+			     reply_len, (void **)&phym, &reply_len);
 	if (retval != 0 || !phym) {
 		/* OID is optional so don't fail here. */
 		phym_unspec = cpu_to_le32(RNDIS_PHYSICAL_MEDIUM_UNSPECIFIED);
-- 
2.25.1

