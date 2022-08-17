Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76005966DB
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 03:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbiHQBjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 21:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238042AbiHQBjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 21:39:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5335995AFE;
        Tue, 16 Aug 2022 18:39:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CAD8B81B8D;
        Wed, 17 Aug 2022 01:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E42C433D6;
        Wed, 17 Aug 2022 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660700372;
        bh=WNI4T2l1xlFYKRJlgSA2O9Bc98a5ZBHH6E/B6tCD50A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EEknQiKrl/fuhzX2gYjfHuS2LhzKcvaeq3V/YtQcZVtcI78dfH+0IsdjveRIYTLHh
         1grv26DVJhODDyf1ecCVDxMbjo1sSJ4DqiS37XphKS80Gl4NvqNQhdrIPoDTnt3Abz
         QmkJq5ksZu/qUhsA29utPhTN2t2Qz3uH2BuTQSYGUxF52YZT8KVZcInAT4lYyTZO+Y
         lDx+luMTE+zYuCCY/I1QGnAM3LhLa04WQaCJCog9XRcyZgpzcM340le5rc3eHddq+y
         mP8yQCYrjv4h0HShV9WvfJ8uR2lQaw0H292s6ns2Y3uuqlSs4UD0nXtewuds+18bpf
         VHHXp+xAm2gfQ==
Date:   Tue, 16 Aug 2022 18:39:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     David Howells <dhowells@redhat.com>,
        Hawkins Jiawei <yin31149@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        bpf@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [PATCH] net: Fix suspicious RCU usage in
 bpf_sk_reuseport_detach()
Message-ID: <20220816183930.2328d46d@kernel.org>
In-Reply-To: <20220817004319.fd7dekpqeumbvmsh@kafai-mbp>
References: <20220816103452.479281-1-yin31149@gmail.com>
        <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
        <804153.1660684606@warthog.procyon.org.uk>
        <20220816164435.0558ef94@kernel.org>
        <20220817004319.fd7dekpqeumbvmsh@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 17:43:19 -0700 Martin KaFai Lau wrote:
> > I like your version because it documents what the lock protecting this
> > field is.
> > 
> > In fact should we also add && sock_owned_by_user(). Martin, WDYT? Would
> > that work for reuseport? Jakub S is fixing l2tp to hold the socket lock
> > while setting this field, yet most places take the callback lock...  
>
> It needs to take a closer look at where the lock_sock() has already
> been acquired and also need to consider the lock ordering with reuseport_lock.
> It probably should work but may need a separate patch to discuss those
> considerations ?

Right, the users of the field with a bit allocated protect the writes
with the callback lock, so we can hard code the check against the
callback lock for now and revisit later if needed.
