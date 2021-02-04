Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4395830F423
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 14:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbhBDNrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 08:47:17 -0500
Received: from mail-am6eur05on2059.outbound.protection.outlook.com ([40.107.22.59]:15616
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236451AbhBDNqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 08:46:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRjLsh6+0j5ijDqi2FBNS/B6VQz8LAQeyVgw3Mt7a7Ivu68I5+xiDGGajdchFBtk8IcjQbgzNvJRJkafjXUlFu8PFvlUXvxtCAkG9+Fo0yvK78sURR6M3npyZfzqsOs00+Ck5o/CO11rnyIiZfbmISgPQ/i66gBdIP25haAgFlE0wbYLJKpXg9ujM4gMIWjLR/uI6B5ntewDLGuHGqhaSfQuKAlKNU07N+7sSlEklVim7GhWmspCgmTMIFBmvDUt39ZusGHH8HL+ynolLPJqsaSmAemNDPM5oNhHVTrEQguFurK0UaTfT0wOcJ9gEwyijQzl9xejtTlNHUPwIYJDoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LBeUPzAacBKC4HkhY6lXYHtYSvSbyvbQXjwrrJ04h0=;
 b=I64GYn/1hdlvCtrvYMQY76KeBfuGBbaeO1d/7cSVGBIVnGiD0STOeIzvB6CwbzPsQBmHCv3T2jDvlS3wfFobb22D5dc0URN+y2WumXXdjPwznOgAD5YUiQhcGBNpwjxdW2cGsNZJxvzm+iU78p2RiqCE6byVxXYZjVVQr8Hc7csofvvUz7k5BorcOnLoFZLJ4VnQ4v/kuqrCqUg+w9SWF44GHwxVVbdPuWvxoP2g2xH5Dl0du6SDE+2X+QR0dFHqZ5y65K0A9x3Iiqh9NwkVu3Ci+LJ9QTw1kWuOti+u6IZLzWQm58JGOHAS+WZv4mabc8QJATnUrE65DplGBYe2OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LBeUPzAacBKC4HkhY6lXYHtYSvSbyvbQXjwrrJ04h0=;
 b=IMhsLix9f7wD6TIWdaquUvHIkV9f6n815hBRLFvJiY7lsP6DKo7KW9Dw706k43zy+wO9tAUTKXhdREOgzYYEBs31rFzDN+1vrr18sAIddoySoZLGkrdDBf3Jwf85X+2OfNiedlDxBnvgKBgF/rJ2HKZQcekB08rPo/B3cxsuTdE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 13:45:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Thu, 4 Feb 2021
 13:45:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: [PATCH net] net: enetc: initialize the RFS and RSS memories
Date:   Thu,  4 Feb 2021 15:45:11 +0200
Message-Id: <20210204134511.2640309-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: AM8P192CA0007.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by AM8P192CA0007.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 13:45:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a85830ab-4569-403e-3e0d-08d8c9132848
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28628EED2181731D74C6BD98E0B39@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /emr+iAuvsGPxQqcbs6mhmJgNndUZGPK2va3O1duOGgII+7JuMbLZzEADTCZe6EFnMTGyNOMA4W/7fDe0I8ehPg6wKNGxaujkYt1MElOc7HxojcwxkLAgLD3r6/IZcaRhFxC9ato3VSvwNzxOtIAYaicHmtCfHp5dptbgik2qm1chPXtJstxWIirWZaT+XYMwnqqLpK9KgXj1zaIypqy8A1OVvcGtDOzkFCSp2hADL3qo854sWHDSQ73m+krut7n9bEV7XjW0UqSbr4pVnHAerBvxj12gMS3Onsae/nPH8VqH0QVrCyxkqB6x6EZebQY289SU2q4VrLqf6iS1thepj7OQdurXAtrnw7NnA7TQZljT3Kf35rWY8NTbQSq5HwLC51K1JvO1M7SzdkSAubkJk2brtxDl4BNPhL8/DQoiHyMVJ06Sr4bJTkwxV11c/yE9ybFZQ4yWCRhe6XffqsB4gcb6tWuO/6Y0Mh38odQKZET+dxeC6CeoopwwxhrcTxeUqt1b7dee3oal6dZ7DIThmibsTRxqT+cr6bN97U6231AlIfMCCeT+dZ8xJusNiclALNy2GLqO2Y6iAaSezhLMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(54906003)(86362001)(316002)(6666004)(66946007)(1076003)(52116002)(110136005)(36756003)(2616005)(2906002)(186003)(16526019)(8936002)(66476007)(66556008)(6506007)(6486002)(8676002)(26005)(6512007)(956004)(44832011)(69590400011)(83380400001)(478600001)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nnYIQ4GEJ0zuSUufK+7m/ms2vivnJjeomeSnWz688hnKAN5LNNj5hBrKj/3H?=
 =?us-ascii?Q?5ZIgnQ0KS30vfh8PbrA1gSLLwQLibRsO/B7uC/NKn3F+wSdFVKBXk6dnBg66?=
 =?us-ascii?Q?b5gVo1R4Ujm5AHGgGNzB1bx0hUqy4PGIlW8IrFsgzjCtqt95TZai0W3Ke/aP?=
 =?us-ascii?Q?NHRVshp3qFVFQetZjExsngPRki0ruAqd5vPQZNkEEf9olTIgofJXvBbsUdUz?=
 =?us-ascii?Q?Kgr2O4L/tCX0xV4OTqBziJO7vb6oB5XJSFjk8qKJG5vpMvsTxb5YyScb/HeA?=
 =?us-ascii?Q?LK5Q0adh7zE/ypq/wrHmsxhwDG7kRpOPF6mCy/O5Hk6OM62ZtHE3erSxXEh5?=
 =?us-ascii?Q?RI/kONKbTu332iGyttONTvqK60sAvdQq91EEwOFwwZokmbuRpNcHtvOCsmqI?=
 =?us-ascii?Q?hsM8m7gwYxudXePmyVOI+s8fCCUqwl/i+he4E1WlPG9xzwSaiZVT0r5vEsld?=
 =?us-ascii?Q?D3MSxPHw1wQdLSP4Q49Mucda7CpL25MIwhg+zp2GGEfe7Xs7msm5pEOow5kS?=
 =?us-ascii?Q?xm1LnIuIsigdB11bVSRNINLkKxekZmD/0RpM+hBrA39CRfEsHduReZCiU2iQ?=
 =?us-ascii?Q?YrBfmMR+yfjv2PC7bv+Nx0NAMahDS6xefda5KZFJdps+PijLUus5n/Yi4im0?=
 =?us-ascii?Q?xK3dxBHsasersx9Q4aKTqMLKPcg/R8N8gp1VCFYPzlk8EqkLIWQyL9fmbcf8?=
 =?us-ascii?Q?c4VaRCULBCRXBurSEQXiPE+nHTKw+Zgh0Mu7onny3rc5jaEWcPdgnk8pW8TE?=
 =?us-ascii?Q?Gn5+FX0L5fUmVC+i3B00F1t/SoFifNjpW6i+pZLu930tCZN94HOMJYV8LTv1?=
 =?us-ascii?Q?b0sHnV8R+wc6Ux//GpjhfINK0OupIyh+OErawG+VJHVPg1TjQXqqfwgaXjxv?=
 =?us-ascii?Q?MXWOg0VSgsLnfHeZZL48K9kYifH37B9XboTeOfn0AQWhHnJ4WJ0MiJAwodag?=
 =?us-ascii?Q?ha/wlSDeIAy3SjEcAhYYw6a1liKY9zCo2hQprUSGV9uHvrrhU69H0by2s5yv?=
 =?us-ascii?Q?DYDVm2k/bPdP+KltlwX0NufuIxS+mgpkxxvQpykj6BX1zipYId+seSLw1P4h?=
 =?us-ascii?Q?/MqPhkFS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a85830ab-4569-403e-3e0d-08d8c9132848
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 13:45:39.3498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KepNXDxAFZSDVMxrhtBkNT5bQ24MhYCEIrcukvFXVHk2RA60USb3Ad3vsmfwKgi9JwV0z5OXnPNoUMDiuzpK+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael tried to enable Advanced Error Reporting through the ENETC's
Root Complex Event Collector, and the system started spitting out single
bit correctable ECC errors coming from the ENETC interfaces:

pcieport 0000:00:1f.0: AER: Multiple Corrected error received: 0000:00:00.0
fsl_enetc 0000:00:00.0: PCIe Bus Error: severity=Corrected, type=Transaction Layer, (Receiver ID)
fsl_enetc 0000:00:00.0:   device [1957:e100] error status/mask=00004000/00000000
fsl_enetc 0000:00:00.0:    [14] CorrIntErr
fsl_enetc 0000:00:00.1: PCIe Bus Error: severity=Corrected, type=Transaction Layer, (Receiver ID)
fsl_enetc 0000:00:00.1:   device [1957:e100] error status/mask=00004000/00000000
fsl_enetc 0000:00:00.1:    [14] CorrIntErr

Further investigating the port correctable memory error detect register
(PCMEDR) shows that these AER errors have an associated SOURCE_ID of 6
(RFS/RSS):

$ devmem 0x1f8010e10 32
0xC0000006
$ devmem 0x1f8050e10 32
0xC0000006

Discussion with the hardware design engineers reveals that on LS1028A,
the hardware does not do initialization of that RFS/RSS memory, and that
software should clear/initialize the entire table before starting to
operate. That comes as a bit of a surprise, since the driver does not do
initialization of the RFS memory. Also, the initialization of the
Receive Side Scaling is done only partially.

Even though the entire ENETC IP has a single shared flow steering
memory, the flow steering service should returns matches only for TCAM
entries that are within the range of the Station Interface that is doing
the search. Therefore, it should be sufficient for a Station Interface
to initialize all of its own entries in order to avoid any ECC errors,
and only the Station Interfaces in use should need initialization.

There are Physical Station Interfaces associated with PCIe PFs and
Virtual Station Interfaces associated with PCIe VFs. We let the PF
driver initialize the entire port's memory, which includes the RFS
entries which are going to be used by the VF.

Reported-by: Michael Walle <michael@walle.cc>
Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  2 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 59 +++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index e1e950d48c92..c71fe8d751d5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -196,6 +196,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_CBS_BW_MASK	GENMASK(6, 0)
 #define ENETC_PTCCBSR1(n)	(0x1114 + (n) * 8) /* n = 0 to 7*/
 #define ENETC_RSSHASH_KEY_SIZE	40
+#define ENETC_PRSSCAPR		0x1404
+#define ENETC_PRSSCAPR_GET_NUM_RSS(val)	(BIT((val) & 0xf) * 32)
 #define ENETC_PRSSK(n)		(0x1410 + (n) * 4) /* n = [0..9] */
 #define ENETC_PSIVLANFMR	0x1700
 #define ENETC_PSIVLANFMR_VS	BIT(0)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index ed8fcb8b486e..3eb5f1375bd4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -996,6 +996,51 @@ static void enetc_phylink_destroy(struct enetc_ndev_priv *priv)
 		phylink_destroy(priv->phylink);
 }
 
+/* Initialize the entire shared memory for the flow steering entries
+ * of this port (PF + VFs)
+ */
+static int enetc_init_port_rfs_memory(struct enetc_si *si)
+{
+	struct enetc_cmd_rfse rfse = {0};
+	struct enetc_hw *hw = &si->hw;
+	int num_rfs, i, err = 0;
+	u32 val;
+
+	val = enetc_port_rd(hw, ENETC_PRFSCAPR);
+	num_rfs = ENETC_PRFSCAPR_GET_NUM_RFS(val);
+
+	for (i = 0; i < num_rfs; i++) {
+		err = enetc_set_fs_entry(si, &rfse, i);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
+static int enetc_init_port_rss_memory(struct enetc_si *si)
+{
+	struct enetc_hw *hw = &si->hw;
+	int num_rss, err;
+	int *rss_table;
+	u32 val;
+
+	val = enetc_port_rd(hw, ENETC_PRSSCAPR);
+	num_rss = ENETC_PRSSCAPR_GET_NUM_RSS(val);
+	if (!num_rss)
+		return 0;
+
+	rss_table = kcalloc(num_rss, sizeof(*rss_table), GFP_KERNEL);
+	if (!rss_table)
+		return -ENOMEM;
+
+	err = enetc_set_rss_table(si, rss_table, num_rss);
+
+	kfree(rss_table);
+
+	return err;
+}
+
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -1051,6 +1096,18 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_si_res;
 	}
 
+	err = enetc_init_port_rfs_memory(si);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to initialize RFS memory\n");
+		goto err_init_port_rfs;
+	}
+
+	err = enetc_init_port_rss_memory(si);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to initialize RSS memory\n");
+		goto err_init_port_rss;
+	}
+
 	err = enetc_alloc_msix(priv);
 	if (err) {
 		dev_err(&pdev->dev, "MSIX alloc failed\n");
@@ -1079,6 +1136,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	enetc_mdiobus_destroy(pf);
 err_mdiobus_create:
 	enetc_free_msix(priv);
+err_init_port_rss:
+err_init_port_rfs:
 err_alloc_msix:
 	enetc_free_si_resources(priv);
 err_alloc_si_res:
-- 
2.25.1

