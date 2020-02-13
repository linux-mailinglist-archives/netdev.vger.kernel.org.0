Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3E315B7D2
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 04:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgBMDeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 22:34:37 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25454 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729432AbgBMDed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 22:34:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581564872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jveoJYEei31LnYAAA1c+qGj2sc1cBfYcZJcuE3oKpzU=;
        b=IfPK6GPzSSAIyATiMStCwXT2kh68/p284zdYWH+8CY6l76AopclO/eX3YHmeKFsuvPr5Am
        q1nS3SwZVmi8pUL/4UPWNpoH7vda/MPaZzqX414W3MgrolwzBxpO1HgF+wfjKFLroU7xhX
        hrlz0pe6YcE9RPyTUi78rIy7E+dwf1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-_Su18Ee-OOmoGnyCqHCCHA-1; Wed, 12 Feb 2020 22:34:30 -0500
X-MC-Unique: _Su18Ee-OOmoGnyCqHCCHA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBD04800D41;
        Thu, 13 Feb 2020 03:34:27 +0000 (UTC)
Received: from [10.72.13.212] (ovpn-13-212.pek2.redhat.com [10.72.13.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54EF710002B6;
        Thu, 13 Feb 2020 03:34:12 +0000 (UTC)
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
Date:   Thu, 13 Feb 2020 11:34:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200212125108.GS4271@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/12 =E4=B8=8B=E5=8D=888:51, Jason Gunthorpe wrote:
> On Wed, Feb 12, 2020 at 03:55:31PM +0800, Jason Wang wrote:
>>> The ida_simple_remove should probably be part of the class release
>>> function to make everything work right
>> It looks to me bus instead of class is the correct abstraction here si=
nce
>> the devices share a set of programming interface but not the semantics=
.
> device_release() doesn't call the bus release?


What it did is:

 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dev->release)
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 dev->release(dev);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else if (dev->type && dev->ty=
pe->release)
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 dev->type->release(dev);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else if (dev->class && dev->c=
lass->dev_release)
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 dev->class->dev_release(dev);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 WARN(1, KERN_ERR "Device '%s' does not have a release(=
)=20
function, it is broken and must be fixed. See Documentation/kobject.txt.\=
n",
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_na=
me(dev));

So it looks not.


>   You have dev, type or
> class to choose from. Type is rarely used and doesn't seem to be used
> by vdpa, so class seems the right choice
>
> Jason


Yes, but my understanding is class and bus are mutually exclusive. So we=20
can't add a class to a device which is already attached on a bus.

Thanks


