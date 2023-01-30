Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D549680697
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbjA3HkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjA3HkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:40:10 -0500
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4A919F09;
        Sun, 29 Jan 2023 23:40:07 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VaPc4LJ_1675064403;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VaPc4LJ_1675064403)
          by smtp.aliyun-inc.com;
          Mon, 30 Jan 2023 15:40:04 +0800
Message-ID: <1675064346.4139252-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH] vhost-net: support VIRTIO_F_RING_RESET
Date:   Mon, 30 Jan 2023 15:39:06 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        hengqi@linux.alibaba.com,
        Kangjie Xu <kangjie.xu@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
References: <20220825085610.80315-1-kangjie.xu@linux.alibaba.com>
 <10630d99-e0bd-c067-8766-19266b38d2fe@redhat.com>
In-Reply-To: <10630d99-e0bd-c067-8766-19266b38d2fe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Sep 2022 16:32:19 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/8/25 16:56, Kangjie Xu =E5=86=99=E9=81=93:
> > Add VIRTIO_F_RING_RESET, which indicates that the driver can reset a
> > queue individually.
> >
> > VIRTIO_F_RING_RESET feature is added to virtio-spec 1.2. The relevant
> > information is in
> >      oasis-tcs/virtio-spec#124
> >      oasis-tcs/virtio-spec#139
> >
> > The implementation only adds the feature bit in supported features. It
> > does not require any other changes because we reuse the existing vhost
> > protocol.
> >
> > The virtqueue reset process can be concluded as two parts:
> > 1. The driver can reset a virtqueue. When it is triggered, we use the
> > set_backend to disable the virtqueue.
> > 2. After the virtqueue is disabled, the driver may optionally re-enable
> > it. The process is basically similar to when the device is started,
> > except that the restart process does not need to set features and set
> > mem table since they do not change. QEMU will send messages containing
> > size, base, addr, kickfd and callfd of the virtqueue in order.
> > Specifically, the host kernel will receive these messages in order:
> >      a. VHOST_SET_VRING_NUM
> >      b. VHOST_SET_VRING_BASE
> >      c. VHOST_SET_VRING_ADDR
> >      d. VHOST_SET_VRING_KICK
> >      e. VHOST_SET_VRING_CALL
> >      f. VHOST_NET_SET_BACKEND
> > Finally, after we use set_backend to attach the virtqueue, the virtqueue
> > will be enabled and start to work.
> >
> > Signed-off-by: Kangjie Xu <kangjie.xu@linux.alibaba.com>
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
>
> Acked-by: Jason Wang <jasowang@redhat.com>

@mst

Do we miss this?

Thanks.

>
>
> > ---
> >
> > Test environment and method:
> >      Host: 5.19.0-rc3
> >      Qemu: QEMU emulator version 7.0.50 (With vq rset support)
> >      Guest: 5.19.0-rc3 (With vq reset support)
> >      Test Cmd: ethtool -g eth1; ethtool -G eth1 rx $1 tx $2; ethtool -g=
 eth1;
> >
> >      The drvier can resize the virtio queue, then virtio queue reset fu=
nction should
> >      be triggered.
> >
> >      The default is split mode, modify Qemu virtio-net to add PACKED fe=
ature to
> >      test packed mode.
> >
> > Guest Kernel Patch:
> >      https://lore.kernel.org/bpf/20220801063902.129329-1-xuanzhuo@linux=
.alibaba.com/
> >
> > QEMU Patch:
> >      https://lore.kernel.org/qemu-devel/cover.1661414345.git.kangjie.xu=
@linux.alibaba.com/
> >
> > Looking forward to your review and comments. Thanks.
> >
> >   drivers/vhost/net.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 68e4ecd1cc0e..8a34928d4fef 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -73,7 +73,8 @@ enum {
> >   	VHOST_NET_FEATURES =3D VHOST_FEATURES |
> >   			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
> >   			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> > -			 (1ULL << VIRTIO_F_ACCESS_PLATFORM)
> > +			 (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> > +			 (1ULL << VIRTIO_F_RING_RESET)
> >   };
> >
> >   enum {
>
