Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEE64065A7
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 04:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhIJCVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 22:21:43 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.219]:51665 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229628AbhIJCVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 22:21:42 -0400
HMM_SOURCE_IP: 172.18.0.218:58442.420792233
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.86.5.93 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 1B58D2800BF;
        Fri, 10 Sep 2021 10:20:19 +0800 (CST)
X-189-SAVE-TO-SEND: zhenggy@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id c4ed38dce6094429a7c177322764116b for kuba@kernel.org;
        Fri, 10 Sep 2021 10:20:31 CST
X-Transaction-ID: c4ed38dce6094429a7c177322764116b
X-Real-From: zhenggy@chinatelecom.cn
X-Receive-IP: 172.18.0.218
Sender: zhenggy@chinatelecom.cn
Subject: Re: [PATCH] net: fix tp->undo_retrans accounting in tcp_sacktag_one()
To:     Neal Cardwell <ncardwell@google.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
References: <1630238373-12912-1-git-send-email-zhenggy@chinatelecom.cn>
 <CADVnQykZvz3qSEm3c16cHOG66nwXnRVq5FhBT05h6Dj4dnxyiQ@mail.gmail.com>
From:   zhenggy <zhenggy@chinatelecom.cn>
Message-ID: <b1064d37-5510-c38b-d046-f914337cfe0b@chinatelecom.cn>
Date:   Fri, 10 Sep 2021 10:20:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CADVnQykZvz3qSEm3c16cHOG66nwXnRVq5FhBT05h6Dj4dnxyiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi，Neal：

Thanks very much for your checking, I will send a v2 patch to make it.

在 2021/9/9 21:38, Neal Cardwell 写道:
> On Thu, Sep 9, 2021 at 6:34 AM zhenggy <zhenggy@chinatelecom.cn> wrote:
>>
>> Commit a71d77e6be1e ("tcp: fix segment accounting when DSACK range covers
>> multiple segments") fix some DSACK accounting for multiple segments.
>> In tcp_sacktag_one(), we should also use the actual DSACK rang(pcount)
>> for tp->undo_retrans accounting.
>>
>> Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>
>> ---
>>  net/ipv4/tcp_input.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index 3f7bd7a..141e85e 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -1346,7 +1346,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
>>         if (dup_sack && (sacked & TCPCB_RETRANS)) {
>>                 if (tp->undo_marker && tp->undo_retrans > 0 &&
>>                     after(end_seq, tp->undo_marker))
>> -                       tp->undo_retrans--;
>> +                       tp->undo_retrans = max_t(int, 0, tp->undo_retrans - pcount);
>>                 if ((sacked & TCPCB_SACKED_ACKED) &&
>>                     before(start_seq, state->reord))
>>                                 state->reord = start_seq;
>> --
> 
> Thanks for the fix!
> 
> I think it would be useful to have a Fixes: footer to help maintainers
> know how far back to backport the fix.
> 
> I think an appropriate fixes footer might be the following:
> 
> Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
> 
> Before that commit, the assumption underlying the tp->undo_retrans--
> seems correct, AFAICT.
> 
> thanks,
> neal
> 
