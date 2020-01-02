Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F5512E369
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 08:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgABHsy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jan 2020 02:48:54 -0500
Received: from mail.wangsu.com ([123.103.51.198]:42910 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726145AbgABHsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 02:48:53 -0500
Received: from XMCDN1207038 (unknown [59.61.78.137])
        by app1 (Coremail) with SMTP id xjNnewDnab1DoA1eQc8WAA--.66S2;
        Thu, 02 Jan 2020 15:48:20 +0800 (CST)
From:   =?UTF-8?B?5p2o6bmP56iL?= <yangpc@wangsu.com>
To:     "'Eric Dumazet'" <edumazet@google.com>
Cc:     "'David Miller'" <davem@davemloft.net>,
        "'Alexey Kuznetsov'" <kuznet@ms2.inr.ac.ru>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>, <andriin@fb.com>,
        "'netdev'" <netdev@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK
Date:   Thu, 2 Jan 2020 15:48:01 +0800
Message-ID: <000201d5c140$f5dd0cb0$e1972610$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdXAmTvGSt3UBdpWS06LqBel1jbauAAoqjMw
Content-Language: zh-cn
X-CM-TRANSID: xjNnewDnab1DoA1eQc8WAA--.66S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw48WrW5Xw1ftrW3tF13Jwb_yoWxCr1xpa
        15Kry7Krn5Ary8C3Wqgr18ua48Wan7Ca13GryIkrZF9w45Cw1ruF4FgF4Y9FW2gFWvgFW0
        yryjg3yq9a98GaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkCb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAv
        7VCY1x0262k0Y48FwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCF
        04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU8qXdUU
        UUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric Dumazet,

I'm sorry there was a slight error in the packetdrill test case of the previous email reply,
the ACK segment should not carry data, although this does not affect the description of the situation.
I fixed the packetdrill test and resent it as follows:

packetdrill test case:
// Verify the "old stuff" D-SACK causing SACK to be treated as D-SACK
--tolerance_usecs=10000

// enable RACK and TLP
    0 `sysctl -q net.ipv4.tcp_recovery=1; sysctl -q net.ipv4.tcp_early_retrans=3`

// Establish a connection, rtt = 10ms
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

  +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <...>
 +.01 < . 1:1(0) ack 1 win 320
   +0 accept(3, ..., ...) = 4

// send 10 data segments
   +0 write(4, ..., 10000) = 10000
   +0 > P. 1:10001(10000) ack 1

// send TLP
 +.02 > P. 9001:10001(1000) ack 1

// enter recovery and retransmit 1:1001, now undo_marker = 1
+.015 < . 1:1(0) ack 1 win 320 <sack 9001:10001, nop, nop>
   +0 > . 1:1001(1000) ack 1

// ack 1:1001 and retransmit 1001:3001
 +.01 < . 1:1(0) ack 1001 win 320 <sack 9001:10001, nop, nop>
   +0 > . 1001:3001(2000) ack 1

// sack 2001:3001, now 2001:3001 has R|S
 +.01 < . 1:1(0) ack 1001 win 320 <sack 2001:3001 9001:10001, nop, nop>

+0 %{ assert tcpi_reordering == 3, tcpi_reordering }%

// d-sack 1:1001, satisfies: undo_marker(1) <= start_seq < end_seq <= prior_snd_una(1001)
// BUG: 2001:3001 is treated as D-SACK then reordering is modified in tcp_sacktag_one()
   +0 < . 1:1(0) ack 1001 win 320 <sack 1:1001 2001:3001 9001:10001, nop, nop>

// reordering was modified to 8
+0 %{ assert tcpi_reordering == 3, tcpi_reordering }%



-----邮件原件-----
发件人: 杨鹏程 <yangpc@wangsu.com> 
发送时间: 2020年1月1日 19:47
收件人: 'Eric Dumazet' <edumazet@google.com>
抄送: 'David Miller' <davem@davemloft.net>; 'Alexey Kuznetsov' <kuznet@ms2.inr.ac.ru>; 'Hideaki YOSHIFUJI' <yoshfuji@linux-ipv6.org>; 'Alexei Starovoitov' <ast@kernel.org>; 'Daniel Borkmann' <daniel@iogearbox.net>; 'Martin KaFai Lau' <kafai@fb.com>; 'Song Liu' <songliubraving@fb.com>; 'Yonghong Song' <yhs@fb.com>; 'andriin@fb.com' <andriin@fb.com>; 'netdev' <netdev@vger.kernel.org>; 'LKML' <linux-kernel@vger.kernel.org>
主题: Re: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Hi Eric Dumazet,

Thanks for discussing this issue.

'previous sack segment was lost' means that the SACK segment carried by D-SACK will be processed by tcp_sacktag_one () due to the previous SACK loss, but this is not necessary.

Here is the packetdrill test, this example shows that the reordering was modified because the SACK segment was treated as D-SACK.

//dsack-old-stuff-bug.pkt
// Verify the "old stuff" D-SACK causing SACK to be treated as D-SACK
--tolerance_usecs=10000

// enable RACK and TLP
    0 `sysctl -q net.ipv4.tcp_recovery=1; sysctl -q net.ipv4.tcp_early_retrans=3`

// Establish a connection, rtt = 10ms
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

  +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <...>
 +.01 < . 1:1(0) ack 1 win 320
   +0 accept(3, ..., ...) = 4

// send 10 data segments
   +0 write(4, ..., 10000) = 10000
   +0 > P. 1:10001(10000) ack 1

// send TLP
 +.02 > P. 9001:10001(1000) ack 1

// enter recovery and retransmit 1:1001, now undo_marker = 1
+.015 < . 1:1(0) ack 1 win 320 <sack 9001:10001, nop, nop>
   +0 > . 1:1001(1000) ack 1

// ack 1:1001 and retransmit 1001:3001
 +.01 < . 1:1001(1000) ack 1001 win 320 <sack 9001:10001, nop, nop>
   +0 > . 1001:3001(2000) ack 1

// sack 2001:3001, now 2001:3001 has R|S
 +.01 < . 1001:1001(0) ack 1001 win 320 <sack 2001:3001 9001:10001, nop, nop>

+0 %{ assert tcpi_reordering == 3, tcpi_reordering }%

// d-sack 1:1001, satisfies: undo_marker(1) <= start_seq < end_seq <= prior_snd_una(1001) // BUG: 2001:3001 is treated as D-SACK then reordering is modified in tcp_sacktag_one()
   +0 < . 1001:1001(0) ack 1001 win 320 <sack 1:1001 2001:3001 9001:10001, nop, nop>

// reordering was modified to 8
+0 %{ assert tcpi_reordering == 3, tcpi_reordering }%




-----邮件原件-----
发件人: Eric Dumazet <edumazet@google.com>
发送时间: 2019年12月30日 21:41
收件人: Pengcheng Yang <yangpc@wangsu.com>
抄送: David Miller <davem@davemloft.net>; Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>; Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; Martin KaFai Lau <kafai@fb.com>; Song Liu <songliubraving@fb.com>; Yonghong Song <yhs@fb.com>; andriin@fb.com; netdev <netdev@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>
主题: Re: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

On Mon, Dec 30, 2019 at 1:55 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> When we receive a D-SACK, where the sequence number satisfies:
>         undo_marker <= start_seq < end_seq <= prior_snd_una we 
> consider this is a valid D-SACK and tcp_is_sackblock_valid() returns 
> true, then this D-SACK is discarded as "old stuff", but the variable 
> first_sack_index is not marked as negative in 
> tcp_sacktag_write_queue().
>
> If this D-SACK also carries a SACK that needs to be processed (for 
> example, the previous SACK segment was lost),

What do you mean by ' previous sack segment was lost'  ?

 this SACK
> will be treated as a D-SACK in the following processing of 
> tcp_sacktag_write_queue(), which will eventually lead to incorrect 
> updates of undo_retrans and reordering.
>
> Fixes: fd6dad616d4f ("[TCP]: Earlier SACK block verification & 
> simplify access to them")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_input.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c index 
> 88b987c..0238b55 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1727,8 +1727,11 @@ static int tcp_sack_cache_ok(const struct tcp_sock *tp, const struct tcp_sack_bl
>                 }
>
>                 /* Ignore very old stuff early */
> -               if (!after(sp[used_sacks].end_seq, prior_snd_una))
> +               if (!after(sp[used_sacks].end_seq, prior_snd_una)) {
> +                       if (i == 0)
> +                               first_sack_index = -1;
>                         continue;
> +               }
>
>                 used_sacks++;
>         }


Hi Pengcheng Yang

This corner case deserves a packetdrill test so that we understand the issue, can you provide one ?

Thanks.

