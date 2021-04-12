Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B36735C2BC
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241220AbhDLJsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 05:48:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241682AbhDLJqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 05:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618220745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VIbjcuPC8N7M+c8siBXb+nqnEmaj8al3DwWSW085yH4=;
        b=ftOCZjPFYnBvJn8wIIIj770n1E8KI/P6wlsfKrtqP+IuZMkjSURNK9TRMv30Gg89Ve3kxG
        DxRW3BGhCqWe8Kz0DpvFg6rowBzXZamhnMUy0A/quEpBzgvNvCGX/VFt84Rha4SC6nM3xz
        duoVYqgUCFtNAAFpKV612EeBjozRVsI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-HQjvhX-LOsmrxNMG3pSHew-1; Mon, 12 Apr 2021 05:45:44 -0400
X-MC-Unique: HQjvhX-LOsmrxNMG3pSHew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE1B66415B;
        Mon, 12 Apr 2021 09:45:42 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-232.pek2.redhat.com [10.72.13.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 761635C26D;
        Mon, 12 Apr 2021 09:45:36 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs
 fails
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com, si-wei.liu@oracle.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20210411083646.910546-1-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <427b1f96-9e41-a1e3-1ce5-09fc38799e69@redhat.com>
Date:   Mon, 12 Apr 2021 17:45:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210411083646.910546-1-elic@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/11 ÏÂÎç4:36, Eli Cohen Ð´µÀ:
> Set err = -ENOMEM if dma_map_sg_attrs() fails so the function reutrns
> error.
>
> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/vdpa/mlx5/core/mr.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index 3908ff28eec0..800cfd1967ad 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -278,8 +278,10 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
>   	mr->log_size = log_entity_size;
>   	mr->nsg = nsg;
>   	mr->nent = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
> -	if (!mr->nent)
> +	if (!mr->nent) {
> +		err = -ENOMEM;
>   		goto err_map;
> +	}
>   
>   	err = create_direct_mr(mvdev, mr);
>   	if (err)


Acked-by: Jason Wang <jasowang@redhat.com>


