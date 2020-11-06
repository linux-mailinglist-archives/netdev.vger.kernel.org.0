Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E522A9DC4
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgKFTQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 14:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgKFTQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 14:16:50 -0500
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5832EC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 11:16:50 -0800 (PST)
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id C75CD1FA9D;
        Fri,  6 Nov 2020 21:16:46 +0200 (EET)
References: <20201031201644.247605-1-vlad@buslov.dev> <20201031202522.247924-1-vlad@buslov.dev> <ddd99541-204c-1b29-266f-2d7f4489d403@gmail.com> <87wnz25vir.fsf@buslov.dev> <178bdf87-8513-625f-1b2e-79ad435bcdf3@mojatatu.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, davem@davemloft.net, kuba@kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2-next] tc: implement support for action terse dump
In-reply-to: <178bdf87-8513-625f-1b2e-79ad435bcdf3@mojatatu.com>
Date:   Fri, 06 Nov 2020 21:16:45 +0200
Message-ID: <87y2je9tya.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 03 Nov 2020 at 23:59, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-11-03 10:07 a.m., Vlad Buslov wrote:
>>
>> On Tue 03 Nov 2020 at 03:48, David Ahern <dsahern@gmail.com> wrote:
>>> On 10/31/20 2:25 PM, Vlad Buslov wrote:
>>>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>>>> index 5ad84e663d01..b486f52900f0 100644
>>>> --- a/include/uapi/linux/rtnetlink.h
>>>> +++ b/include/uapi/linux/rtnetlink.h
>>>> @@ -768,8 +768,12 @@ enum {
>>>>    * actions in a dump. All dump responses will contain the number of actions
>>>>    * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
>>>>    *
>>>> + * TCA_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
>>>> + * includes essential action info (kind, index, etc.)
>>>> + *
>>>>    */
>>>>   #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
>>>> +#define TCA_FLAG_TERSE_DUMP		(1 << 1)
>>>>   
>>>
>>> there is an existing TCA_DUMP_FLAGS_TERSE. How does this differ and if
>>> it really is needed please make it different enough and documented to
>>> avoid confusion.
>>
>> TCA_FLAG_TERSE_DUMP is a bit in TCA_ROOT_FLAGS tlv which is basically
>> "action flags". TCA_DUMP_FLAGS_TERSE is a bit in TCA_DUMP_FLAGS tlv
>> which is dedicated flags attribute for filter dump. We can't just reuse
>> existing filter dump constant because its value "1" is already taken by
>> TCA_FLAG_LARGE_DUMP_ON. This might look confusing, but what do you
>> suggest? Those are two unrelated tlv's. I can rename the constant name
>> to TCA_FLAG_ACTION_TERSE_DUMP to signify that the flag is action
>> specific, but that would make the naming inconsistent with existing
>> TCA_FLAG_LARGE_DUMP_ON.
>>
>
> Its unfortunate that the TCA_ prefix ended being used for both filters
> and actions. Since we only have a couple of flags maybe it is not too
> late to have a prefix TCAA_ ? For existing flags something like a
> #define TCAA_FLAG_LARGE_DUMP_ON TCA_FLAG_LARGE_DUMP_ON
> in the uapi header will help. Of course that would be a separate
> patch which will require conversion code in both the kernel and user
> space.

I can send a followup patch, assuming David is satisfied with proposed
change.

>
> FWIW, the patch is good for what i tested. So even if you do send an
> update with a name change please add:
>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
>
> cheers,
> jamal

