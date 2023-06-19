Return-Path: <netdev+bounces-12024-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB012735B4E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9346F1C209BC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D8C12B97;
	Mon, 19 Jun 2023 15:43:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23FDC2C5;
	Mon, 19 Jun 2023 15:43:38 +0000 (UTC)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF8B183;
	Mon, 19 Jun 2023 08:43:34 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VlYSrVC_1687189409;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VlYSrVC_1687189409)
          by smtp.aliyun-inc.com;
          Mon, 19 Jun 2023 23:43:30 +0800
Date: Mon, 19 Jun 2023 23:43:29 +0800
From: Heng Qi <hengqi@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, bpf@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next 4/4] virtio-net: remove F_GUEST_CSUM check for
 XDP loading
Message-ID: <20230619154329.GD74977@h68b04307.sqa.eu95>
References: <20230619105738.117733-1-hengqi@linux.alibaba.com>
 <20230619105738.117733-5-hengqi@linux.alibaba.com>
 <20230619071347-mutt-send-email-mst@kernel.org>
 <20230619124154.GC74977@h68b04307.sqa.eu95>
 <20230619103208-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619103208-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 10:33:44AM -0400, Michael S. Tsirkin wrote:
> On Mon, Jun 19, 2023 at 08:41:54PM +0800, Heng Qi wrote:
> > On Mon, Jun 19, 2023 at 07:16:20AM -0400, Michael S. Tsirkin wrote:
> > > On Mon, Jun 19, 2023 at 06:57:38PM +0800, Heng Qi wrote:
> > > > Lay the foundation for the subsequent patch
> > > 
> > > which subsequent patch? this is the last one in series.
> > > 
> > > > to complete the coexistence
> > > > of XDP and virtio-net guest csum.
> > > > 
> > > > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > > > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 4 +---
> > > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 25b486ab74db..79471de64b56 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -60,7 +60,6 @@ static const unsigned long guest_offloads[] = {
> > > >  	VIRTIO_NET_F_GUEST_TSO6,
> > > >  	VIRTIO_NET_F_GUEST_ECN,
> > > >  	VIRTIO_NET_F_GUEST_UFO,
> > > > -	VIRTIO_NET_F_GUEST_CSUM,
> > > >  	VIRTIO_NET_F_GUEST_USO4,
> > > >  	VIRTIO_NET_F_GUEST_USO6,
> > > >  	VIRTIO_NET_F_GUEST_HDRLEN
> > > 
> > > What is this doing? Drop support for VIRTIO_NET_F_GUEST_CSUM? Why?
> > 
> > guest_offloads[] is used by the VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET
> > command to switch features when XDP is loaded/unloaded.
> > 
> > If the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature is negotiated:
> > 1. When XDP is loaded, virtnet_xdp_set() uses virtnet_clear_guest_offloads()
> > to automatically turn off the features in guest_offloads[].
> > 
> > 2. when XDP is unloaded, virtnet_xdp_set() uses virtnet_restore_guest_offloads()
> > to automatically restore the features in guest_offloads[].
> > 
> > Now, this work no longer makes XDP and _F_GUEST_CSUM mutually
> > exclusive, so this patch removed the _F_GUEST_CSUM from guest_offloads[].
> > 
> > > This will disable all of guest offloads I think ..
> > 
> > No. This doesn't change the dependencies of other features on
> > _F_GUEST_CSUM. Removing _F_GUEST_CSUM here does not mean that other
> > features that depend on it will be turned off at the same time, such as
> > _F_GUEST_TSO{4,6}, F_GUEST_USO{4,6}, etc.
> > 
> > Thanks.
> 
> Hmm I don't get it.
> 
> static int virtnet_restore_guest_offloads(struct virtnet_info *vi)
> {               
>         u64 offloads = vi->guest_offloads;
>                         
>         if (!vi->guest_offloads)
>                 return 0;
>         
>         return virtnet_set_guest_offloads(vi, offloads); 
> }               
>                         
> is the bit _F_GUEST_CSUM set in vi->guest_offloads?

No, but first we doesn't clear _F_GUEST_CSUM in virtnet_clear_guest_offloads().

If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS is negotiated, features that can
be dynamically controlled by the VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET
command must also be negotiated. Therefore, if GRO_HW_MASK features such
as _F_GUEST_TSO exist, then _F_GUEST_CSUM must exist (according to the
dependencies defined by the spec).

Now, we only dynamically turn off/on the features contained in
guest_offloads[] through XDP loading/unloading (with this patch,
_F_GUEST_CSUM will not be controlled), and _F_GUEST_CSUM is always on.

Another point is that the virtio-net NETIF_F_RXCSUM corresponding to
_F_GUEST_CSUM is only included in dev->features, not in dev->hw_features,
which means that users cannot manually control the switch of
_F_GUEST_CSUM.

> 
> Because if it isn't then we'll try to set _F_GUEST_TSO
> without setting _F_GUEST_CSUM and that's a spec
> violation I think.

As explained above, we did not cause a specification violation.

Thanks.

> 
> 
> > > 
> > > 
> > > > @@ -3522,10 +3521,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> > > >  	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> > > >  	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> > > >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
> > > > -		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM) ||
> > > >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) ||
> > > >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6))) {
> > > > -		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
> > > > +		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW, disable GRO_HW first");
> > > >  		return -EOPNOTSUPP;
> > > >  	}
> > > >  
> > > > -- 
> > > > 2.19.1.6.gb485710b

