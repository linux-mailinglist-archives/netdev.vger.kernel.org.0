Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B15131E696
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 08:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhBRG5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 01:57:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230428AbhBRGvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 01:51:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613630942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZsYPo7lFIHJSBW+k62y1pF0Q5iGGVk8F/Ofi1wgySA=;
        b=D4nn7JodsEGOBvhd5Yb4LKuwB2kq2PTaVbWv5peaz1p1R1cnF7gDs9AoUxeHuYKVEhOK5A
        2iHl2nR5Ic72SofhNBU6yJP2X7BG2c7i4nkECESB7A9l9ox3jKXjHwADZ3H5kinFov+G/X
        76w1qAXz0QHW+OwIyvpTvPx/1a7PMbY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-uvGEjrB0MqiW0qrg2HcOWQ-1; Thu, 18 Feb 2021 01:37:29 -0500
X-MC-Unique: uvGEjrB0MqiW0qrg2HcOWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DBF3801976;
        Thu, 18 Feb 2021 06:37:28 +0000 (UTC)
Received: from [10.72.13.28] (ovpn-13-28.pek2.redhat.com [10.72.13.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 987C6722CF;
        Thu, 18 Feb 2021 06:37:19 +0000 (UTC)
Subject: Re: [PATCH v2 3/3] vdpa/mlx5: defer clear_virtqueues to until
 DRIVER_OK
To:     Si-Wei Liu <si-wei.liu@oracle.com>, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
 <1612993680-29454-4-git-send-email-si-wei.liu@oracle.com>
 <20210211073314.GB100783@mtl-vdi-166.wap.labs.mlnx>
 <20210216152148.GA99540@mtl-vdi-166.wap.labs.mlnx>
 <88ecbbb6-a339-a5cd-82b7-387225a45d36@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <27c7858e-67a4-9f22-37e3-f527f1dd85a6@redhat.com>
Date:   Thu, 18 Feb 2021 14:37:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <88ecbbb6-a339-a5cd-82b7-387225a45d36@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/18 上午5:55, Si-Wei Liu wrote:
>
>
> On 2/16/2021 7:21 AM, Eli Cohen wrote:
>> On Thu, Feb 11, 2021 at 09:33:14AM +0200, Eli Cohen wrote:
>>> On Wed, Feb 10, 2021 at 01:48:00PM -0800, Si-Wei Liu wrote:
>>>> While virtq is stopped,  get_vq_state() is supposed to
>>>> be  called to  get  sync'ed  with  the latest internal
>>>> avail_index from device. The saved avail_index is used
>>>> to restate  the virtq  once device is started.  Commit
>>>> b35ccebe3ef7 introduced the clear_virtqueues() routine
>>>> to  reset  the saved  avail_index,  however, the index
>>>> gets cleared a bit earlier before get_vq_state() tries
>>>> to read it. This would cause consistency problems when
>>>> virtq is restarted, e.g. through a series of link down
>>>> and link up events. We  could  defer  the  clearing of
>>>> avail_index  to  until  the  device  is to be started,
>>>> i.e. until  VIRTIO_CONFIG_S_DRIVER_OK  is set again in
>>>> set_status().
>>>>
>>>> Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index 
>>>> after change map")
>>>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>> Acked-by: Eli Cohen <elic@nvidia.com>
>>>
>> I take it back. I think we don't need to clear the indexes at all. In
>> case we need to restore indexes we'll get the right values through
>> set_vq_state(). If we suspend the virtqueue due to VM being suspended,
>> qemu will query first and will provide the the queried value. In case of
>> VM reboot, it will provide 0 in set_vq_state().
>>
>> I am sending a patch that addresses both reboot and suspend.
> With set_vq_state() repurposed to restoring used_index I'm fine with 
> this approach.
>
> Do I have to repost a v3 of this series while dropping the 3rd patch?
>
> -Siwei 


Yes, please.

Thanks


