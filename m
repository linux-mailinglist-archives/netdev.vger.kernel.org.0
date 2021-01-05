Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E421C2EA6AD
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 09:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbhAEIh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 03:37:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbhAEIh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 03:37:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609835790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pl2VjgHgWM+ZojCAv4JjpepIhqYoZRtiH5P0VsatjuQ=;
        b=DUsNWzRFvZ628QDt4Q3/FLRa/6uzp2+dMpSVHadx/QToLARK3kde9iPlXOoUcT85bVoih8
        5OitF/0SGupRFjE4nEdL5sHaX3FcKOQkvBnu7l8i06IV4CrXj4sZftjw51dtCGiBmQhawN
        vfQBvdWiEZSAnWoWJuxrzvSlvG1vrVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-_5rRbaXXMsS_rSZnqxIeug-1; Tue, 05 Jan 2021 03:36:28 -0500
X-MC-Unique: _5rRbaXXMsS_rSZnqxIeug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A85E800D53;
        Tue,  5 Jan 2021 08:36:27 +0000 (UTC)
Received: from [10.72.13.192] (ovpn-13-192.pek2.redhat.com [10.72.13.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C59F460BE5;
        Tue,  5 Jan 2021 08:36:20 +0000 (UTC)
Subject: Re: [PATCH linux-next v2 4/7] vdpa: Define vdpa mgmt device, ops and
 a netlink interface
To:     Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Cc:     "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
 <20210104033141.105876-5-parav@nvidia.com>
 <b08ede5d-e393-b4f8-d1d8-2aa29e409872@redhat.com>
 <BY5PR12MB432236DE09EBC2E584C07FCDDCD20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <b7a4602d-daae-dde1-a064-2ee07cf84309@redhat.com>
 <BY5PR12MB4322EB5AD78BBAB2311AD877DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <449d2860-c75f-04fa-9080-c99dc6df7288@redhat.com>
Date:   Tue, 5 Jan 2021 16:36:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB4322EB5AD78BBAB2311AD877DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/5 下午2:33, Parav Pandit wrote:
>
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Tuesday, January 5, 2021 9:40 AM
>>
>> On 2021/1/4 下午3:24, Parav Pandit wrote:
>>>> From: Jason Wang <jasowang@redhat.com>
>>>> Sent: Monday, January 4, 2021 12:33 PM
>>>>
>>>> On 2021/1/4 上午11:31, Parav Pandit wrote:
>>>>> To add one or more VDPA devices, define a management device which
>>>>> allows adding or removing vdpa device. A management device defines
>>>>> set of callbacks to manage vdpa devices.
>>>>>
>>>>> To begin with, it defines add and remove callbacks through which a
>>>>> user defined vdpa device can be added or removed.
>>>>>
>>>>> A unique management device is identified by its unique handle
>>>>> identified by management device name and optionally the bus name.
>>>>>
>>>>> Hence, introduce routine through which driver can register a
>>>>> management device and its callback operations for adding and remove
>>>>> a vdpa device.
>>>>>
>>>>> Introduce vdpa netlink socket family so that user can query
>>>>> management device and its attributes.
>>>>>
>>>>> Example of show vdpa management device which allows creating vdpa
>>>>> device of networking class (device id = 0x1) of virtio specification
>>>>> 1.1 section 5.1.1.
>>>>>
>>>>> $ vdpa mgmtdev show
>>>>> vdpasim_net:
>>>>>      supported_classes:
>>>>>        net
>>>>>
>>>>> Example of showing vdpa management device in JSON format.
>>>>>
>>>>> $ vdpa mgmtdev show -jp
>>>>> {
>>>>>        "show": {
>>>>>            "vdpasim_net": {
>>>>>                "supported_classes": [ "net" ]
>>>>>            }
>>>>>        }
>>>>> }
>>>>>
>>>>> Signed-off-by: Parav Pandit<parav@nvidia.com>
>>>>> Reviewed-by: Eli Cohen<elic@nvidia.com>
>>>>> Reviewed-by: Jason Wang<jasowang@redhat.com>
>>>>> ---
>>>>> Changelog:
>>>>> v1->v2:
>>>>>     - rebased
>>>>>     - updated commit log example for management device name from
>>>>>       "vdpasim" to "vdpasim_net"
>>>>>     - removed device_id as net and block management devices are
>>>>> separated
>>>> So I wonder whether there could be a type of management devices that
>>>> can deal with multiple types of virtio devices. If yes, we probably
>>>> need to add device id back.
>>> At this point mlx5 plan to support only net.
>>> It is useful to see what type of vdpa device is supported by a management
>> device.
>>> In future if a mgmt dev supports multiple types, user needs to choose
>> desired type.
>>> I guess we can differ this optional type to future, when such mgmt. device
>> will/may be available.
>>
>>
>> I worry if we remove device_id, it may gives a hint that multiple mgmt
>> devices needs to be registered if it supports multiple types.
>>
> No it shouldn't. because we do expose multiple supported types in mgmtdev attributes.


Right.


>
>> So if possible I would like to keep the device_id here.
>>
> Its possible to keep it. But with current drivers, mainly mlx5 and vdpa_sim, it is redundant.
> Not sure of the ifc's plan.
> We have been splitting modules to handle net and block differently in mlx5 as well as vdpa_sim.
> So it looks to me that both may be separate management drivers (and management devices).
> Such as vdpasim_net and vdpasim_block.
> mlx5 doesn't have plan for block yet.


Ok. Then it's fine.

Thanks


