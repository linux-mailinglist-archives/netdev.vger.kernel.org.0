Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C1626E744
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIQVUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:20:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:33449 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgIQVUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 17:20:44 -0400
IronPort-SDR: wRrFjzXo2OkVZX1RBgI3L2hPuCaC/anhcjyzsfV9Lo3fEBaoDpzdK090fuNQbo5Z2/56g4AEav
 cnjcyMkvDsag==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="160723263"
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="160723263"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 14:19:27 -0700
IronPort-SDR: Hriccl3i1c7PAJSohBCSu7F+vimqBHKplqQpVpqClYBv3dp3spvi7kXuImTz7zs34dqBpy1JX/
 2Umtjg1eZCiQ==
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="289117720"
Received: from shantika-mobl1.amr.corp.intel.com ([10.255.229.204])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 14:19:27 -0700
Date:   Thu, 17 Sep 2020 14:19:26 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@shantika-mobl1.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net-next] mptcp: fix integer overflow in
 mptcp_subflow_discard_data()
In-Reply-To: <1a927c595adf46cf5ff186ca6b129f12fb70f492.1600375771.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009171413360.4728@shantika-mobl1.amr.corp.intel.com>
References: <1a927c595adf46cf5ff186ca6b129f12fb70f492.1600375771.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 17 Sep 2020, Paolo Abeni wrote:

> Christoph reported an infinite loop in the subflow receive path
> under stress condition.
>
> If there are multiple subflows, each of them using a large send
> buffer, the delta between the sequence number used by
> MPTCP-level retransmission can and the current msk->ack_seq
> can be greater than MAX_INT.
>
> In the above scenario, when calling mptcp_subflow_discard_data(),
> such delta will be truncated to int, and could result in a negative
> number: no bytes will be dropped, and subflow_check_data_avail()
> will try again to process the same packet, looping forever.
>
> This change addresses the issue by expanding the 'limit' size to 64
> bits, so that overflows are not possible anymore.
>
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/87
> Fixes: 6719331c2f73 ("mptcp: trigger msk processing even for OoO data")
> Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net-next patch, as the culprit commit is only on net-next currently
> ---
> net/mptcp/subflow.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks Paolo!

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>


--
Mat Martineau
Intel
