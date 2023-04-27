Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1256F025E
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242817AbjD0INo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242911AbjD0INk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:13:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA90230C5
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682583170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aB49IfnVQxAVPmxftGfpUlkFmuC67pXs44wakcN9xOc=;
        b=FbtH4z5/qDj7PFm8i0yJ7N2co9K6XrcBnFGK70M7CGpVRn1Eu84v6brftUJIn03rKyU9RD
        IDcouofHxNpGwosWyB7gK1p83s9/0V1j7Wu9Rp2ry0MpZiW5jOPVrcHlXlie2yf2QSEW9n
        CuNdNPVjHfZRlEBadDEWOvx7vm0PNPU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-23tygi6MOiGq7nFR-l8U0Q-1; Thu, 27 Apr 2023 04:12:49 -0400
X-MC-Unique: 23tygi6MOiGq7nFR-l8U0Q-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-2f92bd71f32so2682426f8f.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:12:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682583168; x=1685175168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aB49IfnVQxAVPmxftGfpUlkFmuC67pXs44wakcN9xOc=;
        b=lF8DXYqlqurqIdmghuh1lxGvK5yHAmg92BP8TxX/6qlHe7mjhVEQ78g9LOyJPeO2Pt
         PLnVSJ9awzoLiOtuFlZPYDbyi6RJ8IRsjO9x6hbT18bLyOKmx/N4p8+YXtU1MrTe0lIO
         laFrGvUBWlM5cC6QKAeOXtDBNhnyDE+2SAQ8Ujx2sLOwlNoxxU1ReFhPAOlV+b/fRg5w
         n4bpbwBDG+a40ZDFnxHiLhJUca8elvNNaTMJtnU/Ugcq3w3IP15lA9WrwMDVN6aMBTOs
         7FzexFLYAUXLVtnIGKLRr1WnOF2ykL3syUCsjrCMto8g5fuswPzDQKGpfK7/EJekZdVM
         9zuw==
X-Gm-Message-State: AC+VfDzMPwfM7GgqKyrnjtqhMHj3WOSrs/7PXWxhlIvUSrM4P89QavCk
        m5AcJWrd6sSpBZm3SpU+KcdIRh+TECsFXx8OUFTydbJ9ZP1NQ/0nl09t/00JrLAh0IBPCJh1bjh
        y1oFsnxDDLt3VNFnU
X-Received: by 2002:adf:f64c:0:b0:2f9:a75:b854 with SMTP id x12-20020adff64c000000b002f90a75b854mr536190wrp.59.1682583168408;
        Thu, 27 Apr 2023 01:12:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5emRcma09Oxn5dJrEsZwosfPxvNpGMisqE8jgCL0zI/xRIB9M5uqzHDqbC55yckTxtp6HXjQ==
X-Received: by 2002:adf:f64c:0:b0:2f9:a75:b854 with SMTP id x12-20020adff64c000000b002f90a75b854mr536175wrp.59.1682583168106;
        Thu, 27 Apr 2023 01:12:48 -0700 (PDT)
Received: from redhat.com ([2.52.19.183])
        by smtp.gmail.com with ESMTPSA id m2-20020a056000008200b002f53fa16239sm17804457wrx.103.2023.04.27.01.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 01:12:47 -0700 (PDT)
Date:   Thu, 27 Apr 2023 04:12:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Wenliang Wang <wangwenliang.1995@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jasowang@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH] virtio_net: suppress cpu stall when free_unused_bufs
Message-ID: <20230427041206-mutt-send-email-mst@kernel.org>
References: <20230427043433.2594960-1-wangwenliang.1995@bytedance.com>
 <1682576442.2203932-1-xuanzhuo@linux.alibaba.com>
 <252ee222-f918-426e-68ef-b3710a60662e@bytedance.com>
 <1682579624.5395834-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682579624.5395834-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 03:13:44PM +0800, Xuan Zhuo wrote:
> On Thu, 27 Apr 2023 15:02:26 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
> >
> >
> > On 4/27/23 2:20 PM, Xuan Zhuo wrote:
> > > On Thu, 27 Apr 2023 12:34:33 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
> > >> For multi-queue and large rx-ring-size use case, the following error
> > >
> > > Cound you give we one number for example?
> >
> > 128 queues and 16K queue_size is typical.
> >
> > >
> > >> occurred when free_unused_bufs:
> > >> rcu: INFO: rcu_sched self-detected stall on CPU.
> > >>
> > >> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> > >> ---
> > >>   drivers/net/virtio_net.c | 1 +
> > >>   1 file changed, 1 insertion(+)
> > >>
> > >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > >> index ea1bd4bb326d..21d8382fd2c7 100644
> > >> --- a/drivers/net/virtio_net.c
> > >> +++ b/drivers/net/virtio_net.c
> > >> @@ -3565,6 +3565,7 @@ static void free_unused_bufs(struct virtnet_info *vi)
> > >>   		struct virtqueue *vq = vi->rq[i].vq;
> > >>   		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
> > >>   			virtnet_rq_free_unused_buf(vq, buf);
> > >> +		schedule();
> > >
> > > Just for rq?
> > >
> > > Do we need to do the same thing for sq?
> > Rq buffers are pre-allocated, take seconds to free rq unused buffers.
> >
> > Sq unused buffers are much less, so do the same for sq is optional.
> 
> I got.
> 
> I think we should look for a way, compatible with the less queues or the smaller
> rings. Calling schedule() directly may be not a good way.
> 
> Thanks.

Why isn't it a good way?

> 
> >
> > >
> > > Thanks.
> > >
> > >
> > >>   	}
> > >>   }
> > >>
> > >> --
> > >> 2.20.1
> > >>

