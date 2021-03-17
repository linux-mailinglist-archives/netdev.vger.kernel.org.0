Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A3F33E831
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 05:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhCQD7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 23:59:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231157AbhCQD7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 23:59:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615953549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ndZ/EPGx75V6OcMRIv9fS1gIYZrKaTsBexZg2LyBVk=;
        b=hqI13kmO66VBuFF8MqpTHqNtTisSlK7SSH8lQMEN5utDjWuNAC/LQ/m0Ok00R/V5sh/bFe
        5E15bT/tlYAy9DiDl+XLANX8JpIN45AKt0VhTvkIfG7aHwbiULui2FGI793A7uo5lEEugN
        ZAkU4XBHerEgUoDuTbsmnjyVf7Nz91s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-clyX9_PcOj2OvZ5sHHJCgg-1; Tue, 16 Mar 2021 23:59:05 -0400
X-MC-Unique: clyX9_PcOj2OvZ5sHHJCgg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9B2F363A1;
        Wed, 17 Mar 2021 03:59:03 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E32CC19706;
        Wed, 17 Mar 2021 03:58:57 +0000 (UTC)
Subject: Re: [PATCH V4 6/7] vDPA/ifcvf: verify mandatory feature bits for vDPA
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
 <20210315074501.15868-7-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3188205d-250f-8dfe-c271-50be5c1e2e58@redhat.com>
Date:   Wed, 17 Mar 2021 11:58:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315074501.15868-7-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/15 ÏÂÎç3:45, Zhu Lingshan Ð´µÀ:
> vDPA requres VIRTIO_F_ACCESS_PLATFORM as a must, this commit
> examines this when set features.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++++
>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>   drivers/vdpa/ifcvf/ifcvf_main.c |  5 +++++
>   3 files changed, 18 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index ea6a78791c9b..4f257c4b2f76 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -224,6 +224,18 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
>   	return hw->hw_features;
>   }
>   
> +int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
> +{
> +	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
> +
> +	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)) && features) {
> +		IFCVF_ERR(ifcvf->pdev, "VIRTIO_F_ACCESS_PLATFORM not negotiated\n");


Should be "is not negotiated".

Otherwise:

Acked-by: Jason Wang <jasowang@redhat.com>


> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>   void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
>   			   void *dst, int length)
>   {
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index dbb8c10aa3b1..f77239fc1644 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -123,6 +123,7 @@ void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
>   void ifcvf_reset(struct ifcvf_hw *hw);
>   u64 ifcvf_get_features(struct ifcvf_hw *hw);
>   u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
> +int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 25fb9dfe23f0..ea93ea7fd5df 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -179,6 +179,11 @@ static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
>   static int ifcvf_vdpa_set_features(struct vdpa_device *vdpa_dev, u64 features)
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	int ret;
> +
> +	ret = ifcvf_verify_min_features(vf, features);
> +	if (ret)
> +		return ret;
>   
>   	vf->req_features = features;
>   

