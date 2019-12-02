Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C6B10ECE7
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 17:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfLBQQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 11:16:35 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39694 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727471AbfLBQQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 11:16:35 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iboNE-0007AM-H5; Mon, 02 Dec 2019 17:16:32 +0100
Date:   Mon, 2 Dec 2019 17:16:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Marco Oliverio <marco.oliverio@tanaza.com>
Cc:     netfilter-devel@vger.kernel.org,
        Rocco Folino <notifications@github.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>
Subject: Re: forwarded bridged packets enqueuing is broken
Message-ID: <20191202161632.GO795@breakpoint.cc>
References: <87pnh6lxch.fsf@tanaza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pnh6lxch.fsf@tanaza.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marco Oliverio <marco.oliverio@tanaza.com> wrote:
> We cannot enqueue userspace bridged forwarded packets (neither in the
> forward chain nor in the postrouting one):

[..]

> AFAIU forwarded bridge packets have a null dst entry in the first
> place, as they don't enter the ip stack, so skb_dst_force() returns
> false. The very same commit suggested to check skb_dst() before
> skb_dst_force(), doing that indeed fix the issue for us:
> 
> modified   net/netfilter/nf_queue.c
> @@ -174,7 +174,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
>  		goto err;
>  	}
>  
> -	if (!skb_dst_force(skb) && state->hook != NF_INET_PRE_ROUTING) {
> +	if (skb_dst(skb) && !skb_dst_force(skb)) {

Looks fine to me, please submit this formally.  Thanks!
