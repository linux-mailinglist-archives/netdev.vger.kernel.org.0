Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8B22F4E8F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbhAMP1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:27:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26245 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbhAMP1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:27:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610551580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uFG2beUc9IVe0YKmmsOPupMzO3ZnVCjAS3yzpCtkoDU=;
        b=COFUrNezdanDJ1MZmxsJ1Rz/xR9NskcuorLTN3uTHC6Q+n3zYPpKG9lchUxGbixxZHhuNK
        WMbqpVQhm83EGKNaj3ujvpawI1iZgNW3u6z0apXYebG165FnKmo51qI/VtMH7aD9ThkfdT
        szMvJHfC1vDEMe3yAZMbW6RAws3EZf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-AQv7j8wHPcOsRbm2mOxhSw-1; Wed, 13 Jan 2021 10:26:18 -0500
X-MC-Unique: AQv7j8wHPcOsRbm2mOxhSw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 522CFAFA80;
        Wed, 13 Jan 2021 15:26:17 +0000 (UTC)
Received: from ovpn-115-228.ams2.redhat.com (ovpn-115-228.ams2.redhat.com [10.36.115.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8EE25D9DD;
        Wed, 13 Jan 2021 15:26:15 +0000 (UTC)
Message-ID: <e571c016aa3586e6d68741872a0316b051fb8cca.camel@redhat.com>
Subject: Re: [PATCH net 2/2] mptcp: better msk-level shutdown.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 13 Jan 2021 16:26:14 +0100
In-Reply-To: <c863efca-6574-582b-6779-deb9c81dd900@gmail.com>
References: <cover.1610471474.git.pabeni@redhat.com>
         <4cd18371d7caa6ee4a4e7ef988b50b45e362e177.1610471474.git.pabeni@redhat.com>
         <a42a3c10-0183-a232-aec6-b1e6bbfaa800@gmail.com>
         <c863efca-6574-582b-6779-deb9c81dd900@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-13 at 11:26 +0100, Eric Dumazet wrote:
> 
> On 1/13/21 11:21 AM, Eric Dumazet wrote:
> > 
> > On 1/12/21 6:25 PM, Paolo Abeni wrote:
> > > Instead of re-implementing most of inet_shutdown, re-use
> > > such helper, and implement the MPTCP-specific bits at the
> > > 'proto' level.
> > > 
> > > The msk-level disconnect() can now be invoked, lets provide a
> > > suitable implementation.
> > > 
> > > As a side effect, this fixes bad state management for listener
> > > sockets. The latter could lead to division by 0 oops since
> > > commit ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling").
> > > 
> > > Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
> > > Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  net/mptcp/protocol.c | 62 ++++++++++++--------------------------------
> > >  1 file changed, 17 insertions(+), 45 deletions(-)
> > > 
> > > diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> > > index 2ff8c7caf74f..81faeff8f3bb 100644
> > > --- a/net/mptcp/protocol.c
> > > +++ b/net/mptcp/protocol.c
> > > @@ -2642,11 +2642,12 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
> > >  
> > >  static int mptcp_disconnect(struct sock *sk, int flags)
> > >  {
> > > -	/* Should never be called.
> > > -	 * inet_stream_connect() calls ->disconnect, but that
> > > -	 * refers to the subflow socket, not the mptcp one.
> > > -	 */
> > > -	WARN_ON_ONCE(1);
> > > +	struct mptcp_subflow_context *subflow;
> > > +	struct mptcp_sock *msk = mptcp_sk(sk);
> > > +
> > > +	__mptcp_flush_join_list(msk);
> > > +	mptcp_for_each_subflow(msk, subflow)
> > > +		tcp_disconnect(mptcp_subflow_tcp_sock(subflow), flags);
> > 
> > Ouch.
> > 
> > tcp_disconnect() is supposed to be called with socket lock being held.
> > 
> > Really, CONFIG_LOCKDEP=y should have warned you :/
> 
> Or maybe CONFIG_PROVE_RCU=y is needed to catch the bug.

Thank you for catching this!

Yep, CONFIG_PROVE_RCU=y triggers a 'suspicious RCU usage' warning. I
should really enable 'panic_on_warn' in batch tests.

I'll send a patch.

Thanks,

Paolo

