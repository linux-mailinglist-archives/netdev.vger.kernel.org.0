Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9DA3AFD91
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhFVHJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:09:49 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:53894 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhFVHJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:09:48 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 3BF2A80004A;
        Tue, 22 Jun 2021 09:07:32 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 09:07:32 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 22 Jun
 2021 09:07:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 70F1531801E1; Tue, 22 Jun 2021 09:07:31 +0200 (CEST)
Date:   Tue, 22 Jun 2021 09:07:31 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <sd@queasysnail.net>
Subject: Re: [PATCH ipsec-next v2 0/5] xfrm: remove xfrm replay indirections
Message-ID: <20210622070731.GB40979@gauss3.secunet.de>
References: <20210618135200.14420-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210618135200.14420-1-fw@strlen.de>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 03:51:55PM +0200, Florian Westphal wrote:
> This is v2 of an older patchset that got stuck in backlog hell. Changes:
> 
>  - drop bogus "get rid of duplicated notification code" patch. As noted
>    by Sabrina it does change behavior.
>  - fix a compiler warning in patch 2.
> 
> ipsec.c selftest passes.
> 
> The xfrm replay logic is implemented via indirect calls.
> 
> xfrm_state struct holds a pointer to a
> 'struct xfrm_replay', which is one of several replay protection
> backends.
> 
> XFRM then invokes the backend via state->repl->callback().
> Due to retpoline all indirect calls have become a lot more
> expensive.  Fortunately, there are no 'replay modules', all are available
> for direct calls.
> 
> This series removes the 'struct xfrm_replay' and adds replay
> functions that can be called instead of the redirection.
> 
> Example:
>   -  err = x->repl->overflow(x, skb);
>   +  err = xfrm_replay_overflow(x, skb);
> 
> Instead of a pointer to a struct with function pointers, xfrm_state
> now holds an enum that tells the replay core what kind of replay
> test is to be done.
> 
> Florian Westphal (5):
>   xfrm: replay: avoid xfrm replay notify indirection
>   xfrm: replay: remove advance indirection
>   xfrm: replay: remove recheck indirection
>   xfrm: replay: avoid replay indirection
>   xfrm: replay: remove last replay indirection

All applied, thanks a lot Florian!
