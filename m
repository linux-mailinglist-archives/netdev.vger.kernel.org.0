Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B80F2B8CC6
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgKSIDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:03:36 -0500
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:49134 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbgKSIDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:03:35 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107]) by mx4.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 08:03:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQd1wbka2ZzlT+GS7cll8kRXTVIlc9EMTAx+0eyo/glm8cMvcLIkFZuTi7pILrUmvbfP0c18vRegHHHCnBQ2mYz9bFFYSpUiBCyxVs0xKkF/YDbBpBfR7BkyJcCYKXBFnRqHj6LCeq4MqhjLKq95sS7atz+proh96eYGJu4FgZalJiuaRMhMJpwqiQvpSIagwzSh/m12Aw82wZswh76qRaIOHWNOLeL3lO3UsE8FzDhUg2XuZ2kOge9fMRdQXuuVoNpyL/Nv7IZ6/Ur20NOUx1Pdq5Nbd4kDhm69aTz5Na5esN1f8M/tFgZ5x6o8dP3wmpTStAJC9EME396MxBACPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzhu3HKrBF9WL7Cqr05yTjxR+KiotXQXs5GjHw4rN/g=;
 b=Wz5WPl4PqnIKKvUX+wZryQEguFQpqPbBN0lWy2UFwgNfF1RJMcL0VT7H+sZueGe+7IaCsMEBYoJt0lPns+afBUTrwuJyrUzpCV+gQ+XcYgVD/2pvzDchhsHgECY8LhdXQ/iy0fdEfZsQefMMbtyNKPf3X51mOeEJ1IUPzplz1yvDQPGA8dYXjbT5kKp2rYi5LxKCkSlGrc9pb/fl/0rtceiZUFiQ8ACYpxepMFZlLPNQJmCtl8nJ+oKqWtqh2hGI3IAJw+UbLW4FPUNfyS6ptqhJ79cj37gfAoCz6/PbHdSS7Oxo7mgK0pR9jV23pecLIGZiqFtGs9OzaFOHmbNFQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzhu3HKrBF9WL7Cqr05yTjxR+KiotXQXs5GjHw4rN/g=;
 b=avCl3tdaoSs4qaQ0KRiGb9KJ1MYJqcQBrpVvPXAn82cwW+NAMX5jnd5DqnCQSLlNg9dzeG8H1Z0oDiTr36zJI9sY19Ee3iI27uLNxmze1OlEHWPqf2wDIMHiwmE0bVvJb4lcbiyQLXCfrpWpb1Ymwz/JKk9Ia+YoYZUhDKx7DV4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4399.namprd10.prod.outlook.com (2603:10b6:208:1d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Thu, 19 Nov
 2020 08:03:22 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%9]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 08:03:22 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v9 2/4] net: phy: Add 5GBASER interface mode
Date:   Thu, 19 Nov 2020 18:03:01 +1000
Message-Id: <ce2bdff4ef9a98e47d93b3e183327f16acf05768.1605684865.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605684865.git.pavana.sharma@digi.com>
References: <cover.1605684865.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [14.200.39.236]
X-ClientProxiedBy: SYBPR01CA0121.ausprd01.prod.outlook.com
 (2603:10c6:10:5::13) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (14.200.39.236) by SYBPR01CA0121.ausprd01.prod.outlook.com (2603:10c6:10:5::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 08:03:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1140df2-8a64-4590-0780-08d88c61955f
X-MS-TrafficTypeDiagnostic: MN2PR10MB4399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4399CA8C2CF1CCC0B5E2054495E00@MN2PR10MB4399.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCX9/P2NcUEFaS26U5333IhzOuDHhpX3H2R0hrWFhon0no3DP85UNTQ/RAro2mPMr3Tcdi0PthsS3TcmiI7L+NyGBK94ArPp/88yMB44Q3fd9tMl/Tf1qcWAD51ZkIKaGtWSDbRWRy4kSQlWj0PsfWthHSANCZQUh9jQQ8r11jeE3E4UE2nXlRQ3Jz3l6Upil56x6J2Pz8zglKxO6XjD8OXH0I9Nbfqt8Xb01wzBYZEK97GJiffTowxZj/iO6Mt/0IIfb5kPvM6VBVixMPBO3kAraKRpLVghXsmLCt69KY0Vnnqgr3p+FbRnLEIckUFOyVgO/rdmsKk2qSTfxy9oXTJAKAMDXNu8ZfO428DJMx2vMCP2XocerbaklaYdJ4ak
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39850400004)(7416002)(6486002)(956004)(8676002)(44832011)(26005)(86362001)(6506007)(8936002)(6512007)(6916009)(36756003)(52116002)(478600001)(16526019)(66476007)(66556008)(2906002)(316002)(5660300002)(2616005)(186003)(4326008)(6666004)(69590400008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: FGhJ3ij9rbRwNMmT2hghY9R3dIPbHnqYS9TZLkiUhCwIC9eUmL+vMgQl3YuBVHNELwgxWJD5mmuzaOY/DNyi/dSSYXUQsUoHA/edPm34v6XlHmcKRtgwCZRtnm6TbBtLa2jfb+r32slZqEWnkvK4qAHsxeD7kGI0I5LHN+LfrkC6A/+mEHuNXujVx2bI7RPVzzmUPn578frr9buJ3y17h6BcxTo+p9lJ33z0HvsoHz5ZyDOBMmZKttQE/b/vR7TAUQ2woVdpDbUFjNGAca8v5CSSFPZSXlGjTcbSxxHKG1ESCKr85KadBWaMyYwlXUb2p64O88SqQA2tnvA459ErTEBOkSxjLKIV0B56827vTHL8SbZxKOCUUqb1qwCxp+jG+djy0zrcnZskcf3HYb8hXrPzJVlyQHN0EtDDNiL75JB81Ny8anKFcRg59j9Kw7E5PrDpG6+8eygY4RJmY0vSAxh2ASIBngH0syyrPg2GOC6fqEe/YtsIc/isZTWgbt5R72pgAJRByLcoEIaHE9l0ygdEC4Wrv4UrPHpjzUKrwUe+zYDNR9ZW0E9fcY7qZ8pX/70p7HZyCJJXOnJlePNyxDqnBKg4zKbKcGElH3fnXGEWLUe1l3dHn7MX5Gmvqn+TCPF8OCHPBT+LnAbHgJY3OZqW7ZhbBOVGtDBTKv7BglRxWFzcXowqKanvK/sVGfWeGy2vEZgkzVQRiHgzs89A4qUQQ50Hc5Hcmcg516p8DyR9kYNZsQYF/X7TSVaXpaOFBQ4d+sPpoR1dKS9sH0P5KUpEOIrGIr+s/aoppCmKg5cw0mQ5/aQFeq1LvhtA9Efg7OhgxSfIGIWBhcdBTBGGjHSpsegYnJ0+l7VY7BwTJuW7/fUV3r2iGX7zlunD6CtLTj62i5/qo7v9phZUwJPC6Q==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1140df2-8a64-4590-0780-08d88c61955f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 08:03:22.3622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+Y2n+V8W6+0M0prm8Wvz/jHHkxxN/jjUQTkevKnMhk/tAZ0o+LZMb2Ho4DBzbsEbYywmt13cvsJem84mBqv7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4399
X-BESS-ID: 1605773003-893007-810-54468-1
X-BESS-VER: 2019.1_20201118.2036
X-BESS-Apparent-Source-IP: 104.47.58.107
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228292 [from 
        cloudscan10-124.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5GBASE-R phy interface mode

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..71e280059ec5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -106,6 +106,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
@@ -137,6 +138,8 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	/* 5GBASE-R mode */
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -215,6 +218,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "1000base-x";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_RXAUI:
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
-- 
2.17.1

