Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDFA119E1
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfEBNOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:14:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:38550 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbfEBNOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 09:14:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1BE5AEFD;
        Thu,  2 May 2019 13:14:16 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4FEBFE0117; Thu,  2 May 2019 15:14:16 +0200 (CEST)
Date:   Thu, 2 May 2019 15:14:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] netlink: add validation of NLA_F_NESTED flag
Message-ID: <20190502131416.GE21672@unicorn.suse.cz>
References: <cover.1556798793.git.mkubecek@suse.cz>
 <75a0887b3eb70005c272685d8ef9a712f37d7a54.1556798793.git.mkubecek@suse.cz>
 <3e8291cb2491e9a1830afdb903ed2c52e9f7475c.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8291cb2491e9a1830afdb903ed2c52e9f7475c.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 02:54:56PM +0200, Johannes Berg wrote:
> On Thu, 2019-05-02 at 12:48 +0000, Michal Kubecek wrote:
> > Add new validation flag NL_VALIDATE_NESTED which adds three consistency
> > checks of NLA_F_NESTED_FLAG:
> > 
> >   - the flag is set on attributes with NLA_NESTED{,_ARRAY} policy
> >   - the flag is not set on attributes with other policies except NLA_UNSPEC
> >   - the flag is set on attribute passed to nla_parse_nested()
> 
> Looks good to me!
> 
> > @@ -415,7 +418,8 @@ enum netlink_validation {
> >  #define NL_VALIDATE_STRICT (NL_VALIDATE_TRAILING |\
> >  			    NL_VALIDATE_MAXTYPE |\
> >  			    NL_VALIDATE_UNSPEC |\
> > -			    NL_VALIDATE_STRICT_ATTRS)
> > +			    NL_VALIDATE_STRICT_ATTRS |\
> > +			    NL_VALIDATE_NESTED)
> 
> This is fine _right now_, but in general we cannot keep adding here
> after the next release :-)

Right, that's why I would like to get this into the same cycle as your
series.

> >  int netlink_rcv_skb(struct sk_buff *skb,
> >  		    int (*cb)(struct sk_buff *, struct nlmsghdr *,
> > @@ -1132,6 +1136,10 @@ static inline int nla_parse_nested(struct nlattr *tb[], int maxtype,
> >  				   const struct nla_policy *policy,
> >  				   struct netlink_ext_ack *extack)
> >  {
> > +	if (!(nla->nla_type & NLA_F_NESTED)) {
> > +		NL_SET_ERR_MSG_ATTR(extack, nla, "nested attribute expected");
> 
> Maybe reword that to say "NLA_F_NESTED is missing" or so? The "nested
> attribute expected" could result in a lot of headscratching (without
> looking at the code) because it looks nested if you do nla_nest_start()
> etc.

How about "NLA_F_NESTED is missing" and "NLA_F_NESTED not expected"?

> 
> > +		return -EINVAL;
> > +	}
> >  	return __nla_parse(tb, maxtype, nla_data(nla), nla_len(nla), policy,
> >  			   NL_VALIDATE_STRICT, extack);
> 
> I'd probably put a blank line there but ymmv.

OK

> >  }
> > diff --git a/lib/nlattr.c b/lib/nlattr.c
> > index adc919b32bf9..92da65cb6637 100644
> > --- a/lib/nlattr.c
> > +++ b/lib/nlattr.c
> > @@ -184,6 +184,21 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
> >  		}
> >  	}
> >  
> > +	if (validate & NL_VALIDATE_NESTED) {
> > +		if ((pt->type == NLA_NESTED || pt->type == NLA_NESTED_ARRAY) &&
> > +		    !(nla->nla_type & NLA_F_NESTED)) {
> > +			NL_SET_ERR_MSG_ATTR(extack, nla,
> > +					    "nested attribute expected");
> > +			return -EINVAL;
> > +		}
> > +		if (pt->type != NLA_NESTED && pt->type != NLA_NESTED_ARRAY &&
> > +		    pt->type != NLA_UNSPEC && (nla->nla_type & NLA_F_NESTED)) {
> > +			NL_SET_ERR_MSG_ATTR(extack, nla,
> > +					    "nested attribute not expected");
> > +			return -EINVAL;
> 
> Same comment here wrt. the messages, I think they should more explicitly
> refer to the flag.
> 
> johannes
> 
> (PS: if you CC me on this address I generally can respond quicker)

I'll try to keep that in mind.

Michal
