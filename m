Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916101033F1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 06:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKTFgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 00:36:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31698 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725554AbfKTFgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 00:36:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574228199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knznamAEiTfG9nRki0ZkB5/yRqneVEsD5AOtQiV05Uk=;
        b=GQ04AGt0HfWZv9EINlhOuHDucUzO4CRVGDESO2KMqZ0oLxLRomPPw1z8ErHUmS8vOMUhJ9
        c/mi45sUIw2gXbLfUl0j0NaAKjKmQIxZrCPz0hVoAhP9OLuLFBSTvu7WuLx/my4+6bDLVj
        nZ89UEQ8gHLnwX688v/d+2E9pkKSR/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-rr-kAgRyNyeLrJBfzRHjFw-1; Wed, 20 Nov 2019 00:36:36 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09F91800052;
        Wed, 20 Nov 2019 05:36:35 +0000 (UTC)
Received: from [10.72.12.82] (ovpn-12-82.pek2.redhat.com [10.72.12.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 817EA60BFB;
        Wed, 20 Nov 2019 05:35:24 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
From:   Jason Wang <jasowang@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
References: <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
Message-ID: <3ef5bc09-dd74-44bc-30f1-b773fac448a2@redhat.com>
Date:   Wed, 20 Nov 2019 13:34:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: rr-kAgRyNyeLrJBfzRHjFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/20 =E4=B8=8A=E5=8D=8811:59, Jason Wang wrote:
> Well, VFIO have multiple types of API. The design is to stick the VFIO
> DMA model like container work for making DMA API work for userspace
> driver. We can invent something our own but it must duplicate with the
> exist API and it will be extra overhead when VFIO DMA API starts to
> support stuffs like nesting or PASID.
>
> So in conclusion for vhost-mdev:
>
> - DMA is still done through VFIO manner e.g container fd etc.
> - device API is totally virtio specific.
>
> Compared with vfio-pci device, the only difference is the device API,
> we don't use device fd but vhost-net fd,


Correction here, device fd is used here instead of vhost-net fd.

Thanks


>   but of course we can switch
> to use device fd. I'm sure we can settle this part down by having a
> way that is acceptable by both sides.

