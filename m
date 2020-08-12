Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFD32423F6
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 04:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgHLCJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 22:09:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39578 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726255AbgHLCJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 22:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597198175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CjBAia3ospUg/zmTq94JkNk1GKssjuXqjxy8UFfaMgA=;
        b=Uf95jpW2bePy3f5h0XLq8U8xNkftY4lHNbzkqh01RPAxz7Tw+YwRkHbUs2WpEZGg3mEkuy
        fPquMuwM+6DX6Cdup1YIMGDx7pcoA7Mnmy8wh8bh1dVIy/VlbcJmO5DQqolah58lgUsY2W
        mv2+pp0K57gBXTjLjNGgV/IjxPNzqUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-hLK4A1mUMWylNewyGM9dsg-1; Tue, 11 Aug 2020 22:09:32 -0400
X-MC-Unique: hLK4A1mUMWylNewyGM9dsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E88A102C7F5;
        Wed, 12 Aug 2020 02:09:30 +0000 (UTC)
Received: from [10.72.12.118] (ovpn-12-118.pek2.redhat.com [10.72.12.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EACC087D62;
        Wed, 12 Aug 2020 02:09:23 +0000 (UTC)
Subject: Re: VDPA Debug/Statistics
To:     Eli Cohen <elic@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eli@mellanox.com" <eli@mellanox.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Majd Dibbiny <majd@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
References: <BN8PR12MB342559414BE03DFC992AD03DAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
 <20200811073144-mutt-send-email-mst@kernel.org>
 <BN8PR12MB34259F2AE1FDAF2D40E48C5BAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <02c1cf02-40c7-80d7-60b5-19b691993018@redhat.com>
Date:   Wed, 12 Aug 2020 10:09:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB34259F2AE1FDAF2D40E48C5BAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/8/11 下午7:58, Eli Cohen wrote:
> On Tue, Aug 11, 2020 at 11:26:20AM +0000, Eli Cohen wrote:
>> Hi All
>>
>> Currently, the only statistics we get for a VDPA instance comes from the virtio_net device instance. Since VDPA involves hardware acceleration, there can be quite a lot of information that can be fetched from the underlying device. Currently there is no generic method to fetch this information.
>>
>> One way of doing this can be to create a the host, a net device for
>> each VDPA instance, and use it to get this information or do some
>> configuration. Ethtool can be used in such a case


The problems are:

- vDPA is not net specific
- vDPA should be transparent to host networking stack


>>
>> I would like to hear what you think about this or maybe you have some other ideas to address this topic.
>>
>> Thanks,
>> Eli
> Something I'm not sure I understand is how are vdpa instances created on mellanox cards? There's a devlink command for that, is that right?
> Can that be extended for stats?
>
> Currently any VF will be probed as VDPA device. We're adding devlink support but I am not sure if devlink is suitable for displaying statistics. We will discuss internally but I wanted to know why you guys think.


I agree with Michael, if it's possible, integrating stats with devlink 
should be the best. Having another interface with is just for stats 
looks not good.

Thanks


>
> --
> MST
>

