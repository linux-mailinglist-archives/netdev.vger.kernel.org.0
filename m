Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1743305FC
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 03:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhCHCwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 21:52:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231136AbhCHCwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 21:52:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615171919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kfjo+8+m1mc1N69M4/qDsvTFzx3hcR3U05A0ZBrBI6M=;
        b=fW4e8WdE1VQFDakTgZMwEZaCMOzi+I21GMOKdY4Rt2BmjQkaVMsQPHFWdakDY0I160/HFi
        xy+0gz7NyWIE4iRi6BjhKgo1GRIWmE5m48+qTLmnWSVVwuyOofIuhQ3puNUh3oclRX3ntJ
        aXlSRuIcXNWjcvxX1mgcsvItoHhW/8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-93brkqDoMwa0nhyVxoqSNA-1; Sun, 07 Mar 2021 21:51:55 -0500
X-MC-Unique: 93brkqDoMwa0nhyVxoqSNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3315780432F;
        Mon,  8 Mar 2021 02:51:54 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A49665D9D0;
        Mon,  8 Mar 2021 02:51:48 +0000 (UTC)
Subject: Re: [PATCH 1/3] vDPA/ifcvf: get_vendor_id returns a device specific
 vendor id
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210305142000.18521-1-lingshan.zhu@intel.com>
 <20210305142000.18521-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cd58ab69-0a31-a990-2ce4-4b48f1192a01@redhat.com>
Date:   Mon, 8 Mar 2021 10:51:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305142000.18521-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/5 10:19 下午, Zhu Lingshan wrote:
> In this commit, ifcvf_get_vendor_id() will return
> a device specific vendor id of the probed pci device
> than a hard code.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index fa1af301cf55..e501ee07de17 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -324,7 +324,10 @@ static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
>   
>   static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
>   {
> -	return IFCVF_SUBSYS_VENDOR_ID;
> +	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> +	struct pci_dev *pdev = adapter->pdev;
> +
> +	return pdev->subsystem_vendor;
>   }


Acked-by: Jason Wang <jasowang@redhat.com>



>   
>   static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)

