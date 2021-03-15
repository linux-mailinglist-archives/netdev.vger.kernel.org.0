Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4208E33C084
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhCOPu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:50:59 -0400
Received: from mail-dm3nam07on2127.outbound.protection.outlook.com ([40.107.95.127]:48484
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229919AbhCOPui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 11:50:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+z+/6yPAe6oY84vAsWRlV3jAA+idlG6Yz9PFdBhkp75WUSA2Xksfe4GD5CWkBR695UahporLMiwdAbd7B2AYLY+k4+Jlt7pMeuC/gSCvByLx5AG+y33Rst7D1x3kT6BFv44HDPsPOH7/8vVP/Q/Q3XXmCRPWwKPpirQZrZ2P6M19ExkCLgS9/wPfrQX9uyVXpfHtGL/mYuk+mFRtrMW9DGlgwsTRYWIhztYrRDxt7cH2gB90B12mtzrj9eaRE9MokpSQBTNRjNSbHkHFNHFYzBSD+eTWnVwvIFgEzTTZASIQkbPiUyiCufZqKPb3QAJeZmeQW9iI8M4TGv5Sy64jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8Fs9Va6CVGSGzcjLmp5iCO5sMjFXFLVR8rTFffu6BE=;
 b=DP+ng8h8hz1ULebqbVQPrgl85K7OiLak66AB6tBu992HYNjLkdf276zMpvSa5vI//1NG9Jm8FAsLd51IAO/wgh50NE/xqdx+qXY6BOFz/Vv1L3i6wipmbQP5+dbitBuEFlGNqbocpDyUlqEF9TYwjF/rmg0y63eoGC/ip1V8JmTV+4rmofzlN+Po73yfOJ3uJEj8wXsjiCSjA+asQr9UUzMLdPAgl3eRHb1NM+Ea/CLb+HqzfnoGcKqWfn7reivjmmlWV/hh5/psYLjfTuqaJnUyav/rPDBXT/6p4rf9iJeLWtyNnNBYtljflINccg5ptU6Lrf6kp88w9WgJnmgZ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8Fs9Va6CVGSGzcjLmp5iCO5sMjFXFLVR8rTFffu6BE=;
 b=t60WpVgVfEG7j2QipaVmnD4SCQsjeqsEhzUtif02BLtBATFWdN0h/G4jEKFE+Q9Ct5j4ebeaL+1eiusAh0+QkYKXwOepui9zjU1zf/DcVd1MqqRMBcmh4DwyfDdtJsurk3hWJWvXoOOuHGBpbetpXU3S3Kb9fD3YEosm1Xy2xeQ=
Authentication-Results: ucloud.cn; dkim=none (message not signed)
 header.d=none;ucloud.cn; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM6PR13MB4099.namprd13.prod.outlook.com (2603:10b6:5:2a4::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.13; Mon, 15 Mar 2021 15:50:35 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80a1:dc0f:1853:9fc9]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80a1:dc0f:1853:9fc9%4]) with mapi id 15.20.3955.010; Mon, 15 Mar 2021
 15:50:35 +0000
Subject: Re: [ovs-dev] tc-conntrack: inconsistent behaviour with icmpv6
From:   Louis Peens <louis.peens@corigine.com>
To:     Marcelo Leitner <mleitner@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     "ovs-dev@openvswitch.org" <ovs-dev@openvswitch.org>,
        Paul Blakey <paulb@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>, wenxu@ucloud.cn
References: <DM6PR13MB424939CD604B0FD638A0D56C88919@DM6PR13MB4249.namprd13.prod.outlook.com>
 <189ecd92-fe8c-664d-9892-76c5b454cbc9@ovn.org>
 <YEvlysueK+eiMc1b@horizon.localdomain>
 <58820355-7337-d51b-32dd-be944600832d@corigine.com>
Message-ID: <9293ca82-e732-008e-afe8-90334afd9873@corigine.com>
Date:   Mon, 15 Mar 2021 17:50:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <58820355-7337-d51b-32dd-be944600832d@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [102.65.192.244]
X-ClientProxiedBy: LO2P123CA0091.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::6) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.113] (102.65.192.244) by LO2P123CA0091.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:139::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 15:50:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 831ed275-d1e5-4264-0a54-08d8e7ca129e
X-MS-TrafficTypeDiagnostic: DM6PR13MB4099:
X-LD-Processed: fe128f2c-073b-4c20-818e-7246a585940c,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR13MB40990A4587929AAD4FBE0471886C9@DM6PR13MB4099.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RlfFbTjUucEPbrphFgG00kapask9dM8A7WSZDZzqMBm+Ei4nBb46EW1a3QP7Ejokgx0UsnSXEUhrIQ4Hagw10QAnW7JmEMdGpJ4gNYiIcEkY8wSwRGEOGwQ3oYV7yNoONwYLs+PlJLTp997FK2Hb8l+xYDcfBYiv0dkf8hb2pHrXe8bodsShj4lOc5uVz/VtNUr4E+cCvXTwXLJufauSb2VOlLLOBINTmpGV7JYNoaid2MIb6Jgw3XUDesdH/eE66vw5nh4yL2VQflLZkqag0K3/vxW5sOezfdwQc6/nQOvNdtCbj/ApmgK00aikGWZ5g3YcIahkLyh18KCFrvpd7wYdTQ4wb4N972Trlxu77Ye5i0A572qdsUIuL4tVfA9+pqGHri4uKOiA1Zr9YVkgRV6g23A7g7emYuAObSD2P9OQ+6dbjnUivuqtzfrA8l6/zOEnbNQLGI1e2Mz0fDG1m2QbejPnbDpWFA08B6bxiyMpbMe3CRyoRpt+Ad67Wp4O8nlIfz5/xhrqzfvwb0oNH6blK10vu9Iv844NiHKyr60EOXvKGv9AM2H+5j4aDJFvbwDx9xg2lfePb7Z/G6JnpnEWzuV0VzOLQN+a0mpFv9DP9bLJx4fAy+0vOBZJ3s8rJvDN7fmgSmIrv7GAim5GKnvtEM2BbjH5rrUdP+x4kE7b+UYeYdx2NP44CLMLjHKwdkejcXpCA1dyjBSNk4sAvR6tPiEiBLM5p0l4oDjSMns=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(346002)(396003)(376002)(366004)(136003)(316002)(8676002)(30864003)(6486002)(36756003)(5660300002)(478600001)(52116002)(86362001)(110136005)(4326008)(966005)(54906003)(16526019)(2906002)(66946007)(8936002)(186003)(16576012)(6666004)(26005)(66476007)(956004)(31696002)(2616005)(83380400001)(44832011)(66556008)(31686004)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YTNEbXduMHplUVhGbEZ1M1lnOXJFZUZHRjJOeVNqOVBRTTZJMTc1SjBRODds?=
 =?utf-8?B?dzVOQWRiWjVwNkRobWRlTGRxS0NrZTF0MjJaMHk1eEJPTnhXRkdYbjFyMVVL?=
 =?utf-8?B?UXhucGZhSVJ4amw4ZmdvdzExSnBhNGJudDJFK1U2SUt4bkF6UGhIN3ZFalNR?=
 =?utf-8?B?SjVvRHd1ampBUlZrMlNwaUROc200RFVmRk9pWVV0eThoNHphcjFDM0E1OVNs?=
 =?utf-8?B?WFlybVVzMUp0Rk1mY3U0b0UrcG9nVWtucmpoTU5GR3pqL1pzNmRhQUJaTklt?=
 =?utf-8?B?U1FVbmgvRG1uU1V2VUZ2WmxiQVlEL0pFd3VwT3ZvSXV0OVZrZ1luVWJKWEta?=
 =?utf-8?B?NnBFbTI4b2EvSVg3Z2hSVXBKVkl2RW5kQ3V4US81NUF6MmdvRHdzRzN3Y0tN?=
 =?utf-8?B?NUhCdWFlMHZEZExkS1RWeE12Q3lmVy9yanptVC82VXE3czJzS2hCU3RKMW52?=
 =?utf-8?B?QkxiNEVjZWw1R3Z5dEMxK2FzbUxrMkNtWUVPWmVOSmJTVVBJd1E4TTRvN3Vv?=
 =?utf-8?B?Wk84RmlTZUhFUnhUWi9teHkyOEFvSEhXTjhCWGIyMGFSTDhBWGY1YTVaZ25U?=
 =?utf-8?B?bWp1RmRjemFJeG8vK0tXVG43UVhqamVkdCtCUHlWdnFGMVplOTVBR0hJWXkr?=
 =?utf-8?B?ejE2bStlbUxuODJmb0l1bTdJYnRmdEFva0d2d1N6YzZzUnc5RS9HZTRQQTNw?=
 =?utf-8?B?Y1VoWTNPZStaNTlmK2Fmam1DRDBDblVTZDZuQThRZFhGWGxvWCtDOFJwa0lV?=
 =?utf-8?B?VE5qZmlCZm5Na3B4VlFCSkxZUGtQSExKR0UxYmtPbXlOS0RENEtGdUJ6UXly?=
 =?utf-8?B?SGFaN0FKWWhnblFXWUJFdUdvSWNaaGRndVJuN09iL05vU3RTZWZ4U0ZMM2xQ?=
 =?utf-8?B?ZEZETlJwbFpsa0hrWllESkVmTUQyZzhNeVJLMkpEK3dwcWJkNThGWmxEcDJy?=
 =?utf-8?B?Smttd1RKWEJkR1NxbjAwY3R2U1dqNXUrM244RHduQUVZN0R6bFRLTE13MUFP?=
 =?utf-8?B?SEk0VUlueERadGdDSGoyOUFqUUx0a0tLc0d6S0I2RWc0VVMwYTJaSkt5YUpi?=
 =?utf-8?B?VmRUamd2UldZcXQ0NVRDOUUya2N2Vnltb0g1S056S09uZGRWWVBTMGdzUDk2?=
 =?utf-8?B?M0F0d2pnbFovMVdORkNyMGJ5dEo5RStNcUY3U1BaeC9BM0RnYmlZbk1xb2xZ?=
 =?utf-8?B?cUFRY3ErcytLSHpZUmNDa3pCajlJQ3FSdjV6UFhBWDMyQjd3eE9BN08yTGtk?=
 =?utf-8?B?M2pUNUdHSjg5N3BBbVY4SG1KMisxMW5mMzVMMUthSlJGNUlYeXZDdzBJTXRz?=
 =?utf-8?B?bnEvdFE5ZmtwSjJWdytZNDgvaStRbUpOalAvcm1RdTdXM0hVSEJDcXFmYUJU?=
 =?utf-8?B?eXlQeGpDTnk1ZS90NjYvOVloSW1YREtiSXRCU3pBSlhSTHRuSHNETjMvODJY?=
 =?utf-8?B?UzdEUTkvQlZsQVpSbnBDRUZKcDdCemlHb1ZtMnFvSXFJVUVDNFhJNm11VFpL?=
 =?utf-8?B?Zi9EamMwYkQwSGE2ck1kYy9xQlkySjdKbGhhSkF1WTZnSTNXcjI3WTVxbWtz?=
 =?utf-8?B?VEdoNG1kV3VMN25MK0pkL0VmWEdCakkxZ21mQXFCTG5EMkpHT2RBQmlpTnJK?=
 =?utf-8?B?dmJTT3F2cTRsenR1alA5dlpnQU5Ua2M5OTlWdkFDYkZ6Nkt1SWlndDM2bHM3?=
 =?utf-8?B?dmZvZWxTUjloOS91c2h3YlBnbHRqRUJrZys4YzZDcWZFRUh2VkwwU2djWFEz?=
 =?utf-8?Q?05Vx73KzE0UL/XAmcWsYwN9vbuBTgEQEynzzPff?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 831ed275-d1e5-4264-0a54-08d8e7ca129e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 15:50:35.7520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tg1P38iHBmuV2pZhNkbh0Y5ayZK0a3w7cKGtTJ62HmTMlWR6DrIvzsLASE+h3fljzd3m13r9aWFLXKdHMcAKJDgvpqCxgzNOWM2jBJ7TIYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies for the horrible formatting on the previous mail, I had to move email
clients and have not figured it's settings out properly yet for mailing list use.
Hopefully this is better already. I think it's still mostly possible to follow, but let me
know if I should rather resend.

Regards
Louis

On 2021/03/15 17:29, Louis Peens wrote:
> Hi Marcelo
> 
> Thanks for taking time to take a look. I've replied inline - and also found
> a bit more info, although I'm not sure if it clears things up much. I do think
> that the main problem is the different upcall behaviour, I have not figured
> out what to do about it yet.
> 
> On 2021/03/13 00:06, Marcelo Leitner wrote:
>> Hi there,
>>
>> On Wed, Mar 10, 2021 at 12:06:52PM +0100, Ilya Maximets wrote:
>>> Hi, Louis.  Thanks for your report!
>>>
>>> Marcelo, Paul, could you, please, take a look?
>> Thanks for the ping.
>> +wenxu
>>
>>> Best regards, Ilya Maximets.
>>>
>>> On 3/10/21 8:51 AM, Louis Peens wrote:
>>>> Hi all
>>>>
>>>> We've recently encountered an interesting situation with OVS conntrack
>>>> when offloading to the TC datapath, and would like some feedback. Sorry
>>>> about the longish wall of text, but I'm trying to explain the problem
>>>> as clearly as possible. The very short summary is that there is a mismatch
>> Details are very welcomed, thanks for them.
>>
>>>> in behaviour between the OVS datapath and OVS+TC datapath, and we're
>>>> not sure how to resolve this. Here goes:
>>>>
>>>> We have a set of rules looking like this:
>>>> ovs-ofctl add-flow br0 "table=0,in_port=p1,ct_state=-trk,ipv6,actions=ct(table=1)"
>>>> ovs-ofctl add-flow br0 "table=0,in_port=p2,ct_state=-trk,ipv6,actions=ct(table=1)"
>>>> #post_ct flows"
>>>> ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+new,ipv6,actions=ct(commit),output:p2"
>>>> ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+new,ipv6,actions=ct(commit),output:p1"
>>>> ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+est,ipv6,actions=output:p2"
>>>> ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+est,ipv6,actions=output:p1"
>>>>
>>>> p1/p2 are the endpoints of two different veth pairs, just to keep this simple.
>>>> The rules above work well enough with UDP/TCP traffic, however ICMPv6 packets
>>>> (08:56:39.984375 IP6 2001:db8:0:f101::1 > ff02::1:ff00:2: ICMP6, neighbor solicitation, who has 2001:db8:0:f101::2, length 32)
>>>> breaks this somewhat. With TC offload disabled:
>>>>
>>>> ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=false
>>>>
>>>> we get the following datapath rules:
>>>>
>>>> ovs-appctl dpctl/dump-flows --names
>>>> recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:drop
>>>> recirc_id(0),in_port(p1),ct_state(-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:ct,recirc(0x1)
>>>>
>>>> This part is still fine, we do not have a rule for just matching +trk, so the
>>>> the drop rule is to be expected. The problem however is when we enable TC
>>>> offload:
>>>>
>>>> ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=true
>>>>
>>>> This is the result in the datapath:
>>>>
>>>> ovs-appctl dpctl/dump-flows --names
>>>> ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:144, used:0.920s, actions:ct,recirc(0x1)
>>>> recirc_id(0x1),in_port(p1),ct_state(-new-est-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:1, bytes:86, used:0.928s, actions:drop
>>>> recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:0, bytes:0, used:never, actions:drop
>>>>
>>>> Notice the installation of the two recirc rules, one with -trk and one with +trk,
>>>> with the -trk one being the rule that handles all the next packets. Further
>>>> investigation reveals that something like the following is happening:
>>>>
>>>> 1) The first packet arrives and is handled by the OVS datapath,
>> Hmm. This shouldn't happen if hw-offload=true, because the first rule
>> should be installed on tc datapath already. Or maybe you mean OVS
>> vswitchd when you referred to OVS datapath?
>>
>> What does  dpctl/dump-flows --names -m  gives in this situation, are
>> all flows installed on dp:tc?
> 
> Yes, packet would be handled by vswitchd here, triggering the installation of datapath
> flow rules. I think I may have mixed up packet handling and flow rule installation a bit.
> These are the expanded flows:
> ovs-appctl dpctl/dump-flows --more
> ufid:65c93f06-9f09-4b62-b309-951c36d3d98a, skb_priority(0/0),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:2.080s, dp:tc, actions:ct,recirc(0x1)
> ufid:30fd8977-0bcc-41b1-8800-1262cea71005, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:drop
> ufid:c176bac4-a42d-4e8b-99d9-bce386c1be4f, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:drop
> 
> The pre-recirc rule is in tc, but the post-recirc rules are in OVS.
> 
>> triggering the installation of the two rules like in the non-offloaded
>>>>    case. So the recirc_id(0) rule gets installed into tc, and recirc_id(0x1)
>>>>    gets installed into the ovs datapath. This bit of code in the OVS module
>>>>    makes sure that +trk is set.
>>>>
>>>>     /* Update 'key' based on skb->_nfct.  If 'post_ct' is true, then OVS has
>>>>      * previously sent the packet to conntrack via the ct action.....
>>>>      * /
>>>>    static void ovs_ct_update_key(const struct sk_buff *skb,
>>>>                               const struct ovs_conntrack_info *info,
>>>>                               struct sw_flow_key *key, bool post_ct,
>>>>                               bool keep_nat_flags)
>>>>     {
>>>>             ...
>>>>             ct = nf_ct_get(skb, &ctinfo);
>>>>             if (ct) {//tracked
>>>>                     ...
>>>>             } else if (post_ct) {
>>>>                     state = OVS_CS_F_TRACKED | OVS_CS_F_INVALID;
>>>>                     if (info)
>>>>                             zone = &info->zone;
>>>>             }
>>>>             __ovs_ct_update_key(key, state, zone, ct);
>>>>
>>>>     }
>>>>     Obviously this is not the case when the packet was sent to conntrack
>>>>     via tc.
>>>>
>>>> 2) The second packet arrives, and now hits the rule installed in
>>>>    TC. However, TC does not handle ICMPv6 (Neighbor Solicitation), and explicitely
>>>>    clears the tracked bit (net/netfilter/nf_conntrack_proto_icmpv6.c):
>>>>
>>>>     int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
>>>>                                   struct sk_buff *skb,
>>>>                                   unsigned int dataoff,
>>>>                                   const struct nf_hook_state *state)
>>>>
>>>>     {
>>>>     ...
>>>>             type = icmp6h->icmp6_type - 130;
>>>>             if (type >= 0 && type < sizeof(noct_valid_new) &&
>>>>                 noct_valid_new[type]) {
>>>>                     nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>>>>                     return NF_ACCEPT;
>>>>             }
>>>>     ...
>>>>     }
>>>>     (The above code gets triggered a few function calls down from act_ct.c)
>> I don't follow this part, and it seems it would affect ovs kernel
>> dp as well. Can you please elaborate on the call chain you're focusing
>> here?
> The chain I was referring to is:
> tcf_ct_act->nf_conntrack_in->nf_conntrack_handle_icmp->nf_conntrack_icmpv6_error
> However I'm not so sure anymore that this is relevant, and yes, would probably affect
> ovs as well.
>>>> 3) So now the packet does not hit the +trk rule after the recirc, and leads
>>>>    to the installation of the "recirc_id(0x1),..-trk" rule, since +trk wasn't
>>>>    set by TC.
>> If you meant vswitchd above, this can be the problem, yes.
>> ovs_ct_update_key() is updating the key, and AFAICT that's reflected
>> on the upcall. Which, then, it's fair to assume (I didn't check)
>> vswitchd does the same.
>>
>> But for tc, +trk+inv is synthetsized when tc is trying to match again
>> on this packet, when skb_flow_dissect_ct() in it will:
>>
>>        if (!ct) {
>>                key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
>>                                TCA_FLOWER_KEY_CT_FLAGS_INVALID;
>>                return;
>>        }
>>
>> Note that 'key' here is not part of the packet in any way. The only
>> information that is stored within the packet, is
>> qdisc_skb_cb(skb)->post_ct, which ovs kernel doesn't know about. So
>> this wouldn't be reflected on an upcall, causing vswitchd to not see
>> these flags.
>>
>> IOW, an upcall right after this flow:
>> ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=no), actions:ct,recirc(0x1)
>> can be different if it's from tc datapath or ovs kernel/vswitchd
>> regarding these flags in this case.
>>
>> Makes sense? I think we're mostly on the same page on this part,
>> actually.
> I think this is what it boils down to in the end yes. I did do some bisecting of the kernel tree in the mean time:
> Just before "7baf2429a1a9 net/sched: cls_flower add CT_FLAGS_INVALID flag support" all the rules end up in
> in dp:tc, but we have have -trk and +trk as explained. Then after the commit does look to be working as expected,
> rules get's installed in tc, and only +trk set:
> ovs-appctl dpctl/dump-flows --more
> ufid:e476d5a2-3133-405c-9826-ab911c2c3240, skb_priority(0/0),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:1.890s, dp:tc, actions:ct,recirc(0x2)
> ufid:b8369209-3069-4280-9914-820d98a3a536, skb_priority(0/0),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0x2),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:1.890s, dp:tc, actions:drop
> 
> Then things go south again with this commit:
> "1bcc51ac0731 net/sched: cls_flower: Reject invalid ct_state flags rules"
> This is the point where the recirc rule is rejected by tc, and leads to the installation
> of the two ovs rules as in the dump at the start of the email.
> 
> Also, not everything is good at this commit:
> "7baf2429a1a9 net/sched: cls_flower add CT_FLAGS_INVALID flag support"
> If I add userspace rules to also match on +inv so that it isn't wildcarded I
> (with the ovs patches for tc +inv support removed) I get the same two-recirc-rule
> behaviour. I do think that it matches the current theory on the upcall behaviour.
> We will keep on digging on our side as well, this did give some more avenues
> of thought, thanks.
> 
> Regards
> Louis
>> Thanks,
>> Marcelo
>>
>>>> This is now the point where we're a bit stuck and is hoping for some ideas
>>>> on how to best resolve this. A workaround is of course just to modify the
>>>> userspace rules to not send the icmp packets to conntrack and that should
>>>> work, but it is a workaround. I think this inconsistency between TC
>>>> offload and non-TC is quite undesirable, and could lead to some interesting
>>>> results, for instance this was first detected by the observation of packets
>>>> getting stuck in a loop in the datapath:
>>>>
>>>> recirc_id(0xe),...ct_state(0/0x20),....,in_port(eth9),eth_type(0x86dd),... ,dp:tc, actions:ct,recirc(0xe)
>>>>
>>>> Where the userspace rule was doing ct to the same table instead of moving to the next table:
>>>>
>>>> ovs-ofctl add-flow br0 "table=0,in_port=eth9,ct_state=-trk,ipv6,actions=ct(table=0)"
>>>>
>>>> So far we've not managed to think of a good way to resolve this in the code.
>>>> I don't think changing the kernel behaviour would be desirable, at least
>>>> not in that specific function as that is common conntrack code. I suspect
>>>> that ideally this is something we can try and address from the OVS side,
>>>> but at this moment I have no idea how this will be achieved, hence this
>>>> email.
>>>>
>>>> Looking forward to get some suggestions on this
>>>>
>>>> Regards
>>>> Louis Peens
>>>>
>>>> PS: Tested on:
>>>> net-next kernel:
>>>>     d310ec03a34e Merge tag 'perf-core-2021-02-17' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>>> OVS:
>>>>     "cdaa7e0fd dpif-netdev: Fix crash when add dp flow without in_port field."
>>>>         +
>>>>     "[ovs-dev] [PATCH v3 0/3] Add offload support for ct_state rpl and inv flags"
>>>>     (The behaviour before and after the patch series in terms of the problem
>>>>      above is the same. Whether the recirc rules end up in the ovs datapath or tc
>>>>      datapath doesn't really matter)
>>>> _______________________________________________
>>>> dev mailing list
>>>> dev@openvswitch.org
>>>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
>>>>
