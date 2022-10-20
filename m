Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF891605777
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJTGkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiJTGkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:40:22 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E8FE9844;
        Wed, 19 Oct 2022 23:40:20 -0700 (PDT)
Message-ID: <de696460-ab5c-0770-017a-2af06eab5187@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666248018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uhdh9g0+vJc73d6aMWDXOTxTHrUGZI++5TMYFVK+lVg=;
        b=C5NxdRaejuylwhnv6KA06MoxE4vXK/s86uMDVo8/C/sAtowJK9bjfuFhE9E2v/kHz1yTeK
        fK0p75H7CL5CwGpCpklG3DPb5TbmRNwj9fePqBx0IgsRNI4FCZkDjXCNy/ewRRvNjWO7BH
        bPzEtBGwCOqzHY2NUgOt/0svwLzTq1w=
Date:   Wed, 19 Oct 2022 23:40:11 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v6 1/3] bpf: Add skb dynptrs
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        martin.lau@kernel.org, kuba@kernel.org, memxor@gmail.com,
        toke@redhat.com, netdev@vger.kernel.org, kernel-team@fb.com,
        bpf@vger.kernel.org
References: <20220907183129.745846-1-joannelkoong@gmail.com>
 <20220907183129.745846-2-joannelkoong@gmail.com>
 <cd8d201b-74f7-4045-ad2f-6d26ed608d1e@linux.dev>
 <CAJnrk1ZTbHcFsQPKWnZ+Au8BsiFc++Ud7y=24mAhNXNbYQaXhA@mail.gmail.com>
 <8f900712-8dcc-5f39-7a66-b6b2e4162f94@linux.dev>
In-Reply-To: <8f900712-8dcc-5f39-7a66-b6b2e4162f94@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/22 11:34 PM, Martin KaFai Lau wrote:
> On 10/19/22 1:22 PM, Joanne Koong wrote:
>> On Fri, Sep 9, 2022 at 4:12 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>
>>> On 9/7/22 11:31 AM, Joanne Koong wrote:
>>>> For bpf prog types that don't support writes on skb data, the dynptr is
>>>> read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
>>>> will return NULL; for a read-only data slice, there will be a separate
>>>> API bpf_dynptr_data_rdonly(), which will be added in the near future).
>>>>
>>> I just caught up on the v4 discussion about loadtime-vs-runtime error on
>>> write.  From a user perspective, I am not concerned on which error.
>>> Either way, I will quickly find out the packet header is not changed.
>>>
>>> For the dynptr init helper bpf_dynptr_from_skb(), the user does not need
>>> to know its skb is read-only or not and uses the same helper.  The
>>> verifier in this case uses its knowledge on the skb context and uses
>>> bpf_dynptr_from_skb_rdonly_proto or bpf_dynptr_from_skb_rdwr_proto
>>> accordingly.
>>>
>>> Now for the slice helper, the user needs to remember its skb is read
>>> only (or not) and uses bpf_dynptr_data() vs bpf_dynptr_data_rdonly()
>>> accordingly.  Yes, if it only needs to read, the user can always stay
>>> with bpf_dynptr_data_rdonly (which is not the initially supported one
>>> though).  However, it is still unnecessary burden and surprise to user.
>>> It is likely it will silently turn everything into bpf_dynptr_read()
>>> against the user intention. eg:
>>>
>>> if (bpf_dynptr_from_skb(skb, 0, &dynptr))
>>>          return 0;
>>> ip6h = bpf_dynptr_data(&dynptr, 0, sizeof(*ip6h));
>>> if (!ip6h) {
>>>          /* Unlikely case, in non-linear section, just bpf_dynptr_read()
>>>           * Oops...actually bpf_dynptr_data_rdonly() should be used.
>>>           */
>>>          bpf_dynptr_read(buf, sizeof(*ip6h), &dynptr, 0, 0);
>>>          ip6h = buf;
>>> }
>>>
>>
>> I see your point. I agree that it'd be best if we could prevent this
>> burden on the user, but I think the trade-off would be that if we have
>> bpf_dynptr_data return data slices that are read-only and data slices
>> that are writable (where rd-only vs. writable is tracked by verifier),
>> then in the future we won't be able to support dynptrs that are
>> dynamically read-only (since to reject at load time, the verifier must
>> know statically whether the dynptr is read-only or not). I'm not sure
>> how likely it is that we'd run into a case where we'll need dynamic
>> read-only dynptrs though. What are your thoughts on this?
> 
> Out of all dynptr helpers, bpf_dynptr_data() is pretty much the only important 
> function for header parsing because of the runtime offset.  This offset is good 
> to be tracked in runtime to avoid smart compiler getting in the way.  imo, 
> making this helper less usage surprise is important.  If the verifier can help, 
> then static checking is useful here.
> 
> It is hard to comment without a real use case on when we want to flip a dynptr 
> to rdonly in a dynamic/runtime way.  Thus, comparing with the example like the 
> skb here, my preference is pretty obvious :)
> Beside, a quick thought is doing this static checking now should now stop the 

typo: should *not* stop the... :(

> dynamic rdonly flip later.  I imagine it will be a helper call like 
> bpf_dynptr_set_rdonly().  The verifier should be able to track this helper call.

