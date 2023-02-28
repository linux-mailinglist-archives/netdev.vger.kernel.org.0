Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0FD6A569F
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjB1K1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjB1K1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:27:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC1F1F5C3
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677579987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MDfMtxXzFQrOJbPCiOn60FjJ4o5RbbkA4AqIa3ieAbM=;
        b=NVFhnUp26w/UTdrZj39PgpbwmuAJnrxbp3LNscZsAd8zgoQRWWnt6QF9J/pISF2+0xP2eK
        jia4eJQit8Lfn1JVfB72gyimG3NHziEAEN8tti62vGekraWSiHfiljjHew/yPA93C0RiTA
        dZuQFNKqZWSKCGEGUJDqkh3pOH4g9VE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-391-LenQzc39N1a4q-ziAi-s4g-1; Tue, 28 Feb 2023 05:26:25 -0500
X-MC-Unique: LenQzc39N1a4q-ziAi-s4g-1
Received: by mail-wr1-f71.google.com with SMTP id q7-20020a05600000c700b002cd9188abe5so173643wrx.3
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MDfMtxXzFQrOJbPCiOn60FjJ4o5RbbkA4AqIa3ieAbM=;
        b=f7ABtVvOjNilFYr/am+08gcvAPuRtspn2XL+MGd3usGOKGRbtQKeGLpndSJvm/F36E
         foTO5fTNz6QG2VfOb87X3WiG1sxN0xbl7eSGTf43K875ZH0m50GWiXtP5I1v/4h5jsvn
         Wo8HRVRTv4k8mJJ/FVak5NFePQ8KBjChhpdYdPFJemrDaXsFgYTGGq7oz8uZnpPvIQhZ
         bCetLeAo+WzJdYQBSpMGAn+XnYOJG+WRIG7CUvbHgROaP72xTTHdUrlxjWy0SMu1tqxS
         gGz4Yj1TKcAKbHQLEaMWNamXNkerRGKm05Gjxl2flZeXj60/7SV5as+aazdf2DecPUmC
         643w==
X-Gm-Message-State: AO0yUKUSYW5hA62IYmHtJIhuXdPFccP6KRahUNVHSDNlYgqTub/WCTGh
        M3McqI2H4eo/0wj23S6v5Es69/+huMSva7IsALjFrCTk5JG7D+v2tMvIHq6pBD733KwEnW+xyfw
        AOVMrAvTzJWtCT/Ra
X-Received: by 2002:a05:600c:4b28:b0:3eb:39e7:35fe with SMTP id i40-20020a05600c4b2800b003eb39e735femr1619719wmp.30.1677579984450;
        Tue, 28 Feb 2023 02:26:24 -0800 (PST)
X-Google-Smtp-Source: AK7set/C6MKWw0xixGzqMyKbw92PptZzuISaOIFG9J8ILfyAAEOfPLXJ9kl34y318rcejVMrMLMjgw==
X-Received: by 2002:a05:600c:4b28:b0:3eb:39e7:35fe with SMTP id i40-20020a05600c4b2800b003eb39e735femr1619707wmp.30.1677579984138;
        Tue, 28 Feb 2023 02:26:24 -0800 (PST)
Received: from sgarzare-redhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id n41-20020a05600c3ba900b003e20fa01a86sm12877242wms.13.2023.02.28.02.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 02:26:23 -0800 (PST)
Date:   Tue, 28 Feb 2023 11:26:19 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 07/12] vsock/virtio: MGS_ZEROCOPY flag support
Message-ID: <20230228102619.yevqfgx2vj5aeyn4@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <716333a1-d6d1-3dde-d04a-365d4a361bfe@sberdevices.ru>
 <20230216151622.xu5jhha3wvc3us2b@sgarzare-redhat>
 <f76705ca-f20a-3286-3c61-46a953518991@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f76705ca-f20a-3286-3c61-46a953518991@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 09:04:04AM +0000, Krasnov Arseniy wrote:
>On 16.02.2023 18:16, Stefano Garzarella wrote:
>> On Mon, Feb 06, 2023 at 07:00:35AM +0000, Arseniy Krasnov wrote:
>>> This adds main logic of MSG_ZEROCOPY flag processing for packet
>>> creation. When this flag is set and user's iov iterator fits for
>>> zerocopy transmission, call 'get_user_pages()' and add returned
>>> pages to the newly created skb.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> net/vmw_vsock/virtio_transport_common.c | 212 ++++++++++++++++++++++--
>>> 1 file changed, 195 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index 05ce97b967ad..69e37f8a68a6 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -37,6 +37,169 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
>>>     return container_of(t, struct virtio_transport, transport);
>>> }
>>>
>>
>> I'd use bool if we don't need to return an error value in the following
>> new functions.
>>
>>> +static int virtio_transport_can_zcopy(struct iov_iter *iov_iter,
>>> +                      size_t free_space)
>>> +{
>>> +    size_t pages;
>>> +    int i;
>>> +
>>> +    if (!iter_is_iovec(iov_iter))
>>> +        return -1;
>>> +
>>> +    if (iov_iter->iov_offset)
>>> +        return -1;
>>> +
>>> +    /* We can't send whole iov. */
>>> +    if (free_space < iov_iter->count)
>>> +        return -1;
>>> +
>>> +    for (pages = 0, i = 0; i < iov_iter->nr_segs; i++) {
>>> +        const struct iovec *iovec;
>>> +        int pages_in_elem;
>>> +
>>> +        iovec = &iov_iter->iov[i];
>>> +
>>> +        /* Base must be page aligned. */
>>> +        if (offset_in_page(iovec->iov_base))
>>> +            return -1;
>>> +
>>> +        /* Only last element could have not page aligned size.  */
>>> +        if (i != (iov_iter->nr_segs - 1)) {
>>> +            if (offset_in_page(iovec->iov_len))
>>> +                return -1;
>>> +
>>> +            pages_in_elem = iovec->iov_len >> PAGE_SHIFT;
>>> +        } else {
>>> +            pages_in_elem = round_up(iovec->iov_len, PAGE_SIZE);
>>> +            pages_in_elem >>= PAGE_SHIFT;
>>> +        }
>>> +
>>> +        /* In case of user's pages - one page is one frag. */
>>> +        if (pages + pages_in_elem > MAX_SKB_FRAGS)
>>> +            return -1;
>>> +
>>> +        pages += pages_in_elem;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
>>> +                       struct sk_buff *skb,
>>> +                       struct iov_iter *iter,
>>> +                       bool zerocopy)
>>> +{
>>> +    struct ubuf_info_msgzc *uarg_zc;
>>> +    struct ubuf_info *uarg;
>>> +
>>> +    uarg = msg_zerocopy_realloc(sk_vsock(vsk),
>>> +                    iov_length(iter->iov, iter->nr_segs),
>>> +                    NULL);
>>> +
>>> +    if (!uarg)
>>> +        return -1;
>>> +
>>> +    uarg_zc = uarg_to_msgzc(uarg);
>>> +    uarg_zc->zerocopy = zerocopy ? 1 : 0;
>>> +
>>> +    skb_zcopy_init(skb, uarg);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int virtio_transport_fill_nonlinear_skb(struct sk_buff *skb,
>>> +                           struct vsock_sock *vsk,
>>> +                           struct virtio_vsock_pkt_info *info)
>>> +{
>>> +    struct iov_iter *iter;
>>> +    int frag_idx;
>>> +    int seg_idx;
>>> +
>>> +    iter = &info->msg->msg_iter;
>>> +    frag_idx = 0;
>>> +    VIRTIO_VSOCK_SKB_CB(skb)->curr_frag = 0;
>>> +    VIRTIO_VSOCK_SKB_CB(skb)->frag_off = 0;
>>> +
>>> +    /* At this moment:
>>> +     * 1) 'iov_offset' is zero.
>>> +     * 2) Every 'iov_base' and 'iov_len' are also page aligned
>>> +     *    (except length of the last element).
>>> +     * 3) Number of pages in this iov <= MAX_SKB_FRAGS.
>>> +     * 4) Length of the data fits in current credit space.
>>> +     */
>>> +    for (seg_idx = 0; seg_idx < iter->nr_segs; seg_idx++) {
>>> +        struct page *user_pages[MAX_SKB_FRAGS];
>>> +        const struct iovec *iovec;
>>> +        size_t last_frag_len;
>>> +        size_t pages_in_seg;
>>> +        int page_idx;
>>> +
>>> +        iovec = &iter->iov[seg_idx];
>>> +        pages_in_seg = iovec->iov_len >> PAGE_SHIFT;
>>> +
>>> +        if (iovec->iov_len % PAGE_SIZE) {
>>> +            last_frag_len = iovec->iov_len % PAGE_SIZE;
>>> +            pages_in_seg++;
>>> +        } else {
>>> +            last_frag_len = PAGE_SIZE;
>>> +        }
>>> +
>>> +        if (get_user_pages((unsigned long)iovec->iov_base,
>>> +                   pages_in_seg, FOLL_GET, user_pages,
>>> +                   NULL) != pages_in_seg)
>>> +            return -1;
>>
>> Reading the get_user_pages() documentation, this should pin the user
>> pages, so we should be fine if we then expose them in the virtqueue.
>>
>> But reading Documentation/core-api/pin_user_pages.rst it seems that
>> drivers should use "pin_user_pages*() for DMA-pinned pages", so I'm not
>> sure what we should do.
>>
>That is really interesting question for me too. IIUC 'pin_user_pages()'
>sets special value to ref counter of page, so we can distinguish such
>pages from the others. I've grepped for pinned pages check and found,
>the it is used in mm/vmscan.c by calling 'folio_maybe_dma_pinned()' during
>page lists processing. Seems 'pin_user_pages()' is more strict version of
>'get_user_pages()' and it is recommended to use 'pin_' when data on these
>pages will be accessed.
>I think, i'll check which API is used in the TCP implementation for zerocopy
>transmission.
>
>> Additional advice would be great!
>>
>> Anyway, when we are done using the pages, we should call put_page() or
>> unpin_user_page() depending on how we pin them.
>>
>In case of 'get_user_pages()' everything is ok here: when such skb
>will be released, 'put_page()' will be called for every frag page
>of it, so there is no page leak.

Got it!

>But in case of 'pin_user_pages()',
>i will need to unpin in manually before calling 'consume_skb()'
>after it is processed by virtio device. But anyway - it is not a
>problem.

Yep.

Thanks,
Stefano

