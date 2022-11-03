Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64D61862F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiKCR3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiKCR3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:29:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7760263F
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 10:29:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbmstGmm4talHqBBb76rbt8za6qW0fsTen618YB2BhJJyBBqBXMAkzDH7QRuARjuMnnNMMMNw/At5SR2+sjGMrNjWAhktUmpFhdYcP5JDP3anXcV7Y9O7FjeYd+ZdkHLqVPpNfUEcTPWAxMZ4w9duUmZ8N/e94uvZeFBBdmBGejVoNG8AuOYwuTZaqwdOaGq3+XsPt9rP4YNTFDbCHiFnbnvsAv1fZLOwgRsSDLNxt6psNniAVWMm7F5lUwZyBNxY2dJkBH6n5w6f5TN6rnACQHW7BR8bYGx+/6FCI5d3XW7Cj9cMMPTWHL0NwIZkVS0AOOtgEESLvWV89LOTm4QEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=th3uH06a+N3TtlKW8Klp3RMlezAMU9S+l17NqBMDHuo=;
 b=Wm+s6NEaDbwaq00i6/ACvjfx1R2xtBnmHPL18VGKm0v+wsYZWyTxURuekFuSHGijOW4HdB6nboSbBqivuDQkaGgQ5H/ZSmJ4bhDFPiC4FGHRrPejEgRguIhchZ7o942XsIbAmIrJmhVXm4wdgDWTg6AiHGoYQSOobYVrQDUujEP4jAF7glbNdkI+Ui2lKxHhQqfDbIL23L5wJA+R39+fCdP21HjB/nE6jkisJyAAijQQX64BIJmYfIPAjum6LLqa1c+tAUrp+egUTpXU6rxgl8vnvJKs349Ovw8Ui7Uldm/pc0TE3dvmDvoS09HbMsjDh1fwM9cyH/O+RjadJDc+iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=th3uH06a+N3TtlKW8Klp3RMlezAMU9S+l17NqBMDHuo=;
 b=j1GcY16zr52BOxyTdU9QJmzEQ2DpoqtCIxgyEh6cxjjY4L0UWlobM1EiQCPbJm8ZJzDnFSAT4n1ZVEA482wpM9TkeqJ+x8qIoSpny9nM3y4q3IQEKHLqwNOMYG0k49AenRwL4rJzZy/g7EW9uGvFQFDlZchpcm/1N/TuCJ4R/bndNeyH6e69SIHQ0EfnIZvvDRSU4ELswtV5i8qdXAGpWMtQGeR139wa9I4OD/moiHXYA0YvO1vAPjGf3PEbKYQtxc45xtxqqjLMPb6hReh+ucL8DdK0qNqn5qQBwBVfILARH5wXSR9N7eizX7mK+J9Q4nwpK5Az0QAXKpbJXzgPCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BN9PR12MB5289.namprd12.prod.outlook.com (2603:10b6:408:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 17:29:39 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::e7d0:29bf:78d1:87b9]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::e7d0:29bf:78d1:87b9%9]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 17:29:39 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Shai Malin <smalin@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [PATCH v7 01/23] net: Introduce direct data placement tcp offload
In-Reply-To: <DM6PR12MB35648F8F904D783E59B7CE01BC389@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
 <20221025135958.6242-2-aaptel@nvidia.com>
 <20221025153925.64b5b040@kernel.org>
 <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
 <20221026092449.5f839b36@kernel.org>
 <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
 <20221028084001.447a7c05@kernel.org>
 <DM6PR12MB356475DB9921B7E8D7802C14BC379@DM6PR12MB3564.namprd12.prod.outlook.com>
 <20221031164744.43f8e83f@kernel.org>
 <DM6PR12MB35648F8F904D783E59B7CE01BC389@DM6PR12MB3564.namprd12.prod.outlook.com>
Date:   Thu, 03 Nov 2022 19:29:33 +0200
Message-ID: <253k04ct08y.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0097.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BN9PR12MB5289:EE_
X-MS-Office365-Filtering-Correlation-Id: dc286e7e-e52e-47a1-c078-08dabdc0fc5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tmRMDhxsZFm3oEmSUvAvUfIHlbFlAFzj+4m3ockQKg/lfnXuYFnN2y9GstuwzJOHYB3DyrLVvpoPm2wGbWPTg6UxiFEp5ITSbnJXSwCPv/PEiByYPoDftS0bKLUoKxEAXMqNSucSLwYMt2ZITaSr95slZdTT860nhGI1F5Ng+H9h5gAY3kYo81dO0UJvjBidmVbcwtoQQ3Kylf8npyPEwM1q9FFsZmFLyZzrQt3vOBCF46bB43tehRRKk+3Q/1480DCNHxThuqi3m+2FPRaDrTC71OADskA5LxWrvt/9Ngu9U54MMrrMKakq2RlVIl6uMJbAUjZJA1FNclk5r9ts2x10an2AQuRC1E64ydGNhsr2+T++oD9jQY2b5xMFL/Ow9l52ZUvHgYu1XcnvVwXMuzmc59rv0F66/Z5jC2d6hLCzl/sc7mqaRRu9JMIGBUPo62IeayaT8Fds/1IiZZP2TyEZwO0gBHfE2Cn1dvUABGOawadDLtODqOviuWTUWnv2TY6KxKn9Wxo9mlgw0APqF4zVSUMsYmDxxPCDb6Jj+hdUTBMJ/WriTGnlU73oVq1kby6kWi88Xn8U6XpjDElHQUIk77DfVy09vz5aczCxXPubpGJCQ1e2WE3Z4CK6kFyAdSvQYiHmIcMNylNW8Ko2RhbhGRl7RXzNX+KPOgFKjhFDtNHDHEy8hU7l6dJkW8H9RoT67PUjC02Hll8T0OLh77AcY2RGpLYiW9a+/ISuW1IWsYL7eOjnf6XqS53W2JDA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199015)(478600001)(8936002)(5660300002)(9686003)(6512007)(6486002)(41300700001)(83380400001)(26005)(7416002)(6666004)(2906002)(316002)(38100700002)(86362001)(66946007)(66476007)(8676002)(4326008)(66556008)(6506007)(54906003)(110136005)(186003)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FGHRgiyo1c1WWLTngRI7nJ+ED9B4wjgaAdc8HMtBjRFFLuyZlKXLje/6vS7M?=
 =?us-ascii?Q?ws7L6hSNx8MfsA5SkZKOB7OXIxvNuNPImQaKhHz/4zABd5KCI0SfsUYu1pSN?=
 =?us-ascii?Q?f4wI18gCPR4vPo5LjOgVW0KH1U/+e4IsCI4ZfwsVlyNwf1EcxPVeA46OGEYF?=
 =?us-ascii?Q?VPrwgNjYQRYJB49vuhXru5AkLzpYqyIqdkz8FCHbu3xj+nkM6jErtL4p9QQQ?=
 =?us-ascii?Q?mJiTwmO5jVbVfeYcNP+2nAyMumSvIS2wmz6Jiy/szrba/l20178h3Th8NXQo?=
 =?us-ascii?Q?slTcJDtpH7KSDFf97QPpq9xgvTrkq4QsrLamVEIi+ScjMv7ZEe535phqKaJs?=
 =?us-ascii?Q?w6ieQHD9wTMRTBQonbYZHPgndVgFj8YjWlGH3eUYr5lyTdq1VXS4BN6zzkoG?=
 =?us-ascii?Q?1eNZwBAOfJ8NPM0rd3CeTOlR4nNWlq1jTBGtEnmRGyulQILdznQia9lmGISz?=
 =?us-ascii?Q?lwO6Jxclit9hb20UysSe9R3ymbuY9gu7dOtFQXD0fK/2uRYhZ2kylLWf2sJi?=
 =?us-ascii?Q?IActfzog1leV41V2eJmq3StziziN5o5qS0SoKPuwfe058qleuzmxAFuc0EpL?=
 =?us-ascii?Q?Sj9aY7sS95EYYea+E1ReQPWFcFSrbrn3M5E205aXlTvDm2ZM4Fqj/z05lScH?=
 =?us-ascii?Q?awA+2/lOzDLCAIxa8NczaBhe8Dcs5vSG6MaHYc1C908lEOJaj/9UH5IH4+T4?=
 =?us-ascii?Q?aNcwJMDnSNsOg7q3rDqNK18F0+PwgvvmMXLKSBftb0NpfN7lrgkd97YEFSI4?=
 =?us-ascii?Q?2jwedV5ZwSIrSY6VFgbNXdCV57SD4Iryfkc3tr3einI6y3IbCiduaQajt/zt?=
 =?us-ascii?Q?tpVVzJMQURrdBzJ/seeRCIQAL1MsTK7mVALOwAYLh03ncfaFDEuzvHrLejJw?=
 =?us-ascii?Q?sZjeIWeXB5yTKdRu/t1BLHbDH9JMvPHpCRpph2mNs6jknUs6s1dyGFORSpWf?=
 =?us-ascii?Q?t9XcfrlPrxctFfO+WofD4m6P4tKGmeK4fA56fY8qGtf14xXcpDKH0GhZ5WdR?=
 =?us-ascii?Q?tAwNQkD4a8fYGkn0ZTEFHeZ1u7+AGo5S7oqcC467VVCrJst5QqcMCwPBVadB?=
 =?us-ascii?Q?jhgB+56sUUr1eZzAaMemW7oYhWBaOL7DQ3AABn+H5M7iyDUqI4UBarlSaHy+?=
 =?us-ascii?Q?NKPE3NlT3VMCwZ48BiUQN6/Eac2e7DwhNpgJdKQQB5oJOPpsWaU8WY4JojQj?=
 =?us-ascii?Q?Uvv/zJXKV2lc6PL0HazG2/VBveuacteMtzARhWA0ZDTD14SsjfTJSlD7YrII?=
 =?us-ascii?Q?OKD74HxVPvSzjtCzcCepIhkbrtm5tjcc4m3lGs2xDfz1Hc34sb4USsrh7jvD?=
 =?us-ascii?Q?rmvhr0Sfiw9/35VrqPAY8iffO+JwkKZWVOK0+GkYR7Jcj+pE5lAq3/QG7ikQ?=
 =?us-ascii?Q?1i/3p76tkNP19q44sOnkZS7bRKyd6ZKq65UVOHDr1aXu4eEkOA51UeIQISpr?=
 =?us-ascii?Q?0TmYURDOQv624+/SFD7EXbtbFy9cIinsikFMtyW1LDhU7GMJRs2eIqyS+2Bx?=
 =?us-ascii?Q?a/RNcFi1BHXUyUrCPQINaafrPwtoR+GJu/Dp2PcDcsZcwtHLQXzGIq4SnIsA?=
 =?us-ascii?Q?eNU874aax+cNLcJ1zZpP9v8O5iNTXHBdEQ2DCJYi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc286e7e-e52e-47a1-c078-08dabdc0fc5c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 17:29:39.2747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bdh/8d7Ncpl46JDTfSCmGCd1B5/zzENXvoPBwl3IzvyT2yJZNxiUqo0HFOaj2LHRpSfHOlalwqoKzQaOAA9pnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5289
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub,

We came up with 2 designs for controlling the ULP DDP capability bits
and getting the ULP DDP statistics.

Both designs share some concepts so I'm going to talk about the common
stuff first:

We drop the netdev->feature bit. To fully disable ULP DDP offload the
caps will have to be set to 0x0.

In both design we replace the feature bit with a new field
netdev->ulp_ddp_caps

struct ulp_ddp_cap {
        bitmap caps_hw;     // what the hw supports (filled by the driver, used as reference once initialized)
        bitmap caps_active; // what is currently set for the system, can be modified from userspace
};

We add a new OP net_device_ops->ndo_set_ulp_caps() that drivers have
to provide to fill netdev->ulp_ddp_caps.caps_hw.  We call it around
the same time as when we call ndo_set_features().

Interfacing with userspace is where the design differs.

Design A ("netlink"):
=====================

# Capabilities

We can expose to the users a new ethtool api using netlink.

For this we want to have a dynamic system where userspace doesn't have
to hardcode all the caps but instead can get a list.  We implement
something similar to what is done for features bits.

We add a table to map caps to string names

const char *ulp_ddp_cap_names[] = {
        [ULP_DDP_NVME_TCP_XXX] = "nvme-tcp-xxx",
        ...
};

We add ETHTOOL messages to get and set ULP caps:

- ETHTOOL_MSG_ULP_CAPS_GET: get device ulp capabilities
- ETHTOOL_MSG_ULP_CAPS_SET: set device up capabilities

The GET reply code can use ethnl_put_bitset32() which does the job of
sending bits + their names as strings.

The SET code would apply the changes to netdev->ulp_ddp_caps.caps_active.

# Statistics

If the ETHTOOL_MSG_ULP_CAPS_GET message requests statistics (by
setting the header flag ETHTOOL_FLAG_STATS) the kernel will append all
the ULP statistics of the device at the end of the reply.

Those statistics will be dynamic in the sense that they will use a new
stringset for their names that userspace will have to fetch.

# Ethtool changes
We will add the -u|-U|--ulp-get|--ulp-set options to ethtool.

   # query list of caps supported and their value on device $dev
   ethtool -u|--ulp-get <dev>

   # query ULP stats of $dev
   ethtool -u|--ulp-get --include-statistics <dev>

   # set $cap to $val on device $dev
   -U|--ulp-set <dev> <cap> [on|off]


Design B ("procfs")
===================

In this design we add a new /proc/sys/net/ulp/* hierarchy, under which
we will add a directory per device (e.g. /proc/sys/net/ulp/eth0/) to
configure/query ULP DDP.

# Capabilities

    # set capabilities per device
    $ echo 0x1 > /proc/sys/net/ulp/<device>/caps

# Statistics

    # show per device stats (global and per queue)
    # space separated values, 1 stat per line
    $ cat /proc/sys/net/ulp/<device>/stats
    rx_nvmeotcp_drop 0
    rx_nvmeotcp_resync 403
    rx_nvmeotcp_offload_packets 75614185
    rx_nvmeotcp_offload_bytes 107016641528
    rx_nvmeotcp_sk_add 1
    rx_nvmeotcp_sk_add_fail 0
    rx_nvmeotcp_sk_del 0
    rx_nvmeotcp_ddp_setup 3327969
    rx_nvmeotcp_ddp_setup_fail 0
    rx_nvmeotcp_ddp_teardown 3327969

I can also suggest the existing paths:

- /sys/class/net/<device>/statistics/
- /proc/net/stat/

Or any other path you will prefer.


We will appreciate your feedback.
Thanks
