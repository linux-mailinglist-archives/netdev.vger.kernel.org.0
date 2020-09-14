Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661942682B0
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 04:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINCm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 22:42:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbgINCmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 22:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600051340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAara/ChDatzgfsJw1KVRRZSOmBMiVP7kGi1yosi4Xw=;
        b=HRlZ0BW++QJigQqTe2SISXhqvQwH5C7pbmSnnPBCG6SJvocbGLghunF7RKeEMMrc5JbpY7
        Y+sCF4cuf1j3cLuGTZuk/5iYCZL2n+JMWDOIKUKVMmkIvCOZTbtalakk8PLKv/Wzfh+3PM
        MtVaTJtW2VabgNEtLw0ukAmEHrfFNNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-PMEHTvPYNtivp0j5MCgq1g-1; Sun, 13 Sep 2020 22:42:16 -0400
X-MC-Unique: PMEHTvPYNtivp0j5MCgq1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 729CE1074658;
        Mon, 14 Sep 2020 02:42:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 674AE60C87;
        Mon, 14 Sep 2020 02:42:15 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4CED7180BACB;
        Mon, 14 Sep 2020 02:42:15 +0000 (UTC)
Date:   Sun, 13 Sep 2020 22:42:15 -0400 (EDT)
From:   Jason Wang <jasowang@redhat.com>
To:     Li Wang <li.wang@windriver.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <1199326218.16921082.1600051335160.JavaMail.zimbra@redhat.com>
In-Reply-To: <1599836979-4950-1-git-send-email-li.wang@windriver.com>
References: <1599836979-4950-1-git-send-email-li.wang@windriver.com>
Subject: Re: [PATCH] vhost: reduce stack usage in log_used
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.20, 10.4.195.2]
Thread-Topic: vhost: reduce stack usage in log_used
Thread-Index: s9yTJ0ICAZlN+4H+zWFH+IIKdn+BDA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> Fix the warning: [-Werror=-Wframe-larger-than=]
> 
> drivers/vhost/vhost.c: In function log_used:
> drivers/vhost/vhost.c:1906:1:
> warning: the frame size of 1040 bytes is larger than 1024 bytes
> 
> Signed-off-by: Li Wang <li.wang@windriver.com>
> ---
>  drivers/vhost/vhost.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519c..41769de 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1884,25 +1884,31 @@ static int log_write_hva(struct vhost_virtqueue *vq,
> u64 hva, u64 len)
>  
>  static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
>  {
> -	struct iovec iov[64];
> +	struct iovec *iov;
>  	int i, ret;
>  
>  	if (!vq->iotlb)
>  		return log_write(vq->log_base, vq->log_addr + used_offset, len);
>  
> +	iov = kcalloc(64, sizeof(*iov), GFP_KERNEL);
> +	if (!iov)
> +		return -ENOMEM;

Let's preallocate it in e.g vhost_net_open().

We don't want to fail the log due to -ENOMEM.

Thanks

> +
>  	ret = translate_desc(vq, (uintptr_t)vq->used + used_offset,
>  			     len, iov, 64, VHOST_ACCESS_WO);
>  	if (ret < 0)
> -		return ret;
> +		goto out;
>  
>  	for (i = 0; i < ret; i++) {
>  		ret = log_write_hva(vq,	(uintptr_t)iov[i].iov_base,
>  				    iov[i].iov_len);
>  		if (ret)
> -			return ret;
> +			goto out;
>  	}
>  
> -	return 0;
> +out:
> +	kfree(iov);
> +	return ret;
>  }
>  
>  int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
> --
> 2.7.4
> 
> 

