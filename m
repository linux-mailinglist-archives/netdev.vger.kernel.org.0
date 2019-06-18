Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815004A2D5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbfFRNxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:53:01 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52690 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbfFRNxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:53:01 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hdEXj-0000bj-0H; Tue, 18 Jun 2019 15:52:59 +0200
Date:   Tue, 18 Jun 2019 15:52:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
Message-ID: <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
References: <20190618130050.8344-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618130050.8344-1-jakub@cloudflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki <jakub@cloudflare.com> wrote:
>  - XDP programs using bpf_sk_lookup helpers, like load balancers, can't
>    find the listening socket to check for SYN cookies with TPROXY redirect.

Sorry for the question, but where is the problem?
(i.e., is it with TPROXY or bpf side)?

>  - TPROXY takes a reference to the listening socket on dispatch, which
>    raises lock contention concerns.

FWIW this could be avoided in similar way as to how we handle noref dsts.

The only reason we need to take the reference at the moment is because
once skb leaves the TPROXY target hook, the skb could leave rcu
protection as well at some point (nfqueue for example).

Maybe its even enough to move reference taking to nfqueue and add
'noref' destructor, that would allow skb_steal_sock to propagate
refcounted value in __inet_lookup_skb.

So, at least for this part I don't see a technical reason why this
has to grab a reference for listener socket.

>  - Traffic steering configuration is split over several iptables rules, at
>    least one per service, which makes configuration changes error prone.

Could you perhaps sketch an example ruleset (doesn't have to be complete
nor parse-able by itpables-restore), I would just like to understand if
there is any room for improvement on netfilter/iptables/nft side.

Thanks,
Florian
