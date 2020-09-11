Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55A62666E9
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgIKRfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:35:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59275 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725959AbgIKRfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599845705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s9a0YBNTX5BY/jledQD9dQtXgYSOg6WQJwbSeVTaRrU=;
        b=fpXe5fG1Vhkk8Eq1N6w7DjwCa6kMFUHfYspZom5c/qaMV5udjE/KNqx5oJfzS66yfsS70T
        CJkyqjBLp0USxNGZhOJfYlcOFG/Y7upBg9Xx56BVvodC1iNh+w3PoohxgAVvPBEwEf4Wny
        FQDKgDYfN9xfHdFjbg2PgWVmVaGmYt0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-ehULRlF0PveL-fP-xe2u_A-1; Fri, 11 Sep 2020 13:35:03 -0400
X-MC-Unique: ehULRlF0PveL-fP-xe2u_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4A651074645;
        Fri, 11 Sep 2020 17:35:01 +0000 (UTC)
Received: from ovpn-114-214.ams2.redhat.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E99F5C1BD;
        Fri, 11 Sep 2020 17:34:59 +0000 (UTC)
Message-ID: <1cf4fa90e9e459901598207261423cc9d88dd9d0.camel@redhat.com>
Subject: Re: [PATCH net-next 11/13] mptcp: allow picking different xmit
 subflows
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Date:   Fri, 11 Sep 2020 19:34:58 +0200
In-Reply-To: <3b8e364293d3cbb0348f20ca14301200aa43bc24.1599832097.git.pabeni@redhat.com>
References: <cover.1599832097.git.pabeni@redhat.com>
         <3b8e364293d3cbb0348f20ca14301200aa43bc24.1599832097.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-09-11 at 15:52 +0200, Paolo Abeni wrote:
 [...]
> +#define MPTCP_SEND_BURST_SIZE		((1 << 16) - \
> +					 sizeof(struct tcphdr) - \
> +					 MAX_TCP_OPTION_SPACE - \
> +					 sizeof(struct ipv6hdr) - \
> +					 sizeof(struct frag_hdr))
> +
> +struct subflow_send_info {
> +	struct sock *ssk;
> +	uint64_t ratio;
> +};
> +
>  static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk,
>  					   u32 *sndbuf)
>  {
> +	struct subflow_send_info send_info[2];
>  	struct mptcp_subflow_context *subflow;
> -	struct sock *sk = (struct sock *)msk;
> -	struct sock *backup = NULL;
> -	bool free;
> +	int i, nr_active = 0;
> +	int64_t ratio, pace;
> +	struct sock *ssk;
>  
> -	sock_owned_by_me(sk);
> +	sock_owned_by_me((struct sock *)msk);
>  
>  	*sndbuf = 0;
>  	if (!mptcp_ext_cache_refill(msk))
>  		return NULL;
>  
> -	mptcp_for_each_subflow(msk, subflow) {
> -		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
> -
> -		free = sk_stream_is_writeable(subflow->tcp_sock);
> -		if (!free) {
> -			mptcp_nospace(msk);
> +	if (__mptcp_check_fallback(msk)) {
> +		if (!msk->first)
>  			return NULL;
> +		*sndbuf = msk->first->sk_sndbuf;
> +		return sk_stream_memory_free(msk->first) ? msk->first : NULL;
> +	}
> +
> +	/* re-use last subflow, if the burst allow that */
> +	if (msk->last_snd && msk->snd_burst > 0 &&
> +	    sk_stream_memory_free(msk->last_snd) &&
> +	    mptcp_subflow_active(mptcp_subflow_ctx(msk->last_snd))) {
> +		mptcp_for_each_subflow(msk, subflow) {
> +			ssk =  mptcp_subflow_tcp_sock(subflow);
> +			*sndbuf = max(tcp_sk(ssk)->snd_wnd, *sndbuf);
>  		}
> +		return msk->last_snd;
> +	}
> +
> +	/* pick the subflow with the lower wmem/wspace ratio */
> +	for (i = 0; i < 2; ++i) {
> +		send_info[i].ssk = NULL;
> +		send_info[i].ratio = -1;
> +	}
> +	mptcp_for_each_subflow(msk, subflow) {
> +		ssk =  mptcp_subflow_tcp_sock(subflow);
> +		if (!mptcp_subflow_active(subflow))
> +			continue;
>  
> +		nr_active += !subflow->backup;
>  		*sndbuf = max(tcp_sk(ssk)->snd_wnd, *sndbuf);
> -		if (subflow->backup) {
> -			if (!backup)
> -				backup = ssk;
> +		if (!sk_stream_memory_free(subflow->tcp_sock))
> +			continue;
>  
> +		pace = READ_ONCE(ssk->sk_pacing_rate);
> +		if (!pace)
>  			continue;
> -		}
>  
> -		return ssk;
> +		ratio = (int64_t)READ_ONCE(ssk->sk_wmem_queued) << 32 / pace;

Kbuild bot on our devel branch just noted that the above division
breaks 32 bits build.

I'll fix that in v2.

Cheers,

Paolo

