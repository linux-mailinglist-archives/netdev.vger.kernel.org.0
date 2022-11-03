Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4457618A4F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiKCVKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiKCVKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:10:00 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF80613F4A;
        Thu,  3 Nov 2022 14:08:28 -0700 (PDT)
Message-ID: <f0bb3cd6-6986-6ca1-aa40-7a10302c8586@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667509674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQcKEXuHs/7YZtQkNBeKwRLPigLlS9nAKVIGEHzvGaU=;
        b=Yxm3Oq/Y7WeBDzWz4L8zz22I/FsSLUnL28y2NM6dbdseg9ViJ6gWVDMHi0aYwH5LcwpTY7
        OycpSxUV32zu00hDdWahU3vjG6u9Yj+ZPMmjlaxX/l7GKJicQTJkcVUXCcr8UhQG7VC5aq
        /cYzQWWrwbLN3iA5Yvs78xVGcouNVhM=
Date:   Thu, 3 Nov 2022 14:07:44 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v4,bpf-next] bpf: Don't redirect packets with invalid
 pkt_len
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, bigeasy@linutronix.de,
        imagedong@tencent.com, petrm@nvidia.com, arnd@arndb.de,
        dsahern@kernel.org, talalahmad@google.com, keescook@chromium.org,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        hawk@kernel.org
References: <20220715115559.139691-1-shaozhengchao@huawei.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20220715115559.139691-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/22 4:55 AM, Zhengchao Shao wrote:
> Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
> skbs, that is, the flow->head is null.
> The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
> run a bpf prog which redirects empty skbs.
> So we should determine whether the length of the packet modified by bpf
> prog or others like bpf_prog_test is valid before forwarding it directly.
> 
> LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
> LINK: [2] https://www.spinics.net/lists/netdev/msg777503.html
> 
> Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v3: modify debug print
> v2: need move checking to convert___skb_to_skb and add debug info
> v1: should not check len in fast path
> 
>   include/linux/skbuff.h | 8 ++++++++
>   net/bpf/test_run.c     | 3 +++
>   net/core/dev.c         | 1 +
>   3 files changed, 12 insertions(+)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index f6a27ab19202..82e8368ba6e6 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2459,6 +2459,14 @@ static inline void skb_set_tail_pointer(struct sk_buff *skb, const int offset)
>   
>   #endif /* NET_SKBUFF_DATA_USES_OFFSET */
>   
> +static inline void skb_assert_len(struct sk_buff *skb)
> +{
> +#ifdef CONFIG_DEBUG_NET
> +	if (WARN_ONCE(!skb->len, "%s\n", __func__))
> +		DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
> +#endif /* CONFIG_DEBUG_NET */
> +}
> +
>   /*
>    *	Add data to an sk_buff
>    */
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 2ca96acbc50a..dc9dc0bedca0 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -955,6 +955,9 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
>   {
>   	struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
>   
> +	if (!skb->len)
> +		return -EINVAL;

 From another recent report [0], I don't think this change is fixing the report 
from syzbot.  It probably makes sense to revert this patch.

afaict, This '!skb->len' test is done after
	if (is_l2)
		__skb_push(skb, hh_len);

Hence, skb->len is not zero in convert___skb_to_skb().  The proper place to test 
skb->len is before __skb_push() to ensure there is some network header after the 
mac or may as well ensure "data_size_in > ETH_HLEN" at the beginning.

The fix in [0] is applied.  If it turns out there are other cases caused by the 
skb generated by test_run that needs extra fixes in bpf_redirect_*,  it needs to 
revisit an earlier !skb->len check mentioned above and the existing test cases 
outside of test_progs would have to adjust accordingly.

[0]: https://lore.kernel.org/bpf/20221027225537.353077-1-sdf@google.com/

> +
>   	if (!__skb)
>   		return 0;
>   
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d588fd0a54ce..716df64fcfa5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4168,6 +4168,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>   	bool again = false;
>   
>   	skb_reset_mac_header(skb);
> +	skb_assert_len(skb);
>   
>   	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
>   		__skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);

