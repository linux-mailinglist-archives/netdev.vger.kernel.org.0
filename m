Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8454CFBF1
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 11:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241474AbiCGKwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 05:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241501AbiCGKwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 05:52:25 -0500
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BFFDF93
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 02:12:31 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V6UQkd0_1646647518;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6UQkd0_1646647518)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Mar 2022 18:05:22 +0800
Message-ID: <1646647482.2340114-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost] virtio_net: fix build warnings
Date:   Mon, 7 Mar 2022 18:04:42 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20220307094042.22180-1-xuanzhuo@linux.alibaba.com>
 <20220307045948-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220307045948-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Mar 2022 05:00:20 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Mar 07, 2022 at 05:40:42PM +0800, Xuan Zhuo wrote:
> > These warnings appear on some platforms (arm multi_v7_defconfig). This
> > patch fixes these warnings.
> >
> > drivers/net/virtio_net.c: In function 'virtnet_rx_vq_reset':
> > drivers/net/virtio_net.c:1823:63: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat=]
> >  1823 |                    "reset rx reset vq fail: rx queue index: %ld err: %d\n",
> >       |                                                             ~~^
> >       |                                                               |
> >       |                                                               long int
> >       |                                                             %d
> >  1824 |                    rq - vi->rq, err);
> >       |                    ~~~~~~~~~~~
> >       |                       |
> >       |                       int
> > drivers/net/virtio_net.c: In function 'virtnet_tx_vq_reset':
> > drivers/net/virtio_net.c:1873:63: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat=]
> >  1873 |                    "reset tx reset vq fail: tx queue index: %ld err: %d\n",
> >       |                                                             ~~^
> >       |                                                               |
> >       |                                                               long int
> >       |                                                             %d
> >  1874 |                    sq - vi->sq, err);
> >       |                    ~~~~~~~~~~~
> >       |                       |
> >       |                       int
> >
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
> I squashed this into the problematic patch. Take a look
> at my tree to verify all's well pls.

LGTM.

Thanks.

>
> > ---
> >  drivers/net/virtio_net.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 1fa2d632a994..4d629d1ea894 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1820,7 +1820,7 @@ static int virtnet_rx_vq_reset(struct virtnet_info *vi,
> >
> >  err:
> >  	netdev_err(vi->dev,
> > -		   "reset rx reset vq fail: rx queue index: %ld err: %d\n",
> > +		   "reset rx reset vq fail: rx queue index: %td err: %d\n",
> >  		   rq - vi->rq, err);
> >  	virtnet_napi_enable(rq->vq, &rq->napi);
> >  	return err;
> > @@ -1870,7 +1870,7 @@ static int virtnet_tx_vq_reset(struct virtnet_info *vi,
> >
> >  err:
> >  	netdev_err(vi->dev,
> > -		   "reset tx reset vq fail: tx queue index: %ld err: %d\n",
> > +		   "reset tx reset vq fail: tx queue index: %td err: %d\n",
> >  		   sq - vi->sq, err);
> >  	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> >  	return err;
> > --
> > 2.31.0
>
