Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590C42B07B7
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 15:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgKLOnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 09:43:24 -0500
Received: from mga03.intel.com ([134.134.136.65]:41817 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbgKLOnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 09:43:22 -0500
IronPort-SDR: 5i+4koJskDkKw7MM+Gn1iBensAviWskUsBQuCg7KhrJMd4WK1gv9s6NdFbE7o874LQMjs5cjlY
 oxpoO4ojPyew==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="170423258"
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="170423258"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 06:43:13 -0800
IronPort-SDR: 2wx5EyFlGRm8nWbprMq0XRbIa4jT6molrvV9TFwSlZjIiXQb+NsxgQXXH4scjirTrJ2wKADBWL
 lWLk4MfLIyig==
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="542279315"
Received: from geigerri-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.34.175])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 06:43:07 -0800
Subject: Re: [PATCH bpf-next 1/9] net: introduce preferred busy-polling
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
 <20201112114041.131998-2-bjorn.topel@gmail.com>
 <CANn89iL=j38rdsKhAm8_4pMbf=vyAZ8SVoUkUgEVUF0GEXRwRg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <55917726-33d0-7a1f-ea4e-0ed0c76ee039@intel.com>
Date:   Thu, 12 Nov 2020 15:43:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <CANn89iL=j38rdsKhAm8_4pMbf=vyAZ8SVoUkUgEVUF0GEXRwRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-12 15:38, Eric Dumazet wrote:
> On Thu, Nov 12, 2020 at 12:41 PM Björn Töpel <bjorn.topel@gmail.com> wrote:
>>
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The existing busy-polling mode, enabled by the SO_BUSY_POLL socket
>> option or system-wide using the /proc/sys/net/core/busy_read knob, is
>> an opportunistic. That means that if the NAPI context is not
>> scheduled, it will poll it. If, after busy-polling, the budget is
>> exceeded the busy-polling logic will schedule the NAPI onto the
>> regular softirq handling.
>>
>> One implication of the behavior above is that a busy/heavy loaded NAPI
>> context will never enter/allow for busy-polling. Some applications
>> prefer that most NAPI processing would be done by busy-polling.
>>
>> This series adds a new socket option, SO_PREFER_BUSY_POLL, that works
>> in concert with the napi_defer_hard_irqs and gro_flush_timeout
>> knobs. The napi_defer_hard_irqs and gro_flush_timeout knobs were
>> introduced in commit 6f8b12d661d0 ("net: napi: add hard irqs deferral
>> feature"), and allows for a user to defer interrupts to be enabled and
>> instead schedule the NAPI context from a watchdog timer. When a user
>> enables the SO_PREFER_BUSY_POLL, again with the other knobs enabled,
>> and the NAPI context is being processed by a softirq, the softirq NAPI
>> processing will exit early to allow the busy-polling to be performed.
>>
>> If the application stops performing busy-polling via a system call,
>> the watchdog timer defined by gro_flush_timeout will timeout, and
>> regular softirq handling will resume.
>>
>> In summary; Heavy traffic applications that prefer busy-polling over
>> softirq processing should use this option.
>>
>> Example usage:
>>
>>    $ echo 2 | sudo tee /sys/class/net/ens785f1/napi_defer_hard_irqs
>>    $ echo 200000 | sudo tee /sys/class/net/ens785f1/gro_flush_timeout
>>
>> Note that the timeout should be larger than the userspace processing
>> window, otherwise the watchdog will timeout and fall back to regular
>> softirq processing.
>>
>> Enable the SO_BUSY_POLL/SO_PREFER_BUSY_POLL options on your socket.
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> 
> ...
> 
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 727ea1cc633c..248f6a763661 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -1159,6 +1159,12 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>>                                  sk->sk_ll_usec = val;
>>                  }
>>                  break;
>> +       case SO_PREFER_BUSY_POLL:
>> +               if (valbool && !capable(CAP_NET_ADMIN))
>> +                       ret = -EPERM;
>> +               else
>> +                       sk->sk_prefer_busy_poll = valbool;
> 
>                              WRITE_ONCE(sk->sk_prefer_busy_poll, valbool);
> 
> So that KCSAN is happy while readers read this field while socket is not locked.
>

Thanks Eric, I'll fix that!

Also, in patch 5, READ_ONCE is missing. I'll address that as well.

