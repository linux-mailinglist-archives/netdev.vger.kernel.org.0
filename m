Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CB96568AE
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 10:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiL0JFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 04:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiL0JFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 04:05:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292018FE5
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672131834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xwaWC7qhv1n472jAfAEwqv5nsnmhd0aYtU5tB8HHqyw=;
        b=G0fPcVQZjzP+NKlKonyFzdpmYskN8S9SGSnhuH0D2fO9pRgUKLdyBlWs3ih2NCAhhLXcdn
        IG1cfMPE7N4LCtyigkKH1TZNw90orUL87sy1Ehqd0XwBSrLlQBzELaHuHDP0aBTngb7LYZ
        ITw7v7/cdWn2KJR/y3Dy0/iV0torhtg=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-439-595uDjYgNQiHF8eF0CSNJQ-1; Tue, 27 Dec 2022 04:03:52 -0500
X-MC-Unique: 595uDjYgNQiHF8eF0CSNJQ-1
Received: by mail-oi1-f199.google.com with SMTP id r65-20020acaf344000000b0035a1d791805so2105929oih.19
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:03:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xwaWC7qhv1n472jAfAEwqv5nsnmhd0aYtU5tB8HHqyw=;
        b=lU1G5Z/dmMcgkBzN7niK0nrNCSSxaGKP/JxQfwWdh3gczPXgTWreIXV4RWXxjLYMmX
         0Dhvwxi5vW1HK+uftmTpDXYFNnKlscXVgM2UjTxQQZBuN+Tjit5o3A4OvAr5X7vi1IXm
         vi7Etb4g8WFI0viI9+6DPqjvByXI6YD4qe0hVJLE2Mp07odEizEoHLvnO+xIXj79Le9g
         Xu24uo0xz64devh0OsyOc8n+5TcsDSNdtyjkmhC2gkQD58n13+Vl4Ly8J9ZUVmcyV+Qo
         FOkbm2LCLyIR/YME4K0K2ZHBXN/zzNUEbcpzJu2p9O5o8pU7Spcar0aNj1Qn8hFQnJrL
         +rqQ==
X-Gm-Message-State: AFqh2krtdhG33H51KLCjNcJw/N/t5mqkxb2pskt9hM9LfME041LCbqgS
        EyAEXqneUGS0eBEK51dnyXPs9b7VouC45YGdcaxzBaf3v4pMzgRRoFq45StUCQDnf8a814IO7vS
        TdYgu8NNs4+sxx6iR/OVwngcJqw3smNmp
X-Received: by 2002:a05:6870:3d97:b0:144:b22a:38d3 with SMTP id lm23-20020a0568703d9700b00144b22a38d3mr1372400oab.280.1672131832122;
        Tue, 27 Dec 2022 01:03:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvJmy3qoV6i2Qvz4anp5Z6wbHhhC955C1D1+oiqOLnAQc1zVZZZnGwH1SvPNoaeh2qsPP7EJTP2FSuMFsn2xO0=
X-Received: by 2002:a05:6870:3d97:b0:144:b22a:38d3 with SMTP id
 lm23-20020a0568703d9700b00144b22a38d3mr1372393oab.280.1672131831882; Tue, 27
 Dec 2022 01:03:51 -0800 (PST)
MIME-Version: 1.0
References: <20221220141449.115918-1-hengqi@linux.alibaba.com> <20221220141449.115918-10-hengqi@linux.alibaba.com>
In-Reply-To: <20221220141449.115918-10-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Dec 2022 17:03:40 +0800
Message-ID: <CACGkMEvorhL+KikOUu=ozpxo0KJSbkHF65h58srfXNd5wHWDgw@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] virtio_net: support multi-buffer xdp
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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

On Tue, Dec 20, 2022 at 10:15 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
> Driver can pass the skb to stack by build_skb_from_xdp_buff().
>
> Driver forwards multi-buffer packets using the send queue
> when XDP_TX and XDP_REDIRECT, and clears the reference of multi
> pages when XDP_DROP.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 65 ++++++----------------------------------
>  1 file changed, 9 insertions(+), 56 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 398ffe2a5084..daa380b9d1cc 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1074,7 +1074,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>         struct bpf_prog *xdp_prog;
>         unsigned int truesize = mergeable_ctx_to_truesize(ctx);
>         unsigned int headroom = mergeable_ctx_to_headroom(ctx);
> -       unsigned int metasize = 0;
>         unsigned int frame_sz;
>         int err;
>
> @@ -1165,63 +1164,22 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
> +                               netdev_dbg(dev, "convert buff to frame failed for xdp\n");
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
> @@ -1231,11 +1189,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
> @@ -1248,9 +1203,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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

