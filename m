Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF10E64E676
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 04:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLPDrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 22:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLPDrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 22:47:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E94312749
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671162391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EgRbOB1vI6fO0b+BPw7TkCmFyVPRHjmCuOLXXeHtLl8=;
        b=YaUNN8NYGn210fUlbj4A8ufwZL8GYGr2I0N0kLz3FSeyeAio26OJR2H0Su6fB86XZ5dPPH
        EgfYx9DlpB0u0CmleE5cc+4gjVEYj9pvOo0sI/SE+gnve0TtaX+J52qNzn3nSZJqxU+pUb
        KQusOi+RjfJzrrVJuVI3b5bh21TRsj4=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-sd-oJTy8N8-zYwweVMI4Fg-1; Thu, 15 Dec 2022 22:46:29 -0500
X-MC-Unique: sd-oJTy8N8-zYwweVMI4Fg-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-143c7a3da8aso688733fac.23
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:46:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EgRbOB1vI6fO0b+BPw7TkCmFyVPRHjmCuOLXXeHtLl8=;
        b=yD8PjxISmertZvHIhSyzawGQMxbxlkJqlcZsvIioaF09Bhb5G5w0DGI6txgF5V16YY
         dj8XZBI9aiRuExMM8tRTND7XPKzfW3WKOWN4Nz/6ja2p/pXN82YESX/d5DaYai+HG1N4
         DEjaYbKzxqvI68S9g7Xb7LD+7Up2aXzZpUX1u6IMuFLovh3DgIDdWvkJ98j4NAa/FJQE
         B5WBnIBQ7YTNEmOpDBqQACThxncIuET76NGLzo0y6jZ9HFbTXvXoa+Mw146vTbpFZUU7
         cDyQTdPQBWpYe1NP5Jjmo1FTMk9LgY3CXZ9DF52x11KZeOHzN7yPr4YbxcATo2py4hN8
         Xkdg==
X-Gm-Message-State: ANoB5pmRrmbEQm0Fa606GnyX/ex4XGiXCm7DnZP/m/7hPMLVue7QN/Y9
        Jb4XEu+jcgtRVnizq/wEOS4agq+AWtbkULgSltH5KCHLDabzg0vNhlXXWGXi6jyap/F/PA4+uuf
        s9IXrDiocakNsvEli4qCF7CyL3T0gCI5q
X-Received: by 2002:a05:6870:9e8f:b0:144:a97b:1ae2 with SMTP id pu15-20020a0568709e8f00b00144a97b1ae2mr319760oab.35.1671162388570;
        Thu, 15 Dec 2022 19:46:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7lyrqNfXgiiFMIiygng4BqcjgGPdDIzFCCBzuQBxFY7FrsKKqlPpTj3nmgMEZ1n/a5cZB5uguv2XoPCIUdZjo=
X-Received: by 2002:a05:6870:9e8f:b0:144:a97b:1ae2 with SMTP id
 pu15-20020a0568709e8f00b00144a97b1ae2mr319757oab.35.1671162388336; Thu, 15
 Dec 2022 19:46:28 -0800 (PST)
MIME-Version: 1.0
References: <20221122074348.88601-1-hengqi@linux.alibaba.com>
 <20221122074348.88601-7-hengqi@linux.alibaba.com> <CACGkMEsbX8w1wuU+954zVwNT5JvCHX7a9baKRytVb641UmNsuw@mail.gmail.com>
 <8b143235-2e74-eddf-4c22-a36d679d093e@linux.alibaba.com> <CACGkMEsX=p4VM0yW0E3oaO=hBJx6y2x8fDkChh=ju13Y_tmjVA@mail.gmail.com>
 <20221214083750.GB56694@h68b04307.sqa.eu95>
In-Reply-To: <20221214083750.GB56694@h68b04307.sqa.eu95>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 16 Dec 2022 11:46:17 +0800
Message-ID: <CACGkMEu4a0B8_3sWisnQ4PjAURfqTa8mWC8HWWHaW3QFv4EBjA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/9] virtio_net: construct multi-buffer xdp in mergeable
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 4:38 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
> On Tue, Dec 13, 2022 at 03:08:46PM +0800, Jason Wang wrote:
> > On Thu, Dec 8, 2022 at 4:30 PM Heng Qi <hengqi@linux.alibaba.com> wrote=
:
> > >
> > >
> > >
> > > =E5=9C=A8 2022/12/6 =E4=B8=8B=E5=8D=882:33, Jason Wang =E5=86=99=E9=
=81=93:
> > > > On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> =
wrote:
> > > >> Build multi-buffer xdp using virtnet_build_xdp_buff() in mergeable=
.
> > > >>
> > > >> For the prefilled buffer before xdp is set, vq reset can be
> > > >> used to clear it, but most devices do not support it at present.
> > > >> In order not to bother users who are using xdp normally, we do
> > > >> not use vq reset for the time being.
> > > > I guess to tweak the part to say we will probably use vq reset in t=
he future.
> > >
> > > OK, it works.
> > >
> > > >
> > > >> At the same time, virtio
> > > >> net currently uses comp pages, and bpf_xdp_frags_increase_tail()
> > > >> needs to calculate the tailroom of the last frag, which will
> > > >> involve the offset of the corresponding page and cause a negative
> > > >> value, so we disable tail increase by not setting xdp_rxq->frag_si=
ze.
> > > >>
> > > >> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > > >> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > >> ---
> > > >>   drivers/net/virtio_net.c | 67 +++++++++++++++++++++++-----------=
------
> > > >>   1 file changed, 38 insertions(+), 29 deletions(-)
> > > >>
> > > >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > >> index 20784b1d8236..83e6933ae62b 100644
> > > >> --- a/drivers/net/virtio_net.c
> > > >> +++ b/drivers/net/virtio_net.c
> > > >> @@ -994,6 +994,7 @@ static struct sk_buff *receive_mergeable(struc=
t net_device *dev,
> > > >>                                           unsigned int *xdp_xmit,
> > > >>                                           struct virtnet_rq_stats =
*stats)
> > > >>   {
> > > >> +       unsigned int tailroom =3D SKB_DATA_ALIGN(sizeof(struct skb=
_shared_info));
> > > >>          struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf;
> > > >>          u16 num_buf =3D virtio16_to_cpu(vi->vdev, hdr->num_buffer=
s);
> > > >>          struct page *page =3D virt_to_head_page(buf);
> > > >> @@ -1024,53 +1025,50 @@ static struct sk_buff *receive_mergeable(s=
truct net_device *dev,
> > > >>          rcu_read_lock();
> > > >>          xdp_prog =3D rcu_dereference(rq->xdp_prog);
> > > >>          if (xdp_prog) {
> > > >> +               unsigned int xdp_frags_truesz =3D 0;
> > > >> +               struct skb_shared_info *shinfo;
> > > >>                  struct xdp_frame *xdpf;
> > > >>                  struct page *xdp_page;
> > > >>                  struct xdp_buff xdp;
> > > >>                  void *data;
> > > >>                  u32 act;
> > > >> +               int i;
> > > >>
> > > >> -               /* Transient failure which in theory could occur i=
f
> > > >> -                * in-flight packets from before XDP was enabled r=
each
> > > >> -                * the receive path after XDP is loaded.
> > > >> -                */
> > > >> -               if (unlikely(hdr->hdr.gso_type))
> > > >> -                       goto err_xdp;
> > > > Two questions:
> > > >
> > > > 1) should we keep this check for the XDP program that can't deal wi=
th XDP frags?
> > >
> > > Yes, the problem is the same as the xdp program without xdp.frags whe=
n
> > > GRO_HW, I will correct it.
> > >
> > > > 2) how could we guarantee that the vnet header (gso_type/csum_start
> > > > etc) is still valid after XDP (where XDP program can choose to
> > > > override the header)?
> > >
> > > We can save the vnet headr before the driver receives the packet and
> > > build xdp_buff, and then use
> > > the pre-saved value in the subsequent process.
> >
> > The problem is that XDP may modify the packet (header) so some fields
> > are not valid any more (e.g csum_start/offset ?).
> >
> > If I was not wrong, there's no way for the XDP program to access those
> > fields or does it support it right now?
> >
>
> When guest_csum feature is negotiated, xdp cannot be set, because the met=
adata
> of xdp_{buff, frame} may be adjusted by the bpf program, therefore,
> csum_{start, offset} itself is invalid. And at the same time,
> multi-buffer xdp programs should only Receive packets over larger MTU, so
> we don't need gso related information anymore and need to disable GRO_HW.

Ok, that's fine.

(But it requires a large pMTU).

Thanks

>
> Thanks.
>
> > >
> > > >> -
> > > >> -               /* Buffers with headroom use PAGE_SIZE as alloc si=
ze,
> > > >> -                * see add_recvbuf_mergeable() + get_mergeable_buf=
_len()
> > > >> +               /* Now XDP core assumes frag size is PAGE_SIZE, bu=
t buffers
> > > >> +                * with headroom may add hole in truesize, which
> > > >> +                * make their length exceed PAGE_SIZE. So we disab=
led the
> > > >> +                * hole mechanism for xdp. See add_recvbuf_mergeab=
le().
> > > >>                   */
> > > >>                  frame_sz =3D headroom ? PAGE_SIZE : truesize;
> > > >>
> > > >> -               /* This happens when rx buffer size is underestima=
ted
> > > >> -                * or headroom is not enough because of the buffer
> > > >> -                * was refilled before XDP is set. This should onl=
y
> > > >> -                * happen for the first several packets, so we don=
't
> > > >> -                * care much about its performance.
> > > >> +               /* This happens when headroom is not enough becaus=
e
> > > >> +                * of the buffer was prefilled before XDP is set.
> > > >> +                * This should only happen for the first several p=
ackets.
> > > >> +                * In fact, vq reset can be used here to help us c=
lean up
> > > >> +                * the prefilled buffers, but many existing device=
s do not
> > > >> +                * support it, and we don't want to bother users w=
ho are
> > > >> +                * using xdp normally.
> > > >>                   */
> > > >> -               if (unlikely(num_buf > 1 ||
> > > >> -                            headroom < virtnet_get_headroom(vi)))=
 {
> > > >> -                       /* linearize data for XDP */
> > > >> -                       xdp_page =3D xdp_linearize_page(rq, &num_b=
uf,
> > > >> -                                                     page, offset=
,
> > > >> -                                                     VIRTIO_XDP_H=
EADROOM,
> > > >> -                                                     &len);
> > > >> -                       frame_sz =3D PAGE_SIZE;
> > > >> +               if (unlikely(headroom < virtnet_get_headroom(vi)))=
 {
> > > >> +                       if ((VIRTIO_XDP_HEADROOM + len + tailroom)=
 > PAGE_SIZE)
> > > >> +                               goto err_xdp;
> > > >>
> > > >> +                       xdp_page =3D alloc_page(GFP_ATOMIC);
> > > >>                          if (!xdp_page)
> > > >>                                  goto err_xdp;
> > > >> +
> > > >> +                       memcpy(page_address(xdp_page) + VIRTIO_XDP=
_HEADROOM,
> > > >> +                              page_address(page) + offset, len);
> > > >> +                       frame_sz =3D PAGE_SIZE;
> > > > How can we know a single page is sufficient here? (before XDP is se=
t,
> > > > we reserve neither headroom nor tailroom).
> > >
> > > This is only for the first buffer, refer to add_recvbuf_mergeable() a=
nd
> > > get_mergeable_buf_len() A buffer is always no larger than a page.
> >
> > Ok.
> >
> > Thanks
> >
> > >
> > > >
> > > >>                          offset =3D VIRTIO_XDP_HEADROOM;
> > > > I think we should still try to do linearization for the XDP program
> > > > that doesn't support XDP frags.
> > >
> > > Yes, you are right.
> > >
> > > Thanks.
> > >
> > > >
> > > > Thanks
> > > >
> > > >>                  } else {
> > > >>                          xdp_page =3D page;
> > > >>                  }
> > > >> -
> > > >> -               /* Allow consuming headroom but reserve enough spa=
ce to push
> > > >> -                * the descriptor on if we get an XDP_TX return co=
de.
> > > >> -                */
> > > >>                  data =3D page_address(xdp_page) + offset;
> > > >> -               xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->x=
dp_rxq);
> > > >> -               xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM =
+ vi->hdr_len,
> > > >> -                                VIRTIO_XDP_HEADROOM, len - vi->hd=
r_len, true);
> > > >> +               err =3D virtnet_build_xdp_buff(dev, vi, rq, &xdp, =
data, len, frame_sz,
> > > >> +                                            &num_buf, &xdp_frags_=
truesz, stats);
> > > >> +               if (unlikely(err))
> > > >> +                       goto err_xdp_frags;
> > > >>
> > > >>                  act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > >>                  stats->xdp_packets++;
> > > >> @@ -1164,6 +1162,17 @@ static struct sk_buff *receive_mergeable(st=
ruct net_device *dev,
> > > >>                                  __free_pages(xdp_page, 0);
> > > >>                          goto err_xdp;
> > > >>                  }
> > > >> +err_xdp_frags:
> > > >> +               shinfo =3D xdp_get_shared_info_from_buff(&xdp);
> > > >> +
> > > >> +               if (unlikely(xdp_page !=3D page))
> > > >> +                       __free_pages(xdp_page, 0);
> > > >> +
> > > >> +               for (i =3D 0; i < shinfo->nr_frags; i++) {
> > > >> +                       xdp_page =3D skb_frag_page(&shinfo->frags[=
i]);
> > > >> +                       put_page(xdp_page);
> > > >> +               }
> > > >> +               goto err_xdp;
> > > >>          }
> > > >>          rcu_read_unlock();
> > > >>
> > > >> --
> > > >> 2.19.1.6.gb485710b
> > > >>
> > >
>

