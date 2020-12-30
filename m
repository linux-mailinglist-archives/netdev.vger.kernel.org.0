Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5262E772A
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 09:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgL3Ipy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 03:45:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbgL3Ipy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 03:45:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609317868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9okFBNwasiSQQCSpJ72vtfGTHuNhhqn6FTR4CcWUioo=;
        b=KKnS6OQinQIWOuzgwDtd+i/oz+e1gKxwXg9CjJ6c8mtimolLWaZ3k1iOnBrdBhrs8zDKlu
        z2K5yCQdtrthC1cekCpUx559QOyRq2AVinju4nrxIvLxly+t/I3iwIVrz6n9RiNP1OOMh9
        2xc79JrdQCiPjRBwd6ejltvcmkX5Ik8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-aMFY9chTMXuEksfzWhLj5Q-1; Wed, 30 Dec 2020 03:44:25 -0500
X-MC-Unique: aMFY9chTMXuEksfzWhLj5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F9631005504;
        Wed, 30 Dec 2020 08:44:24 +0000 (UTC)
Received: from [10.72.13.30] (ovpn-13-30.pek2.redhat.com [10.72.13.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D10D60BFA;
        Wed, 30 Dec 2020 08:44:18 +0000 (UTC)
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
 <20201228145953.08673c8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSe630QvTRM-0fnz=B+QRfii=sbsb-Qp5tTc2zbMgxcQyw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <10395a75-fb31-639f-40b2-d6fd60938247@redhat.com>
Date:   Wed, 30 Dec 2020 16:44:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSe630QvTRM-0fnz=B+QRfii=sbsb-Qp5tTc2zbMgxcQyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/29 上午8:57, Willem de Bruijn wrote:
> On Mon, Dec 28, 2020 at 5:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> On Mon, 28 Dec 2020 11:22:32 -0500 Willem de Bruijn wrote:
>>> From: Willem de Bruijn <willemb@google.com>
>>>
>>> Add optional PTP hardware timestamp offload for virtio-net.
>>>
>>> Accurate RTT measurement requires timestamps close to the wire.
>>> Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
>>> virtio-net header is expanded with room for a timestamp. A host may
>>> pass receive timestamps for all or some packets. A timestamp is valid
>>> if non-zero.
>>>
>>> The timestamp straddles (virtual) hardware domains. Like PTP, use
>>> international atomic time (CLOCK_TAI) as global clock base. It is
>>> guest responsibility to sync with host, e.g., through kvm-clock.
>> Would this not be confusing to some user space SW to have a NIC with
>> no PHC deliver HW stamps?
>>
>> I'd CC Richard on this, unless you already discussed with him offline.
> Thanks, good point. I should have included Richard.
>
> There is a well understood method for synchronizing guest and host
> clock in KVM using ptp_kvm. For virtual environments without NIC
> hardware offload, the when host timestamps in software, this suffices.
>
> Syncing host with NIC is assumed if the host advertises the feature
> and implements using real hardware timestamps.


Or it could be useful for virtio hardware when there's no KVM that 
provides PTP.

Thanks


>

