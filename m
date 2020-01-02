Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51EE12E665
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 14:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgABNP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 08:15:57 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39991 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgABNP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 08:15:56 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so5595002wmi.5;
        Thu, 02 Jan 2020 05:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=64TJ5eJwOB4rGTlADQetJ1R5CZrE9F6rAEm0o8fdFcc=;
        b=XAbVROrmyyVvrrJd9zk6iACCMhRVyd3AEj+s81xAbQyM6q1+YlxqWpw+csbg1/8FHH
         sBkdMdbhdXtY3UxQF1x3LSQWB8MKAh2nXonW0BBdbn7W9JM3KEqnzVAriyDfoXbgdzwT
         vQB2fmHrm8tSKVAwygjQyedmuVRq9+mYjLnGepjkB+4HtOOGqvdxQXHHrcSZbYBvsQdi
         5/I1ya0HFOnQeimdSI6KthZMulNqPwQeFMCC8CHr3/opEJ3F6v4Xcp9dllghsrJQtgrP
         a51VhoeGKMO8YCmJHMgB5/Ssk8iSd6Y6xpQaWv+G69myu2W6P7aOKO4meyXNveram55C
         I6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=64TJ5eJwOB4rGTlADQetJ1R5CZrE9F6rAEm0o8fdFcc=;
        b=d4fAZyZvPp9hkkdFIoMZF7g2cwA9Xmy2Zlf5L6M20nlYV0v+Tn253iqWHwFEAEADCe
         Mo6OUaDHJhvP5oeGB9WMFk8mqZiqyNY9GrGhcawborZnOXK1Ypcmb/R/D5ptEvbDDkBy
         mAj8ce1S+zJFREYNzfhYo+zAfiHbIDjH5AGoh7QMCT2KNqKT5xHEtBFZNQMdwpFWHrNR
         lcxu47cqZZgGSWpskpafpvYyLOyI3I0x/TVqIvcKw+fQivKv7xhT7wrQWOVfGyWPjPUo
         vc9rB1jMEZW9rPy3Nomr6U8LyfijgPb8h+b9h7+GlhuhpkF8dkAinsiQGcaDLWR06z2D
         j1kw==
X-Gm-Message-State: APjAAAXJpDgzRVziAHqy5sq1SINvz9YXfvWekW0AIKrB4hsrJTUEQxU/
        iE6hANbWm8wS9KK7Cs9MUjQd+JQq
X-Google-Smtp-Source: APXvYqwreVBZ/MmivulLL+pVaI3+FuFE2OOZMUTzMunNO4Irty7tPtTcaoBx2GDFs05fWfvb2BAflw==
X-Received: by 2002:a05:600c:24ca:: with SMTP id 10mr14042557wmu.4.1577970953545;
        Thu, 02 Jan 2020 05:15:53 -0800 (PST)
Received: from [192.168.8.147] (195.171.185.81.rev.sfr.net. [81.185.171.195])
        by smtp.gmail.com with ESMTPSA id s3sm8640961wmh.25.2020.01.02.05.15.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 05:15:52 -0800 (PST)
Subject: Re: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated as
 D-SACK
To:     =?UTF-8?B?5p2o6bmP56iL?= <yangpc@wangsu.com>,
        'Eric Dumazet' <edumazet@google.com>
Cc:     'David Miller' <davem@davemloft.net>,
        'Alexey Kuznetsov' <kuznet@ms2.inr.ac.ru>,
        'Hideaki YOSHIFUJI' <yoshfuji@linux-ipv6.org>,
        'Alexei Starovoitov' <ast@kernel.org>,
        'Daniel Borkmann' <daniel@iogearbox.net>,
        'Martin KaFai Lau' <kafai@fb.com>,
        'Song Liu' <songliubraving@fb.com>,
        'Yonghong Song' <yhs@fb.com>, andriin@fb.com,
        'netdev' <netdev@vger.kernel.org>,
        'LKML' <linux-kernel@vger.kernel.org>
References: <000201d5c140$f5dd0cb0$e1972610$@wangsu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5f11208f-1a8b-23eb-1fdb-a70c6963d36a@gmail.com>
Date:   Thu, 2 Jan 2020 05:15:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <000201d5c140$f5dd0cb0$e1972610$@wangsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/1/20 11:48 PM, 杨鹏程 wrote:
> Hi Eric Dumazet,
> 
> I'm sorry there was a slight error in the packetdrill test case of the previous email reply,
> the ACK segment should not carry data, although this does not affect the description of the situation.
> I fixed the packetdrill test and resent it as follows:
> 
> packetdrill test case:
> // Verify the "old stuff" D-SACK causing SACK to be treated as D-SACK
> --tolerance_usecs=10000
> 
> // enable RACK and TLP
>     0 `sysctl -q net.ipv4.tcp_recovery=1; sysctl -q net.ipv4.tcp_early_retrans=3`
> 
> // Establish a connection, rtt = 10ms
>    +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
> 
>   +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
>    +0 > S. 0:0(0) ack 1 <...>
>  +.01 < . 1:1(0) ack 1 win 320
>    +0 accept(3, ..., ...) = 4
> 
> // send 10 data segments
>    +0 write(4, ..., 10000) = 10000
>    +0 > P. 1:10001(10000) ack 1
> 
> // send TLP
>  +.02 > P. 9001:10001(1000) ack 1
> 
> // enter recovery and retransmit 1:1001, now undo_marker = 1
> +.015 < . 1:1(0) ack 1 win 320 <sack 9001:10001, nop, nop>
>    +0 > . 1:1001(1000) ack 1
> 
> // ack 1:1001 and retransmit 1001:3001
>  +.01 < . 1:1(0) ack 1001 win 320 <sack 9001:10001, nop, nop>
>    +0 > . 1001:3001(2000) ack 1
> 
> // sack 2001:3001, now 2001:3001 has R|S
>  +.01 < . 1:1(0) ack 1001 win 320 <sack 2001:3001 9001:10001, nop, nop>
> 
> +0 %{ assert tcpi_reordering == 3, tcpi_reordering }%
> 
> // d-sack 1:1001, satisfies: undo_marker(1) <= start_seq < end_seq <= prior_snd_una(1001)
> // BUG: 2001:3001 is treated as D-SACK then reordering is modified in tcp_sacktag_one()
>    +0 < . 1:1(0) ack 1001 win 320 <sack 1:1001 2001:3001 9001:10001, nop, nop>
> 
> // reordering was modified to 8
> +0 %{ assert tcpi_reordering == 3, tcpi_reordering }%
> 
> 

Very nice, thanks a lot for this test !




> 
> -----邮件原件-----
> 发件人: 杨鹏程 <yangpc@wangsu.com> 
> 发送时间: 2020年1月1日 19:47
> 收件人: 'Eric Dumazet' <edumazet@google.com>
> 抄送: 'David Miller' <davem@davemloft.net>; 'Alexey Kuznetsov' <kuznet@ms2.inr.ac.ru>; 'Hideaki YOSHIFUJI' <yoshfuji@linux-ipv6.org>; 'Alexei Starovoitov' <ast@kernel.org>; 'Daniel Borkmann' <daniel@iogearbox.net>; 'Martin KaFai Lau' <kafai@fb.com>; 'Song Liu' <songliubraving@fb.com>; 'Yonghong Song' <yhs@fb.com>; 'andriin@fb.com' <andriin@fb.com>; 'netdev' <netdev@vger.kernel.org>; 'LKML' <linux-kernel@vger.kernel.org>
> 主题: Re: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK
> 
> Hi Eric Dumazet,
> 
> Thanks for discussing this issue.
> 
> 'previous sack segment was lost' means that the SACK segment carried by D-SACK will be processed by tcp_sacktag_one () due to the previous SACK loss, but this is not necessary.
> 
> Here is the packetdrill test, this example shows that the reordering was modified because the SACK segment was treated as D-SACK.
> 
> //dsack-old-stuff-bug.pkt
> // Verify the "old stuff" D-SACK causing SACK to be treated as D-SACK
> --tolerance_usecs=10000
> 
> // enable RACK and TLP
>     0 `sysctl -q net.ipv4.tcp_recovery=1; sysctl -q net.ipv4.tcp_early_retrans=3`
> 
> // Establish a connection, rtt = 10ms
>    +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
> 
>   +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
>    +0 > S. 0:0(0) ack 1 <...>
>  +.01 < . 1:1(0) ack 1 win 320
>    +0 accept(3, ..., ...) = 4
> 
> // send 10 data segments
>    +0 write(4, ..., 10000) = 10000
>    +0 > P. 1:10001(10000) ack 1
> 
> // send TLP
>  +.02 > P. 9001:10001(1000) ack 1
> 
> // enter recovery and retransmit 1:1001, now undo_marker = 1
> +.015 < . 1:1(0) ack 1 win 320 <sack 9001:10001, nop, nop>
>    +0 > . 1:1001(1000) ack 1
> 
> // ack 1:1001 and retransmit 1001:3001
>  +.01 < . 1:1001(1000) ack 1001 win 320 <sack 9001:10001, nop, nop>
>    +0 > . 1001:3001(2000) ack 1
> 
> // sack 2001:3001, now 2001:3001 has R|S
>  +.01 < . 1001:1001(0) ack 1001 win 320 <sack 2001:3001 9001:10001, nop, nop>
> 
> +0 %{ assert tcpi_reordering == 3, tcpi_reordering }%
> 
> // d-sack 1:1001, satisfies: undo_marker(1) <= start_seq < end_seq <= prior_snd_una(1001) // BUG: 2001:3001 is treated as D-SACK then reordering is modified in tcp_sacktag_one()
>    +0 < . 1001:1001(0) ack 1001 win 320 <sack 1:1001 2001:3001 9001:10001, nop, nop>
> 
> // reordering was modified to 8
> +0 %{ assert tcpi_reordering == 3, tcpi_reordering }%
> 
> 
> 
> 
> -----邮件原件-----
> 发件人: Eric Dumazet <edumazet@google.com>
> 发送时间: 2019年12月30日 21:41
> 收件人: Pengcheng Yang <yangpc@wangsu.com>
> 抄送: David Miller <davem@davemloft.net>; Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>; Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; Martin KaFai Lau <kafai@fb.com>; Song Liu <songliubraving@fb.com>; Yonghong Song <yhs@fb.com>; andriin@fb.com; netdev <netdev@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>
> 主题: Re: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK
> 
> On Mon, Dec 30, 2019 at 1:55 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>>
>> When we receive a D-SACK, where the sequence number satisfies:
>>         undo_marker <= start_seq < end_seq <= prior_snd_una we 
>> consider this is a valid D-SACK and tcp_is_sackblock_valid() returns 
>> true, then this D-SACK is discarded as "old stuff", but the variable 
>> first_sack_index is not marked as negative in 
>> tcp_sacktag_write_queue().
>>
>> If this D-SACK also carries a SACK that needs to be processed (for 
>> example, the previous SACK segment was lost),
> 
> What do you mean by ' previous sack segment was lost'  ?
> 
>  this SACK
>> will be treated as a D-SACK in the following processing of 
>> tcp_sacktag_write_queue(), which will eventually lead to incorrect 
>> updates of undo_retrans and reordering.
>>
>> Fixes: fd6dad616d4f ("[TCP]: Earlier SACK block verification & 
>> simplify access to them")
>> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
>> ---
>>  net/ipv4/tcp_input.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c index 
>> 88b987c..0238b55 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -1727,8 +1727,11 @@ static int tcp_sack_cache_ok(const struct tcp_sock *tp, const struct tcp_sack_bl
>>                 }
>>
>>                 /* Ignore very old stuff early */
>> -               if (!after(sp[used_sacks].end_seq, prior_snd_una))
>> +               if (!after(sp[used_sacks].end_seq, prior_snd_una)) {
>> +                       if (i == 0)
>> +                               first_sack_index = -1;
>>                         continue;
>> +               }
>>
>>                 used_sacks++;
>>         }
> 
> 
> Hi Pengcheng Yang
> 
> This corner case deserves a packetdrill test so that we understand the issue, can you provide one ?
> 
> Thanks.
> 
