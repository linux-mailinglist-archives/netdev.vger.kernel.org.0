Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05C75B1E57
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiIHNPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiIHNPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:15:05 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80093.outbound.protection.outlook.com [40.107.8.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E207A7FF9B;
        Thu,  8 Sep 2022 06:15:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dywdd1P52+erK5+/dP3r0AwQ+Y13G5TZCn4EzQ2U9G8xiryTD4tKJozmJ0H7oNqsOTVkX2yys7RLEK9jkd2C+qlH2x9q+EuplQAyf4RDkVf1myg1PGshreSQwZwIsScSBmzbey5wxdZGSTatrHDj9tT1pSTEokLO+7OIHWGz/YH+LCdKPEIw9kYyp/Rw96yZkZ33H7MmCygoujot40+RP2mjNUmG3fnn0LRz/AfhTOsPbpsY1J3SrtDz1bgnK0SRTr7LqV/VIe2e2f+gkTZIQn1Hx3EnA57QWvlIv25wCV1rekgnrtVpan45Df6qXGZqa57eDYU+A0Qiw8MZx1WphA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BCBtt2qtSjODTqNFT8cxpXDumwKClaSmMZ/1+byiYQ=;
 b=XnW+1KBhn5Af6cypliv8Rvx7Q3zUncXxCS/dl3L+BmaxyTPdW9pzDwH2xqYy26EM+3VTVOH6H3ZU5zamMx/5utU2fADGs4zctDLNjX7ECa6GR2Q8RzZ86n7GUWoMJldb3YxZwxhcuDP2K5bbKzNNchGJ1uWrRA6+nCz7yigpphp1n/3oWdHX/PKakdspMX3Jvp+qkzEInkA6X7SaemIp0U1nWyC6bZIHrpfVMeXc7+hp8qXfFC5ZnZo1nK5uw/8EFwfHepDEwLKbs6joD8mqgi1AKm9FveN2GvKjTWEFb7eFlpk6ECIYGZwW3Y4mgBBb9B0yZgPmSa6lWvGnHCZFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BCBtt2qtSjODTqNFT8cxpXDumwKClaSmMZ/1+byiYQ=;
 b=YrHyiYOt5JlxbvzmInJj648AVLv+4Go0v+jF7hiOWqCmyhS0CHPWPAVr0j5zpgSuraEtOCks6pkFLXgcQrKhRurHU8bItKZcGAUNevkDNPuJWXhybRafmng16RIbK8RgGsgrCaioVC8mecJ8PaoNBwM+gnJPjCHtGtv4LJPS1YE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by VE1P190MB0909.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:1b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 13:14:56 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb9:99a7:7852:6336]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb9:99a7:7852:6336%6]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 13:14:56 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        taras.chornyi@plvision.eu
Subject: [PATCH V2 net] net: marvell: prestera: add support for for Aldrin2
Date:   Thu,  8 Sep 2022 16:14:46 +0300
Message-Id: <20220908131446.12978-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::6) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4f1b55d-0fdf-454d-68f4-08da919c1fde
X-MS-TrafficTypeDiagnostic: VE1P190MB0909:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OMpoz5jaEHZOCQoFL0K6JoWEyBkqUnf2SFuBhbmWeVi19vC0/jwIR2M89VCvC3FYK8NK4gZVTyONFyssNBA29FkSj6Bv407foftrI64A8yLs9jWa2e2DtAXEb7bFa1ZQ6zz6WVBWWfRmyLLuNJFg2Q797m+0Bg9IJsSvdDPoIv+DJGuJbV5iVM7uZk0OCEJ4V5WVdAZl0MLW4bs0U3MUarZ/zG4Iwa8OVdV+jd492/6QVtQWcFzKaBRme+4pQtOAT1Uoz2DhCnszjGTZyXUJWffrnsy7sMUHKXhm9xac1wegjTSgEbtDsyyqcsfwNbPk5plk49F2McwWRdf7Opzwg+m7qznf5Zctqzn3zK3cEii2D8pOCbpQZ+YFeVTrYp0g2koCzR1GOgM0S0wRDrGN15s5gSos/TiRPbpGSiq8ONZlDiSnniVfkm60AVCPnK08RhfCK4RPuf5wMCM/q6ghiS/f115r7Tv3RPJ6LO3wbwsCD7E+95bpK/VeHkE4LVECEDyRuULEoVDeLUTHdLiun5Vs4n3bhhC+sLlZOfXwlok+xbdXoIkQ7HH0QEnyXoA3DD+RrurlTYgwAntRF/4c37ZthuD+G9/vi3xf+ClrHjNP1p4BSYg3+gvboRD7XF4Xo1HTwmDF8NiVPbNQyfkhA95Mgi+FQpOszY2+OR0T6CkcBqoR/Xx+3WbeUi4U1s1hunPtUWkxP5j6R0t2ck4qBI1XQI+Uv+5JQuuYOtnzpOyPHKrEs/zA9eovC1bUl0z9HItOWVSriNseCeRtQwwtmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39830400003)(346002)(34036004)(376002)(136003)(366004)(66946007)(66476007)(44832011)(508600001)(4326008)(8676002)(4744005)(41300700001)(8936002)(6666004)(107886003)(5660300002)(6486002)(2906002)(66556008)(26005)(6512007)(6506007)(52116002)(41320700001)(38100700002)(38350700002)(2616005)(86362001)(110136005)(186003)(1076003)(316002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qYzdgyzS+lYFT1Pe9TWS772aryj6KQZZkm+fD1zXrjKgvrsFJKQL/gdgYrYS?=
 =?us-ascii?Q?9Lbr4cqKLcgrRMAo1iB/uqsVjDwkHTxGzG+2YnlUx0F58Q30Fgd8JI2czHpT?=
 =?us-ascii?Q?R9dpIbLODSHrmZZh9Go3h863bx5SsZcV1XpjTLm41rjbvijrI9VZzwV5ZTD9?=
 =?us-ascii?Q?FcByyMhAP+SL70rY8ztdxMjirpfDovlfYt+0t0GPVJCoC9mJmrY5DThDTFvO?=
 =?us-ascii?Q?mSJnnlRFrcvZ7F2nTz+2nF1xf2akZtq5cBmI3a788vhU5feuf/1YRjmLK+Wa?=
 =?us-ascii?Q?UUIHTzKe88TYJwWfO78nD+VwjtunpyYNLwhPs6R0itj6alUqzuwlxovqg4Sr?=
 =?us-ascii?Q?rsBcXPfW9IzYrvLYobqOEELOW/SjBbgo3fy++Ae1MLXrPAE9WCHjVgxArL+y?=
 =?us-ascii?Q?ohssSAG7tInFsGxJw3lXtOxJe0be5R/KDK5t45YhlXNu2Q9Hhxm7/nfQlST2?=
 =?us-ascii?Q?q3RuB9+LhPTZoFAAX6CLt8A1hiYgPwcEgSlVQmu+lm2ZHatLWmy0fYZneD1n?=
 =?us-ascii?Q?PK5EHNz+OJsKTNZd8aA//uHlGzcO6e+myy/QaWgOqpATHnW5GAfMCt/idNkv?=
 =?us-ascii?Q?irxFn3p8ERKRUxQtd1TaSb2q13+MJCTcUeJTHcfHlVDn1K4r+1RJifIfX0fD?=
 =?us-ascii?Q?Q1zcN/C7s5PimV+fij/sQITmbFsgxLF2ewAoRrPasczy72+pCsWVDaT13bDJ?=
 =?us-ascii?Q?RtXBlePigrvsw6VPF+/CINwf8hKsNID4caiyERylF10jA+Ujx9h5hgGCFuEV?=
 =?us-ascii?Q?rX+0/K/1DIrmgxD6uyweZqlaq0VY2wE2yUUedfdYaE/Yi3GZPRmPkJUdaNAi?=
 =?us-ascii?Q?9nJ2P7cneEFjYbjarKfsk7Ycp2W8Tl+LRFBR1/AZPmYvN2+dA/Xau0aZ9thg?=
 =?us-ascii?Q?9DLW0jJ75hcuoTEafG2Lnr4RyUlltU7NCFUh2vtqOn5MLO7jcL2/ni+KxM2t?=
 =?us-ascii?Q?H0TZeSHB1nN1Sz59s5pcyW1pxgaNokVu/qwJzJiRbkNzNM/EvqYenw6PcOti?=
 =?us-ascii?Q?rZICH/M/GIvOzlsh9I8SrWLkaItk4NLIWDHNl/27XF75jlo24HndbB7uOUFc?=
 =?us-ascii?Q?urynZTqxQUErAHMK3IgrgLuIhSATA7aM/kDWTnyXb+CQ2sUAfZkbdnXRsP5i?=
 =?us-ascii?Q?5szpdvcNc0X+R4S4NKfx4d/LMzDie5uXmznDwHFkOmium2QNEOeAzPgHFLPL?=
 =?us-ascii?Q?u51ke9gNRWvUF3+HnuyIKBza2sR9CDulL161kuMmDeRESijOKv212GivgZDL?=
 =?us-ascii?Q?CfiZltYhesAmbI860ipsW7++enLrW7t7/p3W+91FloBE1mb6t4XPtwciLt28?=
 =?us-ascii?Q?/MBHk2rmWFfR+qpndhsU4GKO5UG+ULvXzJ9grR8Ufgn+QSMGKsVT4+6/kAZz?=
 =?us-ascii?Q?ISEBWdJgSMauRFOAbmYaews1Zmn7TQih9e3HvIwzaKvjnBeU2hyFbZvi4Vxo?=
 =?us-ascii?Q?ntJ0m8Hr5UEqV9jENC9OHWMNhRIBv7CUPBgQSvgbjyzHV75gPRpjNOltr0gD?=
 =?us-ascii?Q?Au4ulSbk21klZUv0FZYdrYqqpF7etaHA6YMSK39zSwfTOPJUgWxPmCi7QD9Y?=
 =?us-ascii?Q?uzSabp98W3duPnx413WiaPL0A4Je1BkpiJEAVF1Scu40HPekOVbufolP7xgP?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f1b55d-0fdf-454d-68f4-08da919c1fde
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 13:14:56.4285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egScB0DyQWJOpu2J1Zcis75S5Ntpu1T3Z85OW8NkouAnjSsLsPqSBUR81y1TJRgGBsLLazePPY1bZ+CmmTb7WKkMWZVpNErE6RGy6VD7wYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P190MB0909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aldrin2 (98DX8525) is a Marvell Prestera PP, with 100G support.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

V2:
  - retarget to net tree instead of net-next;
  - fix missed colon in patch subject ('net marvell' vs 'net: mavell');
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index f538a749ebd4..59470d99f522 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -872,6 +872,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xCC1E) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.17.1

