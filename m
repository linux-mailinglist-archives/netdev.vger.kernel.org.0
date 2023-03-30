Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4CE6D0752
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjC3NwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjC3NwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:52:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2129.outbound.protection.outlook.com [40.107.223.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269A55266
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:52:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6wCratNLf+nC0jrTowjOgp5zErwbFxaCJDARCQM+nko9fWeXy4fw1H6Dwk3VaRcNV+29tUwezafDKrFVy7cn4MvoPr8UO+gsuO8QnSStw0MjWkIVglUEOrFjO2AFKxj19JWCjTQ6rqkXgU4ayO8OAnlRJvOoXSd2OQQCgSFBe4UU/KLHZBIkeWUtBPeA6uQkac+mzggjx9lw/+ybcbRANXUz3KDgI5tntMyO2a2hpnIsReEX7TDx8AXTZi5uzfmGgrTbFbufUUfwJq+LqTcMn5cViayPWr6BBJFJ8i1GjW4Cu6hXYdDU0gIj0NTM4bb8pLjC6qQ3hwLRwi55DaFyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0vcW/XmHFh42heHRSnLby17oQY3A7GsPUazqEAyXy4=;
 b=G4kLMqTsAhyV3Ih7PsfLGDjeN66t7tkAruZIrOlrQ497LfY9VJlASFi6lqTU3gjAYnWOefGomWXnodPzgvnrzC5J2VLgQefH7U6bfPXiLXAHJoqesdaokKG3sX2T/o7ksyGEVdzS2yIArDsD+4rex2rsRhyiR7vdsrTfYjcu/aLUYwmlgPJ1W1IuiW31a/lv+QRJPOnmNAn/lM/Q/AOW+fxUgCryIwJ7d1BTsbKd4M58y91shoy//DDtWh5cCOSz+WbM4S92sfVYXEzlKzyAl4H5xjGGEANXupwgQ4kEKlaaAqShmhRO13ZmPjqgdwA/kL3rwiHsigF7qZkPqRVAdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0vcW/XmHFh42heHRSnLby17oQY3A7GsPUazqEAyXy4=;
 b=uqZ8Xc+/C/RD566/gLDykhNGsxuAvj801HiLYAMfddIGjWMH0pKi3vk47GzoPyD30l3oF3hChMhwsauTC6BfSzc9lEFNZgT1sBNZUot6HiEh3qFC6pdM/887m7QtV9cYybVBWV5zFt3lujJVANb3OX8Goo8A9LTgiOaXEL7PnHc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4863.namprd13.prod.outlook.com (2603:10b6:806:1a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 13:52:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 13:52:20 +0000
Date:   Thu, 30 Mar 2023 15:52:14 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] net: dsa: sync unicast and multicast addresses for
 VLAN filters too
Message-ID: <ZCWUDm3UyQmGKUSl@corigine.com>
References: <20230329151821.745752-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329151821.745752-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b82973c-5107-4586-65b6-08db3125fb34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EsHixP/4eSU3xjK6lP8ka2OLKc3RduvcJkMoQkSGNXxh+vMUK5nbxmkYvQ8QXAXzhZrdNmkSzI6aB6danMSRfzg7MCJ80SH/RrRXR8epe6ptE2eWGcZBH6z27zjXsXw6AvzDZAMd23OI/8nNJoCcb2wv7sjAL7Buu51LORGzKOVwNaEJ98Ay7th6MX4Hn1ZQDF2Zo5BvhLTA9qTMziWcPkewvKJ4anrPjJvulTpJJ5FdijCpnWVajHHc2tb11BeARAOeR6xJUXq0b71K/9FEx05sp1W0yAc7Q7gjVJDOhS0Pr5t3ktONwzmfIgKY2S6zkL8YRBLSwww8RLtcpCdXd0D6Wm+Q9L1wKPCZx5oBOybFyQVFwinqR8vr+eo7jzQdf9sjo03TI/Zvndp3zgF/qdFew1COKx/IoxrUUYslDHFF4GUcCmt8iGQC73WJoZSABSqfkMhn11+t+RuQuHYRWWCjFjZPvQf69WEtuVcRIyaXesZIfBwhowRIdR2hFIj1MRAhBB3AHN/OalDm1qLuP3YeEnQjdzgS5rdAVTjWSb/38vZ3f3WcksSKeBTVijibu+R37gVY2CeyDoJXLkByG0XVin8LGOmkjo27P9j1ts8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(376002)(136003)(39840400004)(451199021)(36756003)(86362001)(2906002)(6666004)(2616005)(6512007)(478600001)(83380400001)(6506007)(6916009)(4326008)(66946007)(54906003)(66556008)(316002)(8936002)(41300700001)(8676002)(6486002)(186003)(66476007)(38100700002)(44832011)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xusZHJCl5cAK424MaX/ssDInY2q6Rpv+6bwrtT0SRD/5yyk/HxZX+sXyRFUE?=
 =?us-ascii?Q?E0+mYNIDQuhIzMGcJZnLc5aFNm7CJJp/N61sC6ysoxuZe/FvM7TaoaKagfHE?=
 =?us-ascii?Q?EfKirh6+EkWOt921QhXMqtZPWErF4HT2fEGuu0MWWe1peOWcz9fjd6hxqzSz?=
 =?us-ascii?Q?65z1WYQeYen816j8LMwoDakpIK4Dt/sFpndqJNQ+IofrwvOcV+bUoeNTbn/e?=
 =?us-ascii?Q?wZ/BHpdSh/0sLAC0Hu/kzZfDuqM0h41ebFwhl9aFSBP/FPvDPzMyF9gbxdv9?=
 =?us-ascii?Q?Gq3ky8IJSu7/Pnog0dCfmDzuYkZGNo5fK5BToRB/v5REVUiUfzJn+vdexBJo?=
 =?us-ascii?Q?qvVAI1Gn0ynTJRILDbtmLge0sifjgTe2hvp0E3QgEYoulcmRpQPDLp/rTLxc?=
 =?us-ascii?Q?tniTTMaZkF9dwOdxE12tUzeoChsKBXZeo9c1Jgx7ZyQihUpKg2XAvcyyiE0c?=
 =?us-ascii?Q?y0tmelusUB5xKqNKX5SsMcwIiQ6FD6D5uaugezSvVHNhN/TqPt/ySf6Ch60g?=
 =?us-ascii?Q?P2oRBnd0gl757QmW+YL+IXdwqtt43FnBlUzdOhLplIC9ag1MG6QqJQgEb7RQ?=
 =?us-ascii?Q?1gyp2nZSjYwFEBxiyzpdeJeOh8QrrNYxy1QpuTZCtat2nWTr7OKHHb2/rXrM?=
 =?us-ascii?Q?/lT1vK4LTrLIDWx2GL5PPTHGhGIQ6PaNlGduiSq2KHBu04DEP8bQaiEva2Dq?=
 =?us-ascii?Q?UMhS/OH37hmoQG/k8yAgoMU0n6nLxSNXE2H77+Qqo7lcjqqC3pkx30U1DHoa?=
 =?us-ascii?Q?2vf7RsTlZSXENbo+iZOOVNhcUV92CfNowx/SER25iIJlPjOi8wGv7Qud5nvi?=
 =?us-ascii?Q?q1hRTf8hiGCvYKwcNK+6DYLXcHi84r/6NUDyAxt1C+9Z05FMnOUDWw4V5ddf?=
 =?us-ascii?Q?kyn8dwFFaDVfdNPjd7NiDzHW3sdul/ppFFJthFOl4pwHvjP6njCXzxLWByp+?=
 =?us-ascii?Q?59moUYuVuUK3orhH27spGoEuFc6ZmRCqjFCJouHnjUdac0DEN2ooscjAnvr4?=
 =?us-ascii?Q?0OC+7hqUUUkORJ48+EpY3CF0lYLjT6zb232Wbq/li5HaozPDM2WKrhfxxujI?=
 =?us-ascii?Q?EurAKYibsQitI5EmiK8u1WF+ZGtAMEvCHZVv61e/IX3pu7Wg6tSeH37cyNzk?=
 =?us-ascii?Q?sUHFkhWy17uZ+uLxqe6OKf07afr6sgb2vsHIMbswU2DcPMbAOhP0enhv3NzM?=
 =?us-ascii?Q?zR9d9phMe6gs/s0+ZPuxRXiTFKSlpbHqmV7oxbK0jRM+UV4fj5/f1UXrEmhn?=
 =?us-ascii?Q?LOjreWqjxiYR8E5PtMHu3Aq2Zz+edXg7FbHm2GMrB/4NEHZS6YnWRv1FSDtV?=
 =?us-ascii?Q?KTe3Sn8GqdZYPkw+Jj1FTBBzTJNiBOb5JRtSgu5x44G6Wo208ZVWjM6v4hA9?=
 =?us-ascii?Q?yOkVAijX1h5/lmIc28B303n97iLWfX7KejXpdL4/IQUSxTwMDPC9f+SK39f7?=
 =?us-ascii?Q?K9iESH9lBMEuc6u9dywccYWuf5Kn2uV4Cp71SovFlC9F3XUEiQmX25EsGXL9?=
 =?us-ascii?Q?F0lSa2TEjO7EjJrkXYRVLvzmTWgC5Sx5AiEUVR01EqI7k09IElQuAt49d7se?=
 =?us-ascii?Q?NzvKFZ3SUupW3d3/OWi97+WlCjup+FsQZ2h+bfCAyB8RNNQDAJvn1gBCEvM5?=
 =?us-ascii?Q?pX1ujHGVPld8IWV6yATf+ThvTVyD8yjunKDsBUa8LKr/5uYoFJ8ZVoYCuVqj?=
 =?us-ascii?Q?hSGo8g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b82973c-5107-4586-65b6-08db3125fb34
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 13:52:20.3339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DS9Xli4B2J6byBiC6CAviymHcpj2YkQ5oKGMqRyhwpgvy0rSAcMpObZw/a6t0IaqPqEdkz6Cj5TeQUAAy+wTt/q0QJntQklROQYQWsiIS+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4863
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 06:18:21PM +0300, Vladimir Oltean wrote:
> If certain conditions are met, DSA can install all necessary MAC
> addresses on the CPU ports as FDB entries and disable flooding towards
> the CPU (we call this RX filtering).
> 
> There is one corner case where this does not work.
> 
> ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
> ip link set swp0 master br0 && ip link set swp0 up
> ip link add link swp0 name swp0.100 type vlan id 100
> ip link set swp0.100 up && ip addr add 192.168.100.1/24 dev swp0.100
> 
> Traffic through swp0.100 is broken, because the bridge turns on VLAN
> filtering in the swp0 port (causing RX packets to be classified to the
> FDB database corresponding to the VID from their 802.1Q header), and
> although the 8021q module does call dev_uc_add() towards the real
> device, that API is VLAN-unaware, so it only contains the MAC address,
> not the VID; and DSA's current implementation of ndo_set_rx_mode() is
> only for VID 0 (corresponding to FDB entries which are installed in an
> FDB database which is only hit when the port is VLAN-unaware).
> 
> It's interesting to understand why the bridge does not turn on
> IFF_PROMISC for its swp0 bridge port, and it may appear at first glance
> that this is a regression caused by the logic in commit 2796d0c648c9
> ("bridge: Automatically manage port promiscuous mode."). After all,
> a bridge port needs to have IFF_PROMISC by its very nature - it needs to
> receive and forward frames with a MAC DA different from the bridge
> ports' MAC addresses.
> 
> While that may be true, when the bridge is VLAN-aware *and* it has a
> single port, there is no real reason to enable promiscuity even if that
> is an automatic port, with flooding and learning (there is nowhere for
> packets to go except to the BR_FDB_LOCAL entries), and this is how the
> corner case appears. Adding a second automatic interface to the bridge
> would make swp0 promisc as well, and would mask the corner case.
> 
> Given the dev_uc_add() / ndo_set_rx_mode() API is what it is (it doesn't
> pass a VLAN ID), the only way to address that problem is to install host
> FDB entries for the cartesian product of RX filtering MAC addresses and
> VLAN RX filters.
> 
> Fixes: 7569459a52c9 ("net: dsa: manage flooding on the CPU ports")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

There is a lot of boilerplate in these code-paths.
But ok.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
