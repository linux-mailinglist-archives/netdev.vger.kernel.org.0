Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3147054F522
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381719AbiFQKPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381614AbiFQKPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:15:37 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130094.outbound.protection.outlook.com [40.107.13.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A624C6A071;
        Fri, 17 Jun 2022 03:15:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHbUh9YEyx/oDWi0pjTyYwbB6xfaBJ17Gw5zIoG4w83JZhHXTUG0n+Qf85/wXqwFkv5Mb0y+AmA937UK+2WBwM+rOiaXtoAO25ICyEOuYAZ0yJdPVYb4W236wX2T0xk3PZilOVsCUD5s9Cd9y9IHhWCbZPKL3Wqv7YBzRH09xkCGOm7IRUlGbvn5/TfyrDVLuBAd/d1Uvq/y8876eP9k62oUAzWwsx2TwjMcC7yDoxbsKiU0z0T3HiJprKkc+brec0kf3WN2SoTbDBsRnI0ghqiS+y8Y83mFSx5oAT9X8Qj7+XaUnKUpQ79I1FBAquZ1zkwu8p8VT3yvo6WET4/cow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0grRUAdVC9dfkS5ShW9SPJ1khQ1T028r6DVkgOHjw8=;
 b=j02AiewKJShhhlSP+K/ASL9QY4g8wUfLTd32HXtZfXHwxCc9T3lKrwInXwD9P6BapgBrwgpl9EQ6FdQU4fBxobl5bNnl51KJTJA4QtNxq0rQXAP8c9ZTLJNHul9hrMNiVq+2SHudz16QoVGnZFOMCCAjiO+Z2EBw86sE48PtZNXHkrcLSDdWe7/5G4RZID1gOYu5TF8kXp+AokDz59KHnbsHFgUtVD/fu2IGM8QzmNP5MI6smD+F45IU2F2RnAVilvMt0c7AAqZ+lPjhlpBU6I1H532DHB+plOqnbJaqRrGvOalTblEu6PeMJbwyVFJd9FHK1TrAVOJZxGIZPlKZLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0grRUAdVC9dfkS5ShW9SPJ1khQ1T028r6DVkgOHjw8=;
 b=rkY0rZ94vSZohvIj5Nvfl5kwd7pbkKqdWBhiSp/RdKQ2hETyRHwCVJcArThuibEbC7GMkAlAWhasCFjbmkEs2zRkfYtUWX8PwvxD2fru/T2frqCUWkslk8CX3Gas4CWM1U0TrFKLDPQcQJqz99kinv9wPP/lX/6LYPtN3Hp4QSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AM4P190MB0051.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:5b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Fri, 17 Jun
 2022 10:15:31 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 10:15:31 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V2 net-next 0/4] net: marvell: prestera: add MDB offloading support
Date:   Fri, 17 Jun 2022 13:15:16 +0300
Message-Id: <20220617101520.19794-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::15)
 To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31f07ceb-41d8-492f-6051-08da504a4f3a
X-MS-TrafficTypeDiagnostic: AM4P190MB0051:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB0051C050D465C5BF5EACD49CE4AF9@AM4P190MB0051.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8CkuOmCzHw3oChdRiX+gg9WG8GIzj6ookt0PSuzSGrhtJ94yRiMt5SmcN+XXe1FcDPaf9KxIaSeN8QQkePpVy6T+xLleYTNkbEMVDUvtnt0lKFaew4L+SUxeY6X4hB6XGH0r+1Y6b1JWXZkHuLJxCfOhjSWEet9dCMTrUNFS6KqOzt1ylXT0ZX84EMMVZHb6FoFreDYp8SMWWADvD96TUbKZTBGxogwRsGcqOIwWp5xdVHLFJRP8aGyL7p/WSPZRsQKbaReYwKEnQQmV5C139Tl8HzE8ut+fZxhfqZC35XDV3nBIlGui5j/7rmdX2xa8gmoakTmduEWSm0w1UjHQvFFOOlsPuI+gauSAJq4t7R+0QHkozsPRUzH7EjLG/YsSThdAMTeGEV8ad4y4m+WEjvJ8WEr/8tkygoSz6W2x2uuWkQzMzVoNXxD6fungYvM8SDKvB7qebk3WwZSIimAtUjmTHnUCnztHIe9Ve6yhb6j+v/rR1zTdg+SWfNqo3KAaYwDvyd3UKDORPSyDWmXPjqkQAzwIBg7WejAH5eRjReTkp0OHONHRHn7Bf81l07oxYa2tzjrYkH71udTBK9QAqkG9c9j3GVbNYMwKnK1oCig+OFcR3Kru/QL7FWAI1uASLz/uJxDYkqElIZF3aBFVjYlfn2OPfPjwzSVfgfCJkdkYqbq/jxWYCl/idw5YC685OfBO7AOwfPFIRfp7KI3KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39830400003)(366004)(44832011)(8936002)(26005)(41300700001)(83380400001)(186003)(6486002)(5660300002)(508600001)(1076003)(107886003)(52116002)(6512007)(86362001)(66574015)(66556008)(66476007)(2906002)(4326008)(2616005)(66946007)(6506007)(316002)(110136005)(38100700002)(54906003)(36756003)(8676002)(6666004)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SiyJG5Gz5QoyOykQRRiIKhbACGHhH334w+LHuORNk7Gv8LOxnbSi7zgKreiT?=
 =?us-ascii?Q?m/GUvowRzcqHxcJ6rqbq2Q9MuHPGhb4YzqmqdMjbSmsTHafm/d5E69DpLY8I?=
 =?us-ascii?Q?zwJ6kxhvYFSwVcOp9Sr0kqJ20clQ72BOGtlWRJvjxGrAb2vZpXN/geKPrw1T?=
 =?us-ascii?Q?NRLSSGnE2UPnvCEb/9Ce8atsxf1NpCcsRzvV2giMRn6FLQoExb9VUfezP/Wm?=
 =?us-ascii?Q?U4LbX9BTVRJZ8J3VPUx8oCVU2JcjSSD3+e+4S5Mvj/fH+pt+Q1VGXjW3Pwju?=
 =?us-ascii?Q?8/hWMRH5LOHZyv9P2DMXY3ATJXfFDXScDiuNiUfDz2rrw72iynyjRm99BR2y?=
 =?us-ascii?Q?p4ZIQZdg1ZLbS6wXbmEkLILeHleJadKvY2HKE7Zj6BPpeJUXgYrpnOPVLOQp?=
 =?us-ascii?Q?056ZoTF5guFNVwBy1QHxOmvdF1hhVWRiMPNtYGmB6EBRve7uqku9U2IkzZaq?=
 =?us-ascii?Q?9hvwj/HZPpQkaBxjLIHcmlEH6zRB265IX1AcARywHbpKBhe9QR+liTBeQFOw?=
 =?us-ascii?Q?HCxTfvmlPZvesSSn5HRhlOJBDb6Ef4SNOjBU0cWK1q+XUVbUzHJ1DDDNAFQW?=
 =?us-ascii?Q?+cCtV3gYQClr9LC0RUr6Cj1Z/fXRohY81vglRUb1il5115M2oXmEhtIv7nfJ?=
 =?us-ascii?Q?QZyR45hXxt+0PqhQxIIrXX53CzAjI4TjXXEAbmKJgFpdHmNuEJTQAFw/hj/p?=
 =?us-ascii?Q?jUFS3nbg0Jhn7mqJtYlmHZbpPZmOPHMz853Wb0rRVtjAYR0H+HWIUeMauHI+?=
 =?us-ascii?Q?a9diQhaByEpXlNgGESQgxnW5GLG127euLv5uS3YQpOwAhImy3GSpniITMqFb?=
 =?us-ascii?Q?1CZUQ1sbicT7nK43UpGhbuhERvhfFVpLI3T2wBBpQoOvvvP2+WD91Fklkpn5?=
 =?us-ascii?Q?gTyNNCKnnV6dhqnTb2r8vDhBpoHGwczRUJfAfFHb17o6+6h4S6xRD6GSXTmC?=
 =?us-ascii?Q?qcRMoNCHFtTO0Qol4Q8BW3BLIu1ShKpTj81+ymJzhO9XbuPJEqGEfK0/2pJx?=
 =?us-ascii?Q?SNaPdBJ055c/Ki+yFy8zOXsCNIvHikejLnNXr7BJFBR54feKp8fAGO5vlsd1?=
 =?us-ascii?Q?tfKE+aLZ9AtPHp0RFRc952zNWHSrUyB4po2hq5sEhQGKcvgIn9kJM+zDfDtu?=
 =?us-ascii?Q?AbsutCz5W7bvUD0SK8yHWqK8B4Nx9DyZZMqDhy8fnzu7nIfKJUFf3hdgxlKa?=
 =?us-ascii?Q?iCaTOi9SPxS33jFhvvYt9UyLfH1n83u9XJekr6+l1Q+pkMSU4e6pC8wz1Ap1?=
 =?us-ascii?Q?TeUxIzXT+Z1hfqVYY3lsfaKkg5VHAhf9RvCqom26CBbLxTi6YL94lSPC6cbc?=
 =?us-ascii?Q?OVoQCVkpAtBMR4wc16n++lFZ1rxo42tcGJWD7JkaK9g9bPuXxCtRVf7WnmH5?=
 =?us-ascii?Q?vVWM1zE2dLUkKHA8bI8LAP8R4+JqTdf93CNd7HQ00k0JzNKIR1mI+fCFNbyh?=
 =?us-ascii?Q?YjL3yyAWu0n18qGgn6N42zo2lJG3LIHgF7OMEeBlR3BeZs0s28yZyfU79tXt?=
 =?us-ascii?Q?sWJWBFF1dWYKVigcNipHiFS3kVC4q5dltEnl/aEJCn9qUtGuf1xB0tRCrs6z?=
 =?us-ascii?Q?EGIS3Od3p9exaNikJL+EsQhiqRkXLXV745KI0gQDb1TqxJiHz6CFsiOYvskL?=
 =?us-ascii?Q?3LcL3Z8zohGDOKMnmkk97xWtt6PFgVNooS+d6ektIv8R/VhDuJSBTR5ogoSE?=
 =?us-ascii?Q?KPV0pMLBbByEWlC7f8t9msa7k1plKll6K+/gsxWMSQwihEc9IgCsPSaEhJTW?=
 =?us-ascii?Q?k7vTQSkRXBNI9nHExbv/7b4crh2cO2M=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f07ceb-41d8-492f-6051-08da504a4f3a
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 10:15:31.5405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 97IEupk43fL5GSteZ07DNsJ1d0V3WWvb91dW0OSAuH0dSqvpCbnjEONupcot11CzTHmkRrwWhN4F/8wYYORH5wPKceSZxwLGTvhsLNyRPWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0051
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

