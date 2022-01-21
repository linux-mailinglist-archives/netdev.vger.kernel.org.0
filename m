Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392FE49668D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 21:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiAUUpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 15:45:02 -0500
Received: from mga14.intel.com ([192.55.52.115]:45565 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230206AbiAUUpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 15:45:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642797901; x=1674333901;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=3pkJrpiYFusXoDTrhJ/CUiPlq5DIDo4wnLNlUR3WS/Y=;
  b=GnWCpBKcL8VBCiHjsTiU+aSybaJ90jkLPwvptajUHgxCU9fLJp8jbAu+
   kXM3oYNV2swj4NCZdskuuPLy1rTNqS4gW1UshdsaxPw7nbtVqMg53xe8G
   1OQJppWjDFH2NVD6fm3cu13+lilxQiuODcdHp988Fq5XmCxtDS1n6C/at
   tOJxFPhjHRLwkLEjoaoDERAkSJOQzSTp+WpZxwup84Q1z0nV8GbSHCE8J
   MOQuZaJAnByX57FhoigTue/Xs+dHc+QHFokjRFE8tOiMVOjXf7E56Og0r
   SFm869AxWrI2TUxldR/wNfHvQq4nNTMTRpDYUFhfiBRC1Xv1V7v8ZP8Bp
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10234"; a="245960629"
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="245960629"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 12:44:56 -0800
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="579725848"
Received: from hma4-mobl2.amr.corp.intel.com ([10.212.239.251])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 12:44:56 -0800
Date:   Fri, 21 Jan 2022 12:44:55 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Kees Cook <keescook@chromium.org>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mptcp: Use struct_group() to avoid cross-field
 memset()
In-Reply-To: <20220121073935.1154263-1-keescook@chromium.org>
Message-ID: <73486c93-8ebb-2391-dc50-a2b2cb38743@linux.intel.com>
References: <20220121073935.1154263-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022, Kees Cook wrote:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
>
> Use struct_group() to capture the fields to be reset, so that memset()
> can be appropriately bounds-checked by the compiler.
>
> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: mptcp@lists.linux.dev
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> net/mptcp/protocol.h | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>

Thanks Kees, looks good to me. I checked around for other MPTCP structs 
that would need similar attention and didn't see any.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>


> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index 0e6b42c76ea0..85317ce38e3f 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -408,7 +408,7 @@ DECLARE_PER_CPU(struct mptcp_delegated_action, mptcp_delegated_actions);
> struct mptcp_subflow_context {
> 	struct	list_head node;/* conn_list of subflows */
>
> -	char	reset_start[0];
> +	struct_group(reset,
>
> 	unsigned long avg_pacing_rate; /* protected by msk socket lock */
> 	u64	local_key;
> @@ -458,7 +458,7 @@ struct mptcp_subflow_context {
>
> 	long	delegated_status;
>
> -	char	reset_end[0];
> +	);
>
> 	struct	list_head delegated_node;   /* link into delegated_action, protected by local BH */
>
> @@ -494,7 +494,7 @@ mptcp_subflow_tcp_sock(const struct mptcp_subflow_context *subflow)
> static inline void
> mptcp_subflow_ctx_reset(struct mptcp_subflow_context *subflow)
> {
> -	memset(subflow->reset_start, 0, subflow->reset_end - subflow->reset_start);
> +	memset(&subflow->reset, 0, sizeof(subflow->reset));
> 	subflow->request_mptcp = 1;
> }
>
> -- 
> 2.30.2
>
>

--
Mat Martineau
Intel
