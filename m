Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719E327E52
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfEWNkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:40:15 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45991 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729902AbfEWNkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 09:40:15 -0400
Received: by mail-pg1-f196.google.com with SMTP id i21so3154263pgi.12;
        Thu, 23 May 2019 06:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rUmn2ja+dsx9T2AcDt5tXF1htUylMgRP4W5rbRUkVzc=;
        b=YB4ulEPR3jivWmBVHuBPwvxC1HlR4seDKuueZMQzHiRG+gHPPekKClgOPgKJzS0tHz
         /FIR6W32MEVJ2MD62aIEzhx6b5gs8MuoG1T99W47PcSYv5EjY1uhVsao6M4W2KZi8ccO
         bLEaXn6bli2/uIia/zffYYDC1jLNYZCQ+5JpChaju0bkizrmObTvAZQJ4zN7l8WRBeo6
         m+TbO9z6/bq0wwZDji+x0M5wKZKN5YuuE+deIYILoIDOxxn5/PPkX0HtIm5noCSMBgm5
         v/XQ48MSdJq6f1kH1yv2A39hfxzKxFj5419ZpktcBDJ7hR4LqtHwIMmpewR++/XtPQ20
         5ytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rUmn2ja+dsx9T2AcDt5tXF1htUylMgRP4W5rbRUkVzc=;
        b=A6D/bWCogQWyPzJgwB9T5sdEq+XUkNYjZbmxI90gArVyKVBS07WRXHJhIJC0ISTuTN
         e1UH/PYFAdz2btxFyAwsmL1B5NAeT1q/L0E5fFSbpcPqbyVcC0HXjS8jykOeJ5qlY9wU
         HEPRZ3D9OFRbkIXCaP7zfCKfkP4xAgs+oB74in0gFocduiKSqGFJqP2YDbMP2iIgzVrw
         1IhSQE4jK+nk5qozFUSqjkXh+z4+HGhOsNSR1vj+6+yNm4l9yPq1nozWMePF/1fKiTlj
         CIxPh9WSCR60/DBYzcY217N2baox+f2KuEyZSWVW0/0Z6apY3TBtB4WXYipcBwIq3lm6
         8zOA==
X-Gm-Message-State: APjAAAVbvYiAPdJNUL4VwRYIvGK47lh+19BaHmNGJhSvS3wd5N460rTV
        UYWYMc0o6JTPLzadhwyF8B0Bewux
X-Google-Smtp-Source: APXvYqxIu6XzktX/s4yteZjbE7Z9iAXvIxRKDHNvpaSuN/APrz6OzN02p30TI78QC1VD/rWwpOeg+A==
X-Received: by 2002:a62:ab10:: with SMTP id p16mr71842358pff.222.1558618814654;
        Thu, 23 May 2019 06:40:14 -0700 (PDT)
Received: from [192.168.1.9] (i223-218-240-142.s42.a013.ap.plala.or.jp. [223.218.240.142])
        by smtp.googlemail.com with ESMTPSA id h5sm19389001pfk.163.2019.05.23.06.40.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 06:40:13 -0700 (PDT)
Subject: Re: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <87zhnd1kg9.fsf@toke.dk> <599302b2-96d2-b571-01ee-f4914acaf765@lab.ntt.co.jp>
 <87sgt51i0e.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <0439f845-16cd-20ef-65e2-ebe6da11d57a@gmail.com>
Date:   Thu, 23 May 2019 22:40:09 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87sgt51i0e.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/23 (木) 21:18:25, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
> 
>> On 2019/05/23 20:25, Toke Høiland-Jørgensen wrote:
>>> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
>>>
>>>> This improves XDP_TX performance by about 8%.
>>>>
>>>> Here are single core XDP_TX test results. CPU consumptions are taken
>>>> from "perf report --no-child".
>>>>
>>>> - Before:
>>>>
>>>>    7.26 Mpps
>>>>
>>>>    _raw_spin_lock  7.83%
>>>>    veth_xdp_xmit  12.23%
>>>>
>>>> - After:
>>>>
>>>>    7.84 Mpps
>>>>
>>>>    _raw_spin_lock  1.17%
>>>>    veth_xdp_xmit   6.45%
>>>>
>>>> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
>>>> ---
>>>>   drivers/net/veth.c | 26 +++++++++++++++++++++++++-
>>>>   1 file changed, 25 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>>> index 52110e5..4edc75f 100644
>>>> --- a/drivers/net/veth.c
>>>> +++ b/drivers/net/veth.c
>>>> @@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>>   	return ret;
>>>>   }
>>>>   
>>>> +static void veth_xdp_flush_bq(struct net_device *dev)
>>>> +{
>>>> +	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
>>>> +	int sent, i, err = 0;
>>>> +
>>>> +	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);
>>>
>>> Wait, veth_xdp_xmit() is just putting frames on a pointer ring. So
>>> you're introducing an additional per-cpu bulk queue, only to avoid lock
>>> contention around the existing pointer ring. But the pointer ring is
>>> per-rq, so if you have lock contention, this means you must have
>>> multiple CPUs servicing the same rq, no?
>>
>> Yes, it's possible. Not recommended though.
>>
>>> So why not just fix that instead?
>>
>> The queues are shared with packets from stack sent from peer. That's
>> because I needed the lock. I have tried to separate the queues, one for
>> redirect and one for stack, but receiver side got too complicated and it
>> ended up with worse performance.
> 
> I meant fix it with configuration. Now many receive queues are you
> running on the veth device in your benchmarks, and how have you
> configured the RPS?

As I wrote this test is a single queue test and does not have any 
contention.
Per packet lock has some overhead even in that configuration.

Toshiaki Makita

