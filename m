Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0799823B01A
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgHCWPi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Aug 2020 18:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbgHCWPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:15:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D839DC06174A;
        Mon,  3 Aug 2020 15:15:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k2ik2-0006gh-0p; Tue, 04 Aug 2020 00:15:34 +0200
Date:   Tue, 4 Aug 2020 00:15:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: nft_exthdr: the presence return
 value should be little-endian
Message-ID: <20200803221534.GR29169@breakpoint.cc>
References: <20200803182001.9243-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200803182001.9243-1-ssuryaextr@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Suryaputra <ssuryaextr@gmail.com> wrote:
> On big-endian machine, the returned register data when the exthdr is
> present is not being compared correctly because little-endian is
> assumed. The function nft_cmp_fast_mask(), called by nft_cmp_fast_eval()
> and nft_cmp_fast_init(), calls cpu_to_le32().
> 
> The following dump also shows that little endian is assumed:
> 
> $ nft --debug=netlink add rule ip recordroute forward ip option rr exists counter
> ip
>   [ exthdr load ipv4 1b @ 7 + 0 present => reg 1 ]
>   [ cmp eq reg 1 0x01000000 ]
>   [ counter pkts 0 bytes 0 ]
> 
> Lastly, debug print in nft_cmp_fast_init() and nft_cmp_fast_eval() when
> RR option exists in the packet shows that the comparison fails because
> the assumption:
> 
> nft_cmp_fast_init:189 priv->sreg=4 desc.len=8 mask=0xff000000 data.data[0]=0x10003e0
> nft_cmp_fast_eval:57 regs->data[priv->sreg=4]=0x1 mask=0xff000000 priv->data=0x1000000

Right, nft userspace assumes a boolean data type when it does existence
check.

> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index 07782836fad6..50e4935585e3 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -44,7 +44,7 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
>  
>  	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
>  	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
> -		*dest = (err >= 0);
> +		*dest = cpu_to_le32(err >= 0);

Both should probably use nft_reg_store8(dst, err >= 0) for consistency
with the rest.

But the patch looks correct to me, thanks.
