Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3679533E84D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 05:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhCQEI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 00:08:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44419 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhCQEIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 00:08:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615954084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdiveM119yE82h3FVSM3fQt9fV4OqxVZRZ4Nl+K7F/Y=;
        b=YBdW3H0SR3oBO3u6u+WpcsIFgwcW80Vcd1vh1qU++n58+Ktk4p3SRUbrBin+lZGn/flixH
        eyAvfIN+f46r1D5UsxRw8hi3gcWiVhmMYRUpwo7AgGIMUJkyDTJ/nHt/LJvZ2VGsmHcXUb
        G8BiUo0MKjaaMm1FsE1v+os2s4AXYiA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-25agm97fMqCYyxv1ABnnMQ-1; Wed, 17 Mar 2021 00:08:02 -0400
X-MC-Unique: 25agm97fMqCYyxv1ABnnMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA84487A826;
        Wed, 17 Mar 2021 04:08:00 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06E5E19706;
        Wed, 17 Mar 2021 04:07:54 +0000 (UTC)
Subject: Re: [PATCH V4 7/7] vDPA/ifcvf: deduce VIRTIO device ID from pdev ids
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
 <20210315074501.15868-8-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a873deef-81e9-9177-b297-7c7063077ff6@redhat.com>
Date:   Wed, 17 Mar 2021 12:07:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315074501.15868-8-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/3/15 下午3:45, Zhu Lingshan 写道:
>   static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
>   {
> -	return VIRTIO_ID_NET;
> +	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	u32 ret = -EOPNOTSUPP;
> +
> +	if (ifcvf_probed_virtio_net(vf))
> +		ret = VIRTIO_ID_NET;


So the point is to simplify the future extension.

How about simply?

if (device_id>0x1040)
     return devce_id - 0x1040;
else
     return device_id;

Since I don't think you plan to introduce device whose vendor id is not 
1AF4 and the subsys vendor/device id is not interesting to vDPA bus.

Thanks


> +
> +	return ret;
>   }

