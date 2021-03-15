Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03CB33C27E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhCOQwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:52:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232488AbhCOQvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615827104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFFcd4wD8/CMTprSPx6NQ5pGVPcuBak1/nAOtKKtWKQ=;
        b=WuhGiCrPxSAwPNs/wwshEq0B5MzHKYk31vyK1yy8ZPFkKrCOeP6o/uMGDb2g7jJh07yzAB
        x/xjHZvi90eaWIfEt+rgex+Rqb5QQ6ZhmdojcFNKVCw7dl/0pjzK45S0MINmFVx7VeKJcd
        GuArS1/2ntul3blQSfWBzcAbrmWDTlc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-HlO-i1j-P7ub0ae-8cCVmA-1; Mon, 15 Mar 2021 12:51:41 -0400
X-MC-Unique: HlO-i1j-P7ub0ae-8cCVmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98F951B2C981;
        Mon, 15 Mar 2021 16:51:39 +0000 (UTC)
Received: from [10.36.112.75] (ovpn-112-75.ams2.redhat.com [10.36.112.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 359965D745;
        Mon, 15 Mar 2021 16:51:31 +0000 (UTC)
Subject: Re: [PATCH v4 06/14] vringh: add vringh_kiov_length() helper
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
References: <20210315163450.254396-1-sgarzare@redhat.com>
 <20210315163450.254396-7-sgarzare@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <b06eb44c-d4e5-e47c-fbf5-26be469aae9e@redhat.com>
Date:   Mon, 15 Mar 2021 17:51:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210315163450.254396-7-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2021 17:34, Stefano Garzarella wrote:
> This new helper returns the total number of bytes covered by
> a vringh_kiov.
> 
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/linux/vringh.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 755211ebd195..84db7b8f912f 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -199,6 +199,17 @@ static inline void vringh_kiov_cleanup(struct vringh_kiov *kiov)
>  	kiov->iov = NULL;
>  }
>  
> +static inline size_t vringh_kiov_length(struct vringh_kiov *kiov)
> +{
> +	size_t len = 0;
> +	int i;
> +
> +	for (i = kiov->i; i < kiov->used; i++)
> +		len += kiov->iov[i].iov_len;
> +
> +	return len;
> +}

Do we really need an helper?

For instance, we can use:

len = iov_length((struct iovec *)kiov->iov, kiov->used);

Or do we want to avoid the cast?

Thanks,
Laurent

