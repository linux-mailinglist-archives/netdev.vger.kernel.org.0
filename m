Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB04597A48
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 01:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242271AbiHQXmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 19:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239249AbiHQXmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 19:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D13495AE1;
        Wed, 17 Aug 2022 16:42:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77B866133B;
        Wed, 17 Aug 2022 23:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3A8C433D6;
        Wed, 17 Aug 2022 23:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660779730;
        bh=90a0gHd140Crru58gwz91c0iI4UzcfwU6EDuHdNf2Mc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bKqzDfLdSmpjAPt1fgcvYgH9DmrNEP84Fa4J4OmzTzbSQ3xi+N30wqlhxxB8F/DsU
         67waHblV+XrGuh4SPKBgvy+kHI3rK97tZ6AaFE0DBIzZgJAnIEbDELwggfu7+sx00N
         7MyWl+NacEKVkMCvr1syY0zMGfcsmLNHc8ETKXrFz+ZBeyLTzXF1bkWLpuqlhJNzKV
         lOSyh56WbqUEH0AG/Yq/gxjEz/erUXZGTr4zGs56oeWqcx1mZiw7Pp4U629N2aAYcX
         ReOxkkYj9J6SN9NJFsatUEf73nWVVDQMDhdmQxzkBKkdPclgQJ/E4dUHKSvVtZLf0t
         HDctf4J7QsLEA==
Date:   Wed, 17 Aug 2022 16:42:09 -0700
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
Message-ID: <20220817164209.72c182fb@kernel.org>
In-Reply-To: <3974013.1660769749@warthog.procyon.org.uk>
References: <20220816164435.0558ef94@kernel.org>
        <20220816103452.479281-1-yin31149@gmail.com>
        <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
        <804153.1660684606@warthog.procyon.org.uk>
        <3974013.1660769749@warthog.procyon.org.uk>
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

On Wed, 17 Aug 2022 21:55:49 +0100 David Howells wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > I like your version because it documents what the lock protecting this
> > field is. 
> > 
> > In fact should we also add && sock_owned_by_user(). Martin, WDYT? Would
> > that work for reuseport? Jakub S is fixing l2tp to hold the socket lock
> > while setting this field, yet most places take the callback lock...  
> 
> So how do you want to proceed?  My first version of the patch with
> sock_owned_by_user()?

Sorry about the lack of clarity. I was sort of expecting the name 
to still be shortened, but what you have is probably good enough.

Applying v1, then, thanks!
