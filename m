Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3BD27F24C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbgI3TDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729556AbgI3TDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:03:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88110C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:03:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNhNd-00DzVo-Q9; Wed, 30 Sep 2020 21:03:09 +0200
Message-ID: <563a2334a42cc5f33089c2bff172d92e118575ea.camel@sipsolutions.net>
Subject: Re: Genetlink per cmd policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Date:   Wed, 30 Sep 2020 21:03:08 +0200
In-Reply-To: <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
         <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
         <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
         <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 12:01 -0700, Jakub Kicinski wrote:
> On Wed, 30 Sep 2020 20:36:24 +0200 Johannes Berg wrote:
> > On Wed, 2020-09-30 at 09:44 -0700, Jakub Kicinski wrote:
> > 
> > > I started with a get_policy() callback, but I didn't like it much.
> > > Static data is much more pleasant for a client of the API IMHO.  
> > 
> > Yeah, true.
> > 
> > > What do you think about "ops light"? Insufficiently flexible?  
> > 
> > TBH, I'm not really sure how you'd do it?
> 
> There are very few users who actually access ops, I was thinking that
> callers to genl_get_cmd() should declare a full struct genl_ops on the
> stack (or in some context, not sure yet), and then genl_get_cmd() will
> fill it in.
> 
> If family has full ops it will do a memcpy(); if the ops are "light" it
> can assign the right pointers.
> 
> Plus it can propagate the policy and maxattr from family if needed in
> both cases.

Oh, so you were thinking you'd have to sort of decide on the *family*
level whether you want "light" or "heavy" ops?

Hm. I guess you could even have both?

	struct genl_ops *ops;
	struct genl_ops_ext *extops;

and then search both arrays, no need for memcpy/pointer assignment?

johannes

