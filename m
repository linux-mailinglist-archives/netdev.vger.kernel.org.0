Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AAA322824
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 10:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhBWJxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 04:53:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231822AbhBWJug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 04:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614073750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vKyuU9LWKwPaA0W8b7Zn/93LIBS1BDs8g8bsSMSJ0MM=;
        b=X6SQnT9BA/7QgAw6rhJXQ4W2PfLriH2MDXh5yopP2StmWGhpu2tB9vO+b31kcEFo93HTyk
        5qy4b5YXhlE3MplDeRuWoyBK9o23vhh4kPA5QcXgHh+X4pmPZAsRbxf6WTfZsCSKCEiqmC
        TjZMHomuDmYlAUF6Ahj1ABIWGoVTjoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-Ft6zYw1bOe-pQyUCOJ4coQ-1; Tue, 23 Feb 2021 04:48:18 -0500
X-MC-Unique: Ft6zYw1bOe-pQyUCOJ4coQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF58E1085927;
        Tue, 23 Feb 2021 09:48:16 +0000 (UTC)
Received: from [10.72.13.6] (ovpn-13-6.pek2.redhat.com [10.72.13.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CC8E19C45;
        Tue, 23 Feb 2021 09:48:11 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <20210221144437.GA82010@mtl-vdi-166.wap.labs.mlnx>
 <20210221165047-mutt-send-email-mst@kernel.org>
 <20210222060526.GA110862@mtl-vdi-166.wap.labs.mlnx>
 <20210223042559-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <65494f6b-9613-1c0e-4a36-e4af2965235e@redhat.com>
Date:   Tue, 23 Feb 2021 17:48:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210223042559-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 下午5:26, Michael S. Tsirkin wrote:
> On Mon, Feb 22, 2021 at 08:05:26AM +0200, Eli Cohen wrote:
>> On Sun, Feb 21, 2021 at 04:52:05PM -0500, Michael S. Tsirkin wrote:
>>> On Sun, Feb 21, 2021 at 04:44:37PM +0200, Eli Cohen wrote:
>>>> On Fri, Feb 19, 2021 at 06:54:58AM -0500, Si-Wei Liu wrote:
>>>>> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
>>>>> for legacy") made an exception for legacy guests to reset
>>>>> features to 0, when config space is accessed before features
>>>>> are set. We should relieve the verify_min_features() check
>>>>> and allow features reset to 0 for this case.
>>>>>
>>>>> It's worth noting that not just legacy guests could access
>>>>> config space before features are set. For instance, when
>>>>> feature VIRTIO_NET_F_MTU is advertised some modern driver
>>>>> will try to access and validate the MTU present in the config
>>>>> space before virtio features are set. Rejecting reset to 0
>>>>> prematurely causes correct MTU and link status unable to load
>>>>> for the very first config space access, rendering issues like
>>>>> guest showing inaccurate MTU value, or failure to reject
>>>>> out-of-range MTU.
>>>>>
>>>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
>>>>> Signed-off-by: Si-Wei Liu<si-wei.liu@oracle.com>
>>>>> ---
>>>>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
>>>>>   1 file changed, 1 insertion(+), 14 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>> index 7c1f789..540dd67 100644
>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>> @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
>>>>>   	return mvdev->mlx_features;
>>>>>   }
>>>>>   
>>>>> -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
>>>>> -{
>>>>> -	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
>>>>> -		return -EOPNOTSUPP;
>>>>> -
>>>>> -	return 0;
>>>>> -}
>>>>> -
>>>> But what if VIRTIO_F_ACCESS_PLATFORM is not offerred? This does not
>>>> support such cases.
>>> Did you mean "catch such cases" rather than "support"?
>>>
>> Actually I meant this driver/device does not support such cases.
> Well the removed code merely failed without VIRTIO_F_ACCESS_PLATFORM
> it didn't actually try to support anything ...


I think it's used to catch the driver that doesn't support ACCESS_PLATFORM?

Thanks


>

