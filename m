Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F92112DED8
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 12:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgAALsG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Jan 2020 06:48:06 -0500
Received: from mail.wangsu.com ([123.103.51.227]:39506 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbgAALsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jan 2020 06:48:05 -0500
Received: from XMCDN1207038 (unknown [59.61.78.238])
        by app2 (Coremail) with SMTP id 4zNnewAnCM3ghgxesa8SAA--.33S2;
        Wed, 01 Jan 2020 19:47:45 +0800 (CST)
From:   =?utf-8?B?5p2o6bmP56iL?= <yangpc@wangsu.com>
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
Date:   Wed, 1 Jan 2020 19:47:27 +0800
Message-ID: <003001d5c099$3e60fad0$bb22f070$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdXAmTvGSt3UBdpWS06LqBel1jbauA==
Content-Language: zh-cn
X-CM-TRANSID: 4zNnewAnCM3ghgxesa8SAA--.33S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAFW7Gw45Cr13ArWkJF1UJrb_yoWrAFWUpa
        n8KrW7Krn5Ary8Ca4qqr18Za48Gan7Cw43GryjkrZF9w45Cw1fuF48KF4Y9FW2gFWvgFWI
        vr1jg3yq9as8CaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyvb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vE
        x4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzx
        vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4l
        Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04
        v7MxkIecxEwVAFwVW8KwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC2
        0s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI
        0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE
        14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20x
        vaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
        xVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUUCD73UUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric Dumazet,

Thanks for discussing this issue.

'previous sack segment was lost' means that the SACK segment carried by D-SACK
will be processed by tcp_sacktag_one () due to the previous SACK loss, 
but this is not necessary.

Here is the packetdrill test, this example shows that the reordering was modified 
because the SACK segment was treated as D-SACK.

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

// d-sack 1:1001, satisfies: undo_marker(1) <= start_seq < end_seq <= prior_snd_una(1001)
// BUG: 2001:3001 is treated as D-SACK then reordering is modified in tcp_sacktag_one()
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
>         undo_marker <= start_seq < end_seq <= prior_snd_una
> we consider this is a valid D-SACK and tcp_is_sackblock_valid()
> returns true, then this D-SACK is discarded as "old stuff",
> but the variable first_sack_index is not marked as negative
> in tcp_sacktag_write_queue().
>
> If this D-SACK also carries a SACK that needs to be processed
> (for example, the previous SACK segment was lost),

What do you mean by ' previous sack segment was lost'  ?

 this SACK
> will be treated as a D-SACK in the following processing of
> tcp_sacktag_write_queue(), which will eventually lead to
> incorrect updates of undo_retrans and reordering.
>
> Fixes: fd6dad616d4f ("[TCP]: Earlier SACK block verification & simplify access to them")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_input.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 88b987c..0238b55 100644
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

This corner case deserves a packetdrill test so that we understand the
issue, can you provide one ?

Thanks.

