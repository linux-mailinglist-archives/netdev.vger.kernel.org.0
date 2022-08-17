Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5E75969C6
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 08:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiHQGqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 02:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiHQGqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 02:46:52 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2113.outbound.protection.outlook.com [40.107.95.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9B15A2CE
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 23:46:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKuZ5pmej61NSv/AdWEkwkaBJcsoTZbIR5ME9Uz3WM0AzCYJa0HJUqo6pcir+0NOsengzTz3hzMAs4eeBqlaZndKsqx5XxHB1Mn10NfBk30f+RzXW9kjMtWUIHL/LJti0VnPKWhtdL+AinLaBkujoyJgI5rEx4u0C32G2sA8EZlMyNAdu47goT3aTcu2WSPSSh+sow4eJwjrfGG/O7ofYFB0rjbfa+xR76U/kNc37W6LQTaf8PrGspD/6c/mpScnTfjq5W+lvjGCiFm9TMtJrXbuoUx2jOhLfZsBIqw0+oIjpKmLuL8JWJeV7x8EI3q1WPOHLDh5A7iVKwg2mzLKVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCYtLvrNpRDEOslhMEdEmr4osFJUecAraqFhiXkRWJs=;
 b=GqybqdDd43H4M67kbXDK3ZkqKg3HloI/q2sgcMm0pIF7NdvkXPGHxy+5++/S/mFdR1bCdvaskPfvWMJU5Rt58OiMO7Ja9OWldLogSbWwy8N23cr11QGeM7hCNQJjeXWLMkRBud0W+kCA9Yhx3W4u/XdJRsxFfDqxSY0+yLzof15xOhp5v2wUUkig62zFaB0CeBv6oz8RZKytV/ppGn7vwh7JLQiYaIkYlgnkkH5DV815mfJxFAFlcVb2eur5G6kV8XXgvd8MkLfisO2itQvVMCBC9pf3RmyrtDQni+XPPg0MVJvR0cSNa5h3dAi9HBCyn69hgdo3Nn41PFLtC9m6rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCYtLvrNpRDEOslhMEdEmr4osFJUecAraqFhiXkRWJs=;
 b=Ed9Nnq0U520m8Fwkup5Ncvk28omNMCwy3iHtaWyTBXeIE7aO+UCNrcA+dxTMe/0zt3FUgVMHTUkRcuNv2GgObuTlnWeenXiO0SSnbs07bHQIFzt6xR1QecDB8zqL44i7SDdYkuefWVtA2GtvZ2LFXodpSMKcXHPrMobWW1GkQ40=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5085.namprd10.prod.outlook.com
 (2603:10b6:5:38c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 17 Aug
 2022 06:46:49 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 06:46:48 +0000
Date:   Tue, 16 Aug 2022 23:46:46 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net 6/8] net: mscc: ocelot: make struct
 ocelot_stat_layout array indexable
Message-ID: <YvyO1kjPKPQM0Zw8@euler>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
 <20220816135352.1431497-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816135352.1431497-7-vladimir.oltean@nxp.com>
X-ClientProxiedBy: MW4PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:303:b4::35) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9332ecc6-b847-4051-85b7-08da801c4255
X-MS-TrafficTypeDiagnostic: DS7PR10MB5085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e2eggxMV8DqLKIwKW4yu675ghH8t4AskbTO7spZP7kjuLNh77vUL+mDMSsa52fcySLbg4w969b5a462xoYL+iDRjLm6kwtG+eXVDZJLeTr2E0sVKVEvUM0J11RMdWBzu84yRdVPT8pwv8AlF0+CAxkV4U2iR5PzTsaNsCra5jIEhwBBvksl67mUwPunq4HL1mcEndLUSsJ4aX8L90e4rxf+QHr+cYFHWLEeZCu0xvUwoArwZABoncz+bhqmYzFFNoSK0XZlQycujDs6BLQpx39DtMrS40MdHKiKBdprJ1UZCn8NCZzIysvfwHuzSCBsnlHJ6n7RBUr9RMOx2z8c5914t0UH88MWlCN5//Jrgw1Mun2xCU+cCdjiYdOTh6b2s2I9TZ8sx36ApAUEZ4tsr+L8ZjEtHhKHIcvC4BA+p4J5qP2DLQpwvXpseitdjO9uBEbnYA4Qqsnm163iG7q/ZlHwV/J9noRWcvXN7SMskxI3a4tRBJREK/bMnaGTUosyK4XWrkuWNNnYAkmslhYcncvbXEgGqQzksFoAF95L4kYDvGIUMPbwS1YIta18T908ssc9ohURNNtB2FJWnCjr+fwirATr8inCkWhnifNzqVckvNQKI1ZG1Nqzoz8NfH533jv2rY57riCC7/eklWEMKOU7VnzMlmfzgxBxdxJb4OWxcoPGTdofe/S+iQ0NvRGL/rW8b+lbb/GE+brlE4yZi4FzmEeMXLvzvctRwuObWZRIPMo/RP79r21aeWbDqxufb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(346002)(396003)(376002)(136003)(39830400003)(66476007)(478600001)(6512007)(186003)(4326008)(6486002)(8936002)(66556008)(54906003)(5660300002)(7416002)(316002)(66946007)(8676002)(86362001)(26005)(83380400001)(44832011)(6506007)(2906002)(6916009)(38100700002)(33716001)(9686003)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LWXAZRkt0Z4G0gNadfsgq+CpN9tQyF141Be6zo3cHrp7+DAaK/iBbal1WNdP?=
 =?us-ascii?Q?fbmo3ughe53SWB53+RVIgCli2f1PkIyHng1s0NvARGQk4t+Rq2QTd+n8Wz0n?=
 =?us-ascii?Q?RqfjOvzUH7MwVenYY232FRBvljM21e/EcAUCdgUk0InT0BRu/wMsRWyMUht9?=
 =?us-ascii?Q?TJOjDDuPxVb2n12jH+MpOMnYOb/93FV+pnwyimntlpKp0WfTYKgAfChuPrKL?=
 =?us-ascii?Q?EnOrkCqXmRdc2255OyRA3xR7xyKmsC0q4AeKaAwF3C+XayBjziqlSoERGlD9?=
 =?us-ascii?Q?/ooPBdnSyEalTkNDql7XhGY1qh9ImCv8h5cQxowWuYF97h0imKzVjMfs4qhA?=
 =?us-ascii?Q?wr2KTomT82DHLDWidUmALIyOxZvp2raMiCk8Yk/J9RswRGf1rGuanuUfb0bq?=
 =?us-ascii?Q?5clUWyCQiZpfm8R7vbSmoVJjagodyFvK7WX39ujwjnGNWd0TEzAh4AHpt44m?=
 =?us-ascii?Q?53A8HSrw2BBkZUdTls5HQ6f2UDpsWiP/rmU+lFGJob0cJkB284PzhpcKYpPB?=
 =?us-ascii?Q?G4TbfA2tjU0AIsuyxkR/oilXWKL2fztHxUmoCkfEEfe3/72Uso2e4rUuRw/C?=
 =?us-ascii?Q?7aWrHiiW9L7iBtokwWPn8Y6DO0SKUHuWYw31dlRCCJhp1AZq12GBzJ8pev2v?=
 =?us-ascii?Q?LZhLZYHreemZb++cb1FvkrY4JAl0pKlm6Q3xOv/9+WutbTyFgaDjueUNB4sh?=
 =?us-ascii?Q?mufRp4zeo07+0X7IwK9fw5sW/uFLthEOr1IP1jNh2I6pAyuzz8wOBv9MvfSg?=
 =?us-ascii?Q?j1hFrsXdr4uXzeSDrc4mT17YPTRVpa5kWHpZooy7Ym40dfQ1tQa4D7AOpjuH?=
 =?us-ascii?Q?1smw6V7LqSPsVhq+2Je2BunIASHFI05hSncynkORi3M+zNu1bOvUcG/ayN3g?=
 =?us-ascii?Q?FrrWsTfLFppfD3ER48N62KRCI9DqmptSTh1g7gDL3RZvZ8k3XMQ/xlbbhzDx?=
 =?us-ascii?Q?RaQbQ7deGBL0423Uu4Sg4dddRm8QaaKl6JF27YufCN+29+gmNIXxZzO9cqLD?=
 =?us-ascii?Q?sFTWUVwsnIlyqdeKaBzz9sZmFM83ZKLJcwGJCRn0SlsZq5tOmVFDPSId1Kl3?=
 =?us-ascii?Q?64hSqaFWr/FMx4qQrjI8FZt4dU1+vEkNCfoV1NhVp3Svz9lNx2RQPlKBaLVk?=
 =?us-ascii?Q?1gPzO4m4fesWV/2ORYndymBOI1ApfEiaoe2/GkcEDPVfpmR3YZQuZvgPYPJl?=
 =?us-ascii?Q?Mj8mZRbI7n1Q2tMQCc03A03L2vLi6qDGmra/eFPsiJffq082VhVsJ1L9KKeJ?=
 =?us-ascii?Q?YnKRlaw3GVm+tKg93BNFi+/fJ+ZE2OKMi3lljupRwenU7ueTfz5Qp1i6uhRP?=
 =?us-ascii?Q?XyImqR4fBi24MXNDYdMJXZpGohDG/TUJCYtO/V2FVGCvVQO9BUUDJFaBoXz0?=
 =?us-ascii?Q?WUp8iFY4Nq0KvtqzJANdz9HnV5LvwBYeLLGjHPytiXmB1/+g/U9QXR5zwG/e?=
 =?us-ascii?Q?gPQuMVcGazoXhmCcwMCDzKXpl2gSe169RQm0eRq2unqOZ5fgtVzoDzmpAjPY?=
 =?us-ascii?Q?H8poRln7v8ymcCDrIPiMq7MZLXRibh6kkKHIdQ25ae2mW0xUCt12dowtTc5E?=
 =?us-ascii?Q?f/3VvlajiUhXoHYsF9pXVylkYe0/1Y7cYuxoiFAVvtrMSHd6HssovujUriNY?=
 =?us-ascii?Q?7k/AG5SNYbJgK/4wBgqIXgI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9332ecc6-b847-4051-85b7-08da801c4255
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 06:46:48.8249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nbXwtGsNXRAqKFeH8OW6ThyqgYzLI5rev8mM+jeGfk1Cuqy7/9dwcjgK8H+v+E3y/uuWxZJHtwr1WCTQ8Na4qbmTwNXYk99tM8QLLuqYBaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5085
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 04:53:50PM +0300, Vladimir Oltean wrote:
> The ocelot counters are 32-bit and require periodic reading, every 2
> seconds, by ocelot_port_update_stats(), so that wraparounds are
> detected.
> 
> Currently, the counters reported by ocelot_get_stats64() come from the
> 32-bit hardware counters directly, rather than from the 64-bit
> accumulated ocelot->stats, and this is a problem for their integrity.
> 
> The strategy is to make ocelot_get_stats64() able to cherry-pick
> individual stats from ocelot->stats the way in which it currently reads
> them out from SYS_COUNT_* registers. But currently it can't, because
> ocelot->stats is an opaque u64 array that's used only to feed data into
> ethtool -S.
> 
> To solve that problem, we need to make ocelot->stats indexable, and
> associate each element with an element of struct ocelot_stat_layout used
> by ethtool -S.
> 
> This makes ocelot_stat_layout a fat (and possibly sparse) array, so we
> need to change the way in which we access it. We no longer need
> OCELOT_STAT_END as a sentinel, because we know the array's size
> (OCELOT_NUM_STATS). We just need to skip the array elements that were
> left unpopulated for the switch revision (ocelot, felix, seville).

Hi Vladimir,

I'm not sure if this is an issue here, and I'm not sure it will ever
be... ocelot_stat_layout as you know relies on consecutive register
addresses to be most efficient. This was indirectly enforced by
*_stats_layout[] always being laid out in ascending order.

If the order of ocelot_stat doesn't match each device's register
offset order, there'll be unnecessary overhead. I tried to test
this just now, but I'll have to deal with a few conflicts that I won't
be able to get to immediately.

Do you see this as a potential issue in the future? Or do you expect all
hardware is simliar enough that they'll all be ordered the same?

Or, because I'm the lucky one running on a slow SPI bus, this will be my
problem to monitor and fix if need be :)

