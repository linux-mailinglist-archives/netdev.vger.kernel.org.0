Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD5DE47E1
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408914AbfJYJzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:55:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42910 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394354AbfJYJzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571997315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UVoMMueYUvZ0eI/99xRHtgd80EIwZE7u1t/HBTorxLk=;
        b=CnVy8qTu145LnR3iFmrmWvmicVVYM7v8yuXrnpCj8yZTpswO96LH0qednG4VTVnKY+rOoS
        sEaFJl89pu9UGUXu0nwdsdIYFCAOkpAqwRmxaLi5RVHjp4TXmO6qI3HbGwFNH8Lqu9/SJb
        eEtnMH6bd99zWuKsGz2oPKQN95O0+0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-29ZThwCIPJi-QKNlPM682w-1; Fri, 25 Oct 2019 05:55:10 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F6D91005500;
        Fri, 25 Oct 2019 09:55:09 +0000 (UTC)
Received: from [10.72.12.249] (ovpn-12-249.pek2.redhat.com [10.72.12.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC3E160BEC;
        Fri, 25 Oct 2019 09:54:56 +0000 (UTC)
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
From:   Jason Wang <jasowang@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <47a572fd-5597-1972-e177-8ee25ca51247@redhat.com>
 <20191023030253.GA15401@___>
 <ac36f1e3-b972-71ac-fe0c-3db03e016dcf@redhat.com>
 <20191023070747.GA30533@___>
 <106834b5-dae5-82b2-0f97-16951709d075@redhat.com> <20191023101135.GA6367@___>
 <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
 <20191024042155.GA21090@___>
 <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
 <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
 <20191024091839.GA17463@___>
 <fefc82a3-a137-bc03-e1c3-8de79b238080@redhat.com>
Message-ID: <e7e239ba-2461-4f8d-7dd7-0f557ac7f4bf@redhat.com>
Date:   Fri, 25 Oct 2019 17:54:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fefc82a3-a137-bc03-e1c3-8de79b238080@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 29ZThwCIPJi-QKNlPM682w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/24 =E4=B8=8B=E5=8D=886:42, Jason Wang wrote:
>
> Yes.
>
>
>> =C2=A0 And we should try to avoid
>> putting ctrl vq and Rx/Tx vqs in the same DMA space to prevent
>> guests having the chance to bypass the host (e.g. QEMU) to
>> setup the backend accelerator directly.
>
>
> That's really good point.=C2=A0 So when "vhost" type is created, parent=
=20
> should assume addr of ctrl_vq is hva.
>
> Thanks


This works for vhost but not virtio since there's no way for virtio=20
kernel driver to differ ctrl_vq with the rest when doing DMA map. One=20
possible solution is to provide DMA domain isolation between virtqueues.=20
Then ctrl vq can use its dedicated DMA domain for the work.

Anyway, this could be done in the future. We can have a version first=20
that doesn't support ctrl_vq.

Thanks

