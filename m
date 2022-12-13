Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C1264AE4C
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 04:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbiLMDiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 22:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiLMDiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 22:38:51 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9532165B0;
        Mon, 12 Dec 2022 19:38:49 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VXC4qCa_1670902725;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VXC4qCa_1670902725)
          by smtp.aliyun-inc.com;
          Tue, 13 Dec 2022 11:38:46 +0800
Message-ID: <1670902391.9610498-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] virtio-net: correctly enable callback during start_xmit
Date:   Tue, 13 Dec 2022 11:33:11 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        Jason Wang <jasowang@redhat.com>
References: <20221212091029.54390-1-jasowang@redhat.com>
 <20221212042144-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221212042144-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Dec 2022 04:25:22 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Dec 12, 2022 at 05:10:29PM +0800, Jason Wang wrote:
> > Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> > virtqueue callback via the following statement:
> >
> >         do {
> >            ......
> > 	} while (use_napi && kick &&
> >                unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> >
> > This will cause a missing call to virtqueue_enable_cb_delayed() when
> > kick is false. Fixing this by removing the checking of the kick from
> > the condition to make sure callback is enabled correctly.
> >
> > Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> > The patch is needed for -stable.
>
> stable rules don't allow for theoretical fixes. Was a problem observed?
>
> > ---
> >  drivers/net/virtio_net.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 86e52454b5b5..44d7daf0267b 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1834,8 +1834,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> >
> >  		free_old_xmit_skbs(sq, false);
> >
> > -	} while (use_napi && kick &&
> > -	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > +	} while (use_napi &&
> > +		 unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> >
>
> A bit more explanation pls.  kick simply means !netdev_xmit_more -
> if it's false we know there will be another packet, then transmissing
> that packet will invoke virtqueue_enable_cb_delayed. No?

It's just that there may be a next packet, but in fact there may not be.
For example, the vq is full, and the driver stops the queue.

Thanks.

>
>
>
>
>
> >  	/* timestamp packet in software */
> >  	skb_tx_timestamp(skb);
> > --
> > 2.25.1
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
