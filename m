Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C59629859B
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 03:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421494AbgJZCpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 22:45:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1421490AbgJZCph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 22:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603680336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kiy/scF/hlp1wouCLACe5uKilF+W+fUexE2l1/eWOxo=;
        b=CRoW/AGhUTEBAsbDLQ784NWo1DHS7YoWf6bIZz+c0bfsWI0ZA5xIPV4zAHYiwz3nu6Apo6
        lNdh7DNOXvnFGqVb2Y4nBQhkmJHeNmEAoJe0B3gB1BVsLEdBS4VHJxuLb+5/oAjvy8nTA1
        MEpKnvdsniyHvqy3DrYT4iGAPJAmMzU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-xmmeefaqPMqyLvjBjDhZ-Q-1; Sun, 25 Oct 2020 22:45:34 -0400
X-MC-Unique: xmmeefaqPMqyLvjBjDhZ-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45391835B8E;
        Mon, 26 Oct 2020 02:45:33 +0000 (UTC)
Received: from [10.72.13.201] (ovpn-13-201.pek2.redhat.com [10.72.13.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A04A60C05;
        Mon, 26 Oct 2020 02:45:28 +0000 (UTC)
Subject: Re: [PATCH] vdpa: handle irq bypass register failure case
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20201023104046.404794-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bf3d5114-c55f-80e6-41b0-b7f5ae8ad9e9@redhat.com>
Date:   Mon, 26 Oct 2020 10:45:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201023104046.404794-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/23 下午6:40, Zhu Lingshan wrote:
> LKP considered variable 'ret' in vhost_vdpa_setup_vq_irq() as
> a unused variable, so suggest we remove it. Actually it stores
> return value of irq_bypass_register_producer(), but we did not
> check it, we should handle the failure case.
>
> This commit will print a message if irq bypass register producer
> fail, in this case, vqs still remain functional.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>   drivers/vhost/vdpa.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 62a9bb0efc55..d6b2c3bd1b01 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -107,6 +107,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>   	vq->call_ctx.producer.token = vq->call_ctx.ctx;
>   	vq->call_ctx.producer.irq = irq;
>   	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
> +	if (unlikely(ret))
> +		dev_info(&v->dev, "vq %u, irq bypass producer (token %p) registration fails, ret =  %d\n",
> +			 qid, vq->call_ctx.producer.token, ret);
>   	spin_unlock(&vq->call_ctx.ctx_lock);
>   }
>   


Acked-by: Jason Wang <jasowang@redhat.com>


