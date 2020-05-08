Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E401CA060
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgEHB4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:56:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36851 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726509AbgEHB4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588903009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JT05FM/qFjOhlzVbidfMllXSBmmMs5hu8jLgUO53t7w=;
        b=XcCGcoifhYmUdgA3GzlVGIVDUI672LJU4ks5eDxO7wKSRJAMmwBRfUAqcY/xYaBweMNO9j
        UXOHG+tbO43vkEg+OdFGVqHktJR95cHcLU3LPD+KaLGMM9DOPmU+OGaw2HS5TjOUmdFMSX
        4bQFlmj+/41MlXg+IOtH0Dov7Zb1O7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-MdXXWQgiPJ-p7NVrRQ1dJg-1; Thu, 07 May 2020 21:56:47 -0400
X-MC-Unique: MdXXWQgiPJ-p7NVrRQ1dJg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AFB5107ACCA;
        Fri,  8 May 2020 01:56:46 +0000 (UTC)
Received: from [10.72.13.98] (ovpn-13-98.pek2.redhat.com [10.72.13.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D48125C1B0;
        Fri,  8 May 2020 01:56:39 +0000 (UTC)
Subject: Re: [PATCH net-next 1/2] virtio-net: don't reserve space for vnet
 header for XDP
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20200506061633.16327-1-jasowang@redhat.com>
 <20200506033834-mutt-send-email-mst@kernel.org>
 <7a169b06-b6b9-eac1-f03a-39dd1cfcce57@redhat.com>
 <20200506055436-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c1df2cdf-eaff-f146-1804-f0a6cad6bb2d@redhat.com>
Date:   Fri, 8 May 2020 09:56:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506055436-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 下午5:54, Michael S. Tsirkin wrote:
> On Wed, May 06, 2020 at 04:19:40PM +0800, Jason Wang wrote:
>> On 2020/5/6 下午3:53, Michael S. Tsirkin wrote:
>>> On Wed, May 06, 2020 at 02:16:32PM +0800, Jason Wang wrote:
>>>> We tried to reserve space for vnet header before
>>>> xdp.data_hard_start. But this is useless since the packet could be
>>>> modified by XDP which may invalidate the information stored in the
>>>> header and there's no way for XDP to know the existence of the vnet
>>>> header currently.
>>> What do you mean? Doesn't XDP_PASS use the header in the buffer?
>> We don't, see 436c9453a1ac0 ("virtio-net: keep vnet header zeroed after
>> processing XDP")
>>
>> If there's other place, it should be a bug.
>>
>>
>>>> So let's just not reserve space for vnet header in this case.
>>> In any case, we can find out XDP does head adjustments
>>> if we need to.
>> But XDP program can modify the packets without adjusting headers.
>>
>> Thanks
> Then what's the problem?


Then we can't do anything more than just invalidating vnet header since 
we don't know whether or not the packet has been modified or not.

Technically, XDP can give the driver some hint about whether or not the 
packet has been modified, but AFAIK we haven't implemented this yet.

Thanks


>

