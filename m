Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D16852E2CE
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 05:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344971AbiETDCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 23:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344976AbiETDCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 23:02:37 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2130B8BE1
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 20:02:34 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id i1so6311418plg.7
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 20:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=T49autrwazSVPbqM6JLQ0qnBuicehxkova35EuZCJaU=;
        b=YAQzupJhJUp7xZHECAP6liV1GLyneKC7ORPbdztHF98+Q7076sqC9DSsyMYsCmP6cA
         oWwweI2rAbNR1XW76OAHHX4lpS3lIfOkzqlEwwScfdtl/YFj4oxt/7O2AA+TtnDWZAu3
         0/8tnXWRPpE/h6SoJ+lwC43FRUQPlDADpf0y0r99L9hq/jeXx3sg1Lw9uJenlEYTz3ce
         X0kJzXObUKCU7TOOJ30K4XEuS8xNv1TIaxRHNg9Qf0/aDLsQIdKLa/l0wrOuRfha3dgu
         2/KpF94tfXYOkEX/1t6Lf1IuRtSmd9XMFw8WvsUvYNNQY2Aq791p0vpJ09dUsT0RNHIi
         hgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T49autrwazSVPbqM6JLQ0qnBuicehxkova35EuZCJaU=;
        b=Vlg0SUN1j6LC7+at2nGhAIvzV2tXGg/fwuOdlpwQptrSvjXAQPx7fwlatPxh3AsE/o
         B3t8XcFByJT1ccyaoCVUGRdQuuGn/RlOahjq6SJmXieuFr34woH8k1mraBP2EZEtCyxi
         1pFBHIFXUF1nvEv2R0jfl6EUG0/t2Udvs2PNX+MR4tvCEn59mvYr09okcPTClxTdYsyD
         mWuZVg9HDLWq8NI74q6igzouF3+3jK5gb1mkRp9ejLn8G+2IAORa/7pNYlVgErAQ4/X6
         cwtcpGAR/F2ex8DXmoBKBgpWx/mF+wp75NXaXNsRXjptDLI3UElQ/zfo0RL1DR6b2+mU
         kevQ==
X-Gm-Message-State: AOAM531KqZy/VPZzC9+azr9yHhOjS++2M7N8MjBRtsl6lMlQbZVQI1gS
        mXboqnfhLNnFxau6/ac2o4GU7Q==
X-Google-Smtp-Source: ABdhPJwOjHkRwZ7scwMzECt6n/SIMuW/O/aZf3GaVbzT7jr3FkELxpScQ0hys0wR4wtFxD+F+4Ucpg==
X-Received: by 2002:a17:903:1c7:b0:161:9d6f:376a with SMTP id e7-20020a17090301c700b001619d6f376amr7770822plh.147.1653015754279;
        Thu, 19 May 2022 20:02:34 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902e54100b0015e8d4eb219sm4574667plf.99.2022.05.19.20.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 20:02:33 -0700 (PDT)
Message-ID: <344e2064-62f8-845e-7d1d-2afcaeb0e524@bytedance.com>
Date:   Fri, 20 May 2022 11:02:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH] bpf: avoid grabbing spin_locks of all cpus
 when no free elems
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20220518062715.27809-1-zhoufeng.zf@bytedance.com>
 <CAADnVQ+x-A87Z9_c+3vuRJOYm=gCOBXmyCJQ64CiCNukHS6FpA@mail.gmail.com>
 <6ae715b3-96b1-2b42-4d1a-5267444d586b@bytedance.com>
 <9c0c3e0b-33bc-51a7-7916-7278f14f308e@fb.com>
 <380fa11e-f15d-da1a-51f7-70e14ed58ffc@bytedance.com>
 <CAADnVQL9naBBKzQdAOWu2ZH=i7HA1VDi7uNzsDQ1TM9Jr+c0Ww@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAADnVQL9naBBKzQdAOWu2ZH=i7HA1VDi7uNzsDQ1TM9Jr+c0Ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/20 上午12:12, Alexei Starovoitov 写道:
> On Wed, May 18, 2022 at 8:12 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>> 在 2022/5/19 上午4:39, Yonghong Song 写道:
>>>
>>> On 5/17/22 11:57 PM, Feng Zhou wrote:
>>>> 在 2022/5/18 下午2:32, Alexei Starovoitov 写道:
>>>>> On Tue, May 17, 2022 at 11:27 PM Feng zhou
>>>>> <zhoufeng.zf@bytedance.com> wrote:
>>>>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>>>>
>>>>>> We encountered bad case on big system with 96 CPUs that
>>>>>> alloc_htab_elem() would last for 1ms. The reason is that after the
>>>>>> prealloc hashtab has no free elems, when trying to update, it will
>>>>>> still
>>>>>> grab spin_locks of all cpus. If there are multiple update users, the
>>>>>> competition is very serious.
>>>>>>
>>>>>> So this patch add is_empty in pcpu_freelist_head to check freelist
>>>>>> having free or not. If having, grab spin_lock, or check next cpu's
>>>>>> freelist.
>>>>>>
>>>>>> Before patch: hash_map performance
>>>>>> ./map_perf_test 1
>>> could you explain what parameter '1' means here?
>> This code is here:
>> samples/bpf/map_perf_test_user.c
>> samples/bpf/map_perf_test_kern.c
>> parameter '1' means testcase flag, test hash_map's performance
>> parameter '2048' means test hash_map's performance when free=0.
>> testcase flag '2048' is added by myself to reproduce the problem phenomenon.
> Please convert it to selftests/bpf/bench,
> so that everyone can reproduce the issue you're seeing
> and can assess whether it's a real issue or a corner case.
>
> Also please avoid adding indent in the patch.
> Instead of
>   if (!s->extralist.is_empty) {
>    .. churn
>
> do
>
>   if (s->extralist.is_empty)

Ok, will do. Thanks.

