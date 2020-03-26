Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53931193825
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgCZFwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:52:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:58617 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbgCZFwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 01:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585201925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nHSCTCOpueCpiOWznPRR+Xn/UI1HYzEARRPs1NvUwTk=;
        b=BPq/fVQd7hFlrh7J3PImINEcj6DIynvs81RwDTjals9U4xHi5PfvWpQo0QX4nhrk/Xv62y
        T4NmdpWYpVytAlUxsDbcNvsF24wJR0jpTD6d2ZeYx1fAkjPfNByw1ZFh53P34ktBPdhIjx
        q8JsoME61fYA+mSAingPA1jbr7YegFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-3eHxDwQyNnWQi176UfAy4A-1; Thu, 26 Mar 2020 01:52:01 -0400
X-MC-Unique: 3eHxDwQyNnWQi176UfAy4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAF121005510;
        Thu, 26 Mar 2020 05:51:58 +0000 (UTC)
Received: from [10.72.13.193] (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 149D2A0A87;
        Thu, 26 Mar 2020 05:51:42 +0000 (UTC)
Subject: Re: [PATCH V8 5/9] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com
References: <20200325082711.1107-1-jasowang@redhat.com>
 <20200325082711.1107-6-jasowang@redhat.com>
 <20200325122949.GW13183@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a1474a55-7525-7c3e-a806-e3f53850a590@redhat.com>
Date:   Thu, 26 Mar 2020 13:51:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200325122949.GW13183@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/25 =E4=B8=8B=E5=8D=888:29, Jason Gunthorpe wrote:
> On Wed, Mar 25, 2020 at 04:27:07PM +0800, Jason Wang wrote:
>> +struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>> +					const struct vdpa_config_ops *config,
>> +					size_t size);
>> +
>> +#define vdpa_alloc_device(dev_struct, member, parent, config)   \
>> +			  container_of(__vdpa_alloc_device( \
>> +				       parent, config, \
>> +				       sizeof(struct dev_struct) + \
>> +				       BUILD_BUG_ON_ZERO(offsetof( \
>> +				       struct dev_struct, member))), \
>> +				       struct dev_struct, member)
> This all looks robust now, one minor remark is to not do 'struct
> dev_struct' here so the caller has to do
>
>     vdpa_alloc_device(struct foo, vpda, ...)
>
> Which suggests to the reader something unusual is happening
>
> Jason


Yes, that's better.

But my understanding is that this can be done on top.

Thanks

