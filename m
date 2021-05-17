Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D678938301A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 16:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbhEQOXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 10:23:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:50520 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238856AbhEQOVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 10:21:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621261224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pBvkavdK2+tEKfPns8/0KtXvMxeeFCb6/eSO70iXjJI=;
        b=KLTOub7TZSUOtkuHjpjekTAeT7wCeVfOQvosdmBXGcqwk4DiC/5/awqVvT7u7JBOfoHIyE
        v7KGYFo5pFFclu6Ss7cK58jfDScXMPZZBsPG4CyN9PmNL1hEk1EfZO+4UK8ttQkgRhH+L2
        e/oEsvaU+rkOSW2y8kZNRwFlPjxMsro=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C0BC3B271;
        Mon, 17 May 2021 14:20:23 +0000 (UTC)
Subject: Re: [PATCH 5/8] xen/netfront: read response from backend only once
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210513100302.22027-1-jgross@suse.com>
 <20210513100302.22027-6-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <c9f90370-fc02-3f05-0670-35f795c59d95@suse.com>
Date:   Mon, 17 May 2021 16:20:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210513100302.22027-6-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.05.2021 12:02, Juergen Gross wrote:
> In order to avoid problems in case the backend is modifying a response
> on the ring page while the frontend has already seen it, just read the
> response into a local buffer in one go and then operate on that buffer
> only.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>
with one remark:

> @@ -830,24 +830,22 @@ static int xennet_get_extras(struct netfront_queue *queue,
>  			break;
>  		}
>  
> -		extra = (struct xen_netif_extra_info *)
> -			RING_GET_RESPONSE(&queue->rx, ++cons);
> +		RING_COPY_RESPONSE(&queue->rx, ++cons, &extra);
>  
> -		if (unlikely(!extra->type ||
> -			     extra->type >= XEN_NETIF_EXTRA_TYPE_MAX)) {
> +		if (unlikely(!extra.type ||
> +			     extra.type >= XEN_NETIF_EXTRA_TYPE_MAX)) {
>  			if (net_ratelimit())
>  				dev_warn(dev, "Invalid extra type: %d\n",
> -					extra->type);
> +					extra.type);
>  			err = -EINVAL;
>  		} else {
> -			memcpy(&extras[extra->type - 1], extra,
> -			       sizeof(*extra));
> +			memcpy(&extras[extra.type - 1], &extra, sizeof(extra));

Maybe take the opportunity and switch to (type safe) structure
assignment?

Jan
