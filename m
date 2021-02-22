Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1ED320FFB
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 05:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhBVEP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 23:15:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230083AbhBVEPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 23:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613967267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+x2TUELl7mIVGk/ohyT3Fe+rS53LsnETTro7AaKiEY=;
        b=HHwaiOd87D7gzCq9keJmrraERvauRvKr9QgTSV20O9rmMV4rtRXvYPJy4n2lZlRvahy+29
        peEAiywqXUCzne1Ax/TsNI5lEP/zqeKP7IIaVs8cLPEFjQnQnZQydszeflYxKluzCDcCg6
        clrbtVbbEG6JvHOZ9AJdApAvBGgvhiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-kMsuTl1_NKemZuv_UIhDrw-1; Sun, 21 Feb 2021 23:14:25 -0500
X-MC-Unique: kMsuTl1_NKemZuv_UIhDrw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 702D18030BB;
        Mon, 22 Feb 2021 04:14:24 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-112.pek2.redhat.com [10.72.13.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D41660C5C;
        Mon, 22 Feb 2021 04:14:19 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     Si-Wei Liu <si-wei.liu@oracle.com>, mst@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
Date:   Mon, 22 Feb 2021 12:14:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> for legacy") made an exception for legacy guests to reset
> features to 0, when config space is accessed before features
> are set. We should relieve the verify_min_features() check
> and allow features reset to 0 for this case.
>
> It's worth noting that not just legacy guests could access
> config space before features are set. For instance, when
> feature VIRTIO_NET_F_MTU is advertised some modern driver
> will try to access and validate the MTU present in the config
> space before virtio features are set.


This looks like a spec violation:

"

The following driver-read-only field, mtu only exists if 
VIRTIO_NET_F_MTU is set. This field specifies the maximum MTU for the 
driver to use.
"

Do we really want to workaround this?

Thanks


> Rejecting reset to 0
> prematurely causes correct MTU and link status unable to load
> for the very first config space access, rendering issues like
> guest showing inaccurate MTU value, or failure to reject
> out-of-range MTU.
>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
>   1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 7c1f789..540dd67 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
>   	return mvdev->mlx_features;
>   }
>   
> -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> -{
> -	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> -		return -EOPNOTSUPP;
> -
> -	return 0;
> -}
> -
>   static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
>   {
>   	int err;
> @@ -1558,18 +1550,13 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
>   {
>   	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>   	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> -	int err;
>   
>   	print_features(mvdev, features, true);
>   
> -	err = verify_min_features(mvdev, features);
> -	if (err)
> -		return err;
> -
>   	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
>   	ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
>   	ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
> -	return err;
> +	return 0;
>   }
>   
>   static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)

