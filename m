Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010C13FF176
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346352AbhIBQdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:33:14 -0400
Received: from relay.sw.ru ([185.231.240.75]:47162 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242481AbhIBQdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 12:33:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=9RCNEQgzOsFkVYRclOSep+JOIavBm+WQguvnh2YAla0=; b=KEWBK/wo3d5ml/d0a
        ewRcDe+7sS0Q64aPlRSCZEuWcw5EbRM8P5PN5fyA748dzXGQTv/Ky1eXutWl3LacJvq36htCwUfvr
        ynl9deeHphRE2+y/Pg8+kcZT7ZXGW9EcfEIriqhxLorxHSPz+g26qu6V7zjddR/5TfeDGraFi145k
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mLpdE-000bpY-GV; Thu, 02 Sep 2021 19:32:04 +0300
Subject: Re: [PATCH net-next v5] skb_expand_head() adjust skb->truesize
 incorrectly
To:     Christoph Paasch <christoph.paasch@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <27f87dd8-f6e4-b2b0-2b3a-9378fddf147f@virtuozzo.com>
 <053307fc-cc3d-68f5-1994-fe447428b1f2@virtuozzo.com>
 <CALMXkpbZ3R40XVTMOBF5Bhut9Yv_x=a682qg6gEsAMTT5TGhHQ@mail.gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <63f90028-df26-d212-3bd2-65168736ce06@virtuozzo.com>
Date:   Thu, 2 Sep 2021 19:32:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMXkpbZ3R40XVTMOBF5Bhut9Yv_x=a682qg6gEsAMTT5TGhHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/21 6:53 PM, Christoph Paasch wrote:
> On Thu, Sep 2, 2021 at 4:12 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>>
>> Christoph Paasch reports [1] about incorrect skb->truesize
>> after skb_expand_head() call in ip6_xmit.
>> This may happen because of two reasons:
>> - skb_set_owner_w() for newly cloned skb is called too early,
>> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
>> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
>> In this case sk->sk_wmem_alloc should be adjusted too.
>>
>> [1] https://lkml.org/lkml/2021/8/20/1082
>>
>> Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
>> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>> ---
>> v5: fixed else condition, thanks to Eric
>>     reworked update of expanded skb,
>>     added corresponding comments
>> v4: decided to use is_skb_wmem() after pskb_expand_head() call
>>     fixed 'return (EXPRESSION);' in os_skb_wmem according to Eric Dumazet
>> v3: removed __pskb_expand_head(),
>>     added is_skb_wmem() helper for skb with wmem-compatible destructors
>>     there are 2 ways to use it:
>>      - before pskb_expand_head(), to create skb clones
>>      - after successfull pskb_expand_head() to change owner on extended skb.
>> v2: based on patch version from Eric Dumazet,
>>     added __pskb_expand_head() function, which can be forced
>>     to adjust skb->truesize and sk->sk_wmem_alloc.
>> ---
>>  include/net/sock.h |  1 +
>>  net/core/skbuff.c  | 63 ++++++++++++++++++++++++++++++++++++++++++++++--------
>>  net/core/sock.c    |  8 +++++++
>>  3 files changed, 63 insertions(+), 9 deletions(-)
> 
> Still the same issues around refcount as I reported in my other email.
> 
> Did you try running the syzkaller reproducer on your setup?

no, I do not have 

>> +       } else if (sk && skb->destructor != sock_edemux) {
>> +               bool ref, set_owner;
>> +
>> +               ref = false; set_owner = false;
>> +               delta = osize - skb_end_offset(skb);

error is here, should be instead
delta = skb_end_offset(skb) - osize;

>> +               /* skb_set_owner_w() calls current skb destructor.
>> +                * It can decrease sk_wmem_alloc to 0 and release sk,
>> +                * To prevnt it we increase sk_wmem_alloc earlier.
>> +                * Another kind of destructors can release last sk_refcnt,
>> +                * so it will be impossible to call sock_hold for !fullsock
>> +                * Take extra sk_refcnt to prevent it.
>> +                * Otherwise just increase truesize of expanded skb.
>> +                */
>> +               refcount_add(delta, &sk->sk_wmem_alloc);
>> +               if (!is_skb_wmem(skb)) {
>> +                       set_owner = true;
>> +                       if (!sk_fullsock(sk) && IS_ENABLED(CONFIG_INET)) {
>> +                               /* skb_set_owner_w can set sock_edemux */
>> +                               ref = refcount_inc_not_zero(&sk->sk_refcnt);
>> +                               if (!ref) {
>> +                                       set_owner = false;
>> +                                       WARN_ON(refcount_sub_and_test(delta, &sk->sk_wmem_alloc));
>> +                               }
>> +                       }
>> +               }
>> +               if (set_owner)
>> +                       skb_set_owner_w(skb, sk);
>> +#ifdef CONFIG_INET
>> +               if (skb->destructor == sock_edemux) {
>> +                       WARN_ON(refcount_sub_and_test(delta, &sk->sk_wmem_alloc));
>> +                       if (ref)
>> +                               WARN_ON(refcount_dec_and_test(&sk->sk_refcnt));
>> +               }
>> +#endif
>> +               skb->truesize += delta;
>>         }
>>         return skb;
>>  }
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 950f1e7..6cbda43 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -2227,6 +2227,14 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
>>  }
>>  EXPORT_SYMBOL(skb_set_owner_w);
>>
>> +bool is_skb_wmem(const struct sk_buff *skb)
>> +{
>> +       return skb->destructor == sock_wfree ||
>> +              skb->destructor == __sock_wfree ||
>> +              (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
>> +}
>> +EXPORT_SYMBOL(is_skb_wmem);
>> +
>>  static bool can_skb_orphan_partial(const struct sk_buff *skb)
>>  {
>>  #ifdef CONFIG_TLS_DEVICE
>> --
>> 1.8.3.1
>>

