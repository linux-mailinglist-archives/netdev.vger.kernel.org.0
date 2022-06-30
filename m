Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D305618E6
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbiF3LSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiF3LSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:18:40 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130131.outbound.protection.outlook.com [40.107.13.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CEA4D4C8;
        Thu, 30 Jun 2022 04:18:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXngkat+3aouW/Nlm4KXLx4ByURUvnI2cnqmzuKaQsThpMfAzPVJh9/HRDu9Nb2iQemoOrfTXM29FmtQTVeDt6I3SP9TVI+buTKmbJsLAwlWHzB8OlNmDPZW9/57lvRWJtKWPhQMiTwsR96FiNDUfPGiPRSBQEzcZy+vDQ3g2DVi7JFOtQnsrUFkWjRaj0j2Q0ZRfyqrplZzbtCDwS+o0JWVKW+AXgsgf8ycnBXSGBcLSHvDiIeanX7jtv9qAq77yw7n8ioy3AmYS4ItYHs6Wq4J/fVmSi/9D0kDOAAga9KVkzuudGgHi8T2kjbNPae0NT/USV4zSZXneedXCitiSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PshA7ilwVGhBTPPI5zzfdJSH/qtoYbnKTH+wU1VTMI=;
 b=XeYIkl2iDrzkQUarkZVtUTHq9OdZt3OpaWTUOjqGX3IauFHBjJMlXUGSO8OCNpSL89j0UFL7dNDoG+HWPRTpPAFHC2wP7UGbuwIksUUGAdMV5ij52yqAqGtlXUHkMAbaWQQnf0BJNC0SAKR8KNwICTJB17yun98zXLMnfN9IUiPfEK4BYmuxEOHNPxmjgsd/p8TBsZfb0lcdA3GtWrp3b9/NlzKSpqU76q9iNsvWWw3WP5RMlc4Ke36A5/M+ZmI7hg0U5/ee94wXovOutpSBzLsU8nTqsyzHFwHcflPZ0hNTUzpn7s5hGhlJDav2AoTyXOJubYIbRRi2JJcwtCZwWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PshA7ilwVGhBTPPI5zzfdJSH/qtoYbnKTH+wU1VTMI=;
 b=qYmr4z1O4FRdB6FAV7fgO1E3IJJZrJGGMJIB7oecL6MZ83OvSvRbweftzAxFcoi4sDWQMeJCi4UPU35LOj7SbXYDf42Ys8qc72Gp65K6xEJwCQxfWjviPtm+EB2FKlE93y/fyN0g+zo+zHIxSgt4foWA4l7bb3AAuNT4EycPlIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by HE1P190MB0489.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:60::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Thu, 30 Jun 2022 11:18:35 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 11:18:35 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, oleksandr.mazur@plvision.eu,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Cc:     lkp@intel.com, linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V3 net-next 0/4] net: marvell: prestera: add MDB offloading support
Date:   Thu, 30 Jun 2022 14:18:18 +0300
Message-Id: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::22) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b52f2a96-39a4-40f0-4340-08da5a8a45d3
X-MS-TrafficTypeDiagnostic: HE1P190MB0489:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OhcCjLTKL557XSafssa3e44t/LEn+ZP7fuAgd2ePnxKstyfox9fpoQV6WFn3kNSRJx9W8MXAU+SKtNPWOJbRDBeeatYgnoHuZax10azzyRUa6qNTV6sUwgDUaJMeIHeEkotBuAXhLjvbzxFCkm5pT3O/3L5z7mqOcjGLpGUl1V1Ybv/iQ0BWOWudThWjAjMQ8ncK9RAc//CnsfHhqXMN5/2k5i4a9v1O8vIx8UxT/LZd6RAOcb0nbQIypV440xxU9nQdOyYE0mUMDu2WL2/CZE5lFbLZwxtvugaD35IXzyleAne4qZDfLsIDaEuuGjhJzsb8lwGRNIbkA6DvVxfegLk7/YhheoM/bEK6c3olEer28A/zYLReXTFqRuLRwXUo95N01mtjmA4/JnEOJ5zaxTdKnstU5XIYb/9doiybNdgDFn1d5raj9ADTbM5tb73cBS4SSCOthCx7EiJo346uBZ7XeRAqC4EX2BL5AXA1vkalEh83f2nPyM6J+gZjFTmUsWJbZKGUSdsyG3vt8my1qAZwYeVjrKp4TjF++kuhsAcE9hnP7Y8GDl8e+3dMWv3ULfUa9PiOwYj6a8LH+cuDKIKHmyLUgLQK6If4U61fS0nL+R24B0dsddenJvtqxg9rL7ctcwCfuuwJ/HFUK2zzktMhbSL+XRU/lfD44UajsZ86lH3++PoSXuqc5FgrG9X+dCk9W3Ng5EfG3oRMowb4poh5fN1c2v0O/qrNbJvKhU2tI0j73OcjRU+oZd4LeOk7wnu87I4H2feCyUVrvse/42NaUaSS03SUFftgYRhxk9Ex3niOuFP6GI1tMk1JiGty
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(39830400003)(396003)(136003)(5660300002)(66574015)(86362001)(36756003)(6512007)(8936002)(6666004)(52116002)(38100700002)(2616005)(44832011)(26005)(38350700002)(66556008)(186003)(8676002)(107886003)(66476007)(478600001)(2906002)(110136005)(6486002)(4326008)(316002)(66946007)(1076003)(41300700001)(83380400001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RwtdjaFpTlX8Px0FWVt9H5kD96hr5YspCgZdUG0BHCJH5KRuGWW7Qalqe6n7?=
 =?us-ascii?Q?LNXqgx6xv6zD1tqHJfozb9kxwAKl+Aq5Ztm/tDjmEEb0Rkv5snWhRSExBosS?=
 =?us-ascii?Q?cMUXJhhpWrxAk6OveLtfkmTMQVuKgHszDUGE9F4UpC4c/j/P+AQizCbIoOzP?=
 =?us-ascii?Q?c8niStGA7LiUOqT7KH8VRCqSzsYOygXF4RJ47Ksqv55BkYUIGRABHvQLMxYV?=
 =?us-ascii?Q?p3DS4D6pl4CV0aFEm84v9VcnNVzYQngUTw913aOfzjGELF1N6u7f2Ud1CJEY?=
 =?us-ascii?Q?Mh9Uy9aFety9f0uf4GslvSXxr4RJYBmcX2tl5UIdvw0cqV/qpafaALcKoUkS?=
 =?us-ascii?Q?Nahhh4TQ9c3lR/OnsV6mr4SA38vxoG3iHi7qPI/BDNp6dIOcke5vMjHo72lo?=
 =?us-ascii?Q?SinsKZKtfFWGOXgYXxr4amfs+3qfR/2eRnWX8hJKLD3wzRTbeuq1KNZp4YGB?=
 =?us-ascii?Q?QYSshyZB/5Ou+zmRzSubavxPJVOO1BqpKddV9FFuKFADGU286V5Uxg6b6uLp?=
 =?us-ascii?Q?WDqMuZDM8Nx3slVbPy4JDC21OMF9ME1kCbeKisVw+lCFh3NMJhiixECs8/7z?=
 =?us-ascii?Q?2n5eJdTcheuk9zHp6/bttdha95C/dCzsnVKWiq0XeIRA8EdjcMYgqbPG2Jlu?=
 =?us-ascii?Q?VE4ZVSzsGim6SnI1kZefp21NFrCwLP9Ai3VH8tfTXSKDyqDG/+WN7JE/x+lC?=
 =?us-ascii?Q?oGLnC+nDKKAJHizDUBI1z2JEpM3spWZkD4z2Ar0lGdNd66EdWEymmGPDAtrv?=
 =?us-ascii?Q?rIEBiD3tXHOczetnPiiN47b6Cc1Hz6/P8+bKAsURiJ3jB1RXffz3Z5n0WIBp?=
 =?us-ascii?Q?jYiQf3ACpKwG06xJgLR4yJiAEYLI8Z0DLeD7qr7tfWytVGTWnHuzCvhKI7ES?=
 =?us-ascii?Q?niNxi+YCnA4kV8fy2G7EmBcFgxTiQTOCk6TwNrlKIFN0ld5J5A9B2xKHlZn4?=
 =?us-ascii?Q?CLTA+PFazYror6LYXMEgFBS+o6MGAIR3ZbZq+mBDKTu4ImCU0Y+9tbPO6efx?=
 =?us-ascii?Q?OF8izRSy03hfUQZw2F1AZt0duN+z/YjpHkDun+QFeHAgimeOY1UZvlo7aw3F?=
 =?us-ascii?Q?ZyzRgmYPXVWCqkSpzB19MUMyf1/+otOo0K0ThHPMoS1Kt7zZ/774Qf9cmYmr?=
 =?us-ascii?Q?qBwFAZHsteTZLAWkGFO+lvyuWYaOaX8Ie1l43IY9e84zHQQSFuwWSEqcBCM6?=
 =?us-ascii?Q?JYgUreh/5nYSUyWNNqO0d7Z7QUEorMHWZ2JIpkF4lZ1scazBWJV2W3g0CJLb?=
 =?us-ascii?Q?txXt2Tn8zl2g2w2v3kAlgcIfWxJWgd5Fx8gjeyz84MbU6nAMTtbO7N+eFGVy?=
 =?us-ascii?Q?fLn2H+z6UZgL+hgHeUg6ut62oWlRsk8PEaMIhaBL8hXu6wVQblHH41hf8zBi?=
 =?us-ascii?Q?AA5vCyRHkERVReK9vV/xMyWqNgW+N+UoRyrMBXTkp0QipTMuuahiWlUfcc6m?=
 =?us-ascii?Q?ltqqBwuzWX7mzdY6km8X0KBcFanXAUPUVWHwHRkIMYZMF0Sr5GLgjAl1+0w1?=
 =?us-ascii?Q?9LzH7h6dqMWOFLqtBP9lEqTOkCGP9wotBNyWHjnLLCyB9N5WF66GbgzIcvij?=
 =?us-ascii?Q?d8NrLPc0J/52XTPFh5v9zSJpXg+NEU4nD2c+Ef7n4TklnYS/7kNuAZvVAqR3?=
 =?us-ascii?Q?XA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b52f2a96-39a4-40f0-4340-08da5a8a45d3
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 11:18:35.2774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBYKEzokhDDZzjZXMGmr5JkkHG1ePuVg/o9zMofPpKNg3ieSLPUzpImXmnWzxfFDPTrsQj71EZwMpGbSUuWHOZFGraOjOOdax2cUS4udem0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the MDB handling for the marvell
Prestera Driver. It's used to propagate IGMP groups registered within
the Kernel to the underlying HW (offload registered groups).

Features:
 - define (and implement) main internal MDB-related objects;
 - define (and implement) main HW APIs for MDB handling;
 - add MDB handling support for both regular ports as well as Bond
   interfaces;
 - Mirrored behavior of Bridge driver upon multicast router appearance
   (all traffic flooded when there's no mcast router; mcast router
    receives all mcast traffic, and only group-specific registered mcast
    traffic is being received by ports who've explicitly joined any group
    when there's a registered mcast router);
 - Reworked prestera driver bridge flags (especially multicast)
   setting - thus making it possible to react over mcast disabled messages
   properly by offloading this state to the underlying HW
   (disabling multicast flooding);

Limitations:
 - Not full (partial) IGMPv3 support (due to limited switchdev
   notification capabilities:
     MDB events are being propagated only with a single MAC entry,
     while IGMPv3 has Group-Specific requests and responses);
 - It's possible that multiple IP groups would receive traffic from
   other groups, as MDB events are being propagated with a single MAC
   entry, which makes it possible to map a few IPs over same MAC;

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

PATCH V3:
 - add missing function implementations to 2/4 (HW API implementation),
   only definitions were added int V1, V2, and implementation waas missed
   by mistake.

Reported-by: kernel test robot <lkp@intel.com>
 - fix compiletime warning (unused variable)

PATCH V2:
 - include all the patches of patch series (V1's been sent to
   closed net-next, also had not all patches included);

Oleksandr Mazur (4):
  net: marvell: prestera: rework bridge flags setting
  net: marvell: prestera: define MDB/flood domain entries and HW API to
    offload them to the HW
  net: marvell: prestera: define and implement MDB / flood domain API
    for entires creation and deletion
  net: marvell: prestera: implement software MDB entries allocation

 .../net/ethernet/marvell/prestera/prestera.h  |  47 ++
 .../ethernet/marvell/prestera/prestera_hw.c   | 126 +--
 .../ethernet/marvell/prestera/prestera_hw.h   |  15 +-
 .../ethernet/marvell/prestera/prestera_main.c | 191 +++++
 .../marvell/prestera/prestera_switchdev.c     | 730 +++++++++++++++++-
 5 files changed, 1018 insertions(+), 91 deletions(-)

-- 
2.17.1

