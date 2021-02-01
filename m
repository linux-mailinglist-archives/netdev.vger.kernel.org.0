Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F63130AFC9
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhBASwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbhBASwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:52:09 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988ACC061573;
        Mon,  1 Feb 2021 10:51:28 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id m2so238589wmm.1;
        Mon, 01 Feb 2021 10:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t+1ROMgCAtu/xArHYsFd1+YZoT/w+IqsJ+s+xa9cGnA=;
        b=guYjshs7HC0I62X3kkx+RuXbELZ4OroN7UlF1sFZvbTo5jY5iab7DOjQ+EgsZ9Y3zN
         XimK9A3IfKNlQxOPGATUL1K5/0p9nJp9lH4rvPiKQqLGsvMOsS/d41zMTBwn8FHtorDV
         2SMUugxEH40GJ/7q5+67s7xGJyl7lGyqy6kSIUtJ2veA2QBD8GRkf5mMkq5RwLgWz0Qr
         3ZCP1a4xYPwqoBc0j1K3dlH8AjY9U8RWi8w32TvcV7Y7JnSwHSixCzFUviHgtgEksQhF
         xl49u7rWwyxBUbAaFa2daVYcYliQVWPX7ge76Tces1eY0woLpagr1vM/AeYTsiZlccUu
         k7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t+1ROMgCAtu/xArHYsFd1+YZoT/w+IqsJ+s+xa9cGnA=;
        b=B4QIlb7wzB00SyFRPeLLO5nAvWNu4HzcQrgpoA7SPIjWIKjdHFzBhm4S3vQxfvQ+NH
         Zx59j+mvIweGAv+Ost6qX2HuOZ6Zu0fgN+BVZrHHkr62PT70OcXY8oRpLiMAv9IK6xpY
         REFS6So6pHE8MC+GdqvNrhHjWvQ0OGljDWjgSmzGG5oGfaqFI8BUy09OVy04Vk3eDyxG
         J8fC4RHluL/Vd3XioAkkt0gWI0JYM/oj+mlD+OgwHoJyDDVTALD+4viLMSvANtKBJPWc
         J0SgWOl6IYWiuSiZYC8rlvo+3SqwECDJuef6GvzN4drNSO8XZEBwwNEtCTEtirIgPo5s
         3OYg==
X-Gm-Message-State: AOAM531pYf3IVi03YhliEkws0WIrS1/Z4HOszon34y0gesbiztcxlMOt
        zDgDoLpZhhgB9m0l+39PdHivY/Sgm9OJ0uXfkiA=
X-Google-Smtp-Source: ABdhPJy7sQZhNsX1mCxFoVvMIT++Dd517N4q1jo+5ewfDQfszmXr+MYshhj5Mleagi2M9n9PuYkZWVUazvwwP5FgW20=
X-Received: by 2002:a05:600c:354c:: with SMTP id i12mr235435wmq.51.1612205487194;
 Mon, 01 Feb 2021 10:51:27 -0800 (PST)
MIME-Version: 1.0
References: <20210128134130.3051-1-elic@nvidia.com> <20210128134130.3051-2-elic@nvidia.com>
In-Reply-To: <20210128134130.3051-2-elic@nvidia.com>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Mon, 1 Feb 2021 10:51:15 -0800
Message-ID: <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wrote:
>
> suspend_vq should only suspend the VQ on not save the current available
> index. This is done when a change of map occurs when the driver calls
> save_channel_info().

Hmmm, suspend_vq() is also called by teardown_vq(), the latter of
which doesn't save the available index as save_channel_info() doesn't
get called in that path at all. How does it handle the case that
aget_vq_state() is called from userspace (e.g. QEMU) while the
hardware VQ object was torn down, but userspace still wants to access
the queue index?

Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-send-email-si-wei.liu@oracle.com/

vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)

QEMU will complain with the above warning while VM is being rebooted
or shut down.

Looks to me either the kernel driver should cover this requirement, or
the userspace has to bear the burden in saving the index and not call
into kernel if VQ is destroyed.

-Siwei


>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 88dde3455bfd..549ded074ff3 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
>
>  static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
>  {
> -       struct mlx5_virtq_attr attr;
> -
>         if (!mvq->initialized)
>                 return;
>
> @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>
>         if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
>                 mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
> -
> -       if (query_virtqueue(ndev, mvq, &attr)) {
> -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> -               return;
> -       }
> -       mvq->avail_idx = attr.available_index;
>  }
>
>  static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> --
> 2.29.2
>
