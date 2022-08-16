Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CE3595FAE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiHPPzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbiHPPz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:55:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B05656A;
        Tue, 16 Aug 2022 08:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 493C4B81A84;
        Tue, 16 Aug 2022 15:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5B4C433C1;
        Tue, 16 Aug 2022 15:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660665198;
        bh=hlkYJEYHyg2S6iWZ8XPY2X8XBAGgCaNjt7hhi5OwEtg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aZLNZDSVQi9fGX8AJl/etW3qEk8e5X77R7oncvw4Dy7CWKD7aeUpTcZQcKd5ncAOl
         eWfB7+/HyOY/BaM2+DnFUIW8XkvjcF4cWD/5AW+YTqH5d2LTN24KX/14qbsUOkXDrA
         R9owL/kjWlqRp8QK8JLbb8NL5NNnabyA2EgpAdjNuhLl8DLdDXK7i6bFVJr1BGQVpE
         qpMJLvqTMF1k93dHQXniHrm0a8ILERBZDE7+vBbwt2tpKTL3Y/zl6FpRjIzEnVwOel
         5YCpvXvsblhlVOs+nq8O+Fz5aG3z0Wl6NK3woRe8klg2R9zQ8cPcn+N7+6rYeBVmeg
         FdRLYUVCnxiwQ==
Date:   Tue, 16 Aug 2022 08:53:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 2/4] ynl: add the schema for the schemas
Message-ID: <20220816085316.65fda789@kernel.org>
In-Reply-To: <7241755af778426a2241cacd51119ba8dbd7c136.camel@sipsolutions.net>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-3-kuba@kernel.org>
        <6b972ef603ff2bc3a3f3e489aa6638f6246c1e48.camel@sipsolutions.net>
        <20220815174742.32b3611e@kernel.org>
        <7241755af778426a2241cacd51119ba8dbd7c136.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 09:21:27 +0200 Johannes Berg wrote:
> On Mon, 2022-08-15 at 17:47 -0700, Jakub Kicinski wrote:
> > On Mon, 15 Aug 2022 22:09:11 +0200 Johannes Berg wrote:  
> > It's the incredibly inventive nesting format used in genetlink policy
> > dumps where the type of the sub-attr(s there are actually two levels)
> > carry a value (index of the policy and attribute) rather than denoting
> > a type :S :S :S  
> 
> Hmm, OK, in the policy dump (not specific to genetlink, btw, can be used
> for any policy, but is only generically hooked up for genetlink), we
> have
> 
> [policy_idx] = {
>   [attr_idx] = {
>     [NL_POLICY_TYPE_ATTR_...] = ...
>   }
> }
> 
> Is that what you mean?

Yes.

> I guess I never really thought about this format much from a description
> POV, no need to have a policy since you simply iterate (for_each_attr)
> when reading it, and don't really need to care about the attribute
> index, at least.
> 
> For future reference, how would you suggest to have done this instead?

My guess was that some of the wrapping was for ease of canceling here
(cancel is used both on skip and on error). What I think we should push
for is multi-attr, so the same attribute happens multiple times.

[msg]
 [ATTR1]
 [ATTR2] // elem 1
   [SubATTR1]
   [SubATTR2]
 [ATTR2] // elem 2
   [SubATTR1]
   [SubATTR2]
 [ATTR2] // elem 3
   [SubATTR1]
   [SubATTR2]
 [ATTR3]
 [ATTR4]

Instead of wrapping into an array and then elements.

As Michal pointed out a number of times - the wrapping ends up limiting 
the size of the array to U16_MAX, and I have a suspicion that most of
wrapping is done because we tend to parse into a pointer array, which
makes multi-attr a little tricky. But we shouldn't let one parsing
technique in a relatively uncommon language like C dictate the format :)

> > Slightly guessing but I think I know what you mean -> the value of the
> > array is a nest with index as the type and then inside that is the
> > entry of the array with its attributes <- and that's where the space is
> > applied, not at the first nest level?  
> 
> Right.
> 
> > Right, I should probably put that in the docs rather than the schema,
> > array-nests are expected to strip one layer of nesting and put the
> > value taken from the type (:D) into an @idx member of the struct
> > representing the values of the array. Or at least that's what I do in
> > the C codegen.  
> 
> Well mostly you're not supposed to care about the 'value'/'type', I
> guess?

Fair, I wasn't sure if it's ever used, but I figured if I have to parse
it out why not save the values. Same for array-next indexes.

I'm leaning heavily towards defining a subset of the YAML spec as 
"the way to do things in new family" which will allow only one form 
of arrays.
