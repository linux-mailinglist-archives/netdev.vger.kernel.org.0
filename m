Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C746F6F101F
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 03:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344633AbjD1Byi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 21:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjD1Byh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 21:54:37 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593E93A92;
        Thu, 27 Apr 2023 18:54:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vh9OEYK_1682646872;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vh9OEYK_1682646872)
          by smtp.aliyun-inc.com;
          Fri, 28 Apr 2023 09:54:33 +0800
Message-ID: <1682646856.5083742-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v4 12/15] virtio_net: small: avoid double counting in xdp scenarios
Date:   Fri, 28 Apr 2023 09:54:16 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
 <20230427030534.115066-13-xuanzhuo@linux.alibaba.com>
 <20230427210802-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230427210802-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Apr 2023 21:08:25 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Apr 27, 2023 at 11:05:31AM +0800, Xuan Zhuo wrote:
> > Avoid the problem that some variables(headroom and so on) will repeat
> > the calculation when process xdp.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
>
>
> this is "code duplication" not "double counting".

Will fix.

Thanks.


>
>
> > ---
> >  drivers/net/virtio_net.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index b8ec642899c9..f832ab8a3e6e 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1027,11 +1027,10 @@ static struct sk_buff *receive_small(struct net_device *dev,
> >  	struct sk_buff *skb;
> >  	struct bpf_prog *xdp_prog;
> >  	unsigned int xdp_headroom = (unsigned long)ctx;
> > -	unsigned int header_offset = VIRTNET_RX_PAD + xdp_headroom;
> > -	unsigned int headroom = vi->hdr_len + header_offset;
> > -	unsigned int buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> > -			      SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> >  	struct page *page = virt_to_head_page(buf);
> > +	unsigned int header_offset;
> > +	unsigned int headroom;
> > +	unsigned int buflen;
> >
> >  	len -= vi->hdr_len;
> >  	stats->bytes += len;
> > @@ -1059,6 +1058,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
> >  	rcu_read_unlock();
> >
> >  skip_xdp:
> > +	header_offset = VIRTNET_RX_PAD + xdp_headroom;
> > +	headroom = vi->hdr_len + header_offset;
> > +	buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> > +		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > +
> >  	skb = build_skb(buf, buflen);
> >  	if (!skb)
> >  		goto err;
> > --
> > 2.32.0.3.g01195cf9f
>
