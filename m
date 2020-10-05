Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8286283FA0
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgJET2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgJET2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:28:22 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBFCC0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 12:28:22 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPW9h-00HOQo-0A; Mon, 05 Oct 2020 21:28:17 +0200
Message-ID: <d5824faed8a748dc2f73dab16f914377cf972bc4.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 6/6] ethtool: specify which header flags are
 supported per command
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
Date:   Mon, 05 Oct 2020 21:28:16 +0200
In-Reply-To: <20201005122544.70aad7f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-7-kuba@kernel.org>
         <1dc47668cc015c5a1bff10072e64e55a3436cbb7.camel@sipsolutions.net>
         <20201005122544.70aad7f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 12:25 -0700, Jakub Kicinski wrote:
> On Mon, 05 Oct 2020 20:58:57 +0200 Johannes Berg wrote:
> > On Mon, 2020-10-05 at 08:57 -0700, Jakub Kicinski wrote:
> > > @@ -47,19 +61,16 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
> > >  		NL_SET_ERR_MSG(extack, "request header missing");
> > >  		return -EINVAL;
> > >  	}
> > > +	/* Use most permissive header policy here, ops should specify their
> > > +	 * actual header policy via NLA_POLICY_NESTED(), and the real
> > > +	 * validation will happen in genetlink code.
> > > +	 */
> > >  	ret = nla_parse_nested(tb, ETHTOOL_A_HEADER_MAX, header,
> > > -			       ethnl_header_policy, extack);
> > > +			       ethnl_header_policy_stats, extack);  
> > 
> > Would it make sense to just remove the validation here? It's already
> > done, so it just costs extra cycles and can't really fail, and if there
> > are more diverse policies in the future this might also very quickly get
> > out of hand?
> 
> I was slightly worried I missed a command and need last line of defence,

Ah. I was just about to suggest to put it into the family policy/maxattr
but that won't work of course since this is nested.

But actually what you _could_ put there is a dummy policy (non-NULL
pointer) with a maxattr of 0, and then all attrs will be completely
rejected for a command where the policy was missed.

Not if you missed the NLA_POLICY_NESTED() link, though.

johannes

