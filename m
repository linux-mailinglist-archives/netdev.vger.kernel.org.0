Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D56C234DA0
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgGaWjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:39:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:51105 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgGaWjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 18:39:14 -0400
IronPort-SDR: WLe2MutfC9tFL6PnLwgOIF0yEKyLAXpW2teQxVJia22h5jsV7m+dgv4ny9BDNYJc2MQzmSEDcL
 uVZpfq5V5sWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="216318495"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="216318495"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:39:13 -0700
IronPort-SDR: AfnClz+Vz0HUjunOHYJPpekIbKvzc4R32nBmzNH4ybBryWeGSIj1Pdd5idTJY+ntpgyMX3fs1w
 pJce9kue1xNQ==
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="287331246"
Received: from nataliet-mobl.amr.corp.intel.com ([10.254.79.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:39:13 -0700
Date:   Fri, 31 Jul 2020 15:39:13 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@nataliet-mobl.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, edumazet@google.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 7/9] mptcp: enable JOIN requests even if
 cookies are in use
In-Reply-To: <20200730192558.25697-8-fw@strlen.de>
Message-ID: <alpine.OSX.2.23.453.2007311538520.30834@nataliet-mobl.amr.corp.intel.com>
References: <20200730192558.25697-1-fw@strlen.de> <20200730192558.25697-8-fw@strlen.de>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020, Florian Westphal wrote:

> JOIN requests do not work in syncookie mode -- for HMAC validation, the
> peers nonce and the mptcp token (to obtain the desired connection socket
> the join is for) are required, but this information is only present in the
> initial syn.
>
> So either we need to drop all JOIN requests once a listening socket enters
> syncookie mode, or we need to store enough state to reconstruct the request
> socket later.
>
> This adds a state table (1024 entries) to store the data present in the
> MP_JOIN syn request and the random nonce used for the cookie syn/ack.
>
> When a MP_JOIN ACK passed cookie validation, the table is consulted
> to rebuild the request socket from it.
>
> An alternate approach would be to "cancel" syn-cookie mode and force
> MP_JOIN to always use a syn queue entry.
>
> However, doing so brings the backlog over the configured queue limit.
>
> v2: use req->syncookie, not (removed) want_cookie arg
>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> net/ipv4/syncookies.c  |   6 ++
> net/mptcp/Makefile     |   1 +
> net/mptcp/ctrl.c       |   1 +
> net/mptcp/protocol.h   |  20 +++++++
> net/mptcp/subflow.c    |  14 +++++
> net/mptcp/syncookies.c | 132 +++++++++++++++++++++++++++++++++++++++++
> 6 files changed, 174 insertions(+)
> create mode 100644 net/mptcp/syncookies.c

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
