Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C28689262
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjBCIe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjBCIen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:34:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D77570D79
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675413229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c9gia5gCXojDKJbnjBecgsqKUe4A6lVBjKVa+Q7BTrU=;
        b=Es+CFDeMQrAGZA/KkThcSvNXwe5vpbGJZXeKQxoddvNTcjN5jvOUGNp8SJhJgKjnFnWfy8
        FGtRJ7ZUAoKNRI2B6mY2Az+ngvrwpoWNQivK7J2G3kcBsnr4OeDwx7xwCmMkwAm4oq7OWa
        k1E5WEKIrk9Eat5/XgEpUp486a+lDuA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-BIPzZzhOPmqob1GjwSKwow-1; Fri, 03 Feb 2023 03:33:48 -0500
X-MC-Unique: BIPzZzhOPmqob1GjwSKwow-1
Received: by mail-wm1-f72.google.com with SMTP id n4-20020a05600c3b8400b003dfe223de49so1593790wms.5
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:33:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9gia5gCXojDKJbnjBecgsqKUe4A6lVBjKVa+Q7BTrU=;
        b=ldNSFNKeyI9GKrIbqNLwVCGjiKONCxUd7DZ1tlM6an+FBA8MwpdfmxZlUGnmkBFZA5
         eHrNTCxgzQvw5bZyTBoZ3ZiqHQ3wXcUr8RYkJrTlGI16fpU3LyHULgWdtzremPB3wnGx
         ScVM9xONCd9dKGpDJLI7ZUo27qxNHec7b8RtqtbEWRvK/DPmgg463uAf97xsjtR/24fV
         PnARGW5bjqPosRnKJDsKue6vvv8r7/emyXJKWSue0CVPcKf5mE0NBkpRBPKvLaK57X78
         GOLNulVeVrE4vTUX97wVHPeAIF+aq1JymoSjgAtmWcKJgWAzJaid/78w4LXBDvKFKIfL
         Ke8w==
X-Gm-Message-State: AO0yUKWSE50yaV8Pr8/QiMQ2u1r5TWp6MnGoPo0TkNG8/PIfGy0rSlUk
        ecr6uAZ3zybdW/XkMkQAhn2U452+ercMWe2gEm9+asz4jRFesqt1NcmM20z57KBI68REyjdJ1kk
        T8dMYaQAouzF2qmuC
X-Received: by 2002:a05:600c:1d03:b0:3dd:1bcc:eb17 with SMTP id l3-20020a05600c1d0300b003dd1bcceb17mr8913692wms.28.1675413226953;
        Fri, 03 Feb 2023 00:33:46 -0800 (PST)
X-Google-Smtp-Source: AK7set+Y8WwnwZ3TGibkgw7+NTRwE/wRyUdxNN+qG3QQe1IWY+jcAry8oCig/t9FCfmiWTBrHfVg6Q==
X-Received: by 2002:a05:600c:1d03:b0:3dd:1bcc:eb17 with SMTP id l3-20020a05600c1d0300b003dd1bcceb17mr8913678wms.28.1675413226764;
        Fri, 03 Feb 2023 00:33:46 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id m13-20020a05600c3b0d00b003dc51c48f0bsm7879692wms.19.2023.02.03.00.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 00:33:46 -0800 (PST)
Date:   Fri, 3 Feb 2023 03:33:41 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 24/33] virtio_net: xsk: stop disable tx napi
Message-ID: <20230203032945-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-25-xuanzhuo@linux.alibaba.com>
 <20230202122445-mutt-send-email-mst@kernel.org>
 <1675394682.9569418-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675394682.9569418-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 11:24:42AM +0800, Xuan Zhuo wrote:
> On Thu, 2 Feb 2023 12:25:59 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Thu, Feb 02, 2023 at 07:00:49PM +0800, Xuan Zhuo wrote:
> > > Since xsk's TX queue is consumed by TX NAPI, if sq is bound to xsk, then
> > > we must stop tx napi from being disabled.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >  drivers/net/virtio/main.c | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> > > index ed79e750bc6c..232cf151abff 100644
> > > --- a/drivers/net/virtio/main.c
> > > +++ b/drivers/net/virtio/main.c
> > > @@ -2728,8 +2728,15 @@ static int virtnet_set_coalesce(struct net_device *dev,
> > >  		return ret;
> > >
> > >  	if (update_napi) {
> > > -		for (i = 0; i < vi->max_queue_pairs; i++)
> > > +		for (i = 0; i < vi->max_queue_pairs; i++) {
> > > +			/* xsk xmit depend on the tx napi. So if xsk is active,
> >
> > depends.
> >
> > > +			 * prevent modifications to tx napi.
> > > +			 */
> > > +			if (rtnl_dereference(vi->sq[i].xsk.pool))
> > > +				continue;
> > > +
> > >  			vi->sq[i].napi.weight = napi_weight;
> >
> > I don't get it.
> > changing napi weight does not work then.
> > why is this ok?
> 
> 
> static void skb_xmit_done(struct virtqueue *vq)
> {
> 	struct virtnet_info *vi = vq->vdev->priv;
> 	struct napi_struct *napi = &vi->sq[vq2txq(vq)].napi;
> 
> 	/* Suppress further interrupts. */
> 	virtqueue_disable_cb(vq);
> 
> 	if (napi->weight)
> 		virtqueue_napi_schedule(napi, vq);
> 	else
> 		/* We were probably waiting for more output buffers. */
> 		netif_wake_subqueue(vi->dev, vq2txq(vq));
> }
> 
> 
> If the weight is 0, tx napi will not be triggered again.
> 
> Thanks.

This needs more thought then. First ignoring what user is requesting is
not nice.  Second what if napi is first disabled and then xsk enabled?


> >
> >
> > > +		}
> > >  	}
> > >
> > >  	return ret;
> > > --
> > > 2.32.0.3.g01195cf9f
> >

