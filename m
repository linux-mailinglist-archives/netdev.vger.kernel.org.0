Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8CD478990
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 12:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhLQLNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 06:13:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:35132 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhLQLNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 06:13:18 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1myBAp-000BeB-6n; Fri, 17 Dec 2021 12:13:15 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1myBAo-000OBl-VZ; Fri, 17 Dec 2021 12:13:15 +0100
Subject: Re: [RFC PATCH v2 net-next] net: Preserve skb delivery time during
 forward
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
References: <20211215201158.271976-1-kafai@fb.com>
 <CA+FuTSdR0yPwXAZZjziGOeujJ_Ac19fX1DsqfRXX3Dsn1uFPAQ@mail.gmail.com>
 <20211216222332.fltkclu4x3udpomr@kafai-mbp.dhcp.thefacebook.com>
 <CA+FuTSfsrMUAz-5Huf2j4f35ttqO5gpFKvsn4uJLXtRPqEaKEg@mail.gmail.com>
 <ca11f6f6-86f9-52c9-4251-90bf0b6f588a@iogearbox.net>
 <20211217073351.k4thkro443m3fnme@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <32c53d3c-8393-c5ba-4a43-6e40bd2ed258@iogearbox.net>
Date:   Fri, 17 Dec 2021 12:13:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211217073351.k4thkro443m3fnme@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26390/Fri Dec 17 10:20:34 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/21 8:33 AM, Martin KaFai Lau wrote:
> On Fri, Dec 17, 2021 at 12:42:30AM +0100, Daniel Borkmann wrote:
>> On 12/16/21 11:58 PM, Willem de Bruijn wrote:
>>>>>> @@ -530,7 +538,14 @@ struct skb_shared_info {
>>>>>>           /* Warning: this field is not always filled in (UFO)! */
>>>>>>           unsigned short  gso_segs;
>>>>>>           struct sk_buff  *frag_list;
>>>>>> -       struct skb_shared_hwtstamps hwtstamps;
>>>>>> +       union {
>>>>>> +               /* If SKBTX_DELIVERY_TSTAMP is set in tx_flags,
>>>>>> +                * tx_delivery_tstamp is stored instead of
>>>>>> +                * hwtstamps.
>>>>>> +                */
>>>>>
>>>>> Should we just encode the timebase and/or type { timestamp,
>>>>> delivery_time } in th lower bits of the timestamp field? Its
>>>>> resolution is higher than actual clock precision.
>>>> In skb->tstamp ?
>>>
>>> Yes. Arguably a hack, but those bits are in the noise now, and it
>>> avoids the clone issue with skb_shinfo (and scarcity of flag bits
>>> there).
>>>
>>>>> is non-zero skb->tstamp test not sufficient, instead of
>>>>> SKBTX_DELIVERY_TSTAMP_ALLOW_FWD.
>>>>>
>>>>> It is if only called on the egress path. Is bpf on ingress the only
>>>>> reason for this?
>>>> Ah. ic.  meaning testing non-zero skb->tstamp and then call
>>>> skb_save_delivery_time() only during the veth-egress-path:
>>>> somewhere in veth_xmit() => veth_forward_skb() but before
>>>> skb->tstamp was reset to 0 in __dev_forward_skb().
>>>
>>> Right. If delivery_time is the only use of skb->tstamp on egress, and
>>> timestamp is the only use on ingress, then the only time the
>>> delivery_time needs to be cached if when looping from egress to
>>> ingress and this field is non-zero.
>>>
>>>> Keep *_forward() and bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)
>>>> because the skb->tstamp could be stamped by net_timestamp_check().
>>>>
>>>> Then SKBTX_DELIVERY_TSTAMP_ALLOW_FWD is not needed.
>>>>
>>>> Did I understand your suggestion correctly?
>>>
>>> I think so.
>>>
>>> But the reality is complicated if something may be setting a delivery
>>> time on ingress (a BPF filter?)
>>
>> I'm not quite following the 'bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)'
>> part yet; in our case we would need to preserve it as well, for example, we are
>> redirecting via bpf from bpf@tc-ingress@host-veth to bpf@tc-egress@phys-dev in
>> the egress path and fq sits on phys-dev.. (I mean if needed we could easily do
>> that as shown in my prev diff with a flag for the helper).
> Right, we have the same use case:
>      redirecting from bpf@tc-ingress@host-veth to bpf@tc-egress@phys-dev in
>      the egress path and fq sits on phys-dev
> 
> My earlier comment was on having the delivery_time preserved in
> the skb_shared_hwtstamps.  The delivery_time (e.g. EDT) and
> timestamp (timestamp as RX timestamp) are separately stored when
> looping from veth-egress to veth-ingress:
> 
> 	delivery_time in skb_shared_hwtstamps
> 	rx timestamp in skb->tstamp
> 
> Thus, when bpf_redirect_neigh(phys-dev) happens, bpf_out_*() can
> continue to reset skb->tstamp as-is while delivery_time will
> automatically be kept in skb_shared_hwtstamps.  When the skb
> reaches the egress@phys-dev (__dev_queue_xmit), the delivery_time
> in skb_shared_hwtstamps will be restored into skb->tstamp (done
> in skb_restore_delivery_time in this patch).

I think that could probably work, also in particular if it's restored once
on stacked devs e.g. when instead of phys-dev we're dealing with upper
tunnel dev (e.g. vxlan/geneve + BPF with collect_md). Wouldn't we still
need something like SKBTX_DELIVERY_TSTAMP_ALLOW_FWD, e.g. when the phys
driver sets skb_hwtstamps(skb)->hwtstamp on RX, and this gets carried on
the ingress path to the target namespaces' socket?

Thanks,
Daniel
