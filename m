Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508D9523042
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbiEKKHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240226AbiEKKGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:06:52 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2052.outbound.protection.outlook.com [40.107.21.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C055E35A8A
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:06:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K23WcIv6K/ekX9XSSTbW5XMTxN7DJHp0DASlSRmPOMIYciNNt29ebyH7Xf9xRGX2VWex0YrZ8vAdyjrtdjcqKFaFiDJpoxJXFdK1XbJVySrl+ewbGU8GbbYMqz3h9zpOHe02POEirGXEYAtCo+hx+PCTL1JOJw89CLMKo4XMJvQugAX4oa5sWXxc4tC3iAZuiqFUOUMtjvej01Krs575sT3Lapn7DeCY2Vz8zV/MtS6Ce2BCxhk2agckoPkIvh5oKckBNRNDGNBZbzYFDPWOvuuM8nBeg5gzyDvsK+AV57Xa2XHrHuQL+GwiGtiRg/diWqFvTwPai2489Kz9Po7jJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1M926ykZc6tWgTaDoJzCAyopMzBzCdS0/faN1JX53Q=;
 b=hDeoYoyTofeTUEpuy/NomLtfTXV8z5MRESDICG5Ljvt0y7VG7CHHuoAB8PIN7B5CjO2eDYAC+xcEh/uarm2ZDOfY3qcnw7TCWemQ0DWpszGeztss3V4R/VmsTilEJbY+L0C1PjOkes2mxId6+26r4mfIl483G3cYt3AzcKm98DOrB3ZgCsztFG5jclE7usxkUodcCayIgoacDokNfoEuAfE8VgBATtu3iQk8UrOJHDfc7cv1na7tnZSfjZSehCAuygT1k+LyRVWgIpqACxQIFEK6fqTsl532R9wwq16YGweB2jv9dTbhRXMRyK255Pk7aPWVlX8//pwKuR6dDC2zZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1M926ykZc6tWgTaDoJzCAyopMzBzCdS0/faN1JX53Q=;
 b=ZXpRXlReXFb9Ol74f8T9/Mr6wbz//NTXMLuJM60yGYlmZ5VHVeaJQFFfV09rxBG79z5yr/fTgLphyWT6dTtTK/CPqzl2MNiyzjMZqSF/EpFzIUMx8fvDoPU/XOosIwC2luIFjTza4TXeQIeLVdLB/fVAhNA/JaM7P6N+0lScmb8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4055.eurprd04.prod.outlook.com (2603:10a6:209:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 10:06:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 10:06:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 0/3] Restructure struct ocelot_port
Date:   Wed, 11 May 2022 13:06:34 +0300
Message-Id: <20220511100637.568950-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0005.eurprd08.prod.outlook.com
 (2603:10a6:803:104::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da7d6c97-7e25-401a-8b1d-08da3335f599
X-MS-TrafficTypeDiagnostic: AM6PR04MB4055:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB40555CBA43398E1BC171C724E0C89@AM6PR04MB4055.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJ6EO48zA6WKODPFyQ4iFCsaQVkNTPRZ29O9jb3tO0kmyOsPeayiMX7lAcYYytEN4iWEszqKJgAoz4XW24hhvUdXyhZAb7zowO1hCzE/0Q81lxW4fthxt+BAZ1Fo00abpmrv9fm1BRk2OLxPEMcOlyStvaT349+1ar25EqINUIqgOs5gREPwst/981NukeVXV0MrNssMxTufRCmsb838Dt5glbjGf+7ojNLdabNjRt5lwBwWMI1ISkJk2jRKxEa4dldBpxkt35DD3Q9d2EiwbDShFUCkGVrRA14qd8FEHKPqF7KcRm/wMT1afZQSS+sgO2eTle7mrmo1tCM+gpedJWXZwua4Wd32Fy2+eWe8JzQqotUJHSQB4+utA3qtfMgBzB58HQQlH82rk4iIERdX5rtg+gvkJamafRQNN2qWDNBU1JW6vkuUm/lHpstzxmvrtgRv0e28MUG3hGNY6TUIosTiNxp/lbhj0HIJWmGWaoQkV/l2x0fV/GhBbPrDOXMSf3LUeiji3xx8B8u1D76MqIT3gXLCAG4ltDpx2FcD11WR98RVm0r6hcEoX6pVp5tUlBtARB8AsjEo1aUqCjWTcF/DINp7rrpc+Vky0OJ/yp0A1MPaHHIhWlUh0EV/f86wvt+BdzSmOgeLFxEF3ZDTSusnh8amBYkBPjrFgVA/pYtPTJjgDuJetqSYWhvRXH400jOirDXaWUhS00dAWQD5Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6666004)(6506007)(36756003)(186003)(508600001)(6486002)(2906002)(38100700002)(38350700002)(26005)(66556008)(66946007)(54906003)(1076003)(6916009)(5660300002)(7416002)(8936002)(44832011)(4744005)(8676002)(4326008)(83380400001)(66476007)(86362001)(6512007)(316002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JkF9FwHiaryWeaya+raVRqUew4vMeJ7bmIhIPRf0EJTi+cpbnCphocjxuvqI?=
 =?us-ascii?Q?KUb2FyKrOA3XFOPkjY5rdJ6IC0XAjDWOBl7IUlc4pLPhbvc/9BcI20Ckl8UF?=
 =?us-ascii?Q?hUPCBwf5bHSdoO1RHBla2NwH8NAn8FzGmK5SSskZVd8YQdBSEBY/UwPNrBAq?=
 =?us-ascii?Q?8D0Dw/+gD6Qs7BdSIkrTKitAawPuT10J8LcjSlAsM4A5jtM+0XUK4iURvD5I?=
 =?us-ascii?Q?INRYuibGl+mULbtTM7jgXkn/zdnUYXxbTj4CLCLe7blOzt1gEPIyNi065jul?=
 =?us-ascii?Q?mBXn7DW44YbrOC0NKhSTtNTQfCGQHAvWMatIB4YSIeYPgtf1qcI6rmA1v3YB?=
 =?us-ascii?Q?HogzfPvB27cw5SP5Kd8sM4B2aFtZhdOTVF7/dLKubTC/42x+U6tSpYgyCpLN?=
 =?us-ascii?Q?803vAYtPTuUPH2I3zUUPo5+nbf6wVdAXiRENTHm6jmKWIPsB4sniUWjpMSnp?=
 =?us-ascii?Q?KNZ1L5aY836yw+JUSTfslnwiRtN+ZmgU+xW+8HnTjt3choZ4vRg2Pjktpk7u?=
 =?us-ascii?Q?sIKhUEaOzU047obwNP7tAjHtfwg/xa+cIrlkw8CVeIWDPwWPU53QQwLxQwgo?=
 =?us-ascii?Q?mxMJRKNL7imwOLEUz1dJYgZ2sgDqMG8adnaST0Q/IqzSHPTFeT5GOxH9dKG2?=
 =?us-ascii?Q?0UUZSGmISxjPQEatZlU+2s7DdyYy3UkbuFBWnVqr6fYxM8TzmYWWAE+Rp/Up?=
 =?us-ascii?Q?oVrMlf83P/UDx/J7+Ay70aVnAKgRoDC/K2JcTdBphyIyFjUZGoxkRgf/oI7X?=
 =?us-ascii?Q?GPxQRzGRf8927tbD983zSfHOq76CfryM/Z4uX98fIQq0LvXWan7QzD6dFShr?=
 =?us-ascii?Q?Bf7oS+ZYhD+l9JGg8QcS5sp/DLdqUji9E43h6gTtR9/AumV+93PjPxjp2Owy?=
 =?us-ascii?Q?GRGCXi8i/vlVL0sKK4YeyrW8X19KwG4KqmaDVn6Hf5eE0lgB/7FR1Xkshbqy?=
 =?us-ascii?Q?vu9hltyjmvi5aKqp92KgE32uL8aqRTz9pmRMaRpJsaAIMtbZlK2cxQPOQtBW?=
 =?us-ascii?Q?ZRGJG7TTASl8D1uItL1tIQqF6V6eXpnP6I5LWgB5vv8qOX7XkNqNvRrzyBhg?=
 =?us-ascii?Q?V23esHch0xtA2ywMwBZsQruurDn74oFoe0urZNxe7N6SkDiSo9e6AXM73ltU?=
 =?us-ascii?Q?Go+E8BSBHGKuQtbICma6f8uGMhIlAFCu3LaL5uwn2dxQ3i/A57MWR2Z0VJ08?=
 =?us-ascii?Q?TRwmRc9Qha0ZBup1EnqPmRy8PtY8uwYfT8VGTWeKtM+qy31SdvKjIyd2dR8W?=
 =?us-ascii?Q?UXIYTgUbg+uOHhR641EV4Pri14nu34F4Ay27WowypTq7Sjq52gyKPu2mEQiA?=
 =?us-ascii?Q?cC4hvoXVpwgboQEjYt9+gApk0AUr2qlxZT54oo3NKToRsC/LG0W7oPWM+98K?=
 =?us-ascii?Q?I9D5LTSLILpV0EjSJn0nFUeXHeeS+wjmXR7P23Z4IwYFJcsLmoyVQjVnicxy?=
 =?us-ascii?Q?ktubQlPsLuX/G9HHcxSD8DoghrqchXmQAbm7PZ21ibsBJG2PJIluBK9C3PLd?=
 =?us-ascii?Q?X0Lt3ulukS6+PA14fhOO6bnFU1l0xShFZkCyufMCDk+cwSIteA0EzhtGZpf8?=
 =?us-ascii?Q?0qyJFTn29n3AtrxNvJGw7wSm8K6Vu9/6ExiLy5erv/mZiaBPS3QX8Zh0qlnT?=
 =?us-ascii?Q?Lh8CrfXp9m1VWCMIoePwF/ecdzyiQYgQBnbzXmKdpm4s3A1K46LTq1CW8z75?=
 =?us-ascii?Q?6iLurejR+fMg9FBr0WFHA8ImI9ZeV6DSPhAuj6z0t5CLW51ZCw1vCr1+YGoz?=
 =?us-ascii?Q?r4yJOJlHngS46uF2U6eG/uerh4ZIeHw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7d6c97-7e25-401a-8b1d-08da3335f599
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 10:06:47.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/pcBEBnP6C7JA/nLcW+nmEFEQp7ZvmBIbOftt1T/kXb6iqRTccDGHWN/R5KyKNMQGjCLhdvyd0dreo2kQDMEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4055
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set represents preparation for further work. It adds an
"index" field to struct ocelot_port, and populates it from the Felix DSA
driver and Ocelot switchdev driver.

The users of struct ocelot_port :: index are the same users as those of
struct ocelot_port_private :: chip_port.

Vladimir Oltean (3):
  net: mscc: ocelot: delete ocelot_port :: xmit_template
  net: mscc: ocelot: minimize holes in struct ocelot_port
  net: mscc: ocelot: move ocelot_port_private :: chip_port to
    ocelot_port :: index

 drivers/net/dsa/ocelot/felix.c         |  1 +
 drivers/net/ethernet/mscc/ocelot.h     |  1 -
 drivers/net/ethernet/mscc/ocelot_net.c | 76 +++++++++++++-------------
 include/soc/mscc/ocelot.h              | 21 ++++---
 4 files changed, 51 insertions(+), 48 deletions(-)

-- 
2.25.1

