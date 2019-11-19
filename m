Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4939B10125F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 05:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfKSEIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 23:08:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49370 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727464AbfKSEIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 23:08:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574136522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4KHnBphqylub5AyGngwSZIrs22cExMLF/6Fas0WmnvQ=;
        b=OgEkU7+0aIyvooI55kRm0zklnwbMKuvz/Q/9kLoQ7M+yjt5EW98pEfZpA9kllzJJK44jS8
        vY1a79PhqxQRyfm6qcmbsOwWfmlOYdi6MbSJO8HB6EarYSEF9bb3hQG/6JhGWdxhULcOFW
        igqDGpDWAaZnPrsiRKusi41ASSHUykQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-9KDg-R-QMyC7gJzz-rja_w-1; Mon, 18 Nov 2019 23:08:39 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 619B71005500;
        Tue, 19 Nov 2019 04:08:37 +0000 (UTC)
Received: from [10.72.12.132] (ovpn-12-132.pek2.redhat.com [10.72.12.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA718608E2;
        Tue, 19 Nov 2019 04:08:16 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
Date:   Tue, 19 Nov 2019 12:08:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 9KDg-R-QMyC7gJzz-rja_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/16 =E4=B8=8A=E5=8D=887:25, Parav Pandit wrote:
> Hi Jeff,
>
>> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Sent: Friday, November 15, 2019 4:34 PM
>>
>> From: Dave Ertman <david.m.ertman@intel.com>
>>
>> This is the initial implementation of the Virtual Bus, virtbus_device an=
d
>> virtbus_driver.  The virtual bus is a software based bus intended to sup=
port
>> lightweight devices and drivers and provide matching between them and
>> probing of the registered drivers.
>>
>> The primary purpose of the virual bus is to provide matching services an=
d to
>> pass the data pointer contained in the virtbus_device to the virtbus_dri=
ver
>> during its probe call.  This will allow two separate kernel objects to m=
atch up
>> and start communication.
>>
> It is fundamental to know that rdma device created by virtbus_driver will=
 be anchored to which bus for an non abusive use.
> virtbus or parent pci bus?
> I asked this question in v1 version of this patch.
>
> Also since it says - 'to support lightweight devices', documenting that i=
nformation is critical to avoid ambiguity.
>
> Since for a while I am working on the subbus/subdev_bus/xbus/mdev [1] wha=
tever we want to call it, it overlaps with your comment about 'to support l=
ightweight devices'.
> Hence let's make things crystal clear weather the purpose is 'only matchi=
ng service' or also 'lightweight devices'.
> If this is only matching service, lets please remove lightweight devices =
part..


Yes, if it's matching + lightweight device, its function is almost a=20
duplication of mdev. And I'm working on extending mdev[1] to be a=20
generic module to support any types of virtual devices a while. The=20
advantage of mdev is:

1) ready for the userspace driver (VFIO based)
2) have a sysfs/GUID based management interface

So for 1, it's not clear that how userspace driver would be supported=20
here, or it's completely not being accounted in this series? For 2, it=20
looks to me that this series leave it to the implementation, this means=20
management to learn several vendor specific interfaces which seems a burden=
.

Note, technically Virtual Bus could be implemented on top of [1] with=20
the full lifecycle API.

[1] https://lkml.org/lkml/2019/11/18/261


>
> You additionally need modpost support for id table integration to modifo,=
 modprobe and other tools.
> A small patch similar to this one [2] is needed.
> Please include in the series.
>
> [..]


And probably a uevent method. But rethinking of this, matching through a=20
single virtual bus seems not good. What if driver want to do some=20
specific matching? E.g for virtio, we may want a vhost-net driver that=20
only match networking device. With a single bus, it probably means you=20
need another bus on top and provide the virtio specific matching there.=20
This looks not straightforward as allowing multiple type of buses.

Thanks

