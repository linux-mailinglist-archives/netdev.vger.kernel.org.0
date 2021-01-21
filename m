Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0EC2FE65D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbhAUJaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:30:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728186AbhAUJCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:02:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611219642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+1P7b60HaR2MAzWv8XFsDjrssAyoeWJipGT+zaJVmE=;
        b=HrJlr1We2seEnW/W2i+pGAIeu+jluKCwj61fVoB8eo/ghP18y14KsV5JqnNsLclFRcDeRt
        sQ4Jt93D9yugumMp/8TMKfD8stt3saEMFn33nBlQTlzASxJRRdkieY0/fWsP997n/7UEzc
        p53Ax5hTcHxxqNeR3NiSozN+q/PcsDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-jDmMz9WnOKKAMlu3hfLq8w-1; Thu, 21 Jan 2021 04:00:39 -0500
X-MC-Unique: jDmMz9WnOKKAMlu3hfLq8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DA241005D4E;
        Thu, 21 Jan 2021 09:00:38 +0000 (UTC)
Received: from [10.72.13.67] (ovpn-13-67.pek2.redhat.com [10.72.13.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7D0819C46;
        Thu, 21 Jan 2021 09:00:26 +0000 (UTC)
Subject: Re: [PATCH 1/1] vhost scsi: allocate vhost_scsi with GFP_NOWAIT to
 avoid delay
To:     Dongli Zhang <dongli.zhang@oracle.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, joe.jin@oracle.com,
        aruna.ramakrishna@oracle.com
References: <20210121050328.7891-1-dongli.zhang@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3aa5c6ca-abd3-13c4-b6a6-504f3a52bae7@redhat.com>
Date:   Thu, 21 Jan 2021 17:00:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121050328.7891-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/21 13:03, Dongli Zhang wrote:
> The size of 'struct vhost_scsi' is order-10 (~2.3MB). It may take long time
> delay by kzalloc() to compact memory pages when there is a lack of
> high-order pages. As a result, there is latency to create a VM (with
> vhost-scsi) or to hotadd vhost-scsi-based storage.
>
> The prior commit 595cb754983d ("vhost/scsi: use vmalloc for order-10
> allocation") prefers to fallback only when really needed, while this patch
> changes allocation to GFP_NOWAIT in order to avoid the delay caused by
> memory page compact.
>
> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Another option is to rework by reducing the size of 'struct vhost_scsi',
> e.g., by replacing inline vhost_scsi.vqs with just memory pointers while
> each vhost_scsi.vqs[i] should be allocated separately. Please let me
> know if that option is better.
>
>   drivers/vhost/scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 4ce9f00ae10e..85eaa4e883f4 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1814,7 +1814,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
>   	struct vhost_virtqueue **vqs;
>   	int r = -ENOMEM, i;
>   
> -	vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
> +	vs = kzalloc(sizeof(*vs), GFP_NOWAIT | __GFP_NOWARN);
>   	if (!vs) {
>   		vs = vzalloc(sizeof(*vs));
>   		if (!vs)


Can we use kvzalloc?

Thanks


