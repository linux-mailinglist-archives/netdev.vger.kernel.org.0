Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9525BB3F0
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 23:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiIPVbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 17:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiIPVbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 17:31:43 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA54ABB02C;
        Fri, 16 Sep 2022 14:31:38 -0700 (PDT)
Message-ID: <a774a513-284c-eb1f-7578-bb6d475b0509@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663363896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aUusDOzWHis+2UidmSCMnHqSklJAdLsrWVsXfECqtNY=;
        b=lYsuwfgmyLGn2XjImpB5vaLtD4AB1q+UrezIaQ0GKOgaOkdxm3boMHN3iUPQze3ccbED6y
        4WUW/rKFNqS0sNy2YL/JSoshVWp0CkTvIWHzlzohUxPUjCNo7pSBsaUi1w+fO95jrSP7WT
        271VolouyUTVNjdHfEroAJd1Xzco07A=
Date:   Fri, 16 Sep 2022 14:31:25 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next] bpf: Move nf_conn extern declarations to
 filter.h
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
References: <c4cb11c8ffe732b91c175a0fc80d43b2547ca17e.1662920329.git.dxu@dxuuu.xyz>
 <ada17021-83c9-3dad-5992-4885e824ecac@linux.dev>
 <CAP01T74=btUEPDrz0EVm9wNuMmbbqc2wRvtpJ-Qq45OtasMBZQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAP01T74=btUEPDrz0EVm9wNuMmbbqc2wRvtpJ-Qq45OtasMBZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/22 1:35 PM, Kumar Kartikeya Dwivedi wrote:
> On Fri, 16 Sept 2022 at 22:20, Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>
>> On 9/11/22 11:19 AM, Daniel Xu wrote:
>>> We're seeing the following new warnings on netdev/build_32bit and
>>> netdev/build_allmodconfig_warn CI jobs:
>>>
>>>       ../net/core/filter.c:8608:1: warning: symbol
>>>       'nf_conn_btf_access_lock' was not declared. Should it be static?
>>>       ../net/core/filter.c:8611:5: warning: symbol 'nfct_bsa' was not
>>>       declared. Should it be static?
>>>
>>> Fix by ensuring extern declaration is present while compiling filter.o.
>>>
>>> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
>>> ---
>>>    include/linux/filter.h                   | 6 ++++++
>>>    include/net/netfilter/nf_conntrack_bpf.h | 7 +------
>>>    2 files changed, 7 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>>> index 527ae1d64e27..96de256b2c8d 100644
>>> --- a/include/linux/filter.h
>>> +++ b/include/linux/filter.h
>>> @@ -567,6 +567,12 @@ struct sk_filter {
>>>
>>>    DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>>>
>>> +extern struct mutex nf_conn_btf_access_lock;
>>> +extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
>>> +                    const struct btf_type *t, int off, int size,
>>> +                    enum bpf_access_type atype, u32 *next_btf_id,
>>> +                    enum bpf_type_flag *flag);
>>
>> Can it avoid leaking the nfct specific details like
>> 'nf_conn_btf_access_lock' and the null checking on 'nfct_bsa' to
>> filter.c?  In particular, this code snippet in filter.c:
>>
>>           mutex_lock(&nf_conn_btf_access_lock);
>>           if (nfct_bsa)
>>                   ret = nfct_bsa(log, btf, ....);
>>          mutex_unlock(&nf_conn_btf_access_lock);
>>
>>
>> Can the lock and null check be done as one function (eg.
>> nfct_btf_struct_access()) in nf_conntrack_bpf.c and use it in filter.c
>> instead?
> 
> Don't think so, no. Because we want nf_conntrack to work as a module as well.
Ah, got it.

I don't see nf_conntrack_btf_struct_access() in nf_conntrack_bpf.h is 
used anywhere.  Can be removed?

> I was the one who suggested nf_conn specific names for now. There is
> no other user of such module supplied
> btf_struct_access callbacks yet, when one appears, we should instead
> make registration of such callbacks properly generic (i.e. also
> enforce it is only for module BTF ID etc.).
> But that would be a lot of code without any users right now.

The lock is the only one needed to be in btf.c and 
nfct_btf_struct_access() can be an inline in nf_conntrack_bpf.h instead?

