Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8CC19141B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 16:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgCXPUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 11:20:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47857 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727589AbgCXPUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 11:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585063249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+JTcpVfOw/bmfScdEMgRwUs3s3EW2/WgRaQGfv5rQsY=;
        b=QOmNLagyGqwBakN3mmaRtnVdSFkNdyJAdn/3/1gvkJyzKtMcBoIDtAk8hFErgTkdyQO7gk
        yiIRYOkRJPhy8KIzf0/sv/LZHDhZpWz7Fan1TH0vDGICwm5I8U6ShReMCNse5k9Ht6eSm6
        372nZnM1RzG2JJrbO/Ql+mc0DcD7TsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-UZPWCj5QOJmuIrOmf1PGFw-1; Tue, 24 Mar 2020 11:20:47 -0400
X-MC-Unique: UZPWCj5QOJmuIrOmf1PGFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13454107ACC9;
        Tue, 24 Mar 2020 15:20:46 +0000 (UTC)
Received: from ovpn-114-145.ams2.redhat.com (ovpn-114-145.ams2.redhat.com [10.36.114.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03807A0A63;
        Tue, 24 Mar 2020 15:20:10 +0000 (UTC)
Message-ID: <fc891ad2dd19edf7a11da0a62ca40c53581fa85e.camel@redhat.com>
Subject: Re: [PATCH net-next 04/17] mptcp: Add handling of outgoing MP_JOIN
 requests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 24 Mar 2020 16:20:09 +0100
In-Reply-To: <20200323212642.34104-5-mathew.j.martineau@linux.intel.com>
References: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
         <20200323212642.34104-5-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-03-23 at 14:26 -0700, Mat Martineau wrote:
> @@ -131,6 +149,7 @@ static void subflow_init_req(struct request_sock *req,
>  
>  		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
>  	} else if (rx_opt.mptcp.mp_join && listener->request_mptcp) {
> +		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
>  		subflow_req->mp_join = 1;
>  		subflow_req->backup = rx_opt.mptcp.backup;
>  		subflow_req->remote_id = rx_opt.mptcp.join_id;
> @@ -169,13 +188,35 @@ static void subflow_v6_init_req(struct request_sock *req,
>  }
>  #endif
>  
> +/* validate received truncated hmac and create hmac for third ACK */
> +static bool subflow_thmac_valid(struct mptcp_subflow_context *subflow)
> +{
> +	u8 hmac[MPTCPOPT_HMAC_LEN];
> +	u64 thmac;
> +
> +	subflow_generate_hmac(subflow->remote_key, subflow->local_key,
> +			      subflow->remote_nonce, subflow->local_nonce,
> +			      hmac);
> +
> +	thmac = get_unaligned_be64(hmac);
> +	pr_debug("subflow=%p, token=%u, thmac=%llu, subflow->thmac=%llu\n",
> +		 subflow, subflow->token,
> +		 (unsigned long long)thmac,
> +		 (unsigned long long)subflow->thmac);
> +
> +	return thmac == subflow->thmac;
> +}
> +
>  static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
>  {
>  	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
>  
>  	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
>  
> -	if (!subflow->conn_finished) {
> +	if (subflow->conn_finished || !tcp_sk(sk)->is_mptcp)
> +		return;
> +
> +	if (subflow->mp_capable) {
>  		pr_debug("subflow=%p, remote_key=%llu", mptcp_subflow_ctx(sk),
>  			 subflow->remote_key);
>  		mptcp_finish_connect(sk);

This chunk conflicts with commit c3c123d16c0ed4a81b9b18d3759a31c58b2fe504.

The next iteration will address such conflict.

Thanks,

Paolo


