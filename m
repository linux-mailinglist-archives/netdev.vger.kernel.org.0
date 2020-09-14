Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C392269460
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgINSHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:07:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:5374 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgINSGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:06:55 -0400
IronPort-SDR: Q/n3QDtPKhn/ysE9amL8ehv43vIiO04Qs8a9BXWW5Sryer48rRNJ3uIBPR7lPXk9a0oFtzWfYn
 3fQ5NhJCb3hA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="156527886"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="156527886"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:06:51 -0700
IronPort-SDR: m3gUXRquUmi1/9PSin6hKHdgTwhI4S/NhK08eIIkilfg/4uKI6282XueFs3WPc8ORl0ms7hKCB
 H9Uy6Y5enVeQ==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="330843223"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:06:51 -0700
Date:   Mon, 14 Sep 2020 11:06:50 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 06/13] mptcp: move ooo skbs into msk out of
 order queue.
In-Reply-To: <26988dc9d753a61cd344d71d4bf16b50920913c7.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141106240.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <26988dc9d753a61cd344d71d4bf16b50920913c7.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> Add an RB-tree to cope with OoO (at MPTCP level) data.
> __mptcp_move_skb() insert into the RB tree "future"
> data, eventually coalescing skb as allowed by the
> MPTCP DSN.
>
> To simplify sequence accounting, move the DSN inside
> the cb.
>
> After successfully enqueuing in sequence data, check
> if we can use any data from the RB tree.
>
> Additionally move the data_fin check after spooling
> data from the OoO tree, otherwise we could miss shutdown
> events.
>
> The RB tree code is copied as verbatim as possible
> from tcp_data_queue_ofo(), with a few simplifications
> due to the fact that MPTCP doesn't need to cope with
> sacks. All bugs here are added by me.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 264 ++++++++++++++++++++++++++++++++++---------
> net/mptcp/protocol.h |   2 +
> net/mptcp/subflow.c  |   1 +
> 3 files changed, 211 insertions(+), 56 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
