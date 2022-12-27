Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEB06568F9
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 10:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiL0Jju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 04:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiL0JjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 04:39:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39DE262F
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672133912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3BLtHqoydlVUf+z9Cs67tPhoqV/CQzv2c7yUWqYhoE=;
        b=FGXHCX7/J1P9lPs3V0pXOwU6ADXhRDfzVKrgxBwG4hveR07PHhDR2n8DN7kxtUr1ke64HC
        qZOI+aIAz5ABo0I3n2MANhvg81l3LHXSeBZLjNHTRGjIoIjedJK7v4pSQAlyKsAQrbT4/n
        vEXJVRbQ7SroHB8Gefiv7lKINgVVUW8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-EkAHTloHOXGa-f1_xlCGxw-1; Tue, 27 Dec 2022 04:38:30 -0500
X-MC-Unique: EkAHTloHOXGa-f1_xlCGxw-1
Received: by mail-ej1-f69.google.com with SMTP id sd1-20020a1709076e0100b00810be49e7afso8948228ejc.22
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:38:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J3BLtHqoydlVUf+z9Cs67tPhoqV/CQzv2c7yUWqYhoE=;
        b=YWVd/8mOiiAfsvk0LSQB5a498ds4QYXwGAYsbFrQtlHlu6JyMs/Vn84fFRYYxpciBr
         T48x5xnyUZL5hLkLooiOibJs7HMZADoK2xgG63wYEKq5Ww7WTU4VvA+t/lCKZAk/s7XY
         vwb9spBCBhU3F/slBFdfnQDzHHSpRfOakwXDcwYXYjha0vgM9fO8pu7AKjx03degjb9e
         mc+UOqKHO44gMvp9CFinJ0QZDlXoJPpStS9f0h7hkH0UBrtJtMAfbSjVD0buJVDblZNK
         PLs7PhiABrtMHhkn/nAaR2mWHdw9i2W1gEQsg3gEPd3O4mNHU16wWKsa7bNxOjXQER/A
         +uLw==
X-Gm-Message-State: AFqh2kphO4u4tMEzE5e/BpOnmI/rSnkrMGrz45e8KV1jwZFUnjcZ5DZd
        rVNXhzZo3E6cTRwdwEKVw+MG/+F//gQjAD2CSh4oAaYTfPwRgSsbzuZoM1D9QgRlBDgD/yciSiO
        Wm67ijRCj6LLslk/q
X-Received: by 2002:a17:907:7f04:b0:7c1:36:9002 with SMTP id qf4-20020a1709077f0400b007c100369002mr21415457ejc.67.1672133909657;
        Tue, 27 Dec 2022 01:38:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu1izE+/u+Tuwf8tjP2vCdjI4kLYsk008OtSrOIXpnLKNcCpaysWJW9Xx5P3ns02pTzhv/LQg==
X-Received: by 2002:a17:907:7f04:b0:7c1:36:9002 with SMTP id qf4-20020a1709077f0400b007c100369002mr21415444ejc.67.1672133909480;
        Tue, 27 Dec 2022 01:38:29 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906218900b007c4fbb79535sm5873901eju.82.2022.12.27.01.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 01:38:28 -0800 (PST)
Date:   Tue, 27 Dec 2022 04:38:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Message-ID: <20221227043148-mutt-send-email-mst@kernel.org>
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-4-jasowang@redhat.com>
 <20221226183705-mutt-send-email-mst@kernel.org>
 <CACGkMEuNZLJRnWw+XNxJ-to1y8L2GrTrJkk0y0Gwb5H2YhDczQ@mail.gmail.com>
 <20221227022255-mutt-send-email-mst@kernel.org>
 <d77bc1ce-b73f-1ba8-f04f-b3bffeb731c3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d77bc1ce-b73f-1ba8-f04f-b3bffeb731c3@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
> 
> 在 2022/12/27 15:33, Michael S. Tsirkin 写道:
> > On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
> > > > But device is still going and will later use the buffers.
> > > > 
> > > > Same for timeout really.
> > > Avoiding infinite wait/poll is one of the goals, another is to sleep.
> > > If we think the timeout is hard, we can start from the wait.
> > > 
> > > Thanks
> > If the goal is to avoid disrupting traffic while CVQ is in use,
> > that sounds more reasonable. E.g. someone is turning on promisc,
> > a spike in CPU usage might be unwelcome.
> 
> 
> Yes, this would be more obvious is UP is used.
> 
> 
> > 
> > things we should be careful to address then:
> > 1- debugging. Currently it's easy to see a warning if CPU is stuck
> >     in a loop for a while, and we also get a backtrace.
> >     E.g. with this - how do we know who has the RTNL?
> >     We need to integrate with kernel/watchdog.c for good results
> >     and to make sure policy is consistent.
> 
> 
> That's fine, will consider this.
> 
> 
> > 2- overhead. In a very common scenario when device is in hypervisor,
> >     programming timers etc has a very high overhead, at bootup
> >     lots of CVQ commands are run and slowing boot down is not nice.
> >     let's poll for a bit before waiting?
> 
> 
> Then we go back to the question of choosing a good timeout for poll. And
> poll seems problematic in the case of UP, scheduler might not have the
> chance to run.

Poll just a bit :) Seriously I don't know, but at least check once
after kick.

> 
> > 3- suprise removal. need to wake up thread in some way. what about
> >     other cases of device breakage - is there a chance this
> >     introduces new bugs around that? at least enumerate them please.
> 
> 
> The current code did:
> 
> 1) check for vq->broken
> 2) wakeup during BAD_RING()
> 
> So we won't end up with a never woke up process which should be fine.
> 
> Thanks


BTW BAD_RING on removal will trigger dev_err. Not sure that is a good
idea - can cause crashes if kernel panics on error.

> 
> > 
> > 

