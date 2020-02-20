Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87241165716
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 06:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgBTFlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 00:41:19 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35132 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgBTFlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 00:41:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582177278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V8v5166J4SbhdR4e6T70Bx8eG2hcXpRERfrbWLPrkP0=;
        b=g1nxG7ihS9hkOMh8nAoncu/rVxNBFTIya9GwdzG2uI7tgJwCul6Fdv1nJ/rFr1BROodiKD
        7ozUfvhsMW7F6XfaBIAnizSPZrd/rhX72EALkV4w0vWxfupRS6E5Pnl+AJHjI2i59NDKTo
        mrBVh1Cn3vhVfmajVQO5DJfvkDs6/Ew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110--XF2wSw1MSiPuumGVPBXeQ-1; Thu, 20 Feb 2020 00:41:16 -0500
X-MC-Unique: -XF2wSw1MSiPuumGVPBXeQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DC1618A6EC2;
        Thu, 20 Feb 2020 05:41:14 +0000 (UTC)
Received: from [10.72.12.159] (ovpn-12-159.pek2.redhat.com [10.72.12.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71A555C28E;
        Thu, 20 Feb 2020 05:40:54 +0000 (UTC)
Subject: Re: [PATCH V3 4/5] virtio: introduce a vDPA based transport
To:     Randy Dunlap <rdunlap@infradead.org>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com
References: <20200220035650.7986-1-jasowang@redhat.com>
 <20200220035650.7986-5-jasowang@redhat.com>
 <2c5a3a84-be56-3003-8d71-d46645664bab@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0f796bc9-3e27-38ae-9d7a-bf2be2a9f8ab@redhat.com>
Date:   Thu, 20 Feb 2020 13:40:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2c5a3a84-be56-3003-8d71-d46645664bab@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/20 =E4=B8=8B=E5=8D=8812:07, Randy Dunlap wrote:
> On 2/19/20 7:56 PM, Jason Wang wrote:
>> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
>> index 9c4fdb64d9ac..0df3676b0f4f 100644
>> --- a/drivers/virtio/Kconfig
>> +++ b/drivers/virtio/Kconfig
>> @@ -43,6 +43,19 @@ config VIRTIO_PCI_LEGACY
>>  =20
>>   	  If unsure, say Y.
>>  =20
>> +config VIRTIO_VDPA
>> +	tristate "vDPA driver for virtio devices"
>> +        select VDPA
>> +        select VIRTIO
>> +	help
>> +	  This driver provides support for virtio based paravirtual
>> +	  device driver over vDPA bus. For this to be useful, you need
>> +	  an appropriate vDPA device implementation that operates on a
>> +          physical device to allow the datapath of virtio to be
>> +	  offloaded to hardware.
>> +
>> +	  If unsure, say M.
>> +
> Please use tabs consistently for indentation, not spaces,
> except in the Kconfig help text, which should be 1 tab + 2 spaces.


Fixed.

Thanks


>
>>   config VIRTIO_PMEM
>>   	tristate "Support for virtio pmem driver"
>>   	depends on VIRTIO
>

