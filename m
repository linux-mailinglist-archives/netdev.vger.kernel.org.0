Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F08018C33F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgCSWse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:48:34 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:31557 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727646AbgCSWsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 18:48:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584658111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGXoQGvrZTkgCm169M9Ovm0ZHysGkKm26/X8UwKR7hM=;
        b=ezlLwlBt8Zs+ptQBAerrldTnuN51XmoabIW0ovm1hxa5hOUeYFLMv2h2p0oHPeXEQrdnQl
        SzvNe0K+ol6zABpytVA5pk+b1teerIHy9UmCf5pRcBNmkvQ2Ju0JxIMpCpSmU4tXkd3Ryh
        Im7KllRPqf9Q2oX66qw1yKAE+GUw+tQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-hUXB1XyBMs-BMTEsFQgDSA-1; Thu, 19 Mar 2020 18:48:27 -0400
X-MC-Unique: hUXB1XyBMs-BMTEsFQgDSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5DF9800D4E;
        Thu, 19 Mar 2020 22:48:25 +0000 (UTC)
Received: from ovpn-112-2.ams2.redhat.com (ovpn-112-2.ams2.redhat.com [10.36.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E40A5D9CD;
        Thu, 19 Mar 2020 22:48:22 +0000 (UTC)
Message-ID: <3121516743a4acdb67799565d0251531092244e7.camel@redhat.com>
Subject: Re: [PATCH net-next] net: mptcp: don't hang in mptcp_sendmsg()
 after TCP fallback
From:   Paolo Abeni <pabeni@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Thu, 19 Mar 2020 23:48:21 +0100
In-Reply-To: <9a7cd34e2d8688364297d700bfd8aea60c3a6c7f.1584653622.git.dcaratti@redhat.com>
References: <9a7cd34e2d8688364297d700bfd8aea60c3a6c7f.1584653622.git.dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-03-19 at 22:45 +0100, Davide Caratti wrote:
> it's still possible for packetdrill to hang in mptcp_sendmsg(), when the
> MPTCP socket falls back to regular TCP (e.g. after receiving unsupported
> flags/version during the three-way handshake). Adjust MPTCP socket state
> earlier, to ensure correct functionality of mptcp_sendmsg() even in case
> of TCP fallback.
> 
> Fixes: 767d3ded5fb8 ("net: mptcp: don't hang before sending 'MP capable with data'")
> Fixes: 1954b86016cf ("mptcp: Check connection state before attempting send")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/mptcp/protocol.c | 4 ----
>  net/mptcp/subflow.c  | 6 ++++++
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index e959104832ef..92d5382e71f4 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -1055,10 +1055,6 @@ void mptcp_finish_connect(struct sock *ssk)
>  	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
>  	WRITE_ONCE(msk->ack_seq, ack_seq);
>  	WRITE_ONCE(msk->can_ack, 1);
> -	if (inet_sk_state_load(sk) != TCP_ESTABLISHED) {
> -		inet_sk_state_store(sk, TCP_ESTABLISHED);
> -		sk->sk_state_change(sk);
> -	}
>  }
>  
>  static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 052d72a1d3a2..06b9075333c5 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -109,9 +109,15 @@ static void subflow_v6_init_req(struct request_sock *req,
>  static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
>  {
>  	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
> +	struct sock *parent = subflow->conn;
>  
>  	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
>  
> +	if (inet_sk_state_load(parent) != TCP_ESTABLISHED) {
> +		inet_sk_state_store(parent, TCP_ESTABLISHED);
> +		parent->sk_state_change(parent);
> +	}
> +
>  	if (!subflow->conn_finished) {
>  		pr_debug("subflow=%p, remote_key=%llu", mptcp_subflow_ctx(sk),
>  			 subflow->remote_key);

LGTM, thanks Davide!

Acked-by: Paolo Abeni <pabeni@redhat.com>

