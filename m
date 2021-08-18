Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25B73F0C65
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 22:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhHRUG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 16:06:56 -0400
Received: from aibo.runbox.com ([91.220.196.211]:41128 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232149AbhHRUGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 16:06:53 -0400
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <post@jbechtel.de>)
        id 1mGRpI-0008Io-AX; Wed, 18 Aug 2021 22:06:16 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (535840)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1mGRp0-0007Ru-GY; Wed, 18 Aug 2021 22:05:58 +0200
Date:   Wed, 18 Aug 2021 21:57:38 +0200
From:   Jonas Bechtel <post@jbechtel.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: ss command not showing raw sockets? (regression)
Message-ID: <20210818215738.1830fd0b@mmluhan>
In-Reply-To: <74deda94-f14e-be9e-6925-527c7b70a563@gmail.com>
References: <20210815231738.7b42bad4@mmluhan>
        <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210817080451.34286807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210817202135.6b42031f@mmluhan>
        <20210817114402.78463d9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <af485441-123b-4f50-f01b-cee2612b9218@gmail.com>
        <20210817143753.30f21bb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <74deda94-f14e-be9e-6925-527c7b70a563@gmail.com>
X-Mailer: Claws Mail ~3.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On Tue, 17 Aug 2021 18:47:06 -0600
David Ahern <dsahern@gmail.com> wrote with subject
"Re: ss command not showing raw sockets? (regression)":

> On 8/17/21 3:37 PM, Jakub Kicinski wrote:
> > 
> > Ah, good point, strace will show it. 
> > 
> > /me goes off to look at the strace Jonas sent off list.
> > 
> > Well this is unexpected:
> > 
> > sendmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0,
> > nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base={{len=76,
> > type=DCCPDIAG_GETSOCK, ... --->8----------------  
> > 
> > From: Jakub Kicinski <kuba@kernel.org>
> > Subject: ss: fix fallback to procfs for raw and sctp sockets
> > 
> > sockdiag_send() diverts to tcpdiag_send() to try the older
> > netlink interface. tcpdiag_send() works for TCP and DCCP
> > but not other protocols. Instead of rejecting unsupported
> > protocols (and missing RAW and SCTP) match on supported ones.
> > 
> > Fixes: 41fe6c34de50 ("ss: Add inet raw sockets information
> > gathering via netlink diag interface") Signed-off-by: Jakub
> > Kicinski <kuba@kernel.org> ---
> >  misc/ss.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/misc/ss.c b/misc/ss.c
> > index 894ad40574f1..b39f63fe3b17 100644
> > --- a/misc/ss.c
> > +++ b/misc/ss.c
> > @@ -3404,13 +3404,13 @@ static int tcpdiag_send(int fd, int
> > protocol, struct filter *f) struct iovec iov[3];
> >  	int iovlen = 1;
> >  
> > -	if (protocol == IPPROTO_UDP || protocol == IPPROTO_MPTCP)
> > -		return -1;
> > -
> >  	if (protocol == IPPROTO_TCP)
> >  		req.nlh.nlmsg_type = TCPDIAG_GETSOCK;
> > -	else
> > +	else if (protocol == IPPROTO_DCCP)
> >  		req.nlh.nlmsg_type = DCCPDIAG_GETSOCK;
> > +	else
> > +		return -1;
> > +
> >  	if (show_mem) {
> >  		req.r.idiag_ext |= (1<<(INET_DIAG_MEMINFO-1));
> >  		req.r.idiag_ext |= (1<<(INET_DIAG_SKMEMINFO-1));
> >   
> 
> That looks correct to me.
> 
> Jonas: can you build iproute2 and test?

I've cloned branch main as instructed in https://wiki.linuxfoundation.org/networking/iproute2. Most recent commit is 9b7ea92b9e3f. After building, no socket was listed in table.

Then I [manually] applied the patch and rebuilt. The patched version works well, I do see the two sockets right now.

Command was in both cases misc/ss -awp

