Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8301196A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 14:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfEBMzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 08:55:02 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55590 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfEBMzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 08:55:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMBEn-000103-Sz; Thu, 02 May 2019 14:54:58 +0200
Message-ID: <3e8291cb2491e9a1830afdb903ed2c52e9f7475c.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 3/3] netlink: add validation of NLA_F_NESTED
 flag
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 02 May 2019 14:54:56 +0200
In-Reply-To: <75a0887b3eb70005c272685d8ef9a712f37d7a54.1556798793.git.mkubecek@suse.cz>
References: <cover.1556798793.git.mkubecek@suse.cz>
         <75a0887b3eb70005c272685d8ef9a712f37d7a54.1556798793.git.mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-05-02 at 12:48 +0000, Michal Kubecek wrote:
> Add new validation flag NL_VALIDATE_NESTED which adds three consistency
> checks of NLA_F_NESTED_FLAG:
> 
>   - the flag is set on attributes with NLA_NESTED{,_ARRAY} policy
>   - the flag is not set on attributes with other policies except NLA_UNSPEC
>   - the flag is set on attribute passed to nla_parse_nested()

Looks good to me!

> @@ -415,7 +418,8 @@ enum netlink_validation {
>  #define NL_VALIDATE_STRICT (NL_VALIDATE_TRAILING |\
>  			    NL_VALIDATE_MAXTYPE |\
>  			    NL_VALIDATE_UNSPEC |\
> -			    NL_VALIDATE_STRICT_ATTRS)
> +			    NL_VALIDATE_STRICT_ATTRS |\
> +			    NL_VALIDATE_NESTED)

This is fine _right now_, but in general we cannot keep adding here
after the next release :-)

>  int netlink_rcv_skb(struct sk_buff *skb,
>  		    int (*cb)(struct sk_buff *, struct nlmsghdr *,
> @@ -1132,6 +1136,10 @@ static inline int nla_parse_nested(struct nlattr *tb[], int maxtype,
>  				   const struct nla_policy *policy,
>  				   struct netlink_ext_ack *extack)
>  {
> +	if (!(nla->nla_type & NLA_F_NESTED)) {
> +		NL_SET_ERR_MSG_ATTR(extack, nla, "nested attribute expected");

Maybe reword that to say "NLA_F_NESTED is missing" or so? The "nested
attribute expected" could result in a lot of headscratching (without
looking at the code) because it looks nested if you do nla_nest_start()
etc.

> +		return -EINVAL;
> +	}
>  	return __nla_parse(tb, maxtype, nla_data(nla), nla_len(nla), policy,
>  			   NL_VALIDATE_STRICT, extack);

I'd probably put a blank line there but ymmv.

>  }
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index adc919b32bf9..92da65cb6637 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -184,6 +184,21 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
>  		}
>  	}
>  
> +	if (validate & NL_VALIDATE_NESTED) {
> +		if ((pt->type == NLA_NESTED || pt->type == NLA_NESTED_ARRAY) &&
> +		    !(nla->nla_type & NLA_F_NESTED)) {
> +			NL_SET_ERR_MSG_ATTR(extack, nla,
> +					    "nested attribute expected");
> +			return -EINVAL;
> +		}
> +		if (pt->type != NLA_NESTED && pt->type != NLA_NESTED_ARRAY &&
> +		    pt->type != NLA_UNSPEC && (nla->nla_type & NLA_F_NESTED)) {
> +			NL_SET_ERR_MSG_ATTR(extack, nla,
> +					    "nested attribute not expected");
> +			return -EINVAL;

Same comment here wrt. the messages, I think they should more explicitly
refer to the flag.

johannes

(PS: if you CC me on this address I generally can respond quicker)

