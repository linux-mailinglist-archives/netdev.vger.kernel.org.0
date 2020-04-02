Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C18F19C545
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 17:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389191AbgDBPAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 11:00:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59852 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388782AbgDBPAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 11:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585839599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cCmqKOlQ5uNMhi/s9okkTSfSwLDfmuDXSmQS/oyntI=;
        b=XZ4ktAZHjBMh4pDgQuhnvJNurx/bYkh5smAd4v8GqFAiEVOx2BIU30ig3OuvsNMU0K9Caw
        3lEJugkGAuIqZuM5BadIjiKQwdRdNTPFgNyqATMGS3BMRzd27VSHrpJJO3JQVhq7GQ9Xo5
        2rMX4e6T16UESpVcO1eF1vSuBKOz7MU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-sp5wDE-tO5aRyuQXauUcsg-1; Thu, 02 Apr 2020 10:59:56 -0400
X-MC-Unique: sp5wDE-tO5aRyuQXauUcsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BEEB18A6EC8;
        Thu,  2 Apr 2020 14:59:55 +0000 (UTC)
Received: from [10.72.12.172] (ovpn-12-172.pek2.redhat.com [10.72.12.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4F8F1001925;
        Thu,  2 Apr 2020 14:59:50 +0000 (UTC)
Subject: Re: [PATCH] vhost: drop vring dependency on iotlb
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200402141207.32628-1-mst@redhat.com>
 <afe230b9-708f-02a1-c3af-51e9d4fdd212@redhat.com>
 <20200402103551-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4ba378d7-ce02-a085-dbd7-0c1cbe2d5bab@redhat.com>
Date:   Thu, 2 Apr 2020 22:59:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200402103551-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/2 =E4=B8=8B=E5=8D=8810:36, Michael S. Tsirkin wrote:
> On Thu, Apr 02, 2020 at 10:28:28PM +0800, Jason Wang wrote:
>> On 2020/4/2 =E4=B8=8B=E5=8D=8810:12, Michael S. Tsirkin wrote:
>>> vringh can now be built without IOTLB.
>>> Select IOTLB directly where it's used.
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>>
>>> This is on top of my previous patch (in vhost tree now).
>>>
>>>    drivers/vdpa/Kconfig  | 1 +
>>>    drivers/vhost/Kconfig | 1 -
>>>    2 files changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
>>> index 7db1460104b7..08b615f2da39 100644
>>> --- a/drivers/vdpa/Kconfig
>>> +++ b/drivers/vdpa/Kconfig
>>> @@ -17,6 +17,7 @@ config VDPA_SIM
>>>    	depends on RUNTIME_TESTING_MENU
>>>    	select VDPA
>>>    	select VHOST_RING
>>> +	select VHOST_IOTLB
>>>    	default n
>>>    	help
>>>    	  vDPA networking device simulator which loop TX traffic back
>>> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
>>> index 21feea0d69c9..bdd270fede26 100644
>>> --- a/drivers/vhost/Kconfig
>>> +++ b/drivers/vhost/Kconfig
>>> @@ -6,7 +6,6 @@ config VHOST_IOTLB
>>>    config VHOST_RING
>>>    	tristate
>>> -	select VHOST_IOTLB
>>>    	help
>>>    	  This option is selected by any driver which needs to access
>>>    	  the host side of a virtio ring.
>>
>> Do we need to mention driver need to select VHOST_IOTLB by itself here=
?
>>
>> Thanks
>>
> OK but I guess it's best to do it near where VHOST_IOTLB is defined.
> Like this?
>
>
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index bdd270fede26..ce51126f51e7 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -3,6 +3,8 @@ config VHOST_IOTLB
>   	tristate
>   	help
>   	  Generic IOTLB implementation for vhost and vringh.
> +	  This option is selected by any driver which needs to support
> +	  an IOMMU in software.
>  =20
>   config VHOST_RING
>   	tristate
>

Yes, probably.

Thanks


