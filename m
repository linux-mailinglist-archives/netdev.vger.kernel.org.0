Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1687020BB68
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgFZVZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:25:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:15002 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFZVZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 17:25:20 -0400
IronPort-SDR: bNt6SeVSrcK6LKhDXKHtSAOb8rEzj6l1o0vKcjiOmBxj7dpEGeVtq+PxsAAwP6B3WAtKJUw45I
 4uVcPR4TneHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="132901799"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="132901799"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 14:25:20 -0700
IronPort-SDR: FMEKmFuFLM+x6fFKRHgAPJqTIIaThtLYTje4JcoSzZeDuGPsrUUZt2CKfw479qSSieSIQ0NW/B
 50LifitBc1qg==
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="280271377"
Received: from redsall-mobl2.amr.corp.intel.com ([10.254.108.22])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 14:25:20 -0700
Date:   Fri, 26 Jun 2020 14:25:19 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@redsall-mobl2.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [MPTCP] [PATCH net-next v2 2/4] mptcp: refactor token
 container
In-Reply-To: <11ec0af6f8782f2551a7508d22b31db01ad11246.1593192442.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006261424430.66996@redsall-mobl2.amr.corp.intel.com>
References: <cover.1593192442.git.pabeni@redhat.com> <11ec0af6f8782f2551a7508d22b31db01ad11246.1593192442.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020, Paolo Abeni wrote:

> Replace the radix tree with a hash table allocated
> at boot time. The radix tree has some shortcoming:
> a single lock is contented by all the mptcp operation,
> the lookup currently use such lock, and traversing
> all the items would require a lock, too.
>
> With hash table instead we trade a little memory to
> address all the above - a per bucket lock is used.
>
> To hash the MPTCP sockets, we re-use the msk' sk_node
> entry: the MPTCP sockets are never hashed by the stack.
> Replace the existing hash proto callbacks with a dummy
> implementation, annotating the above constraint.
>
> Additionally refactor the token creation to code to:
>
> - limit the number of consecutive attempts to a fixed
> maximum. Hitting a hash bucket with a long chain is
> considered a failed attempt
>
> - accept() no longer can fail to token management.
>
> - if token creation fails at connect() time, we do
> fallback to TCP (before the connection was closed)
>
> v1 -> v2:
> - fix "no newline at end of file" - Jakub
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c |  45 ++++---
> net/mptcp/protocol.h |  14 ++-
> net/mptcp/subflow.c  |  19 ++-
> net/mptcp/token.c    | 271 ++++++++++++++++++++++++++++++-------------
> 4 files changed, 236 insertions(+), 113 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
