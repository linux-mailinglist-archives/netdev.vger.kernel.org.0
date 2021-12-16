Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9245F4780CD
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 00:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhLPXmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 18:42:35 -0500
Received: from www62.your-server.de ([213.133.104.62]:44610 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhLPXme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 18:42:34 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1my0ON-00042w-7a; Fri, 17 Dec 2021 00:42:31 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1my0OM-000QJI-Vd; Fri, 17 Dec 2021 00:42:31 +0100
Subject: Re: [RFC PATCH v2 net-next] net: Preserve skb delivery time during
 forward
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
References: <20211215201158.271976-1-kafai@fb.com>
 <CA+FuTSdR0yPwXAZZjziGOeujJ_Ac19fX1DsqfRXX3Dsn1uFPAQ@mail.gmail.com>
 <20211216222332.fltkclu4x3udpomr@kafai-mbp.dhcp.thefacebook.com>
 <CA+FuTSfsrMUAz-5Huf2j4f35ttqO5gpFKvsn4uJLXtRPqEaKEg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ca11f6f6-86f9-52c9-4251-90bf0b6f588a@iogearbox.net>
Date:   Fri, 17 Dec 2021 00:42:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSfsrMUAz-5Huf2j4f35ttqO5gpFKvsn4uJLXtRPqEaKEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26389/Thu Dec 16 07:02:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/21 11:58 PM, Willem de Bruijn wrote:
>>>> @@ -530,7 +538,14 @@ struct skb_shared_info {
>>>>          /* Warning: this field is not always filled in (UFO)! */
>>>>          unsigned short  gso_segs;
>>>>          struct sk_buff  *frag_list;
>>>> -       struct skb_shared_hwtstamps hwtstamps;
>>>> +       union {
>>>> +               /* If SKBTX_DELIVERY_TSTAMP is set in tx_flags,
>>>> +                * tx_delivery_tstamp is stored instead of
>>>> +                * hwtstamps.
>>>> +                */
>>>
>>> Should we just encode the timebase and/or type { timestamp,
>>> delivery_time } in th lower bits of the timestamp field? Its
>>> resolution is higher than actual clock precision.
>> In skb->tstamp ?
> 
> Yes. Arguably a hack, but those bits are in the noise now, and it
> avoids the clone issue with skb_shinfo (and scarcity of flag bits
> there).
> 
>>> is non-zero skb->tstamp test not sufficient, instead of
>>> SKBTX_DELIVERY_TSTAMP_ALLOW_FWD.
>>>
>>> It is if only called on the egress path. Is bpf on ingress the only
>>> reason for this?
>> Ah. ic.  meaning testing non-zero skb->tstamp and then call
>> skb_save_delivery_time() only during the veth-egress-path:
>> somewhere in veth_xmit() => veth_forward_skb() but before
>> skb->tstamp was reset to 0 in __dev_forward_skb().
> 
> Right. If delivery_time is the only use of skb->tstamp on egress, and
> timestamp is the only use on ingress, then the only time the
> delivery_time needs to be cached if when looping from egress to
> ingress and this field is non-zero.
> 
>> Keep *_forward() and bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)
>> because the skb->tstamp could be stamped by net_timestamp_check().
>>
>> Then SKBTX_DELIVERY_TSTAMP_ALLOW_FWD is not needed.
>>
>> Did I understand your suggestion correctly?
> 
> I think so.
> 
> But the reality is complicated if something may be setting a delivery
> time on ingress (a BPF filter?)

I'm not quite following the 'bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)'
part yet; in our case we would need to preserve it as well, for example, we are
redirecting via bpf from bpf@tc-ingress@host-veth to bpf@tc-egress@phys-dev in
the egress path and fq sits on phys-dev.. (I mean if needed we could easily do
that as shown in my prev diff with a flag for the helper).

>> However, we still need a bit to distinguish tx_delivery_tstamp
>> from hwtstamps.
>>
>>>
>>>> +{
>>>> +       if (skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP_ALLOW_FWD) {
>>>> +               skb_shinfo(skb)->tx_delivery_tstamp = skb->tstamp;
>>>> +               skb_shinfo(skb)->tx_flags |= SKBTX_DELIVERY_TSTAMP;
>>>> +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
>>>> +       }
>>>
>>> Is this only called when there are no clones/shares?
>> No, I don't think so.  TCP clone it.  I also started thinking about
>> this after noticing a mistake in the change in  __tcp_transmit_skb().
>>
>> There are other places that change tx_flags, e.g. tcp_offload.c.
>> It is not shared at those places or there is some specific points
>> in the stack that is safe to change ?
> 
> The packet probably is not yet shared. Until the TCP stack gives a
> packet to the IP layer, it can treat it as exclusive.
> 
> Though it does seem that these fields are accessed in a possibly racy
> manner. Drivers with hardware tx timestamp offload may set
> skb_shinfo(orig_skb)->tx_flags & SKBTX_IN_PROGRESS without checking
> whether the skb may be cloned.
