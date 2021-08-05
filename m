Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C503E0F78
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbhHEHrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:47:20 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:18309
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230298AbhHEHrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 03:47:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XB7Gn3EAzN5Xpw0PUG4qHqOUW8ResBT4JhyRcWx+oz6+Y55s0PsVBNcbrYUhM1qQmj41sgPGrLhV8wlY/IFzbncCkSjt3JoxeFZYCVUAVviqFioh5ALDE3gJ5KTa7AMbL8sB9YQNvwc3zQZhjtZGxqptmn+b2pCJAky0croF0lxz5q+QB2tyiy7AMJiKgzQQ4wmz5xsQAzTMz6vNOSoJkwds+QWyRJXJrOuhm4SE7YcyYEkXmUd9MtU4u2AM+2DRVW1ynQgip72Dew0WNCC/OOx6Kcww6kNlFF22OMxb73C1ANXhHrRSZVfA2WR/T2uuc/zHMqc3Mv0DCTEm9F8DQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOLhfUpLm9QKAbVckaXDD0KgF51c9h+e0iF39hMvMXc=;
 b=b4PuKFonAEjmPY1i4/RmNMDStYT5UU3fuyfHqgpOyVrFdLEWcTACoqNO75icZNagNtW/P/vuML5RWL5ADPTgCwinI4FLYXVlYMF86YvJpKpJuvWjhpQpbBHhBqMU6uoYfI9By7oPY1xcwmyUjyGwuDDDq1Dnlq2ury3uBowH7zg7XCFQSC2H1R8h3sIPxJFOIDvpEUi+U1R0/aVVyCJI/TvNObSU9Wi6lQWg+UamM0Jj97KDBWMS8dVaH7S0k9aa7tgn1CvBCjZ08A08oafKugrlT8zw/j1t9i4xoGSN+B114pfUW/H+aVFJK73SblBozSbV5ou7NBmQzt6mTKtgGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOLhfUpLm9QKAbVckaXDD0KgF51c9h+e0iF39hMvMXc=;
 b=QJVEq83Fq+yZKY0RKhJ7yprqH0OGpGkMiCC4BnqrhsUKIxmRjv54LH/PuYnCq1gwtDd3+QEiSzA6jLnBLPPN6b0FKppDiMIm3N8uqd6YNydoe9ZtbXogGeNixKx5f5A2TB0Xr3jPK4NAfDvjqfKV8jTEGyiU8C/Hlg4lMa32jWg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8378.eurprd04.prod.outlook.com (2603:10a6:10:25f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Thu, 5 Aug
 2021 07:46:53 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 07:46:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        andrew@lunn.ch
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 0/3] net: fec: add support to select wakeup irq source
Date:   Thu,  5 Aug 2021 15:46:12 +0800
Message-Id: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) To
 DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.1 via Frontend Transport; Thu, 5 Aug 2021 07:46:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fb68550-d4cd-4b31-ddbd-08d957e530c0
X-MS-TrafficTypeDiagnostic: DB9PR04MB8378:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR04MB837856F475B8067A252C620FE6F29@DB9PR04MB8378.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJXmaKQKZyXzVrsv85/mXlEjX3DOt4LGjiMjVkycMPHPB/M4//l1IZsAd1vjxGAUvHtwthmmhUmxkwWsNbcBGnvr5ObbvvQQMP48W8t6OSJwudV/csCO+AMhYewu21NFCCi5V3K/IZWLPBti3FlfQ7lvNZ7oVcnIVzws5XBh8expgKXZKU0CDozcmz8PKL95gUCMVj1192xYR7L2vvqRsF9zoPWPtKB6P94ZIJCV9B6kt9e42qmJrqyxItSje47zLty2lfSnON+loYQZx35rlPp8DuEQrSFH6iYDfHex34RCyl7Q81SBejnnmnixhAs0/VZZCT5QY0YV5r1NUVno6GIK7Jiu83Z56Zt+FVzEysF2TlZI21t2JD4mTNk3CRs35N9AT8QYcilHFBG8CrJWg6dGrpghMSzw0Tfn1J8a44mrosdNcSSrnQwnIhx3+vaOChPU9vy7zzY4xQIxZe8OLLolmntTax/dw6vEHtJlJ1z3HgIkQQOx/1MTlzCnYaHm8gOknVTZCSVKnWZTaBZPktfL13gEww1+uzF4X4+BdV9KAMfY1N51ZOZwnYYYDhCivDZvFh573AqI7vvVDYV9ONVvH9PNBMhaAhnTxgaJG61SKtBaeHw5td8B9f42XorAnVtzGBpQQnwFRCS2a3mq4RVd12uBxvy3SZp3VUjJUGw4vmVlflCg+/cNCPB0ZZGOZKL/ga9DYILJ04j3C5GjsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(4326008)(38350700002)(38100700002)(8936002)(26005)(956004)(8676002)(6486002)(186003)(2616005)(6506007)(6512007)(4744005)(316002)(52116002)(7416002)(66556008)(36756003)(66476007)(1076003)(2906002)(66946007)(6666004)(478600001)(83380400001)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+9sanKwh8gr3yTPhw1DkoO0Hn+NncjKOjVYoXgMyOUKiHoAVIuHUKBGcAKpU?=
 =?us-ascii?Q?rXk9/m7FY+dD4Eas9/hRmIF5/pq5/MIiPaWcZimyabHQ4pY5TIG1JHHzR1nj?=
 =?us-ascii?Q?fCaAUbyNaDCd8JOq3i4WKJT0GTZ0xp6D4r25Q7oljyDYjrYB2kIbNo9WDca/?=
 =?us-ascii?Q?hx05gQgHeDi+K7WPwzJP/mJB3/PlFBElOUftGEF3Rbem0ZxGAHzbbcchmOJC?=
 =?us-ascii?Q?dgoOVTUN9sQ2lMtO0Ja1fWoSBLw5LMIqT6A6GiJj80rlR9FthP6x4tFbqvKw?=
 =?us-ascii?Q?NaJx4P/laZR6D5MAJR+JbR292DdwMPHwbjeHpMPH6WDGUG0dTnhXyXqZcPCl?=
 =?us-ascii?Q?bp0hKgGCdbMXRpALFSg0DW0rK5UyYteSnUHJ8Zmswt6JIOSbxmyaPVQrD8bh?=
 =?us-ascii?Q?KsKMk1YfaGzdIU/vgut3iGWKdBYcn4O0DokWKFX+xxdwtOSk7eLP5w4z+22A?=
 =?us-ascii?Q?wrJ3qtuRevsnkAvz/93KmkUjFgV33l4cfpJOqHIgBOmMdYsLgacCW6+LH9tj?=
 =?us-ascii?Q?htA0ZdlAyL3QbtYhCWihq83EUcJMRnmbr9cl9SXXvoy/6Orgi4SBJaz0WZec?=
 =?us-ascii?Q?cGqQY76sMYyzHsFW/ePEj4wP78J73wIKBvbNrCB87ym8JZAVOqIezYXGbS1J?=
 =?us-ascii?Q?VXyCGRQeIUfe57YajyghARS7gpC9L3sfkjNEM6VDPNdZV6kf5CDl/sAZLHnq?=
 =?us-ascii?Q?2T8Pc8TozBQsaywhGecoIN9Iw2giua/ih3pLJ7QrlLw+kYOmHQWhyH7z3EOz?=
 =?us-ascii?Q?PkJO3KToAF33bCoeFtQmbYxsHTl/vZP+jvRjDF5rohVZSlX4cyrPUsTLTxue?=
 =?us-ascii?Q?8Bs1bJnwe2bcNZ4nw4nZPtJDqHtc/7ie8aKVyMbd+vXJ64/zLNu21mepaxL+?=
 =?us-ascii?Q?DRA5s3juA5g5LtHBUFsmpVpAGUq8V2QnOe95rqMKHgrlC35a19zqQW2RIq4h?=
 =?us-ascii?Q?bamdgHfwIiiSGCkT+6EYnNhgW1bRf0qHBK7WPRQiU5aly0OUBWRAGY4q6Efg?=
 =?us-ascii?Q?jwNQzekBwxgUmh/34qRj9ZOBXfjGK38G6dGd6G0gwd3aeEjnQHBmOeVNVbvd?=
 =?us-ascii?Q?ckydCK3vIo8DSeVeEj/BELvPveniOqy9KXH4NRtIt2oS2f9Fk+CM45uXQ0zm?=
 =?us-ascii?Q?Sgva08WyXkRcDju9oOVEoUQ4nghMu/ix7AZvOL3bNNi3iJymNlYiJqzfxd59?=
 =?us-ascii?Q?4YCxxfbUFAuZBMUT0m1zQyfETMtk0xT1VFqIg/JZlmuoZOOeCEZIeEh0O4j2?=
 =?us-ascii?Q?+/sG01f6DW0XfVSr4IKRg0yJ0ypn8rmLa3tTeQgUmh/JmTWb+F5+kyy/b2H9?=
 =?us-ascii?Q?fiP7HjVvmIbypK+QJzy4x10i?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb68550-d4cd-4b31-ddbd-08d957e530c0
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 07:46:53.0412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +5AP1Vb8plrmAUZryY9n28Xw8kmGr1BQsg3jqKKFBj4XUtOnpog6OLBL2OZKIgMMuizf9uIhpA8pk8bb7x9i9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8378
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set intends to add support to select wakeup irq source.

Joakim Zhang (3):
  dt-bindings: net: fsl,fec: add "fsl,wakeup-irq" property
  net: fec: add support to select wakeup irq source
  arm64: dts: imx8m: add "fsl,wakeup-irq" property for FEC

 .../devicetree/bindings/net/fsl,fec.yaml          |  7 +++++++
 arch/arm64/boot/dts/freescale/imx8mm.dtsi         |  1 +
 arch/arm64/boot/dts/freescale/imx8mn.dtsi         |  1 +
 arch/arm64/boot/dts/freescale/imx8mp.dtsi         |  1 +
 arch/arm64/boot/dts/freescale/imx8mq.dtsi         |  1 +
 drivers/net/ethernet/freescale/fec.h              |  1 +
 drivers/net/ethernet/freescale/fec_main.c         | 15 +++++++++++----
 7 files changed, 23 insertions(+), 4 deletions(-)

-- 
2.17.1

