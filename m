Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1BE2B07BB
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 15:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgKLOpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 09:45:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:17665 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgKLOpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 09:45:51 -0500
IronPort-SDR: lIVe/r462j8jyITzOGIbdcocDAEN6fmmCZul7dE6Ue88swB9F6lqvmUPONDpd+XG/HattSnd8h
 Q51QWE0iAaqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="170482625"
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="170482625"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 06:45:40 -0800
IronPort-SDR: TN6bxwzbqoYGyDaP16dmzETsNXxfLjUrZmlyuA3QZhGcua2QYvLEl45CisQXfDaha2T/zc7k3M
 +g4KmxpgfJyg==
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="542280087"
Received: from geigerri-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.34.175])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 06:45:36 -0800
Subject: Re: [PATCH bpf-next 2/9] net: add SO_BUSY_POLL_BUDGET socket option
To:     Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        magnus.karlsson@intel.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        maciej.fijalkowski@intel.com,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        qi.z.zhang@intel.com, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com
References: <20201112114041.131998-1-bjorn.topel@gmail.com>
 <20201112114041.131998-3-bjorn.topel@gmail.com>
 <CANn89i+Zumgn+phZEYPb9yCQRrJ7UYh1wY7SBio6ykg2noYz2w@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <03a5a7d5-e5c9-5c61-8e8e-9393e8772d88@intel.com>
Date:   Thu, 12 Nov 2020 15:45:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <CANn89i+Zumgn+phZEYPb9yCQRrJ7UYh1wY7SBio6ykg2noYz2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-12 15:36, Eric Dumazet wrote:
> On Thu, Nov 12, 2020 at 12:41 PM Björn Töpel <bjorn.topel@gmail.com> wrote:
>>
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> This option lets a user set a per socket NAPI budget for
>> busy-polling. If the options is not set, it will use the default of 8.
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
>>
> 
> ...
> 
>>   #else /* CONFIG_NET_RX_BUSY_POLL */
>>   static inline unsigned long net_busy_loop_on(void)
>> @@ -106,7 +108,8 @@ static inline void sk_busy_loop(struct sock *sk, int nonblock)
>>
>>          if (napi_id >= MIN_NAPI_ID)
>>                  napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk,
>> -                              READ_ONCE(sk->sk_prefer_busy_poll));
>> +                              READ_ONCE(sk->sk_prefer_busy_poll),
>> +                              sk->sk_busy_poll_budget ?: BUSY_POLL_BUDGET);
> 
> Please use :
> 
>         READ_ONCE(sk->sk_busy_poll_budget) ?: BUSY_POLL_BUDGET
> 
> Because sk_busy_loop() is usually called without socket lock being held.
> 
> This will prevent yet another KCSAN report.
> 
>>   #endif
>>   }
>>
> 
> ...
> 
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -1165,6 +1165,16 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>>                  else
>>                          sk->sk_prefer_busy_poll = valbool;
>>                  break;
>> +       case SO_BUSY_POLL_BUDGET:
>> +               if (val > sk->sk_busy_poll_budget && !capable(CAP_NET_ADMIN)) {
>> +                       ret = -EPERM;
>> +               } else {
>> +                       if (val < 0)
> 
>                 if (val < 0 || val > (u16)~0)
> 
>> +                               ret = -EINVAL;
>> +                       else
>> +                               sk->sk_busy_poll_budget = val;
> 
> 
>                                 WRITE_ONCE(sk->sk_busy_poll_budget, val);
>

Thanks for the review! I'll address it all.


