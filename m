Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4597F1782AA
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbgCCS6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:58:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:29601 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730111AbgCCS6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 13:58:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 10:58:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="287080932"
Received: from mlee22-mobl.amr.corp.intel.com ([10.251.30.98])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Mar 2020 10:58:08 -0800
Date:   Tue, 3 Mar 2020 10:58:08 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mlee22-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: Re: [PATCH net] mptcp: always include dack if possible.
In-Reply-To: <8f78569a035c045fd1ad295dd8bf17dcfeca9c41.1583256003.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2003031056030.20523@mlee22-mobl.amr.corp.intel.com>
References: <8f78569a035c045fd1ad295dd8bf17dcfeca9c41.1583256003.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Paolo -

On Tue, 3 Mar 2020, Paolo Abeni wrote:

> Currently passive MPTCP socket can skip including the DACK
> option - if the peer sends data before accept() completes.
>
> The above happens because the msk 'can_ack' flag is set
> only after the accept() call.
>
> Such missing DACK option may cause - as per RFC spec -
> unwanted fallback to TCP.
>
> This change addresses the issue using the key material
> available in the current subflow, if any, to create a suitable
> dack option when msk ack seq is not yet available.
>
> Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/options.c | 17 +++++++++++++++--
> 1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/net/mptcp/options.c b/net/mptcp/options.c
> index 45acd877bef3..9eb84115dc35 100644
> --- a/net/mptcp/options.c
> +++ b/net/mptcp/options.c
> @@ -334,6 +334,8 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
> 	struct mptcp_sock *msk;
> 	unsigned int ack_size;
> 	bool ret = false;
> +	bool can_ack;
> +	u64 ack_seq;
> 	u8 tcp_fin;
>
> 	if (skb) {
> @@ -360,9 +362,20 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
> 		ret = true;
> 	}
>
> +	/* passive sockets msk will set the 'can_ack' after accept(), even
> +	 * if the first subflow may have the already the remote key handy
> +	 */
> +	can_ack = true;
> 	opts->ext_copy.use_ack = 0;
> 	msk = mptcp_sk(subflow->conn);
> -	if (!msk || !READ_ONCE(msk->can_ack)) {
> +	if (likely(msk && READ_ONCE(msk->can_ack)))
> +		ack_seq = msk->ack_seq;
> +	else if (subflow->can_ack)
> +		mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);

The other code paths that set the initial sequence number all increment it 
before sending (to ack SYN+MP_CAPABLE). It looks like the spec allows the 
value calculated here, but we might as well be consistent about the 
initial value we send over the wire.

> +	else
> +		can_ack = false;
> +
> +	if (unlikely(!can_ack)) {
> 		*size = ALIGN(dss_size, 4);
> 		return ret;
> 	}
> @@ -375,7 +388,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
>
> 	dss_size += ack_size;
>
> -	opts->ext_copy.data_ack = msk->ack_seq;
> +	opts->ext_copy.data_ack = ack_seq;
> 	opts->ext_copy.ack64 = 1;
> 	opts->ext_copy.use_ack = 1;
>
> -- 
> 2.21.1
>
>

--
Mat Martineau
Intel
