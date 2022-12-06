Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819EA643D34
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 07:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiLFGnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 01:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLFGnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 01:43:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59E826571
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 22:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670308949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9/m/LKEM8E8gWvLZfOCL85LkossT//XPtieS+3hIIhc=;
        b=bz9ZowKj94nsZuALOPJWnCIfWm0ZmbJFTlMUbCHjuHvxm6tKrfPe2sv+Jb5N2A7JbTizE7
        KvhDYSa3nG7XAhGZ7hLKbuRlyEjjbxonqgnwt/5anXIP2rlbE2UXA8BIwm67z6EYWnTzk0
        PkD2/Q1MQl9HvGMbxhww1aW8Gjz5BG0=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-148-Wmafv0rBN6We3ToNe3C7hA-1; Tue, 06 Dec 2022 01:42:26 -0500
X-MC-Unique: Wmafv0rBN6We3ToNe3C7hA-1
Received: by mail-ot1-f72.google.com with SMTP id cd15-20020a056830620f00b0066e293d93caso7870797otb.8
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 22:42:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9/m/LKEM8E8gWvLZfOCL85LkossT//XPtieS+3hIIhc=;
        b=fSbTTKJ5SOvUvF9kui3Ije9deoqwfMCA1q74qF+OQnaFx8pQDFwCqi9Ygreo+3B1Vx
         8zQGewv2UTkP6S/kQt/4y+KVa5i1c89U3EbZn6vkW1vs6MFQpVxwSGWPohQoOEkxMFw3
         OEIy4VnWDmvlYV8xTx05zKVyY7NTunHUQ/bcVIC81xLJ7/CcgPcQ8R/ALToOB5FPuK6Z
         KC+cz4BvXDet1VNQdEnoaWNkjkJ1zAwH8zWt6Wo14mGRwDuSywteOZzpXrShicXvawan
         NYOnmBM7rKHEiwcPxR58R11M8jzA5TZCivxr8ussTRiCIpoHOlyGtFNkAemfycIYSqSZ
         lhcw==
X-Gm-Message-State: ANoB5pmeIr5RKr9tB+zaIuLP9K9tOkQTxJCPY4hlOhmShdfuxrjN6Omh
        r6WcBhLurlWu2efDLLy+PY6oUlYvbkt/WXrpgS3Fpk8Eh7hDIETAlOzDMj9qkLef9tAadOpuLY4
        kVRpzRGxQ9Ew5UonHwgJQ+oE05IELJuHn
X-Received: by 2002:a05:6870:b9b:b0:144:b22a:38d3 with SMTP id lg27-20020a0568700b9b00b00144b22a38d3mr2765598oab.280.1670308945570;
        Mon, 05 Dec 2022 22:42:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6HV/xZ/HG4/5jJbnBTSk5WGlj3qqcglUA80mK4pOlvA5TfI1GgyNRYpPF7uNQ2rReqhWQHgoK4yrfEuzHx1Wk=
X-Received: by 2002:a05:6870:b9b:b0:144:b22a:38d3 with SMTP id
 lg27-20020a0568700b9b00b00144b22a38d3mr2765592oab.280.1670308945316; Mon, 05
 Dec 2022 22:42:25 -0800 (PST)
MIME-Version: 1.0
References: <20221122074348.88601-1-hengqi@linux.alibaba.com> <20221122074348.88601-10-hengqi@linux.alibaba.com>
In-Reply-To: <20221122074348.88601-10-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 6 Dec 2022 14:42:14 +0800
Message-ID: <CACGkMEsd75VYCeSSQo_H6+0reNxQsAMSamNr-_k3ndJ-ToJHHQ@mail.gmail.com>
Subject: Re: [RFC PATCH 9/9] virtio_net: support multi-buffer xdp
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
> Driver can pass the skb to stack by build_skb_from_xdp_buff().
>
> Driver forwards multi-buffer packets using the send queue
> when XDP_TX and XDP_REDIRECT, and clears the reference of multi
> pages when XDP_DROP.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 65 ++++++----------------------------------
>  1 file changed, 9 insertions(+), 56 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 431f2126a2b5..bbd5cd9bfd47 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1065,7 +1065,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>         struct bpf_prog *xdp_prog;
>         unsigned int truesize = mergeable_ctx_to_truesize(ctx);
>         unsigned int headroom = mergeable_ctx_to_headroom(ctx);
> -       unsigned int metasize = 0;
>         unsigned int frame_sz;
>         int err;
>
> @@ -1137,63 +1136,22 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>
>                 switch (act) {
>                 case XDP_PASS:
> -                       metasize = xdp.data - xdp.data_meta;
> -
> -                       /* recalculate offset to account for any header
> -                        * adjustments and minus the metasize to copy the
> -                        * metadata in page_to_skb(). Note other cases do not
> -                        * build an skb and avoid using offset
> -                        */
> -                       offset = xdp.data - page_address(xdp_page) -
> -                                vi->hdr_len - metasize;
> -
> -                       /* recalculate len if xdp.data, xdp.data_end or
> -                        * xdp.data_meta were adjusted
> -                        */
> -                       len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
> -
> -                       /* recalculate headroom if xdp.data or xdp_data_meta
> -                        * were adjusted, note that offset should always point
> -                        * to the start of the reserved bytes for virtio_net
> -                        * header which are followed by xdp.data, that means
> -                        * that offset is equal to the headroom (when buf is
> -                        * starting at the beginning of the page, otherwise
> -                        * there is a base offset inside the page) but it's used
> -                        * with a different starting point (buf start) than
> -                        * xdp.data (buf start + vnet hdr size). If xdp.data or
> -                        * data_meta were adjusted by the xdp prog then the
> -                        * headroom size has changed and so has the offset, we
> -                        * can use data_hard_start, which points at buf start +
> -                        * vnet hdr size, to calculate the new headroom and use
> -                        * it later to compute buf start in page_to_skb()
> -                        */
> -                       headroom = xdp.data - xdp.data_hard_start - metasize;
> -
> -                       /* We can only create skb based on xdp_page. */
> -                       if (unlikely(xdp_page != page)) {
> -                               rcu_read_unlock();
> -                               put_page(page);
> -                               head_skb = page_to_skb(vi, rq, xdp_page, offset,
> -                                                      len, PAGE_SIZE);
> -                               return head_skb;
> -                       }
> -                       break;
> +                       head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> +                       rcu_read_unlock();
> +                       return head_skb;
>                 case XDP_TX:
>                         stats->xdp_tx++;
>                         xdpf = xdp_convert_buff_to_frame(&xdp);
>                         if (unlikely(!xdpf)) {
> -                               if (unlikely(xdp_page != page))
> -                                       put_page(xdp_page);
> -                               goto err_xdp;
> +                               pr_debug("%s: convert buff to frame failed for xdp\n", dev->name);

netdev_dbg()?

Thanks

> +                               goto err_xdp_frags;
>                         }
>                         err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
>                         if (unlikely(!err)) {
>                                 xdp_return_frame_rx_napi(xdpf);
>                         } else if (unlikely(err < 0)) {
>                                 trace_xdp_exception(vi->dev, xdp_prog, act);
> -                               if (unlikely(xdp_page != page))
> -                                       put_page(xdp_page);
> -                               goto err_xdp;
> +                               goto err_xdp_frags;
>                         }
>                         *xdp_xmit |= VIRTIO_XDP_TX;
>                         if (unlikely(xdp_page != page))
> @@ -1203,11 +1161,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>                 case XDP_REDIRECT:
>                         stats->xdp_redirects++;
>                         err = xdp_do_redirect(dev, &xdp, xdp_prog);
> -                       if (err) {
> -                               if (unlikely(xdp_page != page))
> -                                       put_page(xdp_page);
> -                               goto err_xdp;
> -                       }
> +                       if (err)
> +                               goto err_xdp_frags;
>                         *xdp_xmit |= VIRTIO_XDP_REDIR;
>                         if (unlikely(xdp_page != page))
>                                 put_page(page);
> @@ -1220,9 +1175,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>                         trace_xdp_exception(vi->dev, xdp_prog, act);
>                         fallthrough;
>                 case XDP_DROP:
> -                       if (unlikely(xdp_page != page))
> -                               __free_pages(xdp_page, 0);
> -                       goto err_xdp;
> +                       goto err_xdp_frags;
>                 }
>  err_xdp_frags:
>                 shinfo = xdp_get_shared_info_from_buff(&xdp);
> --
> 2.19.1.6.gb485710b
>

