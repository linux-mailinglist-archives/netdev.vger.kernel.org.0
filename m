Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F220F101E26
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 09:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfKSInJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 03:43:09 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43511 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSInI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 03:43:08 -0500
Received: by mail-oi1-f195.google.com with SMTP id l20so18124003oie.10;
        Tue, 19 Nov 2019 00:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v/mDkshH35krYGIcPe3UVwAraJNURQQjI1DwQdPxnyw=;
        b=RJ0N/+tJOjLQGrFWcli88Fzip5D5+7bQdfI31Rga+whmF3pumyCghWYvfRfThJh5hJ
         XTvq4MVbfjxir4NUT4yI6gFq0eKvEjHqLbnC0s0jEQMJtsjlf2sXwwuMMs8l9sujmyGp
         COLoH0x4DkEaN1XeDopDzgQx17qQte/Y+W5mwQKIAP7BG4GAh+6YR85L1aVGP4uMsya8
         2x5RqMSjrXfmp6ggA4SA4ygmt24XW54tBWk/zfn+ZpDJ0xwauLRtieeaOnaITshW8fT7
         UW2lXQy3itW8tEoEcj7dw9ISHZHo9baJAeEz7460liOtxa9w38bgDcZyPU1O6qZZM+l3
         xeNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v/mDkshH35krYGIcPe3UVwAraJNURQQjI1DwQdPxnyw=;
        b=We6FXZ87+o11EFKRKN7297GmvGuydQKRC54Gd4RgZta8DexOPZYbLbb/ryWa1QJLY8
         SBJSlb+V2ZND7SrkwYF0IJ1PJvM91wz+e/sOS1KJh7+UcXg441USxj5DQAqPctWKLlUr
         FahscEIjLGyxj4CrxoV/JIX/XP/zs1NXSXbLbjhfW69j+kTykrYA7yofNyOX533Htu5Y
         kUmYtlpq9rxQbNEFOhsztixZxjwR0s/SntocvTJuO34VJg2mEaoY7EHjA4BhOp10S5qb
         JibtI17OZ382OT5+/icxBNGseI+5udZb/bShj9fo0e+JpiB8+GgFL4SsegFmXxWz+5hj
         1MAA==
X-Gm-Message-State: APjAAAX8lOr6GWzM6npeWhIsiLl9ptYyzLkyBO4XFm+Ozlgu4xtOUgky
        DE1prq8FXn98iEuoSuUJJZKHLMPo3ENeYJ3W63Y=
X-Google-Smtp-Source: APXvYqwqQmZr8xiGHAtlQpSHBkO2jeSbsvCCCR2ELA6wUZ8mlisIbvspwWKfTbMvO46yWsKYmuga89dEAqYfFFpNDD8=
X-Received: by 2002:aca:4945:: with SMTP id w66mr3164282oia.98.1574152986206;
 Tue, 19 Nov 2019 00:43:06 -0800 (PST)
MIME-Version: 1.0
References: <20191119001951.92930-1-lrizzo@google.com>
In-Reply-To: <20191119001951.92930-1-lrizzo@google.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 19 Nov 2019 09:42:55 +0100
Message-ID: <CAJ8uoz2EsL76DyfCNP4taFyF9_ES0riV34-FURDDV_KRAAVyvA@mail.gmail.com>
Subject: Re: [PATCH v2] net-af_xdp: use correct number of channels from ethtool
To:     Luigi Rizzo <lrizzo@google.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, rizzo@iet.unipi.it
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 1:20 AM Luigi Rizzo <lrizzo@google.com> wrote:
>
> Drivers use different fields to report the number of channels, so take
> the maximum of all data channels (rx, tx, combined) when determining the
> size of the xsk map. The current code used only 'combined' which was set
> to 0 in some drivers e.g. mlx4.
>
> Tested: compiled and run xdpsock -q 3 -r -S on mlx4
> Signed-off-by: Luigi Rizzo <lrizzo@google.com>
> ---
>  tools/lib/bpf/xsk.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 74d84f36a5b24..37921375f4d45 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -431,13 +431,18 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
>                 goto out;
>         }
>
> -       if (err || channels.max_combined == 0)
> +       if (err) {
>                 /* If the device says it has no channels, then all traffic
>                  * is sent to a single stream, so max queues = 1.
>                  */
>                 ret = 1;
> -       else
> -               ret = channels.max_combined;
> +       } else {
> +               /* Take the max of rx, tx, combined. Drivers return
> +                * the number of channels in different ways.
> +                */
> +               ret = max(channels.max_rx, channels.max_tx);
> +               ret = max(ret, (int)channels.max_combined);
> +       }
>
>  out:
>         close(fd);
> --
> 2.24.0.432.g9d3f5f5b63-goog
>

Thanks Luigi.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
