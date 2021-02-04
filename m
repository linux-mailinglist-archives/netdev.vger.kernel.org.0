Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C928730EACF
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhBDDSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:18:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233205AbhBDDSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612408605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rgYGpxnisbo64RPm48ypK05uakOPf3IDveD9EGryR64=;
        b=IO7pMN50fxrhDr/VCIJJcK58znKnBW/8Fr2yHqfPwaAS3Tn8c4+/z4VkjpIcAlrTAA1Z/S
        RBTM+vBjYYDRbLPQ77evFUhw5LZBQwOImBy7hrVlhNJYoQJt+S4GOQOCWfhvL2LR5gZsI+
        z9WLPBhcuKeslqAzMR0Z9bnLf7xghgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-AJpO5PrJPdW6cwd5Sh_3-g-1; Wed, 03 Feb 2021 22:16:41 -0500
X-MC-Unique: AJpO5PrJPdW6cwd5Sh_3-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97124801962;
        Thu,  4 Feb 2021 03:16:40 +0000 (UTC)
Received: from [10.72.14.1] (ovpn-14-1.pek2.redhat.com [10.72.14.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F0E310016F9;
        Thu,  4 Feb 2021 03:16:32 +0000 (UTC)
Subject: Re: [PATCH iproute2-next v3 0/5] Add vdpa device management tool
To:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dsahern@gmail.com, stephen@networkplumber.org, mst@redhat.com,
        Adrian Moreno Zapata <amorenoz@redhat.com>
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210202103518.3858-1-parav@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <99106d07-1730-6ed8-c847-0400be0dcd57@redhat.com>
Date:   Thu, 4 Feb 2021 11:16:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202103518.3858-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/2 下午6:35, Parav Pandit wrote:
> Linux vdpa interface allows vdpa device management functionality.
> This includes adding, removing, querying vdpa devices.
>
> vdpa interface also includes showing supported management devices
> which support such operations.
>
> This patchset includes kernel uapi headers and a vdpa tool.
>
> examples:
>
> $ vdpa mgmtdev show
> vdpasim:
>    supported_classes net
>
> $ vdpa mgmtdev show -jp
> {
>      "show": {
>          "vdpasim": {
>              "supported_classes": [ "net" ]
>          }
>      }
> }
>
> Create a vdpa device of type networking named as "foo2" from
> the management device vdpasim_net:
>
> $ vdpa dev add mgmtdev vdpasim_net name foo2
>
> Show the newly created vdpa device by its name:
> $ vdpa dev show foo2
> foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2 max_vq_size 256
>
> $ vdpa dev show foo2 -jp
> {
>      "dev": {
>          "foo2": {
>              "type": "network",
>              "mgmtdev": "vdpasim_net",
>              "vendor_id": 0,
>              "max_vqs": 2,
>              "max_vq_size": 256
>          }
>      }
> }
>
> Delete the vdpa device after its use:
> $ vdpa dev del foo2
>
> Patch summary:
> Patch-1 adds kernel headers for vdpa subsystem
> Patch-2 adds library routines for indent handling
> Patch-3 adds library routines for generic socket communication
> PAtch-4 adds library routine for number to string mapping
> Patch-5 adds vdpa tool
>
> Kernel headers are from the vhost kernel tree [1] from branch linux-next.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>
> ---


Adding Adrian to see if this looks good for k8s integration.

Thanks

