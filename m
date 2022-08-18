Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDE5987D9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343960AbiHRPtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343936AbiHRPtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:49:32 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC0154C83
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpH3khulnlq71RT33e3Nx1r4Oy2fdo4A4zivpoynb/Qsi3vUHR4Ne++9TpiVtuUewBJ7at1x4Oj0AKiSKNFKDmovF9YU77a3qYauryCxmuVfw5ZqPa8iptYv4EuTcaSvTnbvucP3ur945wYNIqfrukw0KYRgQYXmiM7BxxPmK0Q7+gufjbw9K+7K+LtCnhj9iUGZwqycRTienGWY9fBA7NXZCjEdP9TmmWY58o7VQ08xQp7kaO5hQvMk4qIRQ6vh90Z+OuF0H0V318RdVKlx4TXiZZQF2vx6/WFie0SVF9S0zzwaRC51QPnUUg2RCIwGrUOZ+dwhKnTtrI7cqMPFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75AfSSS04HhP0O/70X1cpucW/+CEv7gw8Y3RIVWPkeA=;
 b=dZgo6GPxdgjCjSer/aob/HH+9xyxxcoPESYYHDA9KMn6QQ3rLQFH9qelHsOTe5Gw8jT73khJRJzLXyh4KAhhGsPWUi61mn9sWv9nARGba4fpulBqwX3kMJXqPhOYhGqMSHf8gIu8HwHOYDKEyaU5q68dqZNLsU4QLYTkKTlONEQFq+ZEfnBkacQmiu/cpu79CH3pZ+i/VUkk6KTCDaGE/h0FpXHY4HLtBAijoHTShdHTQPW6giO0wdcl+r142OvSQOFB6uMGqsqWiAIhcuC0v9akT5dpyv0OMmyFA1l0R0m3j3udGJZmzXLxP/5XNu0KneWX+dNilaD2eJDpiZnJqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75AfSSS04HhP0O/70X1cpucW/+CEv7gw8Y3RIVWPkeA=;
 b=GllnF4x63C4Lm5qnP4OwWRNFabuFVC/abt5BqPc9a8d2iA55PxFGrRHCDmm1bA2Ri55VpCuQrA0i70uhMF9lZUAKt7ZJn3K+KewDqJCnM7JqtmeoYR/eoa/Bz6IqYU1NkrMJMXDCvBQZM5noHz7JGUf7EvO2cXvUmmpR1AYy//c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5648.eurprd04.prod.outlook.com (2603:10a6:803:e5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 15:49:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH net-next 00/10] Use robust notifiers in DSA
Date:   Thu, 18 Aug 2022 18:49:01 +0300
Message-Id: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 044a21df-d34e-46fd-ffc7-08da81313a0b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5648:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXTX1QfNbshJXZvHmZ8aP8wao9Jba8SWIDe2E6jgiFjOmMpJhTzAz35Yuv4ZxFfRYji5wq3A0hfni4M3KgFeP9A5vp6aXNqlxjSgRgooHIUu870MisNF/8UGcHFag6rRirYXlzIzkGyO1Qu0aB9fQ3B/SlEMOSiV9Tv0XTBNtamUqSpldM9cgZ/Evf1NaRlixHbCq4VpScqhuevRDnDgH+JTpAkfQjwmVJYm36BNORInuekPyQF6o4GPHovq8s6+rpEohyREUvK4/shkOWwJIl6CFCf/yil6IvzE0PrqT4Pk+PGh0/V3mxgfPhrV9a3l05Xx5h66eOr8V37L23AXna1xNCvdbp7HlJx5yWTlp0yV4deCRSQqev+d3j3GYSm+d4uUnBjXuM16nn0d+9D/mLaMte8KcWB3nMnrtmh41eBM6Usj46sFCgoHDAgprf2Lg/xcjKTAsM49NGg3AEZpKFQ7jjVNtL1GucQy5nc+Qlk2HLYcCMQmgAagSvpk1ZV1Jqimd5Cs3C9f/nzyez+HLnnf+BIyijPX6HkE67vu7CFf19Fv+l7sXZcCSKB0t/XTRyhnzMZfBZUSB3fp/Atpl84OqZHmR/aS6r/s24HigZ5p9aZWaKp0fRE/mbkKtXoJ2Br9fvEw7pPszCI2+UOIY0IuoZ6otUf1q6tL3secU4rmZZA9Z2Pz0SDDkejbsq0p7QunYn8y8p8xTP3v3XyYdbxVW4Fx40qDXGEq0P9hLKcM3Pt2XFkKtij4oYI2V2RjhsnZ0cVWvXEgpPNn11mjeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(6486002)(478600001)(38100700002)(38350700002)(83380400001)(6666004)(186003)(2616005)(1076003)(7416002)(5660300002)(44832011)(36756003)(6506007)(52116002)(2906002)(86362001)(41300700001)(6916009)(66476007)(4326008)(66556008)(66946007)(8676002)(316002)(8936002)(54906003)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7DGX7Ub9cWl41kemJkpZwYBppDEZJfwW+suJJ4w0Rs7Jq304v4s3glEdMFf8?=
 =?us-ascii?Q?+U/axoIcaN4neMJ0HMUMu41tlVhM3w3AmW3x5uj1PAqcklBv0H1iFR0zV2gA?=
 =?us-ascii?Q?nTJg1Uho5pB2E1bo2XQKcndI3u5oTppwVEUBphC7//0MwA7l075NDmS6Ap6J?=
 =?us-ascii?Q?qRAKXiWAR4T69YH626zBfh2KunhmBNoz3PmB5p+NXkj6JsRbgZG7slx6AxeU?=
 =?us-ascii?Q?bTgVQohl1JkIChlLeAfgtd4k26Xzq1d0LhU5+jGTVhbry6rHNZFz2pSXvgSY?=
 =?us-ascii?Q?KDxvvXYbFT6hIEAhXKtH7THkvdLL+c5ZidayquMQDYhz6ocVTJ3IrAqIlcZh?=
 =?us-ascii?Q?BIUgNPsi1FAIO9V1lnRD075eBhrG3oYDmHhOxRmH7c5khtcxTU+HPLqIFj2Y?=
 =?us-ascii?Q?44Wbt7Tl8ZB3el3sQFkT5Cn/5r9+Ybh6OUB9BZCe+PhqJSZZgypTWPUhIjOg?=
 =?us-ascii?Q?WiO7jse6eyKGWDbFp8VBE0l+w76og/RWxaNKtzSGkEK3f/4qH2u1apNcZTGt?=
 =?us-ascii?Q?90WNfIHwl9T9Lp/XZ/N47Cy8PAHsh3kuocUI0j0ertylxkqcfG9ilBYJcFF4?=
 =?us-ascii?Q?kyu3tABgH+726LD3OG+eo3oTdWE3SfwFJ8wXcZ+K76/Z9w3F1gBnCkTzIf5k?=
 =?us-ascii?Q?BeB1fm9+yU7kxzU2Ml5Nfap5Yd1T/O7OZojTFFeCj0PIoMEux+WfjbJulep3?=
 =?us-ascii?Q?oYJf7JEDj3NB3dlCc0+Fbs2wR9xSViaS+UFPkqDdbaHjP3lVaxAvOuaLRwOb?=
 =?us-ascii?Q?FD1VHM96feFveDslGN6fzQXfVJUIvQph9iOeHUxQzlL9SJt4RjQofS8QSfyn?=
 =?us-ascii?Q?/kd0dV49jAnMTf27ySX5dfUIOubOb4SPQfxlS2BboOcJmLP1dXLzbLOuqTGt?=
 =?us-ascii?Q?Kk2CtUPaQDTv2Fo1bS/eoml9mjTbP0jESY/dai6IiVgWrX48BSRe7BA+lnja?=
 =?us-ascii?Q?Ijs3SFMV4nA0y1h2LIhJp2VcUDs4XsQQAoG+bYL544QbLaz6LaORrUj7Rzt/?=
 =?us-ascii?Q?8PbeHqk6w0uqekBzZ0ELVz4iW3wdMri0dzPmjFWsHnywY6H8/DauztFOyc2C?=
 =?us-ascii?Q?/+EKF2tvElP0FWZhzLduz4xNMg3G5k69JJq24EbVY6aTd7ZoWxNgbzuCxJ94?=
 =?us-ascii?Q?16/uqcCV2XLjvzzV2BCKElfq5ZaPRm0p8OBHsETA3GKFlpp2UANAVDoV0mZF?=
 =?us-ascii?Q?Tb/yECS7/jrWOfAKy+h+75wnBd9L5XmFFl08I+jw+hOrxfXa0X/eal4rBfhz?=
 =?us-ascii?Q?j4O/yo0ctMDXRRJdwtQ54JmbRE8QL8/C3QQT+DidZfyVak1wDVsvxgGFyIrb?=
 =?us-ascii?Q?bU7xam4YWl/GoudQqVJLFFyIhzRSO1SqEDdXMhLCtpgYyMb9Vqvu0CVU7y3l?=
 =?us-ascii?Q?mu04r+xx1j0SDr6EoVj+U2lxcYyXYu4M5alLepN/KnUpVZmRSgJeqd0qII0C?=
 =?us-ascii?Q?fNmObQN7T3Xza6jgcYLchKa7smachHSeBuFyl9i+Nfsrw20bdPC2s5yw8+EF?=
 =?us-ascii?Q?HHDxxx8L3Gg63oY/xsr1/9t/ZGfKh+f6Hox0sOVDhVYktuAcY6YqXZob+FJ/?=
 =?us-ascii?Q?KPHe+RwFXYPqo/WCizffAw3sT5L4z9W4Kf9CHiNp70OVoYwbrkGMFXJApU6d?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 044a21df-d34e-46fd-ffc7-08da81313a0b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:25.5310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hWMi0ahOP/mGJEdExvJAOf1JcKuFjac5pHWKPRbnHU1XhXNz2uhBvpzO8q2wOJpVD6b/o6mGqkHEFgyO4AaooA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5648
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA framework manages groups of switch devices called trees, and
when an event occurs on one switch, it notifies all the other switches
in that tree through something called cross-chip notifiers, so that they
can react on that change too.

Sometimes switches other than the one who originated a change can reject
that change, and DSA must restore the tree to the previous state. Right
now, it either doesn't always do that consistently, or it does that, by
emitting a second cross-chip notifier with the previous state (which is
handled even by switches which already *are* at the previous state,
since the notifier chain broke earlier).

The status quo has caused bugs like the one fixed in commit 4c46bb49460e
("net: dsa: felix: suppress non-changes to the tagging protocol"), and
this has led to me trying to improve things.

I am introducing a _robust() variant of the functions that emit
cross-chip notifiers, which performs better rollback. But we still need
the non-robust notifiers for things that are not expected to fail, so I
am also making the non-robust variants return void.

I am posting this as RFC because something still feels off, but I can't
exactly pinpoint what, and I'm looking for some feedback. Since most DSA
switches are behind I/O protocols that can fail or time out (SPI, I2C,
MDIO etc), everything can fail; that's a fact. On the other hand, when
a network device or the entire system is torn down, nobody cares that
SPI I/O failed - the system is still shutting down; that is also a fact.
I'm not quite sure how to reconcile the two. On one hand we're
suppressing errors emitted by DSA drivers in the non-robust form of
notifiers, and on the other hand there's nothing we can do about them
either way (upper layers don't necessarily care).

Vladimir Oltean (10):
  notifier: allow robust variants to take a different void *v argument
    on rollback
  net: dsa: introduce and use robust form of dsa_tree_notify()
  net: dsa: introduce and use robust form of dsa_broadcast()
  net: dsa: introduce and use robust form of dsa_port_notify()
  Revert "net: dsa: felix: suppress non-changes to the tagging protocol"
  net: dsa: convert switch.c functions to return void if they can
  net: dsa: remove "breaking chain" comment from dsa_switch_event
  net: dsa: introduce a robust form of MTU cross-chip notifiers
  net: dsa: make dsa_tree_notify() and derivatives return void
  net: dsa: make _del variants of functions return void

 drivers/base/power/domain.c    |   4 +-
 drivers/net/dsa/ocelot/felix.c |   3 -
 include/linux/notifier.h       |   8 +-
 kernel/cpu_pm.c                |   3 +-
 kernel/module/main.c           |   4 +-
 kernel/notifier.c              |  21 ++--
 kernel/power/main.c            |   3 +-
 net/core/dev.c                 |   2 +-
 net/dsa/dsa2.c                 | 156 ++++++++++++++++++++----
 net/dsa/dsa_priv.h             |  56 +++++----
 net/dsa/port.c                 | 213 ++++++++++++++++++---------------
 net/dsa/slave.c                |  81 +++++--------
 net/dsa/switch.c               |  27 ++---
 net/dsa/tag_8021q.c            |   8 +-
 14 files changed, 348 insertions(+), 241 deletions(-)

-- 
2.34.1

