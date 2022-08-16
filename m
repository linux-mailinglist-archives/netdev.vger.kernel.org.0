Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A4C59661F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 01:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237444AbiHPXoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 19:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiHPXoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 19:44:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C578915C2;
        Tue, 16 Aug 2022 16:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EA616134B;
        Tue, 16 Aug 2022 23:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4F7C433C1;
        Tue, 16 Aug 2022 23:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660693476;
        bh=OAzkgD5LmFOw0cU+/xIlB9h5Vph5ExEgMh4qFj5H50A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uDEO8H5QZeU9XvjDP5n5ihdX6f32eqoyRUxcYOZ+bvYDd1xTbA2RNWjQB4igljzDh
         y6IpaJ62pAdBsyCSQvq/RUtbV3aYd422+8gP+ek/eY02kLD5grw6qqazi9T02C1uuP
         LJ8JdErwQK8O9NDuaB/SaX+Q2Cvp8TyKk6S0AY5OGhvuWr5RNTs/tFOPpNR0M+sbUC
         pFQmNwlP6KVQmXTdZ0rAOCW/iC7aydW6xumFXJN6vWXAbcKM8oiK/ZEw4V+/Mhil/z
         AyyuJbTmuNuoUrYr92W8nZ+kZY/ZuGtjoO+1FshsEgJ2Q+wmOEMV/6ICtNI8+7NnyN
         GgJ52V4PQ2xsw==
Date:   Tue, 16 Aug 2022 16:44:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        bpf@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [PATCH] net: Fix suspicious RCU usage in
 bpf_sk_reuseport_detach()
Message-ID: <20220816164435.0558ef94@kernel.org>
In-Reply-To: <804153.1660684606@warthog.procyon.org.uk>
References: <20220816103452.479281-1-yin31149@gmail.com>
        <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
        <804153.1660684606@warthog.procyon.org.uk>
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

On Tue, 16 Aug 2022 22:16:46 +0100 David Howells wrote:
> So either __rcu_dereference_sk_user_data_with_flags_check() has to be a macro,
> or we need to go with something like the first version of my patch where I
> don't pass the condition through.  Do you have a preference?

I like your version because it documents what the lock protecting this
field is. 

In fact should we also add && sock_owned_by_user(). Martin, WDYT? Would
that work for reuseport? Jakub S is fixing l2tp to hold the socket lock
while setting this field, yet most places take the callback lock...

One the naming - maybe just drop the _with_flags() ? There's no version
of locked helper which does not take the flags. And not underscores?
