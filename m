Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0ED40F5CE
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242484AbhIQKXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:23:47 -0400
Received: from mail-eopbgr30074.outbound.protection.outlook.com ([40.107.3.74]:10923
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234869AbhIQKXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 06:23:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzoFLRo0GDcv06SckGG4BT1LSQIKdUs2EFv1O2SrECvGLHvDzaNKBo0Ba4qR+qBxjmYXxoKqIMGqWVylNkLRLFdDGCvB81VFyeZhaJ5xlu/uG5kpWtrR2kzmp0zDM3tK1P9WkepTcBq6w0LdMtPM7jUPmVtVm7mrRWOXWFkzMwTOAabXXS+X/99Ok2zfqyCntJHHTO5/Qiv9XQwuc+phB/RL1gUVH49h0pxCLiErficmrh9sz/GH3ok3Nrp3FGRZ0UVZ5mGaThTx3bye8YEGBmB3u7nNCPQ44fyVlLQMVrpQnDMqJZmFlfzfbW/fiNqVrAc+OUx3+Xlf0j2QU1aTzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NzV+E3eqAcHir4kC2N4z14W0icEhZBhMu44P0aO3ZG8=;
 b=KGrJp2VmeaW2cuA191JaR+NfzzjVCSo0Fa5BWYXwhnKu+5crKCqnzVcl2vLO7BdvsGZhbDJAuirhpdPgUkyBZTqC3upEQXrfdXQI/cq1wPSfadE/W+s5cutnpL+MAV8kEzh/d+GedS/SRW8kER3SLccXL6DITodiFFilF2F5LBJF0+dw/qm0UaiiIm+6K3OdRFzuDQhvn4BM24DUou/T3hDcTg1fovxV6Jwifp4TktmWRPkSwVacvK1KhEK9+wJESNGLrNkOaqa7icsEaX5tkXwObn7QXWmgIgAPdtbMmgfUU15+CzuPfyeIzKFZn26YABe6Z8hygck5UxOV6zyhRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzV+E3eqAcHir4kC2N4z14W0icEhZBhMu44P0aO3ZG8=;
 b=TmrAWozokmXtoppXMWaVIlFxFC7JGyBJ+452HIB4FI6HNbNJnKpj5h7Co63XpKYm1KrXV+Og8cg8ZqO5whKTAn9JtRBl7WILh6zBpZcZS+edYI85MtlLjKHXawzz1qWr9DIXXAHX5udVVAELFMMQ3l4jj2Z9AoPnktduQsKBqGQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB4273.eurprd04.prod.outlook.com (2603:10a6:208:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 10:22:22 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c%7]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 10:22:22 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] enetc: Fix illegal access when reading affinity_hint
Date:   Fri, 17 Sep 2021 13:22:05 +0300
Message-Id: <20210917102206.20616-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0163.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::32) To AM9PR04MB8397.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b5::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (92.120.5.1) by AM0PR01CA0163.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Fri, 17 Sep 2021 10:22:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9de58187-09ff-46c7-c670-08d979c5092d
X-MS-TrafficTypeDiagnostic: AM0PR04MB4273:
X-Microsoft-Antispam-PRVS: <AM0PR04MB42730DD8CDC8CEED4C4D13F796DD9@AM0PR04MB4273.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8ljQ5ycZnAEuSkDLcA3FYXxww/OJHPaxHYb9Qe4kGRdnzQcYOkKPulXDyYBw2Km6vHhWJ4/QPImCdU32w4Qygc9nw25SXMccies1sCwzlB0RpfKIQph3a9ZK+siJr54UQD3Lq3UR+rE27PKPMnrwqQh2evghqWY0qiJ/STQXZ6MYbWHOBRMENl0bVQwOVm2RRgFzxxG7Oaa25yY3seszasZRvHt3UsxsgZGYyeLJVhNlMkO2Dr7kA1EhpTgdbXqHQVeJkBosORKcLXYEmDwc4jsOUUUwnbSB70ua4SCGFnjUU1O6fzdVOVQwtYw/lF+ENZaXOOMYdSMSi40Qa0705sQiy5BdYVQ5bX7E9fe68Gn5WHfV0Jb4Bvz6Apw98p7MqRjHp3LqnEvBp/HwiZccny7L9Rtv9emWxDaXkkBcUdQvoi2XcshaEk+tywi/0jKBAczXqx2kcND5VSr75uTWJuezZPVktuQ1ZVctQQfH/+INzt5tbFw+qva5K+vGVD4sqwjB80/9mJdita4/ZamTFapeTyhyam06UCl65b7PYAW+dQrBb3yUdhnIbFi6c/Krsfk7r2O4YWLALDiW3kIG07rcm8gvHxaYWNvFs+pn7F3aJHpgS5s5OnJAPmVO2QXrm81jVNriwawPL6q4ntC0nQfffKYnpkQaghzPVjnsuAUpbIKc3CpDknLFSUAEKbFAiCE1V5pu3wBtQwEcGHftQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(4326008)(2906002)(66556008)(52116002)(66946007)(7696005)(6666004)(44832011)(26005)(83380400001)(186003)(1076003)(38100700002)(38350700002)(956004)(6486002)(66476007)(2616005)(5660300002)(36756003)(478600001)(54906003)(8676002)(86362001)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m4XZifI7nVAOxLl1L+i445v55fwYfMOF+6fdRIR0aUVv75B3OLIUjM5Huk06?=
 =?us-ascii?Q?d/jZzNXgmnMjM0RO/GbUa1mOukgdS0zfXGkh9dR4jvjmPwJeb9LDdbkHfcno?=
 =?us-ascii?Q?B4szC6d76s4gq0dD6NCqNrnlXUD1+jq1aMtbaHvtti79SGoIXRhRaR2tO5OL?=
 =?us-ascii?Q?qtbO87S91lBAsM70rFGnDK/GkPvs+55x7eTjlp7uZzQQ+N+NuRezOkWp1x4e?=
 =?us-ascii?Q?oiSVeYuChataUx1qKoQFS0Oo03j0LhkbgxVl+vvCIN8lkKb+B/T/arCZl2DI?=
 =?us-ascii?Q?z7cl4egG50cXrG8IwQEBo489sONSgM6S/NELhCgsBB2qCRdHR22mpkwGKhIr?=
 =?us-ascii?Q?WYM7c3tCN2YLBIj1XV0sC1KLe/ZGLm7jzDtTSLNNq03DKo7fBjRIjWnywCP6?=
 =?us-ascii?Q?Z2vj9C6G7nF06+Q6W/q8UJPWt0mQwzILqQYefcmbVjmsYjhcc1d6DoKOWkU+?=
 =?us-ascii?Q?crOtsnXM89Xj4hRKoZpL/mLMHoGeUn+OQUXC1ZnqFw2TYhI5hV4simXEHxMH?=
 =?us-ascii?Q?vmFAkuomUsWfc9HydH7SFvHGlze4YR22GifLKgdkcEnI2RnDEp9VpDhHxoP2?=
 =?us-ascii?Q?eqWneETZbg7ofDBALKeYClILRqXjILhi1sdMBUYv6Tr1JjKLGILmYsUlDkoD?=
 =?us-ascii?Q?BOJsYkg2tBxFq4qTmOhFkoipwYVU+dkl+PIBCtVNoXvZ3u2piY9rkuIZSh0L?=
 =?us-ascii?Q?HHq/lyuzkkjpaMbj+sJXnBmmAolmtQD9IZJutmCpmLF1YAmqsnvYYqOjQh0K?=
 =?us-ascii?Q?8Sf4pp8rglssf9f6A85EpxsjfkwA3y0hN99NVUOgNmUuV7sbrM+gCLheGSo6?=
 =?us-ascii?Q?XwqTmWrSJKf1kQtpSGIlafHE/XRTp8tafBoAUo6lWmGdYySo8WN/dwInfM1J?=
 =?us-ascii?Q?pLi8O9Npj39sCjOX1V3L6WsM7MBEKr8ca/1w/SEPoeSrprsqNUCn2r50x0Ds?=
 =?us-ascii?Q?GEJadUMGb/8Ap/6F63xfHvTV56COrgB832aS7uaE1TV+6eQ29U5O1LA8QT3M?=
 =?us-ascii?Q?0zXci7ZcQqGVw0iXGM7DFlHsuK6bN5CpdDjBmVraPPaWD8bCd8MQt2bZRtjF?=
 =?us-ascii?Q?BP/JoU8c/tFDWyYx7e5P5naqFjwW6E5+TB3q2Wy1jrtZp10Fj+n4VJFqo44E?=
 =?us-ascii?Q?B/8YYIWoQLUdso0kTVNmYJw0aCewAq4lrhMcNsebOQQIgk/FLiNViTAqFvnI?=
 =?us-ascii?Q?CruDnC90mniRSh1SGD0UgGNs5bZxswCcBtIM4p6h2iybklizLYZvhS9VNRK6?=
 =?us-ascii?Q?dl90ch2UPm2Q/BT+HqfymNQsQyuWcHtN6JGvgwHrLcdK5rJQUUPa0iyQtdv4?=
 =?us-ascii?Q?o3f9uvyyptc5lvPBwl1E4yBZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de58187-09ff-46c7-c670-08d979c5092d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 10:22:22.1020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yIw9srkiCY5Tv/8w8lh2c5cB45uRZQ+FnPa4PMgpNa8ZzS0naKxPpo1wZhnsqM1yUlFAn5iQfcSH9pt7/0CBFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4273
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

irq_set_affinity_hit() stores a reference to the cpumask_t
parameter in the irq descriptor, and that reference can be
accessed later from irq_affinity_hint_proc_show(). Since
the cpu_mask parameter passed to irq_set_affinity_hit() has
only temporary storage (it's on the stack memory), later
accesses to it are illegal. Thus reads from the corresponding
procfs affinity_hint file can result in paging request oops.

The issue is fixed by the get_cpu_mask() helper, which provides
a permanent storage for the cpumask_t parameter.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3ca93adb9662..7f90c27c0e79 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1879,7 +1879,6 @@ static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
 static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
-	cpumask_t cpu_mask;
 	int i, j, err;
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
@@ -1908,9 +1907,7 @@ static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 
 			enetc_wr(hw, ENETC_SIMSITRV(idx), entry);
 		}
-		cpumask_clear(&cpu_mask);
-		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
-		irq_set_affinity_hint(irq, &cpu_mask);
+		irq_set_affinity_hint(irq, get_cpu_mask(i % num_online_cpus()));
 	}
 
 	return 0;
-- 
2.25.1

