Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5F82FDA90
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388994AbhATOCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:02:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726278AbhATMuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:50:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611146904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=to3I+Vc6MogcZurvxbaj4Y0JvXwjx8zx2T0T0TYwMYE=;
        b=a68ZRQub/RJj+Zdwt4sNloe/E4d8FPv2uy6xiRNwMqPxrup5OM9s28rereTI4eNegjeZXb
        RmpvdshKelmBpHpPhoIjYfujp2TkV7TIY+pUUOZs24G6gM1STKEeKYMGFpU1daZCKJeXex
        VobXDvBAccvOSDcV6VD0tVLNRnBLBFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-41c7P-DkP8WAcbUbrXDxFQ-1; Wed, 20 Jan 2021 07:48:20 -0500
X-MC-Unique: 41c7P-DkP8WAcbUbrXDxFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0164F15727;
        Wed, 20 Jan 2021 12:48:19 +0000 (UTC)
Received: from ovpn-115-164.ams2.redhat.com (ovpn-115-164.ams2.redhat.com [10.36.115.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3CD92BFE3;
        Wed, 20 Jan 2021 12:48:17 +0000 (UTC)
Message-ID: <cfbbf7b06522e21331328973756831ed06af2a68.camel@redhat.com>
Subject: Re: [PATCH net-next 5/5] mptcp: implement delegated actions
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Date:   Wed, 20 Jan 2021 13:48:16 +0100
In-Reply-To: <8706d39df58e903238c050999e6f88b8eb78d4a1.1610991949.git.pabeni@redhat.com>
References: <cover.1610991949.git.pabeni@redhat.com>
         <8706d39df58e903238c050999e6f88b8eb78d4a1.1610991949.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-20 at 11:40 +0100, Paolo Abeni wrote:
> @@ -428,6 +429,7 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
>  static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops;
>  static struct inet_connection_sock_af_ops subflow_v6_specific;
>  static struct inet_connection_sock_af_ops subflow_v6m_specific;
> +static struct proto tcpv6_prot_override;
>  
>  static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
>  {
> @@ -509,6 +511,14 @@ static void subflow_ulp_fallback(struct sock *sk,
>  	icsk->icsk_ulp_ops = NULL;
>  	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
>  	tcp_sk(sk)->is_mptcp = 0;
> +
> +	/* undo override */
> +#if IS_ENABLED(CONFIG_MPTCP_IPV6)
> +	if (sk->sk_prot == &tcpv6_prot_override)
> +		sk->sk_prot = &tcpv6_prot;
> +	else
> +#endif
> +		sk->sk_prot = &tcp_prot;

CI just spotted an UaF due this patch. We need to do the above also at
ULP release time. I'll send a v2 soon.

Sorry for the noise.

Paolo

