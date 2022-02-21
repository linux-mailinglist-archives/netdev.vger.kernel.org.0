Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40484BE4F1
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381038AbiBUQqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:46:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381036AbiBUQpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:45:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23A2D22BC6
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645461915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2jCd2Sdu68baOqSAUXyeGtOrHHK9pSxZFX8k82IulA=;
        b=GXyJMSy0mAwL8KdCHUIyw0R3Pwh+WI6BvvJ5SmaFVZaRpqg4xgfacHEuRr+uZTrkB7iJIB
        t+OKGdZimDv88QRoNrRsjA/mqL6liNHrm01ZvEcTHBtYoVzp81I1HQbEBF9copL2QscZBo
        SCy7xyPb15W28r2nEaN1HAsqJj2kv5I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-I0vA3XfWMoG1rRjU8Bg1YA-1; Mon, 21 Feb 2022 11:45:14 -0500
X-MC-Unique: I0vA3XfWMoG1rRjU8Bg1YA-1
Received: by mail-wr1-f70.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so7642761wrg.19
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:45:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=b2jCd2Sdu68baOqSAUXyeGtOrHHK9pSxZFX8k82IulA=;
        b=fX/udevc8Od9PNG7Al8Dyn5DRksmn1db8Is5DyWU3HIJuA5ilBaIvsvw7Jvs/VJDbx
         9S1OSxEyFKqj/P4YDAL6dVef5BOSo7zxcURRAYJamRSQHKevcHHKeoK1QS4bf0vsaZ+x
         0HQd7jM3pwO69LZbg5Om7cxJNYHEA7oxqBXo936UOkcLoHK2gD+W/46IlCtBeqq88j3m
         KUT+Qggj0ReDSIuDpc1xK1n9Fs6qiYWf2jio0uItbN7ojbOG/GFGRrR8gY1GFAdHW85E
         Y2qSPMKMOvSCgkQMR3tYfq15SFygV2enFP7njfTrpj3U20o1em0aVkErwEf710u+XkIG
         5BIw==
X-Gm-Message-State: AOAM5322iDU5oTRK17bGzC5nNNSH7qVLZSCTR69RyN0ccQwLfUAmlECv
        0t1oozF2OXVjE+UuT3JL1Rha3i1x/TJB1GSU4oiC/VPUAXjmFc5yRwtDQ0KOK75p6l7PDtWEPnn
        5x29/0Y3DfBn8XFAA
X-Received: by 2002:a5d:4d0d:0:b0:1e3:200f:d6d1 with SMTP id z13-20020a5d4d0d000000b001e3200fd6d1mr16397572wrt.76.1645461912859;
        Mon, 21 Feb 2022 08:45:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvLrjIr6tjmz6KJu9euZ2haPzC0DNswMfVVAl2P2dzhlK7Z4SC3cFSeqpqKtbHwPK8j+XasA==
X-Received: by 2002:a5d:4d0d:0:b0:1e3:200f:d6d1 with SMTP id z13-20020a5d4d0d000000b001e3200fd6d1mr16397560wrt.76.1645461912645;
        Mon, 21 Feb 2022 08:45:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-108-216.dyn.eolo.it. [146.241.108.216])
        by smtp.gmail.com with ESMTPSA id s7sm21152558wro.104.2022.02.21.08.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 08:45:12 -0800 (PST)
Message-ID: <7896488c10ef95255b3fef157cede5ad77d9a8cd.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] gro_cells: avoid using synchronize_rcu() in
 gro_cells_destroy()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Date:   Mon, 21 Feb 2022 17:45:11 +0100
In-Reply-To: <CANn89iJoBqcBLD8GbJhNYN2cKZiSC=vn4L9RCsNs2Nd4HHhu_A@mail.gmail.com>
References: <20220220041155.607637-1-eric.dumazet@gmail.com>
         <294021ae1fae426d868195be77b053bd66f31772.camel@redhat.com>
         <CANn89iJoBqcBLD8GbJhNYN2cKZiSC=vn4L9RCsNs2Nd4HHhu_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-02-21 at 06:21 -0800, Eric Dumazet wrote:
> On Mon, Feb 21, 2022 at 12:24 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > Hello,
> > 
> > On Sat, 2022-02-19 at 20:11 -0800, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > > 
> > > Another thing making netns dismantles potentially very slow is located
> > > in gro_cells_destroy(),
> > > whenever cleanup_net() has to remove a device using gro_cells framework.
> > > 
> > > RTNL is not held at this stage, so synchronize_net()
> > > is calling synchronize_rcu():
> > > 
> > > netdev_run_todo()
> > >  ip_tunnel_dev_free()
> > >   gro_cells_destroy()
> > >    synchronize_net()
> > >     synchronize_rcu() // Ouch.
> > > 
> > > This patch uses call_rcu(), and gave me a 25x performance improvement
> > > in my tests.
> > > 
> > > cleanup_net() is no longer blocked ~10 ms per synchronize_rcu()
> > > call.
> > > 
> > > In the case we could not allocate the memory needed to queue the
> > > deferred free, use synchronize_rcu_expedited()
> > > 
> > > v2: made percpu_free_defer_callback() static
> > > 
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > 
> > I'm sorry for the late feedback. I'm wondering if you considered
> > placing the 'defer' pointer inside 'gro_cells' and allocating it at
> > gro_cells_init() init time?
> 
> I did consider this, but I chose not to risk changing structure
> layouts and adding regression in fast paths,
> with extra cache line misses.

Understood, thanks!

Acked-by: Paolo Abeni <pabeni@redhat.com>

