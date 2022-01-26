Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D62549CFCB
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243107AbiAZQfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:35:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236804AbiAZQfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:35:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643214922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PzVCrLtb3SF3ih9iv7SFaOHQb4UhdKjMEBOt5gzfX9s=;
        b=QqalJjQgiTKNgPNvVkc9BVvDDEoMyJXk3iPFUwd+vhQNicOnfetf7AenEl2kdW/2Y28qRe
        PhGuRTogvmRjie0njE8F+JU8tAsxjj2IjNkH+apcpLwmjeO3dbqek+TjSALuEnqgXt3so2
        jWnlfyUNJa9rbHCuH8eoLRFjvih+LLE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-LNZ9IUy9NjacP__HaJk_aQ-1; Wed, 26 Jan 2022 11:35:21 -0500
X-MC-Unique: LNZ9IUy9NjacP__HaJk_aQ-1
Received: by mail-qk1-f197.google.com with SMTP id z205-20020a3765d6000000b0047db3b020dfso7733816qkb.22
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:35:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=PzVCrLtb3SF3ih9iv7SFaOHQb4UhdKjMEBOt5gzfX9s=;
        b=ylRchrGBaQacr5hX7kEBKSIDu+CR3b4XmSNE14Pov1r7XiNiNc63KIUIFXvsr6e/Cq
         AFSSi05gkXNziE5CVqtkrUdvPMQAb+ELVUPYEHBLB8P22OOLVLPjvAQgTsf1XE5q+ZcT
         PRv+TSjdFMIfroomaNfBUu8FyxrWkrlBOMHr9KGtiqD/tL8hH3jnqpoD7qBwg/hAgI42
         j9sCVSEn1jF06gp2T/xZCFGw3y5rtQwn//7rQ7mDAql0ue4g72trwvGTFyyUBo01AfGw
         EXoAWvDhBnT9FK5BFarFpZhzMpcSuAIiVC1xClrTTQ1LuhDUKlHwbECXaBm55k60tD0F
         Gfxg==
X-Gm-Message-State: AOAM5311wP1JLrAbJyfKzCtK1s4GZr3Ypb1ssCOGy19SJh0wbYRxJjKg
        m7WKxKZGGJnfaFy9HcLR7xueckWnjePT+vZNzC1N/gGL8kGpopNLoHgpwlfEOCBXYbACY4o3aUy
        KOl1z0Qqs49P5GCdL
X-Received: by 2002:a05:620a:4589:: with SMTP id bp9mr19034141qkb.391.1643214910785;
        Wed, 26 Jan 2022 08:35:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzE7nhE8YiTHF3sC+6R/N3KVtWm40xzsjvudrolh/2dfOXM1vZOay6//T9Wca06uhLANgiIxQ==
X-Received: by 2002:a05:620a:4589:: with SMTP id bp9mr19034124qkb.391.1643214910559;
        Wed, 26 Jan 2022 08:35:10 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id bp37sm417539qkb.135.2022.01.26.08.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:35:09 -0800 (PST)
Message-ID: <3ecef3c4c1d158fc1c5812918e1710bce57c4812.camel@redhat.com>
Subject: Re: [PATCH net-next 6/6] ipv4/tcp: do not use per netns ctl sockets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Date:   Wed, 26 Jan 2022 17:35:06 +0100
In-Reply-To: <CANn89iLCdpgh9vWd_A70mPqkRgLTk9aqNY=zV2ibtVus9YLxeA@mail.gmail.com>
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
         <20220124202457.3450198-7-eric.dumazet@gmail.com>
         <6cccaaa7854c98248d663f60404ab6163250107f.camel@redhat.com>
         <CANn89iLCdpgh9vWd_A70mPqkRgLTk9aqNY=zV2ibtVus9YLxeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-01-26 at 08:24 -0800, Eric Dumazet wrote:
> I was working a fix. syzbot found the issue yesterday before I went to bed ;)

I know that is not a nice way to get some rest :(

> (And this is not related to MPTCP)
> 
> My plan is to make struct inet_timewait_death_row not a sub-strutcure
> of struct netns_ipv4
> 
> (the atomic_t tw_count becomes a refcount_t as a bonus)

Sounds good. We can test the patch, if that helps (e.g. if syzbot lacks
a repro or the repro is not very reliable)

Thanks!

Paolo

