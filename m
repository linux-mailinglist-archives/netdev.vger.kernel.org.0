Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C054030C757
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbhBBRSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbhBBRPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:15:48 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41898C061793;
        Tue,  2 Feb 2021 09:14:17 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 6so21286492wri.3;
        Tue, 02 Feb 2021 09:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k4CVJlb0/AWH3A5Sub6ShZZ3WZC37rBXFHjTDRb3cs8=;
        b=E7vNGQax2iQ+VzmOWvnQc0Ye+5pEJQ54SIN3BtnUz+f20UyqTUOd96462rNbqQ2w4G
         AIxPDjuuEAOtxsNdfC1YdwNwbd/CUwcjZHNYsIYwtWTJeglBMsgpzNv9Fr7P7emFipcQ
         YAfxD6H+9zbWpu1VhQn0hIPGHKhLkS0mnIMclIXFfsm96cmXH6K+zVTPNGq6NTmxY36m
         5tSTDC2DtjKPTu2C7yngO4aG4zQumjZXhEGQGyi6bM4rpg/jb1KOP0Nu1oyy+YPyZHpD
         XAyQd9PLaejKLKgMbxhEUiSv/x2L8tkE/Gax3xxRTjAEXCBhoOt+Z/dFQsoL6zjqOaiv
         rrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k4CVJlb0/AWH3A5Sub6ShZZ3WZC37rBXFHjTDRb3cs8=;
        b=duWcyMRN3YAGiPsm9YxTV69mE10eDK6PuNS72OH6lleS/ZHg0PQmF2dVmIQzmgSjNr
         PHNI8WgojCAGFLm3+GYtH4meQZ9tsQIoXn5EXtopduBEN1j62RQC+1A8/xXfvD9yD5JG
         DzLuH0I7qa5I+abwVmunM/2F+JkEpfLRVuxOKcve5hlVWiWcjtVJ2nSEUSl8op2k2JzN
         plxf57Z5V2ygytl+WMUMzB9A4EOc90A06iSSrcKQjZeIzyTqRoWkxY03KHMsXi6EtIqO
         EEldqnnTpBxEW01/B/Bc9B56FmeuHyb4tmjjmeqEjW0aZozIjXSMOJ7oLyKIV+vp/Qtp
         cvZg==
X-Gm-Message-State: AOAM532QPkc76Lx1CMFzw9i/YxBuPiN0k+GY75C+FD/TQJyy4DKD0QVK
        gaEY6tVO8GQn+Xixy+CKPMgkDzCoXMZVr743aB8=
X-Google-Smtp-Source: ABdhPJzgh6Vc+DUq9tdwN2uJ46Lh9+eMLS11bhb8F+ysmXG56poEbcOCvD5XP4uvYaOUA09pp7BUGnMtp1hix5FIEKk=
X-Received: by 2002:adf:e448:: with SMTP id t8mr25353656wrm.288.1612286055917;
 Tue, 02 Feb 2021 09:14:15 -0800 (PST)
MIME-Version: 1.0
References: <20210202142901.7131-1-elic@nvidia.com>
In-Reply-To: <20210202142901.7131-1-elic@nvidia.com>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Tue, 2 Feb 2021 09:14:02 -0800
Message-ID: <CAPWQSg3Z1aCZc7kX2x_4NLtAzkrZ+eO5ABBF0bAQfaLc=++Y2Q@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: Restore the hardware used index after change map
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lulu@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 6:34 AM Eli Cohen <elic@nvidia.com> wrote:
>
> When a change of memory map occurs, the hardware resources are destroyed
> and then re-created again with the new memory map. In such case, we need
> to restore the hardware available and used indices. The driver failed to
> restore the used index which is added here.
>
> Fixes 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
> This patch is being sent again a single patch the fixes hot memory
> addtion to a qemy process.
>
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 88dde3455bfd..839f57c64a6f 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
>         u64 device_addr;
>         u64 driver_addr;
>         u16 avail_index;
> +       u16 used_index;
>         bool ready;
>         struct vdpa_callback cb;
>         bool restore;
> @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
>         u32 virtq_id;
>         struct mlx5_vdpa_net *ndev;
>         u16 avail_idx;
> +       u16 used_idx;
>         int fw_state;
>
>         /* keep last in the struct */
> @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
>
>         obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in, obj_context);
>         MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail_idx);
> +       MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);

The saved indexes will apply to the new virtqueue object whenever it
is created. In virtio spec, these indexes will reset back to zero when
the virtio device is reset. But I don't see how it's done today. IOW,
I don't see where avail_idx and used_idx get cleared from the mvq for
device reset via set_status().

-Siwei


>         MLX5_SET(virtio_net_q_object, obj_context, queue_feature_bit_mask_12_3,
>                  get_features_12_3(ndev->mvdev.actual_features));
>         vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
> @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>  struct mlx5_virtq_attr {
>         u8 state;
>         u16 available_index;
> +       u16 used_index;
>  };
>
>  static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq,
> @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
>         memset(attr, 0, sizeof(*attr));
>         attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
>         attr->available_index = MLX5_GET(virtio_net_q_object, obj_context, hw_available_index);
> +       attr->used_index = MLX5_GET(virtio_net_q_object, obj_context, hw_used_index);
>         kfree(out);
>         return 0;
>
> @@ -1610,6 +1615,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>                 return err;
>
>         ri->avail_index = attr.available_index;
> +       ri->used_index = attr.used_index;
>         ri->ready = mvq->ready;
>         ri->num_ent = mvq->num_ent;
>         ri->desc_addr = mvq->desc_addr;
> @@ -1654,6 +1660,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
>                         continue;
>
>                 mvq->avail_idx = ri->avail_index;
> +               mvq->used_idx = ri->used_index;
>                 mvq->ready = ri->ready;
>                 mvq->num_ent = ri->num_ent;
>                 mvq->desc_addr = ri->desc_addr;
> --
> 2.29.2
>
