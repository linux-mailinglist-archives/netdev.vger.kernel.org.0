Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93B51E8506
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgE2Rfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:35:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:36661 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgE2Rfq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:35:46 -0400
IronPort-SDR: F7GioEF/Bo4iakGSC2wjyXRJnVDkU0UJm8YBIgI30E7WOkCsUa2L/s9dtkupf276kRxqxa5KSl
 ItPgMH5zfqTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:35:45 -0700
IronPort-SDR: mBiB+rSmAg1mA3qEDL49B/ieYjbj0N7Vv6ZrrzMSyW1nvtsjFNfHBkcCNyIR2TOL4Wg507YRxV
 hiy1CI2lcryA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="469580983"
Received: from aparnash-mobl.amr.corp.intel.com ([10.254.67.112])
  by fmsmga005.fm.intel.com with ESMTP; 29 May 2020 10:35:45 -0700
Date:   Fri, 29 May 2020 10:35:45 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@aparnash-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 2/3] mptcp: fix race between MP_JOIN and close
In-Reply-To: <bfd9f8f6fc4d6eb84012d8e04c48d974ed7080ea.1590766645.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2005291035160.3506@aparnash-mobl.amr.corp.intel.com>
References: <cover.1590766645.git.pabeni@redhat.com> <bfd9f8f6fc4d6eb84012d8e04c48d974ed7080ea.1590766645.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020, Paolo Abeni wrote:

> If a MP_JOIN subflow completes the 3whs while another
> CPU is closing the master msk, we can hit the
> following race:
>
> CPU1                                    CPU2
>
> close()
> mptcp_close
>                                        subflow_syn_recv_sock
>                                         mptcp_token_get_sock
>                                         mptcp_finish_join
>                                          inet_sk_state_load
>  mptcp_token_destroy
>  inet_sk_state_store(TCP_CLOSE)
>  __mptcp_flush_join_list()
>                                          mptcp_sock_graft
>                                          list_add_tail
>  sk_common_release
>   sock_orphan()
> <socket free>
>
> The MP_JOIN socket will be leaked. Additionally we can hit
> UaF for the msk 'struct socket' referenced via the 'conn'
> field.
>
> This change try to address the issue introducing some
> synchronization between the MP_JOIN 3whs and mptcp_close
> via the join_list spinlock. If we detect the msk is closing
> the MP_JOIN socket is closed, too.
>
> Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 42 +++++++++++++++++++++++++++---------------
> 1 file changed, 27 insertions(+), 15 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
