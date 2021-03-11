Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE243337EF4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCKUTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:19:06 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:33051 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbhCKUSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:18:54 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BKD1G6030065;
        Thu, 11 Mar 2021 15:18:41 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2058.outbound.protection.outlook.com [104.47.61.58])
        by mx0c-0054df01.pphosted.com with ESMTP id 376bes9j0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 15:18:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4RGscGpaWy5EwniIR8bUAbZvvph3l+x5dDEWUhu/SeUrw7fb/vcXPJyUXp4g/s+9UkjBd4vp6QEs87zs+BzILpwvmmbkF7TT25jYOpb8opusU1lqBDZXHSFjecjuD3p1K59bl8WCO+d65onV7XMQrxYA6eAZYIa0h2jSMM7vSNIYAGiBOHvgoqJmeCD9Y9mbY6ADVhRGQXdKSzkwC7MU9XaoTIQE0R5EWh2a5Wlh+bAXORf4AfWbyDG4cDATgoPXoyW0OlJ2zuDAQ4/AA1ykad9BrVDH3Jxx9+tnm11otDtQQ0eRPiDUOpW6xQBDvjqzaK6YZCPV1xkW/K/2vLCgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4KHIeO0TsH7ylpfGohbvm+3NeBEtAlfgDZhRYh6B4k=;
 b=cLHcUJesgptSv3zQk75JhMmkrn+6WAV/WI3unsbEUYK3KYOy8Xxj/CDASwfsNjBbiAENIDL93e7Un4hWWSG2jzG+XBEOFtqvZZWCjA0f/JXWlPrgC/wSMNeYsTYJsdmMqNFDx88mN9Gd6QwQFW0Ong36ybfB0ODk4MeYqGCfe4od6jdtOxaL7+WVAwsiYobR900lJF//mSMfWJ/yBVGEG/exJlwHEI3+DjQA/xSleOSPWV4MOPwXLH8uiInlbPhNR+GcX8JWz7O/jOMn65U/qUzpqEBHWY1gGLXANRN0lzNBu7gE7PqpU8aC5dtHLb7JXqZ4bLUBTTWZWSYjjmMJ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4KHIeO0TsH7ylpfGohbvm+3NeBEtAlfgDZhRYh6B4k=;
 b=XJiLTH/MgUwLx9SYDn9oHA2g+b/Fg7Pc28659xUeZ0/dkSgBE62TCliuDN2xHaJSdUBx9f176PLM6Si49GSa5+awvTGS0Gymf1I1OzMGFGvPjJJWcCIsGjvUK7hlj3sH77gA71MS3WiTIPaRIa02b/fQPRko34FRyB5dPnsrcfM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3872.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.25; Thu, 11 Mar
 2021 20:18:39 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 20:18:39 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/2] net: macb: Disable PCS auto-negotiation for SGMII fixed-link mode
Date:   Thu, 11 Mar 2021 14:18:13 -0600
Message-Id: <20210311201813.3804249-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210311201813.3804249-1-robert.hancock@calian.com>
References: <20210311201813.3804249-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:3:13f::33) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR17CA0071.namprd17.prod.outlook.com (2603:10b6:3:13f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 20:18:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9f3a455-6e57-4495-49fb-08d8e4cadbc7
X-MS-TrafficTypeDiagnostic: YTBPR01MB3872:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB3872057F0913E478943339FDEC909@YTBPR01MB3872.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xk+pxYWCntnh1bhvy+AE5zykpUPvi/cb+hBBgaIMEBnTkvzVuqvxzM59X5epElqRO5n8hvD5LzBtgpGvdmecHJ1SRvs8PqhCO0QJDaFMyM78imdDmEBPxBv/Tss/j4uCtSOdcZkqtpP0n+9DbqX+mebIUhZXjPrNcuYyq55Zgf6lTqf1imPiXpllOHdPZ8V+nwCYf3jzYEolvuXaF7HHkSCzr22dQL48enkoJ8ICyfP3+PeAlLwxqz9jCQvyW45md5afadgpWgkyF0dDdeI3Bk4nZUNR3wBZa+qM7wz94zHuFdJS1LnLktCu8njX9wmJUe/10v0LFX/TjLXdIgX4dRIk7lgAW4tehqDHpU885c6z74Yr3V38MrfO4g6YSmHNQeU7KA1iL7QpXCUPiRpPuU5ErJvWOYjYFIlSDoT3npOtF1O5KHba7zAwj51/nsqTDGHa9ZIMRlWCb3YxjcsiNoiHH2TKLwJSJn1yYNjdK4e5nEDB8+Q0h+8NixkcqxjfYo77woBHqLJ3lPNQAkLumgv5YTnMAeg5miVoV79QF03OYcxmGkeDFqL2Ef9N/OLJprCFa50uT9yYwDT/cz7Yhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39850400004)(396003)(66946007)(36756003)(6486002)(478600001)(52116002)(69590400012)(66476007)(2906002)(66556008)(316002)(44832011)(86362001)(6506007)(186003)(16526019)(2616005)(8676002)(956004)(8936002)(26005)(6512007)(107886003)(5660300002)(83380400001)(1076003)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wwjbfJcMfPK/oY+/hyVsw4sNCc2IIKPXjy1QvIITjlQGeSkkR9dRa+VSrV+X?=
 =?us-ascii?Q?rTmSwjGfs71+4KBEMhYY4ichmi4ZYnCHRICtIIUNHXLHbiiyBxEfue886Qtr?=
 =?us-ascii?Q?H1KUHdgqVdH42KsbpLxAD0cvyGCKatgmvQPTuIjqxrmRwziuJZ8ivFVcze3m?=
 =?us-ascii?Q?JIsahileofav91S73p3YIZsAuffxRaBDStqJlSO6cWpPJAHJk/jWBS+mW294?=
 =?us-ascii?Q?zfe6KtpcZsaeLCFk/+uzo3CBw/eFUB0ea5NXd5sSlzGiRTQmBFH2Hf0epXhO?=
 =?us-ascii?Q?9zT99trOw/WCzKtORkJgj4HfB20nNAdQGp767Yhhqe4BQt3WfGl09XiAzAHx?=
 =?us-ascii?Q?CyRQc6XmaeArbjuHyXNsL00vruWpgqP5hrFwbrzyCJp7MRChF/twRKs0ZSLF?=
 =?us-ascii?Q?FiokXXfqHqIy1SFx+v4dYROsawxiZWdpckvPhfb6SpndTXqM/wHYZUt7keTE?=
 =?us-ascii?Q?gOHAMXMg5TtdlgwczjbVrCsiZUR2LniX3G9DN15Ahqsy39C4+oJJ21Pby6nX?=
 =?us-ascii?Q?gQ6bMarPqEovnkSch/WpOUZn5wuorTPTbBOTaXFSUEsnNdkyq5sRzAVK/5Pu?=
 =?us-ascii?Q?DFg/jGHhQnDTftakKqc2tPJV6yb6MuIDmzz0ge+PihDiepu/QDGnN0f4mJA/?=
 =?us-ascii?Q?FeNOtJDeAwBVA1hwhFsEkBrTfYTtm6Saef5nQ/qk9HU2oLQ/7X0LK5svdpRI?=
 =?us-ascii?Q?HO4bFwBIqnC3fVGHXhomqxWrcrP446KRDf7idFAo3RjIlApOUpxAaQwlyZkk?=
 =?us-ascii?Q?iTnfk3gcW9GeKr5w2tBQEMfiEaAjefqQw+PJDBxk6vt+wxQ3VS5tsB42WxQJ?=
 =?us-ascii?Q?gXKKnpwvPEe7S0Xw8R8GVmepPA+rNLkuzkA66/w1p3zcH3rrK9lZ9brKRAdD?=
 =?us-ascii?Q?wCvM0mGvh9UrjXzVSDs65L52rJVmUdsahb9HG3ngtmtGVyzA5lUKRitUShY4?=
 =?us-ascii?Q?aTemKGEcKH5siNHsqkdDxVelbpRGEtEa7RmITUolCIZD799BzQjV/FEVE0x+?=
 =?us-ascii?Q?Ja2Yc7BoxVzDqDygvTWbcorP4eK3Q+InKFGjDK4oiuL9WDdJK4XsWL7fFN6Q?=
 =?us-ascii?Q?gCrzLfm0h3HLKVvdKl1/gp7loA/fIfvdqC9kg0gbOGeiz/uMJiI6rL3lc1MB?=
 =?us-ascii?Q?ziS4y83bel1/ozoXK/ZzG2PC5qmPjTMklmgI7QpiNcUOk+ExSai4fOEvQWnG?=
 =?us-ascii?Q?m5p2KuBn9+NfkbLC1oTqOG4sErpap5Am5wuRXJjqyByeGen6H59tHRGHxCBb?=
 =?us-ascii?Q?l40iyCIf9aMx0c+A1yzeIU/yxrvYLWXs23JIhKUpgp6vOJDM+SE17Aub6QpD?=
 =?us-ascii?Q?wZw0wawAgnZ4y0ZfgFz5j++c?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f3a455-6e57-4495-49fb-08d8e4cadbc7
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:18:39.6261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1362rq/sf5uQ1yE7KjcUg+g6VUXRtjQGrxeYvKRgUh4hV0zjpWG9n4YvY6ug86B8uFE2++p4wqBRwY4QdeYpTsogwe8mZ5HAg4u/dvlp/qA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3872
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_08:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=983 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using a fixed-link configuration in SGMII mode, it's not really
sensible to have auto-negotiation enabled since the link settings are
fixed by definition. In other configurations, such as an SGMII
connection to a PHY, it should generally be enabled.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb.h      | 14 ++++++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 16 ++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index d8c68906525a..d8d87213697c 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -159,6 +159,16 @@
 #define GEM_PEFTN		0x01f4 /* PTP Peer Event Frame Tx Ns */
 #define GEM_PEFRSL		0x01f8 /* PTP Peer Event Frame Rx Sec Low */
 #define GEM_PEFRN		0x01fc /* PTP Peer Event Frame Rx Ns */
+#define GEM_PCSCNTRL		0x0200 /* PCS Control */
+#define GEM_PCSSTS		0x0204 /* PCS Status */
+#define GEM_PCSPHYTOPID		0x0208 /* PCS PHY Top ID */
+#define GEM_PCSPHYBOTID		0x020c /* PCS PHY Bottom ID */
+#define GEM_PCSANADV		0x0210 /* PCS AN Advertisement */
+#define GEM_PCSANLPBASE		0x0214 /* PCS AN Link Partner Base */
+#define GEM_PCSANEXP		0x0218 /* PCS AN Expansion */
+#define GEM_PCSANNPTX		0x021c /* PCS AN Next Page TX */
+#define GEM_PCSANNPLP		0x0220 /* PCS AN Next Page LP */
+#define GEM_PCSANEXTSTS		0x023c /* PCS AN Extended Status */
 #define GEM_DCFG1		0x0280 /* Design Config 1 */
 #define GEM_DCFG2		0x0284 /* Design Config 2 */
 #define GEM_DCFG3		0x0288 /* Design Config 3 */
@@ -478,6 +488,10 @@
 #define GEM_HS_MAC_SPEED_OFFSET			0
 #define GEM_HS_MAC_SPEED_SIZE			3
 
+/* Bitfields in PCSCNTRL */
+#define GEM_PCSAUTONEG_OFFSET			12
+#define GEM_PCSAUTONEG_SIZE			1
+
 /* Bitfields in DCFG1. */
 #define GEM_IRQCOR_OFFSET			23
 #define GEM_IRQCOR_SIZE				1
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index ca72a16c8da3..e7c123aadf56 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -694,6 +694,22 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 	if (old_ncr ^ ncr)
 		macb_or_gem_writel(bp, NCR, ncr);
 
+	/* Disable AN for SGMII fixed link configuration, enable otherwise.
+	 * Must be written after PCSSEL is set in NCFGR,
+	 * otherwise writes will not take effect.
+	 */
+	if (macb_is_gem(bp) && state->interface == PHY_INTERFACE_MODE_SGMII) {
+		u32 pcsctrl, old_pcsctrl;
+
+		old_pcsctrl = gem_readl(bp, PCSCNTRL);
+		if (mode == MLO_AN_FIXED)
+			pcsctrl = old_pcsctrl & ~GEM_BIT(PCSAUTONEG);
+		else
+			pcsctrl = old_pcsctrl | GEM_BIT(PCSAUTONEG);
+		if (old_pcsctrl != pcsctrl)
+			gem_writel(bp, PCSCNTRL, pcsctrl);
+	}
+
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
-- 
2.27.0

