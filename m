Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B097A65761C
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 12:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiL1LzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 06:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiL1LzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 06:55:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BB81114D
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 03:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672228471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VTAonzunmwjQBSq+wxbJ9cBnpBdrxOWVFyBZ7mX83lM=;
        b=LEsaXehcn11z2tF4jbyo7mzP/XpSl4h1mLtDIXzft7vQoYihp5wJXDJqnMIYDR/lZyOPB6
        nQLqFgvw4fsAgZfk42e08tLB2Gtt9JI0WyVcnSjbRRZBYpCasBdRZUJXl7wyQauLYr5ds3
        c0sqiUtrpGUl/isHAa2JjlTQKjFJaSo=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-137-Fvv_V3GiNHqemXz2olLsKQ-1; Wed, 28 Dec 2022 06:54:30 -0500
X-MC-Unique: Fvv_V3GiNHqemXz2olLsKQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1441544a0e5so7505509fac.8
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 03:54:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VTAonzunmwjQBSq+wxbJ9cBnpBdrxOWVFyBZ7mX83lM=;
        b=H0iqKurw2gZcZNZseoQNORRlF/mf1Q9hUz2GJmhXaUykpVaPCCZalTlTqEi4Bn8PkJ
         UroBq/ZkDThA02uGTtmd+h7CCyn3DWepLkFdaJuY6Xr0ezSilNnbfA5tbesmIMINzgxz
         Oj9ZNz0Stbsg+iRVhZa0Wab9UaDxMFq7DE6V6itVTpti3N2aFSoXiv2PXr6HkFrtLPvA
         8imIAVVrwp0cbVVUE3d56oTPfBCc30lRUmi/0DF833vtuaYJDcj+fHBS5vko+CAx8Up+
         J26YaqCsSlQm0kCEqdcQyD7bbj/2QllY+dR+FiVUs64eddK8oZQYbQSPNP50jz0iZkTo
         Ja5A==
X-Gm-Message-State: AFqh2komcAp5ovBO4h27PMgcQHwiSndVVA8CHEl8drAf0wiQ3pxPJbf9
        nXhuCv9ddsgVOyGvq+eJ0jlcoGlZvq372Pd+meEFct2Co91dmWOPORLwfOmuX8pxRc/iG4fbCvL
        YPhn4iF3z+5S65zhc6Ufs2jVW2m8tbf9n
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id u19-20020a056870441300b00144a97b1ae2mr1227944oah.35.1672228469862;
        Wed, 28 Dec 2022 03:54:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXukmr1oOpyBAdESqGe0qNA5QKqWE4dsvWoEPQEdJow8j32zVtibTFK/HpJFQPkkYposFxQWACpNCcJoGCMbr8c=
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id
 u19-20020a056870441300b00144a97b1ae2mr1227938oah.35.1672228469589; Wed, 28
 Dec 2022 03:54:29 -0800 (PST)
MIME-Version: 1.0
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221220141449.115918-6-hengqi@linux.alibaba.com> <5a03364e-c09e-63ff-7e73-1efec1ed8ca8@redhat.com>
 <83dc59b1-99f6-58fe-56b5-de5158bcc3cd@linux.alibaba.com> <bfc3f1d0-b656-8d2b-c85d-f20a23f2e976@redhat.com>
 <20221228082301.GA18313@h68b04307.sqa.eu95>
In-Reply-To: <20221228082301.GA18313@h68b04307.sqa.eu95>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 28 Dec 2022 19:54:18 +0800
Message-ID: <CACGkMEtMadpE5UXkLfRZMBa0jPt5tbQ_e+hc4o0AwdPikn2eaQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] virtio_net: construct multi-buffer xdp in mergeable
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 4:23 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
> On Wed, Dec 28, 2022 at 02:24:22PM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2022/12/27 17:31, Heng Qi =E5=86=99=E9=81=93:
> > >
> > >
> > >=E5=9C=A8 2022/12/27 =E4=B8=8B=E5=8D=883:01, Jason Wang =E5=86=99=E9=
=81=93:
> > >>
> > >>=E5=9C=A8 2022/12/20 22:14, Heng Qi =E5=86=99=E9=81=93:
> > >>>Build multi-buffer xdp using virtnet_build_xdp_buff_mrg().
> > >>>
> > >>>For the prefilled buffer before xdp is set, we will probably use
> > >>>vq reset in the future. At the same time, virtio net currently
> > >>>uses comp pages, and bpf_xdp_frags_increase_tail() needs to calculat=
e
> > >>>the tailroom of the last frag, which will involve the offset of the
> > >>>corresponding page and cause a negative value, so we disable tail
> > >>>increase by not setting xdp_rxq->frag_size.
> > >>>
> > >>>Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > >>>Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > >>>---
> > >>>  drivers/net/virtio_net.c | 60
> > >>>+++++++++++++++++++++++++++++-----------
> > >>>  1 file changed, 44 insertions(+), 16 deletions(-)
> > >>>
> > >>>diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > >>>index 8fc3b1841d92..40bc58fa57f5 100644
> > >>>--- a/drivers/net/virtio_net.c
> > >>>+++ b/drivers/net/virtio_net.c
> > >>>@@ -1018,6 +1018,7 @@ static struct sk_buff
> > >>>*receive_mergeable(struct net_device *dev,
> > >>>                       unsigned int *xdp_xmit,
> > >>>                       struct virtnet_rq_stats *stats)
> > >>>  {
> > >>>+    unsigned int tailroom =3D SKB_DATA_ALIGN(sizeof(struct
> > >>>skb_shared_info));
> > >>>      struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf;
> > >>>      u16 num_buf =3D virtio16_to_cpu(vi->vdev, hdr->num_buffers);
> > >>>      struct page *page =3D virt_to_head_page(buf);
> > >>>@@ -1048,11 +1049,14 @@ static struct sk_buff
> > >>>*receive_mergeable(struct net_device *dev,
> > >>>      rcu_read_lock();
> > >>>      xdp_prog =3D rcu_dereference(rq->xdp_prog);
> > >>>      if (xdp_prog) {
> > >>>+        unsigned int xdp_frags_truesz =3D 0;
> > >>>+        struct skb_shared_info *shinfo;
> > >>>          struct xdp_frame *xdpf;
> > >>>          struct page *xdp_page;
> > >>>          struct xdp_buff xdp;
> > >>>          void *data;
> > >>>          u32 act;
> > >>>+        int i;
> > >>>            /* Transient failure which in theory could occur if
> > >>>           * in-flight packets from before XDP was enabled reach
> > >>>@@ -1061,19 +1065,23 @@ static struct sk_buff
> > >>>*receive_mergeable(struct net_device *dev,
> > >>>          if (unlikely(hdr->hdr.gso_type))
> > >>>              goto err_xdp;
> > >>>  -        /* Buffers with headroom use PAGE_SIZE as alloc size,
> > >>>-         * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> > >>>+        /* Now XDP core assumes frag size is PAGE_SIZE, but buffers
> > >>>+         * with headroom may add hole in truesize, which
> > >>>+         * make their length exceed PAGE_SIZE. So we disabled the
> > >>>+         * hole mechanism for xdp. See add_recvbuf_mergeable().
> > >>>           */
> > >>>          frame_sz =3D headroom ? PAGE_SIZE : truesize;
> > >>>  -        /* This happens when rx buffer size is underestimated
> > >>>-         * or headroom is not enough because of the buffer
> > >>>-         * was refilled before XDP is set. This should only
> > >>>-         * happen for the first several packets, so we don't
> > >>>-         * care much about its performance.
> > >>>+        /* This happens when headroom is not enough because
> > >>>+         * of the buffer was prefilled before XDP is set.
> > >>>+         * This should only happen for the first several packets.
> > >>>+         * In fact, vq reset can be used here to help us clean up
> > >>>+         * the prefilled buffers, but many existing devices do not
> > >>>+         * support it, and we don't want to bother users who are
> > >>>+         * using xdp normally.
> > >>>           */
> > >>>-        if (unlikely(num_buf > 1 ||
> > >>>-                 headroom < virtnet_get_headroom(vi))) {
> > >>>+        if (!xdp_prog->aux->xdp_has_frags &&
> > >>>+            (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
> > >>>              /* linearize data for XDP */
> > >>>              xdp_page =3D xdp_linearize_page(rq, &num_buf,
> > >>>                                page, offset,
> > >>>@@ -1084,17 +1092,26 @@ static struct sk_buff
> > >>>*receive_mergeable(struct net_device *dev,
> > >>>              if (!xdp_page)
> > >>>                  goto err_xdp;
> > >>>              offset =3D VIRTIO_XDP_HEADROOM;
> > >>>+        } else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> > >>
> > >>
> > >>I believe we need to check xdp_prog->aux->xdp_has_frags at least
> > >>since this may not work if it needs more than one frags?
> > >
> > >Sorry Jason, I didn't understand you, I'll try to answer. For
> > >multi-buffer xdp programs, if the first buffer is a pre-filled
> > >buffer (no headroom),
> > >we need to copy it out and use the subsequent buffers of this
> > >packet as its frags (this is done in
> > >virtnet_build_xdp_buff_mrg()), therefore,
> > >it seems that there is no need to check
> > >'xdp_prog->aux->xdp_has_frags' to mark multi-buffer xdp (of course
> > >I can add it),
> > >
> > >+ } else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> > >
> > >Because the linearization of single-buffer xdp has all been done
> > >before, the subsequent situation can only be applied to
> > >multi-buffer xdp:
> > >+ if (!xdp_prog->aux->xdp_has_frags &&
> > >+ (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
> >
> >
> > I basically meant what happens if
> >
> > !xdp_prog->aux->xdp_has_frags && num_buf > 2 && headroom <
> > virtnet_get_headroom(vi)
> >
> > In this case the current code seems to leave the second buffer in
> > the frags. This is the case of the buffer size underestimation that
> > is mentioned in the comment before (I'd like to keep that).
>
> If I'm not wrong, this case is still directly into the first 'if' loop.

My fault, you're right.

Thanks

>
> -               if (unlikely(num_buf > 1 ||
> -                            headroom < virtnet_get_headroom(vi))) {
> +               if (!xdp_prog->aux->xdp_has_frags &&
> +                   (num_buf > 1 || headroom < virtnet_get_headroom(vi)))=
 {
>
> Thanks.
>
> >
> > (And that's why I'm asking to use linearizge_page())
> >
> > Thanks
> >
> >
> > >
> > >>
> > >>Btw, I don't see a reason why we can't reuse
> > >>xdp_linearize_page(), (we probably don't need error is the
> > >>buffer exceeds PAGE_SIZE).
> > >
> > >For multi-buffer xdp, we only need to copy out the pre-filled
> > >first buffer, and use the remaining buffers of this packet as
> > >frags in virtnet_build_xdp_buff_mrg().
> > >
> > >Thanks.
> > >
> > >>
> > >>Other looks good.
> > >>
> > >>Thanks
> > >>
> > >>
> > >>>+            if ((VIRTIO_XDP_HEADROOM + len + tailroom) > PAGE_SIZE)
> > >>>+                goto err_xdp;
> > >>>+
> > >>>+            xdp_page =3D alloc_page(GFP_ATOMIC);
> > >>>+            if (!xdp_page)
> > >>>+                goto err_xdp;
> > >>>+
> > >>>+            memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> > >>>+                   page_address(page) + offset, len);
> > >>>+            frame_sz =3D PAGE_SIZE;
> > >>>+            offset =3D VIRTIO_XDP_HEADROOM;
> > >>>          } else {
> > >>>              xdp_page =3D page;
> > >>>          }
> > >>>-
> > >>>-        /* Allow consuming headroom but reserve enough space to pus=
h
> > >>>-         * the descriptor on if we get an XDP_TX return code.
> > >>>-         */
> > >>>          data =3D page_address(xdp_page) + offset;
> > >>>-        xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
> > >>>-        xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM +
> > >>>vi->hdr_len,
> > >>>-                 VIRTIO_XDP_HEADROOM, len - vi->hdr_len, true);
> > >>>+        err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp,
> > >>>data, len, frame_sz,
> > >>>+                         &num_buf, &xdp_frags_truesz, stats);
> > >>>+        if (unlikely(err))
> > >>>+            goto err_xdp_frags;
> > >>>            act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > >>>          stats->xdp_packets++;
> > >>>@@ -1190,6 +1207,17 @@ static struct sk_buff
> > >>>*receive_mergeable(struct net_device *dev,
> > >>>                  __free_pages(xdp_page, 0);
> > >>>              goto err_xdp;
> > >>>          }
> > >>>+err_xdp_frags:
> > >>>+        shinfo =3D xdp_get_shared_info_from_buff(&xdp);
> > >>>+
> > >>>+        if (unlikely(xdp_page !=3D page))
> > >>>+            __free_pages(xdp_page, 0);
> > >>>+
> > >>>+        for (i =3D 0; i < shinfo->nr_frags; i++) {
> > >>>+            xdp_page =3D skb_frag_page(&shinfo->frags[i]);
> > >>>+            put_page(xdp_page);
> > >>>+        }
> > >>>+        goto err_xdp;
> > >>>      }
> > >>>      rcu_read_unlock();
> > >
>

