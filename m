Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42ED350E56
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 07:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhDAFGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 01:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhDAFG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 01:06:27 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58218C0613E6
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 22:06:27 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id l15so544881ybm.0
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 22:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2hGAS0uQta4V2DtdMABmiKWFVIODrn9giT5GyehPd3Q=;
        b=q/RZfaXDFBtk513wZQE+EwezrtN7Q1TpkxP0tUQWbQEJ86aDXLdu5bjcifU0JEtNcI
         i8usmUO5KazxYHK6nqZAVW0r9YbtdfP4I7bd1WCJn7T8gHnR1//pYunJPK504DpHlvoy
         IKwb6CxFulwJeLhf7R6q/iMm882H6Ewxw+XqzscdOl2uNW5mb9QoUsNQaD+cCvc8EcNF
         ZoFBzgZ8T22q4gsxNPsIjt9DW6bBX3vGvCM+SNilhHmww1DS9ZQYq4zoQ3Hrc/pml10w
         9NJMZBRSZt4x5K6EUBhHpZgPfVJR11CfyYgw5x5RIc2HjOXmsGKNhQofIPXkC4YiJjj0
         aYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2hGAS0uQta4V2DtdMABmiKWFVIODrn9giT5GyehPd3Q=;
        b=gue9ZY83npyExy3XpC8ROIaoaarFc75MjRa/iCLga9xPI+p9+DJNnR+pUTFdZjCKPE
         5imyC4lF+wq6A+84L4IG+UIEubUsVVUKQvYlXsSkkVSCNNNiz+yPFF9SLEsXqnC7PM68
         eadxDr755VjSNDOEx/mfpYxmzwIZXTnG9pR0vng/ofp3NMP1dDPPxiHr4W5FyiBu9DKo
         kFjJCKCRdn/3KeEcDVEj1aiChKaC/W7wDXQiHJPsrRZdFiUCcHG2rXdb70uhdtI5wNS6
         8FC0upySOYIMxOuGnzda7wyX5CwyH9VBaM1oTCEzczDMA5utlQCrgkcNfNc8wJHNFbMn
         hG2w==
X-Gm-Message-State: AOAM532W7hMWSZLexe/7Qn4Ap6Og/HOsvrTyLwwV6OnyOgE32b6LoZ4d
        DROxl8C0eV2uut8eqJ8F+Hyom3oyUPHNIc/C5OjPFjcA5y2Gsw==
X-Google-Smtp-Source: ABdhPJzvNMFRNyGLWAptnR0HJYTWrG5NjlK+pCs9xPC8EY+yBmQ58xJAU+Yk0aWnRDJca1xd5p5murmQVfN59llPrSM=
X-Received: by 2002:a25:3614:: with SMTP id d20mr9564509yba.452.1617253586151;
 Wed, 31 Mar 2021 22:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iLhgOCiH5QSU15gfrepfwgh58WqY3UZpUnyi5V+vx3UDA@mail.gmail.com>
 <1617248264.4993114-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1617248264.4993114-2-xuanzhuo@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Apr 2021 07:06:14 +0200
Message-ID: <CANn89i+Sh3UXyfVb+X2AuXL6swX-8mrK++yn7y11EUnWRSd5HA@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 5:40 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:

>
> [  144.405067] eth1: bad gso: type: 1, size: 1452
> [  180.473565] skbuff: bad partial csum: csum=34/16 headroom=64 headlen=14
> [  180.474698] eth1: bad gso: type: 1, size: 1452
> [  180.519980] skbuff: bad partial csum: csum=34/16 headroom=64 headlen=14
> [  180.521076] eth1: bad gso: type: 1, size: 1452
> [  180.559409] skbuff: bad partial csum: csum=34/16 headroom=64 headlen=14
> [  180.560501] eth1: bad gso: type: 1, size: 1452
> [  180.576476] skbuff: bad partial csum: csum=34/16 headroom=64 headlen=14
> [  180.577562] eth1: bad gso: type: 1, size: 1452
> [  183.284265] skbuff: bad partial csum: csum=34/16 headroom=64 headlen=14
> [  183.285372] eth1: bad gso: type: 1, size: 1452
> [  216.831138] net_ratelimit: 2 callbacks suppressed
> [  216.832009] skbuff: bad partial csum: csum=34/16 headroom=64 headlen=14
> [  216.833103] eth1: bad gso: type: 1, size: 1452
> [  216.892180] skbuff: bad partial csum: csum=34/16 headroom=64 headlen=14
> [  216.893280] eth1: bad gso: type: 1, size: 1452
> [  216.949833] skbuff: bad partial csum: csum=34/16 headroom=64 headlen=14
> [  216.950922] eth1: bad gso: type: 1, size: 1452
> [  291.962999] skbuff: bad partial csum: csum=34/6 headroom=64 headlen=14
> [  291.964092] eth1: bad gso: type: 0, size: 0
> [  311.972597] skbuff: bad partial csum: csum=34/6 headroom=64 headlen=14
> [  311.973691] eth1: bad gso: type: 0, size: 0
>
> I got this display after the machine started, I think just copy eth may not be a
> good way.

This is great, thanks for testing.
This means virtio_net_hdr_to_skb() needs to be a little bit smarter to
pull needed bytes (not assuming 128 bytes were pre-pulled)

Can you try this ?
Thanks !

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
+               copy = min_t(int, len, ETH_HLEN + metasize);
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
