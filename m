Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B9411D4F2
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbfLLSLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:11:18 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:42295 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730080AbfLLSLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:11:18 -0500
Received: by mail-pj1-f67.google.com with SMTP id o11so1351368pjp.9;
        Thu, 12 Dec 2019 10:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W4DxNw187O1EAJo02gwzf5htqxUEbPUyJC/3DQD2iQY=;
        b=pCaXtp0DTq76T/ezGaA/mlo4xCd/tGp/Q7Ks3010zuHtPe/tcPi/6tZ3z2iFj/AMuZ
         m9E3Sez3iGFF+Sdtrla4sAaplJpE1FS+PKs/Gq1eMCNhwXb4ImfSvcFOs1HtjIW57seq
         9LbnbtLrnUfot2+6GidLstNzIrx94oqMS38zIQp3fZLfsYQjvB4SJfOIn9V29qfFJgx6
         BWDl4iNvypPv+sTbMvgvYUlfaWVRjAvrb7rM4OFC8IMvIgqkJL8XBC4A0uzDHsNKxq3o
         b23zqRB2/tbIA7FR3ShTOV6jWmOo+xeAZX/o17snlphnYYr4xfXhDYHF5ifU7RlebCXk
         SO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W4DxNw187O1EAJo02gwzf5htqxUEbPUyJC/3DQD2iQY=;
        b=Uqty9gTtAGlQKmluY5T2UfgBy1ie/HBx+cMMph+Eg6fc7jmO3liwOVzjVlgkwppF2P
         aZtTnXvm2SVUeDUkuFSeB5sbtplJsPcN9dD9R2hMeTUxOKZt7wJvXYmg63RJeo7RmCwH
         wOzdOJesfGDm2rb/gK5Tc5wm8GlLQr2wiMEBgehfy/gpYRruBfHrK/wCowHr1h3yLg96
         u+oJU09+cei5Ys346ROFect3OleTE/8I5fGl5mKiLsFi82vKn3CdaWNxz64EXkqidPa9
         DyuPQuyUxlc4m5WMe5uTYMSgkOHiOXNVmSZmcDCjOIPnx+a2rDjm2KL+8XhSZjs5GA7m
         t/vQ==
X-Gm-Message-State: APjAAAXLxvYsFZsEGyPnshUYnVLub/CoBBpGNYek96jNuWR6SvyIaRte
        YxoS+2GEKj9Q8IoEr9Y1jjX9SBYY
X-Google-Smtp-Source: APXvYqyYvy1Szaas3XyfMFlCEXwjG1gu2h6yTc5dvH8MxVd0sGSwrAiyxySBwyJhtdn6dcQeZ4PAfg==
X-Received: by 2002:a17:90a:3aaf:: with SMTP id b44mr11667502pjc.9.1576174277202;
        Thu, 12 Dec 2019 10:11:17 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id g26sm7427542pfo.128.2019.12.12.10.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 10:11:16 -0800 (PST)
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Johannes Berg <johannes@sipsolutions.net>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
Date:   Thu, 12 Dec 2019 10:11:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/19 7:47 AM, Johannes Berg wrote:
> Hi Neal,
> 
> On Thu, 2019-12-12 at 10:11 -0500, Neal Cardwell wrote:
>> On Thu, Dec 12, 2019 at 9:50 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>>> If you have any thoughts on this, I'd appreciate it.
>>
>> Thanks for the detailed report!
> 
> Well, it wasn't. For example, I neglected to mention that I have to
> actually use at least 2 TCP streams (but have tried up to 20) in order
> to not run into the gbit link limit on the AP :-)
> 
>> I was curious:
>>
>> o What's the sender's qdisc configuration?
> 
> There's none, mac80211 bypasses qdiscs in favour of its internal TXQs
> with FQ/codel.
> 
>> o Would you be able to log periodic dumps (e.g. every 50ms or 100ms)
>> of the test connection using a recent "ss" binary and "ss -tinm", to
>> hopefully get a sense of buffer parameters, and whether the flow in
>> these cases is being cwnd-limited, pacing-limited,
>> send-buffer-limited, or receive-window-limited?
> 
> Sure, though I'm not sure my ss is recent enough for what you had in
> mind - if not I'll have to rebuild it (it was iproute2-ss190708).
> 
> https://p.sipsolutions.net/3e515625bf13fa69.txt
> 
> Note there are 4 connections (iperf is being used) but two are control
> and two are data. Easy to see the difference really :-)
> 
>> o Would you be able to share a headers-only tcpdump pcap trace?
> 
> I'm not sure how to do headers-only, but I guess -s100 will work.
> 
> https://johannes.sipsolutions.net/files/he-tcp.pcap.xz
> 

Lack of GRO on receiver is probably what is killing performance,
both for receiver (generating gazillions of acks) and sender (to process all these acks)

I had a plan about enabling compressing ACK as I did for SACK
in commit 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5d9f4262b7ea41ca9981cc790e37cca6e37c789e

But I have not done it yet.
It is a pity because this would tremendously help wifi I am sure.
