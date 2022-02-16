Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65614B7C44
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245394AbiBPBIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:08:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245363AbiBPBHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:07:53 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10111.outbound.protection.outlook.com [40.107.1.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25710F542A;
        Tue, 15 Feb 2022 17:07:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYJo7SgfgTw76goHNw6jtjBWcDJyn/oVgnnjodO8n1L1oKrOIJVVRzn8/LbXFLTM0hRJhul1gEdwLKJv7R3/e/o5V/Q9P60YpJBFkEbjWfQRig1KBHHOJ9W0kz/cODJvKNvWZfqe5TW9FR7lcHFzm+uwUPm0zLBV+/dpJCze8vPKmVi5IJ+xaEbhtGlaf7W+SXqV1hHbRXY0Dcnu6LfANDFvtSdUrkSC76AovibQ4AU7JqN0DMrvnbku3XMjT17KZFfSmXCyIo75gL1OZX217T7/BN7Ajyts1xBfZOqdgVRpGzRABLUNOMgjeSQ8Iq4iI31rZdAMb0pdISHudcVJjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhQkxPc0/QhFJFtLbDgmU6eGMnQHbA8nzp2ktaGpDJ8=;
 b=ZJC5KHsT5g6Klbgbama0ZnFiAan04SWNOEUlM+/L8WQ+kT9aS2MrFa2Tz4eyqM586wpYYD0/zd3fwWON9RgIKXY6hasmjV/THQgpQAMZyeoqI71mhJUxcfUf0pdBfOXgKtCerj94WRfuDdw9B2skYt0/pZUU7erYIv1dgLnL9YrAm94KaDL/01cujG0WykoUdPawlP/HhqsaceaV/3AfI0ESlZKqOESqMuJZIIyprHYS2S5XkjgEfTKiL1VbS62IAPevNNB289icWzllPXp0HIiiVsrz3W9MOfTPIiFOCr947cEwY2t3HOF65G7A0+AXSa9CQU9jh9GXyF6T2reeVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhQkxPc0/QhFJFtLbDgmU6eGMnQHbA8nzp2ktaGpDJ8=;
 b=q/x9LKhi5PsqDDfvNuSqCKhvTaIEGnrPBxLuxdvJVxjYJ+lkIW0dCVPmrHb1EY87r4glssi2gfnx6wLDQtAjd6fDJtnqgqLVbB2hl9Y/0runqEl539RRU6LiCZti/+NLd7wqFAn7xEohfxishrIrw9biNVwvIGTdxQdxY1txBSQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1169.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:266::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 01:07:34 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117%5]) with mapi id 15.20.4995.014; Wed, 16 Feb 2022
 01:07:34 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: marvell: prestera: add basic routes offloading
Date:   Wed, 16 Feb 2022 03:05:54 +0200
Message-Id: <20220216010557.11483-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::19) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faacfad8-df81-4b4f-9e9a-08d9f0e8b688
X-MS-TrafficTypeDiagnostic: AM9P190MB1169:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB11697848BAF54EEED212BAC593359@AM9P190MB1169.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BuXwQViuVQ64P1VK6cFqfXmvi0uws0Svpz5IFNvNl7wzcyVQSwizbZ1S+V4/MI2JJh2LK5pINnSg04sgZLEbwroUj6HXgPnHtGpRvnrdtc0hFC5Buy7ZJqmail4cFCXqgECr00/UbkcrVWvMQV88LOhewLFIjxBG+LkfCGWmKrhTfPhvTVpjUKTLHtAKIyRy6egMxFl8JpZbuEwi7QksdN3nLpaFvS6aOIu+Kk9A03+IgZwc1sm0Vmi2lVKih2TwH5Zgn+c4qAdrgPOde4z2G9VUar5kf7maTAaEHz10fwkSIa03hAadV0f+V4gzHVfcMWFYSe4WTKhloO8PVbF3C1CdG6MCYjxZE1jOPkDd5gG4OmhFZblX36qUqkT7SgbFQ5omUgWpXkMWMXhVcmB1o5rS4o6oC0RLM8BLlYV+pulxaKBPfE8XFniTz6qp3ghBHWsW3TnaKhhgsftisecwoi/8ARINvEu/Cbxvg+/mUz3UP4hM9A3Uw27LpsRHrhHMCP4Pc0JcxEVrLK+C/yp6pmOAC8KMfKpBneki/4TMihMDOiyxp9eSrrxzXnMQiLZ6ttKHo8oacIldU+NX1N6VcL22t9oZr7SagYdJKfBx+yzjl4HgZAv3Pvxf2XaGzu4o2IYrAkQ2GgxsWEBjsvSTIypDU551ve3xklGu2mcXDlALup6r8VMh09YhYjGndiTxG+q1/5We99IOVAlfLWSYUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(376002)(346002)(366004)(136003)(6666004)(5660300002)(44832011)(66574015)(36756003)(38350700002)(86362001)(52116002)(6506007)(8936002)(66556008)(66476007)(66946007)(38100700002)(8676002)(54906003)(6916009)(316002)(4326008)(6486002)(508600001)(2616005)(2906002)(83380400001)(186003)(26005)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fFeiseH1nHO4o1GqEbGUXjlQPjc6iFi4HFXvBW7Z/zjsTXHFRIQe659sZM8F?=
 =?us-ascii?Q?fYUTcOV6zBLJqPtbAjY3T8RmJjbfxof3gBbjkAUEQXDV/viiGiuA7T8Jqd34?=
 =?us-ascii?Q?w1gyW7aJCqteaQpVb+qlCvQv3MBacDB2y2ZahLzmEhvkoJl5cmzMSHQ6rb4b?=
 =?us-ascii?Q?IaA/nrCihj8GbaT//mokHkIHAIUikhX3VyZ0QYcCnAqXx/eYVmKpTm2SWoUN?=
 =?us-ascii?Q?lf0ozsmZeVtr4P6FGvS6Gi5QDRG9YgC02FILbYjGsO+rPs9nCyuaPMRHPm6c?=
 =?us-ascii?Q?fMvrQIicpkxUGS6h1rseB3t08O2skNWzqZQxQv9RGmFblMk/PKlfnK/8pP68?=
 =?us-ascii?Q?XvQy/uzjoJK3b+w3Uib6Mczg8X31LZ91lsXobAEzHdzmJlAkgPcNVaTk1CsB?=
 =?us-ascii?Q?P4C4mBO65dITIA5N/KUVd1KXnjhBLfLoLD0QuCUOpjMJEbjEz2wmTH6gZBEJ?=
 =?us-ascii?Q?z+acUsP29ztw4BMcJ0TAK+QkDZUSI09cpvJwK4WCc5VeyH4nOW4egfUmX6M3?=
 =?us-ascii?Q?Mnyy75FVi63Tg3v9pJXyBipVWHSkosqV5R9lUseCYqeeyMCYRGbQHPGdGj7y?=
 =?us-ascii?Q?7ATQ1v/nBxTNQr7IkcH/yvsv6rk91yJV0/C5nhp+8As6oMPkgKkliWjZUN6P?=
 =?us-ascii?Q?gUrdOAYIeCVH7NjBUBVDmVL7vMlmaFWUBDqM8e4PoEAsx972EVjbx35Jmarf?=
 =?us-ascii?Q?9SvFVo9QLiXunbjiuypVrsbbC+lefzHUN/ecBjEVxZAMQ6M21u7VIk/NeYQb?=
 =?us-ascii?Q?lsuTpQ34LQQ4wPUf/GToLwoSK+T3iFwSBK2ReVLqFWuKvPJo3+tfeRWwYtwA?=
 =?us-ascii?Q?3hH9lyT7pmc4BaoVHvCuVorCDHy/v63MmqxSUteQ+MW8LqQTaJu0J9scQSgR?=
 =?us-ascii?Q?Sf9qqckl00jq+4JLpC9XgzUKNOr5q//mM3IKBYDyAvTH5qaBasfDNYf8eW5+?=
 =?us-ascii?Q?TqgDtOSsvmOcTPvofoydmjYK27TG4xSK5ZXCGD16m5ne2/b6f0UI/4UsXYKa?=
 =?us-ascii?Q?0HMFNMVChxwayFo/p29f+EzCmhML8OW3QSwFtbCeJPqmgKiJEVRBpcKAhRAM?=
 =?us-ascii?Q?paj/D+Af/1d926LEzFg+4oS+iJlcMO1idDXMlSibtYcavI5doNv/Yhv1THb2?=
 =?us-ascii?Q?2pWE0V5QBkoAb9vE4Pvnm0Zqdk/EeFSHn8L7ZcyHdbEFVtqp4rfAwL/XyH5x?=
 =?us-ascii?Q?emHOdqu+xaD/+8G4o/UGuxaVHqcX3ExanWGTlLArKGCs9q65vJmynDjHxheR?=
 =?us-ascii?Q?tOiWImUZJuTgYkh7GGWWS48o0WAhAvOSKqR5JzYVWhRqkMSv+pekxOTW4Vv7?=
 =?us-ascii?Q?faYMGb6Tap9nfwx8upoXcHXXwAEHNDXU944ojNv0+KUTzog4Udy/m2jehIgu?=
 =?us-ascii?Q?i3vRtEdTCNbhMdx2v09PRb1T4ByTcR33UZ0NETo3bjAbOgQqIGI57mNm1EWG?=
 =?us-ascii?Q?UxE+SwbZPxKE+4Ber4zkAtWmYt6g9xj+ynMRDes1m/hqoQsyxKHJ03EeF621?=
 =?us-ascii?Q?3TBJDnBbKDy7+hT39RuqmIm7FPsxM1Seh3HESPD/KbA/7KhobA8gCP/D6AUj?=
 =?us-ascii?Q?EtBv4Ej00kgTIiCHpmR6vAonKf1CV3DVD6bMT3D5iT90v2eoR60e7rMScYs9?=
 =?us-ascii?Q?aI8cS3dNCSri+ZpevMxI9v06AlgAluyd0wSYqzUFlPH4Mxs9LlrWo3U75niL?=
 =?us-ascii?Q?GWKCYA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: faacfad8-df81-4b4f-9e9a-08d9f0e8b688
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:07:33.8390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sv0nIemxaIrPL8IrfoVILNwh+D5AiUCzpWZZBbStqku7Za19ctcRykimzgoTam096fkWpIChHP5fwW9c1JbLvjWpJ4pg1Y8MYrNlI0YZhtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1169
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for blackhole and local routes for Marvell Prestera driver.
Subscribe on fib notifications and handle add/del.

Add features:
 - Support route adding.
   e.g.: "ip route add blackhole 7.7.1.1/24"
   e.g.: "ip route add local 9.9.9.9 dev sw1p30"
 - Support "rt_trap", "rt_offload", "rt_offload_failed" flags
 - Handle case, when route in "local" table overlaps route in "main" table
   example:
	ip ro add blackhole 7.7.7.7
	ip ro add local 7.7.7.7 dev sw1p30
	# blackhole route will be deoffloaded. rt_offload flag disappeared

Limitations:
 - Only "blackhole" and "local" routes supported. "nexthop" routes is TRAP
   for now and will be implemented soon.
 - Only "local" and "main" tables supported

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Yevhen Orlov (3):
  net: marvell: prestera: Add router LPM ABI
  net: marvell: prestera: add hardware router objects accounting for lpm
  net: marvell: prestera: handle fib notifications

 .../net/ethernet/marvell/prestera/prestera.h  |   5 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  49 +++
 .../ethernet/marvell/prestera/prestera_hw.h   |   6 +
 .../ethernet/marvell/prestera/prestera_main.c |  11 +
 .../marvell/prestera/prestera_router.c        | 412 ++++++++++++++++++
 .../marvell/prestera/prestera_router_hw.c     | 132 +++++-
 .../marvell/prestera/prestera_router_hw.h     |  44 ++
 7 files changed, 652 insertions(+), 7 deletions(-)

-- 
2.17.1

