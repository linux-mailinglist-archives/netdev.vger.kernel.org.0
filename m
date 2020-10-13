Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C3328C852
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 07:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732500AbgJMFlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 01:41:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732482AbgJMFlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 01:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602567663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=an1gCRpqueGjFmWqkLo6oeT53oDVqi18CPdvDvMunMk=;
        b=X3ve+OGg2MPMo+vkoCD/dib5jC633PZUlK3NfQEkMV1ZQhCZsGjDy9gTxzTd42CK4MUt7f
        +6EbGbEofCfwBS3LBGmiQ7cYqrEeGGAa29tv5vWcA7rduYDh56cAV6S3fQvMXgIBqS/46g
        ZwBK3p89bj4z9RsAg1rwtO41Erb+Kxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-wFv5dTD3NV6L4xTTMKvdjg-1; Tue, 13 Oct 2020 01:41:01 -0400
X-MC-Unique: wFv5dTD3NV6L4xTTMKvdjg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E71C21018F63;
        Tue, 13 Oct 2020 05:40:59 +0000 (UTC)
Received: from [10.72.13.59] (ovpn-13-59.pek2.redhat.com [10.72.13.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B11261A92A;
        Tue, 13 Oct 2020 05:40:45 +0000 (UTC)
Subject: Re: [RFC PATCH 10/24] vdpa: introduce config operations for
 associating ASID to a virtqueue group
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-11-jasowang@redhat.com>
 <20201001132927.GC32363@mtl-vdi-166.wap.labs.mlnx>
 <70af3ff0-74ed-e519-56f5-d61e6a48767f@redhat.com>
 <20201012065931.GA42327@mtl-vdi-166.wap.labs.mlnx>
 <b1ac150b-0845-874f-75d0-7440133a1d41@redhat.com>
 <20201012081725.GB42327@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3e4a8bea-f187-3843-c1d1-75d0b86a137b@redhat.com>
Date:   Tue, 13 Oct 2020 13:40:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012081725.GB42327@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/12 下午4:17, Eli Cohen wrote:
> On Mon, Oct 12, 2020 at 03:45:10PM +0800, Jason Wang wrote:
>>> So in theory we can have several asid's (for different virtqueues), each
>>> one should be followed by a specific set_map call. If this is so, how do
>>> I know if I met all the conditions run my driver? Maybe we need another
>>> callback to let the driver know it should not expect more set_maps().
>>
>> This should work similarly as in the past. Two parts of the work is expected
>> to be done by the driver:
>>
>> 1) store the mapping somewhere (e.g hardware) during set_map()
>> 2) associating mapping with a specific virtqueue
>>
>> The only difference is that more than one mapping is used now.
> ok, so like today, I will always get DRIVER_OK after I got all the
> set_maps(), right?


Yes.

Thanks


>
>> For the issue of more set_maps(), driver should be always ready for the new
>> set_maps() call instead of not expecting new set_maps() since guest memory
>> topology could be changed due to several reasons.
>>
>> Qemu or vhost-vDPA will try their best to avoid the frequency of set_maps()
>> for better performance (e.g through batched IOTLB updating). E.g there
>> should be at most one set_map() during one time of guest booting.
>>
>>

