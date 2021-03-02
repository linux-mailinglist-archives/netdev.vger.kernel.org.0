Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FD532B378
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhCCD7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 22:59:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1838497AbhCBKz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:55:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614682441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iGoIdvlUz0nc9AN8ZEH5WnSE27CeiPYPvS6gyByubs0=;
        b=fq05dabxyPnNkzIYArGK5OfWuoHUWgumx91aDB2lp2QyrKc7ybiKYo+cp3k9kyHamuS5Rr
        KcIumvyy9vembRnwX/F/wSggHYuG3XP3hgTCyLLQJi4MG/U7b7axbHal5sSQklYY4vVvHB
        w+bgKrcSO4FZE++gi6Ddw2Z+srODs8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-V1K4Oah_PzeYFrWjqcNxZQ-1; Tue, 02 Mar 2021 05:53:59 -0500
X-MC-Unique: V1K4Oah_PzeYFrWjqcNxZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A3A6801976;
        Tue,  2 Mar 2021 10:53:58 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 473455D9D3;
        Tue,  2 Mar 2021 10:53:52 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
Date:   Tue, 2 Mar 2021 18:53:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210302043419-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
>>>>> the kernel that it's a legacy guest. Ugh :(
>>>> Well, although I think adding an ioctl is doable, may I know what the use
>>>> case there will be for kernel to leverage such info directly? Is there a
>>>> case QEMU can't do with dedicate ioctls later if there's indeed
>>>> differentiation (legacy v.s. modern) needed?
>>> BTW a good API could be
>>>
>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>
>>> we did it per vring but maybe that was a mistake ...
>>
>> Actually, I wonder whether it's good time to just not support legacy driver
>> for vDPA. Consider:
>>
>> 1) It's definition is no-normative
>> 2) A lot of budren of codes
>>
>> So qemu can still present the legacy device since the config space or other
>> stuffs that is presented by vhost-vDPA is not expected to be accessed by
>> guest directly. Qemu can do the endian conversion when necessary in this
>> case?
>>
>> Thanks
>>
> Overall I would be fine with this approach but we need to avoid breaking
> working userspace, qemu releases with vdpa support are out there and
> seem to work for people. Any changes need to take that into account
> and document compatibility concerns.


Agree, let me check.


>   I note that any hardware
> implementation is already broken for legacy except on platforms with
> strong ordering which might be helpful in reducing the scope.


Yes.

Thanks


>
>

