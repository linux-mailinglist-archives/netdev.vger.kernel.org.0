Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9D6241D3C
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 17:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgHKPdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 11:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728859AbgHKPdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 11:33:00 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E66C06174A;
        Tue, 11 Aug 2020 08:33:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d188so7818997pfd.2;
        Tue, 11 Aug 2020 08:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=37WdC2DpKlpkgPtRRbtnkLSeSTMLbkdYcrwujx0kflA=;
        b=WRxdEfgwABYCWPxNXFQkp2sWJHfpiD+vbzCJPapYWGU8+JMlX0rUFqbPjg8MN1lxKn
         iR7TMR8XzsWTPuJwdfzL464B6YS/406anYjnJ4agumJ4vW1aRln8gXduhVnUbjqu6vKe
         FzAuPXHLDEt1O9qeiWz83rMO6Ovvikdc+StC2EDkV8/oJwRWiiF71jQrjY3OkduC/RGH
         dIy1N/HW8TjSLG/RUE7ZiIeY627GxEUbT9yZFl1YvDwE05Mt4h+tuO6x+sc9VLwwZv/i
         fY5bJb/i+LeDzCFy66/XuRPpFCnkTS/CxcYtFuFnIoNXCVIFrSIFcrAHpu8dcTfpz7gZ
         evIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=37WdC2DpKlpkgPtRRbtnkLSeSTMLbkdYcrwujx0kflA=;
        b=aHkm0BjGP1OtTN6AIZJtP6P/sFEZVZDsqt7TPDNqJMsEfEwD/q3upkzPedeJlCRlrS
         /4JZDnYjWiDiuciq8t8XEIhJGZ2M/UgxdrWRLOL0oYPvptdF0HTNKnLrBjtSlEkcvO4O
         ZTYW4Y7Yt91V2JfNF+27v/zHrw5+Sm2c6V8OH+YSjSWaX7qafQnRp51liO69QbUCtBb4
         5YHvl0GChR1LM8rk+a1DL/K3VGH/mRzL3CIlpifEj/sewhPL50Ex2dHlkOhVuXe+fumk
         DTUC5ABnEbxJ8IC/10z3Irjil4q71C+LVvdBLOM9xijEt+m4e1SIs18yGtg4dXdZMxWF
         23kQ==
X-Gm-Message-State: AOAM530c6LbJAY7c+R7dMS4zRoKGgtVJj3sMYjgakajAa9GrZZIPuVww
        sJEVJAHtY3UoNXSBwzrlZztQz6ir
X-Google-Smtp-Source: ABdhPJxXxMcM4WtijwyYUtIveBvV0Fh/XebCwvW9MnUglBFEzLNxOZi3ejJO0le6kOk/LK5ZmDlSwA==
X-Received: by 2002:aa7:968b:: with SMTP id f11mr6655235pfk.63.1597159980059;
        Tue, 11 Aug 2020 08:33:00 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m4sm2937988pfh.129.2020.08.11.08.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 08:32:59 -0700 (PDT)
Subject: Re: [PATCH v2 4.19] tcp: fix TCP socks unreleased in BBR mode
To:     Jason Xing <kerneljasonxing@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        liweishi <liweishi@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <20200604090014.23266-1-kerneljasonxing@gmail.com>
 <CANn89iKt=3iDZM+vUbCvO_aGuedXFhzdC6OtQMeVTMDxyp9bAg@mail.gmail.com>
 <CAL+tcoCU157eGmMMabT5icdFJTMEWymNUNxHBbxY1OTir0=0FQ@mail.gmail.com>
 <CAL+tcoA9SYUfge02=0dGbVidO0098NtT2+Ab_=OpWXnM82=RWQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bcbaf21e-681e-2797-023e-000dbd6434d1@gmail.com>
Date:   Tue, 11 Aug 2020 08:32:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAL+tcoA9SYUfge02=0dGbVidO0098NtT2+Ab_=OpWXnM82=RWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/20 3:37 AM, Jason Xing wrote:
> Hi everyone,
> 
> Could anyone take a look at this issue? I believe it is of high-importance.
> Though Eric gave the proper patch a few months ago, the stable branch
> still hasn't applied or merged this fix. It seems this patch was
> forgotten :(


Sure, I'll take care of this shortly.

Thanks.

> 
> Thanks,
> Jason
> 
> On Thu, Jun 4, 2020 at 9:47 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>>
>> On Thu, Jun 4, 2020 at 9:10 PM Eric Dumazet <edumazet@google.com> wrote:
>>>
>>> On Thu, Jun 4, 2020 at 2:01 AM <kerneljasonxing@gmail.com> wrote:
>>>>
>>>> From: Jason Xing <kerneljasonxing@gmail.com>
>>>>
>>>> When using BBR mode, too many tcp socks cannot be released because of
>>>> duplicate use of the sock_hold() in the manner of tcp_internal_pacing()
>>>> when RTO happens. Therefore, this situation maddly increases the slab
>>>> memory and then constantly triggers the OOM until crash.
>>>>
>>>> Besides, in addition to BBR mode, if some mode applies pacing function,
>>>> it could trigger what we've discussed above,
>>>>
>>>> Reproduce procedure:
>>>> 0) cat /proc/slabinfo | grep TCP
>>>> 1) switch net.ipv4.tcp_congestion_control to bbr
>>>> 2) using wrk tool something like that to send packages
>>>> 3) using tc to increase the delay and loss to simulate the RTO case.
>>>> 4) cat /proc/slabinfo | grep TCP
>>>> 5) kill the wrk command and observe the number of objects and slabs in
>>>> TCP.
>>>> 6) at last, you could notice that the number would not decrease.
>>>>
>>>> v2: extend the timer which could cover all those related potential risks
>>>> (suggested by Eric Dumazet and Neal Cardwell)
>>>>
>>>> Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
>>>> Signed-off-by: liweishi <liweishi@kuaishou.com>
>>>> Signed-off-by: Shujin Li <lishujin@kuaishou.com>
>>>
>>> That is not how things work really.
>>>
>>> I will submit this properly so that stable teams do not have to guess
>>> how to backport this to various kernels.
>>>
>>> Changelog is misleading, this has nothing to do with BBR, we need to be precise.
>>>
>>
>> Thanks for your help. I can finally apply this patch into my kernel.
>>
>> Looking forward to your patchset :)
>>
>> Jason
>>
>>> Thank you.
