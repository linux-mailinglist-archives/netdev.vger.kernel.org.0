Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713925FD282
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJMBZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJMBZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:25:47 -0400
X-Greylist: delayed 1368 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Oct 2022 18:25:39 PDT
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD9EB56D0;
        Wed, 12 Oct 2022 18:25:35 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 0C40B500669;
        Thu, 13 Oct 2022 03:39:49 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 0C40B500669
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665621591; bh=ixeQ2bDkrFAa8j/pTu1c+7sHh9CHcjnL5tH54cA/vxQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=nNqBOu7ZDGDxqH9tfsCbrwz7rXz1l7hHXzk36zIfKtpuY1gEBuBaOki31jYTQX615
         Fg02vMEUXHeY+QFkoh/RniWBKNhxOhjbJHlOO8aOxQ/rVQxkgvfpTe9qxFg5E7kIl0
         3W7MTxA0M6HonqILxQZHA5vPMQrfuMcUXShqmGY0=
Message-ID: <f87d7615-a978-4f9e-f124-635789fa5874@novek.ru>
Date:   Thu, 13 Oct 2022 01:43:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: bridge:fragmented packets dropped by bridge
Content-Language: en-US
To:     Vyacheslav Salnikov <snordicstr16@gmail.com>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <CACzz7uzbSVpLu8iqBYXTULr2aUW_9FDdkEVozK+r-BiM2rMukw@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <CACzz7uzbSVpLu8iqBYXTULr2aUW_9FDdkEVozK+r-BiM2rMukw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.10.2022 12:21, Vyacheslav Salnikov wrote:
> Hi.
> 
> I switched from kernel versions 4.9 to 5.15 and found that the MTU on
> the interfaces in the bridge does not change.
> For example:
> I have the following bridge:
> bridge      interface
> br0          sw1
>                 sw2
>                 sw3
> 
> And I change with ifconfig MTU.
> I see that br0 sw1..sw3 has changed MTU from 1500 -> 1982.
> 
> But if i send a ping through these interfaces, I get 1500(I added
> prints for output)
> I investigated the code and found the reason:
> The following commit came in the new kernel:
> https://github.com/torvalds/linux/commit/ac6627a28dbfb5d96736544a00c3938fa7ea6dfb
> 
> And the behavior of the MTU setting has changed:
>>
>> Kernel 4.9:
>> if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
>>     ip_mtu_locked(dst) ||
>>     !forwarding)  <--- True
>> return dst_mtu(dst) <--- 1982
>>
>>
>> / 'forwarding = true' case should always honour route mtu /
>> mtu = dst_metric_raw(dst, RTAX_MTU);
>> if (mtu)
>> return mtu;
> 
> 
> 
> Kernel 5.15:
>>
>> if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
>>     ip_mtu_locked(dst) ||
>>     !forwarding) { <--- True
>> mtu = rt->rt_pmtu;  <--- 0
>> if (mtu && time_before(jiffies, rt->dst.expires)) <-- False
>> goto out;
>> }
>>
>> / 'forwarding = true' case should always honour route mtu /
>> mtu = dst_metric_raw(dst, RTAX_MTU); <---- 1500
>> if (mtu) <--- True
>> goto out;
> 
> As I see from the code in the end takes mtu from br_dst_default_metrics
>> static const u32 br_dst_default_metrics[RTAX_MAX] = {
>> [RTAX_MTU - 1] = 1500,
>> };
> 
> Why is rt_pmtu now used instead of dst_mtu?
> Why is forwarding = False called with dst_metric_raw?
> Maybe we should add processing when mtu = rt->rt_pmtu == 0?
> Could this be an error?
> 
If you compare ipv4_mtu code from 4.9 you will see that the very first mtu value 
is filled by rt->rt_pmtu value. I believe there were changes to the bridge code 
where rt_pmtu value got empty or cleared.

I'm still looking for the root cause of the problem, will update you once I find it.


> 
> I found a thread discussing a similar problem. It suggested porting
> the next patch:
> Signed-off-by: Rundong Ge <rdong.ge@gmail.com>
> ---
>   include/net/ip.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/include/net/ip.h b/include/net/ip.h
> index 29d89de..0512de3 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -450,6 +450,8 @@ static inline unsigned int
> ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
>   static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
>      const struct sk_buff *skb)
>   {
> + if ((skb_dst(skb)->flags & DST_FAKE_RTABLE) && skb->dev)
> + return min(skb->dev->mtu, IP_MAX_MTU);
>    if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
>    bool forwarding = IPCB(skb)->flags & IPSKB_FORWARDED;
> 
> 
> Why was this patch not accepted in the end?

