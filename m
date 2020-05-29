Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3BF1E78FF
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 11:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgE2JFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 05:05:19 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:53928 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725775AbgE2JFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 05:05:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=anny.hu@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0TzyLLYT_1590743112;
Received: from 30.25.84.75(mailfrom:anny.hu@linux.alibaba.com fp:SMTPD_---0TzyLLYT_1590743112)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 May 2020 17:05:13 +0800
Subject: Re: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg
To:     John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <db5393a3-d4b3-45c1-8219-f23b43a8d2ab.anny.hu@linux.alibaba.com>
 <5ecd85c7a21fd_35792ad4115a05b8a9@john-XPS-13-9370.notmuch>
From:   dihu <anny.hu@linux.alibaba.com>
Message-ID: <c2f19152-efd0-530f-8b59-74e2393cee0e@linux.alibaba.com>
Date:   Fri, 29 May 2020 17:05:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <5ecd85c7a21fd_35792ad4115a05b8a9@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/27 5:10, John Fastabend wrote:
> dihu wrote:
>>  From 865a45747de6b68fd02a0ff128a69a5c8feb73c3 Mon Sep 17 00:00:00 2001
>> From: dihu <anny.hu@linux.alibaba.com>
>> Date: Mon, 25 May 2020 17:23:16 +0800
>> Subject: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg
>>
>> When user application calls read() with MSG_PEEK flag to read data
>> of bpf sockmap socket, kernel panic happens at
>> __tcp_bpf_recvmsg+0x12c/0x350. sk_msg is not removed from ingress_msg
>> queue after read out under MSG_PEEK flag is set. Because it's not
>> judged whether sk_msg is the last msg of ingress_msg queue, the next
>> sk_msg may be the head of ingress_msg queue, whose memory address of
>> sg page is invalid. So it's necessary to add check codes to prevent
>> this problem.
>>
>> [20759.125457] BUG: kernel NULL pointer dereference, address:
>> 0000000000000008
>> [20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G            E
>> 5.4.32 #1
>> [20759.140890] Hardware name: Inspur SA5212M4/YZMB-00370-109, BIOS
>> 4.1.12 06/18/2017
>> [20759.149734] RIP: 0010:copy_page_to_iter+0xad/0x300
>> [20759.270877] __tcp_bpf_recvmsg+0x12c/0x350
>> [20759.276099] tcp_bpf_recvmsg+0x113/0x370
>> [20759.281137] inet_recvmsg+0x55/0xc0
>> [20759.285734] __sys_recvfrom+0xc8/0x130
>> [20759.290566] ? __audit_syscall_entry+0x103/0x130
>> [20759.296227] ? syscall_trace_enter+0x1d2/0x2d0
>> [20759.301700] ? __audit_syscall_exit+0x1e4/0x290
>> [20759.307235] __x64_sys_recvfrom+0x24/0x30
>> [20759.312226] do_syscall_64+0x55/0x1b0
>> [20759.316852] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Signed-off-by: dihu <anny.hu@linux.alibaba.com>
>> ---
>>   net/ipv4/tcp_bpf.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>> index 5a05327..c0d4624 100644
>> --- a/net/ipv4/tcp_bpf.c
>> +++ b/net/ipv4/tcp_bpf.c
>> @@ -64,6 +64,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>>     } while (i != msg_rx->sg.end);
>>
>>     if (unlikely(peek)) {
>> +   if (msg_rx == list_last_entry(&psock->ingress_msg,
>> +       struct sk_msg, list))
>> +    break;
>
> Thanks. Change looks good but spacing is a bit off . Can we
> turn those spaces into tabs? Otherwise adding fixes tag and
> my ack would be great.
>
> Fixes: 02c558b2d5d67 ("bpf: sockmap, support for msg_peek in sk_msg with redirect ingress")
> Acked-by: John Fastabend <john.fastabend@gmail.com>


 From 127a334fa5e5d029353ceb1a0414886c527f4be5 Mon Sep 17 00:00:00 2001
From: dihu <anny.hu@linux.alibaba.com>
Date: Fri, 29 May 2020 16:38:50 +0800
Subject: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg

When user application calls read() with MSG_PEEK flag to read data
of bpf sockmap socket, kernel panic happens at
__tcp_bpf_recvmsg+0x12c/0x350. sk_msg is not removed from ingress_msg
queue after read out under MSG_PEEK flag is set. Because it's not
judged whether sk_msg is the last msg of ingress_msg queue, the next
sk_msg may be the head of ingress_msg queue, whose memory address of
sg page is invalid. So it's necessary to add check codes to prevent
this problem.

[20759.125457] BUG: kernel NULL pointer dereference, address:
0000000000000008
[20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G            E
5.4.32 #1
[20759.140890] Hardware name: Inspur SA5212M4/YZMB-00370-109, BIOS
4.1.12 06/18/2017
[20759.149734] RIP: 0010:copy_page_to_iter+0xad/0x300
[20759.270877] __tcp_bpf_recvmsg+0x12c/0x350
[20759.276099] tcp_bpf_recvmsg+0x113/0x370
[20759.281137] inet_recvmsg+0x55/0xc0
[20759.285734] __sys_recvfrom+0xc8/0x130
[20759.290566] ? __audit_syscall_entry+0x103/0x130
[20759.296227] ? syscall_trace_enter+0x1d2/0x2d0
[20759.301700] ? __audit_syscall_exit+0x1e4/0x290
[20759.307235] __x64_sys_recvfrom+0x24/0x30
[20759.312226] do_syscall_64+0x55/0x1b0
[20759.316852] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: dihu <anny.hu@linux.alibaba.com>
---
  net/ipv4/tcp_bpf.c | 3 +++
  1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 5a05327..b82e4c3 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -64,6 +64,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock 
*psock,
          } while (i != msg_rx->sg.end);

          if (unlikely(peek)) {
+            if (msg_rx == list_last_entry(&psock->ingress_msg,
+                              struct sk_msg, list))
+                break;
              msg_rx = list_next_entry(msg_rx, list);
              continue;
          }
-- 
1.8.3.1

