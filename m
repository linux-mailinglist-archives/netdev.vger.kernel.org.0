Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC1D5034A5
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 09:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiDPHgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 03:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiDPHgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 03:36:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD55B3DD4;
        Sat, 16 Apr 2022 00:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF569B8125F;
        Sat, 16 Apr 2022 07:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1743C385A3;
        Sat, 16 Apr 2022 07:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650094409;
        bh=jIbE4W95Z91IGJhTUxo9IvdkEdg4KANutS7Vlis0L+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pDlHmmsg7ZttAvWqKPwWSiYS0sTQfbtAKlztE+vjMebQPTwlMDY7jfUNVUMD9s+lA
         snC4h3fqXVYVmrfzFbmXE3eOA4hnRIlgi7mAl5IgKd/DVrIuBb7ozDTUYbH6kGknI+
         5KGUUGJWZ0u9bVR1Vj9AeyEK6t76UMmJuY2gXEcu8X5CbLeT2pyst6qsguD/yFhkSR
         f7Z+g8Pu9BUyXBF60CnwwBHS99ImN66aU2VpjKQ/sx0a7TF9Vi4ZmZidABUzZgEcSW
         7c3TbtQe0LUIW6PkCXhav5FtwHnverlQu9y+4PoV0aY7/X3CKDF3v+q7yp6o2MkhNg
         UOF51hPmy7WNQ==
Date:   Sat, 16 Apr 2022 09:33:20 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] ip6_gre: Fix skb_under_panic in __gre6_xmit()
Message-ID: <20220416093320.13f4ba1d@kernel.org>
In-Reply-To: <20220416065633.GA10882@bytedance>
References: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com>
        <9cd9ca4ac2c19be288cb8734a86eb30e4d9e2050.1649715555.git.peilin.ye@bytedance.com>
        <20220414131424.744aa842@kernel.org>
        <20220414200854.GA2729@bytedance>
        <20220415191133.0597a79a@kernel.org>
        <20220416065633.GA10882@bytedance>
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

On Fri, 15 Apr 2022 23:56:33 -0700 Peilin Ye wrote:
> On Fri, Apr 15, 2022 at 07:11:33PM +0200, Jakub Kicinski wrote:
> > > Could you explain this a bit more?  It seems that commit 77a5196a804e
> > > ("gre: add sequence number for collect md mode.") added this
> > > intentionally.  
> > 
> > Interesting. Maybe a better way of dealing with the problem would be
> > rejecting SEQ if it's not set on the device itself.  
> 
> According to ip-link(8), the 'external' option is mutually exclusive
> with the '[o]seq' option.  In other words, a collect_md mode IP6GRETAP
> device should always have the TUNNEL_SEQ flag off in its
> 'tunnel->parms.o_flags'.
> 
> (However, I just tried:
> 
>   $ ip link add dev ip6gretap11 type ip6gretap oseq external
> 					       ^^^^ ^^^^^^^^
>  ...and my 'ip' executed it with no error.  I will take a closer look at
>  iproute2 later; maybe it's undefined behavior...)
> 
> How about:
> 
> 1. If 'external', then 'oseq' means "always turn off NETIF_F_LLTX, so
> it's okay to set TUNNEL_SEQ in e.g. eBPF";
> 
> 2. Otherwise, if 'external' but NOT 'oseq', then whenever we see a
> TUNNEL_SEQ in skb's tunnel info, we do something like WARN_ONCE() then
> return -EINVAL.

Maybe pr_warn_once(), no need for a stacktrace.

> > When the device is set up without the SEQ bit enabled it disables Tx
> > locking (look for LLTX). This means that multiple CPUs can try to do
> > the tunnel->o_seqno++ in parallel. Not catastrophic but racy for sure.  
> 
> Thanks for the explanation!  At first glance, I was wondering why don't
> we make 'o_seqno' atomic until I found commit b790e01aee74 ("ip_gre:
> lockless xmit").  I quote:
> 
> """
> Even using an atomic_t o_seq, we would increase chance for packets being
> out of order at receiver.
> """
> 
> I don't fully understand this out-of-order yet, but it seems that making
> 'o_seqno' atomic is not an option?

atomic_t would also work (if it has enough bits). Whatever is simplest
TBH. It's just about correctness, I don't think seq is widely used.

Thanks!
