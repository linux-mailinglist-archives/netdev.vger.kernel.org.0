Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F4F46C6EF
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 22:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhLGVw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 16:52:29 -0500
Received: from www62.your-server.de ([213.133.104.62]:51784 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbhLGVw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 16:52:28 -0500
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1muiKU-000BRk-JK; Tue, 07 Dec 2021 22:48:54 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1muiKU-000PtY-BQ; Tue, 07 Dec 2021 22:48:54 +0100
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
Date:   Tue, 7 Dec 2021 22:48:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26376/Tue Dec  7 10:34:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 3:27 PM, Willem de Bruijn wrote:
> On Mon, Dec 6, 2021 at 9:01 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>
>> The skb->tstamp may be set by a local sk (as a sender in tcp) which then
>> forwarded and delivered to another sk (as a receiver).
>>
>> An example:
>>      sender-sk => veth@netns =====> veth@host => receiver-sk
>>                               ^^^
>>                          __dev_forward_skb
>>
>> The skb->tstamp is marked with a future TX time.  This future
>> skb->tstamp will confuse the receiver-sk.
>>
>> This patch marks the skb if the skb->tstamp is forwarded.
>> Before using the skb->tstamp as a rx timestamp, it needs
>> to be re-stamped to avoid getting a future time.  It is
>> done in the RX timestamp reading helper skb_get_ktime().
>>
>> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>> ---
>>   include/linux/skbuff.h | 14 +++++++++-----
>>   net/core/dev.c         |  4 +++-
>>   net/core/skbuff.c      |  6 +++++-
>>   3 files changed, 17 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> index b609bdc5398b..bc4ae34c4e22 100644
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -867,6 +867,7 @@ struct sk_buff {
>>          __u8                    decrypted:1;
>>   #endif
>>          __u8                    slow_gro:1;
>> +       __u8                    fwd_tstamp:1;
>>
>>   #ifdef CONFIG_NET_SCHED
>>          __u16                   tc_index;       /* traffic control index */
>> @@ -3806,9 +3807,12 @@ static inline void skb_copy_to_linear_data_offset(struct sk_buff *skb,
>>   }
>>
>>   void skb_init(void);
>> +void net_timestamp_set(struct sk_buff *skb);
>>
>> -static inline ktime_t skb_get_ktime(const struct sk_buff *skb)
>> +static inline ktime_t skb_get_ktime(struct sk_buff *skb)
>>   {
>> +       if (unlikely(skb->fwd_tstamp))
>> +               net_timestamp_set(skb);
>>          return ktime_mono_to_real_cond(skb->tstamp);
> 
> This changes timestamp behavior for existing applications, probably
> worth mentioning in the commit message if nothing else. A timestamp
> taking at the time of the recv syscall is not very useful.
> 
> If a forwarded timestamp is not a future delivery time (as those are
> scrubbed), is it not correct to just deliver the original timestamp?
> It probably was taken at some earlier __netif_receive_skb_core.
> 
>>   }
>>
>> -static inline void net_timestamp_set(struct sk_buff *skb)
>> +void net_timestamp_set(struct sk_buff *skb)
>>   {
>>          skb->tstamp = 0;
>> +       skb->fwd_tstamp = 0;
>>          if (static_branch_unlikely(&netstamp_needed_key))
>>                  __net_timestamp(skb);
>>   }
>> +EXPORT_SYMBOL(net_timestamp_set);
>>
>>   #define net_timestamp_check(COND, SKB)                         \
>>          if (static_branch_unlikely(&netstamp_needed_key)) {     \
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index f091c7807a9e..181ddc989ead 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -5295,8 +5295,12 @@ void skb_scrub_tstamp(struct sk_buff *skb)
>>   {
>>          struct sock *sk = skb->sk;
>>
>> -       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
>> +       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME)) {
> 
> There is a slight race here with the socket flipping the feature on/off.
> 
>>                  skb->tstamp = 0;
>> +               skb->fwd_tstamp = 0;
>> +       } else if (skb->tstamp) {
>> +               skb->fwd_tstamp = 1;
>> +       }
> 
> SO_TXTIME future delivery times are scrubbed, but TCP future delivery
> times are not?
> 
> If adding a bit, might it be simpler to add a bit tstamp_is_edt, and
> scrub based on that. That is also not open to the above race.

One other thing I wonder, BPF progs at host-facing veth's tc ingress which
are not aware of skb->tstamp will then see a tstamp from future given we
intentionally bypass the net_timestamp_check() and might get confused (or
would confuse higher-layer application logic)? Not quite sure yet if they
would be the only affected user.

With regards to open question on mono clock and time namespaces (which
cover mono + boottime offsets), looks like it seems not an issue as they
only affect syscall-facing APIs.

Thanks,
Daniel
