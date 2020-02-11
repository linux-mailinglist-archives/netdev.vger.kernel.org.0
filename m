Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE7B158899
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 04:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgBKDMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 22:12:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34247 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727874AbgBKDMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 22:12:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581390764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q+EmKIrsTYodqEbhl714OL2yeXOxjPittki/IV3oU/E=;
        b=Bw3P/38weRF4kZWBaULPb2UQONoUp8hrbBUXNIaAnGzjAMWFLcHPYQylBUFiMj8hCpTIFk
        0OXSOUlHl7AdfIPhPh7FUE3tNd4p6AnctJ47gYavPpINbEwwmbRSQZRdlm9ABkpwb1dAKx
        qnAfhzv0tro34QaE8P9+rlJkkqXEVx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-j-AC7TOhNd6v0QTR3XvrnQ-1; Mon, 10 Feb 2020 22:12:41 -0500
X-MC-Unique: j-AC7TOhNd6v0QTR3XvrnQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DF6A800EBB;
        Tue, 11 Feb 2020 03:12:39 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA73A89F24;
        Tue, 11 Feb 2020 03:12:20 +0000 (UTC)
Subject: Re: [PATCH V2 5/5] vdpasim: vDPA device simulator
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-6-jasowang@redhat.com>
 <20200210062219-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d738e251-d03b-c2a0-bf0a-045ea0b1871c@redhat.com>
Date:   Tue, 11 Feb 2020 11:12:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200210062219-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/10 =E4=B8=8B=E5=8D=887:23, Michael S. Tsirkin wrote:
> On Mon, Feb 10, 2020 at 11:56:08AM +0800, Jason Wang wrote:
>> This patch implements a software vDPA networking device. The datapath
>> is implemented through vringh and workqueue. The device has an on-chip
>> IOMMU which translates IOVA to PA. For kernel virtio drivers, vDPA
>> simulator driver provides dma_ops. For vhost driers, set_map() methods
>> of vdpa_config_ops is implemented to accept mappings from vhost.
>>
>> Currently, vDPA device simulator will loopback TX traffic to RX. So
>> the main use case for the device is vDPA feature testing, prototyping
>> and development.
>>
>> Note, there's no management API implemented, a vDPA device will be
>> registered once the module is probed. We need to handle this in the
>> future development.
>>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>> ---
>>   drivers/virtio/vdpa/Kconfig    |  17 +
>>   drivers/virtio/vdpa/Makefile   |   1 +
>>   drivers/virtio/vdpa/vdpa_sim.c | 678 +++++++++++++++++++++++++++++++=
++
>>   3 files changed, 696 insertions(+)
>>   create mode 100644 drivers/virtio/vdpa/vdpa_sim.c
>>
>> diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
>> index 7a99170e6c30..a7888974dda8 100644
>> --- a/drivers/virtio/vdpa/Kconfig
>> +++ b/drivers/virtio/vdpa/Kconfig
>> @@ -7,3 +7,20 @@ config VDPA
>>             datapath which complies with virtio specifications with
>>             vendor specific control path.
>>  =20
>> +menuconfig VDPA_MENU
>> +	bool "VDPA drivers"
>> +	default n
>> +
>> +if VDPA_MENU
>> +
>> +config VDPA_SIM
>> +	tristate "vDPA device simulator"
>> +        select VDPA
>> +        default n
>> +        help
>> +          vDPA networking device simulator which loop TX traffic back
>> +          to RX. This device is used for testing, prototyping and
>> +          development of vDPA.
> So how about we make this depend on RUNTIME_TESTING_MENU?
>
>

I'm not sure how much it can help but I can do that in next version.

Thanks

RUNTIME_TESTING_MENU

