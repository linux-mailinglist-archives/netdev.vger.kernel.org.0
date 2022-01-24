Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219ED497957
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 08:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241757AbiAXHVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 02:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbiAXHVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 02:21:34 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB70AC06173B;
        Sun, 23 Jan 2022 23:21:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nBtf5-0004hl-3j; Mon, 24 Jan 2022 08:21:11 +0100
Date:   Mon, 24 Jan 2022 08:21:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     kai zhang <zhangkaiheb@126.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix duplicate logs of iptables TRACE target
Message-ID: <20220124072111.GB14018@breakpoint.cc>
References: <20220124053455.55858-1-zhangkaiheb@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124053455.55858-1-zhangkaiheb@126.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kai zhang <zhangkaiheb@126.com> wrote:
> Below configuration, mangle,filter and security tables have no rule:
> 
> There are 5 logs for incoming ssh packet:
> 
> kernel: [ 7018.727278] TRACE: raw:PREROUTING:policy:2 IN=enp9s0 ...
> kernel: [ 7018.727304] TRACE: mangle:PREROUTING:policy:1 IN=enp9s0 ...
> kernel: [ 7018.727327] TRACE: mangle:INPUT:policy:1 IN=enp9s0 ...
> kernel: [ 7018.727343] TRACE: filter:INPUT:policy:1 IN=enp9s0 ...
> kernel: [ 7018.727359] TRACE: security:INPUT:policy:1 IN=enp9s0 ...

Thats correct and exactly whats supposed to happen.

>  #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
>  		/* The packet is traced: log it */
> -		if (unlikely(skb->nf_trace))
> +		if (unlikely(skb->nf_trace)) {
>  			trace_packet(state->net, skb, hook, state->in,
>  				     state->out, table->name, private, e);
> +			nf_reset_trace(skb);
> +		}

This breaks the long established behavior of TRACE,
we don't want users to have to TRACE tables individually which may also
be hard when nat is involved.
