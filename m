Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAED27BB7
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 13:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfEWLZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 07:25:46 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43851 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbfEWLZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 07:25:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id z5so5087656lji.10
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 04:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SrYXsYajuhxHoYUyiFBd8Tl+QmrENDXMAS1vXU2GDmk=;
        b=lt+Q9eF+HRvUKzuMYZKdoOHaNlK/bdNbflGmYoPP2SuY2ikQsexETGyt+NTpmdDbE2
         Wias4XJQ6NmVox2JDapbxXoUY8phryJCyV/40ZZWvSfKGRCrXO7rc1XaQwVWRWLd0i1u
         vT3KCcIauPHMOl2dMLQlwWVKsyitNvnMOGs8oDOjxxm8WC5Edxzd34Az3Mpv51tg5fZH
         oPAIu74aO7yw2UlxOvDRd0pQNZYwSoikvRjDo0J8DdCdixsCIv8BPFQwKsIw4QnyIDa9
         x1+PWV8lauuMOs/MihvXfUkH/jC1W6JDnqR4K2SeSDcUgqkPOZk64dDUe6VarIHhK3r3
         3WAA==
X-Gm-Message-State: APjAAAXW1DsMU4NxMKb/faWC6n6ErajNfgD6VManavAX8qHkdbL7oWUp
        dG235RqdVBzneizTROjvtVUhbe+D+To=
X-Google-Smtp-Source: APXvYqyH2WNXzf0sY4Zfc0VvB7Ym06Z0i+3CkgkwpnAjAUzvRTCKfo/WBlR7bk3l2r85cxF8ZGh21w==
X-Received: by 2002:a2e:9acb:: with SMTP id p11mr19382428ljj.129.1558610744451;
        Thu, 23 May 2019 04:25:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id i74sm6064892lfg.78.2019.05.23.04.25.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 04:25:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 953EF1800B1; Thu, 23 May 2019 13:25:42 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
In-Reply-To: <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp> <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 May 2019 13:25:42 +0200
Message-ID: <87zhnd1kg9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:

> This improves XDP_TX performance by about 8%.
>
> Here are single core XDP_TX test results. CPU consumptions are taken
> from "perf report --no-child".
>
> - Before:
>
>   7.26 Mpps
>
>   _raw_spin_lock  7.83%
>   veth_xdp_xmit  12.23%
>
> - After:
>
>   7.84 Mpps
>
>   _raw_spin_lock  1.17%
>   veth_xdp_xmit   6.45%
>
> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
> ---
>  drivers/net/veth.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 52110e5..4edc75f 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>  	return ret;
>  }
>  
> +static void veth_xdp_flush_bq(struct net_device *dev)
> +{
> +	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
> +	int sent, i, err = 0;
> +
> +	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);

Wait, veth_xdp_xmit() is just putting frames on a pointer ring. So
you're introducing an additional per-cpu bulk queue, only to avoid lock
contention around the existing pointer ring. But the pointer ring is
per-rq, so if you have lock contention, this means you must have
multiple CPUs servicing the same rq, no? So why not just fix that
instead?

-Toke
