Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF672D8D50
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 14:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406694AbgLMNhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 08:37:12 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:54867 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbgLMNhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 08:37:11 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd618dd0000>; Sun, 13 Dec 2020 21:36:29 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 13 Dec
 2020 13:36:26 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 13 Dec 2020 13:36:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpaqtFWpCaD9tZr7D+8NTHYDnw0hrfW1U+uIXRHgaw6u1UavBj+S2vB3OL7yclpbDMowtEzLQKENU1eTULi2xmoRpJrWARksUo/6VsVjlHOpx1c81PC1C1x7rvu/fnsIcUT+nEhMxnSPYHpHxlaGDgvBgo4WobEj0N9tobkvZEY2pW2lCYzjc0Ijr2kFjQXKHSTyW+ysOZUjnkOygWM4BnfW+oDPz6OPz9EhIQ8ii4HXkf6Jevw3H8kTXeVzuOhCtVy+mm9QYrOSceRYEM55vMMPiop/CmTZ6Cm5zgRnR2yiAaty6QW/s7irIZPA01YK03vjSzFq1M/AWZOy0JC5zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3BmVZLVQT5qh7MuexDiudp0lgvEJbb64kOCYb2Beo0=;
 b=DRZBkBTUbcjHhnKqIRy340IVes31kejWO5C6AaZA/wrg+W5F4jY8iu4qnBqer2c1ZBKVF+4fNTUJD7A7vLXXT//nd6DsNCV4Vf55VX9O81oYChe0mpFIUezXvmhOrWmzfqeuuRMLAgi4pSRh7QlwauGZbJNRjrXSzRq70x9jEBemcupDqxODfdQosgr+oSpTukz0hRFmOerI78PM6RymCXXaai2N3Zx1Smjdk3sFA6IzGG6glxrqQOzig+/v51iVJTYA1suWcKFpoOo8RSqRpcJeyCrDm7bABVycKSzHZhTRVhqw7aYaPWjzqNWHNqnrqFZzT4tnWM3pilQZKQSACQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM5PR1201MB0220.namprd12.prod.outlook.com (2603:10b6:4:4e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.19; Sun, 13 Dec 2020 13:36:24 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3654.021; Sun, 13 Dec 2020
 13:36:24 +0000
Subject: Re: [PATCH v2 net-next 1/6] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
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
 <85b824ea-5f43-b483-55b6-4ffd0e8275d8@nvidia.com>
Message-ID: <562e27af-ff7a-8dad-4303-19edd5b15af8@nvidia.com>
Date:   Sun, 13 Dec 2020 15:36:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <85b824ea-5f43-b483-55b6-4ffd0e8275d8@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::18) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.216] (213.179.129.39) by ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.19 via Frontend Transport; Sun, 13 Dec 2020 13:36:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6336e2d0-075a-4629-60b6-08d89f6c15c3
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02201EDA31B06BA03155A825DFC80@DM5PR1201MB0220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UoAvAggVQ1R5BOrNGouFRwicrOLLApl6CxetgpDwamjcLDL0HiESFuI78fbsBmengZqN7NbbW9+gIoRh/yXL98LQP8yBKuhqHZHdpwpdd1m5gmoYiagBi7R4fpYG8TN941lQurWis0OGLPEvk6prcS7h0bMpehWKc1sjmTo3bncq1isXiPnJ0NCjIorZ7br3/jNQsi0MEVkbZJATxvCMoOp5ek8eX04dHHXLY2H6WArElIWGAajHNrENQSv87IHdQff8cHJw6lmUl0E7+gkI5VV0O0p8XlFMyFBGLAcEkDL/9geqxaW0WGxRmWVbsOKrK1N18T8Vug+l4WOy6OyqgqZ6wYjzZHBkiZHCk4uEShLASqm/VsPosk+DD0XnVN7lMrLwjMR41xegkP6wglbA37P9+nSkCTafgrwI5njC+QmGZnw+X8Wx4tBHNIEaIjjH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(66476007)(54906003)(86362001)(31696002)(508600001)(956004)(4326008)(16576012)(83380400001)(31686004)(6486002)(53546011)(8936002)(6666004)(36756003)(110136005)(66556008)(26005)(7416002)(2616005)(5660300002)(921005)(66946007)(8676002)(2906002)(16526019)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S1Q2dkxsMDBnWUZjZlNab3JCc25jVUpaSENQYmtmNXlBand1ZXJLazlTYnc3?=
 =?utf-8?B?SDQyZ3NQWmJBVHpVNWZDeThnWFl3VTdMeHFaS1MwSU9hRzg3S015d3VGQ1Bi?=
 =?utf-8?B?V3hnYmlDelpCSmRLU2tDbXd5NGlZbm5JTXJyRUdYaVdIOXFJWHBVNXkrQW4w?=
 =?utf-8?B?SVRtZTdGQXQwb1pSeFVYdlEyR3JEL0IxeHFEUitCNjF3L2hlT0ZkOTUyUkZR?=
 =?utf-8?B?dGErZWZ6djlKa1NPY0Q0UE1Fd01ERHF2RVVLM2xTZ3NuUDE0c0VNempUZnEz?=
 =?utf-8?B?UjlDZXZVRHYzZ2k5VU8yVXpkR1dIMjFJWFZmV0ZwUjZBaGw2NHV6UkJNbGhH?=
 =?utf-8?B?b3Q4TFVNREx2ZWxJdU9lRmpaZ1pQckI4TC9kWlBpZ0pXcldYRTZvRkVNdi95?=
 =?utf-8?B?clVEZm9yVnI2Tjd0QUJNNmZFVmZwaSswMkRUTHVBWktwV3dWV3VrbnZrN21M?=
 =?utf-8?B?Vlk4QzZnendIQ3JXMElUVEV5MElQS09qUnpLaFg0c01oQXR3RXM4dTdrczVR?=
 =?utf-8?B?c3F5MkJmWFhhenF4djRLOTVkUVdBU0dpdkNQSC9ncGFUVmZ0aDlLVXdETnpO?=
 =?utf-8?B?Y1ZTMisyNGN2dmU2OWFpeEhHbkt0eERpbWluMDA4ckE4eGwyb0RnVzRHL3Zl?=
 =?utf-8?B?NUJPQldyN0RkSllYT1dBMldsK3A0c0dDaG5zVUc2WklWVlJXNmJ3NkczOHdn?=
 =?utf-8?B?WUpWL01MbmJNZlFUaUlha3NaSmFqWmlLS2tZeGFhWHR2SVBUeThvSTRQektJ?=
 =?utf-8?B?UkN3bi9xaFhJV2JGUDZCR1ZFdGxrUnRVT2l5azZ5ZGI3a1VrZk1XYUF2bEl1?=
 =?utf-8?B?QTFaMmFmU2RKY2hRREd2V1I2SHB3OTZXQ1VNWjUvVWtLa3cwa3BEY1U3eDQ4?=
 =?utf-8?B?N2Z1U3J0ZmZCMHBDM2czcytHeU9maEFtdlpVemNtREpYc1N2SHJLdHdwa1gz?=
 =?utf-8?B?bSsxeTRuUjdLUUZHc0ZMQkNjZ3puU1Jpalh0YUwwTnFTSy9HOXROSEVGOG10?=
 =?utf-8?B?aWxleWpDRUlTSGlUaGtVNzgySlJjUTE1cFlTK1N4T1g0dU9nTEtmc0NlWTJ1?=
 =?utf-8?B?YXJ4L3dQRG5UaXpQV1RQSXRwZjVHUTR3K0ZkbXhTaVUzVU9Nbm5KeFZPdmV5?=
 =?utf-8?B?dkVpNTRaNmxCaU5KdXg1UHZBczBqODZYQUtLZno2cWprOTQ4QUF2OHRqWGNH?=
 =?utf-8?B?Sk80eW50dHNJMXA3N3gzUEFGRFZkU2RPN3VYV0Rjb3VST1J6MEJiKzI5QXhN?=
 =?utf-8?B?ekRYZEk3Q0EveXpJaGtxczBQeVlmdUdGclJkYlZaS0k1bThFankwOFY4SlJn?=
 =?utf-8?Q?FrLKSp3QdRkAEismHPC3MJDrYicaJ5i+Jz?=
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 13:36:24.2445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: 6336e2d0-075a-4629-60b6-08d89f6c15c3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O34PCrN0NRpHP73Hs88tGpypJOzwNe5Q3PECAd3Hc+nReLOFvnbM5cQN4XUKAdsGFE0qGLuAxhR6tRhjRa2vDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0220
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607866589; bh=h3BmVZLVQT5qh7MuexDiudp0lgvEJbb64kOCYb2Beo0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:From:To:CC:References:Message-ID:
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
        b=fA9GaAKgJ9ZTedgK56INt7aeXSDqBkef3P5z0b1dKNbkhPwlowNrEdNoY5l/pzEW+
         FLta0Wpyj79rIoHCNgGaiPaNBAM9agfGTyBcI4NIh4+G2fNAYpljIY+l1R5s4jkVc3
         BFw4Ms/xVHdc67mDMrnmptAeC7NPY6Y4Ot9qDOYhVYBjjAqfJQ/RhzgyYbpaSUMKCu
         u0hCQWEmq8NjO7Wr2uusJ0U8HYy4UTwDK9l/xxuoONUBje4lb3JWggETd6hZXW34oN
         CWPHfUWVglG3o1Djt1phO78g2bchV5eKGckkss+KyHCn43Xvre/IqHomY6O1ulE8Yg
         3EMKy7gaodzuQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/12/2020 15:22, Nikolay Aleksandrov wrote:
> On 13/12/2020 04:40, Vladimir Oltean wrote:
>> Currently the bridge emits atomic switchdev notifications for
>> dynamically learnt FDB entries. Monitoring these notifications works
>> wonders for switchdev drivers that want to keep their hardware FDB in
>> sync with the bridge's FDB.
>>
>> For example station A wants to talk to station B in the diagram below,
>> and we are concerned with the behavior of the bridge on the DUT device:
>>
>>                    DUT
>>  +-------------------------------------+
>>  |                 br0                 |
>>  | +------+ +------+ +------+ +------+ |
>>  | |      | |      | |      | |      | |
>>  | | swp0 | | swp1 | | swp2 | | eth0 | |
>>  +-------------------------------------+
>>       |        |                  |
>>   Station A    |                  |
>>                |                  |
>>          +--+------+--+    +--+------+--+
>>          |  |      |  |    |  |      |  |
>>          |  | swp0 |  |    |  | swp0 |  |
>>  Another |  +------+  |    |  +------+  | Another
>>   switch |     br0    |    |     br0    | switch
>>          |  +------+  |    |  +------+  |
>>          |  |      |  |    |  |      |  |
>>          |  | swp1 |  |    |  | swp1 |  |
>>          +--+------+--+    +--+------+--+
>>                                   |
>>                               Station B
>>
>> Interfaces swp0, swp1, swp2 are handled by a switchdev driver that has
>> the following property: frames injected from its control interface bypass
>> the internal address analyzer logic, and therefore, this hardware does
>> not learn from the source address of packets transmitted by the network
>> stack through it. So, since bridging between eth0 (where Station B is
>> attached) and swp0 (where Station A is attached) is done in software,
>> the switchdev hardware will never learn the source address of Station B.
>> So the traffic towards that destination will be treated as unknown, i.e.
>> flooded.
>>
>> This is where the bridge notifications come in handy. When br0 on the
>> DUT sees frames with Station B's MAC address on eth0, the switchdev
>> driver gets these notifications and can install a rule to send frames
>> towards Station B's address that are incoming from swp0, swp1, swp2,
>> only towards the control interface. This is all switchdev driver private
>> business, which the notification makes possible.
>>
>> All is fine until someone unplugs Station B's cable and moves it to the
>> other switch:
>>
>>                    DUT
>>  +-------------------------------------+
>>  |                 br0                 |
>>  | +------+ +------+ +------+ +------+ |
>>  | |      | |      | |      | |      | |
>>  | | swp0 | | swp1 | | swp2 | | eth0 | |
>>  +-------------------------------------+
>>       |        |                  |
>>   Station A    |                  |
>>                |                  |
>>          +--+------+--+    +--+------+--+
>>          |  |      |  |    |  |      |  |
>>          |  | swp0 |  |    |  | swp0 |  |
>>  Another |  +------+  |    |  +------+  | Another
>>   switch |     br0    |    |     br0    | switch
>>          |  +------+  |    |  +------+  |
>>          |  |      |  |    |  |      |  |
>>          |  | swp1 |  |    |  | swp1 |  |
>>          +--+------+--+    +--+------+--+
>>                |
>>            Station B
>>
>> Luckily for the use cases we care about, Station B is noisy enough that
>> the DUT hears it (on swp1 this time). swp1 receives the frames and
>> delivers them to the bridge, who enters the unlikely path in br_fdb_update
>> of updating an existing entry. It moves the entry in the software bridge
>> to swp1 and emits an addition notification towards that.
>>
>> As far as the switchdev driver is concerned, all that it needs to ensure
>> is that traffic between Station A and Station B is not forever broken.
>> If it does nothing, then the stale rule to send frames for Station B
>> towards the control interface remains in place. But Station B is no
>> longer reachable via the control interface, but via a port that can
>> offload the bridge port learning attribute. It's just that the port is
>> prevented from learning this address, since the rule overrides FDB
>> updates. So the rule needs to go. The question is via what mechanism.
>>
>> It sure would be possible for this switchdev driver to keep track of all
>> addresses which are sent to the control interface, and then also listen
>> for bridge notifier events on its own ports, searching for the ones that
>> have a MAC address which was previously sent to the control interface.
>> But this is cumbersome and inefficient. Instead, with one small change,
>> the bridge could notify of the address deletion from the old port, in a
>> symmetrical manner with how it did for the insertion. Then the switchdev
>> driver would not be required to monitor learn/forget events for its own
>> ports. It could just delete the rule towards the control interface upon
>> bridge entry migration. This would make hardware address learning be
>> possible again. Then it would take a few more packets until the hardware
>> and software FDB would be in sync again.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> ---
>> Changes in v2:
>> Patch is new.
>>
>>  net/bridge/br_fdb.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
> 
> Hi Vladimir,
> Thank you for the good explanation, it really helps a lot to understand the issue.
> Even though it's deceptively simple, that call adds another lock/unlock for everyone
> when moving or learning (due to notifier lock), but I do like how simple the solution
> becomes with this change, so I'm not strictly against it. I think I'll add a "refcnt"-like
> check in the switchdev fn which would process the chain only when there are registered users
> to avoid any locks when moving fdbs on pure software bridges (like it was before swdev).
> 
> I get that the alternative is to track these within DSA, I'm tempted to say that's not such
> a bad alternative as this change would make moving fdbs slower in general. Have you thought
> about another way to find out, e.g. if more fdb information is passed to the notifications ?
> 
> Thanks,
>  Nik
> 

Nevermind the whole comment. :) I was looking at the wrong code and got confused.

All is well (thanks to Ido).

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

