Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125C868A32C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 20:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbjBCTny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 14:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjBCTnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 14:43:52 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2097.outbound.protection.outlook.com [40.107.102.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BE29DCB3
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 11:43:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLWXPVyurDIM2zC15MKQhqGfkqJ5FDnK9n/aJYp3oZxtA/mA8HaFOQi3xSQDQySR/AJ0nuvB73RuJ3jEURd9OM6R2txWSlRANri1flYhYZylkNoz5DO7McWoqtRy8rkyQMhJdpFf8rMgEAnvD4TjiYN97F78OZBVmIYDfVbShCmAJ28DKC8vxByORnwoHbvJcnpcCfHhiEBmmgskcb8RxZ1nPWmVuxrImPPjRRVOCP2zW7krpbZZ3fofRRImyi0EGI+dHFlMu0Ux/BesjcoocBbDWeBpsP29CEZgtGERZOWGw2Gx97Yv2q55o9gfdWKLStlmWLK5bYcRJUBBtEvn4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5fHwONSKT12aAXuU4xydZRRrb768KnbAVFbLbkEVgM=;
 b=LSOmghUix8zH2l7RsCZBvaoYjVPM4g6KH/H0BfeBfevv8kUHr+UfG0Ohi5roVdPwL+DaxFS6T5IlOP/BUYTtfkWpd97X+7ZKS2iEJ+SVhSsdHdBNJQV6CyAMosOBT2lKdLr2XTMrpQB2frv00lFxBrujrM7kyPO2RRBekhEQFVUmcCOeYi4frwimapJA2ZaYVofk+lhqTm4PMXc/97OtQ2YoJVtp3G0OcoEx7J83m+SrN7sg/3yKrZL7hp2yA2QzaUc6Pe6ROHOzSFnnod8oODoYuIymdgyT+zbJ8skJg1whgdBYcBjlDlCzgPLWI155YRe10BUkdfOr6sAD96sUSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5fHwONSKT12aAXuU4xydZRRrb768KnbAVFbLbkEVgM=;
 b=oRyu6C3zUNLW2FFs7f+FEEcUHtdIAfI/mwhAWoHRwNls834+1mO92unX3EuWWDcOqvRA4JreX+VQRY6HPAHfaf13fdoKfXea2WbVLL1Fg71AypnB3CMDZ0uk3VYYKfgWUZYWEhY+TaQlmlQDDhgXONP89TfSXgJakkei+tAJbFw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 19:43:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 19:43:42 +0000
Date:   Fri, 3 Feb 2023 20:43:35 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: use NL_SET_ERR_MSG_WEAK_MOD() more
 consistently
Message-ID: <Y91j58bzciTCqjJX@corigine.com>
References: <20230202140354.3158129-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202140354.3158129-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR01CA0074.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 0850e579-6978-438d-7a5b-08db061ef409
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNRu+4W7NhCRmbP6WgDtT2GypEKIBK9rzhns6bAyLk9tuHonqQ4ABLDVxmvnPX8IND8lJ4fumDpEvTK4+/jErlLQCtLlqxQbto4QlGx8VDN9+eWXpeESqjpTsgSK8UCHxSSUB2JxJAP17pglcF7hg1laipT13zWXBd+d/bB4law3iKk/fGeNQf40K9rTrtwTSLw9/SL9KX4ybVweo7O/kJubel2jOaxlcTggCOmQoQLvJftD/bZx+MdQZxAXSaDTKU225dFJp0J3u/Bait1KSP4xk97qD2JypeNDg+7Lrw5zUbT9Xa+Q5h6MQu8+f1Pv7bUn6jWvu7lsggNWAnW4cnNqheqc9E/2TlHxmZs4rqZse+X5zGJHD8aTxRfZj8afP3Ejx2zIIr3KPvqLfAhHDmgXjM6fQECUEXGCiUUjtQM4jwopgvzd0V87SHgST6tsltRlYzV+xd9a7k6x+CrUxOAMPR93/DRbo667jeteAs4nJ6AW7XjsxcRmECkqUj7lsFsuiw0db7NlEgjFnl2f3SDsJmzgcgtebYH9TtiOUSTRoS1ROD5dRWBeZgvonKJ2M3/6BpxbzCeFBuYCZZmE3VxltbYx0L5KV/TXEUilpsVzdkHz9k6+e5NdPfIxTY45aBlGtN9cJsDyVmB2fWfFJP/5MTLIubUHz8+PR9Zk/7mcYkwVHFCJX93ME2yteIH6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(39840400004)(396003)(376002)(451199018)(2616005)(38100700002)(83380400001)(6512007)(36756003)(6486002)(478600001)(186003)(86362001)(6506007)(6666004)(8676002)(316002)(54906003)(66556008)(66476007)(66946007)(6916009)(4326008)(41300700001)(8936002)(5660300002)(4744005)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?frnXvwEiQvrQAvgSxYUQNBT8W2atk6vkbZI+tzGFZZb4lBShrVFxBNtiK3gR?=
 =?us-ascii?Q?A9twoO/7/UyebgZL2CSPvUjjEiV+RPXP/vGKtL9mPj+k3YNI6H21s0WIAPv6?=
 =?us-ascii?Q?qcf7cDCntkHTje5KULL2gROvOltMBrWSHK1oKbDpBn3P5OB2W46IY9uBKBKh?=
 =?us-ascii?Q?vqurrQ53A3rmEwEQbtKD6xdDKirZRxVtEbSeFgxhd8Bl7UMl0mNdlFMWnCYh?=
 =?us-ascii?Q?i72p4/Z7XoQDQ//mCOeHkEPLBswF0OfnOQWuLnybhgemMmyiM41y7b+qsD4o?=
 =?us-ascii?Q?WXsx+HW+Pr3nuMvMEnQp/M/6oZwSOQqyjqFzNfhOxBVmhiIAZwx6CbMJjhYM?=
 =?us-ascii?Q?BEs4EClWoigYMFSWl/Trf41CpivU76WydDX6KLh1IccyIE4KDsKbfuFfXU+q?=
 =?us-ascii?Q?gRel94OsYI9thFBGdzEV3OoVSawjxQPqvBm6Z+F6ZZ+Dth0WNthHLLB1MAh2?=
 =?us-ascii?Q?qaflGaRTajAphurAz6OZYMJpo+Uus8Vp+x1EwrLiOO9Q43gl4izo+GXv7vhx?=
 =?us-ascii?Q?zw/1U+w6Tu9lI9fiLTBTtMj8OH78+fH/EvZ7GcNNptH6OqeFcKxyvOLBbily?=
 =?us-ascii?Q?HELAyJ+exP0xYMyjTksgGG5KMbt2SRPTH7uIRAU0dNEIzDINREUvSmEWDcio?=
 =?us-ascii?Q?fBq36iLo0W0G52lKCzUZwL5RmA4MtUIrA9OoCgMiGt+0jKXcc3Ao97PNcttW?=
 =?us-ascii?Q?4GJBZNbcvNP7IflbzMIUvy0vhRFfGh7Dwev4rNMME9T2Cm5odiFzm1MPZgbh?=
 =?us-ascii?Q?SRciy73GqJJ+7aBlF9KZeRe2Illzk63+KDWpn4LzM/VI6Ah9pgV5CTyxLlM2?=
 =?us-ascii?Q?RKjTl4pXq7kbWmdCVEjLyRYSCoFElw3NrxxWIVz1APOGx5eKOGoU7lMpzV3J?=
 =?us-ascii?Q?wLVuKi/xdNoK9+Z8a1YDSHRp64tPPkYL7kja96UWsG6nZwQTHnlT54VOH97j?=
 =?us-ascii?Q?7mSVYZLVWh5UtKEfALe6hv46odyTxtwFjV7U5A1b4KB7wD3IyF9Jgdyk7s6S?=
 =?us-ascii?Q?kGFVAXyDqeAn0t79JGCY3QJXq5uyDvKCP3zYM7imnDFWC17LbM1zCWHMXweC?=
 =?us-ascii?Q?5tBz5bSR/eo8Ri7hS2R7v3L9A6j5vymvfMEfv/RSCAW7IOXwZDyMENVOclXb?=
 =?us-ascii?Q?9BL+BhSj0Pt32oykX9GofuXlNYBkbULOONU/KU2ZZZvEVqWVXi2Uj10uvQxn?=
 =?us-ascii?Q?Qtz2vuUgmWpGd9Mh8RvxZCB/WLsZLuIb5LVOaqIvkzyL3lgEl2Y/Pk/VaAp1?=
 =?us-ascii?Q?Wpec6XEOU8AYBHuh42IEQ4YiENJZz8ODIekT5kUK/0yPrENCz6ao2JvnQI8o?=
 =?us-ascii?Q?Yk85KKMPWJ/GktPvLXifbsy/KkrCC8K8ymYI464ldzVIAgvqQ0fU3bBpQxQ7?=
 =?us-ascii?Q?TC0DRaDqztTQ5p487ym8NjfcJ2sYnMeZX+gjq3ok9DlNKHoDyKGojva6KeWo?=
 =?us-ascii?Q?76/xfuBHC4wU01b/eBs3BywiXD8G6ztJs+Pp2pJk8cg9iNovQiP3/SEcMpFt?=
 =?us-ascii?Q?7/n7FU1pBNET5bmshrrt2EDQwajWWdXGjPD2FG/b2X5hb7+ujB41sbmd3eJi?=
 =?us-ascii?Q?sYkXLMpPGeUndpzuzjW1t840TjUwci/l1xBMUmC7ER7l7VzgbN1td2b3aLWQ?=
 =?us-ascii?Q?3WuPGzrKI+v+3hbaotr8swIXsiiFKoL6ltnM4dywvMMdiNwa85KgWMUpNRv4?=
 =?us-ascii?Q?r1ZOuA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0850e579-6978-438d-7a5b-08db061ef409
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 19:43:42.0010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zpV43yOUHOZ3IU7jTqMACP8ZOKdBKgIlTOiY/jpoeW2TOz3dzAkq98Zfne988tbs9f08NHUjodQ6H04DaBB2+IsiE2YHuvwkeh8km3wpbyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4834
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 04:03:54PM +0200, Vladimir Oltean wrote:
> Now that commit 028fb19c6ba7 ("netlink: provide an ability to set
> default extack message") provides a weak function that doesn't override
> an existing extack message provided by the driver, it makes sense to use
> it also for LAG and HSR offloading, not just for bridge offloading.
> 
> Also consistently put the message string on a separate line, to reduce
> line length from 92 to 84 characters.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

