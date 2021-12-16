Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8954C4768A7
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 04:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhLPDX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 22:23:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230467AbhLPDX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 22:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639625036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NpP4+hk92r4w2B9+P9RZxFn4KHsmw9feHBEAh+dzxBI=;
        b=ciZucP3fpuFk/k6QW8FK3ztj/sIuT8G5g2aYtjrvs+q+YUS38kNGwugQbR1NBjJON0cGB2
        SzqChuAlPLV5XvfF0m6113299k3oHecODYvqa4fTnLEnRMZCFwQRlp3EfO7B7/hIPZ2d2F
        RaOqoxNVuJ182C701sV70vGfMi4gNdA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-jbhXJ0qONLSOP93wmX3hAg-1; Wed, 15 Dec 2021 22:23:55 -0500
X-MC-Unique: jbhXJ0qONLSOP93wmX3hAg-1
Received: by mail-lf1-f71.google.com with SMTP id z30-20020a0565120c1e00b0041fcb7eaff3so7887239lfu.12
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 19:23:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NpP4+hk92r4w2B9+P9RZxFn4KHsmw9feHBEAh+dzxBI=;
        b=U4Ni5zvyW1FOZWXvWCvscgOUkCWBFexcZWYHyx1UUmkRMu24HANZURsUicG7SDaImX
         NJ4588+AfnC4SuNAz0vREp6Ti7FXISJhAsHwOa/HHpU2HTEL5odrL/G26Dn2slsjl+MI
         hqvmEC6Cw7Ugv6eEcKdgp/MB+ThEyy3jILDZ4pr2mVYEYosATXMkjVhKcaK+D6oh3quw
         zUFpgM28rqNREf5XfVfYwICSlmNmoLl9sbN0pGg6t7NrQmO87L65z1umvaFRU7Gi5ody
         11EeZFpuxYd+1z71OqCjmnOECeYSQq+MhW+3RlCHv03/aiKrYyEm6Mcf4It5syLtKb0d
         mfCw==
X-Gm-Message-State: AOAM532hf8v6pag71LfGk4YeEAE3U0l2Pv3ebdgqWBL2v1DzcJwYAdNo
        7Hh/JltnfuiXm+etq3UZvXq+zgYK0gQUxylem8oZ/o9M2u2EPwoReJI0g1GS1GyxJwugb+STiIu
        A4q6xiurSZl5xkYbcjjMpc/fWtE0KGgKv
X-Received: by 2002:a2e:9f55:: with SMTP id v21mr13762190ljk.420.1639625033574;
        Wed, 15 Dec 2021 19:23:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBMixYaEZyd4edEWw5Bj/aizM8U5Uj0hSuNa6Ik2s82KlOktsgxUZAtKHuh6rOaExNcjN8fE1mOpyHnQE3Im8=
X-Received: by 2002:a2e:9f55:: with SMTP id v21mr13762176ljk.420.1639625033370;
 Wed, 15 Dec 2021 19:23:53 -0800 (PST)
MIME-Version: 1.0
References: <20211216031135.3182660-1-wangwenliang.1995@bytedance.com>
In-Reply-To: <20211216031135.3182660-1-wangwenliang.1995@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 16 Dec 2021 11:23:42 +0800
Message-ID: <CACGkMEtPkybSyPRXqcqtBGbEHvMEw04dcWpUDswuXgwEnshBSA@mail.gmail.com>
Subject: Re: [PATCH] virtio_net: fix rx_drops stat for small pkts
To:     Wenliang Wang <wangwenliang.1995@bytedance.com>
Cc:     mst <mst@redhat.com>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 11:12 AM Wenliang Wang
<wangwenliang.1995@bytedance.com> wrote:
>
> We found the stat of rx drops for small pkts does not increment when
> build_skb fail, it's not coherent with other mode's rx drops stat.
>
> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/net/virtio_net.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 55db6a336f7e..b107835242ad 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -733,7 +733,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>                 pr_debug("%s: rx error: len %u exceeds max size %d\n",
>                          dev->name, len, GOOD_PACKET_LEN);
>                 dev->stats.rx_length_errors++;
> -               goto err_len;
> +               goto err;
>         }
>
>         if (likely(!vi->xdp_enabled)) {
> @@ -825,10 +825,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>
>  skip_xdp:
>         skb = build_skb(buf, buflen);
> -       if (!skb) {
> -               put_page(page);
> +       if (!skb)
>                 goto err;
> -       }
>         skb_reserve(skb, headroom - delta);
>         skb_put(skb, len);
>         if (!xdp_prog) {
> @@ -839,13 +837,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
>         if (metasize)
>                 skb_metadata_set(skb, metasize);
>
> -err:
>         return skb;
>
>  err_xdp:
>         rcu_read_unlock();
>         stats->xdp_drops++;
> -err_len:
> +err:
>         stats->drops++;
>         put_page(page);
>  xdp_xmit:
> --
> 2.30.2
>

