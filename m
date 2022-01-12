Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7299348CAE0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356251AbiALSXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:23:30 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:26571 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356249AbiALSXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:23:30 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGT63m010893;
        Wed, 12 Jan 2022 13:23:19 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g26d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 13:23:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF2GPvAkm6rh9iDK+BGRJI88cNOA7/ul/iiEY6zkoaPUuDxcQUB889mQDV/ttmytjNX1tbRXgI8C0hkxRZsuNo0f8qUA7y3TCktE/knFmF3bcIbW/ML1R2KvW0fa3qNP964wU+jEFwGXkq99tvymzGvYQGmUt+TX3HJyR96rWjNVlIOfhTpfVbKiVAIzO0oL9ZHkyMHNYTRU9IQ6Bk4eKV+CyYzgsQGcZQcSaTo9TYhAO3W3VzsDonE5i0Igas0iRmbL6YgJaMRU6/xGcw9QgZBMMufA/Wo/Ppbt2v/IkcqZVMbZU7MtVmVToONVzE2zCo4xwpD7OOFccZOZmGFrMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bcg329DL2Nfk/YbSd8kLr5YjWlnL4qcBO7yCk1Xjulo=;
 b=Ei+FWdZ7CL4zNPYpGJQyX3qT9TpPfpQJ++pNYFlLLTQas2NiK+XCXBPNA//9MyZTIYvJ61ieZpTfcb/B2HlobrljNQj/I4ympo5fYiTigwKIRqzbxKGiJ1s3bYWIP0GXx53O1qVR9aYzkzlVpNBL+93ZZFP42DToHdxy7racrOZXtyYAyqBepyC+TWcAAMlCiSmQ3eK5zlQO/HsiX2X4oO2zKVYIbGhY95oyq6YzW7L87GpzN1yewBXygzd5HN8DLh8wpyMPer3CD4D/AwmHaogTR+iX9u8DnKrP2yHyplBe7hS2ExzB9bo+tt3Eh9HS38jZ7lSdrgqN74AcXuqXMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcg329DL2Nfk/YbSd8kLr5YjWlnL4qcBO7yCk1Xjulo=;
 b=Ao/xV7sjOau5u5gG/krC3HIqpWc/WcHuQ8sFSTtl3YZhUiqeBn8sYDpiEKszs/QpmrjSOSiajyJxIYuviXD8BmpQzq9kLgSOjb/gZXjjfIku7sa5PjdytodM2yoPev9OoeoGwXqaYNgioQo/dSSwKGtEEmEaeNlQAFJoOSQULDU=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6385.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 18:23:18 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 18:23:18 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/2] net: dsa: microchip: Add property to disable reference clock
Date:   Wed, 12 Jan 2022 12:22:51 -0600
Message-Id: <20220112182251.876098-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112182251.876098-1-robert.hancock@calian.com>
References: <20220112182251.876098-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:104:1::11) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c2314b9-59e9-49e1-e641-08d9d5f89b06
X-MS-TrafficTypeDiagnostic: YT2PR01MB6385:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB638566C4F7D3438B2ECD0C81EC529@YT2PR01MB6385.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ca9+3EJcVcmnR6pqb8UH+Ti0WbzEpPbIqPUiNpSOOq4v5pH/xcaQlxhNQqC/UlmOvc67ZD7Vy+hWKLw4iiZt3Xo8T8UiB/KzccGQCpB3aTt9gkFHK3JtG/QXYBPDWzdPc/PnPBAa6wJ/NjPjdl5HiGYAt/4uhO/TXoF7mTSi6gFGN/Af9t2VpZFPhE/ksLKhCmPsmNgxtahR3papW1x9xHJEZB9VpAbjSII2xeTZrWa6C28TW0Y55OtARH8w6aTYDZiM28MK+75AcgWwuz7N/MvLRFDUxVruHLTe5M5oGnS75jkMBEmo2zq4ryAeGIR8w1I+CHayQSPJB807RlIKrFhTYRTY32y//pioviarSGWUStODYzrjYfMmwyYf+nkSb5UBUvniVw4EknvVI3x1tyl8OtI0YqEztj6bhNmqoDWuptdVMt+kL41IsxhFJwKAqrr/60JUXkfS2KWpdazqs4MKjQlNgSqmXBAkrIZqizfWYaw8wQDF7OXQL5qca1eS5tPkCH1cJreELJYr3vYt7FJuTcovsgEJbZ3eoSkzQV0M6W0hm+GpzRN/rE74b2IYSibJhKJyDc2KLNT68enVwkSRO7YcxjVaB1b6RtbEnuhcR1V/mkwt0VgCdfMmdUXO2mKoD3smKEYBWY3hdqnBrj6AJ9cEfXScFTsB17ytcoYtb3AiqumnGTGZDfnJc8gHjWSPdI/SaPE3W4DHVtl7Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(52116002)(316002)(7416002)(66946007)(86362001)(6666004)(44832011)(1076003)(66556008)(83380400001)(107886003)(5660300002)(2906002)(38350700002)(38100700002)(8936002)(6506007)(508600001)(36756003)(186003)(2616005)(6486002)(6916009)(6512007)(4326008)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PRJvtT4uhNN9ZaQfMLAlKlPFXGNGjqpS7i7CbJNAKxP5hb+D19/R01pEFnMO?=
 =?us-ascii?Q?u03v0x0SL+Cigl0kyeLQxs3FYklyB5NTCfuwPyznnIOcpktx/TcEIvc2PtLf?=
 =?us-ascii?Q?vtp5q24ZqYBxZmO74R6WG2ggv9Cuka17+fYSqGkgK9RScrVBCUfnvVUlvpRx?=
 =?us-ascii?Q?fuqBsIDr/uc/CveUE1eHttchCxkpZTrF6Y5eqwws32gsT1jpCI9ywzf/9QVo?=
 =?us-ascii?Q?aMT9VwqDxt20jnAkQUyCUAtJv/v2IAttWhAnOqI+vXJns7+gdg/cNeKn/kjN?=
 =?us-ascii?Q?YaXSCDDEexaKX9Sz2vAsPubnA/Z4aGpvEQcCja8qDfEKiV8o7nbejzdIn7Tc?=
 =?us-ascii?Q?XSlVeiDA0WsUM5/cnXVNOFgEa2WpBffZGwEK6ab7dCXzJ4MhEe1Acq7y64w/?=
 =?us-ascii?Q?s8Zew+6DwPsKP64PPEC9DW+z9hB4sJhISBaIgKRC3+uDVAWZizyVO8cenE+H?=
 =?us-ascii?Q?sqeOrxlaSre8Gp3QGC+Aa4qMgF1ON/J9bmq9ZP56QeEqep9+prbmke+ipUB6?=
 =?us-ascii?Q?b0jlvKFtgXQeeEK8ymv6CkTnzqYDsPfvs9Z1yudQk0uQiiB9T8Bo2xe0PW59?=
 =?us-ascii?Q?QGn+SnN0Sj9WS0aeXQwHy81la3aJIYa6bdpE8k0YcNqPDbT/+vSdjrANV6XJ?=
 =?us-ascii?Q?84denjcl7zANy9H2StFRRZxRNvE8u7n8xAdYyPtBSeuWT8jij2AvGjQQoclg?=
 =?us-ascii?Q?64+wSFlsxFL5sbjtmxtdSxvGxX2AmZUuGUt7cvBQVSvxaeZ3vGigI6a5Q1BM?=
 =?us-ascii?Q?50WvZuQ5901MWnL46DXOmmNKzkmzoS6uSEtKBb/eUPtMEh/wvpDWEu0bENa1?=
 =?us-ascii?Q?oY0qYZnGyfVkF8NWyDMqQMRj9+C3rUUfeAzSgx+MIWZ45XeJxLiQfCtuAw1Q?=
 =?us-ascii?Q?49ji+W6rexfcbgqZpPdGqBkRLMCMuSGrG98Xci4XHnLm2/Wbuzgj3gTgom5Q?=
 =?us-ascii?Q?JrEtH+y3Dkgw3DVL7UIoUboMEMkbkZFVuKyEBrCj+jSc6noo7caTBW4WmpFh?=
 =?us-ascii?Q?wHlaANRtw2NA+HP3sRdaN3Xq+lZuxgdIpgMOvUmoHc4K27wJzxCIWEE8sp2+?=
 =?us-ascii?Q?ZMx/YsUx9PfF3QeXlaE9VLRmRyX6NfsmN/gBtnwWZhqcUCADSvj3Zhh0sGDg?=
 =?us-ascii?Q?Uu1x/m/rQ+59vG3vNA7eIv4JXGidl0Fg54vNeespaiTjOMl+lkHXIx+o6u4e?=
 =?us-ascii?Q?F3sfFYLrsFy6hr23YpwRGOSYsNHroNARpCQrGwpVtR5pMEccOUHSe1+NdIM+?=
 =?us-ascii?Q?2+W2FSKv2GVtXnGCoaaMaRjPTxNAo1qjFYF3HqjTtNX+M+NPNVo1YyBCjhIf?=
 =?us-ascii?Q?bPW+qPeaBoKJCAV+Ca7FejxvfseOFp4BVwDHOYpwQQarL1Cj0gl5et7PA9vt?=
 =?us-ascii?Q?1rM9QLpmpcTCKIfGkUfShIAZyIlZu3e1zpXAZ95ggiSNSafeHikR7DodlGuj?=
 =?us-ascii?Q?gjSjzy4FLbmTTGqATKT3cWuKinnQeUp1CyMPw1TneazGdyA03GIGb773XW5i?=
 =?us-ascii?Q?HpAQGfAFfE3pJ6WLXdZtFCtrFf8Tlx5ncR9gkD85PxyhQenWXWrKJNKH9Cui?=
 =?us-ascii?Q?hd++GxXzcxIUToDWx97LcgzZHlc5QMiE17fXXdHR5tSxIFhSrNTRVzCACG5L?=
 =?us-ascii?Q?qR7EpUGtWNjJ4GDMPgpPXeim//AsJj6HoJjBpb04RQVHSjGpM/pF88WOr5tp?=
 =?us-ascii?Q?SY+Z6nrhFRbqLjPbknORFkHTkaY=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c2314b9-59e9-49e1-e641-08d9d5f89b06
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 18:23:18.1349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r92fJdTPwRxEidifSr+blon00sKrk5TYpPy9rDL/bGkHQHHbhckKRhRzUJRYR+AWCADhaZ3KCaAmh+2US0L9C/oxejqmAZKNSYRiw8HNo80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6385
X-Proofpoint-GUID: t0C_8iRlUPT9CVA7K33STi0KbuxKtW2_
X-Proofpoint-ORIG-GUID: t0C_8iRlUPT9CVA7K33STi0KbuxKtW2_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=736
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new microchip,synclko-disable property which can be specified
to disable the reference clock output from the device if not required
by the board design.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 7 ++++++-
 drivers/net/dsa/microchip/ksz_common.c | 2 ++
 drivers/net/dsa/microchip/ksz_common.h | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 353b5f981740..33d52050cd68 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -222,9 +222,14 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 			   (BROADCAST_STORM_VALUE *
 			   BROADCAST_STORM_PROT_RATE) / 100);
 
-	if (dev->synclko_125)
+	if (dev->synclko_disable)
+		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1, 0);
+	else if (dev->synclko_125)
 		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
 			   SW_ENABLE_REFCLKO | SW_REFCLKO_IS_125MHZ);
+	else
+		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
+			   SW_ENABLE_REFCLKO);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 55dbda04ea62..0a524f1f227a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -434,6 +434,8 @@ int ksz_switch_register(struct ksz_device *dev,
 			}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
+		dev->synclko_disable = of_property_read_bool(dev->dev->of_node,
+							     "microchip,synclko-disable");
 	}
 
 	ret = dsa_register_switch(dev->ds);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index df8ae59c8525..3db63f62f0a1 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -75,6 +75,7 @@ struct ksz_device {
 	u32 regs_size;
 	bool phy_errata_9477;
 	bool synclko_125;
+	bool synclko_disable;
 
 	struct vlan_table *vlan_cache;
 
-- 
2.31.1

