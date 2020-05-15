Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4831D5530
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgEOPxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:53:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60838 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726248AbgEOPxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589557987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aUuGGnOOq6rRV3+tQu2hhlMU1HK6emduuKwZLOwf4I4=;
        b=DnsPmi5QCuhm7FL2glLzlF7Kgf14xJ6u8wEpSoR6MANNLnRA6F9XFzlghqD/L1zOxvkOCJ
        +SvntVsXBf9HmsoPeY5XeIzNkE8+q04mmCnIUL8CcN4N/dovWkA7Y+bRGTmcOw/T1MBSXu
        yCB7UkPbCPSIrQ9Ql4EJ6kJ5X+Z/SDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-8xieKTIoOZCekgzTbW8Qcw-1; Fri, 15 May 2020 11:53:03 -0400
X-MC-Unique: 8xieKTIoOZCekgzTbW8Qcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FDAA80183C;
        Fri, 15 May 2020 15:53:02 +0000 (UTC)
Received: from ovpn-115-8.ams2.redhat.com (ovpn-115-8.ams2.redhat.com [10.36.115.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91E5746;
        Fri, 15 May 2020 15:53:00 +0000 (UTC)
Message-ID: <004e2c4790b048600e80311a22dd7b3d441c9ad9.camel@redhat.com>
Subject: Re: [PATCH net-next 1/3] mptcp: add new sock flag to deal with join
 subflows
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Date:   Fri, 15 May 2020 17:52:59 +0200
In-Reply-To: <alpine.OSX.2.22.394.2005141258520.26234@aabousam-mobl1.amr.corp.intel.com>
References: <cover.1589383730.git.pabeni@redhat.com>
         <968fb022a824140c6761c755e916f4526fee0a29.1589383730.git.pabeni@redhat.com>
         <alpine.OSX.2.22.394.2005141258520.26234@aabousam-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-05-14 at 13:13 -0700, Mat Martineau wrote:
> Paolo -
> 
> On Wed, 13 May 2020, Paolo Abeni wrote:
> 
> > MP_JOIN subflows must not land into the accept queue.
> > Currently tcp_check_req() calls an mptcp specific helper
> > to detect such scenario.
> > 
> > Such helper leverages the subflow context to check for
> > MP_JOIN subflows. We need to deal also with MP JOIN
> > failures, even when the subflow context is not available
> > due allocation failure.
> > 
> > A possible solution would be changing the syn_recv_sock()
> > signature to allow returning a more descriptive action/
> > error code and deal with that in tcp_check_req().
> > 
> > Since the above need is MPTCP specific, this patch instead
> > uses a TCP request socket hole to add a MPTCP specific flag.
> > Such flag is used by the MPTCP syn_recv_sock() to tell
> > tcp_check_req() how to deal with the request socket.
> > 
> > This change is a no-op for !MPTCP build, and makes the
> > MPTCP code simpler. It allows also the next patch to deal
> > correctly with MP JOIN failure.
> > 
> > RFC -> v1:
> > - move the drop_req bit inside tcp_request_sock (Eric)
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > include/linux/tcp.h      |  3 +++
> > include/net/mptcp.h      | 17 ++++++++++-------
> > net/ipv4/tcp_minisocks.c |  2 +-
> > net/mptcp/protocol.c     |  7 -------
> > net/mptcp/subflow.c      |  2 ++
> > 5 files changed, 16 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> > index e60db06ec28d..bf44e85d709d 100644
> > --- a/include/linux/tcp.h
> > +++ b/include/linux/tcp.h
> > @@ -120,6 +120,9 @@ struct tcp_request_sock {
> > 	u64				snt_synack; /* first SYNACK sent time */
> > 	bool				tfo_listener;
> > 	bool				is_mptcp;
> > +#if IS_ENABLED(CONFIG_MPTCP)
> > +	bool				drop_req;
> > +#endif
> > 	u32				txhash;
> > 	u32				rcv_isn;
> > 	u32				snt_isn;
> > diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> > index e60275659de6..c4a6ef4ba35b 100644
> > --- a/include/net/mptcp.h
> > +++ b/include/net/mptcp.h
> > @@ -68,6 +68,11 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
> > 	return tcp_rsk(req)->is_mptcp;
> > }
> > 
> > +static inline bool rsk_drop_req(const struct request_sock *req)
> > +{
> > +	return tcp_rsk(req)->is_mptcp && tcp_rsk(req)->drop_req;
> > +}
> > +
> > void mptcp_space(const struct sock *ssk, int *space, int *full_space);
> > bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
> > 		       unsigned int *size, struct mptcp_out_options *opts);
> > @@ -121,8 +126,6 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
> > 				 skb_ext_find(from, SKB_EXT_MPTCP));
> > }
> > 
> > -bool mptcp_sk_is_subflow(const struct sock *sk);
> > -
> > void mptcp_seq_show(struct seq_file *seq);
> > #else
> > 
> > @@ -140,6 +143,11 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
> > 	return false;
> > }
> > 
> > +static inline bool rsk_drop_req(const struct request_sock *req)
> > +{
> > +	return false;
> > +}
> > +
> > static inline void mptcp_parse_option(const struct sk_buff *skb,
> > 				      const unsigned char *ptr, int opsize,
> > 				      struct tcp_options_received *opt_rx)
> > @@ -190,11 +198,6 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
> > 	return true;
> > }
> > 
> > -static inline bool mptcp_sk_is_subflow(const struct sock *sk)
> > -{
> > -	return false;
> > -}
> > -
> > static inline void mptcp_space(const struct sock *ssk, int *s, int *fs) { }
> > static inline void mptcp_seq_show(struct seq_file *seq) { }
> > #endif /* CONFIG_MPTCP */
> > diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> > index 7e40322cc5ec..495dda2449fe 100644
> > --- a/net/ipv4/tcp_minisocks.c
> > +++ b/net/ipv4/tcp_minisocks.c
> > @@ -774,7 +774,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
> > 	if (!child)
> > 		goto listen_overflow;
> > 
> > -	if (own_req && sk_is_mptcp(child) && mptcp_sk_is_subflow(child)) {
> > +	if (own_req && rsk_drop_req(req)) {
> > 		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
> > 		inet_csk_reqsk_queue_drop_and_put(sk, req);
> > 		return child;
> > diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> > index 6a812dd8b6b6..b974898eb6b5 100644
> > --- a/net/mptcp/protocol.c
> > +++ b/net/mptcp/protocol.c
> > @@ -1687,13 +1687,6 @@ bool mptcp_finish_join(struct sock *sk)
> > 	return ret;
> > }
> > 
> > -bool mptcp_sk_is_subflow(const struct sock *sk)
> > -{
> > -	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
> > -
> > -	return subflow->mp_join == 1;
> > -}
> > -
> > static bool mptcp_memory_free(const struct sock *sk, int wake)
> > {
> > 	struct mptcp_sock *msk = mptcp_sk(sk);
> > diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> > index 009d5c478062..42a8a650ff20 100644
> > --- a/net/mptcp/subflow.c
> > +++ b/net/mptcp/subflow.c
> > @@ -500,6 +500,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
> > 			ctx->remote_key = mp_opt.sndr_key;
> > 			ctx->fully_established = mp_opt.mp_capable;
> > 			ctx->can_ack = mp_opt.mp_capable;
> > +			tcp_rsk(req)->drop_req = false;
> > 		} else if (ctx->mp_join) {
> > 			struct mptcp_sock *owner;
> > 
> > @@ -512,6 +513,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
> > 				goto close_child;
> > 
> > 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
> > +			tcp_rsk(req)->drop_req = true;
> > 		}
> 
> It looks like tcp_rsk(req)->drop_req gets initialized when the 
> ctx->mp_capable and ctx->mp_join values are set as expected, but it's hard 
> to tell if it's guaranteed to be initialized in every corner case (any 
> allocation or token failures, unexpected input, etc.).
> 
> Patch 3 will set drop_req for some cases, but does it makes sense to 
> set tcp_rsk(req)->drop_req in subflow_v{4,6}_init_req() here as an 
> additional 'else' clause?

More testing confirmed I really missed a code-path for 'drop_req'
initialization. So I'll move 'tcp_rsk(req)->drop_req = false;' at the top of 'own_req' conditional, just to stay safe.

I'll post v2 after more testing.

Thanks!

Paolo

