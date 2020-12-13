Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4552D8D38
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 14:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406802AbgLMNXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 08:23:16 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:43008 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgLMNXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 08:23:15 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd615990000>; Sun, 13 Dec 2020 21:22:33 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 13 Dec
 2020 13:22:30 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 13 Dec 2020 13:22:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTqwfpNrac6wLsZOZR7j8mIxJGu2CpcclCOSB9FPlsJzN78rHy3E6t12S0XsP9DPBXvF1+ibZq1OM6pcN8frxPR09fT/x22/nYt6a2AppUy4BRmshtz1/amGDWU1kyWIxpeBgbpcODKsbO7Ww/YvcDk6ccdE31yQWNfKT47ZU3s1EDv+Qj5Pm8XVB6O20YWEQdEAY1qn6gedpbdaEMRD1o1JpeeEH3Rg0JxJEbjZ1bWrrNFKiZoBvlq13lcIRmTKtr8ZNTpAUueklW9FM/LqM9wlPRn3Rn5cBDiCuRMN09B4IWeoyZrolBCkiwznw9s5YiCLL7kQn4xRzIm6bw9ITQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoqOydHicIMi/TM0s+KBjVs1U4WPirPhj650n4vekIQ=;
 b=TfjA1YTsKmBkFhF5489zSIEonnA1CSB7s1C7W+k/CDnP7d5UqGQ0MccEj/Ej4/It99x2KPlK3HVmytsWxT29WHreWcjOWW750z6JwYeGbE+TDclIvyhGEu4yghIIgX7nn+Wvup4N5yZ/e0Q8mbLehKfyB/ZtLkbZDs/XI5fn4iV8U2jVZ4mPY2j6Osqv23jAHCkuEgSM8sjwVIYsdiwrye3QaRR1bKe9wbV+FEYrmaxHy04c0Q1UMJXVSGm87EAl5iwSFHENh+AXFWEZGhBrkEk6gSOR8QV4KfyYBQc47CRwOQCXygbQhTAVZ303vjER3lAybQf2CWFTCOYXkA0b+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB4958.namprd12.prod.outlook.com (2603:10b6:5:20a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Sun, 13 Dec 2020 13:22:27 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3654.021; Sun, 13 Dec 2020
 13:22:27 +0000
Subject: Re: [PATCH v2 net-next 1/6] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        "Russell King - ARM Linux admin" <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
 <20201213024018.772586-2-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <85b824ea-5f43-b483-55b6-4ffd0e8275d8@nvidia.com>
Date:   Sun, 13 Dec 2020 15:22:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20201213024018.772586-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::14) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.216] (213.179.129.39) by ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 13:22:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 827f28e9-44fb-4082-a9df-08d89f6a2309
X-MS-TrafficTypeDiagnostic: DM6PR12MB4958:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB49582333464FBEFB61675939DFC80@DM6PR12MB4958.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/t3iJo4D/I/r9M3RM/61QC6OOn7fVcQmEO8ALwuZLedrjf+ldrOstuyRXu26yHtNKzywtIf94W23CjcAH4KsP9VW1HZvf0x44PDC1WIp3yopZx2ddWRho95CyGK2c3DynWmuMy/UXK5wuxZBvnBJE+/Smy8nlX0OejZ9mWu8iPLKjTzc/EPktcuuP/PkgFt8oQIpKy686zT0BrUuiSe/gpaebNt0Y1yBwbusBfMlWsWEEk6HxpdyRmDsM6zYWZG3l+1m3ci3ean6uXLHQVeVDEl1wXXz0Lo7d9bMuPsCu6UObuXDdfmjXTAG4JBuCI5gaRItMRrqwuNcytjzOybKj56AwH+gEymyP/P8Casfsj+kTcnGzod8yBi+Cv/5uzeTV+qlX3ZQzF48QLT/qe7NIr2AXUhV1VYic+rlqRJm6JvH8bE+OzJw5aOh3LSVBft
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(956004)(31696002)(110136005)(16576012)(53546011)(54906003)(66946007)(86362001)(7416002)(66556008)(921005)(4326008)(2906002)(16526019)(186003)(66476007)(2616005)(6666004)(6486002)(26005)(36756003)(8936002)(508600001)(5660300002)(31686004)(83380400001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?KzBXWElFVm83dXNYbUJGTXphNmV6ekFiU1hIZ0dlNTV3aTlYV0JHQVlPemZo?=
 =?utf-8?B?M0lMekxqMkl6RHhFbjIyU3JqUm9Yd2czeEUvZTIwOUdxVGdlb2FUNWc2QWhJ?=
 =?utf-8?B?aDlIWDdoN1hNUXBNb1A2a2wvZzBLS2FNdkVnMDlXNklYdkh3MzAzT1l5UE1Z?=
 =?utf-8?B?Uy9qVHZXZEtMeHgrVzZvNTNuelpjLzl0OXlMU3NJM1NzZmZqWW1BVUt0ZEhy?=
 =?utf-8?B?MnNIbTJYT0ZIRUgxbkZtS0wza2hJR1RNM3dVQWVjZU4rdE5yVFE4aCtuU29T?=
 =?utf-8?B?RURhZ1JYT1g4SnhoOHg0dGxTTjlPa1VUZ1hGTGROckpobWJIeW1vaE9sOGZJ?=
 =?utf-8?B?V2dtS3B3NTk5TEJGd0MwOVIzSW1aWDFFa2hwSVdTTVJzeUFaSWFFWTNPYzhn?=
 =?utf-8?B?NEVHY0M5TFcxUjJNbHhZcFFWLzYwYklUK2RaRUg3OElnUThzVDNqSlQyOW5r?=
 =?utf-8?B?RU83VnBqZDU5Q1dLNDJONXpSTTBsenJ2VEdXNlk5ZzBEUEJ2MVg2cHVDcGpQ?=
 =?utf-8?B?NEk0RkUxeVVjajYzdnF5eXdkbW44NkQ0UVYwMkhBZEdpYzM0bDZqdjNWS2E5?=
 =?utf-8?B?MmNQcndjTVBscjZQaHUzMmprcEZuRzJjU2w5eHBCVkdKN2ozV1oyU2MvZW42?=
 =?utf-8?B?N3VGMzFTT2c0Szg4cGh5bnVtVnhxVFF1M0U3Y3V0TmtQRGFDdEYzRmcrSVlL?=
 =?utf-8?B?WGU2dXF0UTkvd2FQRnhWVFpvNmZqbWprUVhzOUU0d0NtNzdzaUI1L2wvS1lr?=
 =?utf-8?B?NmRNT1Y0SG5lM1drVEFJK3dOZURzcG83UXgvWGF1Y09LUUU4eWRhVTB3QVcy?=
 =?utf-8?B?dEFuNkRoMVVKcDd1VjdFb1hia01FYXJWU2NTT24rR093U2p6Qk0xWTllT0Zl?=
 =?utf-8?B?SUtzVElUdGcxaTlFR3BKOWZlWGc5cVVOalZ2VDFzNzhycHVGcjZIMitLSVVO?=
 =?utf-8?B?ZzRLaW9mRGJDYUNlVUI5RGpsTC8vMnhiNkREbDduRFcvVG9STlJNNDJzbUwx?=
 =?utf-8?B?K2pRSU5vQzAwT1dOSU9WbG9LUGh2SXVMR1ptTEQvWDJBU0tXVUI0TnlYTDJ3?=
 =?utf-8?B?SDBEQmd2OE1HS2tlLzNlWTJVNFZ4WCsycXYxOGU0dEdTQnlTWWg4Qk5aeVR1?=
 =?utf-8?B?MXBvOXZpcVBFdWRQZ01LdEdtWEtUenRzeDU0T2M3T256bTlqU0V2SEFxcVhG?=
 =?utf-8?B?WjNvbVB0cFBaY1k4TmhSQklteFZZOXpFYm9ZZDBXT1NtbVR1UkU4YjZZZ3Jq?=
 =?utf-8?B?aExqQ2ZJRWhtbDA5VllwNzhZRzNZejA2UmJwaEN0NzRYVWIvdXBudVNvSzl5?=
 =?utf-8?Q?Qrac2TUKKdcxEZ+BhTUP3ZWS14uAGqmTO0?=
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 13:22:27.4521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: 827f28e9-44fb-4082-a9df-08d89f6a2309
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xAc87NSFe6nd1bm0/9e6SrFTXvO9oPZglA3vKWBurQUf+2CE0nFw7kEkI6U56y3qESvN4Q/6IBooaw/skV0/wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4958
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607865753; bh=NoqOydHicIMi/TM0s+KBjVs1U4WPirPhj650n4vekIQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=GMb11Wn9Rrdz3EdcTpfEw6ckrHSj0muIE+FMWFqqLqKNHiAmBeUCUdFxZd6KrsbEs
         x6LBFMKIeZxzFYT6OcPzTumqvSeB6ewhyCCDGuKQ7QGhIWi1FtgUWifcLFI1lZhxLr
         MUE5rCrhOGogc7huGrDd8E5Bzfmxe82DKJDqfgq6CCof0KqKd/1s2emcmTUBLPjV5+
         v9+/sNsMBNYMgRVZ2PLi1XaQtfraggjbaoogg6Ewp+ylF/Oq6PsuxJCFnR+fAJBSlG
         xfp3mwWGN5dSlYTFD7m4kE9rOQTUEHyA4swZV2va+gxkOZ+4wL7GqrJe4qShIHtyE+
         vTQGxLFGu8h3w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/12/2020 04:40, Vladimir Oltean wrote:
> Currently the bridge emits atomic switchdev notifications for
> dynamically learnt FDB entries. Monitoring these notifications works
> wonders for switchdev drivers that want to keep their hardware FDB in
> sync with the bridge's FDB.
> 
> For example station A wants to talk to station B in the diagram below,
> and we are concerned with the behavior of the bridge on the DUT device:
> 
>                    DUT
>  +-------------------------------------+
>  |                 br0                 |
>  | +------+ +------+ +------+ +------+ |
>  | |      | |      | |      | |      | |
>  | | swp0 | | swp1 | | swp2 | | eth0 | |
>  +-------------------------------------+
>       |        |                  |
>   Station A    |                  |
>                |                  |
>          +--+------+--+    +--+------+--+
>          |  |      |  |    |  |      |  |
>          |  | swp0 |  |    |  | swp0 |  |
>  Another |  +------+  |    |  +------+  | Another
>   switch |     br0    |    |     br0    | switch
>          |  +------+  |    |  +------+  |
>          |  |      |  |    |  |      |  |
>          |  | swp1 |  |    |  | swp1 |  |
>          +--+------+--+    +--+------+--+
>                                   |
>                               Station B
> 
> Interfaces swp0, swp1, swp2 are handled by a switchdev driver that has
> the following property: frames injected from its control interface bypass
> the internal address analyzer logic, and therefore, this hardware does
> not learn from the source address of packets transmitted by the network
> stack through it. So, since bridging between eth0 (where Station B is
> attached) and swp0 (where Station A is attached) is done in software,
> the switchdev hardware will never learn the source address of Station B.
> So the traffic towards that destination will be treated as unknown, i.e.
> flooded.
> 
> This is where the bridge notifications come in handy. When br0 on the
> DUT sees frames with Station B's MAC address on eth0, the switchdev
> driver gets these notifications and can install a rule to send frames
> towards Station B's address that are incoming from swp0, swp1, swp2,
> only towards the control interface. This is all switchdev driver private
> business, which the notification makes possible.
> 
> All is fine until someone unplugs Station B's cable and moves it to the
> other switch:
> 
>                    DUT
>  +-------------------------------------+
>  |                 br0                 |
>  | +------+ +------+ +------+ +------+ |
>  | |      | |      | |      | |      | |
>  | | swp0 | | swp1 | | swp2 | | eth0 | |
>  +-------------------------------------+
>       |        |                  |
>   Station A    |                  |
>                |                  |
>          +--+------+--+    +--+------+--+
>          |  |      |  |    |  |      |  |
>          |  | swp0 |  |    |  | swp0 |  |
>  Another |  +------+  |    |  +------+  | Another
>   switch |     br0    |    |     br0    | switch
>          |  +------+  |    |  +------+  |
>          |  |      |  |    |  |      |  |
>          |  | swp1 |  |    |  | swp1 |  |
>          +--+------+--+    +--+------+--+
>                |
>            Station B
> 
> Luckily for the use cases we care about, Station B is noisy enough that
> the DUT hears it (on swp1 this time). swp1 receives the frames and
> delivers them to the bridge, who enters the unlikely path in br_fdb_update
> of updating an existing entry. It moves the entry in the software bridge
> to swp1 and emits an addition notification towards that.
> 
> As far as the switchdev driver is concerned, all that it needs to ensure
> is that traffic between Station A and Station B is not forever broken.
> If it does nothing, then the stale rule to send frames for Station B
> towards the control interface remains in place. But Station B is no
> longer reachable via the control interface, but via a port that can
> offload the bridge port learning attribute. It's just that the port is
> prevented from learning this address, since the rule overrides FDB
> updates. So the rule needs to go. The question is via what mechanism.
> 
> It sure would be possible for this switchdev driver to keep track of all
> addresses which are sent to the control interface, and then also listen
> for bridge notifier events on its own ports, searching for the ones that
> have a MAC address which was previously sent to the control interface.
> But this is cumbersome and inefficient. Instead, with one small change,
> the bridge could notify of the address deletion from the old port, in a
> symmetrical manner with how it did for the insertion. Then the switchdev
> driver would not be required to monitor learn/forget events for its own
> ports. It could just delete the rule towards the control interface upon
> bridge entry migration. This would make hardware address learning be
> possible again. Then it would take a few more packets until the hardware
> and software FDB would be in sync again.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> Patch is new.
> 
>  net/bridge/br_fdb.c | 1 +
>  1 file changed, 1 insertion(+)
>

Hi Vladimir,
Thank you for the good explanation, it really helps a lot to understand the issue.
Even though it's deceptively simple, that call adds another lock/unlock for everyone
when moving or learning (due to notifier lock), but I do like how simple the solution
becomes with this change, so I'm not strictly against it. I think I'll add a "refcnt"-like
check in the switchdev fn which would process the chain only when there are registered users
to avoid any locks when moving fdbs on pure software bridges (like it was before swdev).

I get that the alternative is to track these within DSA, I'm tempted to say that's not such
a bad alternative as this change would make moving fdbs slower in general. Have you thought
about another way to find out, e.g. if more fdb information is passed to the notifications ?

Thanks,
 Nik

