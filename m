Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460C81ECF5E
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 14:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgFCME5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 08:04:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725855AbgFCME5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 08:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591185895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I1hAyly7NhesZ77QwDd9STwcXrPYKxChvgkxKRkQ9hs=;
        b=AdFRxCnTY55kr19C0XbsRvYziO3o+KYWOcai1JbuJTCOSlMnFu3oB8qPZK6kOZMjgr0EWO
        x9n5McygfQ1HSAQsGpRJ+mLovzF9ffL6s2PHrQ4Yb5AfdXmvAQp7NebVLfa0ERazk9nP58
        5+ODqB8TIxbxY7aeocllUKY+fwrEpyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-XUmdhkusMDq-jhTXjwZ9aA-1; Wed, 03 Jun 2020 08:04:53 -0400
X-MC-Unique: XUmdhkusMDq-jhTXjwZ9aA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72AFD8018A5;
        Wed,  3 Jun 2020 12:04:52 +0000 (UTC)
Received: from [10.72.12.129] (ovpn-12-129.pek2.redhat.com [10.72.12.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32ECD10013D7;
        Wed,  3 Jun 2020 12:04:46 +0000 (UTC)
Subject: Re: [PATCH RFC 01/13] vhost: option to fetch descriptors through an
 independent struct
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-2-mst@redhat.com>
 <e35e5df9-7e36-227e-7981-232a62b06607@redhat.com>
 <20200603045825-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <48e6d644-c4aa-2754-9d06-22133987b3be@redhat.com>
Date:   Wed, 3 Jun 2020 20:04:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603045825-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/3 下午5:48, Michael S. Tsirkin wrote:
> On Wed, Jun 03, 2020 at 03:13:56PM +0800, Jason Wang wrote:
>> On 2020/6/2 下午9:05, Michael S. Tsirkin wrote:


[...]


>>> +
>>> +static int fetch_indirect_descs(struct vhost_virtqueue *vq,
>>> +				struct vhost_desc *indirect,
>>> +				u16 head)
>>> +{
>>> +	struct vring_desc desc;
>>> +	unsigned int i = 0, count, found = 0;
>>> +	u32 len = indirect->len;
>>> +	struct iov_iter from;
>>> +	int ret;
>>> +
>>> +	/* Sanity check */
>>> +	if (unlikely(len % sizeof desc)) {
>>> +		vq_err(vq, "Invalid length in indirect descriptor: "
>>> +		       "len 0x%llx not multiple of 0x%zx\n",
>>> +		       (unsigned long long)len,
>>> +		       sizeof desc);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	ret = translate_desc(vq, indirect->addr, len, vq->indirect,
>>> +			     UIO_MAXIOV, VHOST_ACCESS_RO);
>>> +	if (unlikely(ret < 0)) {
>>> +		if (ret != -EAGAIN)
>>> +			vq_err(vq, "Translation failure %d in indirect.\n", ret);
>>> +		return ret;
>>> +	}
>>> +	iov_iter_init(&from, READ, vq->indirect, ret, len);
>>> +
>>> +	/* We will use the result as an address to read from, so most
>>> +	 * architectures only need a compiler barrier here. */
>>> +	read_barrier_depends();
>>> +
>>> +	count = len / sizeof desc;
>>> +	/* Buffers are chained via a 16 bit next field, so
>>> +	 * we can have at most 2^16 of these. */
>>> +	if (unlikely(count > USHRT_MAX + 1)) {
>>> +		vq_err(vq, "Indirect buffer length too big: %d\n",
>>> +		       indirect->len);
>>> +		return -E2BIG;
>>> +	}
>>> +	if (unlikely(vq->ndescs + count > vq->max_descs)) {
>>> +		vq_err(vq, "Too many indirect + direct descs: %d + %d\n",
>>> +		       vq->ndescs, indirect->len);
>>> +		return -E2BIG;
>>> +	}
>>> +
>>> +	do {
>>> +		if (unlikely(++found > count)) {
>>> +			vq_err(vq, "Loop detected: last one at %u "
>>> +			       "indirect size %u\n",
>>> +			       i, count);
>>> +			return -EINVAL;
>>> +		}
>>> +		if (unlikely(!copy_from_iter_full(&desc, sizeof(desc), &from))) {
>>> +			vq_err(vq, "Failed indirect descriptor: idx %d, %zx\n",
>>> +			       i, (size_t)indirect->addr + i * sizeof desc);
>>> +			return -EINVAL;
>>> +		}
>>> +		if (unlikely(desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT))) {
>>> +			vq_err(vq, "Nested indirect descriptor: idx %d, %zx\n",
>>> +			       i, (size_t)indirect->addr + i * sizeof desc);
>>> +			return -EINVAL;
>>> +		}
>>> +
>>> +		push_split_desc(vq, &desc, head);
>>
>> The error is ignored.
> See above:
>
>       	if (unlikely(vq->ndescs + count > vq->max_descs))
>
> So it can't fail here, we never fetch unless there's space.
>
> I guess we can add a WARN_ON here.


Yes.


>
>>> +	} while ((i = next_desc(vq, &desc)) != -1);
>>> +	return 0;
>>> +}
>>> +
>>> +static int fetch_descs(struct vhost_virtqueue *vq)
>>> +{
>>> +	unsigned int i, head, found = 0;
>>> +	struct vhost_desc *last;
>>> +	struct vring_desc desc;
>>> +	__virtio16 avail_idx;
>>> +	__virtio16 ring_head;
>>> +	u16 last_avail_idx;
>>> +	int ret;
>>> +
>>> +	/* Check it isn't doing very strange things with descriptor numbers. */
>>> +	last_avail_idx = vq->last_avail_idx;
>>> +
>>> +	if (vq->avail_idx == vq->last_avail_idx) {
>>> +		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
>>> +			vq_err(vq, "Failed to access avail idx at %p\n",
>>> +				&vq->avail->idx);
>>> +			return -EFAULT;
>>> +		}
>>> +		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
>>> +
>>> +		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
>>> +			vq_err(vq, "Guest moved used index from %u to %u",
>>> +				last_avail_idx, vq->avail_idx);
>>> +			return -EFAULT;
>>> +		}
>>> +
>>> +		/* If there's nothing new since last we looked, return
>>> +		 * invalid.
>>> +		 */
>>> +		if (vq->avail_idx == last_avail_idx)
>>> +			return vq->num;
>>> +
>>> +		/* Only get avail ring entries after they have been
>>> +		 * exposed by guest.
>>> +		 */
>>> +		smp_rmb();
>>> +	}
>>> +
>>> +	/* Grab the next descriptor number they're advertising */
>>> +	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
>>> +		vq_err(vq, "Failed to read head: idx %d address %p\n",
>>> +		       last_avail_idx,
>>> +		       &vq->avail->ring[last_avail_idx % vq->num]);
>>> +		return -EFAULT;
>>> +	}
>>> +
>>> +	head = vhost16_to_cpu(vq, ring_head);
>>> +
>>> +	/* If their number is silly, that's an error. */
>>> +	if (unlikely(head >= vq->num)) {
>>> +		vq_err(vq, "Guest says index %u > %u is available",
>>> +		       head, vq->num);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	i = head;
>>> +	do {
>>> +		if (unlikely(i >= vq->num)) {
>>> +			vq_err(vq, "Desc index is %u > %u, head = %u",
>>> +			       i, vq->num, head);
>>> +			return -EINVAL;
>>> +		}
>>> +		if (unlikely(++found > vq->num)) {
>>> +			vq_err(vq, "Loop detected: last one at %u "
>>> +			       "vq size %u head %u\n",
>>> +			       i, vq->num, head);
>>> +			return -EINVAL;
>>> +		}
>>> +		ret = vhost_get_desc(vq, &desc, i);
>>> +		if (unlikely(ret)) {
>>> +			vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
>>> +			       i, vq->desc + i);
>>> +			return -EFAULT;
>>> +		}
>>> +		ret = push_split_desc(vq, &desc, head);
>>> +		if (unlikely(ret)) {
>>> +			vq_err(vq, "Failed to save descriptor: idx %d\n", i);
>>> +			return -EINVAL;
>>> +		}
>>> +	} while ((i = next_desc(vq, &desc)) != -1);
>>> +
>>> +	last = peek_split_desc(vq);
>>> +	if (unlikely(last->flags & VRING_DESC_F_INDIRECT)) {
>>> +		pop_split_desc(vq);
>>> +		ret = fetch_indirect_descs(vq, last, head);
>>
>> Note that this means we don't supported chained indirect descriptors which
>> complies the spec but we support this in vhost_get_vq_desc().
> Well the spec says:
> 	A driver MUST NOT set both VIRTQ_DESC_F_INDIRECT and VIRTQ_DESC_F_NEXT in flags.
>
> Did I miss anything?
>

No, but I meant current vhost_get_vq_desc() supports chained indirect 
descriptor. Not sure if there's an application that depends on this 
silently.

Thanks


