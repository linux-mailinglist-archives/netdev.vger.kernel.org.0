Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FB81FC49A
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 05:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgFQDTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 23:19:42 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36065 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726759AbgFQDTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 23:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592363977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mq/stawXjx0dcB0y1QUsFlRW19BEay/7Pm1Vse2Y1ZY=;
        b=hvjuil4itLv34XSCzPH5UpQnwFhLwaWHcr1OJpyNSf/1t491Hsq/xPxiLR8vKFEjw4PJ7p
        K9wIgoCk4SdK2j7vEYucWbWpDf+7AWTOMTJt71e+nDXTMAdT/2YvSX5z8PcxMe+1iB9H4F
        1HHeuHR91Vw9TCHqtYs5N6rpdtjMXic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-xkJ2Kb9hMbC8iI2CXnx6hw-1; Tue, 16 Jun 2020 23:19:33 -0400
X-MC-Unique: xkJ2Kb9hMbC8iI2CXnx6hw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A81C910059A6;
        Wed, 17 Jun 2020 03:19:32 +0000 (UTC)
Received: from [10.72.13.217] (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D49205D9D3;
        Wed, 17 Jun 2020 03:19:27 +0000 (UTC)
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, eperezma@redhat.com
References: <20200611113404.17810-1-mst@redhat.com>
 <20200611113404.17810-3-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com>
Date:   Wed, 17 Jun 2020 11:19:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200611113404.17810-3-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/11 下午7:34, Michael S. Tsirkin wrote:
>   static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>   {
>   	kfree(vq->descs);
> @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>   	for (i = 0; i < dev->nvqs; ++i) {
>   		vq = dev->vqs[i];
>   		vq->max_descs = dev->iov_limit;
> +		if (vhost_vq_num_batch_descs(vq) < 0) {
> +			return -EINVAL;
> +		}


This check breaks vdpa which set iov_limit to zero. Consider iov_limit 
is meaningless to vDPA, I wonder we can skip the test when device 
doesn't use worker.

Thanks

