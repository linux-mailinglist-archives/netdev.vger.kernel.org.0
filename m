Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C597570CA4
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 23:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiGKVVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 17:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGKVVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 17:21:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793BD2A716;
        Mon, 11 Jul 2022 14:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657574499; x=1689110499;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=jrR4sgIVwu8asDoM1btJi7FV1UTp9Jqz+B7cQdtvtlA=;
  b=UgdYSWn+Ixf2AB+oQrv4MFJbWqNxRMceY3YqCmfAOReNmpCUYish57zz
   lfo7kanjmr+nkzAh70JenKzQzKrTEO6CDUgYZ7dWRre6A+Aj92cD+RFhC
   zu2kn7dhaFuU/cfWTUX5s5WvB4P+UD9J1DrtDR3i/FWjha97HsieJzI/e
   iDjxfWzi+R94fdeMw7kpbi8rTntDOtRjlPYfPdI9X7YcNZWg5DbOw0Krk
   trqacfGTWhLl8uirATEwNj31xdw8xqSNczC6TdbYxhCmf29JpKWZ9Bm9x
   qe+2ZvGif16O2WkshMBODZySitbDgyfdegZd+eSa4SkjPhrbB3hOKZsK/
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="264557917"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="264557917"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 14:21:17 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="592400481"
Received: from huiyaoch-mobl.amr.corp.intel.com ([10.209.36.129])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 14:21:17 -0700
Date:   Mon, 11 Jul 2022 14:21:17 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jiri Olsa <jolsa@kernel.org>
cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev
Subject: Re: [PATCH bpf-next] mptcp: Add struct mptcp_sock definition when
 CONFIG_MPTCP is disabled
In-Reply-To: <20220711130731.3231188-1-jolsa@kernel.org>
Message-ID: <6d3b3bf-2e29-d695-87d7-c23497acc81@linux.intel.com>
References: <20220711130731.3231188-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022, Jiri Olsa wrote:

> The btf_sock_ids array needs struct mptcp_sock BTF ID for
> the bpf_skc_to_mptcp_sock helper.
>
> When CONFIG_MPTCP is disabled, the 'struct mptcp_sock' is not
> defined and resolve_btfids will complain with:
>
>  BTFIDS  vmlinux
> WARN: resolve_btfids: unresolved symbol mptcp_sock
>
> Adding empty difinition for struct mptcp_sock when CONFIG_MPTCP
> is disabled.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> include/net/mptcp.h | 4 ++++
> 1 file changed, 4 insertions(+)
>
> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> index ac9cf7271d46..25741a52c666 100644
> --- a/include/net/mptcp.h
> +++ b/include/net/mptcp.h
> @@ -59,6 +59,10 @@ struct mptcp_addr_info {
> 	};
> };
>
> +#if !IS_ENABLED(CONFIG_MPTCP)
> +struct mptcp_sock { };
> +#endif

The only use of struct mptcp_sock I see with !CONFIG_MPTCP is from this 
stub at the end of mptcp.h:

static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk) { return NULL; }

It's normally defined in net/mptcp/protocol.h for the MPTCP subsystem 
code.

The conditional could be added on the line before the stub to make it 
clear that the empty struct is associated with that inline stub.

> +
> struct mptcp_out_options {
> #if IS_ENABLED(CONFIG_MPTCP)
> 	u16 suboptions;
> -- 
> 2.35.3
>
>

--
Mat Martineau
Intel
