Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B51A545CDF
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346369AbiFJHKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346600AbiFJHKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:10:08 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7835232389C;
        Fri, 10 Jun 2022 00:09:58 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzYmJ-0007UB-Rn; Fri, 10 Jun 2022 09:09:55 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzYmJ-00026j-G0; Fri, 10 Jun 2022 09:09:55 +0200
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Jonathan Maxwell <jmaxwell37@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Antoine Tenart <atenart@kernel.org>, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, joe@cilium.io, i@lmb.io,
        bpf@vger.kernel.org
References: <20220609011844.404011-1-jmaxwell37@gmail.com>
 <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
 <20220610001743.z5nxapagwknlfjqi@kafai-mbp>
 <20220610003618.um4qya5rl6hirvnz@kafai-mbp>
 <CAGHK07BQZj4D1=KUmuWOjYS+4Hm3gq6_GJoWRt=Css9atL5U8w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <07fd01be-aff6-cd63-5991-4c3dc398b4c8@iogearbox.net>
Date:   Fri, 10 Jun 2022 09:09:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAGHK07BQZj4D1=KUmuWOjYS+4Hm3gq6_GJoWRt=Css9atL5U8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26567/Thu Jun  9 10:06:06 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 2:45 AM, Jonathan Maxwell wrote:
> On Fri, Jun 10, 2022 at 10:36 AM Martin KaFai Lau <kafai@fb.com> wrote:
>>
>> On Thu, Jun 09, 2022 at 05:17:47PM -0700, Martin KaFai Lau wrote:
>>> On Thu, Jun 09, 2022 at 10:29:15PM +0200, Daniel Borkmann wrote:
>>>> On 6/9/22 3:18 AM, Jon Maxwell wrote:
>>>>> A customer reported a request_socket leak in a Calico cloud environment. We
>>>>> found that a BPF program was doing a socket lookup with takes a refcnt on
>>>>> the socket and that it was finding the request_socket but returning the parent
>>>>> LISTEN socket via sk_to_full_sk() without decrementing the child request socket
>>>>> 1st, resulting in request_sock slab object leak. This patch retains the
>>> Great catch and debug indeed!
>>>
>>>>> existing behaviour of returning full socks to the caller but it also decrements
>>>>> the child request_socket if one is present before doing so to prevent the leak.
>>>>>
>>>>> Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
>>>>> thanks to Antoine Tenart for the reproducer and patch input.
>>>>>
>>>>> Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
>>>>> Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
>>> Instead of the above commits, I think this dated back to
>>> 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
>>
>> Since this is more bpf specific, I think it could go to the bpf tree.
>> In v2, please cc bpf@vger.kernel.org and tag it with 'PATCH v2 bpf'.
> 
> Okay thanks will do.
> 
> Daniel, are you okay with omitting 'if (unlikely...) { WARN_ONCE(...); }'?
> 
> If so I'll stick to the rest of the logic of your suggestion and omit that
> check in v1.

Ok, works for me, see also my other reply that we should at least mention it in
the commit log.

Thanks!
Daniel
