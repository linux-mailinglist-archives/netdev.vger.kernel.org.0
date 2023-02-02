Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4404A68874C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjBBTDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjBBTDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:03:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A093F23DA9
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 11:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675364542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4o2AJqH1LncKqMk2D1jCK1GtMJr5qHrJunic916Hg94=;
        b=B9Ri6O5etErDYDo9rXAkvghKDy4dfT5dOmigUBGrp3dbeu/pHQWMf7HF5LGCKNisXgqO8X
        VDb/vgG9bK67LmexxXcU5zVl7LYPlaxNyegVKjMxuLzWLaAN2twH4xFhPulGzhqlswddm8
        TP8YCw0r97DKIwmqYgNPhKbmyvltnMw=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-180-nLOTYfgwMcicqhZCLZdt5Q-1; Thu, 02 Feb 2023 14:02:21 -0500
X-MC-Unique: nLOTYfgwMcicqhZCLZdt5Q-1
Received: by mail-yb1-f199.google.com with SMTP id v37-20020a25aba8000000b0080f1143ef6bso2585813ybi.11
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 11:02:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4o2AJqH1LncKqMk2D1jCK1GtMJr5qHrJunic916Hg94=;
        b=JnjNnccPn73m4maTVPAqZxVp4ZArZ+7EfI0xn05Nodzbit+Ivm67uHnCpUGc2e0Z87
         MtL78Zzuc4lQKhdtLed3y5C7k8sSJMhSJgAskTR0WQEbDLY4u/IdABfWaBsuQX3l4LPc
         F5kANe1ptBhXJG+q1ZG+l4jGpVOh09fsNGtxlJymYq9OXwT72WN1qKeUqcsKORbPB5Ju
         ysM6c1EKlB4qrrQUKM+TS8neb8oINwSfovNy8GvBK7HSU4GWuTZNAi6Il2AdodUJFMui
         fMHLt2pub1NzkN/a0ZoKvyoYg6CVWEx7cqhBN5q0B1CPO5UbqvGsIzAykCETki/eahAG
         CKsw==
X-Gm-Message-State: AO0yUKUeb6jtq8fYlY58ngAfvkpN6bUe7SXGhYN04IKAYZ8oj6BSJCud
        GerQQqyj1f8qEoHpeV0MtuMGSviLtCmvARNWhWkvO3GL33tJNs06Afe8lv9w6LC7D2zJJWOhURn
        hjPk6zawRlw9VVVz/FUbRQ8IKIz/c9y7M
X-Received: by 2002:a0d:d40e:0:b0:51b:64c0:3251 with SMTP id w14-20020a0dd40e000000b0051b64c03251mr958174ywd.266.1675364540774;
        Thu, 02 Feb 2023 11:02:20 -0800 (PST)
X-Google-Smtp-Source: AK7set/riZxYvQVJ3LC0NhNQqpRjygkYkpjD+BLDdbvtidfkPC0ROeO4nsgpqbwnaZyZ0ebQph7F3TISMNXl0y3nYCs=
X-Received: by 2002:a0d:d40e:0:b0:51b:64c0:3251 with SMTP id
 w14-20020a0dd40e000000b0051b64c03251mr958168ywd.266.1675364540565; Thu, 02
 Feb 2023 11:02:20 -0800 (PST)
MIME-Version: 1.0
References: <20230201152018.1270226-1-alvaro.karsz@solid-run.com> <20230202084212.1328530-1-alvaro.karsz@solid-run.com>
In-Reply-To: <20230202084212.1328530-1-alvaro.karsz@solid-run.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 2 Feb 2023 20:01:44 +0100
Message-ID: <CAJaqyWeQRcnZ45xHYjbOhcQpN4kpPWADAK2gTvmBVeMwp19H8Q@mail.gmail.com>
Subject: Re: [PATCH v2] vhost-vdpa: print warning when vhost_vdpa_alloc_domain fails
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 9:42 AM Alvaro Karsz <alvaro.karsz@solid-run.com> wr=
ote:
>
> Add a print explaining why vhost_vdpa_alloc_domain failed if the device
> is not IOMMU cache coherent capable.
>
> Without this print, we have no hint why the operation failed.
>
> For example:
>
> $ virsh start <domain>
>         error: Failed to start domain <domain>
>         error: Unable to open '/dev/vhost-vdpa-<idx>' for vdpa device:
>                Unknown error 524
>
> Suggested-by: Eugenio Perez Martin <eperezma@redhat.com>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
>

Acked-by: Eugenio P=C3=A9rez Martin <eperezma@redhat.com>

Thanks!

> ---
> v2:
>         - replace dev_err with dev_warn_once.
>
>  drivers/vhost/vdpa.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 23db92388393..135f8aa70fb2 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1151,8 +1151,11 @@ static int vhost_vdpa_alloc_domain(struct vhost_vd=
pa *v)
>         if (!bus)
>                 return -EFAULT;
>
> -       if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
> +       if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY)) {
> +               dev_warn_once(&v->dev,
> +                             "Failed to allocate domain, device is not I=
OMMU cache coherent capable\n");
>                 return -ENOTSUPP;
> +       }
>
>         v->domain =3D iommu_domain_alloc(bus);
>         if (!v->domain)
> --
> 2.34.1
>

