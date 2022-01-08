Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044104880F8
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 03:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiAHCol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 21:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiAHCoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 21:44:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0881C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 18:44:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 518E961FF0
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 02:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B03AC36AE5;
        Sat,  8 Jan 2022 02:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641609877;
        bh=MFtK35e2nCWrmM4Pu0ugzMOvXzjSkJ2t+OkUpQ1ez1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VFscG0hpXHLQbfEtZp1vzgvfk8KEzowatvY1bP0waMTXT37B98f3Tx370mtMqhe+G
         OehLjwjHZwkpFG+xOP3VBos6OpYpENd59cLmZBY6BrRMsM+VH1cWt+GHPQjZT1jhN3
         Mzj2+op1L9A/agmJ901XbIFCNkD2MFTkn45mP0VwW00E2TUwG9dmDNZ3b7imoiTkwf
         isXC5YYEGc2ihcVld0dVMtLpHRsKc4hyY04rhlqWfgEeXKtBzxJTFuIca0PSuN0xTq
         VEAQSt0heBcyyxoKgUf+zKtZs7qVKFT+wWkOvujfk920OwaiwXOcLbDDRHqRtWcB2I
         pwGQRYQxW9lqg==
Date:   Fri, 7 Jan 2022 18:44:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [RFC PATCH] net/tls: Fix skb memory leak when running kTLS
 traffic
Message-ID: <20220107184436.758e15c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJqgJjpFEaYPLuVAAzwwC_y3O6se2pChj40=zTAyWN=6w@mail.gmail.com>
References: <20220102081253.9123-1-gal@nvidia.com>
        <20220107105106.680cd28f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJqgJjpFEaYPLuVAAzwwC_y3O6se2pChj40=zTAyWN=6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 11:12:28 -0800 Eric Dumazet wrote:
> On Fri, Jan 7, 2022 at 10:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sun, 2 Jan 2022 10:12:53 +0200 Gal Pressman wrote:  
> > > The cited Fixes commit introduced a memory leak when running kTLS
> > > traffic (with/without hardware offloads).
> > > I'm running nginx on the server side and wrk on the client side and get
> > > the following:
> > >
> > >   unreferenced object 0xffff8881935e9b80 (size 224):
> > >   comm "softirq", pid 0, jiffies 4294903611 (age 43.204s)
> > >   hex dump (first 32 bytes):
> > >     80 9b d0 36 81 88 ff ff 00 00 00 00 00 00 00 00  ...6............
> > >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >   backtrace:
> > >     [<00000000efe2a999>] build_skb+0x1f/0x170
> > >     [<00000000ef521785>] mlx5e_skb_from_cqe_mpwrq_linear+0x2bc/0x610 [mlx5_core]
> > >     [<00000000945d0ffe>] mlx5e_handle_rx_cqe_mpwrq+0x264/0x9e0 [mlx5_core]
> > >     [<00000000cb675b06>] mlx5e_poll_rx_cq+0x3ad/0x17a0 [mlx5_core]
> > >     [<0000000018aac6a9>] mlx5e_napi_poll+0x28c/0x1b60 [mlx5_core]
> > >     [<000000001f3369d1>] __napi_poll+0x9f/0x560
> > >     [<00000000cfa11f72>] net_rx_action+0x357/0xa60
> > >     [<000000008653b8d7>] __do_softirq+0x282/0x94e
> > >     [<00000000644923c6>] __irq_exit_rcu+0x11f/0x170
> > >     [<00000000d4085f8f>] irq_exit_rcu+0xa/0x20
> > >     [<00000000d412fef4>] common_interrupt+0x7d/0xa0
> > >     [<00000000bfb0cebc>] asm_common_interrupt+0x1e/0x40
> > >     [<00000000d80d0890>] default_idle+0x53/0x70
> > >     [<00000000f2b9780e>] default_idle_call+0x8c/0xd0
> > >     [<00000000c7659e15>] do_idle+0x394/0x450
> > >
> > > I'm not familiar with these areas of the code, but I've added this
> > > sk_defer_free_flush() to tls_sw_recvmsg() based on a hunch and it
> > > resolved the issue.
> > >
> > > Eric, do you think this is the correct fix? Maybe we're missing a call
> > > to sk_defer_free_flush() in other places as well?  
> >
> > Any thoughts, Eric? Since the merge window is coming soon should
> > we purge the defer free queue when socket is destroyed at least?
> > All the .read_sock callers will otherwise risk the leaks, it seems.  
> 
> It seems I missed this patch.
> 
> We might merge it, and eventually add another
> 
> WARN_ON_ONCE(!llist_empty(sk->defer_list))
> sk_defer_free_flush(sk);
> 
> at socket destroy as you suggested ?
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks, applied!

Gal please follow up as suggested, for TLS similar treatment to what
you have done here will be necessary in the splice_read handler.
