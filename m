Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A755F10DC
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiI3Rar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbiI3RaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:30:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FECC80DB
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 10:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664559017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJEg+XbDXK2RWREInhbLrkA1YKp/rqXrap7N/22tN7U=;
        b=i3aawZPpC1ZxIo0sYJQ4pNgx2UfSZzXicGjmJjI+S2kUbfUy6JzQTFhUQOszXG9GPNhPeu
        i00QciUfEYVcFYdC00Gq5MgT0dsSFxA9cvHwC8SJMtNt7hOYD/dXEhK9+rAq/e+5NEeumR
        qgPbBFNZiFwysG61POZtwwF1Tyh4q0M=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-60-lud4LaY9Pa-nmXp1ZIepEw-1; Fri, 30 Sep 2022 13:30:13 -0400
X-MC-Unique: lud4LaY9Pa-nmXp1ZIepEw-1
Received: by mail-qv1-f71.google.com with SMTP id g12-20020a0cfdcc000000b004ad431ceee0so3252440qvs.7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 10:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=mJEg+XbDXK2RWREInhbLrkA1YKp/rqXrap7N/22tN7U=;
        b=7GGBUSVoohmGXIASaemLOfSqbWkrU5HzUMWIo5OdDebJjR/jOKaWf17E+9aXgLlLzv
         USQWqCig/dgzdd+MaOcZb1Jp0mD6uNClExIWdXTfQQ8qYUBc8UPbQDu//wcds81VvyOO
         RmEul8ig9JY3iJSVKu38BJ245ahNa/H7yL5NoZChI1YSbrybRXQDhhNq9Hn3K61q39uM
         7B34EF2ORX649k3sEchXRDs2aKFYSYYK6AzIN+kU8M7je8aDGT8moZjpwncBOxMbbBjl
         MyBCJEYRd5oMdEdQHGscD22i2/CrcHGkCLYSYj5KtwVU1Ehd9npLfgGDC4SbZ7kFr3d2
         amjQ==
X-Gm-Message-State: ACrzQf0MleQaCQHybHRgdmrRQJG6GGEd6EmF7FNCxSn6AmuWBmqkvvwX
        zyNlIUTrLFWo2Mt2/8Eagsu7TEbqJWvLbEWE07DOsZ9CmzATB8sFYLIUoXyenO6BH6hUD32I1ey
        ElcLk0m9cnG8hAF7r
X-Received: by 2002:a05:620a:280e:b0:6a6:ee16:8c78 with SMTP id f14-20020a05620a280e00b006a6ee168c78mr6889721qkp.122.1664559012682;
        Fri, 30 Sep 2022 10:30:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5+QOAmd4WPdGtcLAEp85goNgWGUrP5hndenM+wvDkNCNfKxpSc1tUHc5ukya6vZoN07GNpqA==
X-Received: by 2002:a05:620a:280e:b0:6a6:ee16:8c78 with SMTP id f14-20020a05620a280e00b006a6ee168c78mr6889704qkp.122.1664559012423;
        Fri, 30 Sep 2022 10:30:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id h17-20020a05620a245100b006ccc96c78easm3026652qkn.134.2022.09.30.10.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 10:30:11 -0700 (PDT)
Message-ID: <cdbfe4615ffec2bcfde94268dbc77dfa98143f39.camel@redhat.com>
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page
 frag cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        patchwork-bot+netdevbpf@kernel.org
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Date:   Fri, 30 Sep 2022 19:30:08 +0200
In-Reply-To: <CANn89iJ=_e9-P4dvRcMzJYqpTBQ5kevEvaYFH1JVvSdv4sguhA@mail.gmail.com>
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
         <166450446690.30186.16482162810476880962.git-patchwork-notify@kernel.org>
         <CANn89iJ=_e9-P4dvRcMzJYqpTBQ5kevEvaYFH1JVvSdv4sguhA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-09-30 at 09:43 -0700, Eric Dumazet wrote:
> On Thu, Sep 29, 2022 at 7:21 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > 
> > Hello:
> > 
> > This patch was applied to netdev/net-next.git (master)
> > by Jakub Kicinski <kuba@kernel.org>:
> > 
> > On Wed, 28 Sep 2022 10:43:09 +0200 you wrote:
> > > After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> > > for tiny skbs") we are observing 10-20% regressions in performance
> > > tests with small packets. The perf trace points to high pressure on
> > > the slab allocator.
> > > 
> > > This change tries to improve the allocation schema for small packets
> > > using an idea originally suggested by Eric: a new per CPU page frag is
> > > introduced and used in __napi_alloc_skb to cope with small allocation
> > > requests.
> > > 
> > > [...]
> > 
> > Here is the summary with links:
> >   - [net-next,v4] net: skb: introduce and use a single page frag cache
> >     https://git.kernel.org/netdev/net-next/c/dbae2b062824
> > 
> 
> Paolo, this patch adds a regression for TCP RPC workloads (aka TCP_RR)
> 
> Before the patch, cpus servicing NIC interrupts were allocating
> SLAB/SLUB objects for incoming packets,
> but they were also freeing skbs from TCP rtx queues when ACK packets
> were processed. SLAB/SLUB caches
> were efficient (hit ratio close to 100%)

Thank you for the report. Is that reproducible with netperf TCP_RR and
CONFIG_DEBUG_SLAB, I guess? Do I need specific request/response sizes?

Do you think a revert will be needed for 6.1?

> After the patch, these CPU only free skbs from TCP rtx queues and
> constantly have to drain their alien caches,
> thus competing with the mm spinlocks. RX skbs allocations being done
> by page frag allocation only left kfree(~1KB) calls.
> 
> One way to avoid the asymmetric behavior would be to switch TCP to
> also use page frags for TX skbs,
> allocated from tcp_stream_alloc_skb()

I guess we should have:

	if (<alloc size is small and NAPI_HAS_SMALL_PAGE>)
		<use small page frag>
	else
		<use current allocator>

right in tcp_stream_alloc_skb()? or all the way down to __alloc_skb()?

Thanks!

Paolo



> 

