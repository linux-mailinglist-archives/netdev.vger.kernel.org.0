Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578ED60503E
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJSTOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJSTOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:14:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBAA27CDC
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7216E619B2
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDB0C433D6;
        Wed, 19 Oct 2022 19:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666206864;
        bh=vyLSrbWFGfP1azvJfE+ouYKboVLUzi3ZTzDPKdsy8MQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XA8e3nC2De0vREN+DmzUm+dLcPFXDOzv25yV2KryP8TG0S6vC4TPwGUDK7MyhkfqP
         R+1L9ZXavvaAGFZ6Z1GarVfquC0szNrm1F3hg3tNw+evnVH5drghIzoofAAS4He47K
         mqhwsOsJSIOxp4498IpGOJd5ndE7qPjYis3hDy4OSW0KBiNBXq+FRM2kfSBLTp6QXv
         dNF7XP1cEnG5EFR+u0xk/ujv7GaEvSARCk4oYCzrtgoOPwPG0KmyNjZk96naYUWxyL
         6QPQLXIRMU9juEUTnSMJibb3dUOB8xJN5mrAFs5ljdcBG1P9kHnMYavFw4oP2U6AIf
         ifCzHpfoEszYQ==
Date:   Wed, 19 Oct 2022 12:14:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        jiri@nvidia.com, nhorman@tuxdriver.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org
Subject: Re: [PATCH net-next 03/13] genetlink: introduce split op
 representation
Message-ID: <20221019121422.799eee78@kernel.org>
In-Reply-To: <93e9137fb80f63cd13fa226bcca3007c473a74d4.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-4-kuba@kernel.org>
        <93e9137fb80f63cd13fa226bcca3007c473a74d4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 09:59:24 +0200 Johannes Berg wrote:
> On Tue, 2022-10-18 at 16:07 -0700, Jakub Kicinski wrote:
> > + * Do callbacks:
> > + * @pre_doit: called before an operation's @doit callback, it may
> > + *	do additional, common, filtering and return an error
> > + * @doit: standard command callback
> > + * @post_doit: called after an operation's @doit callback, it may
> > + *	undo operations done by pre_doit, for example release locks  
> 
> Is that really worth it? I mean, if you need pre/post for a *specific*
> op, you can just roll that into it.
> 
> Maybe the use case would be something like "groups" where some commands
> need one set of pre/post, and some other commands need another set, and

Exactly - groups of ops. Different groups of ops need different
handling. But as I think I mentioned in the commit messages the 
separate policies are the real reason, this is just done "while 
at it".

> then it's still simpler to do as pre/post rather than calling them
> inside the doit()?

A little bit, it simplifies the unwind in case you need to take some
references and some locks you save dealing with success path vs error 
path handling in the doit.

> (and you also have space for the pointers given the dump part of the
> union, so ...)

Yes, we have the space... I think I lost your thread of thought..
Do you want to define more info for each group than just the pre/post?

> > +static void
> > +genl_cmd_full_to_split(struct genl_split_ops *op,
> > +		       const struct genl_family *family,
> > +		       const struct genl_ops *full, u8 flags)
> > +{  
> 
> [...]
> 
> 
> > +	op->flags		|= flags;  
> 
> why |= ?

op->flags should already have all the existing flags (i.e. ADMIN_PERM)
from the op, I'm adding the DO/DUMP to them.

> > @@ -776,8 +821,9 @@ static int genl_family_rcv_msg(const struct genl_family *family,
> >  {
> >  	struct net *net = sock_net(skb->sk);
> >  	struct genlmsghdr *hdr = nlmsg_data(nlh);
> > -	struct genl_ops op;
> > +	struct genl_split_ops op;  
> 
> it's not even initialized?
> 
> > +	flags = (nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP ?
> > +		GENL_CMD_CAP_DUMP : GENL_CMD_CAP_DO;
> > +	if (genl_get_cmd_split(hdr->cmd, flags, family, &op))
> >  		return -EOPNOTSUPP;  
> 
> before being used
> 
> or am I misreading something?

It's used as an output argument here, so that's what initializes it.
genl_get_cmd* should always init the split command because in policy
dumping we don't care about the errors, we just want the structure
to be zeroed if do/dump is not implemented, and we'll skip accordingly.
Wiping the 40B just to write all the fields felt... wrong. 
Let KASAN catch us if we fail to init something.
