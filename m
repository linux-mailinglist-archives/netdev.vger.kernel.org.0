Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B345BBF9A
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 21:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiIRTsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 15:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiIRTsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 15:48:08 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-cy1gcc01bn2071.outbound.protection.outlook.com [52.100.19.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBAF17E3E;
        Sun, 18 Sep 2022 12:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SjwHyixpJl/EJ0nhWoMiHQI3c2voEajLMY97n5Ig9cQxe+UHsC4DLCE1TV0r414fkEtyEjZPqA2NWoL/OMI6MH/94/x3ZMUmvxeMR0vF8E/0n1XyabH60ZTLdVoS1dsepsmYAfuPpuI9HDaJXBRdZUHwOwsJPVvZ27WSW5nKqI0jXQHhcyQbA0XeLgE9fwmpS0yL6bifCzm1znFwU8krgb9lrGDmBdXGP8Y7RECgPhItit62ityiaqz+tG9hgc/FSemAMK3Y/r99aiR2HeKa3GLwYdCp5gz2dloq3qTiaWf9JZIw4ICT521/w2riCxxa432d6doTKyTKDb0pJ7cF2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=J7SZ/J3u5E2BObQNeq/5mIw9OytDNO+OpVDLjcCU3LWlZovLamVagNStshtJkN7B3sESYGeZDTCWxP/xGndyVs6uYwPqsrNyu6nrNcVO4grtjMl4fFutQ8OWwIWEWmNDAvd3KH8MfmuTNOG6T//anDOz4mGrA6KKBWydYiHi61m38KV5Hr5XVAt+8Bna8hNVpk072ynekZ48wmxZDdQreWz4qsq/c701Toa6bdhdTBlC5GvWTAD+9wu86v6yyssMPtEyHeC3P4nVyzIF94/H36IGz9Sl9fUjoTsIlj5uCBFRcfbo1OuSbL788RVzCz5ex923MGBuh40iI0SqnVhLmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=A8SuMVXHnm16l0F0dyLoiscpYyp4ybezAeUq9fQbEeZzdG2uxVDp/JuG//dBqCwMFo5jnJEW/t8lELB3tKbPfgbXwp13QG3BDe7OljYD95jDR15vzmCTaT95qfvVs1Nx7w4hEHY6y9O+Nocn5njFX/uGl5/SMag0W/M+nZYEtMk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS4P190MB1927.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:513::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Sun, 18 Sep
 2022 19:47:22 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f%5]) with mapi id 15.20.5632.018; Sun, 18 Sep 2022
 19:47:22 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v6 5/9] net: marvell: prestera: Add length macros for prestera_ip_addr
Date:   Sun, 18 Sep 2022 22:46:56 +0300
Message-Id: <20220918194700.19905-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
References: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0006.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::18) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|AS4P190MB1927:EE_
X-MS-Office365-Filtering-Correlation-Id: 60506166-0c48-4a34-65d3-08da99ae9a9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(13230022)(4636009)(376002)(346002)(366004)(39830400003)(396003)(136003)(451199015)(478600001)(6486002)(316002)(36756003)(66574015)(186003)(1076003)(2616005)(86362001)(38100700002)(38350700002)(26005)(6916009)(54906003)(52116002)(6512007)(6506007)(6666004)(107886003)(66946007)(66556008)(41300700001)(44832011)(5660300002)(8936002)(7416002)(66476007)(2906002)(8676002)(4326008)(59833002);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VbUB5tUQ/sBQ2KKwTAOk0TEFF/XhdUo1u79Qcm/f1R2tBalQf1Vn1sEyhPlN?=
 =?us-ascii?Q?26xqppR0Ph7vbajg9PCX8glRb6mP6AlcjBHV7P5YWYGrUnfETee0o/S/lrrt?=
 =?us-ascii?Q?BA8CdQnRGE7vK8ET9Cz1AVC/aMnTF+OuQMnW4rzdQBa9lLJRCgaAjNMgjNX3?=
 =?us-ascii?Q?hNyCVLBhcU5R2gxRNp9gSSH0zaDnIHbsN3NNTcjhOUyrIaD5nsmN7gUgqaxv?=
 =?us-ascii?Q?LJgtD+0zhVqV3WKvOsiNDWg2c7kVB8Jm0+C2ZEEhGR8MX0Cpv53ygDsADaR2?=
 =?us-ascii?Q?QR/B9R1bM/LYaKlrXz3R+MXoArI2/xtqAeoZjGUKxO0l9jA8jCdi8uAkej1M?=
 =?us-ascii?Q?OYugEQD7dv1ja38Tw7WCTHRMZ6hAXnwuXz7+TUMwWc0j53o2UG18Zso2VDiB?=
 =?us-ascii?Q?ijanAHCVw0qGscoj6ehGE2osF7Jxu/OHfIcTigz6cuLI+nwFGaUqxyynZE8/?=
 =?us-ascii?Q?lPHG6CmA0DDahf5TVPnUF7/RFbR6nxMOuBjO6EzKGbBwyGpqEKF4oVPfwpxA?=
 =?us-ascii?Q?FB8K6RyJqpkjsn9qubWH8EvThgodbHNW9IAGwm7GNXPWYNaD40Ap/bEMN7bg?=
 =?us-ascii?Q?aqJqdqkmZHGMNuaOfE5dBaUbX/tSH+j4yLTdB6/o612BMajqSogIYxEKtqeS?=
 =?us-ascii?Q?7DHQ0sxcJPMvwahd8y8eOS5vVZvF9V4aGEs451ci8yBr8P3KZJpDut7XVf9/?=
 =?us-ascii?Q?a08o8jV67VYGtf+Co0DuijkUeLd2MjUcA5Z5dth4Uw11Z+La2AWLe7EMfOjz?=
 =?us-ascii?Q?ZXSMS+vIbquoi7SvdNI75j288fildX4l9kiviD1EwcR0e7QJf92WI/PL4VtY?=
 =?us-ascii?Q?IVw8OzLRgPlXaQ5EWFl5jkku4e3Jd3DcEGuPvl6O7kp8bbDoBSyxGxWFjiMA?=
 =?us-ascii?Q?0TBXMGUdXMtV62TwjvPkyWG5+8T4ZGtUsOmtNzRPvQjYnxw1xEZeFrOsuaZF?=
 =?us-ascii?Q?k+zR96aQIhb8qGVsQkBzn62yRdT0zpZH3Kj5CCiz+kA/ELrELTOu1HHKHRoR?=
 =?us-ascii?Q?JxJvUKuYnfXOHpc9dlzpmrIIFdCqMCz/YQK4We35G85T6OXlgYsNlnYFNLcu?=
 =?us-ascii?Q?TXQv98egWukVaQhFUg2ZmKGSJQMC6CEXi5BCbn2Y3oa6hURx2LtalqMMbc2Y?=
 =?us-ascii?Q?v27bv1QbZ843s+nVQMfj6HEkcteuIHRFBbX5S7hOXhAZ612INR66ooM=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VhM8ercg2zEwBiFgZVoBMb60+k9WlR02z6fFZTDt8sIwd8DP2oJXLasbFzB9?=
 =?us-ascii?Q?Ve3akhzLlJXnh+mxb6CsMC5XUu0ZPM1wiCHO8hq5Z9USjBOZjeNYqApncG8o?=
 =?us-ascii?Q?L7qOwFfBDDrOhpPmvKOFxpL1YdCnUa+AsjB6Ml7ICocrGdr8ZiPFhSsXqPX7?=
 =?us-ascii?Q?vWQcqXmdnFWu5SlNQIVEwuV3Zu/eMiUdcwT0kMN6XTEVg6eZxDttnXEU+lp3?=
 =?us-ascii?Q?EiPMGEFR1LcXQ7k8WFycqPG7l6qzL3AK00iAa+DQpcumQA/y1W33KHeOI1ew?=
 =?us-ascii?Q?96CTZ0YfXbkdfrawJpPP5Dws7z/UCSyjAtT8SG7SYDaVmncz71fRrO4z6wbN?=
 =?us-ascii?Q?T3tg550/5LXZBd+34D+Dx8uQW9t1oX+UhUQ5yAfWEqnDDqx0RpnnF87ZfRpr?=
 =?us-ascii?Q?x9yXrp+ZP8xUqRGP5Fmk59yr7j1Ja0ylrzmsCz8M65EZrA/nHS2M35eOyXER?=
 =?us-ascii?Q?bgO6H2IyVuSN1W/NLU6looV8yOYP3WTg/q3GnqQQyOqJZIdoM5rQ7zklrarI?=
 =?us-ascii?Q?zPtbskWLkAhwJNbe9cS1RvzhH2MlZsADHpyRUqoq98aMFFUwZgtIe5E7dv/2?=
 =?us-ascii?Q?BuXbgA8uHdZLNQwhcxaWlnNkWqg386C48hEyo/Kf2lFBZEqjSi8wU9/1WhHL?=
 =?us-ascii?Q?G75DUMxS+ojMXWd2yxU/h0Pm1QKMf6JMHMwV+PvQ7Bot5Thr+p4B4WGelWwo?=
 =?us-ascii?Q?xHHRmaQTX5j0zlLZXBUqG+zJOY1jR8qRBZScT9A0NZ5CGCl88/amlm/jzXwy?=
 =?us-ascii?Q?JLWCzcJHpYp7ZHQKuN9OqpfUjYgNbqTZ/s2Ev2g83P8POI4PB+Vvi2RHqNW1?=
 =?us-ascii?Q?4UHQ6Gf2GT/LRFCET4DuXMEKVQSKatNDT5DsenAWHGkiMgZtsSGkTCna+DFy?=
 =?us-ascii?Q?Xllk6+TprJDlZVxPBgPd8vunoSbgQt+BAvMyXbOkO1WTkmJYRVC+EETeUFE3?=
 =?us-ascii?Q?lWuxAuYNFEXT0yuZ8xBznSCnmhsEnjwIMT0ohkNaLpw9MSaiCEO0g7WCNQyB?=
 =?us-ascii?Q?NFO7HnHF1OJP4ZxBEfm8sY/A62G2Jqo5TpxOiAbRRkWBWt86px9KZeZV3k50?=
 =?us-ascii?Q?y+2TS63pNZNn56lRJQ41azsraqPRh5+1qgBxLrpnFXMOxDN6G/7Po9o+n2gs?=
 =?us-ascii?Q?Yns48TgTwy2jgEr7D1JKZ9ozLxOaqK3jSE7+mAqQue69ejrNKjV94P97lbFJ?=
 =?us-ascii?Q?YpT2w9Q7oTFRm7V98YhIP4oblLiIJuivwH4dtRnVSyadLzdhDmGYTFxWBObz?=
 =?us-ascii?Q?POAdgf370jhQR3c1tdQ6Fl+76TFsKdJyNQ5p5oyrjYZzYXdBPZAhUPI/arCi?=
 =?us-ascii?Q?M+Mh/Q8f+Kbcb/FeW67lWJxnQrWGRFERFHDLUmzcsEKEChhfhhu0FLhX497+?=
 =?us-ascii?Q?x1khtNLzBQDEzhioFEJQCaz4c44lL3EOkHvQTORVwlVXcEcQzKDIRJ+ZUfB9?=
 =?us-ascii?Q?yTvFM59lmj9OapKVIg2igjaaL3wXC/DwhOFCuYVTGKfY8EI74HJVcbY34epu?=
 =?us-ascii?Q?up9PMWwH00esAw+u7b7Rnnhra9FpBE4jgnvNzZSkx+Lsh20YQmRuvFN64NTW?=
 =?us-ascii?Q?lmCJmTEc42yOBWpiTCmNVi6+R/+sRkFASXP5bu5wLRrJ6ELe8lTtp0dlfdLC?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 60506166-0c48-4a34-65d3-08da99ae9a9e
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2022 19:47:22.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGyuoNssKOX15SCfXYcUPZjXesD3J8RyIXRwO+JLt9Ij2TwxRb6yQrECpWBNGZslWQpci1L5gOkP4bJfZKV14ok8ySzNcRJn2hJhW6YD89s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P190MB1927
X-Spam-Status: No, score=0.4 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros to determine IP address length (internal driver types).
This will be used in next patches for nexthops logic.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index 43bad23f38ec..9ca97919c863 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -31,6 +31,8 @@ struct prestera_ip_addr {
 		PRESTERA_IPV4 = 0,
 		PRESTERA_IPV6
 	} v;
+#define PRESTERA_IP_ADDR_PLEN(V) ((V) == PRESTERA_IPV4 ? 32 : \
+				  /* (V) == PRESTERA_IPV6 ? */ 128 /* : 0 */)
 };
 
 struct prestera_nh_neigh_key {
-- 
2.17.1

