Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC2D186E1
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 10:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfEIIko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 04:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfEIIko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 04:40:44 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 84BA73086268;
        Thu,  9 May 2019 08:40:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BE7E60BFB;
        Thu,  9 May 2019 08:40:41 +0000 (UTC)
Message-ID: <bcfa1b06f277357d89b746a4fced49c0617deef1.camel@redhat.com>
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     Paul Moore <paul@paul-moore.com>, davem@davemloft.net
Cc:     selinux@vger.kernel.org, netdev@vger.kernel.org,
        Tom Deseyn <tdeseyn@redhat.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date:   Thu, 09 May 2019 10:40:40 +0200
In-Reply-To: <CAHC9VhTs+Q4oAiMGkK9QZBJ9G4yY28WFJkc2jjp05DEW1OAhYw@mail.gmail.com>
References: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
         <36e13dc4-be40-d1f6-0be5-32cd4fc38f6e@tycho.nsa.gov>
         <83b4adb4-9d8f-848f-d1cc-a4a1f30cee51@tycho.nsa.gov>
         <20190508182737.GK10916@localhost.localdomain>
         <0957f30f-07b8-5e2f-ac71-615f511a5eea@tycho.nsa.gov>
         <CAHC9VhTs+Q4oAiMGkK9QZBJ9G4yY28WFJkc2jjp05DEW1OAhYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 09 May 2019 08:40:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-05-08 at 17:17 -0400, Paul Moore wrote:
> On Wed, May 8, 2019 at 2:55 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > On 5/8/19 2:27 PM, Marcelo Ricardo Leitner wrote:
> > > On Wed, May 08, 2019 at 02:13:17PM -0400, Stephen Smalley wrote:
> > > > On 5/8/19 2:12 PM, Stephen Smalley wrote:
> > > > > On 5/8/19 9:32 AM, Paolo Abeni wrote:
> > > > > > calling connect(AF_UNSPEC) on an already connected TCP socket is an
> > > > > > established way to disconnect() such socket. After commit 68741a8adab9
> > > > > > ("selinux: Fix ltp test connect-syscall failure") it no longer works
> > > > > > and, in the above scenario connect() fails with EAFNOSUPPORT.
> > > > > > 
> > > > > > Fix the above falling back to the generic/old code when the address
> > > > > > family
> > > > > > is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
> > > > > > specific constraints.
> > > > > > 
> > > > > > Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
> > > > > > Reported-by: Tom Deseyn <tdeseyn@redhat.com>
> > > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > ---
> > > > > >    security/selinux/hooks.c | 8 ++++----
> > > > > >    1 file changed, 4 insertions(+), 4 deletions(-)
> > > > > > 
> > > > > > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > > > > > index c61787b15f27..d82b87c16b0a 100644
> > > > > > --- a/security/selinux/hooks.c
> > > > > > +++ b/security/selinux/hooks.c
> > > > > > @@ -4649,7 +4649,7 @@ static int
> > > > > > selinux_socket_connect_helper(struct socket *sock,
> > > > > >            struct lsm_network_audit net = {0,};
> > > > > >            struct sockaddr_in *addr4 = NULL;
> > > > > >            struct sockaddr_in6 *addr6 = NULL;
> > > > > > -        unsigned short snum;
> > > > > > +        unsigned short snum = 0;
> > > > > >            u32 sid, perm;
> > > > > >            /* sctp_connectx(3) calls via selinux_sctp_bind_connect()
> > > > > > @@ -4674,12 +4674,12 @@ static int
> > > > > > selinux_socket_connect_helper(struct socket *sock,
> > > > > >                break;
> > > > > >            default:
> > > > > >                /* Note that SCTP services expect -EINVAL, whereas
> > > > > > -             * others expect -EAFNOSUPPORT.
> > > > > > +             * others must handle this at the protocol level:
> > > > > > +             * connect(AF_UNSPEC) on a connected socket is
> > > > > > +             * a documented way disconnect the socket.
> > > > > >                 */
> > > > > >                if (sksec->sclass == SECCLASS_SCTP_SOCKET)
> > > > > >                    return -EINVAL;
> > > > > > -            else
> > > > > > -                return -EAFNOSUPPORT;
> > > > > 
> > > > > I think we need to return 0 here.  Otherwise, we'll fall through with an
> > > > > uninitialized snum, triggering a random/bogus permission check.
> > > > 
> > > > Sorry, I see that you initialize snum above.  Nonetheless, I think the
> > > > correct behavior here is to skip the check since this is a disconnect, not a
> > > > connect.
> > > 
> > > Skipping the check would make it less controllable. So should it
> > > somehow re-use shutdown() stuff? It gets very confusing, and after
> > > all, it still is, in essence, a connect() syscall.
> > 
> > The function checks CONNECT permission on entry, before reaching this
> > point.  This logic is only in preparation for a further check
> > (NAME_CONNECT) on the port.  In this case, there is no further check to
> > perform and we can just return.
> 
> I agree with Stephen, in the connect(AF_UNSPEC) case the right thing
> to do is to simply return with no error.

The 'default:' case is catching any address family other than
INET{4,6}, but I guess you argument still applies - selinux should not
do name check for unknown protocols ?!?

> I would also suggest that since this patch only touches the SELinux
> code it really should go in via the SELinux tree and not netdev; this
> will help avoid merge conflicts in the linux-next tree and during the
> merge window.  I think the right thing to do at this point is to
> create a revert patch (or have DaveM do it, I'm not sure what he
> prefers in situations like this) for this commit, make the adjustments
> that Stephen mentioned and submit them for the SELinux tree.

Sorry, my fault, I sent the email to both MLs for more awareness, I
should have used a different subject prefix.

@DaveM: if it's ok for you, I'll send a revert for this on netdev and
I'll send a v2 via the selinux ML, please let me know!

Thank you,

Paolo

