Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A776B43CB65
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242334AbhJ0OC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237334AbhJ0OCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:02:52 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB1BC061767;
        Wed, 27 Oct 2021 07:00:27 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id g125so3542747oif.9;
        Wed, 27 Oct 2021 07:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gplW2JHzQohgeI9w8S3pDXSsBEIOVAPQhMqeRXzSpHE=;
        b=ikqqtCFKzIWO+2H/4jds1Iyx/rpTiWgSqUKGYZGggzyN0zxOCFV9YgWdRGJZVkGhwO
         nUfywavzeiMcFEMIps0XC8VmR8iwuLeUbofOvdXQ8c2zQa1kKh/CDAbWMjQY4MZMIbxv
         GZsZTqpIpejjJKruZX17NfPnefOD07i0h32yL18S8MLp1BPITda+a2qNL1n0chyyI7Gg
         i9zI5avYihd2wjM8AFRXWLcrMjlwVzz1TSi1qKwvE71TU2KUElubwW65pbcSjgRzRc2y
         0SIUW6xSiDaDITvRxH6SnoA7Y85il9aiz2OjsYwemYLyfVUj4TEBnqrGONFm7cqGQih8
         xTAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gplW2JHzQohgeI9w8S3pDXSsBEIOVAPQhMqeRXzSpHE=;
        b=iUGIRaoqAAE+pYcgcJEMvTduq7hFcJz+nRSJQFY9bWfG0Ox5HVwTGkdJ52x+ncfvf8
         me7Dc1l6VTWxLbrkZImpBgtr1XFyy1YjroEukeSqdpvifHbyEnvAYWOpQvzvJ8LD5ZiA
         enm4uoEagCqPEqUviQeNw03F/7/w9TPONI7DljzNVVgBFvLXEC5vCxAutYI+iGMojE/N
         Fyn+pUS4Y9QerpAKnAOGDMigsa2QduQ3vtP1CN3nc6me0pKSz83upXp6QUtEr4ye1AIT
         6qHT1i1zqxPMZ0GCSNaWRmSYglNs3Ch2UBPxyn8FVurRJ5B5vKBzZqD1QVJjUjhGdzX4
         FTyw==
X-Gm-Message-State: AOAM5306dC5dQE7rmP4TepJJ1s7ObW7euYbDC+1/lMR9eaQ45tv8T3y5
        HU8SG36jaxV0uYDaO9FYzw87wEpZf9xIx0r9IhE=
X-Google-Smtp-Source: ABdhPJyxpbEPQz937PJTufs4bKJfvW1ix+SH2bRhnTkPuUJCPCFKd0ZlXJJKrW/8L2e58rqgwdzCIZvA8VcCT7azzWU=
X-Received: by 2002:a05:6808:22a0:: with SMTP id bo32mr3655743oib.123.1635343226874;
 Wed, 27 Oct 2021 07:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211027084944.4508-1-kerneljasonxing@gmail.com>
In-Reply-To: <20211027084944.4508-1-kerneljasonxing@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 27 Oct 2021 21:59:51 +0800
Message-ID: <CAL+tcoDS7UgZBqVO_TqKwftMzA+BA9kDG64KRDnDJ9B_-y5sTw@mail.gmail.com>
Subject: Re: [PATCH net] net: gro: flush the real oldest skb
To:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        Eric Dumazet <edumazet@google.com>, atenart@kernel.org,
        alobakin@pm.me, Wei Wang <weiwan@google.com>, bjorn@kernel.org,
        arnd@arndb.de, memxor@gmail.com
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch has some problems. I got wrong with the @skb->list. Please ignore it.

Thanks,
Jason

On Wed, Oct 27, 2021 at 4:50 PM <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <xingwanli@kuaishou.com>
>
> Prior to this patch, when the count of skbs of one flow is larger than
> MAX_GRO_SKBS, gro_flush_oldest() flushes the tail of the list. However,
> as we can see in the merge part of skb_gro_receive(), the tail of the
> list is the newest, head oldest.
>
> Here, we need to fetch the real oldest one and then process it to lower
> the latency.
>
> Fix: 07d78363dc ("net: Convert NAPI gro list into a small hash table.")
> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7ee9fec..d52ebdb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6012,7 +6012,7 @@ static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
>  {
>         struct sk_buff *oldest;
>
> -       oldest = list_last_entry(head, struct sk_buff, list);
> +       oldest = list_first_entry(head, struct sk_buff, list);
>
>         /* We are called with head length >= MAX_GRO_SKBS, so this is
>          * impossible.
> --
> 1.8.3.1
>
