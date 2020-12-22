Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA232E0577
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 05:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgLVEmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 23:42:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59218 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgLVEmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 23:42:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608612087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KxNvOkwVVescVONh1zwIXV5OChiSOuHHhJQGCHD0sCo=;
        b=Q39tAqJDjO/0S2RKmW1A7kEDPrhqyLNmOwTtNcHVoImMG131hdePWCKKzZ9srfpGRGvioT
        MWGOjJFzV/fwB0r0OmBYCRIpFo9xkEDmv/HOaKmiHUWyTp0t8IRPK7dk1++AIkJUacFYMU
        S4vCgAwWcCALHzz2i2hRDYw8Sl+iets=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-aub14m2SNuyyi1o3ejeAqw-1; Mon, 21 Dec 2020 23:41:23 -0500
X-MC-Unique: aub14m2SNuyyi1o3ejeAqw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27791801817;
        Tue, 22 Dec 2020 04:41:22 +0000 (UTC)
Received: from [10.72.13.168] (ovpn-13-168.pek2.redhat.com [10.72.13.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 445595D6D1;
        Tue, 22 Dec 2020 04:41:16 +0000 (UTC)
Subject: Re: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        wangyunjian <wangyunjian@huawei.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
References: <cover.1608065644.git.wangyunjian@huawei.com>
 <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
 <CAF=yD-K6EM3zfZtEh=305P4Z6ehO6TzfQC4cxp5+gHYrxEtXSg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <acebdc23-7627-e170-cdfb-b7656c05e5c5@redhat.com>
Date:   Tue, 22 Dec 2020 12:41:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-K6EM3zfZtEh=305P4Z6ehO6TzfQC4cxp5+gHYrxEtXSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/22 上午7:07, Willem de Bruijn wrote:
> On Wed, Dec 16, 2020 at 3:20 AM wangyunjian<wangyunjian@huawei.com>  wrote:
>> From: Yunjian Wang<wangyunjian@huawei.com>
>>
>> Currently we break the loop and wake up the vhost_worker when
>> sendmsg fails. When the worker wakes up again, we'll meet the
>> same error.
> The patch is based on the assumption that such error cases always
> return EAGAIN. Can it not also be ENOMEM, such as from tun_build_skb?
>
>> This will cause high CPU load. To fix this issue,
>> we can skip this description by ignoring the error. When we
>> exceeds sndbuf, the return value of sendmsg is -EAGAIN. In
>> the case we don't skip the description and don't drop packet.
> the -> that
>
> here and above: description -> descriptor
>
> Perhaps slightly revise to more explicitly state that
>
> 1. in the case of persistent failure (i.e., bad packet), the driver
> drops the packet
> 2. in the case of transient failure (e.g,. memory pressure) the driver
> schedules the worker to try again later


If we want to go with this way, we need a better time to wakeup the 
worker. Otherwise it just produces more stress on the cpu that is what 
this patch tries to avoid.

Thanks


>
>

