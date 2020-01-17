Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E951E14061C
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 10:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbgAQJe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 04:34:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31404 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726778AbgAQJe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 04:34:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579253668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zImW82m1PTihmZyDGaiVEDwS5NVR+NMTox5Q4NiymVk=;
        b=FguwRF6P3KDgLdObYJA1nLkj5xCJBp+gVGeZusCzufIV4mc7f3Ezaksn+in5zFh9xfGAk8
        iefXnFmxtS5JoExv32b3/vEEZMuzGbs4WR7W+t8n7s0zXsvaU375LTqjqMCq8BW4s7cJJn
        C8QZvWF/SXCe5ArRKF0Ztg749Wq/ThI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-Tiljfj8BNmWS7qs6djDupQ-1; Fri, 17 Jan 2020 04:34:27 -0500
X-MC-Unique: Tiljfj8BNmWS7qs6djDupQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC844800D48;
        Fri, 17 Jan 2020 09:34:24 +0000 (UTC)
Received: from [10.72.12.168] (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18BBB5D9CD;
        Fri, 17 Jan 2020 09:34:07 +0000 (UTC)
Subject: Re: [PATCH 1/5] vhost: factor out IOTLB
To:     Randy Dunlap <rdunlap@infradead.org>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, hch@infradead.org,
        aadam@redhat.com, jakub.kicinski@netronome.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-2-jasowang@redhat.com>
 <4a577560-d42a-eed2-97a0-42d2f91495e2@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <38b62ebe-9b9d-612b-acd3-0cbe4ae34db9@redhat.com>
Date:   Fri, 17 Jan 2020 17:34:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4a577560-d42a-eed2-97a0-42d2f91495e2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/17 =E4=B8=8B=E5=8D=8812:14, Randy Dunlap wrote:
> On 1/16/20 4:42 AM, Jason Wang wrote:
>> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
>> index 3d03ccbd1adc..f21c45aa5e07 100644
>> --- a/drivers/vhost/Kconfig
>> +++ b/drivers/vhost/Kconfig
>> @@ -36,6 +36,7 @@ config VHOST_VSOCK
>>  =20
>>   config VHOST
>>   	tristate
>> +        depends on VHOST_IOTLB
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
>> +        default m
>> +        help
>> +          Generic IOTLB implementation for vhost and vringh.
> Use tab + 2 spaces for Kconfig indentation.


Will fix.

I wonder why checkpath doesn't complain about this :)

Thanks


>

