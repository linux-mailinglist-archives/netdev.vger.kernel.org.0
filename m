Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA873623684
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiKIWZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiKIWZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:25:40 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2135.outbound.protection.outlook.com [40.107.22.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330E140C1;
        Wed,  9 Nov 2022 14:25:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmxdJpsCmwVc8D0LgOXhpKgrlegAmjzEmGnSKgjiBvYB1muz2XCCLzKQ46PMqh+oU59cDyx9GdJSO0uhI2XbahE0+30Qe86u7xf7bAX4Hp3X7o/IqXmImFRmmhWZr2aHMzSTQI5OkylY52m2qnfRzFWGksrjCB7uTU377GFxPyH9ZNoXDg3Dsh9Wm4FPDaPsBemTYt7h/nhD3w2X03K7Qkk94uTXERAFsY6jvvTEKLvZ3wJCSEgy88suqwjq3txSEErQtIVt00Y6Ay3Yqy4wxilF2GoN/nHO/BR/cZkMeqRvIhs24Hhb5V7voTDaDRbKzjACKmsQjf36F9Bl+kqtKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4yE27jOdHK/kEzOnjWCeuQDmM4vKvfDskK4eScBgWk=;
 b=AgpXMkVqP/MFWO5kWa7yStE2b8NhaMiGjX+PApswNwgfpsyAP1w6i18UG2Vo6eOb6KUuUTtCFohVlPTPoB8aQdJr0FswR8H3ktle0tRQf4Zny0DO0tN3oZgdh/1cSx6IDguNLCnjsiNe21bekTIb7gcufZQDY3DsjhMgXpUHi836bE46Q89+mNLpWxuvnBURgv1OluEt31G2TLDALk3nchdWxlAIuY8WoctsGF3LYk98Mn9SlkQTJnB+aoxaP/kIbuV1QtVjz0SChNzB2ueMAy6oI6k9gKyPtLGFJO28E6VXT9EAebJyQqbxAQqGNCmfbGeh0Piq3/VGVGaKD/wLHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4yE27jOdHK/kEzOnjWCeuQDmM4vKvfDskK4eScBgWk=;
 b=woaSrWDeyDqrWopruUxoez6djAI97d5YMqoX8v/HKD3t3rY6j6wu1pHR1Lxo+ZJt3Eucgl058ZlC4sNbwi66Nd/i5+i70XAfQiu9RTjSB2XG6coPvR3fmbAPWB+s/wcuXT6E1GMLEmxNCaEj7qLRbcejtOYJR1Tnvi9YbwhkU6U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DBAP190MB0950.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 22:25:37 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87%4]) with mapi id 15.20.5791.022; Wed, 9 Nov 2022
 22:25:37 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        maksym.glubokiy@plvision.eu, vadym.kochan@plvision.eu,
        tchornyi@marvell.com, mickeyr@marvell.com,
        oleksandr.mazur@plvision.eu
Subject: [PATCH 2/3] net: marvell: prestera: pci: add support for AC5X family devices
Date:   Thu, 10 Nov 2022 00:25:21 +0200
Message-Id: <20221109222522.14554-3-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221109222522.14554-1-oleksandr.mazur@plvision.eu>
References: <20221109222522.14554-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P190MB2019:EE_|DBAP190MB0950:EE_
X-MS-Office365-Filtering-Correlation-Id: 347273be-4976-43ed-4d5a-08dac2a15339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NdtlPst+hVXReElUztkUuY3qcnrXr+i9L5xpqUGG3T8cFmae5dqoTfR2eBWARq55JzAN1xzqbMKdHV/WDA5gXfv8BXAJ1G/kPgROjEy4kDYGzqAhnB8Lka8nFCXwZqZJSqtijdcV8dbq4Js/sdK0YvgUIKytI+7GvANS3UAZJ0mOk1Neg29Lc+I4qKktyt3XjysudwiVx2bChV/+O+/hFHcyj6CQB6tnhiHuGxDIU63Va+MV1ee0w9FyyYIQLpu+GVG9ofjk8qwV8lCvT7EDYBjMm16vmUWfKikEVXkLTk9OZYBAlNQrdAUQD3O/XLpAsz6NJPCnu4Tmhon2OTx4sZWvlyoROAVxhFa1Dka0rLlOWojbRWK7JJCbhglux+YfVPNd1vleVeL877cSDCy5+Xl1YtprLMDFl+pSaySwWqSaNqJAcT9afxfru8qmJF6uAhgXDUDXkomGuoKuOPclBwJNm6Thgj+PQ7QLJ26m2G0Nzn6JUkKoBAsfG3C/34KsdXRPuIttvEf6yImhoLj9U7oVOXwh9zaoD4Hna/CP8xifTr6SxyOJpLVQsR/idPk9UH02fs//bTptyGxQfVUXz/ovORrCRSjn1mSNf7yhpYxGwaZFKf2JVDWUwagdcNWpmrfkkWN4UKpPX3RKV7c9WXELgCOvFLYSH6AUO9ZkFtk6yYMFA5lyGjDasA2Ek8H9N7/9h+4Hmdn7XqI/1li+OoUtQDPv0VAgObub9iSOA268DO5QJZiPjES3Ykc6zPvyVhFd4P1Xyn0hBr27UBzNrsW9PuTz4pH/qnBjsv7ialk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39830400003)(34036004)(346002)(376002)(136003)(366004)(451199015)(6486002)(508600001)(6916009)(41320700001)(6666004)(107886003)(316002)(8676002)(38350700002)(52116002)(66476007)(4326008)(66556008)(66946007)(26005)(38100700002)(6512007)(86362001)(6506007)(8936002)(36756003)(5660300002)(2616005)(186003)(1076003)(83380400001)(44832011)(41300700001)(2906002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jeJRCfcYNd0LG2pgEwijfvylzMiF4HbBwVHkUsMax3eFekwBomeu5XsxE+0h?=
 =?us-ascii?Q?MsH0G73nyYMmKkrmxXsvJxqdTR6AUK/j8isgEx6i+5IACBerF31MWTODiUao?=
 =?us-ascii?Q?91GD3lGzvagtm/qdWNErPvhhnlrvEDbPHLzr9mGqe/LtaOshVHbWLU62X6LS?=
 =?us-ascii?Q?/f+Xp0PUkM/LTrYUPiwCt/+amvadtqr0WWnnm87G18NIE+TWRP++WxRxxzCJ?=
 =?us-ascii?Q?LH49BVG2mVoiO/vBRcmPxugJ3ULE0sZ/FTq1qy59a+/knyWGbo70hZxO+btR?=
 =?us-ascii?Q?sc5xVZ1rJ6fU9IH+WJ0llMLmrsR3DPMWBJFcqNSNXQNJeu/LhS2HxLNlwnOI?=
 =?us-ascii?Q?+8BLiO2g8Sdlxz3GFI8wAQMkqK2GCPau9GKms1410JtgPTk9WfkU7kMsOogE?=
 =?us-ascii?Q?2ioUA14DwOY+pdEFsduBaad/P8o9ndPDODIGFVYk+SQTCR1dHuz3NRseNvgv?=
 =?us-ascii?Q?ZspAFfMGUWClB9KJ4zVxuqH47s0XlpKuaESDdj2UaTtivpZmQXBFJ8rXmkpC?=
 =?us-ascii?Q?aZztXtx5c5SIpgNOY35MuI5LNS4+V6hm/3JINjfOJDvZkK3oLpRo8GwPLh90?=
 =?us-ascii?Q?kdzbpLAXx9L2xpPGHTDmkX4pGjKHv8PWaqCXpDtsqWuRAqxd226PLJxRJOmD?=
 =?us-ascii?Q?P4XZ8qbUdCO/XIF/5Ww/OE7ilYUU55OHiQDVy0/QdqUyzpC3sBNjcoG9fkCi?=
 =?us-ascii?Q?Nc5U0yYSD8H2fijhIXBJFrpsFdrCodaSjUHr9SxydiDPsB2Pwhxv+q+dl632?=
 =?us-ascii?Q?0dPobcAqyTv0kNqRiL11Kfoe3/Cvv0Qk6l09uQrumggOlemb3u0zHQooUJYl?=
 =?us-ascii?Q?p1UIuftXdTlGDbMk6p1di1/XFHN/nfLze+eLpPW7HhxdHgpmH2tl4xC7cNPG?=
 =?us-ascii?Q?As7trpt+/DrGKz7OgaK8c019BKSvcRpbXVLdO+lkdLzkH8Zm2op2+3AFC3GP?=
 =?us-ascii?Q?+QEgmtlEfUlgI7EN0WjwkL43j5h8r43FqHiU6GprEWam4EqiBPsu2j0ofSyF?=
 =?us-ascii?Q?qsuohZAm1A9bD0gA7+rqQcbJUhf95Vv1WwCL8H2KDTFZxvyRvFko+xH31PgR?=
 =?us-ascii?Q?zdctUcHe9Z/oxIotJ1ja4TBfRXaToIGwirI6c0C7XQloST0P/BWn+XMRuBwR?=
 =?us-ascii?Q?buYNUn/bYfijQyhrvC0NeJZ+otInWTr3CtSS7c5vUyeDEUxAv3fpot2c144s?=
 =?us-ascii?Q?GyspBfMdEd/s0pMNnREs+V4f6hon7F5DlPOmPTApWSU2qfiZc/cCZ01VY74M?=
 =?us-ascii?Q?OMUIyOEBvb7lrwsIOnjYJDA3Hoeg1kT5/ZCJ6DKo5LrFmfzWjd0ZnMPHlU48?=
 =?us-ascii?Q?+5uHm9B+KTYbgFlrdbz+0FTAi3iwptOZe5Q79UnlSWpr5IxRBfMveoied13c?=
 =?us-ascii?Q?2KnyOKjBO+Ay5Z+08WpyV1IIqCzm5K9L5hTJm+xNWnDAq9alCAFZWzW9Sx0j?=
 =?us-ascii?Q?zQeVJmF8veNHvMERQvfLOAx3228GxTmXu99Y3PbonxagNvHMb7TIJ3XM40ug?=
 =?us-ascii?Q?w5UoAyNsv6jZH9+fi55bsA/t8Td6q5IgDA/3aGoCnIIAsypUTYHPCJ7CQj1j?=
 =?us-ascii?Q?AtqiQKNrHc6M14yG8pRROMY68Iodsmr5qcGDheFVOimP6PqpzrcQhdvThdyJ?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 347273be-4976-43ed-4d5a-08dac2a15339
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:25:36.9696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJOBrbPG/o/l5Rdkd6mBZ4O2ryhqlHF+fJBke9ZS8M5ycQz4xtNxc9NyCXHCyywanMbVYPJzatTn+z6zKDmYIcAYzhzCHOpw3ZyakL/mNc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAP190MB0950
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maksym Glubokiy <maksym.glubokiy@plvision.eu>

Add support for the following AC5x Marvell Prestera PP family devices:
  98DX7312M (12x25G / 8x25G + 1x100G);
  98DX3500  (24x1G + 6x25G);
  98DX3501  (16x1G + 6x10G);
  98DX3510  (48x1G + 6x25G);
  98DX3520  (24x2.5G + 6x25G);

Known issues:
- FW reload doesn't work (rmmod/modprobe sequence).

Co-developed-by: Vadym Kochan <vadym.kochan@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_pci.c  | 107 ++++++++++++++++--
 1 file changed, 97 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 14639966e53e..9475499069e6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -21,6 +21,7 @@
 #define PRESTERA_PREV_FW_MIN_VER	0
 
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
+#define PRESTERA_FW_ARM64_PATH_FMT "mrvl/prestera/mvsw_prestera_fw_arm64-v%u.%u.img"
 
 #define PRESTERA_FW_HDR_MAGIC		0x351D9D06
 #define PRESTERA_FW_DL_TIMEOUT_MS	50000
@@ -187,6 +188,11 @@ struct prestera_fw_regs {
 #define PRESTERA_DEV_ID_AC3X_98DX_55	0xC804
 #define PRESTERA_DEV_ID_AC3X_98DX_65	0xC80C
 #define PRESTERA_DEV_ID_ALDRIN2		0xCC1E
+#define PRESTERA_DEV_ID_98DX7312M	0x981F
+#define PRESTERA_DEV_ID_98DX3500	0x9820
+#define PRESTERA_DEV_ID_98DX3501	0x9826
+#define PRESTERA_DEV_ID_98DX3510	0x9821
+#define PRESTERA_DEV_ID_98DX3520	0x9822
 
 struct prestera_fw_evtq {
 	u8 __iomem *addr;
@@ -205,6 +211,7 @@ struct prestera_fw {
 	const struct firmware *bin;
 	struct workqueue_struct *wq;
 	struct prestera_device dev;
+	struct pci_dev *pci_dev;
 	u8 __iomem *ldr_regs;
 	u8 __iomem *ldr_ring_buf;
 	u32 ldr_buf_len;
@@ -693,6 +700,20 @@ static int prestera_fw_hdr_parse(struct prestera_fw *fw)
 	return prestera_fw_rev_check(fw);
 }
 
+static const char *prestera_fw_path_fmt_get(struct prestera_fw *fw)
+{
+	switch (fw->pci_dev->device) {
+	case PRESTERA_DEV_ID_98DX3500:
+	case PRESTERA_DEV_ID_98DX3501:
+	case PRESTERA_DEV_ID_98DX3510:
+	case PRESTERA_DEV_ID_98DX3520:
+		return PRESTERA_FW_ARM64_PATH_FMT;
+
+	default:
+		return PRESTERA_FW_PATH_FMT;
+	}
+}
+
 static int prestera_fw_get(struct prestera_fw *fw)
 {
 	int ver_maj = PRESTERA_SUPP_FW_MAJ_VER;
@@ -701,7 +722,7 @@ static int prestera_fw_get(struct prestera_fw *fw)
 	int err;
 
 pick_fw_ver:
-	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
+	snprintf(fw_path, sizeof(fw_path), prestera_fw_path_fmt_get(fw),
 		 ver_maj, ver_min);
 
 	err = request_firmware_direct(&fw->bin, fw_path, fw->dev.dev);
@@ -778,22 +799,56 @@ static int prestera_fw_load(struct prestera_fw *fw)
 	return err;
 }
 
+static bool prestera_pci_pp_use_bar2(struct pci_dev *pdev)
+{
+	switch (pdev->device) {
+	case PRESTERA_DEV_ID_98DX7312M:
+	case PRESTERA_DEV_ID_98DX3500:
+	case PRESTERA_DEV_ID_98DX3501:
+	case PRESTERA_DEV_ID_98DX3510:
+	case PRESTERA_DEV_ID_98DX3520:
+		return true;
+
+	default:
+		return false;
+	}
+}
+
+static u32 prestera_pci_pp_bar2_offs(struct pci_dev *pdev)
+{
+	if (pci_resource_len(pdev, 2) == 0x1000000)
+		return 0x0;
+	else
+		return (pci_resource_len(pdev, 2) / 2);
+}
+
+static u32 prestera_pci_fw_bar2_offs(struct pci_dev *pdev)
+{
+	if (pci_resource_len(pdev, 2) == 0x1000000)
+		return 0x400000;
+	else
+		return 0x0;
+}
+
 static int prestera_pci_probe(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
 	const char *driver_name = dev_driver_string(&pdev->dev);
+	u8 __iomem *mem_addr, *pp_addr = NULL;
 	struct prestera_fw *fw;
 	int err;
 
 	err = pcim_enable_device(pdev);
-	if (err)
-		return err;
+	if (err) {
+		dev_err(&pdev->dev, "pci_enable_device failed\n");
+		goto err_pci_enable_device;
+	}
 
-	err = pcim_iomap_regions(pdev, BIT(PRESTERA_PCI_BAR_FW) |
-				 BIT(PRESTERA_PCI_BAR_PP),
-				 pci_name(pdev));
-	if (err)
-		return err;
+	err = pci_request_regions(pdev, driver_name);
+	if (err) {
+		dev_err(&pdev->dev, "pci_request_regions failed\n");
+		goto err_pci_request_regions;
+	}
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(30));
 	if (err) {
@@ -801,6 +856,26 @@ static int prestera_pci_probe(struct pci_dev *pdev,
 		goto err_dma_mask;
 	}
 
+	mem_addr = pcim_iomap(pdev, 2, 0);
+	if (!mem_addr) {
+		dev_err(&pdev->dev, "pci mem ioremap failed\n");
+		err = -EIO;
+		goto err_mem_ioremap;
+	}
+
+	/* AC5X devices use second half of BAR2 */
+	if (prestera_pci_pp_use_bar2(pdev)) {
+		pp_addr = mem_addr + prestera_pci_pp_bar2_offs(pdev);
+		mem_addr = mem_addr + prestera_pci_fw_bar2_offs(pdev);
+	} else {
+		pp_addr = pcim_iomap(pdev, 4, 0);
+		if (!pp_addr) {
+			dev_err(&pdev->dev, "pp regs ioremap failed\n");
+			err = -EIO;
+			goto err_pp_ioremap;
+		}
+	}
+
 	pci_set_master(pdev);
 
 	fw = devm_kzalloc(&pdev->dev, sizeof(*fw), GFP_KERNEL);
@@ -809,8 +884,9 @@ static int prestera_pci_probe(struct pci_dev *pdev,
 		goto err_pci_dev_alloc;
 	}
 
-	fw->dev.ctl_regs = pcim_iomap_table(pdev)[PRESTERA_PCI_BAR_FW];
-	fw->dev.pp_regs = pcim_iomap_table(pdev)[PRESTERA_PCI_BAR_PP];
+	fw->pci_dev = pdev;
+	fw->dev.ctl_regs = mem_addr;
+	fw->dev.pp_regs = pp_addr;
 	fw->dev.dev = &pdev->dev;
 
 	pci_set_drvdata(pdev, fw);
@@ -858,7 +934,12 @@ static int prestera_pci_probe(struct pci_dev *pdev,
 	prestera_fw_uninit(fw);
 err_prestera_fw_init:
 err_pci_dev_alloc:
+err_pp_ioremap:
+err_mem_ioremap:
 err_dma_mask:
+	pci_release_regions(pdev);
+err_pci_request_regions:
+err_pci_enable_device:
 	return err;
 }
 
@@ -871,12 +952,18 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 	pci_free_irq_vectors(pdev);
 	destroy_workqueue(fw->wq);
 	prestera_fw_uninit(fw);
+	pci_release_regions(pdev);
 }
 
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_AC3X_98DX_55) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_AC3X_98DX_65) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_ALDRIN2) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_98DX7312M) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_98DX3500) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_98DX3501) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_98DX3510) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_98DX3520) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.17.1

