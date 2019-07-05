Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425695FF04
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 02:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfGEAS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 20:18:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfGEAS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 20:18:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B0D8530001E2;
        Fri,  5 Jul 2019 00:18:56 +0000 (UTC)
Received: from [10.72.12.202] (ovpn-12-202.pek2.redhat.com [10.72.12.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81CA517795;
        Fri,  5 Jul 2019 00:18:45 +0000 (UTC)
Subject: Re: [PATCH v2 1/3] vsock/virtio: use RCU to avoid use-after-free on
 the_virtio_vsock
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190628123659.139576-2-sgarzare@redhat.com>
 <05311244-ed23-d061-a620-7b83d83c11f5@redhat.com>
 <20190703104135.wg34dobv64k7u4jo@steredhat>
 <07e5bc00-ebde-4dac-d38c-f008fa230b5f@redhat.com>
 <20190704092044.23gd5o2rhqarisgg@steredhat.homenet.telecomitalia.it>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <23c014de-90b5-1de2-a118-63ec242cbf62@redhat.com>
Date:   Fri, 5 Jul 2019 08:18:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704092044.23gd5o2rhqarisgg@steredhat.homenet.telecomitalia.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 05 Jul 2019 00:18:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/4 下午5:20, Stefano Garzarella wrote:
>>>> This is still suspicious, can we access the_virtio_vsock through vdev->priv?
>>>> If yes, we may still get use-after-free since it was not protected by RCU.
>>> We will free the object only after calling the del_vqs(), so we are sure
>>> that the vq_callbacks ended and will no longer be invoked.
>>> So, IIUC it shouldn't happen.
>> Yes, but any dereference that is not done in vq_callbacks will be very
>> dangerous in the future.
> Right.
>
> Do you think make sense to continue with this series in order to fix the
> hot-unplug issue, then I'll work to refactor the driver code to use the refcnt
> (as you suggested in patch 2) and singleton for the_virtio_vsock?
>
> Thanks,
> Stefano


Yes.

Thanks

