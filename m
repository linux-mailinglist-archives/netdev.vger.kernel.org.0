Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7B13AD9C
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgANP1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:27:10 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45503 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANP1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:27:09 -0500
Received: by mail-oi1-f196.google.com with SMTP id n16so12133631oie.12
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 07:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NSfqseDXRgYxW6cos6v42MObIz83bjZm/sycYhBbN3U=;
        b=tW70tSHkFefhGMQBaoalcMtSt3B5DYYWSmjZV/rPTpWhZYygQfcHuVKlotIKs2vf/G
         P9pSElpqO9AU+sAtmlIw1h/03uLca12hPe7NHMpSOkCY6OfVFlRem4SrUKrqQk0/f6+X
         23V+kyjk/Pko0j8sAKsRhpaCYfcTyQKjsi2vyNMoUttjfE+kEhGgGgU0cfuoyS6NcdOR
         x7OpWImyZKRdZaXFP91OQUCWaLe0ou9MYAmsQDTCYFuiqqRfm+lMVj6qZ6ausD/X8zIQ
         bmeMa23eQ211WC6eEzP8vl/oPiWqYuw9Y9r5y8e4mWnUQLLtWKm29+5EEiLtuxEoUWf/
         Q+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSfqseDXRgYxW6cos6v42MObIz83bjZm/sycYhBbN3U=;
        b=rpn6skiE47VUVIdID6igd3Qx6ERUwiJvM8s7gLUx2oxBPBeB5bkVj9CjQQfLmG6n0/
         zkDFd5yEqdMpBP2QqYLNp4misQ4b2nc3Se40QZW2vSG9b4HiL+znI8whgaXtXr8VYY/G
         seakTS7FXeLEcP1TDcG5xbv+DHgXSJUWHCcEIGIWcVfXWgOSAujp1r+lAn2SJTqpF7P5
         mmY4pxpYQCndEJ+5goxBbFEaSeVgL5VZzQBsa/LQjH88sfHTjMyEMfpb03Gu0nqbLmd0
         5n8C4Kiv8TulrhdAZTIhZ0VHTCFxddzz2aulkrxxWqkjPwEWAUIj3AENYOIByPaFVmK4
         jLeg==
X-Gm-Message-State: APjAAAVvFSTKurLHlFAFHK0XrKGC8Qc0O4JrWP3cW9bZGM1Tp4Ve8hP8
        /rhNBByF4UYHT4LliGLzlQbPB59q5h+j5YUFDCzgEQ==
X-Google-Smtp-Source: APXvYqyDF+nT7rgbrbcfjhIbUn+78PrCncjeMOKUmQqVuSd26q3pleG6o3IYx35IjTpdNlh2Zqkf8KGPbmV3FIk48zk=
X-Received: by 2002:a05:6808:64e:: with SMTP id z14mr16070335oih.79.1579015628785;
 Tue, 14 Jan 2020 07:27:08 -0800 (PST)
MIME-Version: 1.0
References: <1578993820-2114-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1578993820-2114-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 14 Jan 2020 10:26:52 -0500
Message-ID: <CADVnQynVoi=__EE20L5y1KD5Asw+=PbFesSeQE0pf8WmB3cx5Q@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix marked lost packets not being retransmitted
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 4:24 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> When the packet pointed to by retransmit_skb_hint is unlinked by ACK,
> retransmit_skb_hint will be set to NULL in tcp_clean_rtx_queue().
> If packet loss is detected at this time, retransmit_skb_hint will be set
> to point to the current packet loss in tcp_verify_retransmit_hint(),
> then the packets that were previously marked lost but not retransmitted
> due to the restriction of cwnd will be skipped and cannot be
> retransmitted.
>
> To fix this, when retransmit_skb_hint is NULL, retransmit_skb_hint can
> be reset only after all marked lost packets are retransmitted
> (retrans_out >= lost_out), otherwise we need to traverse from
> tcp_rtx_queue_head in tcp_xmit_retransmit_queue().
...
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -915,9 +915,10 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
>  /* This must be called before lost_out is incremented */
>  static void tcp_verify_retransmit_hint(struct tcp_sock *tp, struct sk_buff *skb)
>  {
> -       if (!tp->retransmit_skb_hint ||
> -           before(TCP_SKB_CB(skb)->seq,
> -                  TCP_SKB_CB(tp->retransmit_skb_hint)->seq))
> +       if ((!tp->retransmit_skb_hint && tp->retrans_out >= tp->lost_out) ||
> +           (tp->retransmit_skb_hint &&
> +            before(TCP_SKB_CB(skb)->seq,
> +                   TCP_SKB_CB(tp->retransmit_skb_hint)->seq)))
>                 tp->retransmit_skb_hint = skb;
>  }

Thanks for finding and fixing this issue, and for providing the very
nice packetdrill test case! The fix looks good to me.

I verified that the packetdrill test fails at the line notated "BUG"
without the patch applied:

fr-retrans-hint-skip-fix.pkt:33: error handling packet: live packet
field tcp_seq: expected: 2001 (0x7d1) vs actual: 4001 (0xfa1)
script packet:  0.137311 . 2001:3001(1000) ack 1
actual packet:  0.137307 . 4001:5001(1000) ack 1 win 256

Also verified that the test passes with the patch applied, and that
our internal SACK and fast recovery tests continue to pass with this
patch applied.

Acked-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal
