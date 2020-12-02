Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1D32CC2CC
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387447AbgLBQxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:53:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727877AbgLBQxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:53:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606927908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H9y8NQu9caBK69eHLU5JxliwiHBM3snVUsVDzid8AI8=;
        b=THXmt102VJris9w6f1xw8hNfBiXJcZjcVYYjZ8Ryi5PK4SnhrEV/CxwexOisWYOg8Mw5iX
        HSSr4vGhu7Y1odQDtvGmmp9jq/b+nvSSzRXL6Fc2bbM6IRgOl+2N2Xzdbg6e82yjFYMngA
        NaufPA7lMPT3Yos+p+zB5+ripdhci6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-wgKz6s4mO-K659FB1n5btw-1; Wed, 02 Dec 2020 11:51:45 -0500
X-MC-Unique: wgKz6s4mO-K659FB1n5btw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C789C73A0;
        Wed,  2 Dec 2020 16:51:44 +0000 (UTC)
Received: from ovpn-112-254.ams2.redhat.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDD395D9CA;
        Wed,  2 Dec 2020 16:51:42 +0000 (UTC)
Message-ID: <0c400986125dfdd42990ee4203a60d9b309d29c8.camel@redhat.com>
Subject: Re: [PATCH net-next v2] mptcp: be careful on MPTCP-level ack.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Date:   Wed, 02 Dec 2020 17:51:41 +0100
In-Reply-To: <e2e9500c-f2cc-2e08-6ecc-68ed50e64cd1@gmail.com>
References: <5370c0ae03449239e3d1674ddcfb090cf6f20abe.1606253206.git.pabeni@redhat.com>
         <fdad2c0e-e84e-4a82-7855-fc5a083bb055@gmail.com>
         <665bb3a603afebdcc85878f6b45bcf0313607994.camel@redhat.com>
         <2ac90c38-c82a-8aeb-2c01-b44a6de1bf57@gmail.com>
         <d05ac8b9-3522-e4fc-d3ce-4bea74a6dfbf@gmail.com>
         <ca50540b-f305-7519-6039-f3beced5e5d8@gmail.com>
         <e2e9500c-f2cc-2e08-6ecc-68ed50e64cd1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-02 at 17:45 +0100, Eric Dumazet wrote:
> 
> On 12/2/20 5:32 PM, Eric Dumazet wrote:
> > 
> > On 12/2/20 5:30 PM, Eric Dumazet wrote:
> > > 
> > > On 12/2/20 5:10 PM, Eric Dumazet wrote:
> > > > 
> > > > On 12/2/20 4:37 PM, Paolo Abeni wrote:
> > > > > On Wed, 2020-12-02 at 14:18 +0100, Eric Dumazet wrote:
> > > > > > On 11/24/20 10:51 PM, Paolo Abeni wrote:
> > > > > > > We can enter the main mptcp_recvmsg() loop even when
> > > > > > > no subflows are connected. As note by Eric, that would
> > > > > > > result in a divide by zero oops on ack generation.
> > > > > > > 
> > > > > > > Address the issue by checking the subflow status before
> > > > > > > sending the ack.
> > > > > > > 
> > > > > > > Additionally protect mptcp_recvmsg() against invocation
> > > > > > > with weird socket states.
> > > > > > > 
> > > > > > > v1 -> v2:
> > > > > > >  - removed unneeded inline keyword - Jakub
> > > > > > > 
> > > > > > > Reported-and-suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> > > > > > > Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> > > > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > > ---
> > > > > > >  net/mptcp/protocol.c | 67 ++++++++++++++++++++++++++++++++------------
> > > > > > >  1 file changed, 49 insertions(+), 18 deletions(-)
> > > > > > > 
> > > > > > 
> > > > > > Looking at mptcp recvmsg(), it seems that a read(fd, ..., 0) will
> > > > > > trigger an infinite loop if there is available data in receive queue ?
> > > > > 
> > > > > Thank you for looking into this!
> > > > > 
> > > > > I can't reproduce the issue with the following packetdrill ?!?
> > > > > 
> > > > > +0.0  connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
> > > > > +0.1   > S 0:0(0) <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8,mpcapable v1 fflags[flag_h] nokey>
> > > > > +0.1   < S. 0:0(0) ack 1 win 65535 <mss 1460,sackOK,TS val 700 ecr 100,nop,wscaale 8,mpcapable v1 flags[flag_h] key[skey=2] >
> > > > > +0.1  > . 1:1(0) ack 1 <nop, nop, TS val 100 ecr 700,mpcapable v1 flags[flag_h]] key[ckey,skey]>
> > > > > +0.1 fcntl(3, F_SETFL, O_RDWR) = 0
> > > > > +0.1   < .  1:201(200) ack 1 win 225 <dss dack8=1 dsn8=1 ssn=1 dll=200 nocs,  nop, nop>
> > > > > +0.1   > .  1:1(0) ack 201 <nop, nop, TS val 100 ecr 700, dss dack8=201 dll=00 nocs>
> > > > > +0.1 read(3, ..., 0) = 0
> > > > > 
> > > > > The main recvmsg() loop is interrupted by the following check:
> > > > > 
> > > > >                 if (copied >= target)
> > > > >                         break;
> > > > 
> > > > @copied should be 0, and @target should be 1
> > > > 
> > > > Are you sure the above condition is triggering ?
> > > > 
> > > > Maybe read(fd, ..., 0) does not reach recvmsg() at all.
> > > 
> > > Yes, sock_read_iter() has a shortcut :
> > > 
> > > if (!iov_iter_count(to))    /* Match SYS5 behaviour */
> > >      res = sock_recvmsg(sock, &msg, msg.msg_flags);
> > 
> > No idea what went wrong with my copy/paste.
> > 
> > The real code is more like :
> > 
> > if (!iov_iter_count(to))    /* Match SYS5 behaviour */
> >     return 0;
> > 
> 
> Packetdrill recvmsg syntax would be something like
> 
>    +0	recvmsg(3, {msg_name(...)=...,
> 		    msg_iov(1)=[{..., 0}],
> 		    msg_flags=0
> 		    }, 0) = 0

Thank you very much for all the effort!

Yes, with recvmsg() the packet drill hangs. I agree your proposed fix
is correct.

I can test it explicitly later today.

(and sorry for the initial confusing/confused reply)

Paolo



