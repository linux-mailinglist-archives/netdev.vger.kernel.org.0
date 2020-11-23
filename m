Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9282C0D65
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgKWOVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:21:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729597AbgKWOVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:21:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606141270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFX100UN+MAeeLeuZvJUKayCL3HfCEMAs7islFSWnWY=;
        b=O9qMgqTy4LfKMoR+UzzN2WnOf0y+iAqBDQ8qBSWbYxVlNadeXlrbB+V5/YAhR8qwR3NXfF
        C9oSHn77Jv+RrwUvR9HyJo+tz7vgg9DNLbUeagiFSmSohRWjlG6qNOwJFpvp9/c3/H5LsA
        7U2TZcmuLvbV7O0EGw1ghpMSk5jsoJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-uYz1eSMKNlii2XWjJ3YoJA-1; Mon, 23 Nov 2020 09:21:07 -0500
X-MC-Unique: uYz1eSMKNlii2XWjJ3YoJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EBCD1868429;
        Mon, 23 Nov 2020 14:21:06 +0000 (UTC)
Received: from ovpn-114-150.ams2.redhat.com (ovpn-114-150.ams2.redhat.com [10.36.114.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B3915D6DC;
        Mon, 23 Nov 2020 14:21:04 +0000 (UTC)
Message-ID: <88ac6b9ddbdc6cf825ac3d7f65c9e0ee7f5cadd9.camel@redhat.com>
Subject: Re: [PATCH net-next 10/10] mptcp: refine MPTCP-level ack scheduling
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, mptcp@lists.01.org
Date:   Mon, 23 Nov 2020 15:21:03 +0100
In-Reply-To: <ca0b65f8-7a69-ff4e-9e0d-66a7a923b0c1@gmail.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
         <20201119194603.103158-11-mathew.j.martineau@linux.intel.com>
         <ca0b65f8-7a69-ff4e-9e0d-66a7a923b0c1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 2020-11-23 at 12:57 +0100, Eric Dumazet wrote:
> > diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> > index 4ae2c4a30e44..748343f1a968 100644
> > --- a/net/mptcp/protocol.c
> > +++ b/net/mptcp/protocol.c
> > @@ -407,16 +407,42 @@ static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
> >  	mptcp_sk(sk)->timer_ival = tout > 0 ? tout : TCP_RTO_MIN;
> >  }
> >  
> > -static void mptcp_send_ack(struct mptcp_sock *msk)
> > +static bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
> > +{
> > +	struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
> > +
> > +	/* can't send if JOIN hasn't completed yet (i.e. is usable for mptcp) */
> > +	if (subflow->request_join && !subflow->fully_established)
> > +		return false;
> > +
> > +	/* only send if our side has not closed yet */
> > +	return ((1 << ssk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT));
> > +}
> > +
> > +static void mptcp_send_ack(struct mptcp_sock *msk, bool force)
> >  {
> >  	struct mptcp_subflow_context *subflow;
> > +	struct sock *pick = NULL;
> >  
> >  	mptcp_for_each_subflow(msk, subflow) {
> >  		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
> >  
> > -		lock_sock(ssk);
> > -		tcp_send_ack(ssk);
> > -		release_sock(ssk);
> > +		if (force) {
> > +			lock_sock(ssk);
> > +			tcp_send_ack(ssk);
> > +			release_sock(ssk);
> > +			continue;
> > +		}
> > +
> > +		/* if the hintes ssk is still active, use it */
> > +		pick = ssk;
> > +		if (ssk == msk->ack_hint)
> > +			break;
> > +	}
> > +	if (!force && pick) {
> > +		lock_sock(pick);
> > +		tcp_cleanup_rbuf(pick, 1);
> 
> Calling tcp_cleanup_rbuf() on a socket that was never established is going to fail
> with a divide by 0 (mss being 0)
> 
> AFAIK, mptcp_recvmsg() can be called right after a socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP)
> call.
> 
> Probably, after a lock_sock(), you should double check socket state (same above before calling tcp_send_ack())

Thank you for looking into this.

Indeed you are right! I'll try to cook a fix.

Cheers,

Paolo

