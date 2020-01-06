Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6A3131B88
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgAFWfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:35:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:41688 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAFWfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:35:08 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ioaxl-0003Pm-7W; Mon, 06 Jan 2020 23:35:05 +0100
Received: from [178.197.249.51] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ioaxk-000JD8-UH; Mon, 06 Jan 2020 23:35:04 +0100
Subject: Re: [PATCH][bpf-next] bpf: change bpf_skb_generic_push type as void
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Li RongQing <lirongqing@baidu.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1578031353-27654-1-git-send-email-lirongqing@baidu.com>
 <20200103082712.GF12930@netronome.com>
 <CAPhsuW6z+jh0xofi8FCA0uvTJ5jSL_ZGpwPu1Eg566XeJ03pZA@mail.gmail.com>
 <20200106223206.uxq6isyk7pjruxx3@ast-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f5477d69-f028-a0ca-6889-fecca3769582@iogearbox.net>
Date:   Mon, 6 Jan 2020 23:35:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200106223206.uxq6isyk7pjruxx3@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25686/Mon Jan  6 10:55:07 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/20 11:32 PM, Alexei Starovoitov wrote:
> On Fri, Jan 03, 2020 at 11:18:28AM -0800, Song Liu wrote:
>> On Fri, Jan 3, 2020 at 12:27 AM Simon Horman <simon.horman@netronome.com> wrote:
>>> On Fri, Jan 03, 2020 at 02:02:33PM +0800, Li RongQing wrote:
>>>> bpf_skb_generic_push always returns 0, not need to check
>>>> its return, so change its type as void
>>>>
>>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>>
>>> Reviewed-by: Simon Horman <simon.horman@netronome.com>
>> Acked-by: Song Liu <songliubraving@fb.com>
>>
>>>
>>>> ---
>>>>   net/core/filter.c | 30 ++++++++++--------------------
>>>>   1 file changed, 10 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>> index 42fd17c48c5f..1cbac34a4e11 100644
>>>> --- a/net/core/filter.c
>>>> +++ b/net/core/filter.c
>>>
>>> ...
>>>
>>>> @@ -5144,7 +5134,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
>>>>                if (unlikely(ret < 0))
>>>>                        return ret;
>>>>
>>>> -             ret = bpf_skb_net_hdr_push(skb, offset, len);
>>>> +             bpf_skb_net_hdr_push(skb, offset, len);
>>>
>>> There is a check for (ret < 0) just below this if block.
>>> That is ok becuase in order to get to here (ret < 0) must
>>> be true as per the check a few lines above.
>>>
>>> So I think this is ok although the asymmetry with the else arm
>>> of this if statement is not ideal IMHO.
>>
>> Agreed with this concern. But I cannot think of any free solution. I guess we
>> will just live with assumption that skb_cow_head() never return >0.
> 
> I don't think this patch is worth doing.
> I can imagine bpf_skb_generic_push() handling some errors in the future.
> compiler can do this optimization job instead.

Yep, fully agree.
