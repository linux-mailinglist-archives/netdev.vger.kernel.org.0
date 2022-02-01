Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDBF4A6545
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbiBAUBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:01:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:53356 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234295AbiBAUBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 15:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643745684; x=1675281684;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=8pFfyb6Db6eeLbrqPdLT4F/jozq5PXnfq7n93BhoWxA=;
  b=FkmgEDaBZ83Zokecc2Fa13e3ZegfDKkEs3jrIkyqoHgY/j2KHnP0DbJ/
   nMm7j3eSxhIoFAqzKRemFKV3dnxKs8KNMwVdUR4hION0OtTcW6RhVV3Gh
   JPSsKNyZpfJmtllyjP+mzj4vv07gTnR1EaPMxgtzC6hcGT+FRa5JyBtYs
   xY92+bNVi2XOOtu5Jgq5BuLRq71gujl+h7q3fyKMCclegzxKkkEXIPduR
   lzly/vTY/PgBZzOe8wb1v4s7fLQyE90S8VLnKInQZmGAjRsbO4qlYxNAU
   6IilsSaUfrTuzQeIdJ5KnECjLWiLrfAIDdCb1TIt5/IcIrRCrBkZQEtDM
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="308506519"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="308506519"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 12:01:23 -0800
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="482512107"
Received: from ekebedex-mobl1.amr.corp.intel.com ([10.251.14.93])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 12:01:23 -0800
Date:   Tue, 1 Feb 2022 12:01:23 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Soheil Hassas Yeganeh <soheil@google.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH net] tcp: add missing tcp_skb_can_collapse() test in
 tcp_shift_skb_data()
In-Reply-To: <CACSApvZ8vXXJ_zKf_HpoVgACwWxS2UvBw9QCv1ZnPX9ZpF3D_g@mail.gmail.com>
Message-ID: <62ad3eb-cbb6-a59e-f5fe-5c439d21e760@linux.intel.com>
References: <20220201184640.756716-1-eric.dumazet@gmail.com> <CACSApvZ8vXXJ_zKf_HpoVgACwWxS2UvBw9QCv1ZnPX9ZpF3D_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Feb 2022, Soheil Hassas Yeganeh wrote:

> On Tue, Feb 1, 2022 at 1:46 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> From: Eric Dumazet <edumazet@google.com>
>>
>> tcp_shift_skb_data() might collapse three packets into a larger one.
>>
>> P_A, P_B, P_C  -> P_ABC
>>
>> Historically, it used a single tcp_skb_can_collapse_to(P_A) call,
>> because it was enough.
>>
>> In commit 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions"),
>> this call was replaced by a call to tcp_skb_can_collapse(P_A, P_B)
>>
>> But the now needed test over P_C has been missed.
>>
>> This probably broke MPTCP.
>>
>> Then later, commit 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
>> added an extra condition to tcp_skb_can_collapse(), but the missing call
>> from tcp_shift_skb_data() is also breaking TCP zerocopy, because P_A and P_C
>> might have different skb_zcopy_pure() status.
>>
>> Fixes: 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions")
>> Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
>> Cc: Talal Ahmad <talalahmad@google.com>
>> Cc: Arjun Roy <arjunroy@google.com>
>> Cc: Soheil Hassas Yeganeh <soheil@google.com>
>> Cc: Willem de Bruijn <willemb@google.com>
>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>
> I wish there were some packetdrill tests for MPTCP. Thank you for the fix!
>

Soheil -

I have good news, there are packetdrill tests for MPTCP:

https://github.com/multipath-tcp/packetdrill

This is still in a fork. I think Davide has talked to Neal about 
upstreaming the MPTCP changes before but there may be some code that needs 
refactoring before that could happen.


>> ---
>>  net/ipv4/tcp_input.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index dc49a3d551eb919baf5ad812ef21698c5c7b9679..bfe4112e000c09ba9d7d8b64392f52337b9053e9 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -1660,6 +1660,8 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
>>             (mss != tcp_skb_seglen(skb)))
>>                 goto out;
>>
>> +       if (!tcp_skb_can_collapse(prev, skb))
>> +               goto out;
>>         len = skb->len;
>>         pcount = tcp_skb_pcount(skb);
>>         if (tcp_skb_shift(prev, skb, pcount, len))
>> --
>> 2.35.0.rc2.247.g8bbb082509-goog
>>
>

--
Mat Martineau
Intel
