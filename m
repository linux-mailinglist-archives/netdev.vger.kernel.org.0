Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A088692956
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbjBJVdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbjBJVdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:33:31 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2054.outbound.protection.outlook.com [40.107.22.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B9F8218A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 13:33:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EICU2EjdDNB0PLeqEc4yQmvNREUJ/mhMiKM54hWA2d5p3UfCeyrfGAc6w7c4As9Y462lqhQBz41FgdtyqLoHMbrwucAc8XVAT2U65ve6YnMVUPp7ZPtxuKBe7KgkAzQtyojN4nn6DsxxU0DrR4mxmXg7HsKMRwAxIS8/gJQGVKvjSMVggMzHYK+GucLvCdI5tG4TgHJDQBFNl1IHvX46YiWquOfCIRsJhOqNHJ055WQWQ77io79ZW9x/nANOsUQO+9nW6EX3J8EQFh+ucIBT19GcSDrdIiblgpxHkxYVyAwqkR/cfFPFX0SJwKVJZe7Lsv364ZkTuMFifzhti99z1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEUP+of7I9MbtLiTlR5wnn4psL5YzaIuxNNnhMf4nBk=;
 b=UKWYmBtNgA5ENpaCheIO+pNHBdkqbB3imxzemeFyIVpVhHjpfhM1iDSSDDGfP0MJJJEYje5JFUMMH6YVvbY269p9I1t7XerEoHeTivi/IGgB/xuo0w1AJ4+15gvC0ixr2mZzTMcZkcJzJYVmHgT74Lm3TryHxAsoxYXPkjClx/bkR+8nrwTSP3LyWYCG3eE+MuKtecSrxDK3mYNypOz+Zc5YKesJpNLWJ2mi7+cS+FaxsuepyvryD4q+BPRB6JqJ97oyg7uxAw1sP6cyzdYFBb+ca6oB7+IIUPQcRZALRzfQ8ZNPzKbx1nWe2tiheW7g/4O4UI/L8Ek8QlCnEiLUsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEUP+of7I9MbtLiTlR5wnn4psL5YzaIuxNNnhMf4nBk=;
 b=W9zE9QbVxLLq7HcuPNzXTCI745pMOzC7vQoLUnNGCOEea24WEspG/6iHC2uqeRiuF7kgm+dBE4LNPu6AXndSPyWxbxcgCvBE1Ps2Ll5ZrfEnURd/WiYMocFLr44iN7h1ebYxui3mqdwZzbFWQqumtghFzbhGsfjQju91jrzaYQU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6881.eurprd04.prod.outlook.com (2603:10a6:208:18b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 21:33:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 21:33:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Subject: [PATCH v3 ethtool 0/4] MAC Merge layer support
Date:   Fri, 10 Feb 2023 23:33:07 +0200
Message-Id: <20230210213311.218456-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0019.eurprd04.prod.outlook.com
 (2603:10a6:208:122::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM0PR04MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: c9ef4313-e219-4a0b-58c6-08db0bae7117
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R4Dm6AeTxPvzlTXUgt4am4U6KfJeG4dWz13cE31h9dGfcS7RUQPz7YP2YPf6Yj/xukSmhpBpcvTZOzUqUe0GnfCiXWgU2S5ifmtoHLRCrBI8ADEUpTb/E0FYS22fuQTzuWDkoji+cn7SSvoD4spwi4c0FpKuoO21aTjvkBHM2V/gsx571t6XSpbDG1Jj+aHl/i6AS/8244AsRsvBbc3hd16yZEYse/41Y57mcQJYRM0fyOS9vBQ+B7yM2/DJ0YzYp0AmJaeMLP8xocPDi62AZzcQeSAxwQJC2LmIpPU3LNVuAb6hsDWPS6NS1b5Vx+CCT4M2jRqqe3rZnPDGiDCu8lRACrIV2WgBw8db8jFyZqy7gi9JUxZPlGns79tRH9N6s7hAooCshEqWiyxBUUu9qaojsUT17Vq1OI1FvsiplUnZHbsHCNJjDRO+muFo6Ujv7041wYIRJuBlSTtRzBaz2/8QzmuiXbHBhkyEwmwOsLytATZcI0KF8gPiCoULRfUwHOVfdfGLNyCc4I+uKpGIDOHyRhRwGJGSxxqluvxVct5SQg7hjpALWFCxwf8hw15jBmILB5RbUwQc9qlfJAiqF3IF+GrPsU25Slmdf68lbiOIKRNviZ8sHSvXFhHR08YIUKtrR3aQYp1B7FMfH9znuYJVJa7txBAvEtGBNib8b8/npu5v8uUeS85lAl2v+tiurVWS3RT8sVMU8FUbRAejrOYLCYO4KVMsFMLqvFe3iHc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199018)(186003)(66476007)(6512007)(6666004)(26005)(52116002)(2616005)(478600001)(966005)(6486002)(6506007)(83380400001)(66556008)(66946007)(1076003)(54906003)(316002)(8936002)(6916009)(4326008)(8676002)(41300700001)(5660300002)(44832011)(2906002)(38350700002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pzjt3kb8xQW9hPfzy1U96H1cX3tWJJ+H/Le0Cgiv1GoBnYkrQWK74mAMB669?=
 =?us-ascii?Q?WE7CKDaZsydafGLm3K6VMWjuB454/hqfq3TM3Peu48h3Y/kyqrSD1USiJKZ/?=
 =?us-ascii?Q?16ZZTJ6axEamuTZthkftrb0rMI+Mydm2UgU8AhDBwXCa+hfiXjnGrFWophEM?=
 =?us-ascii?Q?5WYbQt1k7A1L98S6y949gyz6CeDxDrQU/OuZfqhr6kqIqSo/fqLnY75R+hS8?=
 =?us-ascii?Q?ba6G0t0MhphBMCdw5ZkF4P1eDoeS/hECvc7nkrR/crShH5iMMcG8H21dq0c6?=
 =?us-ascii?Q?JivspoTNdXDd2bS+pFaQtYgKy4JYuISQ1FerOBaTBhpuX/5oHdfP3liXAmJi?=
 =?us-ascii?Q?iqPhuQelVHus1qAgG7QF1uvom94GCQjKGB0SN4tX+ipJ871QhbrhIByNrBb5?=
 =?us-ascii?Q?i/D5kiRL8gNmXPG6id8VU1oSb61MKxZRW1kHeLRMO1BvNw9oTeMox2KjLAJt?=
 =?us-ascii?Q?+mTgwOO+MaJp2sX+bKo0uIqNPRHS6ygbuw9zU8PwGNLixugzeXPUlhpjFAAe?=
 =?us-ascii?Q?tRRjpnm0G2MX+9ALd6W0xQTqAr3MKPLAqqvHoN7VnTuyqVn6r/JDKbDGA4dH?=
 =?us-ascii?Q?RY8Y8IW5JuFi0j7Nk2UcUcvkQXpu2iSRfhLX6GhMlE3G9UVua0WiQXrKyAe8?=
 =?us-ascii?Q?IhbcL1hqTqb44ygWIsDIKZBZ6IN0OI3+V4XsdoA0PD5VXrUIXIQ/BJEtpyqk?=
 =?us-ascii?Q?L8G9ajd+ueleyMb83/sf/hXF0psMThU3eb7CnNQBk6ivstv7BXGeNMKogPgI?=
 =?us-ascii?Q?fnV6lfJH2fkAkXS71ZcckB4gmcJbv526qiHLV5aRPjqPACVp8aq3Ja9Y82Bs?=
 =?us-ascii?Q?rL1T9oNtJPzmNCFdiiNT4YocZKYvG2NlsqxabOMECrgNeT/LNhjQi7o04fxJ?=
 =?us-ascii?Q?zsX2zNRxLp2XirQ+Gr7MU3mUN5Twq6y0Q+Or269c9F2WTRSQc9TCfQfjH8Vh?=
 =?us-ascii?Q?evLmo0z9Jv/Q/pAaPz1pSLnNOISB1OmPKNWaHU1CKkK27OvsTZiLYe5WEHkt?=
 =?us-ascii?Q?wShP2JkbilQmD6e8ngIO5Dh8x2vBAGJWJ53x65Usn9mt8Sf3NmmqU/LcK6Iy?=
 =?us-ascii?Q?e6lkGLvb+nyj2wBrqnM4lEoqrdTgq3+SqezGTd40zX7Vu5zZMmqZdTHN2foK?=
 =?us-ascii?Q?NP7fKpeTJxBESUWKOFY/VOCn87bWtwMfbzan5SKQeeoZoSiw1t9yzbf7mXi3?=
 =?us-ascii?Q?iZGebxqPLlX/qIhkuMC88TEKa2UoZhYZj83Fh+s/rAkTFwrf1g9XcB5qb+7T?=
 =?us-ascii?Q?6JyZww/hY4Yw0lRqSrk8jvxC2Asg44VxWxW6aJ5vjyL1rBnQ+5K3oOEoMDk8?=
 =?us-ascii?Q?SYfp/UDbRvmYXNAEjitx39c/LZ7704XtTMhkRoGViFihozKhI6jiF/XGECrE?=
 =?us-ascii?Q?99+tEk0GPNS9sRkdULmM4X0RWXvP/XkBHtX2y1Occ1Yl/qxSeZJWp7eq02+s?=
 =?us-ascii?Q?wxzN5peus0w1x+2abkopVOKmAKvdGFcDF8EgjXyE2IyE0qiyzP+vnZnRnaMt?=
 =?us-ascii?Q?Int1h2tic5Db20cWGOELOsRp2RrQRluQMYlckrcPQR/mN5e2oGxxbx5h18GS?=
 =?us-ascii?Q?ZXH2Z8+ckhdjemIzYrSHH5ZaRoK9AAJpK8pDe/WVZ2AjlVWG9lcWHOSAsebj?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ef4313-e219-4a0b-58c6-08db0bae7117
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 21:33:25.4658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BTILsq35D1amD06Ypp23h8ST8+YIjkcU9httQwDdExx8eRNiq8my2DjG5aHRQfU5uiQFp7wLYDd0MuJJXJ5Gfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6881
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the following 2 new commands:

$ ethtool [ --include-statistics ] --show-mm <eth>
$ ethtool --set-mm <eth> [ ... ]

as well as for:

$ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggregate
$ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggregate
$ ethtool -S <eth> --groups eth-mac eth-phy eth-ctrl rmon -- --src pmac

and some modest amount of documentation (the bulk of it is already
distributed with the kernel's ethtool netlink rst).

This patch set applies on top of "[v5,ethtool-next,1/1] add support for
IEEE 802.3cg-2019 Clause 148", because otherwise it would conflict with it:
https://patchwork.kernel.org/project/netdevbpf/patch/d51013e0bc617651c0e6d298f47cc6b82c0ffa88.1675327734.git.piergiorgio.beruto@gmail.com/
I believe Michal hasn't gotten to it yet, but I'm putting Piergiorgio on
CC too, in case there are other reasons why I shouldn't wait for his patch
to be merged first.

Vladimir Oltean (4):
  netlink: add support for MAC Merge layer
  netlink: pass the source of statistics for pause stats
  netlink: pass the source of statistics for port stats
  ethtool.8: update documentation with MAC Merge related bits

 Makefile.am      |   2 +-
 ethtool.8.in     | 107 +++++++++++++++++++
 ethtool.c        |  16 +++
 netlink/extapi.h |   4 +
 netlink/mm.c     | 270 +++++++++++++++++++++++++++++++++++++++++++++++
 netlink/pause.c  |  33 +++++-
 netlink/stats.c  |  14 +++
 7 files changed, 440 insertions(+), 6 deletions(-)
 create mode 100644 netlink/mm.c

-- 
2.34.1

