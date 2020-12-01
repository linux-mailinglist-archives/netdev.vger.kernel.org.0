Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1252C978B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 07:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgLAG0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 01:26:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725859AbgLAG0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 01:26:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606803916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCHesexpjRFhWOcxGP78gptqdhCw6l2GCYqi5IE/c2M=;
        b=GurzyJYdaIbP7qEk7glfI4rJLLN636K9yE1TUOj48OgltwWmXfYJrU2RXVfhhSt4dEptds
        DUgRFiydI/ZoxJ9vMp7X/4qKB92uV9VkUA0NViLXfsC5AZg8ktI4N0NOLpH+LdHV+mxga+
        Y1ZcVWaAMgnVP2YhAQM7uIGPMihOzhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-h6Hs-gSMOVqrcs__jDRWng-1; Tue, 01 Dec 2020 01:25:12 -0500
X-MC-Unique: h6Hs-gSMOVqrcs__jDRWng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7820F180E49D;
        Tue,  1 Dec 2020 06:25:11 +0000 (UTC)
Received: from [10.72.13.167] (ovpn-13-167.pek2.redhat.com [10.72.13.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F69860853;
        Tue,  1 Dec 2020 06:25:06 +0000 (UTC)
Subject: Re: [External] Re: [PATCH 0/7] Introduce vdpa management tool
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, elic@nvidia.com,
        netdev@vger.kernel.org
References: <20201112064005.349268-1-parav@nvidia.com>
 <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com>
 <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com>
Date:   Tue, 1 Dec 2020 14:25:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/30 下午3:07, Yongji Xie wrote:
>>> Thanks for adding me, Jason!
>>>
>>> Now I'm working on a v2 patchset for VDUSE (vDPA Device in Userspace)
>>> [1]. This tool is very useful for the vduse device. So I'm considering
>>> integrating this into my v2 patchset. But there is one problem：
>>>
>>> In this tool, vdpa device config action and enable action are combined
>>> into one netlink msg: VDPA_CMD_DEV_NEW. But in vduse case, it needs to
>>> be splitted because a chardev should be created and opened by a
>>> userspace process before we enable the vdpa device (call
>>> vdpa_register_device()).
>>>
>>> So I'd like to know whether it's possible (or have some plans) to add
>>> two new netlink msgs something like: VDPA_CMD_DEV_ENABLE and
>>> VDPA_CMD_DEV_DISABLE to make the config path more flexible.
>>>
>> Actually, we've discussed such intermediate step in some early
>> discussion. It looks to me VDUSE could be one of the users of this.
>>
>> Or I wonder whether we can switch to use anonymous inode(fd) for VDUSE
>> then fetching it via an VDUSE_GET_DEVICE_FD ioctl?
>>
> Yes, we can. Actually the current implementation in VDUSE is like
> this.  But seems like this is still a intermediate step. The fd should
> be binded to a name or something else which need to be configured
> before.


The name could be specified via the netlink. It looks to me the real 
issue is that until the device is connected with a userspace, it can't 
be used. So we also need to fail the enabling if it doesn't opened.

Thanks


>
> Thanks,
> Yongji
>

