Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBD3351C27
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbhDASNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbhDASJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:09:30 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E254C08ECBB
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 07:08:52 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id l15so1959994ybm.0
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 07:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cLABjhuTXILnt6ampnjff2nO4bw5eWAVs3zWH+qBMsY=;
        b=PFT9KJJgGzfo+11E6GRaTyf25AmOIGIHSG5IfYQbVtFGr75xdlezHLDEP9SlXD1teo
         zjohLedqwBtNU8uW3qOR+aqzSG9Sj/yDUnEESPCXaW/zxU8hN6vXRnLG3LrYExAXSCfa
         3dXbBovzgXXiC3hkGtrkbSPmkRXeIlLSIwWS1zornnVOf145YrPvsK4RE1qxG1E1Uulu
         WvBhgxbXv3jC/l1DwN03b8RBdF2gh5KZWVakTvcdSXDAuHQ7hnaIz8OGCChzknovhoKI
         ovLN+N0tXMgnSeiNXBMV4bkkPv7mZWkBrBBcsMbNHE4cbT3k10G3tOCeZKC5mao1Ni1v
         e4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cLABjhuTXILnt6ampnjff2nO4bw5eWAVs3zWH+qBMsY=;
        b=sFXlm4IfbHAyEtmU1sc0FWIRPdxTlOPDLa2iTaurwKD6YzvAZtHoNPb6xo7kxh3Kzt
         PSTyo1VCLvDife/T494wYgZ/ynjag1yRq8YlGwcw4OEFmzu1UY9u0uqyRanFcGRsefhj
         BIunLtDmGvp0TAFjVnVVXEzVzLV25pi+2iZ43+JQK2fGlpZKYK17BDYeCWWzhevsvTCl
         c1d+RVQ1QTl0jrYVK0+oH/oVHVGsBd0L0er5sBV21Q5eNF2UEGcFjyajz05Gq7TVQytT
         Bkpdk+mHvMxdDjwpSItFJTXPnuk5IEn+3QfsgS6b4eWq56FYvULxJRqIfvwEUYn+eGwf
         EmqQ==
X-Gm-Message-State: AOAM531vt6Fd37Ezf8zcFVc4ZaCE9bPT4JW3luMHT7IwYrGzgluzbxXX
        wA1bN0+Z+otQTzgVhN4LiyyUcTnaJGJklQtRu81VlA==
X-Google-Smtp-Source: ABdhPJyjtaxqpHBOGY511Tntc1fgoLST00ST1i6nn66Ghb9JxJ0gCL/K57R9vpIubRAJG7mpV43rRMjxOTyieaW7IrA=
X-Received: by 2002:a25:ab81:: with SMTP id v1mr12409681ybi.303.1617286130973;
 Thu, 01 Apr 2021 07:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <1617007696.5731978-1-xuanzhuo@linux.alibaba.com> <CANn89iLXfu7mdk+cxqVYxtJhfBQtpho6i2kyOEUbEGPXBQj+jg@mail.gmail.com>
 <20210331040405-mutt-send-email-mst@kernel.org> <CANn89iJN3SQDctZxaPdZMSPGRbjLrsYGM7=Y2POv-3Ysw-EZ_w@mail.gmail.com>
 <20210401094908-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210401094908-mutt-send-email-mst@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Apr 2021 16:08:39 +0200
Message-ID: <CANn89iJrbnuUGk3OAG+DRjxAz6YoUSyNUXEPsKVZRMxNFQbSBw@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 3:51 PM Michael S. Tsirkin <mst@redhat.com> wrote:

> So IIUC what you are saying is we should do more or less
>      if (hdr_len != 0)
>                         copy hdr_len
> ?

This part is not pulling bytes into skb->head, but into
skb_vnet_hdr(skb) (which is basically skb->cb)

I suggest the following patch

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb4ea9dbc16bcb19c5969fc8247478aa66c63fce..f5a3cecd18eada32694714ecb85c205af7108aae
100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -409,9 +409,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
        offset += hdr_padded_len;
        p += hdr_padded_len;

-       copy = len;
-       if (copy > skb_tailroom(skb))
-               copy = skb_tailroom(skb);
+       /* Copy all frame if it fits skb->head,
+        * otherwise we let GRO pull headers as needed.
+        */
+       if (len <= skb_tailroom(skb))
+               copy = len;
+       else
+               copy =  ETH_HLEN + metasize;
        skb_put_data(skb, p, copy);

        if (metasize) {
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 6b5fcfa1e5553576b0e853ae31a2df655c04204b..2ee8f3ba76a548d54e0b21321a67da958c9984a0
100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -63,8 +63,12 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
        }

        if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
-               u16 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
-               u16 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
+               u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
+               u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
+               u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
+
+               if (pskb_may_pull(skb, needed))
+                       return -EINVAL;

                if (!skb_partial_csum_set(skb, start, off))
                        return -EINVAL;
@@ -100,14 +104,14 @@ static inline int virtio_net_hdr_to_skb(struct
sk_buff *skb,
                        }

                        p_off = keys.control.thoff + thlen;
-                       if (p_off > skb_headlen(skb) ||
+                       if (pskb_may_pull(skb, p_off) ||
                            keys.basic.ip_proto != ip_proto)
                                return -EINVAL;

                        skb_set_transport_header(skb, keys.control.thoff);
                } else if (gso_type) {
                        p_off = thlen;
-                       if (p_off > skb_headlen(skb))
+                       if (pskb_may_pull(skb, p_off))
                                return -EINVAL;
                }
        }
