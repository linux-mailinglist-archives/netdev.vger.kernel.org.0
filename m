Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF553020B2
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 04:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbhAYDN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 22:13:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbhAYDNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 22:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611544341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wyqsE2ie42MN4KyFAEL6ikQv7mdclBjRKNwb4r3BNqA=;
        b=dYUOUxvz0cFoKfEzH0+vwQPLEwtQkyACKqdJTxXxnGvNCzqwxyVeDOxWgi9WiOakuogvGi
        ZalrzYYfOARCYvwJPuMx9vxMQEcgqmbPUHUpEssF/3qItslnWVBHQhPuqBF5WMUS6Tovzz
        hP5pIwslMOgImOT+Zqel9VliwM4ZMjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-HswSJKU1PvukQT_eyiencA-1; Sun, 24 Jan 2021 22:12:19 -0500
X-MC-Unique: HswSJKU1PvukQT_eyiencA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDF3E803623;
        Mon, 25 Jan 2021 03:12:17 +0000 (UTC)
Received: from [10.72.12.105] (ovpn-12-105.pek2.redhat.com [10.72.12.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7AD86F984;
        Mon, 25 Jan 2021 03:12:08 +0000 (UTC)
Subject: Re: [PATCH v2 1/1] vhost scsi: alloc vhost_scsi with kvzalloc() to
 avoid delay
To:     Dongli Zhang <dongli.zhang@oracle.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, joe.jin@oracle.com,
        aruna.ramakrishna@oracle.com
References: <20210123080853.4214-1-dongli.zhang@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <61ed58d6-052b-9065-361d-dc6010fc91ef@redhat.com>
Date:   Mon, 25 Jan 2021 11:12:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210123080853.4214-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/23 下午4:08, Dongli Zhang wrote:
> The size of 'struct vhost_scsi' is order-10 (~2.3MB). It may take long time
> delay by kzalloc() to compact memory pages by retrying multiple times when
> there is a lack of high-order pages. As a result, there is latency to
> create a VM (with vhost-scsi) or to hotadd vhost-scsi-based storage.
>
> The prior commit 595cb754983d ("vhost/scsi: use vmalloc for order-10
> allocation") prefers to fallback only when really needed, while this patch
> allocates with kvzalloc() with __GFP_NORETRY implicitly set to avoid
> retrying memory pages compact for multiple times.
>
> The __GFP_NORETRY is implicitly set if the size to allocate is more than
> PAGE_SZIE and when __GFP_RETRY_MAYFAIL is not explicitly set.
>
> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>    - To combine kzalloc() and vzalloc() as kvzalloc()
>      (suggested by Jason Wang)
>
>   drivers/vhost/scsi.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 4ce9f00ae10e..5de21ad4bd05 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1814,12 +1814,9 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
>   	struct vhost_virtqueue **vqs;
>   	int r = -ENOMEM, i;
>   
> -	vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
> -	if (!vs) {
> -		vs = vzalloc(sizeof(*vs));
> -		if (!vs)
> -			goto err_vs;
> -	}
> +	vs = kvzalloc(sizeof(*vs), GFP_KERNEL);
> +	if (!vs)
> +		goto err_vs;
>   
>   	vqs = kmalloc_array(VHOST_SCSI_MAX_VQ, sizeof(*vqs), GFP_KERNEL);
>   	if (!vqs)


Acked-by: Jason Wang <jasowang@redhat.com>



