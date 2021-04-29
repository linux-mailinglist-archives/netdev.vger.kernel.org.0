Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA53E36E7C7
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 11:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbhD2JRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 05:17:33 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:47457
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231135AbhD2JRb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 05:17:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wdhu3r9M6diePy4UjG4NIVOIOz2Bl0q/nGTqD5VZMIzv2dVT1p4a9HV9O/Rpnn1PwAXxsdxlOZseAz8Gzqh7kHtEQnzbumAgEm3JideAqpuDVdb+uN4ncSNq8Y5ASwQNxjKL4mA+oZiktFK49EFGg1TPEZ1BW0iw7Se48TXLPpr6QAAAE1B7MqcwYhywYyuaR+fhtrW5JKKQ3quWUHPQ7y/OK8hxiuAgJF4PwujmcrD+TIISlQSjVm/vsSFLt8fm7adB10Eh1l/p5Mob796vo8oirx7c3aDOmyO+ryjV2Ay8a95Em4QT2VwaBAj4HSjeYWlu1H4Kcwm2kG8wBdqq7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFITK1aL21pIIpQ42+jX0WnCiao57sobbj3r5uJKad0=;
 b=UadK/rnqa196vQfe2oeIwl7HOAVqiIIGDc5snE6+zX4zzpF2Fz9TtT/apr38wCGnK1LB/ANxOA20cmfwZicQylxRxn8pm4rZ4yQUe0ZFyuYHzBZ7/e0rS9J7mLk8AWMUtX/YwXigx4EANfsH/p1zkgJbgvtD8xO8aluuDLXktf7sPzyXHSG+Of0m8MfV1xpiojuzEH2xNZsFFa9NvfOekHZLtcpo/6RstQ5brhWreglRsu7Fj9NmyOc7+9j9LgYjUBgWNeYUNvTpUiinow/oSBqlCDdpxgoWy5Q+/zY0uypdAW95nafs7lyrM6SI+jc15lwYjDn5yuBG6CsFMFdipQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFITK1aL21pIIpQ42+jX0WnCiao57sobbj3r5uJKad0=;
 b=Zsg9x9H7Yrimz7Uq4AheUppQMaZmjmS2oWi83PJ5+ttyp7lOufJPYOgnsN6jq5M0ibSDV9QIPwBCA47vXNCY0GoYf7I8Vliul97MtJQZS8dt/RwCbzU66gQBJDvY/B6TVc/ECCbQAadpm2LFqo8PFdJD2LHyYsDkDUBscHSY2AdsipsDdDDycKav4AO7xzm8pbuZnJO3E9DiYAakYzaSWrzISxP4n2vHR/vosGgZD+QPE7uRsGpwHActBIgKYxhTQDzCRHGDdze2v/84QHFMIq90idW8vDoo9IknKQXnyKa+WeBnMLOOVHaNleyBrEegS9T5TZ/FEkDKh1hM5Twmsw==
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5166.namprd12.prod.outlook.com (2603:10b6:5:395::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 29 Apr
 2021 09:16:44 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6%2]) with mapi id 15.20.4065.030; Thu, 29 Apr 2021
 09:16:44 +0000
Subject: Re: [RFC net-next 4/9] net: bridge: switchdev: Forward offloading
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-5-tobias@waldekranz.com>
 <ac177d80-6530-be48-95bc-57652a31fe6a@nvidia.com>
 <87tunqni1d.fsf@waldekranz.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <51e241f3-cd75-44a1-f4bf-4f040dae0d7c@nvidia.com>
Date:   Thu, 29 Apr 2021 12:16:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87tunqni1d.fsf@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0126.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.173] (213.179.129.39) by ZR0P278CA0126.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Thu, 29 Apr 2021 09:16:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c2a7f09-9a69-48bc-ed58-08d90aef8192
X-MS-TrafficTypeDiagnostic: DM4PR12MB5166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5166F7A6E8CDEF6462DBCFC6DF5F9@DM4PR12MB5166.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fm9YwFqcHS8BL8L8I4NLYM2ssDD0gkrblJa0zmVBueWtWjE81YWrwPCK6bZUG6n4DcCQqKekjvJNGp/K6quCp2yArlzd1RmvlrAwKw1G3wctQvb2qlhh5/ruAsijaml2ki3bpwGk/8yBGZRY+N1ghZXJf+tPVkdkSuYJRdkx+UV2tcTmKvN9qsQlt3OTlSBywWX8cmh84mC6PmzmH3l5Pl0JoiOfARKO+3+pRlIXLOgjnGYBeENkw0DJsyzUnbQpa90J4jbwyCXihTJMwg4NITZpluUbAmBcDIq0Hif8tpd+zjrd6Qq41dr6zaXb+keJuFxDfU+UZd/yV2HwN0MyoCrgvbbgwLBZnlP81/cXRA1huighQ6dH5p3B+1YPdo8Qvryn6AO6SjcnI7oVn3RWrVTzv2N5uYmyE77vdrMuXrhkR2pPaywGgC+F25HfV6GWpgCKwMiyjYgj3e0hom5TbuorV3q/Rcik1yCFzCy1/ohEsLH4K5qZI9aW+RZh2T2fFUyP61QOADT6CQtBTbxpOiLg9u9S46OW58ZYHDJq5+n8nLK73YQ6z7wMl3cKJkFI5Pzho+mchgfXrkqC9kTJU2a+3oD2Pjx8k1H9abQzG2S65rgkET03AcbO+w5vLms+OqPKjFObGlOqZYPYhZC0CTDeA267gnaET64bu5eCOwJJPHd+H7+bHZNrWRQzPHY5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(31696002)(6666004)(26005)(86362001)(53546011)(4326008)(956004)(5660300002)(478600001)(8936002)(16526019)(2906002)(2616005)(16576012)(7416002)(186003)(83380400001)(36756003)(316002)(8676002)(6486002)(66946007)(38100700002)(66556008)(30864003)(66476007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S3dKeXV0d2ZhTWJIQVlicFVsd1I3WHdoOThqWFpKaDYxRnVVdU4vaVBpdExL?=
 =?utf-8?B?Y1pMN2NPK3lBK3BiN0RTb0JvOU95TzJMUC92MTJOeG9pSDE5RHViZWMrcVVQ?=
 =?utf-8?B?eGtJYUtmc1AxMDFwNjZHMXhrQ05sMTBHUWYvVzJpaWFwYVN0S0x0T3kzL0VR?=
 =?utf-8?B?aVZqTXM2ZDhqZDlCdDlseFVIS3lnam9WNkxjSVhXK3RjNVhEZlRpWEpsdThy?=
 =?utf-8?B?Z1VUMDdBaG1qOTRxRTNwWmdOM09mek1WNlduQTJuaHM0UmR3V0dzRHVSVDkw?=
 =?utf-8?B?MHF6c0xSUU1TUjREdVF3ek82QUU2MTc1QjN2dzRUY1dkUDliaWwwR3lhcHlr?=
 =?utf-8?B?S2hvMHF1UWk4VTY0T2Y4VFUrSDhQZ2lXZFhUbkpYYnB0blQvU00ySXVBc3dI?=
 =?utf-8?B?aUw2Qmw3aUNWU3VSeXdRQXl2eHc5Ym9zd2JSR29qMVg1dmoxSFkxaUpEMGpz?=
 =?utf-8?B?aDdmM2VXRGtVd3JqZ0l2RHFNUlBDTWs4SXRjZ3dBNzZVVElZVUVGaVBpdHVM?=
 =?utf-8?B?SStPaTdBbDQyOTQraWFuSlBOcUljVGhuZG82eVVrblMvdW13UlloMEtaRXZv?=
 =?utf-8?B?cFhieWlpelF0WUZnUjlOQ3ZMOGo2MzVKMGR0UDNQQ3BOOU5CdGNSNFVEb2Vq?=
 =?utf-8?B?c0VkaVYyeml5bmZhNm5NNlZGc0VQSmV6M2hvcXRhSWlIOXpLbEJrazkvSjlB?=
 =?utf-8?B?aEVqZjFXRm80QzdIa0tpUTBFcFF2dnNoOUdaNWszTVM1WExrWGVZbGxzVUNZ?=
 =?utf-8?B?blRSS3VGajBDSUlLLzVmUDNVTFlMVGxLVmJsaXAyc09WaFFJeGw5UnpsNmt1?=
 =?utf-8?B?bjl6U29LcTBGWFhWcnFHd1lRN3hmQUtLdmZlZWEvckEvWE5PbnZoNzNYTktj?=
 =?utf-8?B?UHVSVmk2Q0xnQy85OWRBb3BtaU53MmRXSjBlc1k5Y25jVTkxUDJ6OGwwMUYv?=
 =?utf-8?B?MnpyL2NZdE9tNnhVRmpJd21uVjM3b205NU1EYS9TY29sZEEzc2ZOVzZockpt?=
 =?utf-8?B?SmhiZ1d6VzY1TkRCbUhnQ082SVJ0UDUxQjNsSk92OHdQMXl1eWZVNmFGOVkz?=
 =?utf-8?B?aDYvT1pUU2RDeWZDQmpsMXR0N044VWVoUndRQSsrRWRNc0E4c3J4VHNKMWNy?=
 =?utf-8?B?VG1WSXNraTU4eS80bnMwNVZiQnRDa2RMZlFQa0xUNFFUTnVDanhBc3o4N3JM?=
 =?utf-8?B?VTl5UXM2RG1TRzU0NERXUmFGcFJGbUdRZGRiazUwTXB5NE1ENm1MbVR3WU1i?=
 =?utf-8?B?ODJtTUJwRllLVmxCUExObDRYa1JlMDdQRkluYkR0VkFXMEdKdmJrV3VzNTFu?=
 =?utf-8?B?dVpFK3ZRRXFyL2Z0d3JrcFBYZStLNjhaRitTUHRBRWN3Qnl2bFVIeEhkRXdI?=
 =?utf-8?B?Y1MxRkFVMjdXQ3QxM0g2QU14Y1M3SVZGMHEyTEs0Y0l3ZWtSdWlqOEFidWdV?=
 =?utf-8?B?V09tbkhIaWVzcHNHcEdWNUI4bzFBai9mWXlsaGsrdTNDQkpkb3FGYnZPanBH?=
 =?utf-8?B?cG1lTkdGak5EaUlGM2lpdE5LZk5pRzd4TmZ3bWpIQlJSTENDeCtCbHdLVUlH?=
 =?utf-8?B?M2Q1T3JBNy9XZEFuNkhtRndFVW9PT25PRkVwT3UyaDczWTIyWlNpVVZ1RzI3?=
 =?utf-8?B?R3pxTy9jd2xtZkNZT3FVWEtTRE5yNEpvTnIxb0tLRGNtRHR3TU5kSE5kV2FH?=
 =?utf-8?B?ZW9yTzBZODVPOUUvY3NLZXdUbEk3Q0tJcGRiU1FKekphTmNSUXZxeFdRcXMv?=
 =?utf-8?Q?a0TMpe6z0Dp5gPBdsUZgD/cn3whBZne2+wd8BEO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c2a7f09-9a69-48bc-ed58-08d90aef8192
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 09:16:43.9516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SfuJ0hIEolfYd7wZcvwe6qCPl0ShrUzT4UIahDG9uVnLsbLIf/2WRKojcTjli04SEeFnLuuMqCcCCiDC3mQFRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5166
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2021 01:47, Tobias Waldekranz wrote:
> On Tue, Apr 27, 2021 at 13:35, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
>> On 26/04/2021 20:04, Tobias Waldekranz wrote:
>>> Allow switchdevs to forward frames from the CPU in accordance with the
>>> bridge configuration in the same way as is done between bridge
>>> ports. This means that the bridge will only send a single skb towards
>>> one of the ports under the switchdev's control, and expects the driver
>>> to deliver the packet to all eligible ports in its domain.
>>>
>>> Primarily this improves the performance of multicast flows with
>>> multiple subscribers, as it allows the hardware to perform the frame
>>> replication.
>>>
>>> The basic flow between the driver and the bridge is as follows:
>>>
>>> - The switchdev accepts the offload by returning a non-null pointer
>>>   from .ndo_dfwd_add_station when the port is added to the bridge.
>>>
>>> - The bridge sends offloadable skbs to one of the ports under the
>>>   switchdev's control using dev_queue_xmit_accel.
>>>
>>> - The switchdev notices the offload by checking for a non-NULL
>>>   "sb_dev" in the core's call to .ndo_select_queue.
>>>
>>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>>> ---
>>>  net/bridge/br_forward.c   | 11 +++++++-
>>>  net/bridge/br_private.h   | 27 ++++++++++++++++++
>>>  net/bridge/br_switchdev.c | 59 +++++++++++++++++++++++++++++++++++++--
>>>  3 files changed, 93 insertions(+), 4 deletions(-)
>>>
>>
>> Hi,
>> Please try to find a way to reduce the number of new tests in the fast path.
>> This specific feature might help these devices, but the new tests hurt everybody else.
>> I don't mind the control plane changes, but I'd like to minimize the fast-path impact.
> 
> Wholeheartedly agree.
> 
>> Do you need "accel_priv" to be a pointer, I mean can't derive sb_dev from the port alone ?
>> Either way - you can mark the port via its internal flags if it can accelerate, those are
>> used frequently and are in a hot cache line (by the way that reminds me that the port
>> offload mark/hwdom should be moved in the first cache line).
> 
> I need to stash accel_priv somewhere as .ndo_dfwd_del_station expects it
> sent back when unregistering the offload. But there is no need for it to
> be part of the fast-path. Would it be ok to add a BR_FORWARD_OFFLOAD to
> p->flags, which would be used in the fast-path, while also keeping
> accel_priv on the port, but on a colder line?
> 

About the flag - yes, that is what I'm proposing. Use an internal port flag for it
and for the tests.

About the pointer - it is certainly not appropriate to use net_bridge_port for a void pointer
coming in from a driver or external place. I see that it's always the bridge device so can
we just compare the result of the add op to the bridge dev and set only the flag based on it?
Then on the del path if the flag is set we know it's the bridge and use it as sb_dev.

>> For example you could possibly drop fwd_accel, add the bitmap in a union with sb_dev pointer
>> in br_input_skb_cb which can be set at __br_forward at the accel check and pass it down to
>> avoid the final test.
> 
> Great idea! I will add it in v1.
> 
Actually you can also use a static key to avoid all checks and effects of this feature on
the bridge fast-path. You can enable it when the first device that can accelerate shows
up and disable it when the last one leaves.

By the way __br_forward() can take one more argument (sb_dev) and always set it because
that cache line is dirty anyway due to the tstamp zeroing, but that doesn't matter if
static keys are used. Just noting it. :)

>> Furthermore since the hwdoms are bits and if the port accel is a bit
>> you could probably reduce the nbp_switchdev_can_accel() helper to one test with a few bitops.
> 
> Not sure I follow. The current code has two tests:
> 
> 1. Is offloading enabled on the port. (To be done using p->flags in v1)
> 2. Is offloading allowed for this frame to this port.
> 
> The port can be part of a hwdom that does not support forward
> offloading; indeed only one driver would support it initially. So how do
> I avoid having to test the conditions individually?
> 

Coming to think of it with the port bit test first it should be fine.


For the sake of fun here's one way that can turn it into one test,
obviously I haven't tested anything:
 - reserve a few most significant bits of hwdom as "feature" bits, say 4
 - add a "feature" bit which encodes ability to accelerate
 => test becomes p->hwdom | (src_hwdom & hwdom_bitmask) > (accel feature bit) | p->hwdom
It's very hacky and _not_ to be used. :)

>> In nbp_switchdev_allowed_egress() I'd make the hwdom tests rely on skb's offload_fwd_mark
>> so in the software forwarding case we could avoid them.
> 
> Flipping the left and right side of the expression is possible, but I
> think that would only impact the case where the frame is _not_ allowed
> to egress. Is that what you mean? Otherwise you still need to test for
> the condition that we have forwarded to this port's hwdom already, to
> avoid sending duplicates on the wire. This is independent of
> skb->offload_fwd_mark as both Rx-offloaded and non-Rx-offloaded frames
> can still be Tx-offloaded to other hwdoms.
> 
> A typical example would be a broadcast frame ingressing the bridge from
> eth0 in the figure from the cover letter. skb->offload_fwd_mark would
> always be 0, but you still need to test fwd_hwdoms to skip over swp{1,2}
> after you have sent the skb to swp0.
> 

Yeah, you're right I was still thinking only of offloaded skbs, didn't consider
mixing the two.

>> I might be missing something above, but we have to try and reduce these tests as much as
>> possible, also the port's first cache line is quite crowded so avoiding any new fields
>> would be best, i.e. at some point we'll move the hwdom/offload mark there to avoid pulling
>> in the last cache line of net_bridge_port, so it'd be best to avoid having to move accel_priv
>> there too.
>>
>> Cheers,
>>  Nik
>>
>>> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
>>> index 6e9b049ae521..b4fb3b0bb1ec 100644
>>> --- a/net/bridge/br_forward.c
>>> +++ b/net/bridge/br_forward.c
>>> @@ -32,6 +32,8 @@ static inline int should_deliver(const struct net_bridge_port *p,
>>>  
>>>  int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>>>  {
>>> +	struct net_device *sb_dev = NULL;
>>> +
>>>  	skb_push(skb, ETH_HLEN);
>>>  	if (!is_skb_forwardable(skb->dev, skb))
>>>  		goto drop;
>>> @@ -48,7 +50,10 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
>>>  		skb_set_network_header(skb, depth);
>>>  	}
>>>  
>>> -	dev_queue_xmit(skb);
>>> +	if (br_switchdev_accels_skb(skb))
>>> +		sb_dev = BR_INPUT_SKB_CB(skb)->brdev;
>>> +
>>> +	dev_queue_xmit_accel(skb, sb_dev);
>>>  
>>>  	return 0;
>>>  
>>> @@ -105,6 +110,8 @@ static void __br_forward(const struct net_bridge_port *to,
>>>  		indev = NULL;
>>>  	}
>>>  
>>> +	nbp_switchdev_frame_mark_accel(to, skb);
>>> +
>>>  	NF_HOOK(NFPROTO_BRIDGE, br_hook,
>>>  		net, NULL, skb, indev, skb->dev,
>>>  		br_forward_finish);
>>> @@ -174,6 +181,8 @@ static struct net_bridge_port *maybe_deliver(
>>>  	if (!should_deliver(p, skb))
>>>  		return prev;
>>>  
>>> +	nbp_switchdev_frame_mark_fwd(p, skb);
>>> +
>>>  	if (!prev)
>>>  		goto out;
>>>  
>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>> index aba92864d285..933e951b0d7a 100644
>>> --- a/net/bridge/br_private.h
>>> +++ b/net/bridge/br_private.h
>>> @@ -332,6 +332,7 @@ struct net_bridge_port {
>>>  #endif
>>>  #ifdef CONFIG_NET_SWITCHDEV
>>>  	int				hwdom;
>>> +	void				*accel_priv;
>>>  #endif
>>>  	u16				group_fwd_mask;
>>>  	u16				backup_redirected_cnt;
>>> @@ -506,7 +507,9 @@ struct br_input_skb_cb {
>>>  #endif
>>>  
>>>  #ifdef CONFIG_NET_SWITCHDEV
>>> +	u8 fwd_accel:1;
>>>  	int src_hwdom;
>>> +	br_hwdom_map_t fwd_hwdoms;
>>>  #endif
>>>  };
>>>  
>>> @@ -1597,6 +1600,15 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
>>>  
>>>  /* br_switchdev.c */
>>>  #ifdef CONFIG_NET_SWITCHDEV
>>> +static inline bool br_switchdev_accels_skb(struct sk_buff *skb)
>>> +{
>>> +	return BR_INPUT_SKB_CB(skb)->fwd_accel;
>>> +}
>>> +
>>> +void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
>>> +				    struct sk_buff *skb);
>>> +void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
>>> +				  struct sk_buff *skb);
>>>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>>>  			      struct sk_buff *skb);
>>>  bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>>> @@ -1619,6 +1631,21 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
>>>  	skb->offload_fwd_mark = 0;
>>>  }
>>>  #else
>>> +static inline bool br_switchdev_accels_skb(struct sk_buff *skb)
>>> +{
>>> +	return false;
>>> +}
>>> +
>>> +static inline void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
>>> +						  struct sk_buff *skb)
>>> +{
>>> +}
>>> +
>>> +static inline void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
>>> +						struct sk_buff *skb)
>>> +{
>>> +}
>>> +
>>>  static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>>>  					    struct sk_buff *skb)
>>>  {
>>> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
>>> index 54bd7205bfb5..c903171ad291 100644
>>> --- a/net/bridge/br_switchdev.c
>>> +++ b/net/bridge/br_switchdev.c
>>> @@ -8,6 +8,26 @@
>>>  
>>>  #include "br_private.h"
>>>  
>>> +static bool nbp_switchdev_can_accel(const struct net_bridge_port *p,
>>> +				    const struct sk_buff *skb)
>>> +{
>>> +	return p->accel_priv && (p->hwdom != BR_INPUT_SKB_CB(skb)->src_hwdom);
>>> +}
>>> +
>>> +void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
>>> +				    struct sk_buff *skb)
>>> +{
>>> +	if (nbp_switchdev_can_accel(p, skb))
>>> +		BR_INPUT_SKB_CB(skb)->fwd_accel = true;
>>> +}
>>> +
>>> +void  (const struct net_bridge_port *p,
>>> +				  struct sk_buff *skb)
>>> +{
>>> +	if (nbp_switchdev_can_accel(p, skb))
>>> +		set_bit(p->hwdom, BR_INPUT_SKB_CB(skb)->fwd_hwdoms);
>>> +}
>>> +
>>>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>>>  			      struct sk_buff *skb)
>>>  {
>>> @@ -18,8 +38,10 @@ void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>>>  bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>>>  				  const struct sk_buff *skb)
>>>  {
>>> -	return !skb->offload_fwd_mark ||
>>> -	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
>>> +	struct br_input_skb_cb *cb = BR_INPUT_SKB_CB(skb);
>>> +
>>> +	return !test_bit(p->hwdom, cb->fwd_hwdoms) &&
>>> +		(!skb->offload_fwd_mark || cb->src_hwdom != p->hwdom);
>>>  }
>>>  
>>>  /* Flags that can be offloaded to hardware */
>>> @@ -125,6 +147,27 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
>>>  	return switchdev_port_obj_del(dev, &v.obj);
>>>  }
>>>  
>>> +static void nbp_switchdev_fwd_offload_add(struct net_bridge_port *p)
>>> +{
>>> +	void *priv;
>>> +
>>> +	if (!(p->dev->features & NETIF_F_HW_L2FW_DOFFLOAD))
>>> +		return;
>>> +
>>> +	priv = p->dev->netdev_ops->ndo_dfwd_add_station(p->dev, p->br->dev);
>>> +	if (!IS_ERR_OR_NULL(priv))
>>> +		p->accel_priv = priv;
>>> +}
>>> +
>>> +static void nbp_switchdev_fwd_offload_del(struct net_bridge_port *p)
>>> +{
>>> +	if (!p->accel_priv)
>>> +		return;
>>> +
>>> +	p->dev->netdev_ops->ndo_dfwd_del_station(p->dev, p->accel_priv);
>>> +	p->accel_priv = NULL;
>>> +}
>>> +
>>>  static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
>>>  {
>>>  	struct net_bridge *br = joining->br;
>>> @@ -176,13 +219,23 @@ int nbp_switchdev_add(struct net_bridge_port *p)
>>>  		return err;
>>>  	}
>>>  
>>> -	return nbp_switchdev_hwdom_set(p);
>>> +	err = nbp_switchdev_hwdom_set(p);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	if (p->hwdom)
>>> +		nbp_switchdev_fwd_offload_add(p);
>>> +
>>> +	return 0;
>>>  }
>>>  
>>>  void nbp_switchdev_del(struct net_bridge_port *p)
>>>  {
>>>  	ASSERT_RTNL();
>>>  
>>> +	if (p->accel_priv)
>>> +		nbp_switchdev_fwd_offload_del(p);
>>> +
>>>  	if (p->hwdom)
>>>  		nbp_switchdev_hwdom_put(p);
>>>  }
>>>

