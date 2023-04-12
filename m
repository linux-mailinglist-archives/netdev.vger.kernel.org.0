Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5446DF7BF
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjDLNxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjDLNxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:53:47 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::60e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BDD6592
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:53:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dju6c62u7THjdo0/MhoDqyiYeUfVIRY17/yVYMTDLppXRCij0i4akPa11lT1Ry9V1YYC4p4AdnjsSQ/EfaDor5t3tI/OozfXHHTu88jue73C4E5UR83ot+q7a7TbYjl+QxsagypOU5xplpIj/S0lpoLkglNtadUywJiarFDyZXIi66iDrszXEVju3BgPWgbJ0j4s0QVuqyxwSQvIhWBBkuJ8axzDHUyGEWovKCKHWUsld0zm8COaKSMEVKqFkCQbpf/ulfLKMvhkRddtU6vXzjX4hywL2Lfm8x/Ghaya3JTuEBr9HEQKVJcS/lPKv2At0H10RI8JNJc9KeQwNZ7DzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLkKQ2uoq7HKFjDUXcvlSps9fFJto3g9cOTEDt8N4Zw=;
 b=jGH8ZYNs+HVcf82Goiqoc6CtG00wQDasT6odcdnxecL+BIDGz9DPqZbhbnV/BLDwYmga+br9oWWbZ9dgS5r9FSarlYMfKaDSJ8uIXmTYphJWsZyAWEHCgvBtE083QlIMukCyZU87aYKnKv9iZkHpMFI/Kmalbj2E0k+yb2aixWmowCRG4rlhX+oTysXEUGBxIB0Q7fATzaDn2ivfjCsSBYyy4T1BKi5Cm4fBRvV7bD0rYAVumMFoFbMGEU8FhUOqITMdkaz9kBI6nvmNXvvGGO3EUXBvvI65s8/qldUKHicsmm2prP1ftC2a1Ps8j0oGbXL6mKL+7UcJ/BCbOU8b+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLkKQ2uoq7HKFjDUXcvlSps9fFJto3g9cOTEDt8N4Zw=;
 b=WTQpRS/YldM79lbVuh8RnoASFZ1qaR7hpvegMBk+dl2E9L1+VS/z+NXxzp+OX0PqOVsSFx0CgeIu/E6j4fixVHWxOoJWUV2fMmoHaIBMOnHIEVbFMW79hjfhAR42G0LChgXbFOvYPsecHHm8bdrOqgo5fqPhaimOhsurl/QCme0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8460.eurprd04.prod.outlook.com (2603:10a6:102:1db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 13:53:40 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 13:53:40 +0000
Date:   Wed, 12 Apr 2023 16:53:37 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v3 net] net: ipv4/ipv6 addrconf: call
 igmp{,6}_group_dropped() while dev is still up
Message-ID: <20230412135337.hp6jxne6lkl2r2ud@skbuf>
References: <20230411144955.1604591-1-vladimir.oltean@nxp.com>
 <ZDazSM5UsPPjQuKr@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDazSM5UsPPjQuKr@shredder>
X-ClientProxiedBy: VI1PR07CA0179.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::27) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8460:EE_
X-MS-Office365-Filtering-Correlation-Id: 2caed2fe-e2ea-4f55-4e4f-08db3b5d5288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gtsBRadjHJr5k0BOt2709DzWepK+yh+FA7xRUh8aRBK3kPGDcAhAPEt9uVBlWvxNdsyw5Bzs4bSJhxWyZjAczngq8uqqsxJTfL6dAxu01sz+z9Utr8yWPTS0pgAQqezyIh+TaWGmlwPXP975ZU2vAREfAUMqaR1RjBdNFWu/rzF48nMwdVNvWlFmHhmzROcEDDd0XrKSZnzxdiweGECeDREKFYPQTNM626FbsTqGSFcmA0yJ20ZRZ0es8BpCcl9TEF2YD+4c0XcHkuYjyWTXSjhDdeQZqS4oDFgQqRli7vN/a5oh3jZq9WRc/spRLncKzufH7eMNQv4PTH6QnY0VG597ZnrpN/Jz1LIvuffe2pfaMNvem3tzSXR/wuVRY1zQ3qdXMGPXPbq72H4tpTT8Y7tFRHdmbwLGWASgQSn6FgWfmHR6u0gZesX1g0GeXFnc8DVPf8LuvF9WMd/2wbjVIECGczQocew1ZeBPgJrZqUKyICciU9P2akpDHu97vFiVKhj/YExPl7HTL5u2BX1h04bcrPr4R/s5zrzNbq+s3z78qJLaz1XlgaTbSEkx5z9S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199021)(5660300002)(44832011)(33716001)(6486002)(8936002)(9686003)(6512007)(6506007)(6666004)(2906002)(26005)(1076003)(186003)(38100700002)(86362001)(478600001)(41300700001)(6916009)(66946007)(66556008)(66899021)(4326008)(8676002)(66476007)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E+92lmddbReaeZD56sELn7PMADc+GNjiaO55FKnR5cK0kiCIPlO2D+5qbeFy?=
 =?us-ascii?Q?l6xEOQvsevYofpuMUuDbt+RCcGoSy4BvUu+vXYXIxvPb4aZZDcv4h6XQMwVN?=
 =?us-ascii?Q?a6GOmZY/ZZD/aDKXAueIRhsRKEcvx/3mwET090YC6RwdSHnpIXjHmhDVzm6L?=
 =?us-ascii?Q?RrlRFV8hdBfOg945YCYo48LsLPg5QpmsFf3UCyxQg7PLqetLhp25Zbs9/Ir2?=
 =?us-ascii?Q?zywz4zZLhKCd00eKTfUlnazEiZHsytV320BHXHMY/3wdjq8iotGij/geGPou?=
 =?us-ascii?Q?gqcZhj1kXDn8nQJwTN3qt0zAz2JxCFAMhQFCRjhlyKUzKRCfEcSYV/L2eA/b?=
 =?us-ascii?Q?MulPK/dmsnzEkW2pyiVBdFtXiVfZUY6HBEw0j6h3tbGuxGkVclYhrYlO4AAQ?=
 =?us-ascii?Q?BJk+T5GP3VB6zw/Es8tjXKAhh4xvlGRqkEiOmHGyN650CA8yb+rmlSVh/lA1?=
 =?us-ascii?Q?gXLUcLU0Swkxhobc13lvnirVGH6wNqMCSpApUBIFTYd4iO7STHAA+iLJCS5X?=
 =?us-ascii?Q?PLFGH3QbIEx0uJZtyJVQyNL61JMq5l0vcijff6OQEsj17MNw7J3zoXlMPziM?=
 =?us-ascii?Q?DORfg5jGKI3YHlo+6riM56pIPNO5YhM/070rd2sSOIQJLfL6zkah6j5dT45K?=
 =?us-ascii?Q?xm8SROreJT/+iYiGMRZFizHVfP9PwlGkRgjviPRyUIge8sD3b3AfJB/fY89s?=
 =?us-ascii?Q?hgfAtIaklQ7qCqi+8j4eCygW6TtLbCbRslWz+H9Nf/t+oruVuOOu1q8VrzaQ?=
 =?us-ascii?Q?+b4DMR3iP9p8lTmP/ZlF7YgmT14jeUW3xB1hP5E6YYCJ46gVb2++cs0WTHGM?=
 =?us-ascii?Q?hdfs0RItP0kDK6NUnL/56+o0O+vvAKHI/vyJH1IA2BfKHVRscMmqHUxgypzw?=
 =?us-ascii?Q?f5/N1Y5VYrT10kYB+N58dibzmreqM7r463k0YIGCYG3wzAeX9Y8YBgSHyhun?=
 =?us-ascii?Q?JkeULMVO/WoLsokyjWaKfCQxl5Z0X7MRqwi+SZY9UqWH+9W4NMVNTWL0Pb+a?=
 =?us-ascii?Q?glK+DrAoRRHcdCOFOabPwkiWfuvU2wG6ODtB5HYOinMvWYFNucO7KfOEOZTe?=
 =?us-ascii?Q?UM7EQmF/yGtvySJb+UUGZNPQcz6WRvj3k4GdIuyhm5SZPk2oxk/0aj0aijrP?=
 =?us-ascii?Q?C7GRzTeCFt35KrbSNHjcO8mXqgDmjl7k5fQq9QVBXPEG3s8Dx/oLhZE0j5xN?=
 =?us-ascii?Q?Nf4NV1qBF+4uxiFRidhPmo7HooFmokd5lEJ7FAIIaRCFtbquodmKO2TmyIOJ?=
 =?us-ascii?Q?7s89sGiyGLyEPeD/m0hyFogrSYRO8+zmIgoOZJ7JCTnSgaDBqQ2J30OhXg5v?=
 =?us-ascii?Q?vtNc+VV1sHcI35xAC1lnPLZH35qTRPw07gy6iQYQBlSPsHyyEF0xCFqM0fxS?=
 =?us-ascii?Q?j3080xmDWX8suE945g6aqN1Ii341p3ptqHQd+QvMQV4JYIrean8giWff9GCo?=
 =?us-ascii?Q?XVV8e1ElxPjis4zWRdAwA2or32ieKoJ+kxZTnH/GRM0BRRvFZi1kqRSVeX33?=
 =?us-ascii?Q?LdNvpiK8VqBjo7j1aGQbVjQSZPxvI4c0BQdSFr4EDWMh/4tVO/RwnEmSqUUa?=
 =?us-ascii?Q?D/LL/ashKASr3iy/nVCgCtS5qns+5/0clqDG93iTugpIgSfx8s+fU3bFHbfp?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2caed2fe-e2ea-4f55-4e4f-08db3b5d5288
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 13:53:40.7128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9h5UogUaok8GWGO6TpzkRb6ofSu4d/YCvg6fzQq0XUKwOHxfmJzoSKSMSO2C+pY+6j+F/U7Mwci/Vxxr0W3uSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8460
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 04:34:00PM +0300, Ido Schimmel wrote:
> Even with the proposed fix, wouldn't you get the same leak with the
> following reproducer?
> 
> ip link set dev swp0 up
> bridge fdb add 01:02:03:04:05:06 dev swp0 self local
> ip link set dev swp0 down
> echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
> 
> If so, I wonder how other drivers that allocate memory in their
> ndo_set_rx_mode() deal with this problem. I would imagine that they
> flush the addresses in their ndo_stop() or as part of device dismantle.

Hmm, yeah, fair. I was operating on the premise that callers of
dev_mc_add()/dev_mc_del() would be sane enough to keep track of their
calls, and at least aspire to not leave something behind. Clearly not the
case here, if user space can add a unicast/multicast filter and run...

So I guess I'm left to clean up the stale addresses at DSA removal time,
and remove the WARN_ON().

Actually, looking at ndo_dflt_fdb_add() and ndo_dflt_fdb_del() again,
what concerns me more is this:

	if (is_unicast_ether_addr(addr) || is_link_local_ether_addr(addr))
		err = dev_uc_add_excl(dev, addr);

I.O.W. this:

$ bridge fdb add 01:80:c2:00:00:0e dev swp0 self local

generates a filtering call for a unicast address.
And I don't know about other drivers, but in DSA, we assume that unicast
addresses are unicast, and we have separate API for that vs multicast...
