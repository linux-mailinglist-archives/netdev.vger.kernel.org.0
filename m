Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92357572704
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiGLUM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiGLUM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:12:26 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6D1BEB46;
        Tue, 12 Jul 2022 13:12:25 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oBMEz-0002bi-O3; Tue, 12 Jul 2022 22:12:17 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oBMEz-000SVy-9w; Tue, 12 Jul 2022 22:12:17 +0200
Subject: Re: [PATCH bpf-next] bpf: Don't redirect packets with invalid pkt_len
To:     sdf@google.com, Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        hawk@kernel.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20220712120158.56325-1-shaozhengchao@huawei.com>
 <Ys2oPzt7Yn1oMou8@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f0bf3e9a-15e6-f5c8-1b2a-7866acfcb71b@iogearbox.net>
Date:   Tue, 12 Jul 2022 22:12:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <Ys2oPzt7Yn1oMou8@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26599/Tue Jul 12 10:00:48 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/22 6:58 PM, sdf@google.com wrote:
> On 07/12, Zhengchao Shao wrote:
>> Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
>> skbs, that is, the flow->head is null.
>> The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
>> run a bpf prog which redirects empty skbs.
>> So we should determine whether the length of the packet modified by bpf
>> prog or others like bpf_prog_test is valid before forwarding it directly.
> 
>> LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
>> LINK: [2] https://www.spinics.net/lists/netdev/msg777503.html
> 
>> Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/core/filter.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 4ef77ec5255e..27801b314960 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -2122,6 +2122,11 @@ static int __bpf_redirect_no_mac(struct sk_buff *skb, struct net_device *dev,
>>   {
>>       unsigned int mlen = skb_network_offset(skb);
> 
>> +    if (unlikely(skb->len == 0)) {
>> +        kfree_skb(skb);
>> +        return -EINVAL;
>> +    }
>> +
>>       if (mlen) {
>>           __skb_pull(skb, mlen);
> 
>> @@ -2143,7 +2148,9 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
>>                    u32 flags)
>>   {
>>       /* Verify that a link layer header is carried */
>> -    if (unlikely(skb->mac_header >= skb->network_header)) {
>> +    if (unlikely(skb->mac_header >= skb->network_header) ||
>> +        (min_t(u32, skb_mac_header_len(skb), skb->len) <
>> +         (u32)dev->min_header_len)) {
> 
> Why check skb->len != 0 above but skb->len < dev->min_header_len here?
> I guess it doesn't make sense in __bpf_redirect_no_mac because we know
> that mac is empty, but why do we care in __bpf_redirect_common?
> Why not put this check in the common __bpf_redirect?
> 
> Also, it's still not clear to me whether we should bake it into the core
> stack vs having some special checks from test_prog_run only. I'm
> assuming the issue is that we can construct illegal skbs with that
> test_prog_run interface, so maybe start by fixing that?

Agree, ideally we can prevent it right at the source rather than adding
more tests into the fast-path.

> Did you have a chance to look at the reproducer more closely? What
> exactly is it doing?
> 
>>           kfree_skb(skb);
>>           return -ERANGE;
>>       }
>> -- 
>> 2.17.1
> 

