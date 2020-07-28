Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6C2230456
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgG1Hmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:42:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42130 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727861AbgG1Hmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 03:42:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595922151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZtbfdviuzmJuORt1hYZ3533gUnFhPHnrFXSr+c808HM=;
        b=CbvmwhrF0aiIuwdNJVoyDbcqPEuPzWU0tV3Dt6W2eCsIy6LBjqQDN4CVUYEp/6yq9brz3F
        Q7EQIVreB3u2EcK/SGtI+iFBPhu/TrrQvBq51ljRpOhwNo1YZ/tShf7F4Vjh9R1dddmWdf
        8zNrTyWsJsVg5bgNEehCNQBtUt484K4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-bpRnA74JNyuGR9WtoRE1iw-1; Tue, 28 Jul 2020 03:42:28 -0400
X-MC-Unique: bpRnA74JNyuGR9WtoRE1iw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21446100960F;
        Tue, 28 Jul 2020 07:42:27 +0000 (UTC)
Received: from [10.72.13.242] (ovpn-13-242.pek2.redhat.com [10.72.13.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE395712C2;
        Tue, 28 Jul 2020 07:42:22 +0000 (UTC)
Subject: Re: [PATCH V4 3/6] vDPA: add get_vq_irq() in vdpa_config_ops
To:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
 <20200728042405.17579-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <110786e5-4b0c-f745-a038-174f2d45cf6a@redhat.com>
Date:   Tue, 28 Jul 2020 15:42:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728042405.17579-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/28 下午12:24, Zhu Lingshan wrote:
> This commit adds a new function get_vq_irq() in struct
> vdpa_config_ops, which will return the irq number of a
> virtqueue.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>   include/linux/vdpa.h | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 239db794357c..cebc79173aaa 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -87,6 +87,11 @@ struct vdpa_device {
>    *				@vdev: vdpa device
>    *				@idx: virtqueue index
>    *				Returns the notifcation area
> + * @get_vq_irq:			Get the irq number of a virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				Returns u32: irq number of a virtqueue,
> + *				-EINVAL if no irq assigned.


I think we can not get -EINVAL since the function will return a u32.

Thanks


>    * @get_vq_align:		Get the virtqueue align requirement
>    *				for the device
>    *				@vdev: vdpa device
> @@ -178,6 +183,7 @@ struct vdpa_config_ops {
>   	u64 (*get_vq_state)(struct vdpa_device *vdev, u16 idx);
>   	struct vdpa_notification_area
>   	(*get_vq_notification)(struct vdpa_device *vdev, u16 idx);
> +	u32 (*get_vq_irq)(struct vdpa_device *vdv, u16 idx);
>   
>   	/* Device ops */
>   	u32 (*get_vq_align)(struct vdpa_device *vdev);

