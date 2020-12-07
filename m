Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39C12D09F7
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 06:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgLGFTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 00:19:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgLGFTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 00:19:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607318269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4NEmPb1vJdnm+1yHtk70TIfP0G6eCyJYhuhh3SVbKYs=;
        b=QcHsliStAPyrfP5n+aAYJ9NsgFTopiU8XjWL8kSm1p/t1s0fl3Mby8F7NgUPRvv0mx+yb/
        2GBMYfZ8y0aYwqTRiXFxDn53w45qpJwwPGLj/ehRJqvyrFWbby7FcJcIxwWblccKKcge7b
        gGYD7OdEoXhTno8lUSu8a6qQjgqWq1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-YHvFQFlePI672EkIO4xVIg-1; Mon, 07 Dec 2020 00:17:47 -0500
X-MC-Unique: YHvFQFlePI672EkIO4xVIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43ED7100C602;
        Mon,  7 Dec 2020 05:17:46 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B77D810016FA;
        Mon,  7 Dec 2020 05:17:36 +0000 (UTC)
Subject: Re: [PATCH] vhost scsi: fix error return code in
 vhost_scsi_set_endpoint()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1607071411-33484-1-git-send-email-zhangchangzhong@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <754d3d21-1dfa-6675-5014-2e8fb102c363@redhat.com>
Date:   Mon, 7 Dec 2020 13:17:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1607071411-33484-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/4 下午4:43, Zhang Changzhong wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Fixes: 25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>   drivers/vhost/scsi.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 6ff8a5096..4ce9f00 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1643,7 +1643,8 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
>   			if (!vhost_vq_is_setup(vq))
>   				continue;
>   
> -			if (vhost_scsi_setup_vq_cmds(vq, vq->num))
> +			ret = vhost_scsi_setup_vq_cmds(vq, vq->num);
> +			if (ret)
>   				goto destroy_vq_cmds;
>   		}
>   


Acked-by: Jason Wang <jasowang@redhat.com>


