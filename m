Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59FB3A8CE8
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhFOXyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:54:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:44021 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhFOXyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 19:54:32 -0400
IronPort-SDR: eSI/6LUD/1je9I9fySIm6y5qIpgUQK9FyZqhqaUjlhQcoyKp5Y7oOXC8PnHQ/P5QDTrAbVjp7e
 utFMakVdIi+A==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="193207080"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="193207080"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:52:27 -0700
IronPort-SDR: mmLZYrPa22/oF5BpWdy14ofruaz+xU4EYx9JBuiMJRQQW43bLfOuEGITJsDDJBGNO9pNRpvzFs
 uHBIYlqvRXfw==
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="478881678"
Received: from reschenk-mobl1.amr.corp.intel.com ([10.255.230.223])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:52:25 -0700
Date:   Tue, 15 Jun 2021 16:52:25 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
cc:     matthieu.baerts@tessares.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: Remove redundant assignment to remaining
In-Reply-To: <1623754538-85616-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Message-ID: <66162447-1f70-a6b9-f18a-179a54f8e97@linux.intel.com>
References: <1623754538-85616-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 15 Jun 2021, Jiapeng Chong wrote:

> Variable remaining is assigned, but this value is never read as it is
> not used later on, hence it is a redundant assignment and can be
> removed.
>
> Clean up the following clang-analyzer warning:
>
> net/mptcp/options.c:779:3: warning: Value stored to 'remaining' is never
> read [clang-analyzer-deadcode.DeadStores].
>
> net/mptcp/options.c:547:3: warning: Value stored to 'remaining' is never
> read [clang-analyzer-deadcode.DeadStores].
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> net/mptcp/options.c | 2 --
> 1 file changed, 2 deletions(-)
>
> diff --git a/net/mptcp/options.c b/net/mptcp/options.c
> index 9b263f2..f99272f 100644
> --- a/net/mptcp/options.c
> +++ b/net/mptcp/options.c
> @@ -544,7 +544,6 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
>
> 		map_size = TCPOLEN_MPTCP_DSS_BASE + TCPOLEN_MPTCP_DSS_MAP64;
>
> -		remaining -= map_size;

Hi Jiapeng, thank you for your MPTCP patch!

This change in mptcp_established_options_dss() removes the only reference 
to 'remaining' in that function, so the variable should also be removed 
from the function parameters. It also appears to be unused in 
mptcp_established_options_mp().

I'd like to handle this patch through the MPTCP tree so we can manage 
conflicts with other in-progress patches. This patch does apply to 
net-next cleanly but not our subsystem branch. You can find our git repo 
at https://github.com/multipath-tcp/mptcp_net-next, and develop patches 
using the 'export' branch. If you email a v2 patch to 
mptcp@lists.linux.dev (no need to cc other lists), Matthieu and I can make 
sure it is integrated in the MPTCP repository and handle sending it to 
netdev along with other patches from the MPTCP community.

> 		dss_size = map_size;
> 		if (mpext)
> 			opts->ext_copy = *mpext;
> @@ -776,7 +775,6 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
>
> 	if (mptcp_established_options_mp_prio(sk, &opt_size, remaining, opts)) {
> 		*size += opt_size;
> -		remaining -= opt_size;
> 		ret = true;
> 	}
>
> -- 
> 1.8.3.1

Best regards,

--
Mat Martineau
Intel
