Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160B4F263C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 05:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733138AbfKGEI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 23:08:59 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52299 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733115AbfKGEI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 23:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573099737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YSIEdqcLrogv35u/q3ac44m/gQYEQosg5vjXwg1Frog=;
        b=Kv5Shbw2uYdpjl7xPUJp0kikDCTV436Av2zR0n2DdCcWiHGK1mx9guuVQYRsSaiuc0yLwY
        bWa3ixK3Cg8XwDj6dRa/hMwkQAeiLkdAsLgP6NNPVVw5Vm78dxJEUheCTNiOQu6/1UbsHx
        kPgHiYQeyJ3EIdD04wf9j0IrUrZt+bw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-b64OKsVqNKabWfY1H8bGSQ-1; Wed, 06 Nov 2019 23:08:54 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3D7B107ACC3;
        Thu,  7 Nov 2019 04:08:52 +0000 (UTC)
Received: from [10.72.12.214] (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4851960870;
        Thu,  7 Nov 2019 04:08:16 +0000 (UTC)
Subject: Re: [PATCH v5] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <20191105115332.11026-1-tiwei.bie@intel.com>
 <16f31c27-3a0e-09d7-3925-dc9777f5e229@redhat.com> <20191106122249.GA3235@___>
 <20191106075607-mutt-send-email-mst@kernel.org>
 <580dfa2c-f1ff-2f6f-bbc8-1c4b0a829a3d@redhat.com>
 <20191106144952.GA10926@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <914081d6-40ee-f184-ff43-c3d4cd885fba@redhat.com>
Date:   Thu, 7 Nov 2019 12:08:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106144952.GA10926@___>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: b64OKsVqNKabWfY1H8bGSQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/6 =E4=B8=8B=E5=8D=8810:49, Tiwei Bie wrote:
>>>>>> +=09default:
>>>>>> +=09=09/*
>>>>>> +=09=09 * VHOST_SET_MEM_TABLE, VHOST_SET_LOG_BASE, and
>>>>>> +=09=09 * VHOST_SET_LOG_FD are not used yet.
>>>>>> +=09=09 */
>>>>> If we don't even use them, there's probably no need to call
>>>>> vhost_dev_ioctl(). This may help to avoid confusion when we want to d=
evelop
>>>>> new API for e.g dirty page tracking.
>>>> Good point. It's better to reject these ioctls for now.
>>>>
>>>> PS. One thing I may need to clarify is that, we need the
>>>> VHOST_SET_OWNER ioctl to get the vq->handle_kick to work.
>>>> So if we don't call vhost_dev_ioctl(), we will need to
>>>> call vhost_dev_set_owner() directly.
>> I may miss something, it looks to me the there's no owner check in
>> vhost_vring_ioctl() and the vhost_poll_start() can make sure handle_kick
>> works?
> Yeah, there is no owner check in vhost_vring_ioctl().
> IIUC, vhost_poll_start() will start polling the file. And when
> event arrives, vhost_poll_wakeup() will be called, and it will
> queue work to work_list and wakeup worker to finish the work.
> And the worker is created by vhost_dev_set_owner().
>

Right, rethink about this. It looks to me we need:

- Keep VHOST_SET_OWNER, this could be used for future control vq where=20
it needs a kthread to access the userspace memory

- Temporarily filter=C2=A0 SET_LOG_BASE and SET_LOG_FD until we finalize th=
e=20
API for dirty page tracking.

- For kick through kthread, it looks sub-optimal but we can address this=20
in the future, e.g call handle_vq_kick directly in vhost_poll_queue=20
(probably a flag for vhost_poll) and deal with the synchronization in=20
vhost_poll_flush carefully.

Thanks


