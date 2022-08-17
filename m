Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351C6596D1A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbiHQKyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiHQKyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:54:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD014A828
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660733642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gWHtHY6d40uY0Ij4s58yaxGtL5XuSJS0/N+jf5H/pmM=;
        b=S8+n9d3Kax4NRRwTfe9hCHnS0x43t5BvUwNfVbbp8VBEi6ndhK9Y15mKdOCFx+MSZ5+Uwi
        sF3WUmXKrMhtgWLak5q6Pj8lyU8htzgmXEgXfkOBL7qUbaLV4VT5sQoGeQSXzVBTo21pD1
        6iP3wN9tU5lGa6efxaZd/aVjhomF5bc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-LEVBB3SgP0KT0yoB2wMWYQ-1; Wed, 17 Aug 2022 06:54:00 -0400
X-MC-Unique: LEVBB3SgP0KT0yoB2wMWYQ-1
Received: by mail-wm1-f70.google.com with SMTP id f18-20020a05600c4e9200b003a5f81299caso3072427wmq.7
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=gWHtHY6d40uY0Ij4s58yaxGtL5XuSJS0/N+jf5H/pmM=;
        b=NPzK2WIH6XIZAfT/h+3dI5emb5rfTZr57PmvRlD63n1oXLKxRuEaDrSo2JT4kQMGBn
         Ch6zNTwynxGn+x4pXXyfUUjzTL7M0U/Sj95KxO2BRZI+ZPPCg+E+ZcQ8UL28/eciRrod
         nRoLKwODz98oxu/5j3S0hMEmZ+jt4yu9PU5YN8XWMwPCUPjcGmqNFE4ua//hVSEUVici
         U7OlDZv40EMbfA5VGnvu8A78ufw3WLMBTjcmMNsIZyT6LkLAWvgniYp/DG+XiZRYapoU
         LeQcCqA4UCRNJsSiUWU9FgfmVJgVLsSt5RUbCcNl4aq8Xa1OTfTe0WFNV5hPq+jiy1IW
         wQ/g==
X-Gm-Message-State: ACgBeo3JMMU8/fP50hNNsSgAIiJ+ep3y5igNPHqWAsYhV7q2C2HsZFwx
        X19ZVWsXtLQ8bTOHEmDa3eAWP0oigG3S8N1ejVQFEpTI9tYLE38JstzKsicFHTERv+aRDu3nRfn
        fbIe/++IOfMCz29xn
X-Received: by 2002:a05:600c:4e11:b0:3a5:bfd3:a899 with SMTP id b17-20020a05600c4e1100b003a5bfd3a899mr1743696wmq.185.1660733639795;
        Wed, 17 Aug 2022 03:53:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7d/IR607lJwmB2S6Sw1FJB/dSOGJPbcoQRDZgxOs2ObvWS+6e3HgFTFDQjrws5pZac+mb1Cw==
X-Received: by 2002:a05:600c:4e11:b0:3a5:bfd3:a899 with SMTP id b17-20020a05600c4e1100b003a5bfd3a899mr1743679wmq.185.1660733639576;
        Wed, 17 Aug 2022 03:53:59 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id p27-20020a05600c1d9b00b003a35ec4bf4fsm1905896wms.20.2022.08.17.03.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 03:53:59 -0700 (PDT)
Date:   Wed, 17 Aug 2022 06:53:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        James.Bottomley@hansenpartnership.com, andres@anarazel.de,
        axboe@kernel.dk, c@redhat.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        jasowang@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, martin.petersen@oracle.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        torvalds@linux-foundation.org,
        virtualization@lists.linux-foundation.org,
        kasan-dev@googlegroups.com
Subject: Re: upstream kernel crashes
Message-ID: <20220817065207-mutt-send-email-mst@kernel.org>
References: <20220815113729-mutt-send-email-mst@kernel.org>
 <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de>
 <20220815124748-mutt-send-email-mst@kernel.org>
 <20220815174617.z4chnftzcbv6frqr@awork3.anarazel.de>
 <20220815161423-mutt-send-email-mst@kernel.org>
 <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de>
 <20220815170444-mutt-send-email-mst@kernel.org>
 <20220817061359.200970-1-dvyukov@google.com>
 <1660718191.3631961-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1660718191.3631961-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 02:36:31PM +0800, Xuan Zhuo wrote:
> On Wed, 17 Aug 2022 08:13:59 +0200, Dmitry Vyukov <dvyukov@google.com> wrote:
> > On Mon, 15 Aug 2022 17:32:06 -0400, Michael wrote:
> > > So if you pass the size parameter for a legacy device it will
> > > try to make the ring smaller and that is not legal with
> > > legacy at all. But the driver treats legacy and modern
> > > the same, it allocates a smaller queue anyway.
> > >
> > > Lo and behold, I pass disable-modern=on to qemu and it happily
> > > corrupts memory exactly the same as GCP does.
> >
> > Ouch!
> >
> > I understand that the host does the actual corruption,
> > but could you think of any additional debug checking in the guest
> > that would caught this in future? Potentially only when KASAN
> > is enabled which can verify validity of memory ranges.
> > Some kind of additional layer of sanity checking.
> >
> > This caused a bit of a havoc for syzbot with almost 100 unique
> > crash signatures, so would be useful to catch such issues more
> > reliably in future.
> 
> We can add a check to vring size before calling vp_legacy_set_queue_address().
> Checking the memory range directly is a bit cumbersome.
> 
> Thanks.

With a comment along the lines of

/* Legacy virtio pci has no way to communicate a change in vq size to
 * the hypervisor. If ring sizes don't match hypervisor will happily
 * corrupt memory.
 */


> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> index 2257f1b3d8ae..0673831f45b6 100644
> --- a/drivers/virtio/virtio_pci_legacy.c
> +++ b/drivers/virtio/virtio_pci_legacy.c
> @@ -146,6 +146,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>                 goto out_del_vq;
>         }
> 
> +       BUG_ON(num != virtqueue_get_vring_size(vq));
> +
>         /* activate the queue */
>         vp_legacy_set_queue_address(&vp_dev->ldev, index, q_pfn);
> 
> 
> >
> > Thanks

