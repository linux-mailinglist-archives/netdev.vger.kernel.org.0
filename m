Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5472919F7A2
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 16:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgDFOJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 10:09:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26271 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgDFOJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 10:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586182179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wl9a4vsMx6popLEQnps/1oTIMHKzOVah2HdwSj1HK4k=;
        b=T7SyR2U7n4VBR9Bh2c9woIcfyTHUtAtFbAW97hOYzPisY8dtsUonr83TsEVbNEBt4H7zBX
        +iXOnvqGaXcyuW297tsU71Miyzv+in//Fq4k6NaEYsrWyj8Rd5bp7AnAJK+odSE1mPbE1P
        SQ6u8NKdbmp2wBKgkc2bHSkZatKH+KI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-20pdoNKkNzyFdMakHIAuLg-1; Mon, 06 Apr 2020 10:09:35 -0400
X-MC-Unique: 20pdoNKkNzyFdMakHIAuLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DE5313F6;
        Mon,  6 Apr 2020 14:09:34 +0000 (UTC)
Received: from [10.72.12.191] (ovpn-12-191.pek2.redhat.com [10.72.12.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 115529D352;
        Mon,  6 Apr 2020 14:09:28 +0000 (UTC)
Subject: Re: [PATCH] vhost: force spec specified alignment on types
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200406124931.120768-1-mst@redhat.com>
 <045c84ed-151e-a850-9c72-5079bd2775e6@redhat.com>
 <20200406095424-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d171447e-eabc-60ab-6de7-41ac9b82d7d1@redhat.com>
Date:   Mon, 6 Apr 2020 22:09:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200406095424-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/6 =E4=B8=8B=E5=8D=889:55, Michael S. Tsirkin wrote:
> On Mon, Apr 06, 2020 at 09:34:00PM +0800, Jason Wang wrote:
>> On 2020/4/6 =E4=B8=8B=E5=8D=888:50, Michael S. Tsirkin wrote:
>>> The ring element addresses are passed between components with differe=
nt
>>> alignments assumptions. Thus, if guest/userspace selects a pointer an=
d
>>> host then gets and dereferences it, we might need to decrease the
>>> compiler-selected alignment to prevent compiler on the host from
>>> assuming pointer is aligned.
>>>
>>> This actually triggers on ARM with -mabi=3Dapcs-gnu - which is a
>>> deprecated configuration, but it seems safer to handle this
>>> generally.
>>>
>>> I verified that the produced binary is exactly identical on x86.
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>>
>>> This is my preferred way to handle the ARM incompatibility issues
>>> (in preference to kconfig hacks).
>>> I will push this into next now.
>>> Comments?
>>
>> I'm not sure if it's too late to fix. It would still be still problema=
tic
>> for the userspace that is using old uapi headers?
>>
>> Thanks
> It's not a problem in userspace. The problem is when
> userspace/guest uses 2 byte alignment and passes it to kernel
> assuming 8 byte alignment. The fix is for host not to
> make these assumptions.


Yes, but I meant when userspace is complied with apcs-gnu, then it still=20
assumes 8 byte alignment?

Thanks


>
>>>    drivers/vhost/vhost.h            |  6 ++---
>>>    include/uapi/linux/virtio_ring.h | 41 ++++++++++++++++++++++++----=
----
>>>    2 files changed, 34 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>>> index cc82918158d2..a67bda9792ec 100644
>>> --- a/drivers/vhost/vhost.h
>>> +++ b/drivers/vhost/vhost.h
>>> @@ -74,9 +74,9 @@ struct vhost_virtqueue {
>>>    	/* The actual ring of buffers. */
>>>    	struct mutex mutex;
>>>    	unsigned int num;
>>> -	struct vring_desc __user *desc;
>>> -	struct vring_avail __user *avail;
>>> -	struct vring_used __user *used;
>>> +	vring_desc_t __user *desc;
>>> +	vring_avail_t __user *avail;
>>> +	vring_used_t __user *used;
>>>    	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
>>>    	struct vhost_desc *descs;
>>> diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/vi=
rtio_ring.h
>>> index 559f42e73315..cd6e0b2eaf2f 100644
>>> --- a/include/uapi/linux/virtio_ring.h
>>> +++ b/include/uapi/linux/virtio_ring.h
>>> @@ -118,16 +118,6 @@ struct vring_used {
>>>    	struct vring_used_elem ring[];
>>>    };
>>> -struct vring {
>>> -	unsigned int num;
>>> -
>>> -	struct vring_desc *desc;
>>> -
>>> -	struct vring_avail *avail;
>>> -
>>> -	struct vring_used *used;
>>> -};
>>> -
>>>    /* Alignment requirements for vring elements.
>>>     * When using pre-virtio 1.0 layout, these fall out naturally.
>>>     */
>>> @@ -164,6 +154,37 @@ struct vring {
>>>    #define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
>>>    #define vring_avail_event(vr) (*(__virtio16 *)&(vr)->used->ring[(v=
r)->num])
>>> +/*
>>> + * The ring element addresses are passed between components with dif=
ferent
>>> + * alignments assumptions. Thus, we might need to decrease the compi=
ler-selected
>>> + * alignment, and so must use a typedef to make sure the __aligned a=
ttribute
>>> + * actually takes hold:
>>> + *
>>> + * https://gcc.gnu.org/onlinedocs//gcc/Common-Type-Attributes.html#C=
ommon-Type-Attributes
>>> + *
>>> + * When used on a struct, or struct member, the aligned attribute ca=
n only
>>> + * increase the alignment; in order to decrease it, the packed attri=
bute must
>>> + * be specified as well. When used as part of a typedef, the aligned=
 attribute
>>> + * can both increase and decrease alignment, and specifying the pack=
ed
>>> + * attribute generates a warning.
>>> + */
>>> +typedef struct vring_desc __attribute__((aligned(VRING_DESC_ALIGN_SI=
ZE)))
>>> +	vring_desc_t;
>>> +typedef struct vring_avail __attribute__((aligned(VRING_AVAIL_ALIGN_=
SIZE)))
>>> +	vring_avail_t;
>>> +typedef struct vring_used __attribute__((aligned(VRING_USED_ALIGN_SI=
ZE)))
>>> +	vring_used_t;
>>> +
>>> +struct vring {
>>> +	unsigned int num;
>>> +
>>> +	vring_desc_t *desc;
>>> +
>>> +	vring_avail_t *avail;
>>> +
>>> +	vring_used_t *used;
>>> +};
>>> +
>>>    static inline void vring_init(struct vring *vr, unsigned int num, =
void *p,
>>>    			      unsigned long align)
>>>    {

