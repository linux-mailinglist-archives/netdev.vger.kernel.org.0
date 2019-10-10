Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AB8D31E3
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 22:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfJJUVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 16:21:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:59574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726533AbfJJUVb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 16:21:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CE76AC6E;
        Thu, 10 Oct 2019 20:21:29 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id CAA94E378C; Thu, 10 Oct 2019 22:21:28 +0200 (CEST)
Date:   Thu, 10 Oct 2019 22:21:28 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] genetlink: do not parse attributes for
 families with zero maxattr
Message-ID: <20191010202128.GJ22163@unicorn.suse.cz>
References: <20191010103402.36408E378C@unicorn.suse.cz>
 <20191010102102.3bc8515d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010102102.3bc8515d@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 10:21:02AM -0700, Jakub Kicinski wrote:
> On Thu, 10 Oct 2019 12:34:02 +0200 (CEST), Michal Kubecek wrote:
> > Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
> > to a separate function") moved attribute buffer allocation and attribute
> > parsing from genl_family_rcv_msg_doit() into a separate function
> > genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
> > __nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
> > parsing). The parser error is ignored and does not propagate out of
> > genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
> > type") is set in extack and if further processing generates no error or
> > warning, it stays there and is interpreted as a warning by userspace.
> > 
> > Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
> > the call of genl_family_rcv_msg_doit() if family->maxattr is zero. Do the
> > same also in genl_family_rcv_msg_doit().
> > 
> > Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
> > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> > ---
> >  net/netlink/genetlink.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> > index ecc2bd3e73e4..1f14e55ad3ad 100644
> > --- a/net/netlink/genetlink.c
> > +++ b/net/netlink/genetlink.c
> > @@ -639,21 +639,23 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
> >  				    const struct genl_ops *ops,
> >  				    int hdrlen, struct net *net)
> >  {
> > -	struct nlattr **attrbuf;
> > +	struct nlattr **attrbuf = NULL;
> >  	struct genl_info info;
> >  	int err;
> >  
> >  	if (!ops->doit)
> >  		return -EOPNOTSUPP;
> >  
> > +	if (!family->maxattr)
> > +		goto no_attrs;
> >  	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
> >  						  ops, hdrlen,
> >  						  GENL_DONT_VALIDATE_STRICT,
> > -						  family->maxattr &&
> >  						  family->parallel_ops);
> >  	if (IS_ERR(attrbuf))
> >  		return PTR_ERR(attrbuf);
> >  
> > +no_attrs:
> 
> The use of a goto statement as a replacement for an if is making me
> uncomfortable. 

I used instead of a simple if because (1) it's what the dumpit code does
and (2) the function call arguments are already quite pressed to the
80-character barrier.
 
> Looks like both callers of genl_family_rcv_msg_attrs_parse() jump
> around it if !family->maxattr and then check the result with IS_ERR().
> 
> Would it not make more sense to have genl_family_rcv_msg_attrs_parse()
> return NULL if !family->maxattr?

This sounds like a good solution. I'll check again in the morning and
send v3.

Michal
