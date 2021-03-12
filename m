Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5663385F6
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 07:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhCLGev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 01:34:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231801AbhCLGe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 01:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615530865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R+1V19JdRYahq0X3XulqGaxRbIWtSn54ETW3FVVrlmE=;
        b=IQ9Fpwukmo4cfjY0ErsuADXh3RvrsddSfFGlfH6UIYTaCHQWq9LA5Qy3lKcn9S0N/xQQ+Z
        8bQxHOEjGd6GackGphBpDGJdP8hzShAk5hC5tf3DelSxBKMapBuyLz0XK/ulvM4GycMSUJ
        1YYp7oL7J6QU6nuTQ63eQegsomNd0Ig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-m9UsF-HzPbOe7woipQPy0g-1; Fri, 12 Mar 2021 01:34:21 -0500
X-MC-Unique: m9UsF-HzPbOe7woipQPy0g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C31C107ACCA;
        Fri, 12 Mar 2021 06:34:20 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-168.pek2.redhat.com [10.72.13.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C04018A77;
        Fri, 12 Mar 2021 06:34:12 +0000 (UTC)
Subject: Re: [PATCH 2/2] vhost-vdpa: set v->config_ctx to NULL if
 eventfd_ctx_fdget() fails
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210311135257.109460-1-sgarzare@redhat.com>
 <20210311135257.109460-3-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a5eac458-eed7-df75-66ac-0a8349ad09b0@redhat.com>
Date:   Fri, 12 Mar 2021 14:34:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210311135257.109460-3-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/11 9:52 下午, Stefano Garzarella wrote:
> In vhost_vdpa_set_config_call() if eventfd_ctx_fdget() fails the
> 'v->config_ctx' contains an error instead of a valid pointer.
>
> Since we consider 'v->config_ctx' valid if it is not NULL, we should
> set it to NULL in this case to avoid to use an invalid pointer in
> other functions such as vhost_vdpa_config_put().
>
> Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
> Cc: lingshan.zhu@intel.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vdpa.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 00796e4ecfdf..f9ecdce5468a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -331,8 +331,12 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
>   	if (!IS_ERR_OR_NULL(ctx))
>   		eventfd_ctx_put(ctx);
>   
> -	if (IS_ERR(v->config_ctx))
> -		return PTR_ERR(v->config_ctx);
> +	if (IS_ERR(v->config_ctx)) {
> +		long ret = PTR_ERR(v->config_ctx);
> +
> +		v->config_ctx = NULL;
> +		return ret;
> +	}
>   
>   	v->vdpa->config->set_config_cb(v->vdpa, &cb);
>   

