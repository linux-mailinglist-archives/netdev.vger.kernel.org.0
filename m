Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CA11784B5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 22:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732175AbgCCVOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 16:14:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31352 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732075AbgCCVOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 16:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583270091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qtDniFW2GkzosDdRRH2ZqPL99vwbn7hiTmp+hXZSDCg=;
        b=Y18giXIsynHWqKBk/ulhMSKON1QQBqWesZoRqmrQ/UZd5Rt6InlgQvcM88iOK25tYXH4rC
        FN/ZXH55QQae+rgnPrkcO6kuQZNDpg6IFruKaxk5yHScyaF1kykeXjV8/qH8AbnrWPswPx
        czf0b/xXKugBeOLmZMWlnZsyiuUn5JU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-nTzouVwKMT-uX8BtD29Qrg-1; Tue, 03 Mar 2020 16:14:49 -0500
X-MC-Unique: nTzouVwKMT-uX8BtD29Qrg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB593800053;
        Tue,  3 Mar 2020 21:14:47 +0000 (UTC)
Received: from ovpn-117-38.ams2.redhat.com (ovpn-117-38.ams2.redhat.com [10.36.117.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D72960BE1;
        Tue,  3 Mar 2020 21:14:46 +0000 (UTC)
Message-ID: <f4302e543d88f1e46f29bec283435edd251be51b.camel@redhat.com>
Subject: Re: [PATCH net] mptcp: always include dack if possible.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Date:   Tue, 03 Mar 2020 22:14:45 +0100
In-Reply-To: <alpine.OSX.2.22.394.2003031056030.20523@mlee22-mobl.amr.corp.intel.com>
References: <8f78569a035c045fd1ad295dd8bf17dcfeca9c41.1583256003.git.pabeni@redhat.com>
         <alpine.OSX.2.22.394.2003031056030.20523@mlee22-mobl.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-03 at 10:58 -0800, Mat Martineau wrote:
> On Tue, 3 Mar 2020, Paolo Abeni wrote:
> 
> > Currently passive MPTCP socket can skip including the DACK
> > option - if the peer sends data before accept() completes.
> > 
> > The above happens because the msk 'can_ack' flag is set
> > only after the accept() call.
> > 
> > Such missing DACK option may cause - as per RFC spec -
> > unwanted fallback to TCP.
> > 
> > This change addresses the issue using the key material
> > available in the current subflow, if any, to create a suitable
> > dack option when msk ack seq is not yet available.
> > 
> > Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > net/mptcp/options.c | 17 +++++++++++++++--
> > 1 file changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/mptcp/options.c b/net/mptcp/options.c
> > index 45acd877bef3..9eb84115dc35 100644
> > --- a/net/mptcp/options.c
> > +++ b/net/mptcp/options.c
> > @@ -334,6 +334,8 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
> > 	struct mptcp_sock *msk;
> > 	unsigned int ack_size;
> > 	bool ret = false;
> > +	bool can_ack;
> > +	u64 ack_seq;
> > 	u8 tcp_fin;
> > 
> > 	if (skb) {
> > @@ -360,9 +362,20 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
> > 		ret = true;
> > 	}
> > 
> > +	/* passive sockets msk will set the 'can_ack' after accept(), even
> > +	 * if the first subflow may have the already the remote key handy
> > +	 */
> > +	can_ack = true;
> > 	opts->ext_copy.use_ack = 0;
> > 	msk = mptcp_sk(subflow->conn);
> > -	if (!msk || !READ_ONCE(msk->can_ack)) {
> > +	if (likely(msk && READ_ONCE(msk->can_ack)))
> > +		ack_seq = msk->ack_seq;
> > +	else if (subflow->can_ack)
> > +		mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);
> 
> The other code paths that set the initial sequence number all increment it 
> before sending (to ack SYN+MP_CAPABLE). It looks like the spec allows the 
> value calculated here, but we might as well be consistent about the 
> initial value we send over the wire.

Thanks for the feedback! Agreed. I'll send a v2 tomorrow.

Cheers,

Paolo

