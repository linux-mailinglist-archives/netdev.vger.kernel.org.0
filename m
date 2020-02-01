Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF27514FA4B
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgBATiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:38:55 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35968 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgBATiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 14:38:55 -0500
Received: by mail-oi1-f194.google.com with SMTP id c16so10849555oic.3;
        Sat, 01 Feb 2020 11:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H/PPExul7A4Ds+5Y5uM+zLNiIJBYrh9YzHJkgqjwchw=;
        b=I6/5VqtkK1DA9kR4owFDJ1Hd8fXcRw5DJBr9CbRcydL58KaihiBPZPSR9KIwTuN9Sx
         04Ky84VcQw14F59+9/wfUSOg+KMhT2pe8nviYk3P7+wNg3ilheniwGc0BH0R4qLQxSpz
         sMPbP1ObQFUXgbFlyfvA2l8piO8CDKJH4cxgmghCVAAGHTQDjcZyh9DQV00G/bvwAP0J
         8TpJr316+/JBaevtQrj402gREF7RqthO5hAAGZTz/x7ZIfHvpLzFWdhr50jX/tYbrz9+
         gK30ipt72uohxW0fD8/YaGDLqhlF0nINym95/39ue+HWIGU1oXyiiS1d+JpprmLj0+dL
         ug3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H/PPExul7A4Ds+5Y5uM+zLNiIJBYrh9YzHJkgqjwchw=;
        b=m78DHHP+WTarGMyvogRGrbLFq6ZJCoZV1MvS5skl6XOgPRmiu6ZRr83Eepqo/QQPfb
         z314tWCiNFTGvFl9prkDtCKpHtNxQ+8piDPXAjl+5uzkpGqqBUh9UcCocFh39Owb06SL
         s+/eNEy/wxc6AQE7iidmzLuW1QgFl2bG4gBpugR8NRBnhAnKErjv2oAWmyAOQ3dDvzcG
         17LttSmPiEPB18g3ngT2byjxkVqpwzyuw8HrFRKjUgg2kYMFsZbY48I4Q76Xsdlc9OBQ
         vhzi0AqCEInq4dQP7rqXjGGW7iOb7Fsqynv/3IjTXZIb5HPqqkUjjR8BbTx63UqZom7v
         dUtw==
X-Gm-Message-State: APjAAAXZLBx4K4UivYt8JzRKE2qt+qarlr87Pyl3xAIcuh4ntSO6aNCQ
        G7y+TpHOrKyNYtBtmemZdefyJOKhKVeQkavFuns=
X-Google-Smtp-Source: APXvYqw6e9wLUxqr05SLdvBCLr1imqhVa9HITdmw8n9SPlf6FfaIzEUf13nK72woJcT9nz1Ah146/PiTq9DYDGz/5ds=
X-Received: by 2002:aca:f08:: with SMTP id 8mr10467321oip.60.1580585934724;
 Sat, 01 Feb 2020 11:38:54 -0800 (PST)
MIME-Version: 1.0
References: <20200131065647.joonbg3wzcw26x3b@kili.mountain>
In-Reply-To: <20200131065647.joonbg3wzcw26x3b@kili.mountain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 1 Feb 2020 11:38:43 -0800
Message-ID: <CAM_iQpUYv9vEVpYc-WfMNfCc9QaBzmTYs66-GEfwOKiqOXHxew@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: prevent a use after free
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        "V. Saicharan" <vsaicharan1998@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 10:57 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The code calls kfree_skb(skb); and then re-uses "skb" on the next line.
> Let's re-order these lines to solve the problem.
>
> Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/sched/sch_fq_pie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
> index bbd0dea6b6b9..78472e0773e9 100644
> --- a/net/sched/sch_fq_pie.c
> +++ b/net/sched/sch_fq_pie.c
> @@ -349,9 +349,9 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
>         while (sch->q.qlen > sch->limit) {
>                 struct sk_buff *skb = fq_pie_qdisc_dequeue(sch);
>
> -               kfree_skb(skb);
>                 len_dropped += qdisc_pkt_len(skb);
>                 num_dropped += 1;
> +               kfree_skb(skb);

Or even better: use rtnl_kfree_skbs().

Thanks.
