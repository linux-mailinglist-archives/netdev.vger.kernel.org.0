Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EEC26A063
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIOIHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:07:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28411 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726192AbgIOHxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 03:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600156405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lGaRRpjQpf+p1Uh5RvyOwyknbPxdKoLhOu6iSyQOJLQ=;
        b=CvxHaP96CKDSfEhVFfqiXyF+ln4QEftHglvVYy3QiiIw2AU2EyRu8A1n5BpR4u5prjweW2
        bXhD1QFv7lKCqtK5w9sQPEHCvVFelQbe+3PiLzG+rsMG2CgVolQ+hNVV/rsnpbxtAKsFzD
        VWE3uXQsHlT6zhk/wfXY0zivH+y7ehQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-CKquWnuHPniKTi8BnrRA9A-1; Tue, 15 Sep 2020 03:53:23 -0400
X-MC-Unique: CKquWnuHPniKTi8BnrRA9A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F8A58014D9;
        Tue, 15 Sep 2020 07:53:22 +0000 (UTC)
Received: from [10.72.13.94] (ovpn-13-94.pek2.redhat.com [10.72.13.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A4A27EB8B;
        Tue, 15 Sep 2020 07:53:17 +0000 (UTC)
Subject: Re: [PATCH] vhost: reduce stack usage in log_used
To:     Li Wang <li.wang@windriver.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199326218.16921082.1600051335160.JavaMail.zimbra@redhat.com>
 <1600106889-25013-1-git-send-email-li.wang@windriver.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7c22eeb8-6060-929d-15d7-f1403b98c17f@redhat.com>
Date:   Tue, 15 Sep 2020 15:53:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1600106889-25013-1-git-send-email-li.wang@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/15 上午2:08, Li Wang wrote:
> Fix the warning: [-Werror=-Wframe-larger-than=]
>
> drivers/vhost/vhost.c: In function log_used:
> drivers/vhost/vhost.c:1906:1:
> warning: the frame size of 1040 bytes is larger than 1024 bytes
>
> Signed-off-by: Li Wang <li.wang@windriver.com>
> ---
>   drivers/vhost/vhost.c | 2 +-
>   drivers/vhost/vhost.h | 1 +
>   2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519c..31837a5
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1884,7 +1884,7 @@ static int log_write_hva(struct vhost_virtqueue *vq, u64 hva, u64 len)
>   
>   static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
>   {
> -	struct iovec iov[64];
> +	struct iovec *iov = vq->log_iov;
>   	int i, ret;
>   
>   	if (!vq->iotlb)
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 9032d3c..5fe4b47
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -123,6 +123,7 @@ struct vhost_virtqueue {
>   	/* Log write descriptors */
>   	void __user *log_base;
>   	struct vhost_log *log;
> +	struct iovec log_iov[64];
>   
>   	/* Ring endianness. Defaults to legacy native endianness.
>   	 * Set to true when starting a modern virtio device. */


Acked-by: Jason Wang <jasowang@redhat.com>


