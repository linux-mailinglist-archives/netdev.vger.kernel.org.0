Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15126414FA7
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhIVSQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:16:49 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:48961
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237005AbhIVSQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:16:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DrFmBbVZHJGt5Z9m9FNzjkVMvuor4Z+x6sEawQg++7jqlOWsALP6thZxqNO6rjiEcu0313F6B8beH+8Dn3nR2gmPV8UZ6NJxardLb0ckCnchraSV5ncIKr4J5eumWZJ3OnYpK5hvZ3A6V1ThwUlWGFSRgW1G0he+NmRHx6NV0FJT/vQXIuWM9iN+LLtzvNMpT/aI74Yz05TfNcaXug026GxuI4w594jjki4yYJhk5ZwYfaB8VYUDMwcJzDzdtdav8mEvyTKKfq2LKX99N8KNtEZ87uEesscTT8fbG7SVMILqGmrdiMJu9Wz3UQbCw0yhaJWlGplI+8GnhULMoElU8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3zOwRI88o/TXk1Rhm9UcDtVGUCUI0tSmlNkUFxq56Cc=;
 b=bqu8mbTrcYoiH7MGA5d1YO30ZnP2RRBgH7Z101+zTz6HiU9wNIbOutxlKjRtdt5dhjQo7N1XZ/P488E0JfRpsYPIS8c9Zfiy+UbFhdSRc0R52JteSRw5buCd3ekDfPlC1rDqLMC8B4iXezyyW2DBVcnrdNTXFdLzlNNKfGro/HZA7yHZ725qY4yGSj+z097c8QMEs3lNizO0HoBVSAAN+hIAIZ0XoHFyThUktMYjttbKoSOWRYzE+G9+pTiBQyT06S7LVBCX4+bLWIJLKesSsOuVW7B9FbO1CMsqxaTD5cevoE7X7JqY3ifmd3lR+qhpC5arOUK8Onn0KpsUZ3hY9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zOwRI88o/TXk1Rhm9UcDtVGUCUI0tSmlNkUFxq56Cc=;
 b=Tke3TmMP8IM+T6B5h5aDUEH1E8lBrs/u089XBvwAjyMW1dEfa8fXYZPF0THHXk2i9tFILN6FdQUPoBmnytSJhEG6Wbwcbr7E8TLlrWkhihNVzO0PUMLkft60EdzT+HRVyxQUyPYZGbcFO11U8pwRsIEm7lkoLSXB/GYnd1F6TdE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 18:15:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 18:15:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [RFC PATCH v3 net-next 0/6] Let phylink manage in-band AN for the PHY
Date:   Wed, 22 Sep 2021 21:14:40 +0300
Message-Id: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0001.eurprd09.prod.outlook.com
 (2603:10a6:101:16::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by PR2PR09CA0001.eurprd09.prod.outlook.com (2603:10a6:101:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 18:15:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e64e05d-1987-4cd1-7e7b-08d97df4eca4
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74712DB8B90DA425A5A0AEB6E0A29@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CkZN/aXCL8iKrPQ5PAQ18RkOw8LHyyTs/RXem2PV8xu9b2atcDbx+8+KKqRtltvOm+IMRQM5gaORtmlpUuOPFuDZTeXHLwheKbSDDuYb0RYFXXm8gw6B6R5RfYsYfP0y7dXf8l9ZvYMr5HN/a0xt3EsPEZq6PKhwrW2T1hWSOafQuYZ4hmDnvhmhhqKVIJTJ86uZcMHWIpSomFBf1ndezval+YvDxU1JOhDvQQLp/cCUwab5ufIO88zvGm/oo7if4fAMEFnj7WZJjtLuO9MDYZAPPzq5BZ6IMw/Ic/b0VOnXcdVrCZI3IAfuCqEbKoZfdtMkdRcckjCQ/qTZsDdOmMXV781D8NnK8Hwlljz1E3cSQ7yHlMWXDWAdbf+TDS1/c67/OpdURjQX1t5+7QJyYqaJtb72+SflUGtUO2u/vrynefxfFugXwRowZx7A6Vab6IN4eu/H4dhiIWId8hb951yX2cg9MrCOOXAJ+pqDRaWjU6QccMIb2MumxHVq2QFZE8qJjDt2EtSWrnUoUG9n109pCIWyR6bMqf+xzwDoM3h9+AaGtWN6SCSjkGnDXJyXBPhLx9w7HP+Twa3PMZUotu9EQGKIiEN8IOqzJGknr11kaJlap4uol1dZvaRemYoiHRFVnMN8q0Iug5BeU7xlTuRqBhnaYs2ylYDPknAREZshWFBopMMjy05GaCQBmVZUSQ7lvVgYkvdRM55d8gWeWFZdeaew1l4k0OYFf1pxBw6J4DeFltIfVC3DqEzUJlIEsfOL1r5H0xF7Z2DbwHYKyiJwVtuilVeEJBgCQD9ywmk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(66946007)(66556008)(26005)(38100700002)(2616005)(6512007)(966005)(2906002)(508600001)(83380400001)(66476007)(38350700002)(8936002)(6666004)(7416002)(8676002)(1076003)(54906003)(6486002)(52116002)(6916009)(44832011)(6506007)(316002)(86362001)(36756003)(956004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/07HC8n+zP3ELg40cSZib3yV3CDvEdCGVgdlnlYL1nTjEeU05U2NHx1wLDxF?=
 =?us-ascii?Q?E73JI4M4HQpYI7m7/OYxAYs/jd0a7TRShAMsHFcY0He6s3c+dQNOJMKUwHQO?=
 =?us-ascii?Q?fLeDE+Lq8OQlnityBHQUass9tqQ1oVujwcD6M6zSXwlnenGNGXEGWfaiFUv1?=
 =?us-ascii?Q?JxhFUa2hUDGG2Kc4NWyyHjJCGhl6dvUHp4IoRuXZvbffHSoqH064BuRFt4ru?=
 =?us-ascii?Q?0cNM0bZ6nlxk7hmdchSJHTGLG4jKjvem39u5NMw0i/miGi7DjwO7LCOG0s9l?=
 =?us-ascii?Q?td+HQZ9uUtxlpC0e4gnuo0CFUjC4OrzGTdxjMY7iRQb8otFSuBt47cYhGvpT?=
 =?us-ascii?Q?QUIeFTlJoKtR7xEPV1Onaoplr0DkANOiTSTiZPNvrHnWPO+6x5DsuBNaO5Ir?=
 =?us-ascii?Q?DZBGgBsUWMazWUEe8nxzAETYgdDJrQ004bP8H3mTYO2vZZMae0Ns9+fcCu5O?=
 =?us-ascii?Q?iDJz8DCuW3F84V+qzZhPKZSka5sSP3MN+tB8g5Z7l6iPPbJk6h3UOiTbu3ht?=
 =?us-ascii?Q?n7yPoTosITaJwAHNe5En8kjezQ279eFugfnyRBsE9q3kGWYbkHwLsT8m6xr6?=
 =?us-ascii?Q?lN6QjBa5fzMOwveCtXL6lLzTXCRFFa8snGj+Nf2Iyo4mHpK1tNkI/YepAVs9?=
 =?us-ascii?Q?hXy5SuzOZu9WckdpUhR0UxUdCtU1on/jcVLWKPHPVeDC5WyR6GRPiMnJscD7?=
 =?us-ascii?Q?0TduimMEZhDnfm8NPh50MrzsWIg/NLfNSernQDMe3K9uXbgJuExEJKlY/iBZ?=
 =?us-ascii?Q?zOaDhQZxRd9QqD9Y6keSEK8zlZeUCfm4JWpILv8kYXVxc/PxKjaLm06gjbqp?=
 =?us-ascii?Q?xep+48uwfugah2XTpQYrDtU4ptryC+U5TcK2gwAvCiWdOdAaLf81wA+pC9Am?=
 =?us-ascii?Q?0v99cll8Y15C0nwx06juQaBM2tbw4gnSQDSscpzPkBtfNLFGaZmDoHUd9lbM?=
 =?us-ascii?Q?FJwbMwZpZ1P7ZVmLhMQOc1d5nqUPtF3opIR5aP5sKxTgEYQC5JF4b3hwzLXl?=
 =?us-ascii?Q?GkAYYVA0k54TgPPDq/4b0mWumphTPCkHNJksStZZUrkdnHtxvXDRSyXVNwyk?=
 =?us-ascii?Q?0MokzrE+Cz1OidA5TDkvb62rHUuk+Q9boQQ3/YNDGfKBImB+lwR5tl/iUXf8?=
 =?us-ascii?Q?CBtc9IQudKwYel+X0ENV1DBNtTOFrp6q9bXplP2riOp/giYHz1t/tDgM7+WE?=
 =?us-ascii?Q?ju4tdmIob9QgEMeRGxDZFJdm5T/V+Y7AIFu3O+6p1Eng6INxPg8468mq0myR?=
 =?us-ascii?Q?j0GdwQAdeB6mAwMVcj9HMzgQYPRGI9NIdmlRJL6gXpErenZVyfwROtAAFu1S?=
 =?us-ascii?Q?q9ZCUWfUqW4kYcoAygaRK9Dh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e64e05d-1987-4cd1-7e7b-08d97df4eca4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:15:14.7719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNSrLV0EBJUMoStM2LEf2MkAjTzUNcAoNJ+oVwW5z5PnRLMpyKR0ipriweHKI9w7040UqXQdghDgpXE4GRhpJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series creates a configuration knob for PHY drivers which use
serial MII-side interfaces and support clause 37 in-band auto-negotiation
there. With this knob, phylink can control both the MAC side and the PHY
side, and keep them in sync, which is needed for a functional link. This
fixes the VSC8514 QSGMII PHY on the NXP T1040RDB and LS1028ARDB which is
described in the device tree as having in-band autoneg enabled, but
sometimes it has and sometimes not, depending on boot loader version.

Changes in v2:
Incorporated feedback from Russell, which was to consider PHYs on SFP
modules too, and unify phylink's detection of PHYs with broken in-band
autoneg with the newly introduced PHY driver methods.
https://patchwork.kernel.org/project/netdevbpf/cover/20210212172341.3489046-1-olteanv@gmail.com/

Changes in v3:
Added patch for the Atheros PHY family.

Vladimir Oltean (6):
  net: phylink: pass the phy argument to phylink_sfp_config
  net: phylink: introduce a generic method for querying PHY in-band
    autoneg capability
  net: phy: bcm84881: move the in-band capability check where it belongs
  net: phylink: explicitly configure in-band autoneg for PHYs that
    support it
  net: phy: mscc: configure in-band auto-negotiation for VSC8514
  net: phy: at803x: configure in-band auto-negotiation for AR8031/AR8033

 drivers/net/phy/at803x.c         | 72 ++++++++++++++++++++++++-
 drivers/net/phy/bcm84881.c       | 10 ++++
 drivers/net/phy/mscc/mscc.h      |  2 +
 drivers/net/phy/mscc/mscc_main.c | 20 +++++++
 drivers/net/phy/phy.c            | 25 +++++++++
 drivers/net/phy/phylink.c        | 93 +++++++++++++++++++++++++-------
 include/linux/phy.h              | 25 +++++++++
 7 files changed, 226 insertions(+), 21 deletions(-)

-- 
2.25.1

