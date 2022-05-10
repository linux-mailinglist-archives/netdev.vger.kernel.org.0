Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0708520AE4
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbiEJB7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiEJB7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:59:45 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2112.outbound.protection.outlook.com [40.107.215.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CAC517DF;
        Mon,  9 May 2022 18:55:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L756/A9dUm9pQk6nLZm+ROlzKpUy1ps/tdqCNKG7VYofVWH2+CcUPBp74fLxP2SxolFgvcPthDHNWlDUxNNDtbgI7M7VTnfU06szz8hJV6SYyW1dXxnVsY4dy5zxJMFpovD+dhbetBcIldhYklQeppjHFsIAyta5dsvT233gceDs5RcaRpjEGvoRtQNTqY1viCDYSc4A8FJQebPg65wlb/TM0bstzwIWtzeJdOIGukw0uBE2/qqDSV1UjKKYT5pfoLkmPZNdrHAMGM8zvN9KTGU5kohlXGTJtNBdXyWCsjM3HuzZYc0EIb14Oy49SdlQX5qtdrIKmMOQ4tVbdzc7Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uchmF/jquSUA/PwF1zVAwTBD92RdFQ51gdQ3o8Yl3iU=;
 b=epSR5GpE3eUUkTFWr0qsGejDOxsZ1sIXFz22UG46pCqx9kyTduQNoEKCg33VbdwWYBqFtOitzld6D6o0uwEfOOKurkmVI+TlKx4/CI/E1yS0fpSb5Ka5NuNsOvXy9A196wdya4xI0vjGQbvTgKGpZs2iJt3lwFwpgPl89CI54izGtb4CeMXAT5IkPCwVMep4+P+0VXVv4e238368r2jg/3LV2tIiGegUOrQQi0SGQGHVDlsBYHq4ZJ1ISCwKxpOjL2RJuwDf+89bV3z336EtjkxssXVdQ29i9RmiVSJpAhHDqe9Wl/uHFFMBNfAd45W6BhEgSOzF0EWzT4VTzObYsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uchmF/jquSUA/PwF1zVAwTBD92RdFQ51gdQ3o8Yl3iU=;
 b=gjVO9vRAsbDyM1ZgLHjUWtK8uk3i3lxIoudwgdjw2OSC2NCcOQH0mn1j9uO7AoR4Yzjx+45DzDKEgeAZ9wKdI8U13rfItffJGRKXPtfSdDkOCkNQfo6Noc2QXNjzNHcPyBksF1BESFCjCUTxiy3FqoPOK6D2AP6+xegtb5WR7gs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB3160.apcprd06.prod.outlook.com (2603:1096:4:72::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Tue, 10 May 2022 01:55:44 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Tue, 10 May 2022
 01:55:43 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH v3 net] net: phy: micrel: Fix incorrect variable type in micrel
Date:   Tue, 10 May 2022 09:55:21 +0800
Message-Id: <20220510015521.2542096-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0080.apcprd04.prod.outlook.com
 (2603:1096:202:15::24) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9836dc9d-dcc5-4517-b9cb-08da32283131
X-MS-TrafficTypeDiagnostic: SG2PR06MB3160:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB316076A9FDF602DC4DDE6BCEABC99@SG2PR06MB3160.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iRHQo0Pn+ls6qBW2b0yoRJRr8FPIIyF4jD9cMydtLtClRWaM9aXqO2qDTkqJsltWSo3FAjBupbMNJ1tQ8KnIAChCWAwNCKWowRGE/hPQAbsmXe8umzkd/nCRsPdDkhcex6dDgYff6lYma6nO7GqPXagAY7Pxlk56g3PeAOpT0P5J8s8QYMQlHOrYcrtPJ1f0BSLq9m6PwKQFTB3ChGTSRhxNP4KwSEIjaWo7W+pZKojy9fv2qz6wq9ERAJiE6TnWENVVPdkxb+6Xk9Y4J1ETWP0xDB0nCDjTbVKq0Sks1BBoQjlNj0AS+ntH7keKubZqpJuS5VpFiiW0mJpPX2ILvqyJkwKnURlNvAaacVaTHZAhex2Evz1ddA03BzLWHaQ8RN6C9/o5SjoHtf3Qu9VVuj6EYNaf9nIOZL5xxcGKzdNr1B1pWDu7vJz9j90NnfluCB5khg+3Nr/tI80ShN+zvevczeMRDOh36bi3a4yVQdWpM0uz3HO9fDjQItJoVzjraazdQO4OBjTnjikD2DlANMziSmd3E8nhHQGqbHa72Tt1QLQu7fwl6slTBL+qn8BUtpxU54tXqDxJtTPy2jTJTEkZ5fKX+77RyyE1WledUpbHKVj7o0mzerJdGJQxpJSumMzKhwfEMapn/wvHRaRmhvHgcoRA5MpwvYGjWwOBjzA+l5P6XqSEqOLUwQRpB3nWtYr80djyai3r/0sc5kzkVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6506007)(316002)(1076003)(6666004)(36756003)(6486002)(66946007)(7416002)(8936002)(186003)(2906002)(107886003)(2616005)(5660300002)(83380400001)(8676002)(4326008)(6512007)(26005)(508600001)(66476007)(66556008)(86362001)(110136005)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?99pfK45AXwYUY6PvH5GZu4qrsJkTnjIZXHpUjNoouXE93oK2sZ5Wj7T5sC2D?=
 =?us-ascii?Q?ULXQqXx4LX56tzHUI/gAubHkLUdCsru9CyMuoTmcZjsR0m9g/oSI3LV53Noc?=
 =?us-ascii?Q?MIUl54oRaUnOZ1QFOMEkfzwVaIBRRSAJbink0OFhlC3uQJ/ugZPXbRwd7y+K?=
 =?us-ascii?Q?b0uPD+uEuF0qXCdAF3xSTspR1Wg1+iOMQ5GkOj29e4GZSB9R6WwX5ey/dviM?=
 =?us-ascii?Q?uSdFm/WvjCDmkAlSVATsjbXDKVqNKzdONDi1/epsCpIIQwvUHdxNp6lqLP2Q?=
 =?us-ascii?Q?Y6Jqia9VHvzThvG+VX6XNPjXIJhObu7Ax1qvKBlqpVtV3xZE/8v2kFrec13E?=
 =?us-ascii?Q?8G3aKxbd8WFPka3Q6Cb6V5yUhYWhk2pCSBwDt9hgzbieg+dNHNujeg4xPCpv?=
 =?us-ascii?Q?GasjjFroNNAVIyE4L4oSIFSg0UNIxD8pNcOxRll3jL1t2NV0kyddPLmRI67l?=
 =?us-ascii?Q?X7zq/uZ7W+x3jHjs1mN/KDQEi7AcAxMrkcOHQvPyzGgiQrBmy0oSLZAeDHWO?=
 =?us-ascii?Q?Le7xO4RvfqU6obMI0dkWJQAc0hnpL/euwvkcSEVv0CoDRXSDfIzPLnXHA6I6?=
 =?us-ascii?Q?MpQ6r1ocpPIUzDyW7H+Bb3R6wwrAYejAgcksXU6eXISAeSVQQsZ4CLevtd0d?=
 =?us-ascii?Q?166VkDC9OWxCwD+Al9HBhbB8FBG4Wbt2+eAEVeAjyDeffOX3lsy4biAaUSO6?=
 =?us-ascii?Q?87zSt1/WwNZAwO5kc8unj7UnmKHAGHLPD6urc+9DS3zQAqMHWks51H4HWZ1f?=
 =?us-ascii?Q?nvO2c00IQvXOjDLYajbjNWQDK4XEYjgcIdvbclT1AGpGPN8MVvPJs7WLY7jw?=
 =?us-ascii?Q?7XNiAwQoqAl5VvfsGA+BHT8ZsAcbXVh3ndJYGm175bgD0hLp96HP1yaFriKc?=
 =?us-ascii?Q?25k28YSCYuherM6aspo4bZ6yZKiDaU2gLJjbhtYkZjqpM6puTctWBM+DbAZa?=
 =?us-ascii?Q?ae3FqMLph+nvxKOeR0X7aBny6JRf/MtJADusl/D1yReNVKEJow5+uC/NXLC2?=
 =?us-ascii?Q?b6BUiIMMt6gdHDRWmODaSyCl7kmw2hQYb902AJD9XS1dgLh552jUocDdRVr4?=
 =?us-ascii?Q?gLARxBsxDQib//Cjgip4ypWb5OlWiRQ8nE+HNF8MO7uuZkyv6W3IreRJj/4h?=
 =?us-ascii?Q?DQX6PUp1eCKfcYvYoO9eBRw02wyLwCYADazIhSuLfayNTpVWJqFm/Yugu0TM?=
 =?us-ascii?Q?gd1bkREKQJNmNh4ANBVjX2fyRr53xvSo6MDTS+Q5wBTyCR7EKuGuPXprnLsU?=
 =?us-ascii?Q?63xFYJJ8QcQ6wdC7a14mqbmTcVx7b03wGVDBSQILtc1fvDLaWrKlx1hIKrAv?=
 =?us-ascii?Q?2ddKdEeHXINWcLu9W0MsXW4VySm+01Y9RE1l28w6D9PSSnWzxJqMHI32eU4n?=
 =?us-ascii?Q?6koSpHGR+uqcg1ZlXlenN6S/h/EAZQLgCvmdty5h4g2W2OT75kEvK4VYe8LN?=
 =?us-ascii?Q?hj3Xpvy+mA58nL8ZGIY4QpBiDj9XxpszowVzKxTAMYpf7tzPgrmyX8yXQR0r?=
 =?us-ascii?Q?//sZLsGiGP1YRZXySr2jwe/AbJ8YAIuJEORYKoRhKXzKHWWpkQ2YlVctTXbo?=
 =?us-ascii?Q?NB54qpiz9VeLtggWZBhJdIp0g2A20F3VKj6zFCA2xP2Uk9elbS9LE22InRHG?=
 =?us-ascii?Q?179nGsTfgFKvNvT8OpCxW++NjuUiAdoYLwhUej/9rPNrIBwmPVLIaE3Ix5Gr?=
 =?us-ascii?Q?jJZ8yGCoLWlNDr0Q1IbGDQdY8f1tRuZrmvqJlISYxy1+TZNsF1vc9fVbGAFu?=
 =?us-ascii?Q?NLAKte6nsg=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9836dc9d-dcc5-4517-b9cb-08da32283131
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 01:55:43.4894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6HJPcLFKdxcqPE92ZlTppUKrSVudqksWxp52ZshMctpx5HTiQ+P7Gftmw3pAJ/3TMbwZKxRSGttbe+Vlhuk5Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3160
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In lanphy_read_page_reg, calling __phy_read() might return a negative
error code. Use 'int' to check the error code.

Fixes: 7c2dcfa295b1 ("net: phy: micrel: Add support for LAN8804 PHY")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
Changelog:
v2:
- Add a 'Fixes' tag.
v3:
- Fix a typo in subject line.
---
 drivers/net/phy/micrel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a06661c07ca8..c34a93403d1e 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1959,7 +1959,7 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 
 static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 {
-	u32 data;
+	int data;
 
 	phy_lock_mdio_bus(phydev);
 	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
@@ -2660,8 +2660,7 @@ static int lan8804_config_init(struct phy_device *phydev)
 
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
-	u16 tsu_irq_status;
-	int irq_status;
+	int irq_status, tsu_irq_status;
 
 	irq_status = phy_read(phydev, LAN8814_INTS);
 	if (irq_status > 0 && (irq_status & LAN8814_INT_LINK))
-- 
2.36.0

