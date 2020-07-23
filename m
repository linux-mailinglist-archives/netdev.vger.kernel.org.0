Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DE522A66E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 06:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgGWET6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 00:19:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47613 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725814AbgGWET6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 00:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595477996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9eSYwQ7URF4XR6sMcM6IEzD2UsZRflT6r9H22UCBNEQ=;
        b=dfcLUEjaktseRNlzl2MPIiypl4neyV/IDLxlZ7ejl5bueu0jKxT7wvsnYQjbdUDCa9Qi5e
        /AQO78wwoL1+38V2asEfYYTRoea7vrLt6J3mh1qEOs+9+r2mRRXundQbQcv0yBKKvj3r9R
        8h3qhPLGR/b2NeQu7crA3L3viXg8Q4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-1rwufoNOPpqTclCp-AlzPA-1; Thu, 23 Jul 2020 00:19:53 -0400
X-MC-Unique: 1rwufoNOPpqTclCp-AlzPA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69FF8800464;
        Thu, 23 Jul 2020 04:19:52 +0000 (UTC)
Received: from [10.72.13.141] (ovpn-13-141.pek2.redhat.com [10.72.13.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2ABB71D25;
        Thu, 23 Jul 2020 04:19:43 +0000 (UTC)
Subject: Re: [PATCH V3 3/6] vDPA: implement vq IRQ allocate/free helpers in
 vDPA core
To:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200722100859.221669-1-lingshan.zhu@intel.com>
 <20200722100859.221669-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a3c05c65-74bf-6250-5f4a-3b6cf60f4474@redhat.com>
Date:   Thu, 23 Jul 2020 12:19:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722100859.221669-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/22 下午6:08, Zhu Lingshan wrote:
> +/*
> + * Request irq for a vq, setup irq offloading if its a vhost_vdpa vq.
> + * This function should be only called through setting virtio DRIVER_OK.
> + * If you want to request irq during probe, you should use raw APIs
> + * like request_irq() or devm_request_irq().


This makes the API less flexibile. The reason is we store the irq in 
vhost-vdpa not vDPA.

I wonder whether the following looks better:

1) store irq in vdpa device
2) register producer when DRIVER_OK and unregister producer when 
!DRIVER_OK in vhost-vDPA
3) deal with the synchronization with SET_VRING_CALL
4) document that irq is not expected to be changed during DRIVER_OK

This can make sure the API works during driver probe, and we don't need 
the setup_irq and unsetup_irq method in vdpa_driver

Thanks


> + */
> +int vdpa_devm_request_irq(struct device *dev, struct vdpa_device *vdev,
> +			  unsigned int irq, irq_handler_t handler,
> +			  unsigned long irqflags, const char *devname, void *dev_id,
> +			  int qid)
> +{
> +	int ret;
> +
> +	ret = devm_request_irq(dev, irq, handler, irqflags, devname, dev_id);
> +	if (ret)
> +		dev_err(dev, "Failed to request irq for vq %d\n", qid);
> +	else
> +		vdpa_setup_irq(vdev, qid, irq);
> +
> +	return ret;
> +
> +}
> +EXPORT_SYMBOL_GPL(vdpa_devm_request_irq);

