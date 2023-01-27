Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1846667E1BF
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjA0KgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjA0Kf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:35:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386CF79632
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674815711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BmJzvPHJ7QD6G8a76242dw/sy7+JnW9AjIP8xDPumTk=;
        b=VJd58vShBu2/IsZjD+PxyXoe8r8RFD0bYrBI81JgQq/tOffCpbQ7t2HeFDx2Gk/xzrJrbv
        cbnUIClOROqh7KeaLgYjU/F82HM/vjxDI6OG0RGsfjPm6fSUhJ2uAFoyZm1ovXsnLlay0N
        TyzLfH2+g5lo1pdSOSz1vl8AZIeiVig=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-146-KqbcSuAIOIu677mnCKR1mg-1; Fri, 27 Jan 2023 05:35:09 -0500
X-MC-Unique: KqbcSuAIOIu677mnCKR1mg-1
Received: by mail-ej1-f69.google.com with SMTP id hc30-20020a170907169e00b0086d90ee8b17so3190631ejc.10
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:35:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BmJzvPHJ7QD6G8a76242dw/sy7+JnW9AjIP8xDPumTk=;
        b=KTeu3BpqIiWQYJi+T6lgS0mLdljmc5FhXjjPv+qCMvkBuIQC+IGY7jaMPXl/8DiLLd
         HwgI+HgPJhlyrI6SKoUfVNM9NRhp4zqYblhDV3WivymPDbtg90AfdNWyt/obrKi0w/CM
         HSkz4mgYwtGGAtiV0JmIXlEtz+jwy5Qz29O+na4Uxe7WbzGtj7BbmQxrqCtq0gBvawPy
         foQZTHCkhrIz+dak0MNkGtgd60JEaopr7lJQ4+v6cIr+NBUfvJANmBBA5drUOUx8w/u2
         LVt4OODQ2h2Q6030RA8HE/wGcHrvmfuWEddvssOcyYzjcpvuEtq3eKYSyGArHXWi6B5y
         j1+A==
X-Gm-Message-State: AO0yUKV/ODA5uqvK39uzjZSCvYDQur6MY+SbFalnAKWTdETRJdsRLFZ9
        rWuITLk9N6BA5rvvow0uZfBuWWL9yh0fZbM4E4ihOZFumMTZ9tEs2Q5EN6c7DBAAs9lDSvYQ2zL
        6YArX7l3hHl/7C6C/
X-Received: by 2002:a17:906:2c03:b0:878:734d:1d87 with SMTP id e3-20020a1709062c0300b00878734d1d87mr4305392ejh.47.1674815708661;
        Fri, 27 Jan 2023 02:35:08 -0800 (PST)
X-Google-Smtp-Source: AK7set+Nl6mfZMXpMHEPp5fPvGNYfYrMOBQ2Ev96amqK7f0vTZb6Yf4j1LsKeLNpRExCWSkCWQk/bA==
X-Received: by 2002:a17:906:2c03:b0:878:734d:1d87 with SMTP id e3-20020a1709062c0300b00878734d1d87mr4305377ejh.47.1674815708416;
        Fri, 27 Jan 2023 02:35:08 -0800 (PST)
Received: from redhat.com ([2.52.137.69])
        by smtp.gmail.com with ESMTPSA id kv15-20020a17090778cf00b007bd28b50305sm1998997ejc.200.2023.01.27.02.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:35:07 -0800 (PST)
Date:   Fri, 27 Jan 2023 05:35:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Message-ID: <20230127053112-mutt-send-email-mst@kernel.org>
References: <CACGkMEuNZLJRnWw+XNxJ-to1y8L2GrTrJkk0y0Gwb5H2YhDczQ@mail.gmail.com>
 <20221227022255-mutt-send-email-mst@kernel.org>
 <d77bc1ce-b73f-1ba8-f04f-b3bffeb731c3@redhat.com>
 <20221227043148-mutt-send-email-mst@kernel.org>
 <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
 <CACGkMEv=+D+Es4sfde_X7F0zspVdy4Rs1Wi9qfCudsznsUrOTQ@mail.gmail.com>
 <20221229020553-mutt-send-email-mst@kernel.org>
 <CACGkMEs5s3Muo+4OfjaLK_P76rTdPhjQdTwykRNGOecAWnt+8g@mail.gmail.com>
 <20221229030633-mutt-send-email-mst@kernel.org>
 <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 30, 2022 at 11:43:08AM +0800, Jason Wang wrote:
> On Thu, Dec 29, 2022 at 4:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Dec 29, 2022 at 04:04:13PM +0800, Jason Wang wrote:
> > > On Thu, Dec 29, 2022 at 3:07 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Wed, Dec 28, 2022 at 07:53:08PM +0800, Jason Wang wrote:
> > > > > On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > > >
> > > > > >
> > > > > > 在 2022/12/27 17:38, Michael S. Tsirkin 写道:
> > > > > > > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
> > > > > > >> 在 2022/12/27 15:33, Michael S. Tsirkin 写道:
> > > > > > >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
> > > > > > >>>>> But device is still going and will later use the buffers.
> > > > > > >>>>>
> > > > > > >>>>> Same for timeout really.
> > > > > > >>>> Avoiding infinite wait/poll is one of the goals, another is to sleep.
> > > > > > >>>> If we think the timeout is hard, we can start from the wait.
> > > > > > >>>>
> > > > > > >>>> Thanks
> > > > > > >>> If the goal is to avoid disrupting traffic while CVQ is in use,
> > > > > > >>> that sounds more reasonable. E.g. someone is turning on promisc,
> > > > > > >>> a spike in CPU usage might be unwelcome.
> > > > > > >>
> > > > > > >> Yes, this would be more obvious is UP is used.
> > > > > > >>
> > > > > > >>
> > > > > > >>> things we should be careful to address then:
> > > > > > >>> 1- debugging. Currently it's easy to see a warning if CPU is stuck
> > > > > > >>>      in a loop for a while, and we also get a backtrace.
> > > > > > >>>      E.g. with this - how do we know who has the RTNL?
> > > > > > >>>      We need to integrate with kernel/watchdog.c for good results
> > > > > > >>>      and to make sure policy is consistent.
> > > > > > >>
> > > > > > >> That's fine, will consider this.
> > > > >
> > > > > So after some investigation, it seems the watchdog.c doesn't help. The
> > > > > only export helper is touch_softlockup_watchdog() which tries to avoid
> > > > > triggering the lockups warning for the known slow path.
> > > >
> > > > I never said you can just use existing exporting APIs. You'll have to
> > > > write new ones :)
> > >
> > > Ok, I thought you wanted to trigger similar warnings as a watchdog.
> > >
> > > Btw, I wonder what kind of logic you want here. If we switch to using
> > > sleep, there won't be soft lockup anymore. A simple wait + timeout +
> > > warning seems sufficient?
> > >
> > > Thanks
> >
> > I'd like to avoid need to teach users new APIs. So watchdog setup to apply
> > to this driver. The warning can be different.
> 
> Right, so it looks to me the only possible setup is the
> watchdog_thres. I plan to trigger the warning every watchdog_thres * 2
> second (as softlockup did).
> 
> And I think it would still make sense to fail, we can start with a
> very long timeout like 1 minutes and break the device. Does this make
> sense?
> 
> Thanks

I'd say we need to make this manageable then. Can't we do it normally
e.g. react to an interrupt to return to userspace?



> >
> >
> > > >
> > > > > And before the patch, we end up with a real infinite loop which could
> > > > > be caught by RCU stall detector which is not the case of the sleep.
> > > > > What we can do is probably do a periodic netdev_err().
> > > > >
> > > > > Thanks
> > > >
> > > > Only with a bad device.
> > > >
> > > > > > >>
> > > > > > >>
> > > > > > >>> 2- overhead. In a very common scenario when device is in hypervisor,
> > > > > > >>>      programming timers etc has a very high overhead, at bootup
> > > > > > >>>      lots of CVQ commands are run and slowing boot down is not nice.
> > > > > > >>>      let's poll for a bit before waiting?
> > > > > > >>
> > > > > > >> Then we go back to the question of choosing a good timeout for poll. And
> > > > > > >> poll seems problematic in the case of UP, scheduler might not have the
> > > > > > >> chance to run.
> > > > > > > Poll just a bit :) Seriously I don't know, but at least check once
> > > > > > > after kick.
> > > > > >
> > > > > >
> > > > > > I think it is what the current code did where the condition will be
> > > > > > check before trying to sleep in the wait_event().
> > > > > >
> > > > > >
> > > > > > >
> > > > > > >>> 3- suprise removal. need to wake up thread in some way. what about
> > > > > > >>>      other cases of device breakage - is there a chance this
> > > > > > >>>      introduces new bugs around that? at least enumerate them please.
> > > > > > >>
> > > > > > >> The current code did:
> > > > > > >>
> > > > > > >> 1) check for vq->broken
> > > > > > >> 2) wakeup during BAD_RING()
> > > > > > >>
> > > > > > >> So we won't end up with a never woke up process which should be fine.
> > > > > > >>
> > > > > > >> Thanks
> > > > > > >
> > > > > > > BTW BAD_RING on removal will trigger dev_err. Not sure that is a good
> > > > > > > idea - can cause crashes if kernel panics on error.
> > > > > >
> > > > > >
> > > > > > Yes, it's better to use __virtqueue_break() instead.
> > > > > >
> > > > > > But consider we will start from a wait first, I will limit the changes
> > > > > > in virtio-net without bothering virtio core.
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > >
> > > > > > >
> > > > > > >>>
> > > >
> >

