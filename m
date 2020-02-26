Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B19A416FAC1
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgBZJaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:30:46 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58157 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726082AbgBZJap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:30:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582709444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gl/Qr0UmavRwEDNdFhMHeBuuzOf8uvsGp/oLFksBTPM=;
        b=DcegNe5B+PqK4G4w3TC3eNd9CuUWTaseYMLHo6FzI6rqvyOCE6DHzYuCNC6kILKkqMXBb1
        6LzL/pZ1b5FjrVxwPlan7IOmwBmGzGWpKQGjLipezWiQwcqcziN4od9iCA1fquz2aRAdnG
        U5LjRy+hMrVz6Eq4V+3zWIBwbG/B1gg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-csd-TjdMOK-YHS3eAQQ2sA-1; Wed, 26 Feb 2020 04:30:43 -0500
X-MC-Unique: csd-TjdMOK-YHS3eAQQ2sA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E137107ACC4;
        Wed, 26 Feb 2020 09:30:42 +0000 (UTC)
Received: from [10.72.13.217] (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56EB95C545;
        Wed, 26 Feb 2020 09:30:37 +0000 (UTC)
Subject: Re: virtio_net: can change MTU after installing program
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dahern@digitalocean.com>, netdev@vger.kernel.org
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
 <20200226015113-mutt-send-email-mst@kernel.org>
 <172688592.10687939.1582702621880.JavaMail.zimbra@redhat.com>
 <20200226032421-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b8dcde8c-ce7b-588a-49c1-0cf315794613@redhat.com>
Date:   Wed, 26 Feb 2020 17:30:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200226032421-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/26 =E4=B8=8B=E5=8D=884:39, Michael S. Tsirkin wrote:
> On Wed, Feb 26, 2020 at 02:37:01AM -0500, Jason Wang wrote:
>>
>> ----- Original Message -----
>>> On Tue, Feb 25, 2020 at 08:32:14PM -0700, David Ahern wrote:
>>>> Another issue is that virtio_net checks the MTU when a program is
>>>> installed, but does not restrict an MTU change after:
>>>>
>>>> # ip li sh dev eth0
>>>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_cod=
el
>>>> state UP mode DEFAULT group default qlen 1000
>>>>      link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
>>>>      prog/xdp id 13 tag c5595e4590d58063 jited
>>>>
>>>> # ip li set dev eth0 mtu 8192
>>>>
>>>> # ip li sh dev eth0
>>>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_cod=
el
>>>> state UP mode DEFAULT group default qlen 1000
>>> Well the reason XDP wants to limit MTU is this:
>>>      the MTU must be less than a page
>>>      size to avoid having to handle XDP across multiple pages
>>>
>> But even if we limit MTU is guest there's no way to limit the packet
>> size on host.
> Isn't this fundamental? IIUC dev->mtu is mostly a hint to devices about
> how the network is configured. It has to be the same across LAN.  If
> someone misconfigures it that breaks networking, and user gets to keep
> both pieces. E.g. e1000 will use dev->mtu to calculate rx buffer size.
> If you make it too small, well packets that are too big get dropped.
> There's no magic to somehow make them smaller, or anything like that.
> We can certainly drop packet > dev->mtu in the driver right now if we w=
ant to,
> and maybe if it somehow becomes important for performance, we
> could teach host to drop such packets for us. Though
> I don't really see why we care ...
>
>> It looks to me we need to introduce new commands to
>> change the backend MTU (e.g TAP) accordingly.
>>
>> Thanks
> So you are saying there are configurations where host does not know the
> correct MTU, and needs guest's help to figure it out?


Yes.


> I guess it's
> possible but it seems beside the point raised here.  TAP in particular
> mostly just seems to ignore MTU, I am not sure why we should bother
> propagating it there from guest or host. Propagating it from guest to
> the actual NIC might be useful e.g. for buffer sizing, but is tricky
> to do safely in case the NIC is shared between VMs.


Macvlan passthrough mode could be easier I guess.

Thanks

