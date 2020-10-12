Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CCF28AF70
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgJLHpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:45:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726662AbgJLHpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602488732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QdZ3onrXxBOiI/yO33udyhWQa6oD4WfuDiVTG0nr5Kw=;
        b=bq4YDkbHm3y1Qp09+GqshjACwXHMZyNPSxwItiaRw+PGs8RZwooPUYyrmW7PNOLETeuMH7
        rjAt4qJAte257139s1c0Of8djUp4TP+4OKgk7zDOzygNtP4uhku5l27dowL9HEtSMswnHW
        9FyV4gAnFRb8eg4JoEe5XG3+SgaOe4Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-sMCUXiNeM6evZkrVbhjnyw-1; Mon, 12 Oct 2020 03:45:28 -0400
X-MC-Unique: sMCUXiNeM6evZkrVbhjnyw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD17F108E1C2;
        Mon, 12 Oct 2020 07:45:26 +0000 (UTC)
Received: from [10.72.13.74] (ovpn-13-74.pek2.redhat.com [10.72.13.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8453F10023A7;
        Mon, 12 Oct 2020 07:45:12 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b1ac150b-0845-874f-75d0-7440133a1d41@redhat.com>
Date:   Mon, 12 Oct 2020 15:45:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012065931.GA42327@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/12 下午2:59, Eli Cohen wrote:
> On Fri, Oct 09, 2020 at 11:56:45AM +0800, Jason Wang wrote:
>> On 2020/10/1 下午9:29, Eli Cohen wrote:
>>> On Thu, Sep 24, 2020 at 11:21:11AM +0800, Jason Wang wrote:
>>>> This patch introduces a new bus operation to allow the vDPA bus driver
>>>> to associate an ASID to a virtqueue group.
>>>>
>>> So in case of virtio_net, I would expect that all the data virtqueues
>>> will be associated with the same address space identifier.
>>
>> Right.
>>
>> I will add the codes to do this in the next version. It should be more
>> explicit than have this assumption by default.
>>
>>
>>> Moreover,
>>> this assignment should be provided before the set_map call that provides
>>> the iotlb for the address space, correct?
>>
>> I think it's better not have this limitation, note that set_map() now takes
>> a asid argument.
>>
>> So for hardware if the associated as is changed, the driver needs to program
>> the hardware to switch to the new mapping.
>>
>> Does this work for mlx5?
>>
> So in theory we can have several asid's (for different virtqueues), each
> one should be followed by a specific set_map call. If this is so, how do
> I know if I met all the conditions run my driver? Maybe we need another
> callback to let the driver know it should not expect more set_maps().


This should work similarly as in the past. Two parts of the work is 
expected to be done by the driver:

1) store the mapping somewhere (e.g hardware) during set_map()
2) associating mapping with a specific virtqueue

The only difference is that more than one mapping is used now.

For the issue of more set_maps(), driver should be always ready for the 
new set_maps() call instead of not expecting new set_maps() since guest 
memory topology could be changed due to several reasons.

Qemu or vhost-vDPA will try their best to avoid the frequency of 
set_maps() for better performance (e.g through batched IOTLB updating). 
E.g there should be at most one set_map() during one time of guest booting.

Thanks


>

