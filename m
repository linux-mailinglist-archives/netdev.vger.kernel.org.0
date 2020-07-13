Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAAA21CDC4
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 05:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgGMDb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 23:31:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbgGMDb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 23:31:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594611117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fyZHuYtJrGj2meth1Sm/wJxgmzcWzcHt3+2ZKG1/cLQ=;
        b=LZ6xsInsUKdXrdg9pOpQgApxG7dqEqgfNN0KrGu0jPbnfoG+iWvQFeZSkS+NlietsAfhRR
        EFR5w+HlyK/pOPsh1ZzgLiNpLnngDwV/1dftVhLZhxU16nW8HXiCmkcRYUW84Zlpv8WMfN
        l077Ej5+cXoZL2jA18Xq4z1v3DzPgi8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-nd3WMGC_Mj-Yat-odoEbZw-1; Sun, 12 Jul 2020 23:31:54 -0400
X-MC-Unique: nd3WMGC_Mj-Yat-odoEbZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5A41800597;
        Mon, 13 Jul 2020 03:31:52 +0000 (UTC)
Received: from [10.72.13.177] (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EDFF5C6C0;
        Mon, 13 Jul 2020 03:31:44 +0000 (UTC)
Subject: Re: [PATCH] vhost/scsi: fix up req type endian-ness
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200710104849.406023-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8acbce23-275a-141a-0bfb-1535c6edcbb4@redhat.com>
Date:   Mon, 13 Jul 2020 11:31:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710104849.406023-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/10 下午6:48, Michael S. Tsirkin wrote:
> vhost/scsi doesn't handle type conversion correctly
> for request type when using virtio 1.0 and up for BE,
> or cross-endian platforms.
>
> Fix it up using vhost_32_to_cpu.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/vhost/scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 6fb4d7ecfa19..b22adf03f584 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1215,7 +1215,7 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>   			continue;
>   		}
>   
> -		switch (v_req.type) {
> +		switch (vhost32_to_cpu(vq, v_req.type)) {
>   		case VIRTIO_SCSI_T_TMF:
>   			vc.req = &v_req.tmf;
>   			vc.req_size = sizeof(struct virtio_scsi_ctrl_tmf_req);


Acked-by: Jason Wang <jasowang@redhat.com>


