Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C9AD5FD2
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbfJNKLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:11:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33781 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730860AbfJNKLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 06:11:23 -0400
Received: by mail-pg1-f193.google.com with SMTP id i76so9840550pgc.0;
        Mon, 14 Oct 2019 03:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u6WI0gDjbvLg3JzSkl1yVQQFCwF5JM/S0gxkF6bM6fg=;
        b=lBY+KsDoJUg2hKJs7lp8p8z4x5tDAIj44Rj+aOGnsc7Inftl94nbqA0J0mKXUfDTYT
         QeRQihPX6F3qwA0JnLbUVxFOYnix5KjZebKetNhRYXQUuSbNc9oH58UrD5vRXY5ckaze
         Bfj3ploISAFEcjrqZuu/ms2lVfnWBhQLnitoRsqsDE/bqp3+nSuYpLdkkWiU6tXjxsiq
         B9jYhvh42Vy5qQg1ZlpbFsI/zPK1qfuvEy8mRTVUROOTZzIGss8e1qGfv6QsNX6DP8ov
         clD+1K+1Lj0yn0HyUbUfbyrab+M0EYUMY/Rh9ao7p213ftX+UygJAaKK1ziLIWpq9VJL
         ZoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u6WI0gDjbvLg3JzSkl1yVQQFCwF5JM/S0gxkF6bM6fg=;
        b=c0Khj+exKbCl7MV3A3LZ2pGX1L1l0tjMpSEO/jDkG0AcXqGqahHB5az/vAXm0CPw8b
         FwGAr0QI5cIObWwEEPk5kECXYQw+EJSPqr/3rhkg3FX8e+xKpmimT2lNzn53QVpRCG5G
         3wYwV/LMvfmsqSaqY7EBkB2jNfgjebyzNSvV7OVln+IY37PfNrZSgthRDdDhvuxvhZ83
         VAm8lpMr1pq9Dl/yS1kS9iGDva+iG0nOeaMorfwmNEoG2GHGfpMnKEIpJTObxsZvtvGr
         HaqFXbowlO2k3faH4Omhsxb0EyuahxDGLLR8eI+Tc5DAGI9XaQus3V4d21z0hPKbCVol
         RIIA==
X-Gm-Message-State: APjAAAVXHOLS65x699Al3yNdd2XZ5qdmy7+lmcxHnMjQhTgWfDwypd2k
        iRKI4Y3ieOm3I7quOR47DeiMAFs7w4FKt1Dx8QU=
X-Google-Smtp-Source: APXvYqwwxxKi/wqKL8hzQH0JWvzTmEg06U0A67Gdgik5ysLzrtrS1capqHHl51ggKu1gORfFTWboMHEJXTZ5IVFyuCs=
X-Received: by 2002:a17:90a:c684:: with SMTP id n4mr35304592pjt.33.1571047881584;
 Mon, 14 Oct 2019 03:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <20191014090910.9701-1-jgross@suse.com> <20191014090910.9701-2-jgross@suse.com>
In-Reply-To: <20191014090910.9701-2-jgross@suse.com>
From:   Paul Durrant <pdurrant@gmail.com>
Date:   Mon, 14 Oct 2019 11:11:10 +0100
Message-ID: <CACCGGhDz6nAqoKUaZ+Ud7O7Srm1ygt=6UgSrydajizJfWZsRPQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] xen/netback: fix error path of xenvif_connect_data()
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel <xen-devel@lists.xenproject.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Oct 2019 at 10:09, Juergen Gross <jgross@suse.com> wrote:
>
> xenvif_connect_data() calls module_put() in case of error. This is
> wrong as there is no related module_get().
>
> Remove the superfluous module_put().
>
> Fixes: 279f438e36c0a7 ("xen-netback: Don't destroy the netdev until the vif is shut down")
> Cc: <stable@vger.kernel.org> # 3.12
> Signed-off-by: Juergen Gross <jgross@suse.com>

Yes, looks like this should have been cleaned up a long time ago.

Reviewed-by: Paul Durrant <paul@xen.org>

> ---
>  drivers/net/xen-netback/interface.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
> index 240f762b3749..103ed00775eb 100644
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -719,7 +719,6 @@ int xenvif_connect_data(struct xenvif_queue *queue,
>         xenvif_unmap_frontend_data_rings(queue);
>         netif_napi_del(&queue->napi);
>  err:
> -       module_put(THIS_MODULE);
>         return err;
>  }
>
> --
> 2.16.4
>
