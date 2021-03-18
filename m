Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C74D33FDBE
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhCRDXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231270AbhCRDWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:22:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616037769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LAdQb1xWq5W0KP92TFMDYP8cv7SphLZ0dz63LpVNMdg=;
        b=XPjqGK+96Vi9gd5eVa/+C+egUxpSiuwKDwL33fzoi/brhYMcgJbrtETJollbP4JgISlce1
        ncmX5S5yhvKP+/2T2pBImsKjhjxtGCIXNgRgs6l63nvQhd8Fs/lRizYYCOIRAS5Ogyw/ub
        Pgla617f7sGm/R8EUjB1bz+ZvTiiDYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-lvKCQcO5NiKXKEvGPTtdLA-1; Wed, 17 Mar 2021 23:22:48 -0400
X-MC-Unique: lvKCQcO5NiKXKEvGPTtdLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B06BB8189D3;
        Thu, 18 Mar 2021 03:22:44 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-131.pek2.redhat.com [10.72.13.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 214261007625;
        Thu, 18 Mar 2021 03:22:23 +0000 (UTC)
Subject: Re: [PATCH v4 09/14] vhost/vdpa: use get_config_size callback in
 vhost_vdpa_config_validate()
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
References: <20210315163450.254396-1-sgarzare@redhat.com>
 <20210315163450.254396-10-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <32d55226-445e-4de5-2f5e-327bc724f0c4@redhat.com>
Date:   Thu, 18 Mar 2021 11:22:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315163450.254396-10-sgarzare@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/16 ÉÏÎç12:34, Stefano Garzarella Ð´µÀ:
> Let's use the new 'get_config_size()' callback available instead of
> using the 'virtio_id' to get the size of the device config space.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vdpa.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index e0a27e336293..7ae4080e57d8 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -188,13 +188,8 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>   static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
>   				      struct vhost_vdpa_config *c)
>   {
> -	long size = 0;
> -
> -	switch (v->virtio_id) {
> -	case VIRTIO_ID_NET:
> -		size = sizeof(struct virtio_net_config);
> -		break;
> -	}
> +	struct vdpa_device *vdpa = v->vdpa;
> +	long size = vdpa->config->get_config_size(vdpa);
>   
>   	if (c->len == 0)
>   		return -EINVAL;

