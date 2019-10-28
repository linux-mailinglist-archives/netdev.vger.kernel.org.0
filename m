Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC0EE6B9F
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 04:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731536AbfJ1DwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 23:52:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20076 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728601AbfJ1DwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 23:52:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572234732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6E/VIYauZRkR+EOHGifF88F6ifejkfSEd/ycozu4oc0=;
        b=Lu3gtq98o55AAaBpAhXuvv3yho+UoByMn8psW6aYVNlLqkzKpcZrwF3Pq6T37yZoVsz/i9
        jNYW/wjFXCChcZSqRAxLzwvfZ2nTaXC/oH74LTmRARQimGr4bSHCOI+zu+vp1OgyBEz5lf
        Mky6fTV5FLksDTJq3C47KkLmkxsrGXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-uGx5hqUSPcKVVpELU8IOMQ-1; Sun, 27 Oct 2019 23:52:08 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F0765EC;
        Mon, 28 Oct 2019 03:52:07 +0000 (UTC)
Received: from [10.72.12.246] (ovpn-12-246.pek2.redhat.com [10.72.12.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD96B6012C;
        Mon, 28 Oct 2019 03:52:02 +0000 (UTC)
Subject: Re: [PATCH net-next] vringh: fix copy direction of
 vringh_iov_push_kern()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191024035718.7690-1-jasowang@redhat.com>
 <20191027060328-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f8c51ab6-d328-b574-d5c4-ed4a8cd2c3ec@redhat.com>
Date:   Mon, 28 Oct 2019 11:52:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191027060328-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: uGx5hqUSPcKVVpELU8IOMQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/27 =E4=B8=8B=E5=8D=886:04, Michael S. Tsirkin wrote:
> On Thu, Oct 24, 2019 at 11:57:18AM +0800, Jason Wang wrote:
>> We want to copy from iov to buf, so the direction was wrong.
>>
>> Note: no real user for the helper, but it will be used by future
>> features.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> I'm still inclined to merge it now, incorrect code tends to
> proliferate.


I'm fine with this, so I believe you will merge this patch?

Thanks


>
>> ---
>>   drivers/vhost/vringh.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>> index 08ad0d1f0476..a0a2d74967ef 100644
>> --- a/drivers/vhost/vringh.c
>> +++ b/drivers/vhost/vringh.c
>> @@ -852,6 +852,12 @@ static inline int xfer_kern(void *src, void *dst, s=
ize_t len)
>>   =09return 0;
>>   }
>>  =20
>> +static inline int kern_xfer(void *dst, void *src, size_t len)
>> +{
>> +=09memcpy(dst, src, len);
>> +=09return 0;
>> +}
>> +
>>   /**
>>    * vringh_init_kern - initialize a vringh for a kernelspace vring.
>>    * @vrh: the vringh to initialize.
>> @@ -958,7 +964,7 @@ EXPORT_SYMBOL(vringh_iov_pull_kern);
>>   ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
>>   =09=09=09     const void *src, size_t len)
>>   {
>> -=09return vringh_iov_xfer(wiov, (void *)src, len, xfer_kern);
>> +=09return vringh_iov_xfer(wiov, (void *)src, len, kern_xfer);
>>   }
>>   EXPORT_SYMBOL(vringh_iov_push_kern);
>>  =20
>> --=20
>> 2.19.1

