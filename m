Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48CD6F0277
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242916AbjD0IYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjD0IYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:24:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1537649D5
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682583838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W8usmC3JGK9PorB0wAqvMMI+OvA7gcjYhdZApmddriY=;
        b=N+faVCjZTFN00z42gAqKl3oYG9GRn6FRnRrF737cQBGA7P9wCKTnNjo55m4c7f0YyDrKlq
        +xcKGfU8CJ3qMYDjRDEKN2x+52t+SuEXbFdL4SAJ0q2tvisBcaHEaVYS6pc7ylMv5ZSDCN
        wprGYQhh+UoT7waG3J30G8nCkjjpxBo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-6szEt6XCPAGdMidXb4b2Dw-1; Thu, 27 Apr 2023 04:23:56 -0400
X-MC-Unique: 6szEt6XCPAGdMidXb4b2Dw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30467a7020eso3836349f8f.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682583835; x=1685175835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8usmC3JGK9PorB0wAqvMMI+OvA7gcjYhdZApmddriY=;
        b=ACxeiNViF+YNqj9Wu52yJBZINwW7Xy9Fuofy+OdIEFIL4P4i1oc8AKo+I7H70fgH8c
         clKya6AEnRjSUOwE8oYretwUWB30ZjZejNsy/wUlbq68d/1zBZBhh8B+jv35pHChw/oz
         JpLdbNZHPyQmQ8Ui2OAZp2ETLb4TcaCbXciQStQun9oxX37LNXYOK6flARNyp2bWobog
         0FEd+kfs5/rCTcwuecLBq+/0o8e9kkFKGiKLdtdaLeF7307T5iBS5ewz6I9wvj4Mjc9Z
         WtXe6TPK21b0ETTh7iWRw6Ep31iDXzP8NPW8BnfjmSj8k4Tz231/SsdkLc6nVw5X06df
         At/g==
X-Gm-Message-State: AC+VfDw5p157fuUWtJgne4DTGS8sBPsNujnI4ErEtapV8g6MAOZUj4Rj
        BcKWgmMI7qlxKxYtVplvwaXmyptGfenzB68dpiD2K14hQF+Z4klve6nmWj64LqRTC5jdjcBcmqq
        tQq3ZFqDgvRIBYLod
X-Received: by 2002:adf:db8e:0:b0:2fe:f2d1:dcab with SMTP id u14-20020adfdb8e000000b002fef2d1dcabmr580404wri.58.1682583835562;
        Thu, 27 Apr 2023 01:23:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7rQyd/2UisYbyEnSs2VvV3WiCVMyj0AWWY8+sZq//VJGg92r0G4dwgdN0gnhvMCRphC2USAQ==
X-Received: by 2002:adf:db8e:0:b0:2fe:f2d1:dcab with SMTP id u14-20020adfdb8e000000b002fef2d1dcabmr580392wri.58.1682583835248;
        Thu, 27 Apr 2023 01:23:55 -0700 (PDT)
Received: from redhat.com ([2.52.19.183])
        by smtp.gmail.com with ESMTPSA id b4-20020a05600010c400b002e45f6ffe63sm17892253wrx.26.2023.04.27.01.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 01:23:54 -0700 (PDT)
Date:   Thu, 27 Apr 2023 04:23:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Wenliang Wang <wangwenliang.1995@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jasowang@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH] virtio_net: suppress cpu stall when free_unused_bufs
Message-ID: <20230427042259-mutt-send-email-mst@kernel.org>
References: <20230427043433.2594960-1-wangwenliang.1995@bytedance.com>
 <1682576442.2203932-1-xuanzhuo@linux.alibaba.com>
 <252ee222-f918-426e-68ef-b3710a60662e@bytedance.com>
 <1682579624.5395834-1-xuanzhuo@linux.alibaba.com>
 <20230427041206-mutt-send-email-mst@kernel.org>
 <1682583225.3180113-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682583225.3180113-2-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 04:13:45PM +0800, Xuan Zhuo wrote:
> On Thu, 27 Apr 2023 04:12:44 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Thu, Apr 27, 2023 at 03:13:44PM +0800, Xuan Zhuo wrote:
> > > On Thu, 27 Apr 2023 15:02:26 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
> > > >
> > > >
> > > > On 4/27/23 2:20 PM, Xuan Zhuo wrote:
> > > > > On Thu, 27 Apr 2023 12:34:33 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
> > > > >> For multi-queue and large rx-ring-size use case, the following error
> > > > >
> > > > > Cound you give we one number for example?
> > > >
> > > > 128 queues and 16K queue_size is typical.
> > > >
> > > > >
> > > > >> occurred when free_unused_bufs:
> > > > >> rcu: INFO: rcu_sched self-detected stall on CPU.
> > > > >>
> > > > >> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> > > > >> ---
> > > > >>   drivers/net/virtio_net.c | 1 +
> > > > >>   1 file changed, 1 insertion(+)
> > > > >>
> > > > >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > >> index ea1bd4bb326d..21d8382fd2c7 100644
> > > > >> --- a/drivers/net/virtio_net.c
> > > > >> +++ b/drivers/net/virtio_net.c
> > > > >> @@ -3565,6 +3565,7 @@ static void free_unused_bufs(struct virtnet_info *vi)
> > > > >>   		struct virtqueue *vq = vi->rq[i].vq;
> > > > >>   		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
> > > > >>   			virtnet_rq_free_unused_buf(vq, buf);
> > > > >> +		schedule();
> > > > >
> > > > > Just for rq?
> > > > >
> > > > > Do we need to do the same thing for sq?
> > > > Rq buffers are pre-allocated, take seconds to free rq unused buffers.
> > > >
> > > > Sq unused buffers are much less, so do the same for sq is optional.
> > >
> > > I got.
> > >
> > > I think we should look for a way, compatible with the less queues or the smaller
> > > rings. Calling schedule() directly may be not a good way.
> > >
> > > Thanks.
> >
> > Why isn't it a good way?
> 
> For the small ring, I don't think it is a good way, maybe we only deal with one
> buf, then call schedule().
> 
> We can call the schedule() after processing a certain number of buffers,
> or check need_resched () first.
> 
> Thanks.


Wenliang, does
            if (need_resched())
                    schedule();
fix the issue for you?


> 
> 
> >
> > >
> > > >
> > > > >
> > > > > Thanks.
> > > > >
> > > > >
> > > > >>   	}
> > > > >>   }
> > > > >>
> > > > >> --
> > > > >> 2.20.1
> > > > >>
> >

