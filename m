Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E58331A92A
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhBMA66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:58:58 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:41674 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232487AbhBMA52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:57:28 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D0O6Rs011785;
        Fri, 12 Feb 2021 19:24:21 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2057.outbound.protection.outlook.com [104.47.60.57])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hrw92s67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 19:24:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWRPKGSSOeqG2VOtkmu7UL34N1ouKqyXaCCgJB9Bbpbtp0dsKA/zpYSqhO8VKx+3oSrA0amdZftQDYEAo4zHiBB2Wd6ku9wQ6POmpzXy0iUicXMvbDQkmMzgHXJqJLLSb+kR49pvBQTjrvWUpCjCoGoMPnhiSMJik4Q0/0LQyvXlUC6z227nXCieuAqkhdzz7Vwhux2KvvkhcEfqtoguQPvjs7A349oeSMW7K3MVJSFrBaVEBrYHk/bTE1UJIemLOm2Xe0kaj9+jfMHiB+0lOIm/ObMyFrgao7NayGeZlLZhWLjsAs19hJxdqcmftsEuXqGHk+RdTJjr6hMpv8B3sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLSLBbQpFl4PCpvSi0WmooyB0UwPwHJwadtf+D+ijyo=;
 b=jhH2+jC7ph1IiejpCbmhnrtvr4f71fcR2w9meC+T0Yrvyui5xtjtA36y8tS2kEemA4DKtw3ziZBct7PyJW1hE7XNgYlR7MVmXCKbwtCNcYVQIh8cUkVClph9Hf+a3HIMRHAguavNnQmMu99FvJ/ftkkS8KBBe/wjHzpaNFjduI/ZGuVx0yszPEmmwkBXOGHFqkPC2fPXgHTgaVHbN/gDY5fEe+v9JRDxtZT75HTwnkm/avJLTn+w+9v8eklShDRtscsKG/j2huqtFyELolW06AVDtVT1+Iuvgqw7nYFDt1Xfbxmpf3W1tCkYecOrB+P3mV6/egULLXSuIabNQwvjeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLSLBbQpFl4PCpvSi0WmooyB0UwPwHJwadtf+D+ijyo=;
 b=fiNRqAaxgqhVr9gfNt9T60nLpJkESfpHeTTxyJTFRQXQQA8op0Nu4bqKaOgonTYA5GbXCFJ6PIIDGul3KNCbQWrXyUx7kwslhYvkOlwltZPlm8Heno5GZd7kt5SNThcXiTy9dAQzzEt+4UxSBpwBItWaTmxuLFCKU2zFEo8ai6k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 13 Feb
 2021 00:24:20 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3825.034; Sat, 13 Feb 2021
 00:24:20 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/3] dt-bindings: net: xilinx_axienet: add xlnx,switch-x-sgmii attribute
Date:   Fri, 12 Feb 2021 18:23:55 -0600
Message-Id: <20210213002356.2557207-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210213002356.2557207-1-robert.hancock@calian.com>
References: <20210213002356.2557207-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM6PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:5:337::13) To YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM6PR07CA0080.namprd07.prod.outlook.com (2603:10b6:5:337::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sat, 13 Feb 2021 00:24:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5431a1d7-8b8c-4a19-eaee-08d8cfb5b4a9
X-MS-TrafficTypeDiagnostic: YT1PR01MB3564:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB3564B6562C796944566FFDEEEC8A9@YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvju3eHXp0o50ZQHFtGdnQYT7pyNe8bekgCAIlwb8cWg6YOZArODZ8DYWidcGiCGJ0yUtUvqB30FHicFZgyaS23ZMXxhjgSXW+bZFPsweMmkAiTC8vDk9kF2uV78mk1eOHInn0/+YSb2Eo0RVhuRg+vro903hPBNGlPqzYbyrwTUURmJFRqZw+I28YfhyLiC9DGIfGodkMXEDRpkhlXO1wYLZsxMx5Bt9Payd+y+QYvXsO4UoZDN0WkvQ04RJgCSc8/7zx6WBik5mxOJreGkILbJNvlMISAakViO0rfOYfJi+CoTljfeBOKVPS8S4T9R2sBbicr2QSsegKrVJ9hHbAxQM4vaLVsJYABCZel8ZZh+4GK7UtMt2cVtwDh6pEdHELwB6//NX1cfBxZ53L7F1YRh53RPGoP46zEAYfM9bm/P/tLj1C22TOfls2b3NGDSjNjojPtUn/pJjvmazMnrDr+cmvZ5KCyNZZ4r4N79ou4tDtxbVuECVLitMoldUB7wNXNJebW8Y37J5yRgU+tzRKqrVIAiGDmuuyCjYzbIufO7Dk64ddNyxwLINsYVnRkqHjtCxuSnbemA20xhQrzkjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(1076003)(6512007)(52116002)(4326008)(478600001)(66556008)(66476007)(66946007)(2906002)(8676002)(44832011)(2616005)(107886003)(6486002)(5660300002)(69590400012)(316002)(956004)(83380400001)(16526019)(8936002)(6666004)(6506007)(26005)(36756003)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?e02e+BWubF1Ovha7Ycd+uXdwo755G7hBlHverfeCRdFX4feTlxbfKByd1KxT?=
 =?us-ascii?Q?5RF7Df3TMW2yIYS2J+mhGWYnQYqfUvF5WtmEC/I3QvPx+XcuqNWIKid27WQo?=
 =?us-ascii?Q?BvfByJ1fEHgEARKVlpgMbZSgSW1v6tBxVKJ5Rtzxb1T6gF9gKgRymcFeBlGj?=
 =?us-ascii?Q?cOrEUP14ugSplp5hJZWjHONbsJlbyIvivm9AbKVPuW86R3yAMehuWP4dzjWh?=
 =?us-ascii?Q?lzVChejPwf5cymxOHwC9mZ/spVZUUvtTDAVzZnyIZbuL5cLE1OjRqThtaJNM?=
 =?us-ascii?Q?ik1qJvg9LhFUZPTBJSOj1MiHysGrzkjSKVRYoQJiyyGTQRBpCBcyJdS1SOzR?=
 =?us-ascii?Q?tMeSQvVuTq+NRnNfnKl39AHgf/ot0Gcd9u3u47eHd1kX8Oe0T4GJBV89vSF8?=
 =?us-ascii?Q?O28N9+nBBi1fn5nDVtcWZzpfUUqN8vGaevBCYwzRzrmaIWUZOpRcbt3S8nf3?=
 =?us-ascii?Q?KLJrXuJGVLLx1JH/fkGSyA4brSV/Zvw2HqN3Axcf1pAi5eCVj8JolqvFuZYN?=
 =?us-ascii?Q?dqdoj1lYRJl02idPQR8FUTUGpWT5JPoEoEEjcdpKKIdLvqxHgoPWWTtTF/Uz?=
 =?us-ascii?Q?Z6LwcNCKwRJfQnUpcZNJTS18D6zoASzpbOJxV8faVEQ3V372jSUpoL867pJm?=
 =?us-ascii?Q?nZ8rSvUFYVJ0+BVuW8KPhpnr+aQxqbuVNxyg0Dinaun5Z7JFg7TWiDZUGrbU?=
 =?us-ascii?Q?CYSXWwP+oZ0OTyuFNFb7v/0T/J8VSoqOjn985HQqDpz0ozPmC7EDRHl/AlmX?=
 =?us-ascii?Q?+fmbaD2AUVf3CxyRJ78DaUgqTz0f67PKSyEuq2dcBY9NlrBVFuv62EBiUFal?=
 =?us-ascii?Q?WqZHan541eip0yORN13ktmKytBHFmz8P2W8pmZ7cTUXaSGc4XyGF3pKE5DKH?=
 =?us-ascii?Q?U40DtoGv5bW5o6CkdzrekPeCsmhjXW6bQhB2dzdF2+7JAtj36R/R7Sj9jCI4?=
 =?us-ascii?Q?VlFhHmlYThuvT+2Isw5h0Uu8kWy+2y6ns/+/hexKbZH+J0z/YvQ0NHeDo/aP?=
 =?us-ascii?Q?z2bzelU2TkoccnFuvfW7xLYOd/Gb9LJGZAtGJfA9btP0n2YKimnktjjIjbp8?=
 =?us-ascii?Q?iQkVz/oSojd6/SmhMQr+d63NSoaCmMyj7uGjkb6fhnKGGl//0UtP9mQ+l7z9?=
 =?us-ascii?Q?HsKH7RFfYdc+kvO017+qX2XS3uKXVNcUayKMLvTfOSf52/8hJ5jqes2kJ3yg?=
 =?us-ascii?Q?vhHrkpSJLVCSq2oRbsVfd1sUOsCuRZUo2XuhVYeYUeYIPSKam1btUpgDlbsJ?=
 =?us-ascii?Q?XEoDxTMZctj5Vw5z6z1HxGvrwMmyMURiirndvX+sISW5y5d8zw2mczoSALQZ?=
 =?us-ascii?Q?9sBQ3hVHXLclmJGQ19tAiqyh?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5431a1d7-8b8c-4a19-eaee-08d8cfb5b4a9
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 00:24:20.1988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/mKdRKG1ngkEuN8ZX6G2Zeky/UAXqgT52TDFh9mjN5ewVRnu/cJcU3ROGwXEUOuwHkQMOAdzX3XIjETs0DEM0fTrZziNCihtj1K82v/LKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=878 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102130001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the new xlnx,switch-x-sgmii attribute which is used to indicate
that the Ethernet core supports dynamic switching between 1000BaseX and
SGMII.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 Documentation/devicetree/bindings/net/xilinx_axienet.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 7360617cdedb..2cd452419ed0 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -38,6 +38,10 @@ Optional properties:
 		  1 to enable partial TX checksum offload,
 		  2 to enable full TX checksum offload
 - xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
+- xlnx,switch-x-sgmii : Boolean to indicate the Ethernet core is configured to
+		  support both 1000BaseX and SGMII modes. If set, the phy-mode
+		  should be set to match the mode selected on core reset (i.e.
+		  by the basex_or_sgmii core input line).
 - clocks	: AXI bus clock for the device. Refer to common clock bindings.
 		  Used to calculate MDIO clock divisor. If not specified, it is
 		  auto-detected from the CPU clock (but only on platforms where
-- 
2.27.0

