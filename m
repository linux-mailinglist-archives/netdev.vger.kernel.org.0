Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19281469338
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 11:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhLFKRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 05:17:24 -0500
Received: from mail-zr0che01on2133.outbound.protection.outlook.com ([40.107.24.133]:8033
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229712AbhLFKRX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 05:17:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8ea6gNE64/Ir7iv8XjaXu3PvQH0mu1GmHMJGKKn9Viu1TDSGKeSZ+SrpxGl6PzImPFP+DzafqnATV9BIRq0tHVBDVmADJujxVawnFEwM264rKbG44c1C6qmYejL9C5k53UelpBpyvkv9VLqhJhFOAPu7ntwKepFxukQXytA+ZoLD5gSEcosSohQCl8u98NRewhEtHfkG+pXbwLUQakxemmwiCHg739eIXewU+xoMudNtVSkfZ4KE3ga/dKe7c1f8Xi/s+L1xX9GeTb59L7fkzD/hVl0f3MX+XZbCgnm9xdYMrK855qaCbyD23eg0uYob6m4m6egt1skH9t01ix2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8s4gAHONKxMoldr5/NAPbR/ozmxdC6buEjMMXauXhM=;
 b=nIdbBnlouWPcoajbQB8/4CHrhLqCWjc65MAb3Onob9gT9zYJxjeTAe0gb9NNBskZmZsJj2adOIoJYLtJdGs5tLlXJfWKDtD+grnoVa3LCaab6rqryR5hFs93vAxtTr+XSLqsOS8jjChWlhtoICkIaZkJze3jvucYCVIY65WCp0vqxXlk70vr+BwIQzz5No3eiHkg+HnCY+M/liOq6p20oPHtmP4t4kUX9VDxPY3iyzK8dRil2t3hEBYVe1mz4RTbgKdeGLvhmu8ekwhFaLSIzLDMHfEwn4DED8lq0l9vJyghtX4UBPB6iGAGuPeBa4ac5kDWPwne3sRsfQ9MVUqTZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8s4gAHONKxMoldr5/NAPbR/ozmxdC6buEjMMXauXhM=;
 b=Ka5NjiTeCbl+u5vPbF7s0RE0bEXrSMYIPkBy0Hkt/qP47Q754r1GBO48fBnuwiIrKMHeSp5F/pyKzETZ8KicCD6fj2nRpSvvnQ2pMSxdyuJoCSRkPkW4EMAuZWJHRdmdgKzQT9RADZC0dgWRRVvK2jwlI/pWUb/IAWcl/hvZv8s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZRAP278MB0206.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Mon, 6 Dec
 2021 10:13:52 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea%9]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 10:13:52 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] Reset PHY in fec_resume if it got powered down
Date:   Mon,  6 Dec 2021 11:13:24 +0100
Message-Id: <20211206101326.1022527-1-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.34.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0183.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::13) To ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:34::14)
MIME-Version: 1.0
Received: from philippe-pc.toradex.int (31.10.206.124) by ZR0P278CA0183.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:44::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Mon, 6 Dec 2021 10:13:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45e87c8f-7fdd-42e6-19a4-08d9b8a11a78
X-MS-TrafficTypeDiagnostic: ZRAP278MB0206:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0206A533B0EA41FF5E0A044FF46D9@ZRAP278MB0206.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UjHniDJP1WMQzlQXkXUuBXAfdkUohJ4LyEmJ3Pphj6Pg8qSzpYtj903XzxaKU/BdANUx9VkMQzkaAV3QHeSrCwc6DcHrk4c3FtHhsON2/VsrB+4A3T7nUsxBcPletI+dDLvObxxSH0zVjR60JOeHQN//ZhcdcsLraMgs+kgmQSdSwhszWUWR3Bx/g6Y2/6yMhn0zIoUuXv57ghgYKjTEFWwRCJoXZYw4kXPpYrmfmzZhTSu1B71rgqUjxjyBcs7ONf2ftPucPXdarB2mWwrzMMxHI/sXpfSn3vFEYhcmVjrg5J9VtGYKy3s+uii3Nctwu87xzPlPyaUPaI0EbgJTnKOoqYy9+IIaI8CZY/e/Iwv+KhPk1yk7bw0P8ORNBhw7v3l6xbZdG0KU46me3fSYIGuY1yCwszvz9/BE1kUix25C+LOEgUppOusjbVdwMQ+QqQOqxNeH7MvzaMrD/LuRQ93HqTQ1ltVW2iJR/gUQbQHCVoNYQKneGdW9opqLjbi+d1cWgUz6IDJO4GNqVz8tVjsCj6ogwVvKDaCVZSS9MAog5XaZ8DnILcyOtcAZxhRXIfJx/XRc1Wm/iww5wePzNUJlLApDXDZc6W38y7tkFYs0xeCWrKC/f/PyGq/4o82Sl7k5sALxEGCr7tW6zq58chJpbLPLQYPeaznrQyTryWeyqn4q4gRLj+tyehTYrN/QGs+My9z5S28+bunpCDwQhORtXCy3LFHPJHQWj7rzVX1jC3H8MYYmIeSRBj/3FIfxjRlvtI13vv5w1GFv0UQDeVoeMe8AIAfyOSKCMOekC2N0QWrCU7fD+AAF+49XYJxV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(396003)(346002)(136003)(83380400001)(2616005)(66946007)(1076003)(86362001)(36756003)(2906002)(26005)(966005)(44832011)(956004)(6666004)(6512007)(66476007)(66556008)(4326008)(8676002)(6486002)(110136005)(508600001)(316002)(186003)(6506007)(5660300002)(38100700002)(8936002)(52116002)(38350700002)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zEBc2wzvK5mJHa6gMmwqxpzYoQtRVl2wKDqOLBIuepsBkHYOFj5qoIniTcmX?=
 =?us-ascii?Q?HyJWax2DKKtbxdrz565n660gDiV6ts4Fg4LFMGkufOlvYLW7jNLA/rg+QyNy?=
 =?us-ascii?Q?pAuxSYqlKKCW98I2vcngkK2zQkHQ1uNuiU+iklj6wnvoOZvAoy72TBzaOtEy?=
 =?us-ascii?Q?NyzqM9X813S6+G+DEUee6DP4AkWLIJRkTU/ak3Wj0oBGjjeY6jY+RgAi1eNP?=
 =?us-ascii?Q?uDr3S+xIAfGoCjzRr1p8MPHnjsW6gu8bzB5R59fzfNcw4j4Ut8Xk+ATe7GS1?=
 =?us-ascii?Q?j4Bp3H+0+pwj0s/6dqdLnEbrfJWvF16l84a45dFNjiki4FlqxfjOsZkyYroO?=
 =?us-ascii?Q?ywsMXKDiG4MCm3BchoBMNzcwuTPgJiE2Bwn6G8y3qDG+HAr8LRtuMBrZVt9Y?=
 =?us-ascii?Q?fwYjNLIXF2CLqaQz9jTEC09J+8PcZx1Zmzyql3TsaT0NceWO32ZvlxAGz5Ct?=
 =?us-ascii?Q?hyjAHFTkmiQofcHtJhPUBQ/55+nIXC9M0KBoVfj9wjQjxS0y/ux52vUXTY10?=
 =?us-ascii?Q?c8zvmiwDx5vJ0aYBemdLoJjRLtHKNDSBx93q/GXCkZawXyV3QYdBVkZcVQJW?=
 =?us-ascii?Q?zCi5Rrfimr2aqkyCG6pfSo5QQjw34ArgqBUHb3vgq6eGykn3Pg+i64Y346OF?=
 =?us-ascii?Q?yoEhSb1oxphCh9EyQ7q92Lh3gwbdpBsMZjVK0L5PmN+2g/HbHu+HKnr3S/sQ?=
 =?us-ascii?Q?vi/SUF6tkb+ZZWb+sOpTdgSr3hZuBW3DYevQSktvgRgP/UbO0YnWVZTHjXSO?=
 =?us-ascii?Q?GLyjlWBsAga7lofaaPHGNl6EEt0jQHilMtGLwKX+IDkkMZRoWg67x6M7tDtV?=
 =?us-ascii?Q?wMUX431zOGyu5Ur7weHWu3aymMlYbyn9RzO2jmJQV/HsdnoMpUIkITEYHuQS?=
 =?us-ascii?Q?ChzYmK5Gyx4csQR+D8JRBQd4sbmrLEXW9ErGFnAbeefh2mK20biZemIbMqC0?=
 =?us-ascii?Q?MVza9pUs5pUJrYsRoVguKli3UV+UqOWYy8I2jRhgV1sAu/vTJNUFPZnAOnO6?=
 =?us-ascii?Q?j373/9apK9V+14mzXb9iAXk1IJDcNbhhutKAJyfTDgy9mQStjBvN/nXRJ3Be?=
 =?us-ascii?Q?qv5jw3BOZfT7+a9hen6bQZQ6PmjUfLcaJOGLG7OoRImwcTUmFCmQ/3W4y+Vg?=
 =?us-ascii?Q?Gyg0iG4kXNbtMxwrRhzEO0cHVM54+RTiU1J5cJnPC5k30RyllYQCTEwc8iLA?=
 =?us-ascii?Q?+gzpd6Imu9lwNYNywfD0xY5dfhUzZRDONAt5T3w7uZKYp91y4KtMejJIYnE3?=
 =?us-ascii?Q?OYBnPKxUu0Og+HfGA++MfQBQbySkLXVmjaSXkKU1H5suQnLvtMkyaYFJzyly?=
 =?us-ascii?Q?bJGJR981/fGd7Tf0rIpDXfF6W/RX5ITAf5Lcul4cb2uerfDO17Qt/bLP32Dk?=
 =?us-ascii?Q?txh0pkJv/iXKVkdhAi96GLRmHWrs/5qKmIXfJUrKr3JQl7hLa8KRRg4sYvtb?=
 =?us-ascii?Q?23QN16jtWnjJbKLlrIbm+wrAcFtfX6/xFFUrTS/WD5K7man8dOT20hR9+VIe?=
 =?us-ascii?Q?cmsR6ZIJHnqOzU45bT0V+C75uL6h6ExAst5YKNkag8WgBOB9zpbhAkWMyxvz?=
 =?us-ascii?Q?tKdhPoO5ImCVcONZqMSQiIC3UKDlgpguimEyc6fKIymk1QanmM26QHytUMKy?=
 =?us-ascii?Q?7uXLrVTiZCSu8CZpR0Qkxv3aEjNnwVlSRvzLdLjtZz2wfZQKjDFiItamMOOV?=
 =?us-ascii?Q?cw8LLQ=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e87c8f-7fdd-42e6-19a4-08d9b8a11a78
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 10:13:52.3885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yl4o9RyV6ObP60tSZUJqV1HFHUk4lVCpvf8cOKLUQsylJ/aUlvRpNRRU0/or207lfKAUiEPTZ2xX85Dc0vqjLhN4pmxYMz0Pt68SuA/k7p0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


If a hardware-design is able to control power to the Ethernet PHY and
relying on software to do a reset, the PHY does no longer work after
resuming from suspend, given the PHY does need a hardware-reset.
The Freescale fec driver does currently control the reset-signal of a
phy but does not issue a reset on resume.

On Toradex Apalis iMX8 board we do have such a design where we also
don't place the RC circuit to delay the reset-line by hardware. Hence
we fully rely on software to do so.
Since I didn't manage to get the needed parts of Apalis iMX8 working
with mainline this patchset was only tested on the downstream kernel
toradex_5.4-2.3.x-imx. [1]
This kernel is based on NXP's release imx_5.4.70_2.3.0. [2]
The affected code is still the same on mainline kernel, which would
actually make me comfortable merging this patch, but due to this fact
I'm sending this as RFC maybe someone else is able to test this code.

This patchset aims to change the behavior by resetting the ethernet PHY
in fec_resume. A short description of the patches can be found below,
please find a detailed description in the commit-messages of the
respective patches.

[PATCH 2/2] net: fec: reset phy in resume if it was powered down

This patch calls fec_reset_phy just after regulator enable in
fec_resume, when the phy is resumed

[PATCH 1/2] net: fec: make fec_reset_phy not only usable once

This patch prepares the function fec_reset_phy to be called multiple
times. It stores the data around the reset-gpio in fec_enet_private.
This patch aims to do no functional changes.

[1] http://git.toradex.com/cgit/linux-toradex.git/log/?h=toradex_5.4-2.3.x-imx
[2] https://source.codeaurora.org/external/imx/linux-imx/log/?h=imx_5.4.70_2.3.0


Philippe Schenker (2):
  net: fec: make fec_reset_phy not only usable once
  net: fec: reset phy in resume if it was powered down

 drivers/net/ethernet/freescale/fec.h      |  6 ++
 drivers/net/ethernet/freescale/fec_main.c | 98 ++++++++++++++++-------
 2 files changed, 73 insertions(+), 31 deletions(-)

-- 
2.34.0

