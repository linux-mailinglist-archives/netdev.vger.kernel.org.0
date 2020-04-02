Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE78719C3F6
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733014AbgDBOYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:24:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732823AbgDBOYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:24:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585837476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jwultuJVHkd9Ea7iycYokx+RDR7CVNFkggWBY1P0GTQ=;
        b=cuEtq7CItX4KSehmZw6i0GyN59CJvo9YFWA7k8+xqULT93ySHLy/U8RljJq7hRoF3+tDtG
        VZ5kNq3M3fvtnPD+O5PAkJ3ZMWBD6e/Jby/8EWV02NqbfqDsFiS5C85sDWfVB8lJBfJ+GY
        zGcrAEMveETyX3F/GlxQS/wSC86hzh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-FMcVsSpPMIurF4xDneMD2A-1; Thu, 02 Apr 2020 10:18:28 -0400
X-MC-Unique: FMcVsSpPMIurF4xDneMD2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1188107BAAB;
        Thu,  2 Apr 2020 14:18:26 +0000 (UTC)
Received: from [10.72.12.172] (ovpn-12-172.pek2.redhat.com [10.72.12.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF1C95D9C9;
        Thu,  2 Apr 2020 14:18:18 +0000 (UTC)
Subject: Re: [PATCH] virtio/test: fix up after IOTLB changes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200401165100.276039-1-mst@redhat.com>
 <921fe999-e183-058d-722a-1a6a6ab066e0@redhat.com>
 <20200402084021-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <481b8f28-e3a9-dda1-bfb7-df72b11e4073@redhat.com>
Date:   Thu, 2 Apr 2020 22:18:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200402084021-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/2 =E4=B8=8B=E5=8D=888:53, Michael S. Tsirkin wrote:
> On Thu, Apr 02, 2020 at 12:01:56PM +0800, Jason Wang wrote:
>> On 2020/4/2 =E4=B8=8A=E5=8D=8812:51, Michael S. Tsirkin wrote:
>>> Allow building vringh without IOTLB (that's the case for userspace
>>> builds, will be useful for CAIF/VOD down the road too).
>>> Update for API tweaks.
>>> Don't include vringh with kernel builds.
>>
>> I'm not quite sure we need this.
>>
>> E.g the userspace accessor is not used by CAIF/VOP.
> Well any exported symbols are always compiled in, right?
> So we can save some kernel memory by not building unused stuff ...


Yes, just want to mention that the there's no user for userspace=20
accessors now.


>
>
>>> Cc: Jason Wang <jasowang@redhat.com>
>>> Cc: Eugenio P=C3=A9rez <eperezma@redhat.com>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>>    drivers/vhost/test.c   | 4 ++--
>>>    drivers/vhost/vringh.c | 5 +++++
>>>    include/linux/vringh.h | 2 ++
>>>    tools/virtio/Makefile  | 3 ++-
>>>    4 files changed, 11 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
>>> index 394e2e5c772d..9a3a09005e03 100644
>>> --- a/drivers/vhost/test.c
>>> +++ b/drivers/vhost/test.c
>>> @@ -120,7 +120,7 @@ static int vhost_test_open(struct inode *inode, s=
truct file *f)
>>>    	vqs[VHOST_TEST_VQ] =3D &n->vqs[VHOST_TEST_VQ];
>>>    	n->vqs[VHOST_TEST_VQ].handle_kick =3D handle_vq_kick;
>>>    	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
>>> -		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
>>> +		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
>>>    	f->private_data =3D n;
>>> @@ -225,7 +225,7 @@ static long vhost_test_reset_owner(struct vhost_t=
est *n)
>>>    {
>>>    	void *priv =3D NULL;
>>>    	long err;
>>> -	struct vhost_umem *umem;
>>> +	struct vhost_iotlb *umem;
>>>    	mutex_lock(&n->dev.mutex);
>>>    	err =3D vhost_dev_check_owner(&n->dev);
>>> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>>> index ee0491f579ac..878e565dfffe 100644
>>> --- a/drivers/vhost/vringh.c
>>> +++ b/drivers/vhost/vringh.c
>>> @@ -13,9 +13,11 @@
>>>    #include <linux/uaccess.h>
>>>    #include <linux/slab.h>
>>>    #include <linux/export.h>
>>> +#ifdef VHOST_IOTLB
>>
>> Kbuild bot reports build issues with this.
>>
>> It looks to me we should use #if IS_ENABLED(CONFIG_VHOST_IOTLB) here a=
nd
>> following checks.
>>
>> Thanks
>>
> In fact IS_REACHEABLE is probably the right thing to do.


Yes.

Thanks


>
>
>>>    #include <linux/bvec.h>
>>>    #include <linux/highmem.h>
>>>    #include <linux/vhost_iotlb.h>
>>> +#endif
>>>    #include <uapi/linux/virtio_config.h>
>>>    static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
>>> @@ -1059,6 +1061,8 @@ int vringh_need_notify_kern(struct vringh *vrh)
>>>    }
>>>    EXPORT_SYMBOL(vringh_need_notify_kern);
>>> +#ifdef VHOST_IOTLB
>>> +
>>>    static int iotlb_translate(const struct vringh *vrh,
>>>    			   u64 addr, u64 len, struct bio_vec iov[],
>>>    			   int iov_size, u32 perm)
>>> @@ -1416,5 +1420,6 @@ int vringh_need_notify_iotlb(struct vringh *vrh=
)
>>>    }
>>>    EXPORT_SYMBOL(vringh_need_notify_iotlb);
>>> +#endif
>>>    MODULE_LICENSE("GPL");
>>> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
>>> index bd0503ca6f8f..ebff121c0b02 100644
>>> --- a/include/linux/vringh.h
>>> +++ b/include/linux/vringh.h
>>> @@ -14,8 +14,10 @@
>>>    #include <linux/virtio_byteorder.h>
>>>    #include <linux/uio.h>
>>>    #include <linux/slab.h>
>>> +#ifdef VHOST_IOTLB
>>>    #include <linux/dma-direction.h>
>>>    #include <linux/vhost_iotlb.h>
>>> +#endif
>>>    #include <asm/barrier.h>
>>>    /* virtio_ring with information needed for host access. */
>>> diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
>>> index f33f32f1d208..d3f152f4660b 100644
>>> --- a/tools/virtio/Makefile
>>> +++ b/tools/virtio/Makefile
>>> @@ -22,7 +22,8 @@ OOT_CONFIGS=3D\
>>>    	CONFIG_VHOST=3Dm \
>>>    	CONFIG_VHOST_NET=3Dn \
>>>    	CONFIG_VHOST_SCSI=3Dn \
>>> -	CONFIG_VHOST_VSOCK=3Dn
>>> +	CONFIG_VHOST_VSOCK=3Dn \
>>> +	CONFIG_VHOST_RING=3Dn
>>>    OOT_BUILD=3DKCFLAGS=3D"-I "${OOT_VHOST} ${MAKE} -C ${OOT_KSRC} V=3D=
${V}
>>>    oot-build:
>>>    	echo "UNSUPPORTED! Don't use the resulting modules in production!=
"

