Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8644E170D03
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgB0AKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:10:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:62208 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgB0AKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 19:10:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 16:10:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,490,1574150400"; 
   d="scan'208";a="238211482"
Received: from tvtrimel-mobl2.amr.corp.intel.com ([10.251.11.94])
  by orsmga003.jf.intel.com with ESMTP; 26 Feb 2020 16:10:43 -0800
Date:   Wed, 26 Feb 2020 16:10:43 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@tvtrimel-mobl2.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] mptcp: update mptcp ack sequence from work
 queue
In-Reply-To: <20200226091452.1116-4-fw@strlen.de>
Message-ID: <alpine.OSX.2.22.394.2002261610110.50710@tvtrimel-mobl2.amr.corp.intel.com>
References: <20200226091452.1116-1-fw@strlen.de> <20200226091452.1116-4-fw@strlen.de>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 26 Feb 2020, Florian Westphal wrote:

> If userspace is not reading data, all the mptcp-level acks contain the
> ack_seq from the last time userspace read data rather than the most
> recent in-sequence value.
>
> This causes pointless retransmissions for data that is already queued.
>
> The reason for this is that all the mptcp protocol level processing
> happens at mptcp_recv time.
>
> This adds work queue to move skbs from the subflow sockets receive
> queue on the mptcp socket receive queue (which was not used so far).
>
> This allows us to announce the correct mptcp ack sequence in a timely
> fashion, even when the application does not call recv() on the mptcp socket
> for some time.
>
> We still wake userspace tasks waiting for POLLIN immediately:
> If the mptcp level receive queue is empty (because the work queue is
> still pending) it can be filled from in-sequence subflow sockets at
> recv time without a need to wait for the worker.
>
> The skb_orphan when moving skbs from subflow to mptcp level is needed,
> because the destructor (sock_rfree) relies on skb->sk (ssk!) lock
> being taken.
>
> A followup patch will add needed rmem accouting for the moved skbs.
>
> Other problem: In case application behaves as expected, and calls
> recv() as soon as mptcp socket becomes readable, the work queue will
> only waste cpu cycles.  This will also be addressed in followup patches.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
