Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3502A48EF
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgKCPHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgKCPHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:07:30 -0500
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263C6C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 07:07:30 -0800 (PST)
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 0A64D1FFB3;
        Tue,  3 Nov 2020 17:07:25 +0200 (EET)
References: <20201031201644.247605-1-vlad@buslov.dev> <20201031202522.247924-1-vlad@buslov.dev> <ddd99541-204c-1b29-266f-2d7f4489d403@gmail.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     David Ahern <dsahern@gmail.com>
Cc:     jhs@mojatatu.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, davem@davemloft.net, kuba@kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2-next] tc: implement support for action terse dump
In-reply-to: <ddd99541-204c-1b29-266f-2d7f4489d403@gmail.com>
Date:   Tue, 03 Nov 2020 17:07:24 +0200
Message-ID: <87wnz25vir.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 03 Nov 2020 at 03:48, David Ahern <dsahern@gmail.com> wrote:
> On 10/31/20 2:25 PM, Vlad Buslov wrote:
>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>> index 5ad84e663d01..b486f52900f0 100644
>> --- a/include/uapi/linux/rtnetlink.h
>> +++ b/include/uapi/linux/rtnetlink.h
>> @@ -768,8 +768,12 @@ enum {
>>   * actions in a dump. All dump responses will contain the number of actions
>>   * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
>>   *
>> + * TCA_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
>> + * includes essential action info (kind, index, etc.)
>> + *
>>   */
>>  #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
>> +#define TCA_FLAG_TERSE_DUMP		(1 << 1)
>>  
>
> there is an existing TCA_DUMP_FLAGS_TERSE. How does this differ and if
> it really is needed please make it different enough and documented to
> avoid confusion.

TCA_FLAG_TERSE_DUMP is a bit in TCA_ROOT_FLAGS tlv which is basically
"action flags". TCA_DUMP_FLAGS_TERSE is a bit in TCA_DUMP_FLAGS tlv
which is dedicated flags attribute for filter dump. We can't just reuse
existing filter dump constant because its value "1" is already taken by
TCA_FLAG_LARGE_DUMP_ON. This might look confusing, but what do you
suggest? Those are two unrelated tlv's. I can rename the constant name
to TCA_FLAG_ACTION_TERSE_DUMP to signify that the flag is action
specific, but that would make the naming inconsistent with existing
TCA_FLAG_LARGE_DUMP_ON.

