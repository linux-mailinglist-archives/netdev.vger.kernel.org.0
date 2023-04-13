Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913316E103A
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjDMOoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDMOoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:44:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A071119B7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681396994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4AHxBsSprZmHnjqJ7yFpvkrSr9FZKh55hACs17k4xbc=;
        b=SegS49KBsRuA9GQ8D9KrJgytu8Z5NyqfVdNbNmJfDsg7uvU6nMgJRYh6znYDHuOW9dGcSz
        ZEI1k+f2OB5Bs2K6TmFVWBEvLK5WEdy3LNJKubvChwFM4vS7nF70ejuBhVPKTIGfOvIHLs
        hep4mWZho4sgrZ37fpfMfr+oJ/351no=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-dl0kZ-EqOSiAFK06-oG9jA-1; Thu, 13 Apr 2023 10:43:13 -0400
X-MC-Unique: dl0kZ-EqOSiAFK06-oG9jA-1
Received: by mail-ej1-f70.google.com with SMTP id f2-20020a170906084200b0094e971d803bso976115ejd.7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396992; x=1683988992;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4AHxBsSprZmHnjqJ7yFpvkrSr9FZKh55hACs17k4xbc=;
        b=FSZLWVbgAnU8hd9pMrqSOZZzSBtKfpag2N2I43hpZmlP/K18q1BzQBemaZlb1/25bW
         lTBXfPUi3tmB+oyU+EHMvrULhmnH4Zclo1iWS7Ohmwuotxps5uouSWgZ5CLYepO+DNFT
         5SJ3dJptuA0ep0TSFWuEYB31ihrxKOVLRoqe3UYcz/QnSvj9n6D7eDAYmIpIj+QvkDQ3
         0xX/djp/Eriy0eqlr6n8MPIHd+lx7t7qAiRFdXWuZxLEyIsNPLMIBHoL0//4xtlzP/Cz
         jMR123d7SgajrS9MdJGn0rH0fNu5j47Xfhi4+fNwk/9nqlwrWyCq9ZoHHosuSPepTy/H
         LfKQ==
X-Gm-Message-State: AAQBX9e/7qrQzxVhM78+tx835rGcQb+x2wuqCjZAJ4DigCezdiWxcKuc
        Uk1EzG/3TfHOi55f2YwOGa8nIcSbzTILRownG6AW6Ep9/fWLmMBeoOs40HpWoI7yAUesC1Rgdki
        STF346VyVE8Xncn9n
X-Received: by 2002:a17:906:2559:b0:94a:e89a:4fc9 with SMTP id j25-20020a170906255900b0094ae89a4fc9mr2839212ejb.73.1681396991586;
        Thu, 13 Apr 2023 07:43:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350YK2Rx/74f9cfSeHxFgTwYsET7Q9ppWRh9RgrRWvGYX6r8Sckh3iEVCMCl2u1De0h+WIngw9g==
X-Received: by 2002:a17:906:2559:b0:94a:e89a:4fc9 with SMTP id j25-20020a170906255900b0094ae89a4fc9mr2839170ejb.73.1681396990829;
        Thu, 13 Apr 2023 07:43:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d25-20020a05640208d900b004fa99a22c3bsm907510edz.61.2023.04.13.07.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:43:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C79B1AA7B30; Thu, 13 Apr 2023 16:43:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Yafang Shao <laoar.shao@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, martin.lau@linux.dev
Subject: Re: [PATCH net-next] bpf, net: Support redirecting to ifb with bpf
In-Reply-To: <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net>
References: <20230413025350.79809-1-laoar.shao@gmail.com>
 <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Apr 2023 16:43:09 +0200
Message-ID: <874jpj2682.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

>> 2). We can't redirect ingress packet to ifb with bpf
>> By trying to analyze if it is possible to redirect the ingress packet to
>> ifb with a bpf program, we find that the ifb device is not supported by
>> bpf redirect yet.
>
> You actually can: Just let BPF program return TC_ACT_UNSPEC for this
> case and then add a matchall with higher prio (so it runs after bpf)
> that contains an action with mirred egress redirect that pushes to ifb
> dev - there is no change needed.

I wasn't aware that BPF couldn't redirect directly to an IFB; any reason
why we shouldn't merge this patch in any case?

>> This patch tries to resolve it by supporting redirecting to ifb with bpf
>> program.
>> 
>> Ingress bandwidth limit is useful in some scenarios, for example, for the
>> TCP-based service, there may be lots of clients connecting it, so it is
>> not wise to limit the clients' egress. After limiting the server-side's
>> ingress, it will lower the send rate of the client by lowering the TCP
>> cwnd if the ingress bandwidth limit is reached. If we don't limit it,
>> the clients will continue sending requests at a high rate.
>
> Adding artificial queueing for the inbound traffic, aren't you worried
> about DoS'ing your node?

Just as an aside, the ingress filter -> ifb -> qdisc on the ifb
interface does work surprisingly well, and we've been using that over in
OpenWrt land for years[0]. It does have some overhead associated with it,
but I wouldn't expect it to be a source of self-DoS in itself (assuming
well-behaved TCP traffic).

-Toke

[0] https://openwrt.org/docs/guide-user/network/traffic-shaping/sqm

