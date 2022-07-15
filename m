Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB922576443
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 17:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiGOPRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 11:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbiGOPRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 11:17:18 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2070.outbound.protection.outlook.com [40.107.21.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B5E326EC
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 08:17:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNmLFDSaAxG85BONNeiu6ReSt6D9jiSerxnlP1vUNFWKFxONPoIJv+m/uyndevjdq9mWzGFtSiVaOZNX6sJlohf0ZZWm+F4cQUQhIa+UiZlrLDvNZu1APjy0iTUFkc8daeNYM20kayzLzKKRX4Iw8A8jNb4kpDrhvoB6JelkRwPHPx4Ym86XlNItEkLv/SJMEtuZuEB+zGA8yGL4HfvCQPZjlJe9YoiV/ubK5gz43UTS43q7QL1afJXKwp87dJXiQgojbmMXbLucxyA17vJX8CGc6NAFAyBALFV5ozNcjBz2vPIVWf50k+YceXcLp+xF/u0t+sHYcM3I8NvuQhc7tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4sDv+x2CjGVaGjjjipGMnv9GjwdQlNLjT/JhaDcM3So=;
 b=aKo2lp+8xTkxY8Z7nCO+9693pbAmtd5/+oWiYO0ZemELkH3rRnMMV2VWa4cOCkIf8nU868+gyWux+aXw8aLKVCBNOzjvWuMyLOUpzcwev4y0aNQOKEgSDSyiuMsBuwQ2DPGxBKtHCBm2XuqtVCmrgbWjrgln7sSX2aMHvnr4Nt/xQTxL5NV60X87Ce9a8lUJoiFkPVpMHb0Q7QwtlDMMh7AMM5GqqTVIdyScvxpvuyeB0tYx4OQIOFXuktWeijVdAJY7uZiF/B8RKhcYOXMZ9NTHxlPbe15tJZkdu3zDttPeHKc5i1yIy1Jog9/MtbRZTi5HP5p/sP+Eygzk9TSrFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sDv+x2CjGVaGjjjipGMnv9GjwdQlNLjT/JhaDcM3So=;
 b=HXKlgFOm+EOkwpW5ZBNVKUyusrotB8N6S/kcO6hN5wH1io7v7NT4a3lJ1MA56NMJEyVCZr5KLVaWkQpwL/YHQWn3IJl2u0QI+j8ZGNYCZmkRzWQtYgx4SbBL46gVZ4OpbUH1b0ktkqsUqNMrZ9jnXO6vWL8v8PG7FPHEvMSaAFc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4192.eurprd04.prod.outlook.com (2603:10a6:803:4c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 15:17:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 15:17:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lucian Banu <Lucian.Banu@westermo.com>
Subject: [PATCH net 0/2] Fix 2 DSA issues with vlan_filtering_is_global
Date:   Fri, 15 Jul 2022 18:16:57 +0300
Message-Id: <20220715151659.780544-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3a8fa63-8b2c-4316-3fdb-08da6675174c
X-MS-TrafficTypeDiagnostic: VI1PR04MB4192:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpbgzHn3XcLD6mY/EZFAEZBQuZhVYROuVFefGy5jcNPlgDhLQSTx5g25APSfoyUIbyfuIyFgNDZe+IROFfP/DTaERPqsw7GFlddg1cAfwKe/oCAWgphuSabtC9iVoyCvJt5mo2pEoedoH/TcqMScfi6XiUFTAdb+HIBN+Mn7gEWemX88CSmt+ikG/K+9QPLnYByp8+Tgfk31DcD9GSZQQxJ+U+bEbLepO+uk7MK5Nd8HmRhJXXBN/5pxFuDtalQrhVAbrvWGGuATyfkkGqqfLiCts3MSxj4vKOvDfqSFjr2BqRppdJ2xVYcCGmcpmAzfSnIel7jkCWmDt9uwCIjZZ79yfI3uDIbh2/5lvf0xSzpe0rnFfybaUMaKPbL62QVubqQ/mhC/1fsZ2zP3QAcLk1BVowD+lk3+zJiqdX0RsyvE+kUErBXKzJTSNd5+vyT1fbxkBvXAXnidh0SrAl6aIRokNojui0LG+nu0YeqFUQvyAikx4ynk3xoFX8OBXzMAK5ZRrOhDUpd4iIBRIopeda/rr3lTUo/PZRIT6WYC1Ju2AXOSk2iU0AbaF7ym+BHwDpdDe3LMRP4axXOXbd5pBa/+JOYlheavH+XBNjx9nA0uWs829T9tB+1xhBke7kWEgHPuPfh5VGpYyseL16iwwtCzwCCwWH0DIVIY401kk9pg3ZdaQa7flw/n7FQYlauGJpyMS6ShaYM6Y/XTmv7MBne1rN5IcAyv7rJh/NFw9Xo/oXH2j/hfbO1uyJ+K81J8Pb0/FPamGLCPII2Qgy0UlCNqta3DwetDPhCKPVgeQUtlRlzZqwNi9BjYkoEixi0I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(478600001)(52116002)(6506007)(44832011)(4744005)(186003)(6486002)(38350700002)(26005)(6512007)(38100700002)(86362001)(6916009)(316002)(54906003)(1076003)(8676002)(66946007)(41300700001)(8936002)(66476007)(66556008)(5660300002)(4326008)(6666004)(2616005)(2906002)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?73OTJf/YeQXRggN5JxVOPZM4xDfMV4LRCPxE+xhDDyMezxrOS38pgZwk1+JC?=
 =?us-ascii?Q?komjchs+nSMifNRv93IH6qPsWGyAOwVHOnFuWXLQ+WcDgIJoGANDZpMWaCeA?=
 =?us-ascii?Q?AfM+5d1dMBZkeYdHzH6Cfo4mLnthLd4dtfkISAZRyGKZbwCTKf22obrtDA4+?=
 =?us-ascii?Q?+S5nYjlYugiqQovHilcrqzhmq60XY4ryp0CKC1blog3Q/vb8uEUwUhRy9D0M?=
 =?us-ascii?Q?Ufl4C91rsRgzfIHp3SJev/X5x/gRm5dfCjqVmUed2IIF5734v1bozXT3U31M?=
 =?us-ascii?Q?MLfl9qtzUiwLvnxw/sfiNoQdBJO9KqZ61FL7qWxcWR5Yq3w70hKy1k/It0rz?=
 =?us-ascii?Q?xsMEZ8MDClzThfmE62b9w067IGFPTyd9cQRnfBoZTwOjwc45PZJCoQghR6i4?=
 =?us-ascii?Q?mt3XoafAJDRP1GXDHq6bPyJ1kAnMiqEMP1wi8Oblz+VBA06M2PLhu3T5BVT7?=
 =?us-ascii?Q?vhztx664p6KnX7hZ8VzOvRXBlhbYYyjxoTOmPHn5/5KDcbCbHJ0treu5MIYo?=
 =?us-ascii?Q?WXbkBmk8vMgaYZmAxfgEvlw3NtVq8h63Ccvv0iD4yVUPWYRNnQ916xLmg51w?=
 =?us-ascii?Q?WrOcimsucbYltDsGLzxsS7DzWo8+GjD/IzBEE4rhaeJRCnJke5lyvL66k6BS?=
 =?us-ascii?Q?JrT7rSUPkecwJgbsyKUSiLG7ZoO37Kt6xHC9g4Lkna7CWn/+TVgUhqBi15kF?=
 =?us-ascii?Q?qIkMm8Hs1H6uD2gwpRZezxP775Eo3joPWuEJipOJIokhAhln48U57c4VA7+O?=
 =?us-ascii?Q?7SnfV89qBoY/NketEFEeKATYAMz10oqH0EGQqBYaFFYNtXXD6IdUT4D8Z4RX?=
 =?us-ascii?Q?Bm+lZ7xlNXn2RVuNqDU5sGuDrMV3hFYM9A2OR9RBO+o4W2vBFirJGgOpMI29?=
 =?us-ascii?Q?GSvmnpFtUiv1CsmeufEbGdYIBJVtEt6qTNmrqpJ6URigRA6HPPFVPEehkgT9?=
 =?us-ascii?Q?7/Sd2blCftPcNwywVhcg71rXDkOHqWqcbGid6q1UbtB84vATMBa8TQP9Yhoz?=
 =?us-ascii?Q?h0e8e/zZY51nodI7lZZoP9SRvyu4lGhGYyMWvQU8YgDiHkI+RcUZipXql5ly?=
 =?us-ascii?Q?abnOleNUPsl2tP2kqHMB4MDMdwqC0euKv0O6T0nqWrf+IhmougGTJ9+otnxe?=
 =?us-ascii?Q?NGr93luYDb14RhajMtdOvi7h+pWXxUMArpA/BS4Z20+qY93UtxWu4fH9Nytd?=
 =?us-ascii?Q?XvHwd5BXIkOHas9SgRR6MRP3HyUv5xiBYzzW7UDlw/XhaCJ7Omw77NsAgQDo?=
 =?us-ascii?Q?Xbr4NRHj+93l6dplD9ftKp2pIN6mctXGB00G8dP9HKNbK5iQhUTnwIxvwPN1?=
 =?us-ascii?Q?pnThAagBgFX6uZt8vTB0Mwfxjru9FPZLgIO90A0I8AeWjxm0ikCM6tbJ4Rf+?=
 =?us-ascii?Q?XARHK42RqrOnxLK/WsqwKCDzDMyqTYxzPxDYYaVBE5WL59Cn6o3ubJc7Svch?=
 =?us-ascii?Q?gfrDNB4fxIYi5J+x02PahXCk95HoavGw3gvbVJy7Eb0lsXRNHQhIMzO7Wv53?=
 =?us-ascii?Q?8QlrH4nLpHqv5R7/H6bpo4KTG0GfSLFu8r0RJx/UPVUgtWe3q7TW8p/ovsZA?=
 =?us-ascii?Q?xp5hFYZKP9emulZQxJgfEuEKtc7KLzB58A3QIcgLG4FFH8/vfqBypSk2ORQT?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a8fa63-8b2c-4316-3fdb-08da6675174c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 15:17:11.7082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euS2tmTPwK2iv6vdEYRnkKuY/jOFVGdfsSwxpg4hHj6a+a+BJk4uUhltZBqrxuCSVoUWburSM2rO5WYyOAYKVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4192
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this patch set fixes 2 issues with vlan_filtering_is_global switches.

Both are regressions introduced by refactoring commit d0004a020bb5
("net: dsa: remove the "dsa_to_port in a loop" antipattern from the
core"), which wasn't tested on a wide enough variety of switches.

Tested on the sja1105 driver.

Vladimir Oltean (2):
  net: dsa: fix dsa_port_vlan_filtering when global
  net: dsa: fix NULL pointer dereference in
    dsa_port_reset_vlan_filtering

 net/dsa/port.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
2.34.1

