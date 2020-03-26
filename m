Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E91C193BC2
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgCZJZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:25:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33734 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727699AbgCZJZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:25:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id a25so6854640wrd.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4m+GQy7VYH0n5Zaq8PJqqSUE7P/pBzPbT5al6RrlENk=;
        b=ThYyuZEu+X0Gy47jINIc31DuaXLTq2dPUSR+RyG+3SfzJlFRqPk4ZowMdGWZtf4ijR
         MXfpm3vprsfa8QTY2XDLpW1PtJu0VNY9Jm4eqiedR/DvG7Iphok3jDltzWpaga0zbxoh
         DxeSLkuy8x6MImT1NdvGmOkL/31o7+7c57XJKGjrVbCm+PG64D8N5MzD7qSfbwmILz9g
         rG+Y6vUX1GY610nyj7e0/qII85zDOuJw1Kq+F5fnOrtzQSgm+y/jYZljhVo1bKFilVF7
         +vjIH6/+O3qJbii3EEHNqA3o7+7x3hesPwbiOIbk94Xx14ym7fjHOgufqs2GAaHx+rTV
         2cEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4m+GQy7VYH0n5Zaq8PJqqSUE7P/pBzPbT5al6RrlENk=;
        b=huKlOjfb3aCaCtQYpFWukPqWwDjVjYGLWuBojLvT8sEkd1JmUhOZCXJ7ge+RVsOVb8
         Zzy3vM2o0schJDQGxPQFUjVXmFQcH0Jza69ucEhPfF5QI7ccj7IqfpMdzvxdB/NtlKxg
         Y3vRi5rYP1mPRZ2pmEoD5YreQ31SqSPzvUWeYZmGeeICSA8s5em8Tdc5wxH5Mz42HRCm
         TsXDcLT2L+bN2l1VGwHAbUB6oTqOZxKO8EhxT8LKGUiXkFdwoFdLoimtFHJtrb6p9qB5
         z/gD7qTn1dhu1sPvn5XxUl+RdxoGRxgyPRWkttIvHGX3i8BYL2oMN746g4kFstOIGqll
         AIWA==
X-Gm-Message-State: ANhLgQ3mily1Q/ZCPTMSf4PcXDrWZZPzACnSQu+pG/9vfxd+28UY8H4y
        b5D7takaBoA0V01ArZh11517ItCmkZJfH8OuBl94yK3H
X-Google-Smtp-Source: ADFU+vsf5lfDy65TqlzlkgUgHQnyic9bgJhaFiglrdDpqA9Bg2ZjJlcdq35fDwaX17X8aWaHOYylY+m2aeiKb1cliy4=
X-Received: by 2002:a5d:5447:: with SMTP id w7mr8174169wrv.299.1585214733202;
 Thu, 26 Mar 2020 02:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
In-Reply-To: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 26 Mar 2020 17:28:44 +0800
Message-ID: <CADvbK_fOKPMeVynjxBOZc3tRFEcp9xYpyC9j0Hbs9E1sa6R5LQ@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix a skb extensions leak
To:     network dev <netdev@vger.kernel.org>
Cc:     davem <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC Steffen Klassert <steffen.klassert@secunet.com>

On Thu, Mar 26, 2020 at 5:06 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On udp rx path udp_rcv_segment() may do segment where the frag skbs
> will get the header copied from the head skb in skb_segment_list()
> by calling __copy_skb_header(), which could overwrite the frag skbs'
> extensions by __skb_ext_copy() and cause a leak.
>
> This issue was found after loading esp_offload where a sec path ext
> is set in the skb.
>
> On udp tx gso path, it works well as the frag skbs' extensions are
> not set. So this issue should be fixed on udp's rx path only and
> release the frag skbs' extensions before going to do segment.
>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/udp.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/net/udp.h b/include/net/udp.h
> index e55d5f7..7bf0ca5 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -486,6 +486,10 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
>         if (skb->pkt_type == PACKET_LOOPBACK)
>                 skb->ip_summed = CHECKSUM_PARTIAL;
>
> +       if (skb_has_frag_list(skb) && skb_has_extensions(skb))
> +               skb_walk_frags(skb, segs)
> +                       skb_ext_put(segs);
> +
>         /* the GSO CB lays after the UDP one, no need to save and restore any
>          * CB fragment
>          */
> --
> 2.1.0
>
