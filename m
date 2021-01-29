Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFC6308D17
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhA2THs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhA2TGr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 14:06:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1726664DFB;
        Fri, 29 Jan 2021 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611947166;
        bh=jTqi+jdOU05OqAmzEdlj9q9kyuMeRaWQDDxAGUJIAYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jFysm8KKZ3948cZWZJ2i269CZyeMyaH4hfh3gaYawmwKT4CxjTTtoXwtyiBU7fKe3
         +oxDjfs5+kTQUjG06w7Y1Fp7LUmgZVVma8wIoyOk7pZHqcVfVv2Dyr6CchmmHVheIT
         O45ZWNWJw5/8J/aPRmB8mpCNyRhzWRKEssaAWrJCawj4QcfC9YX7z+8/McvpepULnf
         oJcGC1RHKTkaQ2VDMQgwdOOkCGcjQ+bST+L3Crd2p5RIrjUYbiDGZ+egmSMHlezaEk
         bmsVWx4gGiuiqIRB3m2kARJx4c1Nuibhr1UZHBpY5QhFZ9QMyJmw4KcsEybKHMlvki
         7gpBBn5JwuocA==
Date:   Fri, 29 Jan 2021 11:06:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andy.rudoff@intel.com
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Message-ID: <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
References: <20210122150638.210444-1-willy@infradead.org>
        <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 09:56:48 -0800 Shoaib Rao wrote:
> On 1/25/21 3:36 PM, Jakub Kicinski wrote:
> > On Fri, 22 Jan 2021 15:06:37 +0000 Matthew Wilcox (Oracle) wrote:  
> >> From: Rao Shoaib <rao.shoaib@oracle.com>
> >>
> >> TCP sockets allow SIGURG to be sent to the process holding the other
> >> end of the socket.  Extend Unix sockets to have the same ability.
> >>
> >> The API is the same in that the sender uses sendmsg() with MSG_OOB to
> >> raise SIGURG.  Unix sockets behave in the same way as TCP sockets with
> >> SO_OOBINLINE set.  
> > Noob question, if we only want to support the inline mode, why don't we
> > require SO_OOBINLINE to have been called on @other? Wouldn't that
> > provide more consistent behavior across address families?
> >
> > With the current implementation the receiver will also not see MSG_OOB
> > set in msg->msg_flags, right?  
> 
> SO_OOBINLINE does not control the delivery of signal, It controls how
> OOB Byte is delivered. It may not be obvious but this change does not
> deliver any Byte, just a signal. So, as long as sendmsg flag contains
> MSG_OOB, signal will be delivered just like it happens for TCP.

Not as far as I can read this code. If MSG_OOB is set the data from the
message used to be discarded, and EOPNOTSUPP returned. Now the data gets
queued to the socket, and will be read inline.

Sure, you also add firing of the signal, which is fine. The removal of
the error check is the code I'm pointing at, so to speak.

> >> SIGURG is ignored by default, so applications which do not know about this
> >> feature will be unaffected.  In addition to installing a SIGURG handler,
> >> the receiving application must call F_SETOWN or F_SETOWN_EX to indicate
> >> which process or thread should receive the signal.
> >>
> >> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
> >> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> >> ---
> >>   net/unix/af_unix.c | 5 +++--
> >>   1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> >> index 41c3303c3357..849dff688c2c 100644
> >> --- a/net/unix/af_unix.c
> >> +++ b/net/unix/af_unix.c
> >> @@ -1837,8 +1837,6 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
> >>   		return err;
> >>   
> >>   	err = -EOPNOTSUPP;
> >> -	if (msg->msg_flags&MSG_OOB)
> >> -		goto out_err;
> >>   
> >>   	if (msg->msg_namelen) {
> >>   		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
> >> @@ -1903,6 +1901,9 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
> >>   		sent += size;
> >>   	}
> >>   
> >> +	if (msg->msg_flags & MSG_OOB)
> >> +		sk_send_sigurg(other);
> >> +
> >>   	scm_destroy(&scm);
> >>   
> >>   	return sent;  

