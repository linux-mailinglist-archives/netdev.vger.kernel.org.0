Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C0437312C
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 22:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhEDUG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 16:06:29 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:33703
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232582AbhEDUG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 16:06:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzXW8DqP8ZS/4bxlD0h/lns6H52b/B6MGHes0/bwj3pzOXica8SXJnkrOZScCzc7jxc11WAcaTbcunpET6ZWHiCT2h9I3R4CLMGUBGZI9eayGFMMG9j1Ewgvm5WNdcOG5IbHdlVr1N8q5I07AsbXZ61LbjlcuQugYcq5RFeunURpCo13AQpZnq/rAvJ7e/r/tJA+AruVvFKxSnRfYs6hCE1/UWGmB0ir+kmhgxwS6o5pIeDD9TS9tQHz+56AKwY2Wk0QxFFdi4BQHaFXOEMSBZUuVuc0J/4xxfMjnHtkV9zei5++xUrz6Y3v8J0iV3jpn00ot7TUeJW2kjc/+S8Piw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDaZfruxRLOBNCUNl44GntcTxlfx0NYWY3plBC20+I0=;
 b=CejC/SejTT1RFdpJ0j/0F1B1lNMbkcWNoYsmxHtour0QmutddL4RXKQ2YcPFm9el5sBYVY1AN5hqnc6RMtcPPKGmCVa8OIyDaudSd/odvBzIj5Z4MPvJrrzJ7FOnHmlvZCsO+YyEDjqyqnOIkONfoinZumQkQ1sVBDn67WBx5ULxWJ/d/sjc7+O9zrRPfMwNKd9+gVuL6ZONfHRCRYxuA+/8tu/qukhyDH2Z1Gx/4rjEX6QoTkgU7kU9OzRUAi/Wna81/XxXqqCHIEvQ7+s7kwhbmNBXcukMEZd/csPc49zoVSypir4UaOXqOBuLTtHtXo8i1MVcHa0LNcf+30b22w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDaZfruxRLOBNCUNl44GntcTxlfx0NYWY3plBC20+I0=;
 b=F/KwvChQgRDm8FZ3yh3PFp4cs3Tysu5UJ1cbawxIcbHFPeDN/NxjYIoTd8hPHuslaQGsHIWROfdQvEzlX3avX6Fl4ILrecQ8YNw4imKylOO7n2EHuLpNrMMgNKngabN+LTAgwqT3yDfF1ez8R2XR3rYc4z1IL3hFMfOZliDSvEJ+vu41aVtwpkJjydpnDQlCwR2YAqBicWQWG6357LCikViEzUIZ9crWC25U89086FAGg/j1e/p8i5RnqcabctTmBlfVpeiP02zjSInikVUwRoYn3DlAQIuPc/iMJALiBlR3gmGZrQuP0VEJIqesAR1i1cqiOS5GbQ3Mb0aoSzklEw==
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5053.namprd12.prod.outlook.com (2603:10b6:5:388::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Tue, 4 May
 2021 20:05:31 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 20:05:31 +0000
Subject: Re: [PATCH net 0/6] bridge: Fix snooping in multi-bridge config with
 switchdev
To:     Joseph Huang <Joseph.Huang@garmin.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
References: <20210504182259.5042-1-Joseph.Huang@garmin.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <6fd5711c-8d53-d72b-995d-1caf77047ecf@nvidia.com>
Date:   Tue, 4 May 2021 23:05:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210504182259.5042-1-Joseph.Huang@garmin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::15) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.230] (213.179.129.39) by ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Tue, 4 May 2021 20:05:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fad57310-98a8-429d-706a-08d90f37f826
X-MS-TrafficTypeDiagnostic: DM4PR12MB5053:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB50532E5183859621CF20F88ADF5A9@DM4PR12MB5053.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhrLnuoHcuSDKan4QWWS1REMasy9nieUQo+J6opSOxA+cFscWFKCwy3P0h/9eBC9zKNQ+94PhU+x1AaHvNSt/S1k2Np7rAJoVpCjNxU84zp9NVhyvunyI5eEkT7mbrBq0987qcLBm17icjQb6jA9ylDP37txu4N/hAnBeGwUmpfRgljcDLDRcNZWw9dHEUKZdIFFyZS176OdEz8XN1JE1BsxtQwnb6Aq97efPt4Uulfny5mLNobhrNFoyj234905H0pUfkALo2OYqwWYdBH2dJy/LtP/+83Niek5BKR1UuogcXeiwmGc/IArm4H2JuezXH5seWj2XcAh0LHpvFCkeLKxLesYrO6d7cjwd7WmNqKkIu6c+SToI/MM2PGzTnMjU2+B58xRMyEsq08vL06FERWZOixNBL6L2+OkZbw3DPakaWae88PX0CGQiAtVY/TI+AfJt8CcL3aADf92dYtI0MUvra/XnA5oKm+JPOk8IvyuMRlOyQ3VrVAb1Gqz/I53pkNM3p0ebZOJTsqNa9jxHKBmhfsTdX7+XVe93DLUIMzvCp6hnky9rbWkJb+v1oFIzd64C+4+UG/yb858bPi53vmkJ5LWGt1OFEYHflFFT7HjJAQY9PgUXX9J1aagdNb1LWmnLOgKHIiYQ/G12qAkfRGB41e2yTTDRM1YgQZFxJ63YDj33nvS7lsa1VORji2u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39850400004)(366004)(36756003)(478600001)(186003)(5660300002)(16526019)(53546011)(26005)(8676002)(66556008)(66476007)(6486002)(8936002)(2906002)(16576012)(31686004)(316002)(83380400001)(110136005)(6666004)(66946007)(86362001)(38100700002)(31696002)(956004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SzRXYlpFVVVMOXI1OTZnd29lOWl0MnVpMVVOWWc4MDZybVRnWlhROHN5czBV?=
 =?utf-8?B?WUhoT1dUalRkTWYwSVJZY1J3VEtMdU9QRUxCOW11TndhbGV5bHZleUU5cGk3?=
 =?utf-8?B?ZDdtZjF4Y0hPMlBIUVJEdkxMRXJOYWp0KzBpUWlwTHVsRE9KVW81bHJqWjds?=
 =?utf-8?B?ajA0TDZ2ak5ocW9ObGxMTGg5MktQRnF1MHgwU0dZUFo0NE92Qi93VDdCWEhl?=
 =?utf-8?B?NXZ3eFFCRU5TM0FodGhubU5WdFRlaTJrekV2ei9kVWwxMWQ1YnBVanhZdXNa?=
 =?utf-8?B?Q21mSXFETERXeGpqMEhGTWtZdzRvSWtSeENqUUhQZUxzclAwT0hxTXQvTnRS?=
 =?utf-8?B?bXdZSlVPWENFbmt3Q0pYSVIxaHpmNkx6OW55dVBGaFVsY3dmbVpzelVkZm9t?=
 =?utf-8?B?cGZ3aitGMktoNHBNZzlJZWJDWUxVY0czUU1kSHUzbVp2dDdYcy9NTlhBcGEx?=
 =?utf-8?B?WW00ZFJ5c3Zzdk9FK1RXUmJXTHJ0RFk0Q2xhdGFaalcwNEZUcTlvN0ljWjhv?=
 =?utf-8?B?SE5QWmFqVW5MVGtadGNwUU4xeU9YTXZLNmpsQmR4Y291cm9sUUN2OWRUZ1JL?=
 =?utf-8?B?bHhtZS93cGl4OXcwaDRyNGJCa2t1cVRqTHVaMzFEdVorcDF1bkRVMU9mYkc2?=
 =?utf-8?B?UytXekNkRjM2WXRGNG1Ja09jUFpYaENXSXZwZHRXN2VId09HQWxUZUc3TmJO?=
 =?utf-8?B?Nm1VbCtldkhLQkd2enlXbXVGajJwWUdiMDZaVFc3RkIxNWNuOGlNbmUxN1gr?=
 =?utf-8?B?ek9xc3NVUDhDVXJYN05Ib3E4YlhtVzVkNHFON3dqSlgzTEJFZGlyOHl5a3BX?=
 =?utf-8?B?bjd6MGZUK3RzSFA5TXNacEs1eHZGMEJvR0MyQko2QVR6MXJLUkZ5bDM1Y1J1?=
 =?utf-8?B?UTdCdVVLRnJsL0dyTWYyMXpwU25rTEpPMzdwc3M3QStTMFNiQUNIcHAvd1Bp?=
 =?utf-8?B?SVcxU0JUNzRPTFhtNVJFbk9WSnVxcGt2RnhHd1lOdXc0OWtwU3hVYmQ3V0lQ?=
 =?utf-8?B?YXBQRkNScFBTZ0pXVXl5dFBZcUJPYjkrQjlXcXF1dFdXbytjZVdFWGlvMmJ4?=
 =?utf-8?B?ZjJHbG1TMitFeVFxZVNQSnR4Z3pUaVZ5QVNQT3lQOXJBbk9ZVWxCWHlteGZL?=
 =?utf-8?B?MlVaRGVzK01sdURXa0tZaWhTSDNTaHEzTTdXMzZTZHJqK2pOcEpTOUJ0dkhZ?=
 =?utf-8?B?akZyVndacEs0RkNodHhZaVZnVHlmOG9LQkxXZW5WL3cvM2o4SlJ3STEyRGlz?=
 =?utf-8?B?R3d6a3B0Q2tWeSttU1dpZjh4VEQ4MXpZc3hyV2RsaEJIOXhiQzgzdHhJU2JC?=
 =?utf-8?B?L2Z0MlhXODR3ODVtbk9qNUlLV1VUY1BYZ2JYczdYSWFwUTFVN0JvR1NUaE9j?=
 =?utf-8?B?N2U4ekpYWERPSFR4N2xUSUs3MjZ1cWNuQTFlR2tra2ZSTktUVmJkVm5VUkZ6?=
 =?utf-8?B?azB6cEJFbENIOVdGYWVmdWQ0anIrOUVSczlkUVhFbDZrM096M1NaTWtJQzdL?=
 =?utf-8?B?VnJzREJ5ZUxIYmVKTjFwVUthbjQ3SWU3TFBLMnpuRm10OHVzcEFFMzFONGVu?=
 =?utf-8?B?ZmtJVnlUOUdzWWVUelRXWU1ydUZsL1NlMFFFOE9BWUEzNWtOVEdlZGdaUEs3?=
 =?utf-8?B?N00vYzZOZWl3cjVOTlBQUkI3OWNsaXRrUElmZXV5TlZ3ZG9tQmtSL3AwUzRx?=
 =?utf-8?B?ODd6TzcyWGliMjJzRjhWYnl6UmxkT1k4d25mL2dsMEVKZEw3K1pLdllNdWpC?=
 =?utf-8?Q?iFlo5F/55sFgHg0VSiwBPHz8awroVHBWPMnQ82G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad57310-98a8-429d-706a-08d90f37f826
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 20:05:31.2424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EtKmvulbudd7WvHew/SxR7X5CRGOs6hIXQJKrKF5X1C5G+BzOZQWU7M7kAvfva9R5ERxKhhhc451EpVwW5yLFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/05/2021 21:22, Joseph Huang wrote:
> This series of patches contains the following fixes:
> 
> 1. In a distributed system with multiple hardware-offloading bridges,
>    if a multicast source is attached to a Non-Querier bridge, the bridge
>    will not forward any multicast packets from that source to the Querier.
> 
>                     +--------------------+
>                     |                    |
>                     |      Snooping      |    +------------+
>                     |      Bridge 1      |----| Listener 1 |
>                     |     (Querier)      |    +------------+
>                     |                    |
>                     +--------------------+
>                               |
>                               |
>                     +----+---------+-----+
>                     |    | mrouter |     |
>    +-----------+    |    +---------+     |    +------------+
>    | MC Source |----|      Snooping      |----| Listener 2 |
>    +-----------|    |      Bridge 2      |    +------------+
>                     |    (Non-Querier)   |
>                     +--------------------+
> 
>    In this scenario, Listener 1 will never receive multicast traffic
>    from MC Source since Snooping Bridge 2 does not forward multicast
>    packets to the mrouter port. Patches 0001, 0002, and 0003 address
>    this issue.
> 
> 2. If mcast_flood is disabled on a bridge port, some of the snooping
>    functions stop working properly.
> 
>    a. Consider the following scenario:
> 
>                        +--------------------+
>                        |                    |
>                        |      Snooping      |    +------------+
>                        |      Bridge 1      |----| Listener 1 |
>                        |     (Querier)      |    +------------+
>                        |                    |
>                        +--------------------+
>                                  |
>                                  |
>                        +--------------------+
>                        |    | mrouter |     |
>       +-----------+    |    +---------+     |
>       | MC Source |----|      Snooping      |
>       +-----------|    |      Bridge 2      |
>                        |    (Non-Querier)   |
>                        +--------------------+
> 
>       In this scenario, Listener 1 will never receive multicast traffic
>       from MC Source if mcast_flood is disabled on the mrouter port on
>       Snooping Bridge 2. Patch 0004 addresses this issue.
> 
>    b. For a Non-Querier bridge, if mcast_flood is disabled on a bridge
>       port, Queries received from other Querier will not be forwarded
>       out of that bridge port. Patch 0005 addresses this issue.
> 
> 3. After a system boots up, the first couple Reports are not handled
>    properly:
> 
>    1) the Report from the Host is being flooded (via br_flood) to all
>       bridge ports, and
>    2) if the mrouter port's mcast_flood is disabled, the Reports received
>       from other hosts will not be forwarded to the Querier.
> 
>    Patch 0006 addresses this issue.
> 
> These patches were developed and verified initially against 5.4 kernel
> (due to hardware platform limitation) and forward-patched to 5.12.
> Snooping code introduced between 5.4 and 5.12 are not extensively tested
> (only IGMPv2/MLDv1 were tested). The hardware platform used were two
> bridges utilizing a single Marvell 88E6352 Ethernet switch chip (i.e.,
> no cross-chip bridging involved).
> 
> Joseph Huang (6):
>   bridge: Refactor br_mdb_notify
>   bridge: Offload mrouter port forwarding to switchdev
>   bridge: Avoid traffic disruption when Querier state changes
>   bridge: Force mcast_flooding for mrouter ports
>   bridge: Flood Queries even when mcast_flood is disabled
>   bridge: Always multicast_flood Reports
> 
>  net/bridge/br_device.c    |   5 +-
>  net/bridge/br_forward.c   |   3 +-
>  net/bridge/br_input.c     |   5 +-
>  net/bridge/br_mdb.c       |  70 +++++++++++++---------
>  net/bridge/br_multicast.c | 121 ++++++++++++++++++++++++++++++++++----
>  net/bridge/br_private.h   |  11 +++-
>  6 files changed, 169 insertions(+), 46 deletions(-)
> 
> 
> base-commit: 5e321ded302da4d8c5d5dd953423d9b748ab3775
> 

Hi,
This patch-set is inappropriate for -net, if at all. It's quite late over here
and I'll review the rest later, but I can say from a quick peek that patch 02
is unacceptable for it increases the complexity with 1 order of magnitude of all
add/del call paths and some of them can be invoked on user packets. A lot of this
functionality should be "hidden" in the driver or done by a user-space daemon/helper.
Most of the flooding behaviour changes must be hidden behind some new option
otherwise they'll break user setups that rely on the current. I'll review the patches
in detail over the following few days, net-next is closed anyway.

Cheers,
 Nik

