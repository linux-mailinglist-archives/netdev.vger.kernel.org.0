Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA21D26D445
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 09:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgIQHJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 03:09:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50398 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbgIQHJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 03:09:08 -0400
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 03:09:05 EDT
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0FEE185A67CC42766640;
        Thu, 17 Sep 2020 14:53:02 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 14:52:54 +0800
Subject: Re: [PATCH net-next 6/6] net: hns3: use napi_consume_skb() when
 cleaning tx desc
To:     Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
 <1600085217-26245-7-git-send-email-tanhuazhong@huawei.com>
 <e615366cb2b260bf1b77fdaa0692957ab750a9a4.camel@nvidia.com>
 <2b1219b6-a7dd-38a3-bfb7-1cb49330df90@huawei.com>
 <f2a27306606ab6a882f6a6e4363d07174e55c745.camel@kernel.org>
 <CANn89iJwJwzv60pmWEcU-nJ1unbxXuAU7hyFBuzEo-nTHZmm8A@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3a5c8a23-bc03-e79b-47ef-b67f66452327@huawei.com>
Date:   Thu, 17 Sep 2020 14:52:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJwJwzv60pmWEcU-nJ1unbxXuAU7hyFBuzEo-nTHZmm8A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/16 16:38, Eric Dumazet wrote:
> On Wed, Sep 16, 2020 at 10:33 AM Saeed Mahameed <saeed@kernel.org> wrote:
>>
>> On Tue, 2020-09-15 at 15:04 +0800, Yunsheng Lin wrote:
>>> On 2020/9/15 13:09, Saeed Mahameed wrote:
>>>> On Mon, 2020-09-14 at 20:06 +0800, Huazhong Tan wrote:
>>>>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>>>>
>>>>> Use napi_consume_skb() to batch consuming skb when cleaning
>>>>> tx desc in NAPI polling.
>>>>>
>>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>>>>> ---
>>>>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 27
>>>>> +++++++++++-
>>>>> ----------
>>>>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
>>>>>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  4 ++--
>>>>>  3 files changed, 17 insertions(+), 16 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>>>> b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>>>> index 4a49a76..feeaf75 100644
>>>>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>>>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>>>> @@ -2333,10 +2333,10 @@ static int hns3_alloc_buffer(struct
>>>>> hns3_enet_ring *ring,
>>>>>  }
>>>>>
>>>>>  static void hns3_free_buffer(struct hns3_enet_ring *ring,
>>>>> -                      struct hns3_desc_cb *cb)
>>>>> +                      struct hns3_desc_cb *cb, int budget)
>>>>>  {
>>>>>   if (cb->type == DESC_TYPE_SKB)
>>>>> -         dev_kfree_skb_any((struct sk_buff *)cb->priv);
>>>>> +         napi_consume_skb(cb->priv, budget);
>>>>
>>>> This code can be reached from hns3_lb_clear_tx_ring() below which
>>>> is
>>>> your loopback test and called with non-zero budget, I am not sure
>>>> you
>>>> are allowed to call napi_consume_skb() with non-zero budget outside
>>>> napi context, perhaps the cb->type for loopback test is different
>>>> in lb
>>>> test case ? Idk.. , please double check other code paths.
>>>
>>> Yes, loopback test may call napi_consume_skb() with non-zero budget
>>> outside
>>> napi context. Thanks for pointing out this case.
>>>
>>> How about add the below WARN_ONCE() in napi_consume_skb() to catch
>>> this
>>> kind of error?
>>>
>>> WARN_ONCE(!in_serving_softirq(), "napi_consume_skb() is called with
>>> non-zero budget outside napi context");
>>>
>>
>> Cc: Eric
>>
>> I don't know, need to check performance impact.
>> And in_serving_softirq() doesn't necessarily mean in napi
>> but looking at _kfree_skb_defer(), i think it shouldn't care if napi or
>> not as long as it runs in soft irq it will push the skb to that
>> particular cpu napi_alloc_cache, which should be fine.

Yes, we only need to ensure _kfree_skb_defer() runs with automic context.

And it seems NAPI polling can be in thread context with BH disabled in below
patch, so in_softirq() checking should be more future-proof?

* in_softirq()   - We have BH disabled, or are processing softirqs

net: add support for threaded NAPI polling
https://www.mail-archive.com/netdev@vger.kernel.org/msg348491.html


>>
>> Maybe instead of the WARN_ONCE just remove the budget condition and
>> replace it with
>>
>> if (!in_serving_softirq())
>>       dev_consume_skb_any(skb);

Yes, that is good idea, _kfree_skb_defer() is only called in softirq or
BH disabled context, dev_consume_skb_any(skb) is called in other context,
so driver author do not need to worry about the calling context of the
napi_consume_skb().

>>
> 
> I think we need to keep costs small.
> 
> So lets add a CONFIG_DEBUG_NET option so that developers can add
> various DEBUG_NET() clauses.

Do you means something like below:

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 157e024..61a6a62 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5104,6 +5104,15 @@ do {								\
 })
 #endif

+#if defined(CONFIG_DEBUG_NET)
+#define DEBUG_NET_WARN(condition, format...)				\
+	do {								\
+		WARN(condition, ##__VA_ARGS__);
+	} while (0)
+#else
+#define DEBUG_NET_WARN(condition, format...)
+#endif
+
 /*
  *	The list of packet types we will receive (as opposed to discard)
  *	and the routines to invoke.
diff --git a/net/Kconfig b/net/Kconfig
index 3831206..f59ea4b 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -473,3 +473,9 @@ config HAVE_CBPF_JIT
 # Extended BPF JIT (eBPF)
 config HAVE_EBPF_JIT
 	bool
+
+config DEBUG_NET
+	bool
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here to add some extra checks and diagnostics to networking.
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bfd7483..10547db 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -904,6 +904,9 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 		return;
 	}

+	DEBUG_NET_WARN(!in_serving_softirq(),
+		        "napi_consume_skb() is called with non-zero budget outside softirq context");
+
 	if (!skb_unref(skb))
 		return;


> .
> 
