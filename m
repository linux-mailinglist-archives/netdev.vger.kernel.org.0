Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF18248E426
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbiANGSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:18:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229936AbiANGSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:18:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642141095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YawaJX8lTftoOW61Y7U6IA50jMGmbdQaYnSxlW1+tHw=;
        b=iYMZJ06Ov2MIwtjGo2PkdfMaiiH6PXBVB7rHMu+VFtchAv02b1AYAU7Pil/cgNyKjyn5dy
        nVRYx7NTiESJRK3UfWGYu8KuJmqT42gxNAm7xbq4UJ/N4E+FIjQWY+mmA7SfH2uyrTbGvb
        iz+jG1HNv4OjybxNEqufpEOOfubsnwQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-7iVql8x8NROvL7gadXhQeQ-1; Fri, 14 Jan 2022 01:18:13 -0500
X-MC-Unique: 7iVql8x8NROvL7gadXhQeQ-1
Received: by mail-lf1-f70.google.com with SMTP id v7-20020a056512048700b0042d99b3a962so5521286lfq.23
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 22:18:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YawaJX8lTftoOW61Y7U6IA50jMGmbdQaYnSxlW1+tHw=;
        b=WkXh2DEw7kfmVz5MIOnVlPQmOc2UDFpwVnOe0GFW9WFDSeVpECdq/dvbouG8ct7kkx
         BgzR9T0nOuGL0SPhlEgUo6n2IeLp65YkxTWH93F5IGmIRsOXtG3NnloIr5clGtpMNLq7
         uMut07lLGyZ8Q/3w8jNuCMp0mqaCJvPn+4C/3NJOIyeYVbhGwTL0MIqDAQg+hSHaIN7t
         4X84Cihlv5DI2F7z5xkY+LL0DSbU169FXjeTHc3tt8HwF7K5FN5J/KUJRiEFuUuWY9lu
         dSLAliAGY77NTtM4VS6+ss20+502vipHau7UL15Fx7XYgUdlcf5PbfaPy6hL3vRRfr0W
         qhRg==
X-Gm-Message-State: AOAM531VWcTps7NzEJiS/UEkcAXjPAGwXEl0A8gETW5IclwdXFRONI1x
        X+FFK8iTl/wQRuprDkI00I6IQk64UI8fUvqGrf61QswpWWgkQs73AvTvFsaIk88Tfmm8WgLI5pu
        hEcjlf+cm5omPe3IuBn5aZbiqJMQgTumX
X-Received: by 2002:a2e:8645:: with SMTP id i5mr2054355ljj.420.1642141092333;
        Thu, 13 Jan 2022 22:18:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6Nfbams2KnY3qknpeMJm2YPphc5XVQuPf+9aKqnItDdPeixnxkwbf4f/KJ8Znvhi0j4XtHNEKy5oo568WAt4=
X-Received: by 2002:a2e:8645:: with SMTP id i5mr2054339ljj.420.1642141092040;
 Thu, 13 Jan 2022 22:18:12 -0800 (PST)
MIME-Version: 1.0
References: <20220113145642.205388-1-sgarzare@redhat.com>
In-Reply-To: <20220113145642.205388-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 14 Jan 2022 14:18:01 +0800
Message-ID: <CACGkMEsqY5RHL=9=iny6xRVs_=EdACUCfX-Rmpq+itpdoT_rrg@mail.gmail.com>
Subject: Re: [RFC PATCH] vhost: cache avail index in vhost_enable_notify()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 10:57 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> In vhost_enable_notify() we enable the notifications and we read
> the avail index to check if new buffers have become available in
> the meantime. In this case, the device would go to re-read avail
> index to access the descriptor.
>
> As we already do in other place, we can cache the value in `avail_idx`
> and compare it with `last_avail_idx` to check if there are new
> buffers available.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Patch looks fine but I guess we won't get performance improvement
since it doesn't save any userspace/VM memory access?

Thanks

> ---
>  drivers/vhost/vhost.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..07363dff559e 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2543,8 +2543,9 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>                        &vq->avail->idx, r);
>                 return false;
>         }
> +       vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
>
> -       return vhost16_to_cpu(vq, avail_idx) != vq->avail_idx;
> +       return vq->avail_idx != vq->last_avail_idx;
>  }
>  EXPORT_SYMBOL_GPL(vhost_enable_notify);
>
> --
> 2.31.1
>

