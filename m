Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE14C57566C
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 22:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbiGNUjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 16:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240299AbiGNUjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 16:39:42 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFC53B95C;
        Thu, 14 Jul 2022 13:39:41 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oC5cT-000CPV-G6; Thu, 14 Jul 2022 22:39:34 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oC5cT-0000C8-0g; Thu, 14 Jul 2022 22:39:33 +0200
Subject: Re: [PATCH v2,bpf-next] bpf: Don't redirect packets with invalid
 pkt_len
To:     Stanislav Fomichev <sdf@google.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        hawk@kernel.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20220714060959.25232-1-shaozhengchao@huawei.com>
 <CAKH8qBtxJOCWoON6QXygOTD7AqjF+k=-4JWPHXEAQh-TO+W54A@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7b333bcc-c8ed-f1f8-8331-58cba7897637@iogearbox.net>
Date:   Thu, 14 Jul 2022 22:39:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKH8qBtxJOCWoON6QXygOTD7AqjF+k=-4JWPHXEAQh-TO+W54A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26601/Thu Jul 14 09:57:26 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/22 8:22 PM, Stanislav Fomichev wrote:
> On Wed, Jul 13, 2022 at 11:05 PM Zhengchao Shao
> <shaozhengchao@huawei.com> wrote:
>>
>> Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
>> skbs, that is, the flow->head is null.
>> The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
>> run a bpf prog which redirects empty skbs.
>> So we should determine whether the length of the packet modified by bpf
>> prog is valid before forwarding it directly.
>>
>> LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
>> LINK: [2] https://www.spinics.net/lists/netdev/msg777503.html
>>
>> Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> 
> Daniel, do you see any issues with this approach?

I think it's fine, maybe this could be folded into:

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 750d7d173a20..256cd18cfe22 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -957,6 +957,8 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)

         if (!__skb)
                 return 0;
+       if (!skb->len)
+               return -EINVAL;

         /* make sure the fields we don't use are zeroed */
         if (!range_is_zero(__skb, 0, offsetof(struct __sk_buff, mark)))

> I wonder if we might also want to add some WARN_ON to the
> __bpf_redirect_common routine gated by #ifdef CONFIG_DEBUG_NET ?
> In case syscaller manages to hit similar issues elsewhere..

Assuming the issue is generic (and CONFIG_DEBUG_NET only enabled by things like
syzkaller), couldn't we do something like the below?

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f6a27ab19202..c9988a785294 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2459,6 +2459,17 @@ static inline void skb_set_tail_pointer(struct sk_buff *skb, const int offset)

  #endif /* NET_SKBUFF_DATA_USES_OFFSET */

+static inline void skb_assert_len(struct sk_buff *skb)
+{
+#ifdef CONFIG_DEBUG_NET
+       if (unlikey(!skb->len)) {
+               pr_err("%s\n", __func__);
+               skb_dump(KERN_ERR, skb, false);
+               WARN_ON_ONCE(1);
+       }
+#endif /* CONFIG_DEBUG_NET */
+}
+
  /*
   *     Add data to an sk_buff
   */
diff --git a/net/core/dev.c b/net/core/dev.c
index 978ed0622d8f..53c4b9fd22c0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4168,7 +4168,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
         bool again = false;

         skb_reset_mac_header(skb);
-
+       skb_assert_len(skb);
         if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
                 __skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);



>> ---
>> v1: should not check len in fast path
>>
>>   net/bpf/test_run.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>> index 2ca96acbc50a..750d7d173a20 100644
>> --- a/net/bpf/test_run.c
>> +++ b/net/bpf/test_run.c
>> @@ -1152,6 +1152,12 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>>          ret = convert___skb_to_skb(skb, ctx);
>>          if (ret)
>>                  goto out;
>> +
>> +       if (skb->len == 0) {
>> +               ret = -EINVAL;
>> +               goto out;
>> +       }
>> +
>>          ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false);
>>          if (ret)
>>                  goto out;
>> --
>> 2.17.1
>>

