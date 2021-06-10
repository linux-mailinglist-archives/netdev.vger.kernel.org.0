Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF103A212B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFJAJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:09:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:44249 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhFJAJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:09:47 -0400
IronPort-SDR: S6GrR9aF+vLfF9a+QaT4b2eU/n8HEXIbp8piiwk9rHfkrcn75iSZqP3BEWG5Vey+0osjqWIdnw
 8AVPL8hJKo8A==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="203345821"
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="203345821"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 17:07:51 -0700
IronPort-SDR: N8e0OSUPsbGLqpPqVp1VmrkM7Myp6ilHT1DOM3nmLSyF+o8NsYWH0v0Czm/HRdbgtBYzuS2K5Y
 Bf8t10832G2w==
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="448491309"
Received: from kcsherwo-mobl1.amr.corp.intel.com ([10.212.135.57])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 17:07:33 -0700
Date:   Wed, 9 Jun 2021 17:07:14 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Patrick McHardy <kaber@trash.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Young Xiao <92siuyang@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/3] mptcp: Fix out of bounds when parsing TCP
 options
In-Reply-To: <20210609142212.3096691-3-maximmi@nvidia.com>
Message-ID: <c7caefb9-1aed-5bc9-b429-925412994249@linux.intel.com>
References: <20210609142212.3096691-1-maximmi@nvidia.com> <20210609142212.3096691-3-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Jun 2021, Maxim Mikityanskiy wrote:

> The TCP option parser in mptcp (mptcp_get_options) could read one byte
> out of bounds. When the length is 1, the execution flow gets into the
> loop, reads one byte of the opcode, and if the opcode is neither
> TCPOPT_EOL nor TCPOPT_NOP, it reads one more byte, which exceeds the
> length of 1.
>
> This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
> out of bounds when parsing TCP options.").
>
> Cc: Young Xiao <92siuyang@gmail.com>
> Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> ---
> net/mptcp/options.c | 2 ++
> 1 file changed, 2 insertions(+)
>
> diff --git a/net/mptcp/options.c b/net/mptcp/options.c
> index 6b825fb3fa83..9b263f27ce9b 100644
> --- a/net/mptcp/options.c
> +++ b/net/mptcp/options.c
> @@ -356,6 +356,8 @@ void mptcp_get_options(const struct sk_buff *skb,
> 			length--;
> 			continue;
> 		default:
> +			if (length < 2)
> +				return;
> 			opsize = *ptr++;
> 			if (opsize < 2) /* "silly options" */
> 				return;
> -- 
> 2.25.1

Florian's comment on patch 1 prompted me to double-check th->doff 
validation, and for MPTCP we're covered by the check in tcp_v4_rcv(). So 
this patch looks good:

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

If you send a v2 series, please also cc: mptcp@lists.linux.dev

Thanks!

--
Mat Martineau
Intel
