Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34EE16570D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 06:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgBTFkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 00:40:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28962 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725857AbgBTFkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 00:40:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582177206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J9NrFI8gvvH8gN3m+EAbf89V4rNzqsdM3V845EEW2jg=;
        b=ODbEDpu8QEZBcClQD0IIPXeh+GaBZn0ZuJxOv2tNbg0QkQIrVMyCCisR1HJOuaTHfWWVH7
        T6z5zLc7kVNg11i2FAUr7BmiA5wujfcNqSBL/zQjQq5mIs5Zs0S6X+J/U6DcmlHJtPqPfz
        Qs/FXRBGvTxJeS4rw4nM6zQaBHPBApI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-OnCytqH4M4yaDNXjpZfCEA-1; Thu, 20 Feb 2020 00:40:04 -0500
X-MC-Unique: OnCytqH4M4yaDNXjpZfCEA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B286DB23;
        Thu, 20 Feb 2020 05:40:01 +0000 (UTC)
Received: from [10.72.12.159] (ovpn-12-159.pek2.redhat.com [10.72.12.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87A229077C;
        Thu, 20 Feb 2020 05:39:41 +0000 (UTC)
Subject: Re: [PATCH V3 1/5] vhost: factor out IOTLB
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
 <20200220035650.7986-2-jasowang@redhat.com>
 <61d64892-ce77-3e86-acb8-a49679fc0047@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b348cb04-3b5b-1a11-a4c5-4b05d31e88c0@redhat.com>
Date:   Thu, 20 Feb 2020 13:39:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <61d64892-ce77-3e86-acb8-a49679fc0047@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/20 =E4=B8=8B=E5=8D=8812:04, Randy Dunlap wrote:
> On 2/19/20 7:56 PM, Jason Wang wrote:
>> This patch factors out IOTLB into a dedicated module in order to be
>> reused by other modules like vringh. User may choose to enable the
>> automatic retiring by specifying VHOST_IOTLB_FLAG_RETIRE flag to fit
>> for the case of vhost device IOTLB implementation.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   MAINTAINERS                 |   1 +
>>   drivers/vhost/Kconfig       |   7 ++
>>   drivers/vhost/Makefile      |   2 +
>>   drivers/vhost/net.c         |   2 +-
>>   drivers/vhost/vhost.c       | 221 +++++++++++-----------------------=
--
>>   drivers/vhost/vhost.h       |  36 ++----
>>   drivers/vhost/vhost_iotlb.c | 171 ++++++++++++++++++++++++++++
>>   include/linux/vhost_iotlb.h |  45 ++++++++
>>   8 files changed, 304 insertions(+), 181 deletions(-)
>>   create mode 100644 drivers/vhost/vhost_iotlb.c
>>   create mode 100644 include/linux/vhost_iotlb.h
>>
> Hi,
> Sorry if you have gone over this previously:


Thanks for the review, it's really helpful.


>
>> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
>> index 3d03ccbd1adc..eef634ff9a6e 100644
>> --- a/drivers/vhost/Kconfig
>> +++ b/drivers/vhost/Kconfig
>> @@ -36,6 +36,7 @@ config VHOST_VSOCK
>>  =20
>>   config VHOST
>>   	tristate
>> +	select VHOST_IOTLB
>>   	---help---
>>   	  This option is selected by any driver which needs to access
>>   	  the core of vhost.
>> @@ -54,3 +55,9 @@ config VHOST_CROSS_ENDIAN_LEGACY
>>   	  adds some overhead, it is disabled by default.
>>  =20
>>   	  If unsure, say "N".
>> +
>> +config VHOST_IOTLB
>> +	tristate
>> +	default m
> "default m" should not be needed. Just make whatever needs it select it=
.


Yes, will fix.

Thanks


>
>> +	help
>> +	  Generic IOTLB implementation for vhost and vringh.
>

