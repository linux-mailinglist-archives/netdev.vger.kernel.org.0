Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0646B6F1038
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 04:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjD1CNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 22:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjD1CNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 22:13:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95978269D
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 19:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3576563F6C
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 02:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4E8C433D2;
        Fri, 28 Apr 2023 02:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682648018;
        bh=wBO59fBc7nVvknmFcmAemEkuDJz9UlbXZ3t7brVhcRI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oOTPTV2idJ41VsvS0gQrZgNmmLnUwy1xl22HnFbZogI2Rx2z35iWA1AybxKqqj5Se
         bAekeDUN5b3DoUb8cJeF31AFHs8bS4azCbOZl+VR01j5sj5vpltBnB0uehgcHs3qfV
         F15j62pnEvXZvWkQj7hiwe4vVgBPUaSOkOiLmN1GQTL6cHUtESFRDnt/NE0aZhF9mK
         SCi+kyCBaFYOI6pTKnQgoH/C7qx/RP0+02IjNCYysg7vD/sQf8jQU0802P6in9Nef4
         vmhrGUavUJ4sOv8GZKQnGHmqPhobdFSW7f/Wli9xRMn5R8DyCEcHU0of3Hjbw6tp56
         6i2/1OqWxYuAg==
Message-ID: <3cfdd719-900b-88cf-3fe4-fb277e68325f@kernel.org>
Date:   Thu, 27 Apr 2023 20:13:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net] tcp: fix skb_copy_ubufs() vs BIG TCP
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Willem de Bruijn <willemb@google.com>,
        Coco Li <lixiaoyan@google.com>
References: <20230427192404.315287-1-edumazet@google.com>
 <0fa1d0a7-172e-12ca-99c5-d4cf25f2bfef@kernel.org>
 <644ae750da711_26f41f294eb@willemb.c.googlers.com.notmuch>
 <CADvbK_eX0t9KGuhdERweue3BkefVtzZx-ZQBVhfe8jb1aO6eZw@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CADvbK_eX0t9KGuhdERweue3BkefVtzZx-ZQBVhfe8jb1aO6eZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/23 6:40 PM, Xin Long wrote:
> 
> I just ran David's test scripts in a metal machine:
> 
> There seem memleak with this patch, and the performance is impaired too:
> 
> # free -h
>               total        used        free      shared  buff/cache  
> available
> Mem:           31Gi       999Mi        30Gi        12Mi       303Mi    
>    30Gi


I can confirm the memleak; thanks for noticing that. It is really easy
to reproduce on a real nic by just running tcpdump with large tso packets.



> 
> I could also see some call trace:
> 
> [  271.416989] warn_alloc: 640 callbacks suppressed
> [  271.417006] lt-iperf3: page allocation failure: order:1,
> mode:0x820(GFP_ATOMIC), nodemask=(null),cpuset=/,mems_allowed=0-1
> [  271.432684] CPU: 1 PID: 2218 Comm: lt-iperf3 Tainted: G S            
>     6.3.0.net0 #10
> [  271.440783] Hardware name: Supermicro
> X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.2  06/04/2015
> [  271.449831] Call Trace:
> [  271.452276]  <IRQ>
> [  271.454286]  dump_stack_lvl+0x36/0x50
> [  271.457953]  warn_alloc+0x11b/0x190
> [  271.461445]  __alloc_pages_slowpath.constprop.119+0xcb9/0xd40
> [  271.467192]  __alloc_pages+0x32d/0x340
> [  271.470944]  skb_copy_ubufs+0x11b/0x630

I did not trigger this ... perhaps due to memory pressure from the leak?

performance wise, veth hits the skb_copy_ubufs when the packet crosses
the namespace, so ZC performance (with and without hugepages ) lags
non-ZC for the same host use case.
