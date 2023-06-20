Return-Path: <netdev+bounces-12260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA34B736E76
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 955D01C20C64
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFAF168AF;
	Tue, 20 Jun 2023 14:15:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5078916421;
	Tue, 20 Jun 2023 14:15:41 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6EFE6E;
	Tue, 20 Jun 2023 07:15:38 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VlcDhnY_1687270532;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VlcDhnY_1687270532)
          by smtp.aliyun-inc.com;
          Tue, 20 Jun 2023 22:15:33 +0800
Date: Tue, 20 Jun 2023 22:15:32 +0800
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
Subject: Re: [PATCH net-next 3/4] virtio-net: support coexistence of XDP and
 _F_GUEST_CSUM
Message-ID: <20230620141532.GH74977@h68b04307.sqa.eu95>
References: <20230619105738.117733-1-hengqi@linux.alibaba.com>
 <20230619105738.117733-4-hengqi@linux.alibaba.com>
 <20230619072320-mutt-send-email-mst@kernel.org>
 <20230620032430.GE74977@h68b04307.sqa.eu95>
 <20230620064711-mutt-send-email-mst@kernel.org>
 <20230620110148.GF74977@h68b04307.sqa.eu95>
 <20230620080926-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620080926-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 08:10:38AM -0400, Michael S. Tsirkin wrote:
> On Tue, Jun 20, 2023 at 07:01:48PM +0800, Heng Qi wrote:
> > On Tue, Jun 20, 2023 at 06:50:34AM -0400, Michael S. Tsirkin wrote:
> > > On Tue, Jun 20, 2023 at 11:24:30AM +0800, Heng Qi wrote:
> > > > On Mon, Jun 19, 2023 at 07:26:44AM -0400, Michael S. Tsirkin wrote:
> > > > > On Mon, Jun 19, 2023 at 06:57:37PM +0800, Heng Qi wrote:
> > > > > > We are now re-probing the csum related fields and  trying
> > > > > > to have XDP and RX hw checksum capabilities coexist on the
> > > > > > XDP path. For the benefit of:
> > > > > > 1. RX hw checksum capability can be used if XDP is loaded.
> > > > > > 2. Avoid packet loss when loading XDP in the vm-vm scenario.
> > > > > > 
> > > > > > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > > > > > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > ---
> > > > > >  drivers/net/virtio_net.c | 36 ++++++++++++++++++++++++------------
> > > > > >  1 file changed, 24 insertions(+), 12 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > index 07b4801d689c..25b486ab74db 100644
> > > > > > --- a/drivers/net/virtio_net.c
> > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > @@ -1709,6 +1709,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> > > > > >  	struct net_device *dev = vi->dev;
> > > > > >  	struct sk_buff *skb;
> > > > > >  	struct virtio_net_hdr_mrg_rxbuf *hdr;
> > > > > > +	__u8 flags;
> > > > > >  
> > > > > >  	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
> > > > > >  		pr_debug("%s: short packet %i\n", dev->name, len);
> > > > > > @@ -1717,6 +1718,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> > > > > >  		return;
> > > > > >  	}
> > > > > >  
> > > > > > +	flags = ((struct virtio_net_hdr_mrg_rxbuf *)buf)->hdr.flags;
> > > > > > +
> > > > > >  	if (vi->mergeable_rx_bufs)
> > > > > >  		skb = receive_mergeable(dev, vi, rq, buf, ctx, len, xdp_xmit,
> > > > > >  					stats);
> > > > > 
> > > > > what's going on here?
> > > > 
> > > > Hi, Michael.
> > > > 
> > > > Is your question about the function of this code?
> > > > 1. If yes,
> > > > this sentence saves the flags value in virtio-net-hdr in advance
> > > > before entering the XDP processing logic, so that it can be used to
> > > > judge further logic after XDP processing.
> > > > 
> > > > If _NEEDS_CSUM is included in flags before XDP processing, then after
> > > > XDP processing we need to re-probe the csum fields and calculate the
> > > > pseudo-header checksum.
> > > 
> > > Yes but we previously used this:
> > > -       hdr = skb_vnet_hdr(skb);
> > > which pokes at the copy in skb cb.
> > > 
> > > Is anything wrong with this?
> > > 
> > 
> > This is where we save the hdr when there is no XDP loaded (note that
> > this is the complete hdr, including flags, and also including GSO and
> > other information). When XDP is loaded, because hdr is invalid, we will
> > not save it into skb->cb.
> > 
> > But the above situation is not what we want. Now our purpose is to save
> > the hdr information before XDP processing, that is, when the driver has
> > just received the packet and has not built the skb (in fact, we only
> > need flags). Therefore, only flags are saved here.
> > 
> > Thanks.
> 
> I don't get it. this seems to be the only use of flags:
> 
> 
> +       if (unlikely(vi->xdp_enabled)) {
> +               if (virtnet_set_csum_after_xdp(vi, skb, flags) < 0) {
> +                       pr_debug("%s: errors occurred in flow dissector setting csum",
> +                                dev->name);
> +                       goto frame_err;
> +               }
> 
> looks like skb has already been created here.

I explain more:

First, this patchset only focuses on XDP loaded scenes.

Then in the same-host vm-vm scenario, when the receiver loads XDP, this
is the packet receiving process:
1. The driver receives a packet, represented by *buf.

2. The XDP program builds xdp_buff based on *buf.
   virtio_net_hdr_mrg_rxbuf is located in the headroom of xdp_buff.

3. The XDP program returns XDP_PASS and modifies the headroom, that is,
the information in virtio_net_hdr_mrg_rxbuf becomes invalid (including
flags). So information like csum_{start, offset} is no longer correct.
Therefore, the skb converted from xdp_buff does not save information in
skb cb. And, skb->ip_summed = CHECKSUM_NONE, there is a high probability of
packet loss at this time because the incorrect check value.

So, in order to solve this problem (not only), we save the flags in
virtio_net_hdr_mrg_rxbuf before the #2 step above, which is the
original information, just to know whether the packet is _NEEDS_CSUM or
_DATA_VALID.

If the saved flags contains _NEEDS_CSUM, then we use
virtnet_set_csum_after_xdp() to recalculate csum_{start, offset},
pseudo-header checksum for the skb converted from xdp_buff. That is, the
saved flags are only used to identify whether we want to re-probe for
the packet to avoiding the packet dropping.

Thanks.

> 
> is there another use of flags that I missed?
> 
> 
> 
> > > It seems preferable not to poke at the header an extra time.
> > > 
> > > -- 
> > > MST

