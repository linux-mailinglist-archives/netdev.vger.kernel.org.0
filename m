Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A266C9125
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCYWKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCYWKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:10:42 -0400
Received: from out-47.mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6ECDCC21
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 15:10:35 -0700 (PDT)
Message-ID: <af0efbd5-c44c-d30b-9f82-b77ef59740ac@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679782233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zpvv6o6OmF4icJLi33I+gqHsIckrR5qsYeeyJeujhX0=;
        b=nJHNPVH98v8ygkeK3+NGYBXKkgwa3mQEwpddshCyEXWrKJqkXo3WXYljTKziH/FmHnRPra
        6OfmUozzEkx60e0nbrLOvrNER+GBy9zrtnstiBVvf8wqFrxJnaVA8Rg2LgxD+0XkE2CEWb
        YyXKKc9/cIvlvVMHR2kPvGGKRBFIYYI=
Date:   Sat, 25 Mar 2023 15:10:29 -0700
MIME-Version: 1.0
Subject: Re: [Patch net-next v3] sock_map: dump socket map id via diag
Content-Language: en-US
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
References: <20230319191913.61236-1-xiyou.wangcong@gmail.com>
 <CAKH8qBtoYREbbRaedAfv=cEv2a5gBEYLSLy2eqcMYvsN7sqE=Q@mail.gmail.com>
 <2b3b7e9c-8ed6-71b5-8002-beb5520334cc@linux.dev>
 <ZB9ZIG9fgWKKHL17@pop-os.localdomain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <ZB9ZIG9fgWKKHL17@pop-os.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/23 1:27 PM, Cong Wang wrote:
> On Mon, Mar 20, 2023 at 01:29:39PM -0700, Martin KaFai Lau wrote:
>> On 3/20/23 11:13 AM, Stanislav Fomichev wrote:
>>> One thing I still don't understand here: what is missing from the
>>> socket iterators to implement this? Is it all the sk_psock_get magic?
>>> I remember you dismissed Yonghong's suggestion on v1, but have you
>>> actually tried it?
>> would be useful to know what is missing to print the bpf map id without
>> adding kernel code. There is new bpf_rdonly_cast() which will be useful here
>> also.
> 
> So you don't consider eBPF code as kernel code, right? Interestingly
> enough, eBPF code runs in kernel... and you still need to write eBPF
> code. So what is the point of "without adding kernel code" here?

Interesting, how is it the same? if it needs to print something other than the 
map id in the future, even putting aside further kernel maintenance and 
additional review, does a new bpf prog need to upgrade and reboot the kernel?

Based on your idea, all possible sk_filter automatically qualify to be added to 
the kernel source tree now because they also run in the kernel?

> 
> What is even more interesting is that even your own code does not agree
> with you here, for example, you introduced INET_DIAG_SK_BPF_STORAGES, so
> what was missing to print sk bpf storage without adding kernel code?

Yep, you are absolutely correct. Only if bpf-iter was available earlier. If 
bpf-iter was available before INET_DIAG_SK_BPF_STORAGES was added, there was no 
need to add INET_DIAG_SK_BPF_STORAGES and it would be no brainer to explore the 
bpf-iter approach first. Things have been improving.

The question (from a few people) was to figure out what was missing in the 
bpf-iter approach to print this bpf bits and trying to help. It is the only 
reason I replied. Apparently, you have not even tried and not interested.

