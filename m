Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA4F336A94
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhCKDVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:21:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231157AbhCKDUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:20:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615432831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P09mB4c+K2vA0WOzF718rEjH0GsJKBr1s72NBk2MRHg=;
        b=hLJB0AwYs+O+1got2rqL4qGrbKnoAmFadmBhiU1RnKDRabzwFQRtEYnpAI1XlQKjVcs4rb
        l01m9Vbwbr9sHTPK32aC/8q/AMWvS3NLP0QkecJ8PUuqMVXygP1yCz/VbEc8Q6p2tXDTsp
        p9k+U5hNDTM3gluVvXILUnXRwvFSvSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-VPLtTuS8NzqooVXMHlP4zw-1; Wed, 10 Mar 2021 22:20:27 -0500
X-MC-Unique: VPLtTuS8NzqooVXMHlP4zw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 097C619200C1;
        Thu, 11 Mar 2021 03:20:26 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 490795D746;
        Thu, 11 Mar 2021 03:20:20 +0000 (UTC)
Subject: Re: [PATCH V3 6/6] vDPA/ifcvf: verify mandatory feature bits for vDPA
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-7-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3e53a5c9-c531-48ee-c9a7-907dfdacc9d1@redhat.com>
Date:   Thu, 11 Mar 2021 11:20:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210310090052.4762-7-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
> vDPA requres VIRTIO_F_ACCESS_PLATFORM as a must, this commit
> examines this when set features.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c | 8 ++++++++
>   drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
>   3 files changed, 14 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index ea6a78791c9b..58f47fdce385 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -224,6 +224,14 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
>   	return hw->hw_features;
>   }
>   
> +int ifcvf_verify_min_features(struct ifcvf_hw *hw)
> +{
> +	if (!(hw->hw_features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>   void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
>   			   void *dst, int length)
>   {
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index dbb8c10aa3b1..91c5735d4dc9 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -123,6 +123,7 @@ void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
>   void ifcvf_reset(struct ifcvf_hw *hw);
>   u64 ifcvf_get_features(struct ifcvf_hw *hw);
>   u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
> +int ifcvf_verify_min_features(struct ifcvf_hw *hw);
>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 25fb9dfe23f0..f624f202447d 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -179,6 +179,11 @@ static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
>   static int ifcvf_vdpa_set_features(struct vdpa_device *vdpa_dev, u64 features)
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	int ret;
> +
> +	ret = ifcvf_verify_min_features(vf);


So this validate device features instead of driver which is the one we 
really want to check?

Thanks


> +	if (ret)
> +		return ret;
>   
>   	vf->req_features = features;
>   

