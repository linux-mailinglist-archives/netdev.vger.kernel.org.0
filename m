Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A582C5EF994
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbiI2PzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbiI2PzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:55:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A6B2CDEF
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D857461A09
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 15:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A97C433C1;
        Thu, 29 Sep 2022 15:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664466914;
        bh=18Q/LLwdBDVwTN/W4r+lLuFHmxN9OSNCykkGRIixtQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oYEfiXc4BYZ8fHmLfpFpaO6eqUCLIldeI0YSy3DaAHcKzG8ct69eF5EsctDUDs1Pj
         OxUKEnfWTBY40ZNaACfRpjpGh3+vwCSjDuLCHGx3v/7LjyUKJr77F6Dcy4Z2wUNDu4
         MccZ73Po0G0jw2ex+TolYC556bdBONS8mRdMPpnvDn4D4nRa/5dgpYrX9vVEgZvSS1
         snqpsusJLtsOQOTy0T1hbfbkJHgtoThwC0xXA/3cwEqoba2MycvlkngaEzukxCjbvs
         MmK9I7uEufYRf8Kinzeber2Qnzr4GSK0V/YzlsLtKAG/OmmDCmoaIB9ouqFxg31VIm
         tNMum4VHdDwBw==
Date:   Thu, 29 Sep 2022 08:55:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net-next RESEND] genetlink: reject use of nlmsg_flags
 for new commands
Message-ID: <20220929085512.17be934f@kernel.org>
In-Reply-To: <YzW+ml81tM9Rlt1i@salvia>
References: <20220929142809.1167546-1-kuba@kernel.org>
        <YzWxbrXkvsjnl50R@salvia>
        <20220929080650.370b5977@kernel.org>
        <YzW+ml81tM9Rlt1i@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 17:49:46 +0200 Pablo Neira Ayuso wrote:
> On Thu, Sep 29, 2022 at 08:06:50AM -0700, Jakub Kicinski wrote:
> > > no bail out for incorrectly set NLM_F_DUMP flag?  
> > 
> > Incorrectly? Special handling is because we want to make sure both bits
> > are set for DUMP, if they are not we'll not clear them here and the
> > condition below will fire. Or do you mean some other incorrectness?  
> 
> I have seen software in the past setting only one of the bits in the
> NLM_F_DUMP bitmask to request a dump. I agree that userspace software
> relying in broken semantics and that software should be fixed. What I
> am discussing if silently clearing the 2 bits is the best approach.

I don't think it is and I don't think I silently clear both.
Here's the code again:

+	flags = nlh->nlmsg_flags;
+	if ((flags & NLM_F_DUMP) == NLM_F_DUMP) /* DUMP is 2 bits */
+		flags &= ~NLM_F_DUMP;
+	if (flags & ~(NLM_F_REQUEST | NLM_F_ACK | NLM_F_ECHO)) {
+		NL_SET_ERR_MSG(extack,
+			       "ambiguous or reserved bits set in nlmsg_flags");
+		return -EINVAL;
+	}
