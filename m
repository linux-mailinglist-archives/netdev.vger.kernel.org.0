Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790571D58A7
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgEOSJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:09:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:28086 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgEOSJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 14:09:05 -0400
IronPort-SDR: PD922Gc5o1aft0nFmzTwvsBmK4902UVoCaDFn3bTcQQSQndyfJkmeCCa3iq4J6qwNuS0CoRaWy
 MpELpFih8Vog==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 11:09:05 -0700
IronPort-SDR: Rk5klrQtImSatTVnmFFFx1I42g7MYWgCDAGTkq7ujNeNUMFBArHmY6+iNM7MuSJcYtBQqK0pJa
 8ldGPmPyoWiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="252449180"
Received: from rasanche-mobl.amr.corp.intel.com ([10.255.228.159])
  by fmsmga007.fm.intel.com with ESMTP; 15 May 2020 11:09:04 -0700
Date:   Fri, 15 May 2020 11:09:04 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@rasanche-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 1/3] mptcp: add new sock flag to deal with
 join subflows
In-Reply-To: <a5acf97e4f39de13ba178a3a007eedd83b418702.1589558049.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2005151108130.36555@rasanche-mobl.amr.corp.intel.com>
References: <cover.1589558049.git.pabeni@redhat.com> <a5acf97e4f39de13ba178a3a007eedd83b418702.1589558049.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 15 May 2020, Paolo Abeni wrote:

> MP_JOIN subflows must not land into the accept queue.
> Currently tcp_check_req() calls an mptcp specific helper
> to detect such scenario.
>
> Such helper leverages the subflow context to check for
> MP_JOIN subflows. We need to deal also with MP JOIN
> failures, even when the subflow context is not available
> due allocation failure.
>
> A possible solution would be changing the syn_recv_sock()
> signature to allow returning a more descriptive action/
> error code and deal with that in tcp_check_req().
>
> Since the above need is MPTCP specific, this patch instead
> uses a TCP request socket hole to add a MPTCP specific flag.
> Such flag is used by the MPTCP syn_recv_sock() to tell
> tcp_check_req() how to deal with the request socket.
>
> This change is a no-op for !MPTCP build, and makes the
> MPTCP code simpler. It allows also the next patch to deal
> correctly with MP JOIN failure.
>
> v1 -> v2:
> - be more conservative on drop_req initialization (Mat)
>
> RFC -> v1:
> - move the drop_req bit inside tcp_request_sock (Eric)
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> include/linux/tcp.h      |  3 +++
> include/net/mptcp.h      | 17 ++++++++++-------
> net/ipv4/tcp_minisocks.c |  2 +-
> net/mptcp/protocol.c     |  7 -------
> net/mptcp/subflow.c      |  3 +++
> 5 files changed, 17 insertions(+), 15 deletions(-)
>

Thanks for the initialization fix, patch looks good.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
