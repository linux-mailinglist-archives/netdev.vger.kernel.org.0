Return-Path: <netdev+bounces-2883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A725270469D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6D0C1C20D7E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5881DDC9;
	Tue, 16 May 2023 07:39:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AD41DDC7
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:39:32 +0000 (UTC)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2128.outbound.protection.outlook.com [40.107.14.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957D51FCC;
	Tue, 16 May 2023 00:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tsvcd1x1gwrPw/4PR9J5xdlgXdMVZ+UKIWkILtodeKMjJvN0rB4eojmSkLdW6APRCVUL7fXeNcbHNUqh5hrai3rn+UykRVCSmzjlyTstNssdkycE5HOWzHuKALvo6sDKCWHfw5wwTHkAkW6InD8TXqzBoPniDofz6E8mYqsfHm507ITrzMSDQX7+KJcui/6Tn5ReO58viKCxbP/bOdRpcxE1cjhYuLvzlnO48YFBx0BM7NCxScvr9mtOT834znxhynlyOlg6bUy45eRWVGYQbw+EOvHMzsKLIARsEKqP9ggHBFACvg1efBTDETZUML1c7amVFY6oBqDZ9vy06SzoFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FU2Q/MFbKc4wZfKf+YX5CzP8xtWkeacER693tKcWVM4=;
 b=T8jy6WKNkAIbfrWQyZSAcUkh7UXN+mJ7DQV8vWJkGio2q2+PkarFAClzFLMB06GLHDSgkOgCnVpHrz/+smN3npvCpr436/BemLSkr3WsTs5nUyqfaL94vPpiHMWD8SuhTf6t6nrEYdjHJQDhRDihSbVl1dtazn+/Azx9N5k0bcenFqJHoWxqugKds+KkXbubnyRJnc+icUNGYht7OFekgztp5Z5Sx++oWz2FBbSfJYBrYRRsMZ6Ugp7oTtoEP8GxPqUdjQvIf7DqL+SlM23XY6dgjyLzXv5/ka0Oh6biWwix2tNiV8nGjERb3BfdaFf444IyiTvkQaPfE0WWOXpcNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=tiesse.com; dmarc=pass action=none header.from=tiesse.com;
 dkim=pass header.d=tiesse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=tiesse.com;
Received: from DB9P189MB1626.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2af::17)
 by PRAP189MB1827.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:27b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 07:39:27 +0000
Received: from DB9P189MB1626.EURP189.PROD.OUTLOOK.COM
 ([fe80::f6b6:1762:92f7:9ccc]) by DB9P189MB1626.EURP189.PROD.OUTLOOK.COM
 ([fe80::f6b6:1762:92f7:9ccc%6]) with mapi id 15.20.6387.032; Tue, 16 May 2023
 07:39:26 +0000
From: Marco Migliore <m.migliore@tiesse.com>
To: andrew@lunn.ch
Cc: m.migliore@tiesse.com,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Ashkan Boldaji <ashkan.boldaji@digi.com>,
	Pavana Sharma <pavana.sharma@digi.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: mv88e6xxx: Fix mv88e6393x EPC write command offset
Date: Tue, 16 May 2023 09:38:54 +0200
Message-Id: <20230516073854.91742-1-m.migliore@tiesse.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0063.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::30) To DB9P189MB1626.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2af::17)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1626:EE_|PRAP189MB1827:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ea78916-f468-468f-1702-08db55e0ad03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+4DBPLA1GAMupGrxX2FFd2yKh0azoBL7t3B8XBBVUs1UtlG2fkn+8XzUSBoD4mdNXYoIfS2ostTha6R/hzKHDpSJiz/vo8S4DOfGnNY6m28oLZAGuJQ6/gwFlxtyyMUsBat/PvK3jEHfd9rCClr2tK4MQ5KHBveUPUhQQASOyvZW9NDwy8RjCzHM1Z7EdlhtUpBC4//Rq4FOSKFfwSMcMe+UmB288+SG5Nst4ftb3gAk887oij64azmZqpQnW+hfYuqvNbFW9Lqyc+Z/CCpjs611PcTFM4bz1bvWRy98uRYK4tVXfCPR85b9OR7Dq9sODCVumIYSUA+URwlqCyf5t8bBFM5nfNH1uMhrxCK3pVJ6qvM1gpKXDYEIRuWU3Rf0wAdLLhO/kEDX1wmGklAIrpbG98wIKt+4pCpHSLuNXPFa57gqHZFvU7y0GzW/rQqL5dU5fcFiBTusFDaCBdgGKuwdh6fO+rxaO+XRTNXvkCDG8GGLmeBkp/WrDYqKfnmyGUuXAMPI1Mu3yixyUM647c+gOn3ZDPUBF9BRZMKoJhr/bvHUm7QcAgTB8DahljkXXnsHCF4zjDdnbaPun5sBtudH+/HC/zv7ZtvEYvUCM/W6lZuxPk62RTDWaSz8YLci
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1626.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39840400004)(136003)(346002)(451199021)(36756003)(316002)(86362001)(54906003)(66946007)(66556008)(52116002)(6916009)(66476007)(4326008)(6486002)(478600001)(83380400001)(4744005)(7416002)(5660300002)(8936002)(41300700001)(8676002)(6666004)(38350700002)(2906002)(38100700002)(6506007)(186003)(6512007)(1076003)(26005)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uQfltrEwLWXxFjdmoHh6CGoil/Bb6wSkmOZBwg2uEEa6xmIMjJKFMErR91Tu?=
 =?us-ascii?Q?bcqnU8gW1xoqOXpLqsE/YBee/f2c21L3vTaSn3V5fG68rFaBsP45G5rNnxAx?=
 =?us-ascii?Q?qlSfb6Djf7ZWRaZH6/XHLZT++Hp1reYRzVisKpsZUu9Iu16h5x614URy4wb+?=
 =?us-ascii?Q?3MpGDuVPm3DkakMbI3/x7gMQ/gT85FARgUsg5DYIrjOP0Hh3Q/oXWS/q/flY?=
 =?us-ascii?Q?LuJhiTVXhRLZ6eBZJ/0RaMAiGaCkP2p7MqYl65j3QIuetU9cbe38KOQTeEif?=
 =?us-ascii?Q?GkJFdxAd+tI59T6DVMpOwD0Y3uqotsKmSBcVXMRGJ547JRJ7ZPMe20gAS/9A?=
 =?us-ascii?Q?rj7077hFjw/NJx5lVrku8J6FnIFFsQEMr/1swrg+U5rwcSUk2j6PoQ//GB+n?=
 =?us-ascii?Q?glvuTHTHG2cNNthK63hoSHu151lnGs6b2fi/WEnETfxSyaaJZdMPtd00zJk9?=
 =?us-ascii?Q?Xqg+pEAeH3MObeNdJFkKvQ996K0ND7eqdJjQPINonforKHi1H0hC42R3XJqT?=
 =?us-ascii?Q?L8zHw7AKkNoUl6ZVUDq2/+OoYFDY4YjEXMhUCqM+G+BTVi7mKchjr984a7vL?=
 =?us-ascii?Q?suqSaPAUCJ/XSJohcZg0lyBteY7PXMRt1TufF0j5QLCyAECxESmCjjHLFLxV?=
 =?us-ascii?Q?CLG9NHdLCxL4ihBLSUs959ZyyP38JwFaXjtwgn3GB3RvAyCq6OJ+89wLi3l+?=
 =?us-ascii?Q?2JTfTIt/JJIRin5ioRE748PO491vXGItqYUHenyDKo0AgntSsFr7EJVe+eow?=
 =?us-ascii?Q?aujx5AOZOeZwsmg1gkBtdGs/d3ucHL3BUOgmKoYClrevJcay5m5r7wc6vHdN?=
 =?us-ascii?Q?DMhpcrdpRs5Yf3mDMiQH25vBaC7FfAdS+VFcqncp4ZAg7507rKbVzdXNOU33?=
 =?us-ascii?Q?TfCl0G86YOkMSkSEyF1a4jO8OmV8VpJ5KQAQIJODaU7u2yz+AcX7+jEMK1mN?=
 =?us-ascii?Q?XJaWehkZPNbQACb3BolSUOqNEWqgTD2UgYbFy0ljG7qlAWZ5+mRM7JlQ29eO?=
 =?us-ascii?Q?JMmMp9xIuxCPkDsxtNeBluHjH3mg/poKf+SZXtm/wegk4UkopYGLBD2j+HNG?=
 =?us-ascii?Q?6WCMKhuyCGippQa1PJKs7fS38+rQOOaooGww19nlHb5QCJ/zWO/YJ+Bwqhwd?=
 =?us-ascii?Q?vldIr463nt7x6t4uIINWRZr4ZOA69+9NwpMRQ0dxpmM1q7LfP/mC3lyaHOHM?=
 =?us-ascii?Q?NViVmqNMjEey6AU54fqdA8Yy1fu+07NzCh8JzFtCi6a0xWJZBG/UAqorL0HP?=
 =?us-ascii?Q?08CmXhmTYt5tLEGtbOnGFVI1ewMUwkmujXM7Om0I+mXIoi2SE8vPzkdJHI23?=
 =?us-ascii?Q?bjYqqdv3727l5STEARQEUroEubBcBKUSGDqZhoKU1ChmCetVM6WwbDz0rYwm?=
 =?us-ascii?Q?B4UDZ1pwwAAKIcLKuHAuDZEINQpJdBhy1Vg2VzBlGF62snwKN7DBGrzSB12m?=
 =?us-ascii?Q?yIIVXUjBwM8/X5uFiN604VyHhIGPFZoBA3cKR2sbMoqHTiwCLFkgaG5Rj0cQ?=
 =?us-ascii?Q?qFvon78w3BqaHNvtWn7W5xKpfBTEFVsK/ArniLIaZ+zBVw0ngWWYXd+/osTh?=
 =?us-ascii?Q?Vmy/bFrEqQ0PqenBk9VkpZ7GQ2KyCg8ahJ+eLepM?=
X-OriginatorOrg: tiesse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea78916-f468-468f-1702-08db55e0ad03
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1626.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 07:39:26.8382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1d7a2948-30aa-4ea7-8dac-d5ab64ed5cb1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rbD15BYKqVkwHLytX9r/HfoUG/G7/cLGnR1Z3+ft/4KNJ62FWTMQRox7AHRVrzmlAbZp8A6RF42apxJSx8HyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PRAP189MB1827
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

According to datasheet, the command opcode must be specified
into bits [14:12] of the Extended Port Control register (EPC).

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marco Migliore <m.migliore@tiesse.com>
---
 drivers/net/dsa/mv88e6xxx/port.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index aec9d4fd20e3..d19b6303b91f 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -276,7 +276,7 @@
 /* Offset 0x10: Extended Port Control Command */
 #define MV88E6393X_PORT_EPC_CMD		0x10
 #define MV88E6393X_PORT_EPC_CMD_BUSY	0x8000
-#define MV88E6393X_PORT_EPC_CMD_WRITE	0x0300
+#define MV88E6393X_PORT_EPC_CMD_WRITE	0x3000
 #define MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE	0x02
 
 /* Offset 0x11: Extended Port Control Data */
-- 
2.34.1


