Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B682303C61
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405506AbhAZMBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:01:52 -0500
Received: from mail-eopbgr60053.outbound.protection.outlook.com ([40.107.6.53]:41667
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405568AbhAZMBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 07:01:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqVioDGgOEdyvhohlUDNrg65IcorIT5fV1FrspsGIGf/pv3fvwnSKg7W6ZXajr8Oonww6VVLaU2xMNhGPUKi10A18TRAeCHI8RV4oltdOTqmgYdNxXSuKzCJCnNPw31aRSfJbchIprCK9836WHUSrrf/qpc8vRAEzlM+Bma+7xaPxjkuH5Kk99eCHQ0PmUgPnNpXWVBG3x3Au+3aSO1ejZvpRzbRwFoUKJijYhM8SP/0wb2aJ170vTEt+3BzT8ypNf0qtcDIlON73A1SUa/vKXDfAo3v44bS1kTAZqhj4ZhmdXj1HdqEA/ARqZwrdt9xlnaq/R4gRoO/iCQ/vccI0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AutBUCxFgaGHVhh33OaJys+o/j9pVesBmmSc5T2m1U4=;
 b=j/XazCJdogDXeWTvRM3lvVFLo5k8qQsYklRoHICyA9ZwcEB/25g/F6wdqbwSYwa4Km+lbj4RfJ/OfRmxwuduoVoLWOFPwAdNmbZsiEQkrPMzASEKA1IlI1N38MbB9vXZ6vplDFTl+qvoAW1p9llJRomyhWs0Q5VGWkpG+QbeMlGQRrNZzV0gI3YiNVmBQ13IcD8cZnCTaf+itW8aCJIk9z9hgkT32VYqNPfKB3gqBBZ0w4lisq6upoAmy0P9uEspe5d90L9JvLtr44sInbe+3G2jFS7UhzSWdAZM+ew+VII9TuZ9/9u7fwCSVzXg6ooJM3uRB/GIyD6TFPKIHgtUSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AutBUCxFgaGHVhh33OaJys+o/j9pVesBmmSc5T2m1U4=;
 b=jmzCHLe45zoOHTC98I32IiIP1CMV9hmlBwf4bqGbhdfSKU+gP8AZEZjlPlg0IfCjD4Fkmgln4Bz5aEPpyOCROnRwNwzDCvIK7IhULENqHy31V2bkwi7DmoAJhTvN4wVtJiqCl/r5MxJo7Ime8MG+6MtTRbOPuwVlDJJnXR/Ta6U=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 11:59:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 11:59:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V3 3/6] net: stmmac: fix watchdog timeout during suspend/resume stress test
Date:   Tue, 26 Jan 2021 19:58:51 +0800
Message-Id: <20210126115854.2530-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 11:59:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5733b17b-d1a6-4e60-070c-08d8c1f1df60
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6971EAA18F61FB470F5E147BE6BC0@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJCK/JHhm14DrmbEtiufY3nAQ5TwRkgF03PggRGLnNqoiGbLGSZ3WJuXcp92ST5+Y9+rJsyVd4PGYYQynRDWyVEjNltG2kjDkGs5EhlMsK5dSVcptOjkyObYumZCaxSg/ZbXhnJVCqL1o8AHjkA2yQ29isCy0V8qFUudCnRxn/Pz5DcadZpWmO8X4vbJ6KgQzqb+7T7CGNBdMjKRjWAX88PiGQYzwwDbfhsfW/CbLjN0GRq4iiWMWfMVW8CJVF5h1ZvBOkjRm25XYJK/OChIkRT3Nb0m9Mv7bUA/lkSm6Be5KcbBJ8pdcC1Kv60pIXc8cVnoHpTbDmYsoCYIodjBfcZkBUFYi/gZDmKzZJypS9EA810SYw4oqhh6Cvt+VxoMTO+rayL0LkkXo+jMtJy3ZeDQ9zA6VmVusQSCJtcCqE0vtZjW7foFscyZQfD4dQw/o6Zep1GE+uFqUyBYIIQcW4bBHraedTJHSWxpVm/vU25fk6ls/ZC5WjtfuUW9G06p1h7hEfisibCtMmj16kSMkltg50HTf54YcPEW07rRs5gm5ZNxpzKXb7rLFR3kC/4c2x0ivCZFcfy3GCwCtvKkUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(52116002)(6512007)(66556008)(86362001)(6666004)(66476007)(478600001)(2616005)(6486002)(956004)(15650500001)(66946007)(186003)(2906002)(16526019)(1076003)(26005)(4326008)(6506007)(8936002)(316002)(69590400011)(83380400001)(8676002)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7X/PwIFcWvE+4Jlvy9h5qLc55Tu4ZtwWIgAqkAGHfEivDnUbGXweyU2HwK3a?=
 =?us-ascii?Q?BK5XhM6QjO4i3fO6QiFGF1eQYjeZyD+/W2P+4Q3gCwUEUId/ufogM5TlpQU9?=
 =?us-ascii?Q?WzKCj+JSN6aIySrBkFlDXLCkeuV6zUGCEUAY1iIKmoFjZ4hCM24twmi+SZPG?=
 =?us-ascii?Q?gSYEmuGU+RyZwjvk/P2Zi8aP5CcwHvA3vwcCjaS3KQOze4A2IxF77kya2MTs?=
 =?us-ascii?Q?kzU3QRV/Tn7N2FN41RXoigpBGrkVOvXFBz6XSkUdSm77xgsjAi4oGyYKu6Zl?=
 =?us-ascii?Q?WFRycLGNSaGOIMt8a5uwhxRrNcq344PwIabXdGyM/P6g689/QXl3VEb+vFPw?=
 =?us-ascii?Q?K+7R362EL5q9sEMWGOAR3Y0REP/jzZsuWp2GHNLR2HraMH5I3ZXVV3jUNVpY?=
 =?us-ascii?Q?IqGxKjeWeRlTo5zuOOxYwLl0pFRlWknImloCaQTfCFwfrvxlKjf7V8Qon1qf?=
 =?us-ascii?Q?7nA2lRT39r18G7iXppi6QAV4cuDsKrSEcggvIDVSUBV35fQ40X1A2Opbaja+?=
 =?us-ascii?Q?uF2r9RObQkeoPtPhLW+Z6WyrDlC46E+3F1js5iezfXiXI66Eb5LMoMZgTYRf?=
 =?us-ascii?Q?lfxclPk8TXPnScs/bVjbFJtRLT+VqqLYv5+XI2SLgK2iztXSH5tzeAkJtKE8?=
 =?us-ascii?Q?pKYCMCHNbQiR2cGAzNVFDuXJAKG0ICwTS6nv14G+oeufx/kDg6x7ZbITib40?=
 =?us-ascii?Q?LeckT++wLQFtHQMwLIKf4sZP+q6YtcoXvw54jWV/WCcj48Vb8CxOzmVCejvZ?=
 =?us-ascii?Q?S0TBqv7tz5WNcKs1qNZVrITUfAX7fDqd98mFReWhJnz10yRNlUm2V9Dq/P/T?=
 =?us-ascii?Q?1IJl9LrWOJq4LlXTZlXyoJK7tpSL/bGnzcCPZe3beEZCXhvlhBFKF7x3Hhao?=
 =?us-ascii?Q?HK8T0tCLMRJ5yGI0gZCvqgvAl6HH2Ql4U6sExdYa124Cv1qySApcVoo4erk5?=
 =?us-ascii?Q?BilJ9eareT82SRu88/i8rTFkzytS21zj4BIlnSuunSGdWbY4KvYQ7HR01MIe?=
 =?us-ascii?Q?4cBB/aMCovV+eS6DTGtAKzbyZNZJaXuNTEyrmlbZyq2FIGDdP9YS31alfc/0?=
 =?us-ascii?Q?BXDnIfVg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5733b17b-d1a6-4e60-070c-08d8c1f1df60
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 11:59:45.4246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xR5ZDKZnCRjwovvztU7rA2ZG2CZuIo8EmviTImlxRSJ5XdS9935oOjBy6vrMe1AFX33/GpFEYzH2LYdnWdufTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_xmit() call stmmac_tx_timer_arm() at the end to modify tx timer to
do the transmission cleanup work. Imagine such a situation, stmmac enters
suspend immediately after tx timer modified, it's expire callback
stmmac_tx_clean() would not be invoked. This could affect BQL, since
netdev_tx_sent_queue() has been called, but netdev_tx_completed_queue()
have not been involved, as a result, dql_avail(&dev_queue->dql) finally always
return a negative value.

__dev_queue_xmit->__dev_xmit_skb->qdisc_run->__qdisc_run->qdisc_restart->dequeue_skb:
	if ((q->flags & TCQ_F_ONETXQUEUE) &&
		netif_xmit_frozen_or_stopped(txq)) // __QUEUE_STATE_STACK_XOFF is set

Net core will stop transmitting any more. Finillay, net watchdong would timeout.
To fix this issue, we should call netdev_tx_reset_queue() in stmmac_resume().

Fixes: 54139cf3bb33 ("net: stmmac: adding multiple buffers for rx")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 11e0b30b2e01..e4083bbc092f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5257,6 +5257,8 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
 		tx_q->cur_tx = 0;
 		tx_q->dirty_tx = 0;
 		tx_q->mss = 0;
+
+		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 }
 
-- 
2.17.1

