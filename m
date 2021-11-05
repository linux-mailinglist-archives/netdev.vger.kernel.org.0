Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA2B445E0C
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 03:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhKECvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 22:51:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230395AbhKECva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 22:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636080530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xCcEqsnBhifvXkjiVwnMz5H8oH0AK0pj5dvEeQNewCw=;
        b=P8PsQLaNAFe15EoPXLqHJvLqhI1Mh4ZsRfcc7kfMHOj+KTZaA4ai9RzeQi6upWs/Xu+UDQ
        bckjdU+b+xk7KUPJ7cKqAWV7BE5QsWEQyjRlON7wF+GsoprcI2J9VfHcjEJI3QvV2BwlwA
        fAYtj+Rj93Mxwt16uTrxiRsLIJWxp/I=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-EbbrbVE4NiuMPAIx9FDm9w-1; Thu, 04 Nov 2021 22:48:49 -0400
X-MC-Unique: EbbrbVE4NiuMPAIx9FDm9w-1
Received: by mail-lf1-f71.google.com with SMTP id c13-20020a05651200cd00b004001aab328aso2884704lfp.1
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 19:48:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xCcEqsnBhifvXkjiVwnMz5H8oH0AK0pj5dvEeQNewCw=;
        b=12lGVCF4Jvf3WoBzj9RnCFp9UoJvHctExj0kcEeuJF9GiKmuiwZO8j2G2cXcQrtHJI
         LUxQk9bZmHhQH0zTE6Fq+gQubksV5KlYfISPosxRyT0q2jOaj2+txWD+cB8qWffa3RJ2
         V4tjnXfTEld9IUiJEioTDxP6P81DZdj7zDqlZZwjrycU7QiCqZa0YyBxk4+A5AILbh5j
         bq/Bva/v0gz88er5eIJ5HJrai4pz+r4i4ATxEwAa3Qs990zZ1hhi42Ersr7UuVftpd+U
         SXkgfm30a2rpBPARTHUasPMu6D72scOuECzHefzKJWeyflB39G4+2Ffovw4PhR8AHST1
         du7A==
X-Gm-Message-State: AOAM532o79xnk6W1uToIEUH4B8mEYJRJCLqLT7XRdyLJ5nZNjsSj1voP
        j4U/HnQof+PMUdD4b9Y2IGCRcumM6gGwd2pdryNfD1EkJrly+egyvYvE+fiRDfw4ZTLBMNrJ3Wa
        ATggUZGrLfNW5twZ3ORoO/aQgZj54W48z
X-Received: by 2002:ac2:4e68:: with SMTP id y8mr52932395lfs.348.1636080528103;
        Thu, 04 Nov 2021 19:48:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzS1jRGe/qTBDl1fmwuB1InzojHnj32ucWekjQLu2yHsikj5gNhAUpYDb19ZeRf/IO8Jf3Qu4zH8GujGcXFofc=
X-Received: by 2002:ac2:4e68:: with SMTP id y8mr52932379lfs.348.1636080527953;
 Thu, 04 Nov 2021 19:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211104195833.2089796-1-eperezma@redhat.com>
In-Reply-To: <20211104195833.2089796-1-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 5 Nov 2021 10:48:37 +0800
Message-ID: <CACGkMEug9Ci=mmQcwPwD0rKo4Lp8Vkz87i5X6H9Y0MfgQNc53g@mail.gmail.com>
Subject: Re: [PATCH] vdpa: Avoid duplicate call to vp_vdpa get_status
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 5, 2021 at 3:58 AM Eugenio P=C3=A9rez <eperezma@redhat.com> wro=
te:
>
> It has no sense to call get_status twice, since we already have a
> variable for that.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 01c59ce7e250..10676ea0348b 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -167,13 +167,13 @@ static long vhost_vdpa_set_status(struct vhost_vdpa=
 *v, u8 __user *statusp)
>         status_old =3D ops->get_status(vdpa);
>
>         /*
>          * Userspace shouldn't remove status bits unless reset the
>          * status to 0.
>          */
> -       if (status !=3D 0 && (ops->get_status(vdpa) & ~status) !=3D 0)
> +       if (status !=3D 0 && (status_old & ~status) !=3D 0)
>                 return -EINVAL;
>
>         if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) && !(status & VIRTIO=
_CONFIG_S_DRIVER_OK))
>                 for (i =3D 0; i < nvqs; i++)
>                         vhost_vdpa_unsetup_vq_irq(v, i);
>
> --
> 2.27.0
>

