Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028C041D30F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348229AbhI3GKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:10:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:39430 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348185AbhI3GKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:10:39 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mVpFW-000Ca3-Nk; Thu, 30 Sep 2021 08:08:54 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mVpFW-000TrI-EH; Thu, 30 Sep 2021 08:08:54 +0200
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        lukas@wunner.de, kadlec@netfilter.org, fw@strlen.de,
        ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
References: <20210928095538.114207-1-pablo@netfilter.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
Date:   Thu, 30 Sep 2021 08:08:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210928095538.114207-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26307/Wed Sep 29 11:09:54 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 11:55 AM, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset v5 that re-adds the Netfilter egress:
> 
> 1) Rename linux/netfilter_ingress.h to linux/netfilter_netdev.h
>     from Lukas Wunner.
> 
> 2) Generalize ingress hook file to accomodate egress support,
>     from Lukas Wunner.
> 
> 3) Modularize Netfilter ingress hook into nf_tables_netdev: Daniel
>     Borkmann is requesting for a mechanism to allow to blacklist
>     Netfilter, this allows users to blacklist this new module that
>     includes ingress chain and the new egress chain for the netdev
>     family. There is no other in-tree user of the ingress and egress
>     hooks than this which might interfer with his matter.
> 
> 4) Place the egress hook again before the tc egress hook as requested
>     by Daniel Borkmann. Patch to add egress hook from Lukas Wunner.
>     The Netfilter egress hook remains behind the static key, if unused
>     performance degradation is negligible.
> 
> 5) Add netfilter egress handling to af_packet.
> 
> Arguably, distributors might decide to compile nf_tables_netdev
> built-in. Traditionally, distributors have compiled their kernels using
> the default configuration that Netfilter Kconfig provides (ie. use
> modules whenever possible). In any case, I consider that distributor
> policy is out of scope in this discussion, providing a mechanism to
> allow Daniel to prevent Netfilter ingress and egress chains to be loaded
> should be sufficient IMHO.

Hm, so in the case of SRv6 users were running into a similar issue and commit
7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane") [0] added
a new hook along with a sysctl which defaults the new hook to off.

The rationale for it was given as "the hooks are enabled via nf_hooks_lwtunnel
sysctl to make sure existing netfilter rulesets do not break." [0,1]

If the suggestion to flag the skb [2] one way or another from the tc forwarding
path (e.g. skb bit or per-cpu marker) is not technically feasible, then why not
do a sysctl toggle like in the SRv6 case?

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7a3f5b0de3647c854e34269c3332d7a1e902901a
   [1] https://lore.kernel.org/netdev/20210830093852.21654-1-pablo@netfilter.org/
   [2] https://lore.kernel.org/netdev/11584665-e3b5-3afe-d72c-ef92ad0b9313@iogearbox.net/
