Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E681BD813
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 11:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgD2JV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 05:21:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47030 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2JV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 05:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588152116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZvr/skNPOFKMD3ogXhoD9tnQHqLrRRqrmLtubG1DcI=;
        b=bXRhx8efqDzHNDTwyu6wp7SnFZptiDXeMokD7XE5hs/U+N7+r+W5UgEcNVTOuXoAa8ow2L
        1xYU3jdexUXHFwHWSWGWbk0OmE2YgLe/orTlUA9kb48fJWxY9LqgDBcLq0FYIWliVks/O+
        ebuQKuPcbXQycqfhP+5264r60LtUOl8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-urpKaGkpMHmnm-m04i_PzA-1; Wed, 29 Apr 2020 05:21:55 -0400
X-MC-Unique: urpKaGkpMHmnm-m04i_PzA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96E72107ACF4;
        Wed, 29 Apr 2020 09:21:53 +0000 (UTC)
Received: from [10.72.13.2] (ovpn-13-2.pek2.redhat.com [10.72.13.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 752B65C1BE;
        Wed, 29 Apr 2020 09:21:44 +0000 (UTC)
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     davem@davemloft.net, Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        netdev@vger.kernel.org
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
 <20200428160052.o3ihui4262xogyg4@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6dc937e4-0ef9-617d-c9c8-8b1f8c428d90@redhat.com>
Date:   Wed, 29 Apr 2020 17:21:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428160052.o3ihui4262xogyg4@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/29 =E4=B8=8A=E5=8D=8812:00, Stefano Garzarella wrote:
> On Tue, Apr 28, 2020 at 04:13:22PM +0800, Jason Wang wrote:
>> On 2020/4/27 =E4=B8=8B=E5=8D=8810:25, Stefano Garzarella wrote:
>>> Hi David, Michael, Stefan,
>>> I'm restarting to work on this topic since Kata guys are interested t=
o
>>> have that, especially on the guest side.
>>>
>>> While working on the v2 I had few doubts, and I'd like to have your
>>> suggestions:
>>>
>>>    1. netns assigned to the device inside the guest
>>>
>>>      Currently I assigned this device to 'init_net'. Maybe it is bett=
er
>>>      if we allow the user to decide which netns assign to the device
>>>      or to disable this new feature to have the same behavior as befo=
re
>>>      (host reachable from any netns).
>>>      I think we can handle this in the vsock core and not in the sing=
le
>>>      transports.
>>>
>>>      The simplest way that I found, is to add a new
>>>      IOCTL_VM_SOCKETS_ASSIGN_G2H_NETNS to /dev/vsock to enable the fe=
ature
>>>      and assign the device to the same netns of the process that do t=
he
>>>      ioctl(), but I'm not sure it is clean enough.
>>>
>>>      Maybe it is better to add new rtnetlink messages, but I'm not su=
re if
>>>      it is feasible since we don't have a netdev device.
>>>
>>>      What do you suggest?
>> As we've discussed, it should be a netdev probably in either guest or =
host
>> side. And it would be much simpler if we want do implement namespace t=
hen.
>> No new API is needed.
>>
> Thanks Jason!
>
> It would be cool, but I don't have much experience on netdev.
> Do you see any particular obstacles?


I don't see but if there's we can try to find a solution or ask for=20
netdev experts for that. I do hear from somebody that is interested in=20
having netdev in the past.


>
> I'll take a look to understand how to do it, surely in the guest would
> be very useful to have the vsock device as a netdev and maybe also in t=
he host.


Yes, it's worth to have a try then we will have a unified management=20
interface and we will benefit from it in the future.

Starting form guest is good idea which should be less complicated than ho=
st.

Thanks


>
> Stefano
>

