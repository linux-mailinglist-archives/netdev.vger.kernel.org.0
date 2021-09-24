Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641DF416FDF
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 12:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245480AbhIXKFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 06:05:40 -0400
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:43777
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245329AbhIXKFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 06:05:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaVVmV6/8Ktk6kpqYNx7rlv+xZEbKk0lW24JW9ui8OkIJocN86x2miPR1QcAxGwtYnIgKNfoZ4lVS2GJpiKkowvB1Z2OfDG/JHBwRtIVvCbjmrHk9oIOyMRjECZUuxu+GK0cIN5mFexUHDUztTn4Qw7yZ4HJg3M1d0DqWjZsypYF7I5VcXqqQf+iPA9lj8j6MWUsoMwdiU8HTFXlxDXDW/EIl1Gt8UTlLNPFy1mmm3/jmc/nkLuYxHf7gJmfTJqo4JAhZsbV+b3HtO2Uz75J9zBYoyAmAmH1/4nZQgtYA1Pyr3rga9G49AINck60pGSE/MmMyvYrV9mVoj/SX1tLNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yo4TN2Fr1ANrLmAMziIVd3z2V4OmcIz+KCk46YpMeOk=;
 b=Bkgnfvr0fdANNHr/EfTYEGtQQaXJIpBSO0e+Mfp310en8UffaoG+7Z1P/Et+FOC//1xV3yYlAtRQR9agn707IosFAuJkRfJkACQR/Khe2C+1Pee3v3Pq4A6r1fSj9DN5allI9jmsjWQBYLV478/FQRSuyExjnj+eahxYlORN75vO23wErMUCfYrYc7uOe0b2A1sVE8u1EgHzZsECP8vducBhkMChSXIpxKO9tlfaJHa6JCQMi5MuW5ulA0OW17+iV01e+yHS82+W8TDffhm9fKdFW/18dgItRurWVPim0rTxV35a3VA2dm1+8FY2P+8/x39UuIU9apLZYK++GJa2WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yo4TN2Fr1ANrLmAMziIVd3z2V4OmcIz+KCk46YpMeOk=;
 b=IqPZkxooOH8WtJNUleqvUBwHXr4roTcKvCZn6RV1dC+m623W3rGdaIiN6lgkGlsMvpnIJqHCY85yyK3YZiz7Kqh92S+yFtDPaDt6tWFRe67pQKrrHmj/CrzzOsgqyVTmtYIqkKvjCSD1KIaQWmJ/WwZI0P/x5runPUqRrtZGokv3C0mL4A5DsuBg5WZiXxMdvx92scav1Qlm4qYo+u/leh0R+aHZ5L3dIu8AhkIZ1Y05B7xuhQfL18dxdJhIzopM2bQ2Ta7dMh+LgLzTqKxVb0/Tz7YR8FAtvyvyfS2An1vIY9P4W50OwihzryxzC53s/q0wpaiP97EtLQode/8+Fg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5446.namprd12.prod.outlook.com (2603:10b6:8:3c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 24 Sep
 2021 10:04:05 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 10:04:05 +0000
Subject: Re: [RFC PATCH 0/4] Faster ndo_fdb_dump for drivers with shared FDB
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
 <20210923152510.uuelo5buk3yxqpjv@skbuf>
 <187e4376-e7bb-3e12-f746-8cb3d11f0dc4@gmail.com>
 <20210923224903.mrln22qqfdthzrvm@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <01371d1f-8fdf-4159-331e-32f2dac22445@nvidia.com>
Date:   Fri, 24 Sep 2021 13:03:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210923224903.mrln22qqfdthzrvm@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0105.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::20) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.119] (213.179.129.39) by ZR0P278CA0105.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Fri, 24 Sep 2021 10:04:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df3da72b-b606-4301-da6a-08d97f42a460
X-MS-TrafficTypeDiagnostic: DM8PR12MB5446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5446B825A1BBEAE2B631115DDFA49@DM8PR12MB5446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CmUR+u2Df1CF2xjJsHxjj+pWjZdYr/iFtquJVzRZoRBYc+DNkUVyU8hA6iwRfqGKbEz1owOzxRbqnpvttUZWOYEvL0SQTffrTVsBTCI5E2OLH58nOvwa9jLgfpiaoVpRNUuLkmHDAo/TXJ05XCexsVs/ZtrrAnJsHk4FeaSMmtlHWkWyrOjnpSGBl+C/9beIwBE/w1kmWJhVYmqNIN5B0xe2QlXxNfKfGnjxlLuM1D0ZJNA/B3pADjUZxsgCWb8Cmr4Q5iBzI2UmqAjQQeizXpoekc3T7YJ7WCPS5KccrDYRSKTEzCeZ4iWGfNxO8MdO0iiX3pU58bY3f9Is9ntVXlrT5BbyjFx1MdMRB4zpkuHZ7VECcXAMEX7+y/CuWXmLw/Flm9/t0pZ9i807SKPS0ZWTS/1WMyDncy+ilXM0y5G+YM5iIzd3fb9gdnv9KPe49LHccxNo7lxhZmSIBsGndYughY+PDNs5UL6A3WjaDQGNA4j5RMeeEtdBcjlD+zK6y8v65ZIYdpVj4dhNPHzw8tLHE6niJYo8rmoor+HWQatwfonUYzl2EB+E6dJoQW42BYjMx67RW2TU7PQoeNYMFBNm+EltQnFu6OdDW7Vk/pRwDUmpr0XVYK+x+ZwxfVMmUbOj8YDON1dh0fHbrp3hA7J1H+KaIARDbwX+QqXf+V0Dr/LmcLRuCOdNozrt6BXv26yBLGfDbZw/gqgW4qc0HdiUCq1uABJ8dWU6fvgY3YPBIJC8X9ZfK+78cpXOXCb3WoW/RBGq1d1ojk1CHCWevGRy74/ANjPCnu3YP/cppYwRkuVYEBMBCuEnJJ6+bxY7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(316002)(16576012)(31686004)(54906003)(66946007)(2906002)(8676002)(86362001)(186003)(2616005)(966005)(110136005)(508600001)(26005)(956004)(5660300002)(8936002)(83380400001)(6486002)(36756003)(6666004)(66556008)(38100700002)(4326008)(66476007)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2pIVWVQVWFDS0RJV0RrSWhNbjNWK0VPQkE2SEp3WUE3b0JOR3dBdjFoejJ6?=
 =?utf-8?B?UkVTb1UzNWFhQ3hzblNqQUJtSHhsbXZ1Z2RaY2h6UlkvTG53UFM1UFdaOFRw?=
 =?utf-8?B?ZkdZZlRSY2pWaEc2NGFuL2c2NWlWSmFrWGNCTFhGMkxkSXgwdCs3SmgrVE52?=
 =?utf-8?B?RHNGUXhVK1NjcGRvUG5JMnorVEtGb1JHK29ieCs0MnNmQnhvQms5RHR3MW5q?=
 =?utf-8?B?c3NBSUNDbW5xaUU4c3E4UkEwcnppUHVFalZPK09KSEtJVVI0eFB5bVJZaE9F?=
 =?utf-8?B?a1ZaWmpuZ1RmOTI3dEgvZm1RelppcXpFSFA1MlJ3dVlEbkZzK1NEOFlOb2JR?=
 =?utf-8?B?ZWJRZUc5Q1hoNjBwZTVKeUZCQ2kwMlpUTGM3TGV2Uzl4dmlUSXpCb2dZWlU2?=
 =?utf-8?B?dHNpMmJlYTJjTEhJbitoc3pnZy9pVFM5a2Qva3F5NW5GS3d5WE8xb3lhTzFB?=
 =?utf-8?B?U1pjSWR0WEpXdGl1NStGaWg1SEV3c05iUTZxTFRqdUFDRGc4WVlYb1lVQnE3?=
 =?utf-8?B?MVIwNkExbnNobDlHazM2aHdpZ3M1MnhXSmo2WjRGTFpPclNiN1NqUk9ZSm1q?=
 =?utf-8?B?VG1XYzlGQmRuWUtGSExodldkRVNmNmNDcGZncmJHMlhzZzVrRGU2dHhNSGMv?=
 =?utf-8?B?enpGaGJuK1JZY2lGREl1UEd0YXN1RmlwTEpZOWdZUnY0ZkhqelJ6MnRoMDIv?=
 =?utf-8?B?MldsbUd1TUUxSDBrRVFJMFNhMGxpblJjb25Vc1owSFI3UElrR2ZOamR6RnNl?=
 =?utf-8?B?aU5ZM0dnK1FLM29DTEI2U25BV0k5SVNiaUhMTzhnNndzMU5IWTgvU3RQNXVW?=
 =?utf-8?B?OFJjYVBsVzErT0tqeGFxcE1Bcm5YbWptb1JzY29hUEF6S1M0SysxSk1MT3FY?=
 =?utf-8?B?b2xYK2hudWZTbWZJOHJvekhmWkNHeG9DQWdMM2FpL2l2Q3hCTlM1TnlZRVgz?=
 =?utf-8?B?TXJrcHp3dThvTjUrL2R1NXdYNzZqWWlVOHg1ZnZ5U3gyYi9HYWtoN1NvY0NW?=
 =?utf-8?B?dEphQkhYdnV0NFMwNWx6aHJJank3UUl6ajJFSHVOdFVqY25OZHQzenVHL3hW?=
 =?utf-8?B?VHVKUkh3eFNUbFcrWmJrYXpmTE1telNYSHdmQzFzMEpkL1NQL0RpTFJCTVJU?=
 =?utf-8?B?SzE4VjVwYTFoemZ4TkxuZVR1RzhPRVQwejllU1Ftb1FGVnltYWptR2VFMG1Q?=
 =?utf-8?B?MkxiTm9KaXNTZjF2S3k3dHNzL1pXV25nMjhGSUtyM3NPY0Eza3JNK25kV3Zl?=
 =?utf-8?B?eVJmVUdnRGFKWERvSkRHZDliQS9PaGI3eGR6VkVnenZVeWpnTEowNjRva2RP?=
 =?utf-8?B?YnZXTVVlSVJkNmJKMkdGYTRSM2pPdUJwUE0zdjViSG5HN0psS0g4TEFDWmd4?=
 =?utf-8?B?ZmlYaWZnSUFMZFpDRlhIY2p3SjZjRU5lcVdGdklJRnprcXNERXM3eE9VWklj?=
 =?utf-8?B?UmdBWEo2Ymo1SHdZMGRJUUh1bWdIYlE1VDAwdTdMWVlOSEpCc1hHM3NQOGtv?=
 =?utf-8?B?WnlSaXUvYWNkYUZXSlNnaUZoYWVGVU1hbGpOYmtnNmZqQlVERVk5WmxPb0Jv?=
 =?utf-8?B?N0QrV3VpbjBMVDVRYldBUFNOYlZRdk91UVRTVHJsZGRtTzRlMFBtb2tSbFJQ?=
 =?utf-8?B?c0F6OXhjRTZEWEY1MzdyOTh4QzdNQStHc2ltaG1wTlVCUXVWelkrenpRd1Fi?=
 =?utf-8?B?MnBETDA3N1R3TFdkTFg0V2kvSlhnTVk1V0xQeTcvMGZCTlcyT3FPQ2FReVFN?=
 =?utf-8?Q?GUpCsL5wpGxrrXM7jQYSKpnv5VeB2ouVmovh97P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3da72b-b606-4301-da6a-08d97f42a460
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 10:04:05.3917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pb/IhLo8Q/O3k3pWxXgbPHtQJzX1B+3ywi3/xA2QS3QQl/DiycD4WKoQ4TIX7hD8M3YduHFRscZuUP8nujY3aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5446
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/09/2021 01:49, Vladimir Oltean wrote:
> On Thu, Sep 23, 2021 at 03:29:07PM -0700, Florian Fainelli wrote:
>>> Does something like this have any chance of being accepted?
>>> https://patchwork.kernel.org/project/netdevbpf/cover/20210821210018.1314952-1-vladimir.oltean@nxp.com/
>>
>> Had not seen the link you just posted, in premise speeding up the FDB
>> dump sounds good to me, especially given that we typically have these
>> slow buses to work with.
> 
> I didn't copy you because you were on vacation.
> 
>> These questions are probably super stupid and trivial and I really
>> missed reviewing properly your latest work, how do we manage to keep the
>> bridge's FDB and hardware FDB in sync given that switches don't
>> typically tell us when they learn new addresses?
> 
> We don't, that's the premise, you didn't miss anything there. I mean in
> the switchdev world, I see that an interrupt is the primary mechanism,
> and we do have DSA switches which are theoretically capable of notifying
> of new addresses, but not through interrupts but over Ethernet, of
> course. Ocelot for example supports sending "learn frames" to the CPU -
> these are just like flooded frames, except that a "flooded" frame is one
> with unknown MAC DA, and a "learn" frame is one with unknown MAC SA.
> I've been thinking whether it's worth adding support for learn frames
> coming from Ocelot/Felix in DSA, and it doesn't really look like it.
> Anyway, when the DSA tagging protocol receives a "learn" frame, it needs
> to consume_skb() it, then trigger some sort of switchdev atomic notifier
> for that MAC SA (SWITCHDEV_FDB_ADD_TO_BRIDGE), but sadly that is only
> the beginning of a long series of complications, because we also need to
> know when the hardware has fogotten it, and it doesn't look like
> "forget" frames are a thing. So because the risk of having an address
> expire in hardware while it is still present in software is kind of
> high, the only option left is to make the hardware entry static, and
> (a) delete it manually when the software entry expires
> (b) set up a second alert which triggers a MAC SA has been received on a
>     port other than the destination port which is pointed towards by an
>     existing FDB entry. In short, "station migration alert". Because the
>     FDB entry is static, we need to migrate it by hand, in software.
> So it all looks kind of clunky. Whereas what we do now is basically
> assume that the amount of frames with unknown MAC DA reaching the CPU
> via flooding is more or less equal and equally distributed with the
> frames with unknown MAC SA reaching the CPU. I have not yet encountered
> a use case where the two are tragically different, in a way that could
> be solved only with SWITCHDEV_FDB_ADD_TO_BRIDGE events and in no other way.
> 
> 
> Anyway, huge digression, the idea was that DSA doesn't synchronize FDBs
> and that is the reason in the first place why we have an .ndo_fdb_dump
> implementation. Theoretically if all hardware drivers were perfect,
> you'd only have the .ndo_fdb_dump implementation done for the bridge,
> vxlan, things like that. So that is why I asked Roopa whether hacking up
> rtnl_fdb_dump in this way, transforming it into a state machine even
> more complicated than it already was, is acceptable. We aren't the
> primary use case of it, I think.
> 

Hi Vladimir,
I glanced over the patches and the obvious question that comes first is have you
tried pushing all of this complexity closer to the driver which needs it?
I mean rtnl_fdb_dump() can already "resume" and passes all the necessary resume indices
to ndo_fdb_dump(), so it seems to me that all of this can be hidden away. I doubt
there will be a many users overall, so it would be nice to avoid adding the complexity
as you put it and supporting it in the core. I'd imagine a hacked driver would simply cache
the dump for some time while needed (that's important to define well, more below) and just
return it for the next couple of devices which share it upon request, basically you'd have the
same type of solution you've done here, just have the details hidden in the layer which needs it.

Now the hard part seems to be figuring out when to finish in this case. Prepare should be a simple
check if a shared fdb list is populated, finish would need to be inferred. One way to do that is
based on a transaction/dump id which is tracked for each shared device and the last dump. Another
is if you just pass a new argument to ndo_fdb_dump() if it's dumping a single device or doing a
full dump, since that's the case that's difficult to differentiate. If you're doing a single
dump - obviously you do a normal fdb dump without caching, if you're doing a full dump (all devices)
then you need to check if the list is populated, if it is and this is the last device you need to free
the cached shared list (finish phase). That would make the core change very small and would push the
complexity to be maintained where it's needed. Actually you have the netlink_callback struct passed
down to ndo_fdb_dump() so probably that can be used to infer if you're doing a single or multi- device
dump already and there can be 0 core changes.

Also one current downside with this set is the multiple walks over the net device list for a single dump,
especially for setups with thousands of net devices. Actually, I might be missing something, but what
happens if a dump is terminated before it's finished? Looks like the finish phase will never be reached.
That would be a problem for both solutions, you might have to add a netlink ->done() callback anyway.

Cheers,
 Nik






