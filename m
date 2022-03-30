Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B291A4EC3A4
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 14:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243659AbiC3MLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 08:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346786AbiC3MFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 08:05:34 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E320C2921F2
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 05:00:21 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nZWzk-0004EC-GK; Wed, 30 Mar 2022 14:00:12 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nZWzk-000UeU-1p; Wed, 30 Mar 2022 14:00:12 +0200
Subject: Re: [net v6 1/2] net: core: set skb useful vars in __bpf_tx_skb
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
References: <20220324135653.2189-1-xiangxia.m.yue@gmail.com>
 <20220324135653.2189-2-xiangxia.m.yue@gmail.com>
 <CAADnVQJmwCKUKbVpqa7SX8QiU1UTZVqgGAMBA4WnKKerBgPiUg@mail.gmail.com>
 <CAMDZJNVK3xpCmg6eCan74prqNBG33USVgqrLE96kkEDhcDrdBQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fe259f3b-8808-5d4c-46b3-7031ee61a63e@iogearbox.net>
Date:   Wed, 30 Mar 2022 14:00:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAMDZJNVK3xpCmg6eCan74prqNBG33USVgqrLE96kkEDhcDrdBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26497/Wed Mar 30 10:19:51 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/22 1:56 AM, Tonghao Zhang wrote:
> On Thu, Mar 24, 2022 at 11:16 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Thu, Mar 24, 2022 at 6:57 AM <xiangxia.m.yue@gmail.com> wrote:
>>>
>>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>>
>>> We may use bpf_redirect to redirect the packets to other
>>> netdevice (e.g. ifb) in ingress or egress path.
>>>
>>> The target netdevice may check the *skb_iif, *redirected
>>> and *from_ingress. For example, if skb_iif or redirected
>>> is 0, ifb will drop the packets.
>>>
>>> Fixes: a70b506efe89 ("bpf: enforce recursion limit on redirects")
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: Alexei Starovoitov <ast@kernel.org>
>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>> Cc: Andrii Nakryiko <andrii@kernel.org>
>>> Cc: Martin KaFai Lau <kafai@fb.com>
>>> Cc: Song Liu <songliubraving@fb.com>
>>> Cc: Yonghong Song <yhs@fb.com>
>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>> Cc: KP Singh <kpsingh@kernel.org>
>>> Cc: Eric Dumazet <edumazet@google.com>
>>> Cc: Antoine Tenart <atenart@kernel.org>
>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>> Cc: Wei Wang <weiwan@google.com>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>> ---
>>>   net/core/filter.c | 8 ++++++++
>>>   1 file changed, 8 insertions(+)
>>>
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index a7044e98765e..c1f45d2e6b0a 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -2107,7 +2107,15 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
>>>          }
>>>
>>>          skb->dev = dev;
>>> +       /* The target netdevice (e.g. ifb) may use the:
>>> +        * - redirected
>>> +        * - from_ingress
>>> +        */
>>> +#ifdef CONFIG_NET_CLS_ACT
>>> +       skb_set_redirected(skb, skb->tc_at_ingress);
>>> +#else
>>>          skb_clear_tstamp(skb);
>>> +#endif
>>
>> I thought Daniel Nacked it a couple times already.
>> Please stop this spam.
> Hi
> Daniel rejected the 2/3 patch,
> https://patchwork.kernel.org/project/netdevbpf/patch/20211208145459.9590-3-xiangxia.m.yue@gmail.com/
> The reasons are as follows.
> * 2/3 patch adds a check in fastpath.
> * on egress, redirect skb to ifb is not useful.
> but this patch fixes  redirect skb to ifb on ingress. I think it is
> useful for us.
> 
> Daniel, can you review this patch ?

Still nack, above makes tc forwarding path for BPF less predictable and could break
existing setups, e.g. if someone is relying on generic XDP. I'm certain you can
resolve this without ifb hack, ifb usage is really discouraged in general.

Thanks,
Daniel
