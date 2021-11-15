Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C57444FDDB
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 05:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbhKOEXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 23:23:01 -0500
Received: from mail-dm6nam08on2068.outbound.protection.outlook.com ([40.107.102.68]:40895
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230271AbhKOEXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 23:23:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNX7FBPXCoBC7OT7T2Hd48Go4OsYLuLaosZ8UQkSeK3r7XOr1qVNU2uMA3H9FrmztUoG99jSnXGMizGBnHXRLTliVSDfyvlfGtmFqrmirQnGEzaj5Xr4d3aLhWtFSJKs1EXWk4dXWRzvJARwJ5QpCQm2B93u17Nr8ucS9hyRotIXCAs9g1nhvVXcARAMmVU5dYof0OeDy8iaNxisLxwctzdE+HM60prB7llju9f0XoVExdsFVOTpUTcdUwzPJWub+goA7zx75HqStkoBfxnZpAjIwlH6qeORGw07WwN77lWBaJjBdVEPuuQnyVqChzGPN28XkB8NuN4XagM0+j4Q8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TURZKUtvutUOYGGNK9BwXbneH6UGHD0ElyebLJC+xns=;
 b=npr7fSbEys3yjq7aq7TqGPQYkkbXO57SwBZGTzh1x1OwyF8XFZWpBFG8im4cC52rNVncvKVcwOW5ubZmvQJuzkhGe/wDA9/2wq6CkGYeLFl5Oc9gVx8E56dnAVD631GwPr5uxRf9aoQF5DCM3vKRWRcdS9OQ4gjrFDZBFjlHqDsQ3ji2218BL+oyAGcktvB8JQYi81bn2AVfOApZRPwvxgjvPu0Fn4SCgS3+ysrtT1BoaQWmnjsvSIGHTJHXsUVTDj1taE/vMJRKEg0wiom4fN4zjVXHBqtbrSX5aR1Gmg0VgS5bL5dp6ZErIGDdzKf6FZ5mBXTZ11hYZ6B2zwqQPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TURZKUtvutUOYGGNK9BwXbneH6UGHD0ElyebLJC+xns=;
 b=Ua9WRw3LHVGWCwul5033RmvAXjuFDw/OMgi/xeBUmYC+8yyoIygM9xKFC/as989Q91v1BOsjgbxu1o+RItCSkizgPY2/bFe4w6ss+Mp95MioM+J/GMfXJg3BXtcouRkPwj0iG5TD4sWu5+mjxICOIEcSOaic8M2YHE5JmV0hOmz1D6xQIWD4VEx21yStMLbit3Sw7+7ErVQjTbYOT+DSOILckVtiQky5faHvTO79zFTVBqBxH1JuqIk+YvATyiJyBwNdywKp8W1AUjuPsFJPTH4Op/QzB5l8srwPVGZJ9i0ziN2Z/KPGieSpm+VlMqaD6gNaQ23uuugji4WEGX91tQ==
Received: from MWHPR22CA0001.namprd22.prod.outlook.com (2603:10b6:300:ef::11)
 by BN7PR12MB2756.namprd12.prod.outlook.com (2603:10b6:408:29::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 04:20:03 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::95) by MWHPR22CA0001.outlook.office365.com
 (2603:10b6:300:ef::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend
 Transport; Mon, 15 Nov 2021 04:20:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 04:20:02 +0000
Received: from [10.2.54.80] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 15 Nov
 2021 04:20:01 +0000
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param to
 init and de-init serdes
To:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>
CC:     sundeep subbaraya <sundeep.lkml@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, <argeorge@cisco.com>
References: <YXmWb2PZJQhpMfrR@shredder>
 <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
 <YXnRup1EJaF5Gwua@shredder>
 <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
 <YXqq19HxleZd6V9W@shredder>
 <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
 <YYeajTs6d4j39rJ2@shredder>
 <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YY0uB7OyTRCoNBJQ@shredder>
 <20211111084719.600f072d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZDK6JxwcoPvk/Zx@shredder>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <952e8bb0-bc1e-5600-92f2-de4d6744fcb0@nvidia.com>
Date:   Sun, 14 Nov 2021 20:19:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YZDK6JxwcoPvk/Zx@shredder>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4250f32c-7f9c-42ed-2a2b-08d9a7ef320b
X-MS-TrafficTypeDiagnostic: BN7PR12MB2756:
X-Microsoft-Antispam-PRVS: <BN7PR12MB2756F2D3AC984DF21BDDC2F5CB989@BN7PR12MB2756.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+WKIF3sIx2y7IHQSWnWl75yd6KjENwnKxA0Xq8gzJVYzcQzFCmQMQVJ+CRrWqL9OOlmyD+NCRajggS1M7+TxGdwn3C8CccoNyxCYjMu65Uxy63tFGgRbn/m5Iysb87h1hwytOFLM/LO8dx3hwU3gXRSwbF5mnIfWZj/VmU/2EzhdpvuSAyNh0PTGXeI17pM8AG0lpr5sOiGB9kZ5Wa53DP1FeClOXdBYK+ma5UwPbvk7LNk+STYRjIddz3N6z9ZR/xqMIYEt8ZyMdwnIkaVl4f0vdIWzT9b8rvaV4Dla7etZR3+RvTTP3vsX9Pp/Bjg1dvzZqzOfmpoHYog24Cfvw226a07yBHbBae9pabIyDkMN6fROTHnEtGj+llsbkPBhwD+omWOu+kyPqIypb9o5/CRN889z3nuzlgVP0kN3dX8YRBrG8qIxs7GSASgNUf71vaDRXUpOuz1hTM0NKW2raUC0fHJFzJcOeR37D/dgZAcyqI4udQZkvdFq1wKq93wYUURpbMGHQvaVHx8SeqnmAQfIqDd8eY9oI/0McFZ7WCkHH6K3tvLFcgMvGYUwo1ECGoKt2tTmhbE1Jb5DGbXGQUyhQKBI8Q0IfStCOyLVWiIMUbpwUGzrb9RLjTJ9BcihQ7YB++QHVJ2dQJW6f9ByAZ3jLV02SUm+HjBgYi2O5crgKEfS9MDrZ99fzvkjF0uSFo1zvB/Gx1WW84VKyEg9w5iuvBTbhVtzTOG2TtHClw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7416002)(426003)(336012)(31696002)(4326008)(70586007)(2616005)(7636003)(8936002)(53546011)(47076005)(8676002)(82310400003)(356005)(2906002)(316002)(31686004)(5660300002)(36906005)(70206006)(36756003)(86362001)(508600001)(16576012)(110136005)(186003)(26005)(54906003)(83380400001)(16526019)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 04:20:02.7231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4250f32c-7f9c-42ed-2a2b-08d9a7ef320b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2756
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/14/21 12:38 AM, Ido Schimmel wrote:
> On Thu, Nov 11, 2021 at 08:47:19AM -0800, Jakub Kicinski wrote:
>> On Thu, 11 Nov 2021 16:51:51 +0200 Ido Schimmel wrote:
>>> On Mon, Nov 08, 2021 at 07:54:50AM -0800, Jakub Kicinski wrote:
>>>> On Sun, 7 Nov 2021 11:21:17 +0200 Ido Schimmel wrote:
>>>>> TBH, I'm not that happy with my ethtool suggestion. It is not very clear
>>>>> which hardware entities the attribute controls.
>>>> Last week I heard a request to also be able to model NC-SI disruption.
>>>> Control if the NIC should be reset and newly flashed FW activated when
>>>> host is rebooted (vs full server power cycle).
>>>>
>>>> That adds another dimension to the problem, even though that particular
>>>> use case may be better answered thru the devlink flashing/reset APIs.
>>>>
>>>> Trying to organize the requirements we have 3 entities which may hold
>>>> the link up:
>>>>   - SFP power policy
>>> The SFP power policy does not keep the link up. In fact, we specifically
>>> removed the "low" policy to make sure that whatever policy you configure
>>> ("auto"/"high") does not affect your carrier.
>> Hm. How do we come up with the appropriate wording here...
>>
>> I meant keeping the "PHY level link" up? I think we agree that all the
>> cases should behave like SFP power behaves today?
>>
>> The API is to control or query what is forcing the PHY link to stay up
>> after the netdev was set down. IOW why does the switch still see link
>> up if the link is down on Linux.
> The SFP power policy doesn't affect that. In our systems (and I believe
> many others), by default, the transceivers are transitioned to high
> power mode upon plug-in, but the link is still down when the netdev is
> down because the MAC/PHY are not operational.
>
> With SRIOV/Multi-Host, the MAC/PHY are always operational which is why
> your link partner has a carrier even when the netdev is down.
>
>> I don't think we should report carrier up when netdev is down?
> This is what happens today, but it's misleading because the carrier is
> always up with these systems. When I take the netdev down, I expect my
> link partner to lose carrier. If this doesn't happen, then I believe the
> netdev should always report IFF_UP. Alternatively, to avoid user space
> breakage, this can be reported via a new attribute such as "protoup".
>
>>>>   - NC-SI / BMC
>>>>   - SR-IOV (legacy)
>>   - NPAR / Mutli-Host
>>
>> so 4 known reasons.
>>
>>>> I'd think auto/up as possible options still make sense, although in
>>>> case of NC-SI many NICs may not allow overriding the "up". And the
>>>> policy may change without notification if BMC selects / activates
>>>> a port - it may go from auto to up with no notification.
>>>>
>>>> Presumably we want to track "who's holding the link up" per consumer.
>>>> Just a bitset with 1s for every consumer holding "up"?
>>>>
>>>> Or do we expect there will be "more to it" and should create bespoke
>>>> nests?
>>>>    
>>>>> Maybe it's better to
>>>>> implement it as a rtnetlink attribute that controls the carrier (e.g.,
>>>>> "carrier_policy")? Note that we already have ndo_change_carrier(), but
>>>>> the kdoc comment explicitly mentions that it shouldn't be used by
>>>>> physical devices:
>>>>>
>>>>>   * int (*ndo_change_carrier)(struct net_device *dev, bool new_carrier);
>>>>>   *	Called to change device carrier. Soft-devices (like dummy, team, etc)
>>>>>   *	which do not represent real hardware may define this to allow their
>>>>>   *	userspace components to manage their virtual carrier state. Devices
>>>>>   *	that determine carrier state from physical hardware properties (eg
>>>>>   *	network cables) or protocol-dependent mechanisms (eg
>>>>>   *	USB_CDC_NOTIFY_NETWORK_CONNECTION) should NOT implement this function.
>>>> New NDO seems reasonable.
>>> Spent a bit more time on that and I'm not sure a new ndo is needed. See:
>>>
>>>   * void (*ndo_change_proto_down)(struct net_device *dev,
>>>   *				 bool proto_down);
>>>   *	This function is used to pass protocol port error state information
>>>   *	to the switch driver. The switch driver can react to the proto_down
>>>   *      by doing a phys down on the associated switch port.
>>>
>>> So what this patch is trying to achieve can be achieved by implementing
>>> support for this ndo:
>>>
>>> $ ip link show dev macvlan10
>>> 20: macvlan10@dummy10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>>>      link/ether 3e:d6:1a:97:ba:5e brd ff:ff:ff:ff:ff:ff
>>>
>>> # ip link set dev macvlan10 protodown on
>>>
>>> $ ip link show dev macvlan10
>>> 20: macvlan10@dummy10: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
>>>      link/ether 3e:d6:1a:97:ba:5e brd ff:ff:ff:ff:ff:ff protodown on
>> Let's wait to hear a strong use case, tho.
> Agree
>
>>> Currently, user space has no visibility into the fact that by default
>>> the carrier is on, but I imagine this can be resolved by adding
>>> "protoup" and defaulting the driver to report "on". The "who's holding
>>> the link up" issue can be resolved via "protoup_reason" (same as
>>> "protodown_reason").
>> "proto" in "protodown" refers to STP, right?
> Not really. I believe the main use case was vrrp / mlag. The
> "protdown_reason" is just a bitmap of user enumerated reasons to keep
> the interface down. See commit 829eb208e80d ("rtnetlink: add support for
> protodown reason") for details.

correct. Its equivalent to errDisable found on most commercial switch OS'es.

Can be used for any control-plane/mgmt-plane/protocol wanting to hold 
the link down.

Other use-cases where this can be used (as also quoted by other vendors):

mismatch of link properties
Link Flapping detection and disable link
Port Security Violation
Broadcast Storms
etc


>
>> Not sure what "proto" in "protoup" would be.
> sriov/multi-host/etc ?

agree. Would be nice to re-use protodown ndo and state/reason here

