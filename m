Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563552C92FB
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgK3Xql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:46:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:46019 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgK3Xql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 18:46:41 -0500
IronPort-SDR: BUlcFs3f82gj6rFcf2AkiJLIYFFvb26fkoO0aIN5FUu3E7eg+yuhtm8rsYE1AGnV4400I+gwYS
 AbrpXrunQoTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="234336250"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="234336250"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:45:18 -0800
IronPort-SDR: bNHkaEM+NJ6OP8PU92hE9GKRGnTg9ZbjcAYYLfDFy8LqPuPG7+ChLbRWVHkhSvPn8k405DATsQ
 S+hVu4YGQ5iA==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="480856181"
Received: from cdhirema-mobl5.amr.corp.intel.com ([10.254.71.173])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:45:18 -0800
Date:   Mon, 30 Nov 2020 15:45:18 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 6/6] mptcp: use mptcp release_cb for delayed
 tasks
In-Reply-To: <b62cc1e06a7924ac60e9c320e6535e2ec9900065.1606413118.git.pabeni@redhat.com>
Message-ID: <98a5b8cf-4c8a-bd28-111-9261d743a3bd@linux.intel.com>
References: <cover.1606413118.git.pabeni@redhat.com> <b62cc1e06a7924ac60e9c320e6535e2ec9900065.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020, Paolo Abeni wrote:

> We have some tasks triggered by the subflow receive path
> which require to access the msk socket status, specifically:
> mptcp_clean_una() and mptcp_push_pending()
>
> We have almost everything in place to defer to the msk
> release_cb such tasks when the msk sock is owned.
>
> Since the worker is no more used to clean the acked data,
> for fallback sockets we need to explicitly flush them.
>
> As an added bonus we can move the wake-up code in __mptcp_clean_una(),
> simplify a lot mptcp_poll() and move the timer update under
> the data lock.
>
> The worker is now used only to process and send DATA_FIN
> packets and do the mptcp-level retransmissions.
>
> Acked-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/options.c  |  18 +++-
> net/mptcp/protocol.c | 250 ++++++++++++++++++++++++++-----------------
> net/mptcp/protocol.h |   3 +
> net/mptcp/subflow.c  |  14 +--
> 4 files changed, 168 insertions(+), 117 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
