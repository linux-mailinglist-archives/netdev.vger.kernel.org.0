Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B56F377903
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhEIW04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhEIW04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:26:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91037C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 15:25:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lfrrx-0003oS-HB; Mon, 10 May 2021 00:25:49 +0200
Date:   Mon, 10 May 2021 00:25:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] mptcp: avoid uninitialised errno usage
Message-ID: <20210509222549.GE4038@breakpoint.cc>
References: <20210503103631.30694-1-fw@strlen.de>
 <b8d9cc70-7667-d2b3-50b6-0ef0ce041735@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8d9cc70-7667-d2b3-50b6-0ef0ce041735@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:
> On 5/3/21 4:36 AM, Florian Westphal wrote:
> > The function called *might* set errno based on errno value in NLMSG_ERROR
> > message, but in case no such message exists errno is left alone.
> > 
> > This may cause ip to fail with
> >     "can't subscribe to mptcp events: Success"
> > 
> > on kernels that support mptcp but lack event support (all kernels <= 5.11).
> > 
> > Set errno to a meaningful value.  This will then still exit with the
> > more specific 'permission denied' or some such when called by process
> > that lacks CAP_NET_ADMIN on 5.12 and later.
> > 
> > Fixes: ff619e4fd370 ("mptcp: add support for event monitoring")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  ip/ipmptcp.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
> > index 5f490f0026d9..504b5b2f5329 100644
> > --- a/ip/ipmptcp.c
> > +++ b/ip/ipmptcp.c
> > @@ -491,6 +491,9 @@ out:
> >  
> >  static int mptcp_monitor(void)
> >  {
> > +	/* genl_add_mcast_grp may or may not set errno */
> > +	errno = EOPNOTSUPP;
> > +
> >  	if (genl_add_mcast_grp(&genl_rth, genl_family, MPTCP_PM_EV_GRP_NAME) < 0) {
> >  		perror("can't subscribe to mptcp events");
> >  		return 1;
> > 
> 
> Seems like this should be set in genl_add_mcast_grp vs its caller.

I think setting errno in libraries (libc excluded) is a bad design
choice.  If you still disagree, then I can respin, but it would get a
bit more ugly, e.g. (untested!):

diff --git a/lib/libgenl.c b/lib/libgenl.c
--- a/lib/libgenl.c
+++ b/lib/libgenl.c
@@ -100,20 +100,29 @@ int genl_add_mcast_grp(struct rtnl_handle *grth, __u16 fnum, const char *group)
 
 	addattr16(&req.n, sizeof(req), CTRL_ATTR_FAMILY_ID, fnum);
 
+	/* clear errno to set a default value if needed */
+	errno = 0;
+
 	if (rtnl_talk(grth, &req.n, &answer) < 0) {
 		fprintf(stderr, "Error talking to the kernel\n");
+		if (errno == 0)
+			errno = EOPNOTSUPP;
 		return -2;
 	}
 
 	ghdr = NLMSG_DATA(answer);
 	len = answer->nlmsg_len;
 
-	if (answer->nlmsg_type != GENL_ID_CTRL)
+	if (answer->nlmsg_type != GENL_ID_CTRL) {
+		errno = EINVAL;
 		goto err_free;
+	}
 
 	len -= NLMSG_LENGTH(GENL_HDRLEN);
-	if (len < 0)
+	if (len < 0) {
+		errno = EINVAL;
 		goto err_free;
+	}
 
 	attrs = (struct rtattr *) ((char *) ghdr + GENL_HDRLEN);
 	parse_rtattr(tb, CTRL_ATTR_MAX, attrs, len);
@@ -130,6 +139,10 @@ int genl_add_mcast_grp(struct rtnl_handle *grth, __u16 fnum, const char *group)
 
 err_free:
 	free(answer);
+
+	if (ret < 0 && errno == 0)
+		errno = EOPNOTSUPP;
+
 	return ret;
 }
 
