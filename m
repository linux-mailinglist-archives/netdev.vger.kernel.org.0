Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5ED2C92F7
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388731AbgK3Xpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:45:35 -0500
Received: from mga18.intel.com ([134.134.136.126]:37290 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388050AbgK3Xpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 18:45:34 -0500
IronPort-SDR: aFFy+KIM7UdiIkGWI/DgiWtVAntVxY0s18YO1pLnKgCyu/9WRYD/EkvFN0h6GsVZp0v1qXdDI8
 +QgiQwxi8+jg==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="160501082"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="160501082"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:43:53 -0800
IronPort-SDR: LXh5cDrFQmCrAShdtswXRxKksRopr6Nun+4ogCr3wVmiNYfdMLFdA60sUyXjXCwinyplaUJwsi
 mfjciP2Ucz/Q==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="480855532"
Received: from cdhirema-mobl5.amr.corp.intel.com ([10.254.71.173])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:43:53 -0800
Date:   Mon, 30 Nov 2020 15:43:53 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 3/6] mptcp: protect the rx path with the msk
 socket spinlock
In-Reply-To: <fec6667a994d79f2511619dd034b85d425e1e2dc.1606413118.git.pabeni@redhat.com>
Message-ID: <cb8f8ad-2925-fb3-1f78-961b8adfaea@linux.intel.com>
References: <cover.1606413118.git.pabeni@redhat.com> <fec6667a994d79f2511619dd034b85d425e1e2dc.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020, Paolo Abeni wrote:

> Such spinlock is currently used only to protect the 'owned'
> flag inside the socket lock itself. With this patch, we extend
> its scope to protect the whole msk receive path and
> sk_forward_memory.
>
> Given the above, we can always move data into the msk receive
> queue (and OoO queue) from the subflow.
>
> We leverage the previous commit, so that we need to acquire the
> spinlock in the tx path only when moving fwd memory.
>
> recvmsg() must now explicitly acquire the socket spinlock
> when moving skbs out of sk_receive_queue. To reduce the number of
> lock operations required we use a second rx queue and splice the
> first into the latter in mptcp_lock_sock(). Additionally rmem
> allocated memory is bulk-freed via release_cb()
>
> Acked-by: Florian Westphal <fw@strlen.de>
> Co-developed-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 149 +++++++++++++++++++++++++++++--------------
> net/mptcp/protocol.h |   5 ++
> 2 files changed, 107 insertions(+), 47 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
