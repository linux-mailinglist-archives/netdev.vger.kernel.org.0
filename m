Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E768624C7D7
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 00:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgHTWjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 18:39:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:65027 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbgHTWjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 18:39:22 -0400
IronPort-SDR: 6rt7al45ND6IZp8mFtcSwqta/iZn4ZjGs4p0fjjvMuCSU1EsFDxAm7Aoz7UFehDB+dYdKG31E6
 jmpua+JORsSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="154690747"
X-IronPort-AV: E=Sophos;i="5.76,334,1592895600"; 
   d="scan'208";a="154690747"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 15:39:22 -0700
IronPort-SDR: C6Nvwk9fzMSQMIfySUZfIOI2brSX05vtV6FmRW3j0QvwdRIStrNdxArTPHaJ1Ql2EVOBZjE0B1
 AahO8WhgWwRw==
X-IronPort-AV: E=Sophos;i="5.76,334,1592895600"; 
   d="scan'208";a="297743778"
Received: from unknown (HELO [10.254.123.1]) ([10.254.123.1])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 15:39:21 -0700
Date:   Thu, 20 Aug 2020 15:39:21 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mjmartin-mac01.local
To:     Martin KaFai Lau <kafai@fb.com>
cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH v5 bpf-next 07/12] bpf: tcp: Add bpf_skops_hdr_opt_len()
 and bpf_skops_write_hdr_opt()
In-Reply-To: <20200820190052.2885316-1-kafai@fb.com>
Message-ID: <alpine.OSX.2.23.453.2008201529350.59053@mjmartin-mac01.local>
References: <20200820190008.2883500-1-kafai@fb.com> <20200820190052.2885316-1-kafai@fb.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 20 Aug 2020, Martin KaFai Lau wrote:

> The bpf prog needs to parse the SYN header to learn what options have
> been sent by the peer's bpf-prog before writing its options into SYNACK.
> This patch adds a "syn_skb" arg to tcp_make_synack() and send_synack().
> This syn_skb will eventually be made available (as read-only) to the
> bpf prog.  This will be the only SYN packet available to the bpf
> prog during syncookie.  For other regular cases, the bpf prog can
> also use the saved_syn.
>
> When writing options, the bpf prog will first be called to tell the
> kernel its required number of bytes.  It is done by the new
> bpf_skops_hdr_opt_len().  The bpf prog will only be called when the new
> BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG is set in tp->bpf_sock_ops_cb_flags.
> When the bpf prog returns, the kernel will know how many bytes are needed
> and then update the "*remaining" arg accordingly.  4 byte alignment will
> be included in the "*remaining" before this function returns.  The 4 byte
> aligned number of bytes will also be stored into the opts->bpf_opt_len.
> "bpf_opt_len" is a newly added member to the struct tcp_out_options.
>
> Then the new bpf_skops_write_hdr_opt() will call the bpf prog to write the
> header options.  The bpf prog is only called if it has reserved spaces
> before (opts->bpf_opt_len > 0).
>
> The bpf prog is the last one getting a chance to reserve header space
> and writing the header option.
>
> These two functions are half implemented to highlight the changes in
> TCP stack.  The actual codes preparing the bpf running context and
> invoking the bpf prog will be added in the later patch with other
> necessary bpf pieces.
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
> include/net/tcp.h              |   6 +-
> include/uapi/linux/bpf.h       |   3 +-
> net/ipv4/tcp_input.c           |   5 +-
> net/ipv4/tcp_ipv4.c            |   5 +-
> net/ipv4/tcp_output.c          | 105 +++++++++++++++++++++++++++++----
> net/ipv6/tcp_ipv6.c            |   5 +-
> tools/include/uapi/linux/bpf.h |   3 +-
> 7 files changed, 109 insertions(+), 23 deletions(-)
>

...

> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 5084333b5ab6..631a5ee0dd4e 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c

...

> @@ -826,6 +886,15 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
> 			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
> 	}
>
> +	if (unlikely(BPF_SOCK_OPS_TEST_FLAG(tp,
> +					    BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG))) {
> +		unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
> +
> +		bpf_skops_hdr_opt_len(sk, skb, NULL, NULL, 0, opts, &remaining);
> +
> +		size = MAX_TCP_OPTION_SPACE - remaining;
> +	}
> +
> 	return size;
> }
>

Since bpf_skops_hdr_opt_len() is called after the SACK code tries to use 
up all remaining option space for SACK blocks, it's less likely that there 
will be sufficient space remaining. Did you consider moving this hunk 
before the SACK option space is allocated to give the bpf prog higher 
priority?

--
Mat Martineau
Intel
