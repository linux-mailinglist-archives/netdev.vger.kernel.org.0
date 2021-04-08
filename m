Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F4357FBE
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhDHJqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:46:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231528AbhDHJqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 05:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617875168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Ed8cXY4Fne68ovFitKR7CHeZADetAwCYIlL4r4Eb7U=;
        b=Lr35rziQnaP6LBty/yNixZj/2cLkYgLDFlnIaLen5Se0C4QuLYlmPZVL5rvAvyeR2Egb9P
        rxTjA9ANhFs/rXr8I4arqwY2i3VCxY2T4zsbeJ41o6dHU3DiJ37+82B8D9hVjlyBLBzrJA
        7B5qoI5F9pdoBS4LkX6aSo8lJRRkwko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-4ZpPA4M8OmqqMcNkDqAJog-1; Thu, 08 Apr 2021 05:46:05 -0400
X-MC-Unique: 4ZpPA4M8OmqqMcNkDqAJog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 905E98189D6;
        Thu,  8 Apr 2021 09:46:01 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-53.pek2.redhat.com [10.72.13.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05FE36B543;
        Thu,  8 Apr 2021 09:45:55 +0000 (UTC)
Subject: Re: [PATCH 5/5] vdpa/mlx5: Fix suspend/resume index restoration
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com, parav@nvidia.com,
        si-wei.liu@oracle.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210408091047.4269-1-elic@nvidia.com>
 <20210408091047.4269-6-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a5356a13-6d7d-8086-bfff-ff869aec5449@redhat.com>
Date:   Thu, 8 Apr 2021 17:45:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408091047.4269-6-elic@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/8 ÏÂÎç5:10, Eli Cohen Ð´µÀ:
> When we suspend the VM, the VDPA interface will be reset. When the VM is
> resumed again, clear_virtqueues() will clear the available and used
> indices resulting in hardware virqtqueue objects becoming out of sync.
> We can avoid this function alltogether since qemu will clear them if
> required, e.g. when the VM went through a reboot.
>
> Moreover, since the hw available and used indices should always be
> identical on query and should be restored to the same value same value
> for virtqueues that complete in order, we set the single value provided
> by set_vq_state(). In get_vq_state() we return the value of hardware
> used index.
>
> Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after change map")
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---


Acked-by: Jason Wang <jasowang@redhat.com>


>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 21 ++++++++-------------
>   1 file changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 6fe61fc57790..4d2809c7d4e3 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1169,6 +1169,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>   		return;
>   	}
>   	mvq->avail_idx = attr.available_index;
> +	mvq->used_idx = attr.used_index;
>   }
>   
>   static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> @@ -1426,6 +1427,7 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>   		return -EINVAL;
>   	}
>   
> +	mvq->used_idx = state->avail_index;
>   	mvq->avail_idx = state->avail_index;
>   	return 0;
>   }
> @@ -1443,7 +1445,11 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>   	 * that cares about emulating the index after vq is stopped.
>   	 */
>   	if (!mvq->initialized) {
> -		state->avail_index = mvq->avail_idx;
> +		/* Firmware returns a wrong value for the available index.
> +		 * Since both values should be identical, we take the value of
> +		 * used_idx which is reported correctly.
> +		 */
> +		state->avail_index = mvq->used_idx;
>   		return 0;
>   	}
>   
> @@ -1452,7 +1458,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>   		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
>   		return err;
>   	}
> -	state->avail_index = attr.available_index;
> +	state->avail_index = attr.used_index;
>   	return 0;
>   }
>   
> @@ -1540,16 +1546,6 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
>   	}
>   }
>   
> -static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
> -{
> -	int i;
> -
> -	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
> -		ndev->vqs[i].avail_idx = 0;
> -		ndev->vqs[i].used_idx = 0;
> -	}
> -}
> -
>   /* TODO: cross-endian support */
>   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
>   {
> @@ -1785,7 +1781,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>   	if (!status) {
>   		mlx5_vdpa_info(mvdev, "performing device reset\n");
>   		teardown_driver(ndev);
> -		clear_virtqueues(ndev);
>   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>   		ndev->mvdev.status = 0;
>   		ndev->mvdev.mlx_features = 0;

