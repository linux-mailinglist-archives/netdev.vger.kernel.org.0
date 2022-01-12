Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8C348CADC
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356244AbiALSX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:23:27 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:8017 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242533AbiALSX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:23:27 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6jCb020242;
        Wed, 12 Jan 2022 13:23:15 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2058.outbound.protection.outlook.com [104.47.60.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg65q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 13:23:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyRAMkNhhUWrC3nUN6CDs4vew0bx5PL4oIIkih6ApO1crBrkotjC+2RjdRhDidmbQ+CpzL8Ej7UVpRgLfYLBBIBW9QEOLxYIqIq3tWPKbpGwuyWd74YbUrMqumDlaR7yg0Oe0DuZ+1aN0ggZC5Wt1w+YlB0y0lJzBXIKOac4Z9FSQ01Ck/basvATtyFkZ3lamc31eha5tOsC2kELAB5wPCMcDJalAN0fVYYbaalETaUqGCKO5tSHJGSsGGOtTRs1XjhIV6jyx28T3bYsd9nshvtLGqh/L7wOEEueX88nwTH9W2U35JlXa2cTW6C94TtuApSnMyWE3OUVnzE0wLApZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynzOTQOGWdwDT8TR/+SYXLt+aAvpcCvHVNnnXoOzLbQ=;
 b=EY2IYZBRz/l9ymw+8cZegNk0gPk/aDrmibQ3dtbxjk0Eb4Qkhzx/DWmGuKe8cwNSzpA/dVgkALMUSa+P23EZ420oTRUEzE5y5+KnxMVxG9i9ABBsLcjtUKkJa0BPfS9JhgSXdCk+z4Gwr0YSEfH2iYEWgotAlc1K6P1IqMm8RsJR69AWBBL7B2EgifDix0OnHBHd04w3xE95LPu6NWkUoZiY6xC0Lpe1MZTCAeAu/T4If7Ia1sXdVpoAt3yrh+JP5JgQY6qqC0CtxgoEC0rzZvyJz/MQoQfvrLHRk1qomx4ZknvviV+vPXdbIKI053pTXOXbrM/dvKn5gXfKh0SdBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynzOTQOGWdwDT8TR/+SYXLt+aAvpcCvHVNnnXoOzLbQ=;
 b=h+1vnOlvzLhj4TF8PGiOaVfNlPO2ouH6RQvJg6eqM5mhYP80vWwbVr4hcrGFx/55IosU1Wz2qVI6VDEOxQq+aTxWoDZ4vOAUyw/F8Jat5SjET6U0snPin/x3b/ZXuamEXdht3YdMCLpnIKzSlj04we2mkgXQVDX//bomUbIYpVE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6385.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 18:23:13 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 18:23:13 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/2] Allow disabling KSZ switch refclock
Date:   Wed, 12 Jan 2022 12:22:49 -0600
Message-Id: <20220112182251.876098-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:104:1::11) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be1bf1cd-f4dd-4104-4ae2-08d9d5f8985e
X-MS-TrafficTypeDiagnostic: YT2PR01MB6385:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB63858DE65C5F8A7215AB185CEC529@YT2PR01MB6385.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c4cesjldglhPDqEGCtp86oBXN+cJXXcgyJITImZP+wTGzLqWbGRjqXbXF6CRu7E/94kDQ1ZZg6+iAnDzGSFR9AITQ2IamgzeIVzkdA/43O/sw+ik6s4yoCNdMv8LLd+yY7/UsOV942PA1f6TNdX7muIqd+XsqSq+TB/zqih45MDAAE2E+7HCYqAiocz0dSgjwUWaeRWfSfVqR+ZTfMeIZPHrvIcgXkskYklh1S40UhEzU2VtGASQ8IQd8ARczwCTR4Ip50pgf6BmdiB10Ew4OGRqPMU3EeuEGIE89UrWWW6pska8rFj58fbfvcxjc9Wbg05m8IBAtS2as7unxrqn7QkU+8EoWdpoCj55QZtIe8hp+Sikxkbow9Dlk314gEPqQIS+XLRFqR0QAmFAaMX4TOltNw9reMwC2lxoO8g8BFAhQRtX2zmjzZlxkKCV6c6ZeyJWC8Jp5jSPTgf+OvFe+MY7o5QfzJVcLJ04ja7Vm2Xb6ZpABZbC9kmzwZ4aQphxl64QTwcQrtMJ1VfiZprU8pX0yBxJkjCHr5Qs67BaD40rz0azvCasYraUP/K1L3+hjQoEN5zGUL55ChuQXQ0YYHXO9esyh7IhdQwjhGZri+h7n02H2aJHPz8mtmpvDSZN3sn90cIV66QuUwR6cvmaAI3O/zYjMcvag7fCRQKUP2cVpmSDI/WbaRCf37v/hPqT4TQBvV4Ant/YkbENDo0ReA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(52116002)(316002)(7416002)(66946007)(86362001)(6666004)(44832011)(1076003)(66556008)(83380400001)(107886003)(5660300002)(2906002)(38350700002)(38100700002)(8936002)(6506007)(508600001)(36756003)(186003)(2616005)(4744005)(6486002)(6916009)(6512007)(4326008)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7n1wvGCUyFRMAACw5kexivTOHts8NDLjxwKpTnww6qwNHE0GoZWm6D1c8jda?=
 =?us-ascii?Q?3TnNolqJOqkFcjU7SKkpzbn/AIsGK5P0w7s1VETC61OEeOzDGh19o1RyMB0+?=
 =?us-ascii?Q?vN8GdHiImHHj72yXAxD5nf80UUS3qbB8TwjSMns68LdqAqTG7G2M7C2tWJ1Y?=
 =?us-ascii?Q?tHWCxgb56GGFKSjqMbddtmAESqD95KMZjD0mWEXMkYklJ7h7W0A8PGRNzpv1?=
 =?us-ascii?Q?jjnnTHfMSOjSwr7TAtG2sxie75h92M03GXOVNXv3m7c0NC4+I4LiixisnpR1?=
 =?us-ascii?Q?z76WFy8TsObYGN155fLlH5j3NSmYqS2zMWdn5e3rMTsio2H/aE/HuGt/qF14?=
 =?us-ascii?Q?sAd3MTjx5shB+G1jAcZwrMs+Of/xop1BJ9M0wepYOE8Wj72ib7zFqRpcmwnL?=
 =?us-ascii?Q?7Xg6TE5l09aKR/fiO5po9ggNCbPDzx2/9PC1NnVpTEghDbNpI2h0BKrVdOCe?=
 =?us-ascii?Q?lTeEBaA7ib+HemxHn2YHGQVpnGznBN39rEPd2NSpzPWFsx8k+EXrbfwqhr7q?=
 =?us-ascii?Q?u+7jWuxnokwV0ZrcE1swI8RC2gh8ZeC6mlOPuW7My3U1s+KkFSsT7FtoEfSa?=
 =?us-ascii?Q?V8veAt+5y7T5FL5KxJ9B9KkN4Tbwtem4aMo1Sf8HcNqXmfQ6O5Aa3DYX8YGp?=
 =?us-ascii?Q?7CBr9AJNsw7g2rYeeTO463CJqjHUAddAZ0A7pokRjZgi50p039gC2g1wfCc4?=
 =?us-ascii?Q?N8hrHD8NP2QVJfkqivLKOtMge8GI1aVsFEdWfrzfW77+0NyoFNJA20/P0aTj?=
 =?us-ascii?Q?buDnFzz62wzG570BPjEwT2O2CEaGGQ4X+yGc9RSZMnif3NKC/Owy0io8U3C5?=
 =?us-ascii?Q?8VoD4gpRlIN+E1pIDYLdiNZ5VwsqX+uVOPEWvkznES3aIvS5M3ZUv9w9CIqq?=
 =?us-ascii?Q?1iJ2KnPrrpvYnGsXtAzNZG+AIjXGsqqjB1TVDTOxtk7hwaN5CWgbR9UAbXHF?=
 =?us-ascii?Q?gMaWxiNCn2JXt/hfg99ctl1Bogap7DrvRdIb1EbplQnGncDMBnf4QHOsg2jX?=
 =?us-ascii?Q?K5POrMue5nSoZ1RqPglWRvdqtLvmvF9fxUbelNfFbwO/ZvlDuuN+0DERPDjG?=
 =?us-ascii?Q?GtznsjwasHHfKIctgp9PDZyfHBPfcTAWrQsUKB1CECXLqGCR1+cRPwD06lM5?=
 =?us-ascii?Q?zALiVQrqeB/lVD08ybj6NQiTNxbcG3oroNpq1VDk/TC9vBoaC51FdNIzMGlo?=
 =?us-ascii?Q?03iyEPCRGozE77D69bprUbfvpl4h4tMFbwHb8GR2ceC+wkft5DPAQHmtRbNY?=
 =?us-ascii?Q?7EhFikxUyntjFOQT+Zs1vhG9F9GEFX5WiVSW5m6DZSG46Kc1pPCTJ51ji0x8?=
 =?us-ascii?Q?Qgs58C3CESD4H7mWrA+cKSz6IU8CBxFYjTXofSJuyRtSmNgRviYckTX5MxkZ?=
 =?us-ascii?Q?frcKVlhZkqwrOonGxuVuzz2FHA+WteJhV8ChHceQc2yFahrUNA7/YVIYlk6/?=
 =?us-ascii?Q?3yNg9REaGGivKTKaldNfTDUP8QvOgMeGGbHDj7U3yIjaoCRNUjvodTPLxiwV?=
 =?us-ascii?Q?XGc5w4YjflxWU/aJTDkxripOw85l9FDLThTAmq2VeSAJiVHJSJNgzQtU3i9z?=
 =?us-ascii?Q?D8Dsdzq1OnbVXcDtUeEFLatYjrwSI/w/DOuqd4pU/3BUy9utmNNgPe3ZaY7Y?=
 =?us-ascii?Q?BwFvy9Mmu4rfqHOdOm9FxBc6hCfncB4kolv5O0/9a+z0XpS/4rfQCMF+CcuC?=
 =?us-ascii?Q?Gl2r4C4+boZCsKdvVKYuRED9cb4=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be1bf1cd-f4dd-4104-4ae2-08d9d5f8985e
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 18:23:13.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7CQbT4weYvPSHFnha9CeaUEE66RtY1270J2AbzedjTdP7V/8BwTypKZcslDs7x5cTAYebDsHGf4p1wa/pqMTKjbZaUp6OS2J8qtubZoenw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6385
X-Proofpoint-GUID: upCbNN0SslQQywxD52Lou4fuiQzbcX0X
X-Proofpoint-ORIG-GUID: upCbNN0SslQQywxD52Lou4fuiQzbcX0X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=746 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reference clock output from the KSZ9477 and related Microchip
switch devices is not required on all board designs. Add a device
tree property to disable it for power and EMI reasons.

Robert Hancock (2):
  net: dsa: microchip: Document property to disable reference clock
  net: dsa: microchip: Add property to disable reference clock

 .../devicetree/bindings/net/dsa/microchip,ksz.yaml         | 5 +++++
 drivers/net/dsa/microchip/ksz9477.c                        | 7 ++++++-
 drivers/net/dsa/microchip/ksz_common.c                     | 2 ++
 drivers/net/dsa/microchip/ksz_common.h                     | 1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.31.1

