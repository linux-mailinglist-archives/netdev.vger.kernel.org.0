Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46FD3DD321
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhHBJmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:42:36 -0400
Received: from mail-dm6nam10on2052.outbound.protection.outlook.com ([40.107.93.52]:55200
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231625AbhHBJmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 05:42:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErToyhAFhxKY4vm8AlM8Yu5uvTHjbPem10FVpYqpL5CGSAGeSD/fb+FQCneEbhaePrkEyIVtr103QIH7kPHuUXDnsU2/enLxHs+PjdLNvtGfC5c38OViSE51GrTzDIDW4Kytyy+Ddsa5oGUFnmyHpUfWOLVgCje53Kcx/lrr/SMy5410e0PRA2ENsbg/vIKTO2HCNh2jb+bpquU24BguBaU+vvalb1pAL43E+7H5VYfvfBsX83Ki4R5lR9Sg01jk+AQ6WPFxI6BblHOE/rAgGyZtspqEFjT7+S0LZ8OJS9vQj/rpkqDvgGk19BJkH9q7WS30qM7Rxk2P0dX6dRkPMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdfBQiRbvEzTKLWAMACT49YLZktqfP+SfDTnzt0zsCA=;
 b=aFybIa7ESTJ3Svm3af7VUz4fJArORgaLTfrAtifuYXgMzSNNvFASmXcaHotGugzWVspKPd1jVf83hbDF8MwHtiIUXRQDeFouKKsxOKwT4dLQ+h7C7ZEt4NzuVR1Phw23ZyRVHLCdle9Ptr8WmJpmltSdXLHjepKreSssIdRikX4t+1GQKNw5uZDkbUoz6nCBmVuYjLeLd58tPkY1vFA5PwT10hz3Q9Qiq7TG0XwUe8ge561H/7b5B+kuNQWB8agj1sWITL7HaD8N/ouK8tm6h+8vKWtDtMMxk24stYxiXNKbrsUHUF8d97RCJSc36XE7IGOTkC3tijzXFt13nTFCVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdfBQiRbvEzTKLWAMACT49YLZktqfP+SfDTnzt0zsCA=;
 b=tbLlMp8zlhCFLshlg+1gBNXncn3waPQXIGhV+MaedmMq5GGEzgAixW0jY73P8R6V3gpGCExxguQNzE+142JABVDj6NgJQIMuvfIs0s96HR7YSYJ2nRpSm63VuwzTSEyPWfiI68lEoM6zDXgKwnDok+c+CaXNIHQBji06GG+a3+gtXO6yzmfkC5qlo1aD2dIZb3ff/Mh3jXypbhqlEglF4kdft9t9Fxp4Q/NPRMymWj+6H5oii5pLVjh0foBF+HObABcUhhAWZn3nag3Euk8p9RthjdxHeUiqlIjdoxAvbi8SyW2NGDDy0qBHvfDtDnKFNchVpsw400TBUHHWz0sy6g==
Authentication-Results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5261.namprd12.prod.outlook.com (2603:10b6:5:398::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Mon, 2 Aug
 2021 09:42:25 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 09:42:25 +0000
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com" 
        <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <ff6d11a2-2931-714a-7301-f624160a2d48@nvidia.com>
 <20210802092053.qyfkuhhqzxjyqf24@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <451c4538-eb77-2865-af74-777e51cd5c31@nvidia.com>
Date:   Mon, 2 Aug 2021 12:42:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210802092053.qyfkuhhqzxjyqf24@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0144.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.206] (213.179.129.39) by ZR0P278CA0144.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 09:42:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68943de9-971e-448e-ecbe-08d95599d5a3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5261:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB52618AC27A35C0FB2F03ACB5DFEF9@DM4PR12MB5261.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SJt/bFEAZcfEIXTxJAE8pzjB97BcgcUrhyXHD0kAwfj7blQe48fZ6I/xnHcNqNHUEJm0qelQueoQ6qWXe7R290kmEcTGXztu85RE+dFEGSwUViorsqeaO0uY5QWTjFzcixRM8GJElBI9nB873B9fyN0uol/ZtRPXRcW2nFRTVR5MC70echiGEZ41PkO2oJgZV/KW8hoB2DTEdahA5j+D5q7GvYmUmyJ485BqDqKbMLgdLzoh67ZZ49iQz2P2wlPBhmxzfzVUtH0ciMlBcaUtrpX2cWi5x2TVnEmFyha6FRKTeSpBS/XV28EVcHH9Ua3n5Gg9ceXy4mJBQ+NcSbFchI2GUUOdITOrOxEoXJS0sLJjIQO1auX+Wq6qY3UqeKfQ/Y7ikfdUK2jK5KGBTvHSVpGSvHDDFSzZoKPCyd6qQLuImzc7hcMn0ZD980pprEMRwtYFAbbY+/CZF306/qf1md8TnSw59q/ynONzkqoAOXQBazzn+A4IAY9n8tC3vMl/KCk68eY9gdW/C+Kaus/5V3T+jWbIBOJ0hVsuGfXqOaNKbsCZEZGTTabnwBfSu4jHrlmAqypPpCA7fwny98pLzfbXqTbAmBQSSEgUBt1eD/duYMMSuhX7WFZvw1r//2i65GBSyVnTb7dBe7QptWbUnFoYRfmp0q7dEJwrMUt6v7sGJGQtUJnShg87UW12eO2OPjaAlkgYh6kUSIKj4D1yOXE/AUBRF4+VHef/WiPFPX6cIGEsMjIA8rFMEYGYTTuW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(5660300002)(83380400001)(478600001)(956004)(2616005)(6916009)(86362001)(6666004)(31696002)(31686004)(6486002)(36756003)(66946007)(66476007)(66556008)(26005)(8676002)(53546011)(186003)(54906003)(16576012)(4326008)(316002)(8936002)(38100700002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDlXd05UM0Y5aEgrcldkTXZ3ZlcrWTlUWU5NVy9WYkZFaEkxbGlUdjZoUk15?=
 =?utf-8?B?bE52MVU2dUpibHcxRkRmSWJJMnBRVTlpQXZ2WElDK1VGT1AvNlEvWGNURjA1?=
 =?utf-8?B?RU1DNDFZeHVZRFRCT2VQa1FHdXgvY2dpYU0zLy92SjQ0OS8vMnU5VzlyQ3FR?=
 =?utf-8?B?b1gwLzBYQTRmSmlsR2RUb1RsdkhNYUZhY2F5K2ROa01Kb3hLRm91UXhYTWZQ?=
 =?utf-8?B?N20zbU9kK0pQdFFXWDgvcWc5L1EzOW5NeStGRXdJMFFiK3ZxZlhucitTS1J5?=
 =?utf-8?B?MmVQTzlFWGtHeGZzd3Y4MmJMdWoxOUJkUWFFQmdsM2NLQm5KajBjRE5OZEtZ?=
 =?utf-8?B?L3pTWEV3Zjh4VFVKWDFFVHVOc0ZpeGxjbXd5Uis5a3BhUkhJMklnaE5RM1Z5?=
 =?utf-8?B?S3dBdk9YVGVUWlROdlhpc1g2OWVCOXZ2K0FEWTdmbEUxY2twR0k1bE5FSnkv?=
 =?utf-8?B?MGlRRHVWWnE3MmtZelBCRWd0Yk9JSDN2cEdKcUJMalFqS0krVVJVR2RiZ21V?=
 =?utf-8?B?MDBUdGYydzVjajZHRWF4WXJSSHFlMlFZUzdScmVqYmNFaWRaUkhVYkJCQW5D?=
 =?utf-8?B?WHFRZGhhS25xN3dERWxIcXlXLzM2YWxZSFgwUkg4N0tBbk9udVFIcjQ3Q254?=
 =?utf-8?B?T2tLNkU0ZUk2dUJzbjBMcFg3dzVOblNzM2RBTlRNQThJcEFPUUljemJCWVZM?=
 =?utf-8?B?SVlQY3pTdUIzUmpoSm1qQTNZQ2ZhLzgwWHZxUkxick5KMHZXS3Jmc21wZWFh?=
 =?utf-8?B?SlRSdkxSWWZyMDhlcWdxVDU3QTVaK1FMSUsyUnhwMWR6K24wVERER3k2Mkdo?=
 =?utf-8?B?eHdON3JTSjY5NmtOa3llLzR0THNlam1OT0lzMnc5RW11M1lSeTk3Z3A4b244?=
 =?utf-8?B?VE9kYnRpVnpVRHVJaWRKMW5XRW1FVVRsaWEwa1prdlFzRGRmT1B2bXVvOXFm?=
 =?utf-8?B?bTNHM0NjYUpncnYwblM2L0NaWGxlUUttcGZhaVpSQ1NWRHIwUTZlN0IybkFp?=
 =?utf-8?B?VEg1bVVTZHZneEhSSTJaM0hBUXZpUHlRQ1lVU1c4Vys0U05PMUdYUWk5YlR0?=
 =?utf-8?B?cVNncGhYV1dPeTgxL1NSS0dFdnhBejhUUWY2ZDEyc0llTndteHc0MUMwRXky?=
 =?utf-8?B?SVpQQWRDZWgzSDdNVC9RMDlReDdzcVQ2RlFENXZ2b1Y1eDk5RGhsRDNYVUs4?=
 =?utf-8?B?MVdZSzFSY2szenJPUGVBclkrNzdCMTQ0OE9JYWNQS1BDRVM3R0l4MWxMRkNw?=
 =?utf-8?B?UVFmQlNqZW92TmVKYVlGOHY0VXZnM29RT3YyQWwrcjZ6NnhtOXdWRzlKVktO?=
 =?utf-8?B?Y1pXYmc1VXVRd1lNS3VHbFhJREtLeGJlMG02UDdkZXNURjN6dnArb2tNNDEx?=
 =?utf-8?B?RzYzWHh1N2tLMi8zaG1vY0JlWnVHdU9oOGN6Rmh5VHhFS3RiTVF0Z2JOOTRt?=
 =?utf-8?B?RUpnTlE2NlZWTENMdXBOZ3VwRk11emZZNFF6dzhoTDNNY0VQK0JzUlpOYXBY?=
 =?utf-8?B?VUpGVmFuU3VZYVhoTVJGSEExSXBtenJDNHhnZ0d5Uk9UT0hublg5ZWlGeUx6?=
 =?utf-8?B?TUt3bDRBajI4cTB0QjhjTWdHY2dSZHdiVHBWcUlhSzl6aXZIdG00Q2t4eVc5?=
 =?utf-8?B?L29kSzk2VHRGRUZrcVZvVmEwNTBUayt4UjNGWXVvbS9EdGlsaEJldU0xTjhZ?=
 =?utf-8?B?ZTlZaGYxQ2pVWTdGVzVnQ1pEeFp5V3VBUTRBdEdOZEo5QS9tUnBmZDgvdVZV?=
 =?utf-8?Q?QoCcIyH1CfJFlj60oyisl8znHmGhC3Bhasf1M2v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68943de9-971e-448e-ecbe-08d95599d5a3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 09:42:25.3666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CwrpCMkAimLGDdRc2VyduLySuuHYhlXG8NObkJxtDmWsNqbpiXZIJylVq0p/fbRaAPqJXMaa53DqbE/PlUHPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5261
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/08/2021 12:20, Vladimir Oltean wrote:
> On Mon, Aug 02, 2021 at 10:42:41AM +0300, Nikolay Aleksandrov wrote:
>> On 02/08/2021 02:17, Vladimir Oltean wrote:
>>> Currently it is possible to add broken extern_learn FDB entries to the
>>> bridge in two ways:
>>>
>>> 1. Entries pointing towards the bridge device that are not local/permanent:
>>>
>>> ip link add br0 type bridge
>>> bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn static
>>>
>>> 2. Entries pointing towards the bridge device or towards a port that
>>> are marked as local/permanent, however the bridge does not process the
>>> 'permanent' bit in any way, therefore they are recorded as though they
>>> aren't permanent:
>>>
>>> ip link add br0 type bridge
>>> bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn permanent
>>>
>>> Since commit 52e4bec15546 ("net: bridge: switchdev: treat local FDBs the
>>> same as entries towards the bridge"), these incorrect FDB entries can
>>> even trigger NULL pointer dereferences inside the kernel.
>>>
>>> This is because that commit made the assumption that all FDB entries
>>> that are not local/permanent have a valid destination port. For context,
>>> local / permanent FDB entries either have fdb->dst == NULL, and these
>>> point towards the bridge device and are therefore local and not to be
>>> used for forwarding, or have fdb->dst == a net_bridge_port structure
>>> (but are to be treated in the same way, i.e. not for forwarding).
>>>
>>> That assumption _is_ correct as long as things are working correctly in
>>> the bridge driver, i.e. we cannot logically have fdb->dst == NULL under
>>> any circumstance for FDB entries that are not local. However, the
>>> extern_learn code path where FDB entries are managed by a user space
>>> controller show that it is possible for the bridge kernel driver to
>>> misinterpret the NUD flags of an entry transmitted by user space, and
>>> end up having fdb->dst == NULL while not being a local entry. This is
>>> invalid and should be rejected.
>>>
>>> Before, the two commands listed above both crashed the kernel in this
>>> check from br_switchdev_fdb_notify:
>>>
>>
>> Not before 52e4bec15546 though, the check used to be:
>> struct net_device *dev = dst ? dst->dev : br->dev;
> 
> "Before", as in "before this patch, on net-next/linux-next".
> 

We still need that check, more below.

>> which wouldn't crash. So the fixes tag below is incorrect, you could
>> add a weird extern learn entry, but it wouldn't crash the kernel.
> 
> :)
> 
> Is our only criterion whether a patch is buggy or not that it causes a
> NULL pointer dereference inside the kernel?
> 
> I thought I'd mention the interaction with the net-next work for the
> sake of being thorough, and because this is how the syzcaller caught it
> by coincidence, but "kernel does not treat an FDB entry with the
> 'permanent' flag as permanent" is enough of a reason to submit this as a

Not exactly right, you may add it as permanent but it doesn't get "permanent" flag set.
The actual bug is that it points to the bridge device, e.g. null dst without the flag.

> bug fix for the commit that I pointed to. Granted, I don't have any use
> case with extern_learn, so probably your user space programs simply
> don't add permanent FDB entries, but as this is the kernel UAPI, it
> should nevertheless do whatever the user space is allowed to say. For a
> permanent FDB entry, that behavior is to stop forwarding for that MAC
> DA, and that behavior obviously was not taking place even before any
> change in br_switchdev_fdb_notify(), or even with CONFIG_NET_SWITCHDEV=n.
> 

Actually I believe there is still a bug in 52e4bec15546 even with this fix.
The flag can change after the dst has been read in br_switchdev_fdb_notify()
so in theory you could still do a null pointer dereference. fdb_notify()
can be called from a few places without locking. The code shouldn't dereference
the dst based on the flag.

I'm okay with this change due to the null dst without permanent flag fix, but
it doesn't fully fix the null pointer dereference.



