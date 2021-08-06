Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0473E31FA
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245645AbhHFW56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhHFW55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 18:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 022E0610FD;
        Fri,  6 Aug 2021 22:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628290661;
        bh=P08v43kWxgysH8p5CKZRHTjxskrEu8Sz1idoUji2/ds=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HTGqFBGQapkQ1gT1VGkVkOTMwbCTNC/S40gPye/rw7H4US6zR4jXwtQxMiHTrw8zA
         lVL469HcxJbzNwdYFiIiZLVeBKRQhqpf/QOwasKd4mMGJ2yGRUJ+QHvauRcBic+8Mn
         qPW3RYAIizAjIV2+SPLGbjQqtX9ICOsas51xtYle+K3U/4jkK1850eg/5Ra7D2RX61
         akadC5pjwQsMHnVTDs67Ea0AA7171ZoQw1Ijk0eJZBczTDy6ZsSTGnFsEqcCoMGcIL
         TPJLPnSiXi5ObuFqnlpf19uujX6LmTflz4WQDVkRWGwu5QbaXVQb539TfqSFqym28A
         nBiykiQFqtI4Q==
Message-ID: <b5f1c558fef468fe8550ebb5e77d36bf1d0971a7.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: Avoid field-overflowing memcpy()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Date:   Fri, 06 Aug 2021 15:57:40 -0700
In-Reply-To: <202108061541.976BE67@keescook>
References: <20210806215003.2874554-1-keescook@chromium.org>
         <920853c06192a4f5cadf59c90b1510411b197a5e.camel@kernel.org>
         <202108061541.976BE67@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-08-06 at 15:45 -0700, Kees Cook wrote:
> On Fri, Aug 06, 2021 at 03:17:56PM -0700, Saeed Mahameed wrote:
> > On Fri, 2021-08-06 at 14:50 -0700, Kees Cook wrote:
> > > [...]
> > > So, split the memcpy() so the compiler can reason about the buffer
> > > sizes.
> > > 
> > > "pahole" shows no size nor member offset changes to struct > >
> > > mlx5e_tx_wqe
> > > nor struct mlx5e_umr_wqe. "objdump -d" shows no meaningful object
> > > code changes (i.e. only source line number induced differences and
> > > optimizations).
> > 
> > spiting the memcpy doesn't induce any performance degradation ? extra
> > instruction to copy the 1st 2 bytes ? 
> 
> Not meaningfully, but strictly speaking, yes, it's a different series
> of
> instructions.
> 
> > [...]
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > 
> > why only here ? mlx5 has at least 3 other places where we use this
> > unbound memcpy .. 
> 
> Can you point them out? I've been fixing only the ones I've been able
> to
> find through instrumentation (generally speaking, those with fixed
> sizes).
> 

we will need to examine each change carefully to look for performance
degradation and maybe run some micro-benchmark tests in house before i
can ack this patch. 

$ git grep -n "eseg->inline_hdr.start"
drivers/infiniband/hw/mlx5/wr.c:129:            copysz = min_t(u64,
*cur_edge - (void *)eseg->inline_hdr.start,
drivers/infiniband/hw/mlx5/wr.c:131:            memcpy(eseg-
>inline_hdr.start, pdata, copysz);
drivers/infiniband/hw/mlx5/wr.c:133:                          
sizeof(eseg->inline_hdr.start) + copysz, 16);
drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:344:          
memcpy(eseg->inline_hdr.start, xdptxd->data, MLX5E_XDP_MIN_INLINE);
drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:510:                  
mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:514:                  
memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:1033:          
memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);


