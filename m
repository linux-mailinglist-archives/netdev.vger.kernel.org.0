Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC707392D90
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 14:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhE0MJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 08:09:06 -0400
Received: from mail-eopbgr30045.outbound.protection.outlook.com ([40.107.3.45]:47124
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234473AbhE0MJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 08:09:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/q/W/YBeSkLoVjFJbQwv0n8w4xiC4ny+6yMTrIKqN/T9Js6tX6aS9Y8cv1lie1GHWPLy8J4o2rao88jGOzqNf/IjzP2Jqudoznl8SPzyOi9cfIF/QPO2saGd2pZaWLY2ABXfWs2Mt75j/nsvRDcoKbiUe3ZG0ekAMJF3QSX2l0JWx/E5OaY7MhxNNt6k93tU7Jk6f5D/NMpQJajEroUXOXBI9OQQQCmNIOAiX9yu3/kEPDvMeG6OUoJQEbrfVKS0Y0gTlkib1Q36v3pwTg28y98VusZKj+3PKlfKdOEuHxiCKvCrTaLsCFGcos3FQXeTxYmoazLBY/z1tTPvPTnYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2IvR8Nj3rTdcn7cHYHCWmZwACZ+Hbh4HDyRN0y7HKA=;
 b=N0rkgzMtJHDTdXCi8T6vinSWuuWc4kHfSm2lz1vev5+I9rS5v4yQjG4Hsg2RCF1obC7uLhOAKa+tDxJH4YL1FNNOA8yiDi7D4yAu5UeIsdkxIFGQI1KOX5U35GVCVVguXBPWVTP+Xaa1YBokerNQUKSLIbWCA2uZmGd044+ZrgxqVIBbuWjPOG5jIqxeqno+NYgZcKedcHp9naml68qgwqALOHXANLjTUaW8119V1mIMIHnAobOavYyywOhdT/XnIA58/02/0F2A3EPogxLZHdH6GUsOsdEaEp1PDIeuyqQV77RI482POYvZ1j++qzxNW3Y4qu4MbGV1YG1dshmFPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2IvR8Nj3rTdcn7cHYHCWmZwACZ+Hbh4HDyRN0y7HKA=;
 b=ciVFGWHIxgKF5SZXfENr1F0wHWt3aI9pOwhceQ4pmgWLr/xPTdSkyRW42goLAJHkGg93lt2fT35zZIT44W9eERd54u2iq2qNCjDsu4uHuIH34C0W5HGpyYNYflu11RAm7zQ6H/wS0RscpHfyvc2oeuuTdIw77mJ6ejGk5DXwRDc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 27 May
 2021 12:07:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Thu, 27 May 2021
 12:07:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Date:   Thu, 27 May 2021 20:07:20 +0800
Message-Id: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0110.apcprd02.prod.outlook.com
 (2603:1096:4:92::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0110.apcprd02.prod.outlook.com (2603:1096:4:92::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 12:07:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f685d8b-3063-4f0c-7c68-08d92108001a
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB69713CAC90B60A1CA5188C94E6239@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KfCcpREpVQsDst9tsHBD8n5ufKo+1l69TCbhTJsUbiIojR/7UzrhZ5dxjttdKomtospdMyhHydtwEAK3+mM1Q+WOrCkIOtM92k8U8IiDKFYFZB6HAkmbeNqUHyyOfPfXPK2te37kGb5gyki4H2qRssf0Z85aJ6Egji2C0bZZmvUJ+VQ4wXUKWy6GtYxEUwKqaOFM1+rTUpsEQvmu0Bir9O56pp4sHPnkAy8Vx/+0MqfUTzP46W8BDP+g2Y7Lw6HLCLKo7qq8x3+m9oTfLR/Xjrio7lOTZcqhSCP1krh1gWzo2UORJdI8m9HuEU/CGsOyDGPGf6+G7ZC+1nk2PrFy6ra5W3oo0qWVi0fr2UvJ0u9ZpgB8eLWO7YMW4Q+Nd/SCSuJFW8eY2eB42abj+heOg53Q67qQJNwujrBvfS/lyzJS+/1rFM+EA7QyBTXQ+91cOtMBzp97j45Xe9Nt1ha0/vOKgvPh22CSmhsxMa0ROOv7qjc0f11kImaRd9rI7ksabb5kBvyr3s+qATB0R3UX6JUm75Q7TSGgcdfRvBmDxfFMCj5Kg/lGwH4rWjS0qpRylESWMsbKYVfLtZEtSm6vEYqj7Jo0PfzCkyQ2hPIdGqJabLKvpIgPT/Yt6NMeWeSwCe7v1qmWjuK6/mrDod2kdQ7BTbtf6/akQde/haus1Alm4a3Am1faTFUO6/YADlO9TZm7IbQlTyb0uwOjFqgQ+MrRqme8Mw15m7ILt0fGG93PgJ0WdjpG5pK9v/fOuNouzBP+cFJeNMhD9LI+ez+J5pvPoDvUflAiTi3EUma1xTtgVTZ+LLy4ruH6MtCbFaGE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39850400004)(396003)(376002)(52116002)(316002)(86362001)(186003)(478600001)(16526019)(4744005)(8936002)(1076003)(6512007)(2906002)(26005)(5660300002)(66476007)(4326008)(66556008)(6666004)(6506007)(36756003)(66946007)(6486002)(38350700002)(38100700002)(966005)(83380400001)(8676002)(956004)(2616005)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1gcQYDIV+Hu49AM844t2TbHipgOoF/VPL6I7gCxx8VmaDIFfS6LgUAQ648wt?=
 =?us-ascii?Q?U9obLjD1f3jNEdUAUBO/o0gWAcI6Bsnu4wQmPvdpr+8FsLRcgoanjhuOBXhz?=
 =?us-ascii?Q?aw7vSgmQ6XDQOxN3fW4TQyH0JJx2aIv8Isd1yfRdoVKfeyFssoyys3ILp68G?=
 =?us-ascii?Q?W2OA2FNe2S4376zmqiXYlO+aI63rVXKW+VbRRZF2D/JYsJdPhOvWs7gMVl+3?=
 =?us-ascii?Q?1Y09KmhvtaHH8IADK5qn476do+MIoSEKiUAu68FDVwzwDmMlDzLlXI+VhO1Q?=
 =?us-ascii?Q?tcj0PFc7UC+sD8W4w+GShLbIA0paRqc5uwdOQlOEzMurR8bKyTSkavACz13N?=
 =?us-ascii?Q?9y0uP53jivwC9B2tyKq8U8wuIDGyXQJfKVQ/otDkBdBT73D92zR4rfstFj2l?=
 =?us-ascii?Q?QAr7uny2yTNDU7CVtU+r85t8eGfzyE3LrRHUxetSbZRx1xF/irgy2IJ4fLoa?=
 =?us-ascii?Q?Gw+mu0jzXHJoeyH33Vl4XSlxvHNTVOhEHIZo/pbPMIZ2SKwhgzvACc6Th0yb?=
 =?us-ascii?Q?gbJDENTyDVShzpDSlrjsRhvAXW3aEvE4kPg1MO501rJVHNOyDt2oyMsuVAvl?=
 =?us-ascii?Q?zEAcQasB67OlmsmitrMSIH9n9AfP6VfHatx79uMbm4ySFAwCsuL3aVeXUJQy?=
 =?us-ascii?Q?tKrNYlZqrtqRR6oIU99CAyEZweHLnkkT+oFHiaRICdj1gbFr/8lVrT3siLUa?=
 =?us-ascii?Q?Mgy3ptMT3rfY257GxEs7NZZejf1lqb0Ryj/pTtjjuuJiHtk9NuBeGzBY7r9u?=
 =?us-ascii?Q?3Dshuy89HOMLWVU24zC6ykUgF0M18QcLoYryUgwN8XmwiGuwvl4owTAkh/4g?=
 =?us-ascii?Q?mgu2m2YhHT62gAEdQhmlsCshCz9iHw8xMBl51jztDYnNa20yfzTM0YBqwTZK?=
 =?us-ascii?Q?hHsBYKZCYdzk1uUFf8+op1SNbEL5ABdwxZYVGghHM3Qcnvm/kQG+49GSyG6c?=
 =?us-ascii?Q?GpJ75EBoKWAseIVU5JMtFyomHSrBpSaLq9vkplDt1u4GTP5DPXyCqQFA+lwz?=
 =?us-ascii?Q?HmnvIDHlHb9AjddHvGMl3f0sMG4XAmK2ELaHyy+rMZ9q6ij2hhZlffuCq+y2?=
 =?us-ascii?Q?Rw7d6ZaqHQd7s+TsRgX4JVIN1oNPmIsluv7y2nFCo4rHi3EQXQH+bBnpHnPP?=
 =?us-ascii?Q?/XFzG/uPFs8eVhvVVPI+u5QLV/MBMJQzufcpV+0d7Iu/MBQfB/OAR/xGjhKV?=
 =?us-ascii?Q?+gJF/p2A4ZowROZtpOwW/4XpGEbjJwhypOxh/ZDdfOjwE05N5o5W4VB54+8G?=
 =?us-ascii?Q?H1iOAHhXyqtRMUZ6jK+YakVdK1tJd/WYfbGc0S7q9Cpl3Wg/1djNhkbtJtJ/?=
 =?us-ascii?Q?7snH6brBrxaQnKkvE6fDYo/i?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f685d8b-3063-4f0c-7c68-08d92108001a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 12:07:29.7863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1rIscBTLSWlJUfAU7BtpwtRxPCo8LtIystouH2uMGcabbNOg1FYt4H6CNZ0nX9NMVsOgHnW3aHg4Y+4WH9DQuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set intends to fix TX bandwidth fluctuations, any feedback would be appreciated.

---
ChangeLogs:
	V1: remove RFC tag, RFC discussions please turn to below:
	    https://lore.kernel.org/lkml/YK0Ce5YxR2WYbrAo@lunn.ch/T/

Fugang Duan (1):
  net: fec: add ndo_select_queue to fix TX bandwidth fluctuations

Joakim Zhang (1):
  net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP

 drivers/net/ethernet/freescale/fec.h      |  5 +++
 drivers/net/ethernet/freescale/fec_main.c | 43 ++++++++++++++++++++---
 2 files changed, 43 insertions(+), 5 deletions(-)

-- 
2.17.1

