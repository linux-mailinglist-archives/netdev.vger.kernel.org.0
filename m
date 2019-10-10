Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A344DD2771
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 12:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732821AbfJJKpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 06:45:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:37042 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726230AbfJJKpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 06:45:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84D03AFB1;
        Thu, 10 Oct 2019 10:45:45 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 32858E378C; Thu, 10 Oct 2019 12:45:45 +0200 (CEST)
Date:   Thu, 10 Oct 2019 12:45:45 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] genetlink: do not parse attributes for families
 with zero maxattr
Message-ID: <20191010104545.GB22163@unicorn.suse.cz>
References: <20191009164432.AD5D1E3785@unicorn.suse.cz>
 <20191010093153.GG2223@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010093153.GG2223@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 11:31:53AM +0200, Jiri Pirko wrote:
> Wed, Oct 09, 2019 at 06:44:32PM CEST, mkubecek@suse.cz wrote:
> >Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
> >to a separate function") moved attribute buffer allocation and attribute
> >parsing from genl_family_rcv_msg_doit() into a separate function
> >genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
> >__nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
> >parsing). The parser error is ignored and does not propagate out of
> >genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
> >type") is set in extack and if further processing generates no error or
> >warning, it stays there and is interpreted as a warning by userspace.
> >
> >Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
> >the call of genl_family_rcv_msg_doit() if family->maxattr is zero. Do the
> >same also in genl_family_rcv_msg_doit().
> >
> >Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
> >Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> >---
> > net/netlink/genetlink.c | 6 ++++--
> > 1 file changed, 4 insertions(+), 2 deletions(-)
> >
> >diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> >index ecc2bd3e73e4..c4bf8830eedf 100644
> >--- a/net/netlink/genetlink.c
> >+++ b/net/netlink/genetlink.c
> >@@ -639,21 +639,23 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
> > 				    const struct genl_ops *ops,
> > 				    int hdrlen, struct net *net)
> > {
> >-	struct nlattr **attrbuf;
> >+	struct nlattr **attrbuf = NULL;
> > 	struct genl_info info;
> > 	int err;
> > 
> > 	if (!ops->doit)
> > 		return -EOPNOTSUPP;
> > 
> >+	if (!family->maxattr)
> >+		goto no_attrs;
> > 	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
> > 						  ops, hdrlen,
> > 						  GENL_DONT_VALIDATE_STRICT,
> >-						  family->maxattr &&
> > 						  family->parallel_ops);
> 
> Please also adjust genl_family_rcv_msg_attrs_free() call arg
> below in this function in the similar way.

Sent v2.

Michal
