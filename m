Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598185EF855
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbiI2PGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiI2PGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:06:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B5B10BB27
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:06:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDCF0614E2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 15:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B501EC433C1;
        Thu, 29 Sep 2022 15:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664464012;
        bh=YM0FLW/+A8nBma6H+9j4yB3qqYl5G5v2OTbMHdW/xZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iVNqgM8EwnJleUmAY1y6EvbORSfJ1wcpI7/6CiPzrflI0zekg47NCs5whfgfAaJJY
         ifdp6G0hNDCLc/i3S+sSBJW/0IUC1P/LlyP3w652ccgWFJXBAi/7XrUTr2r3dguWgj
         hLqceZqCTbcaArSYzE5k5U5YQi6md0CQjc3NQB3DQGPWEHVgvysolbMqpP3JCfSfHD
         z1/r8V1TdPDe5JTpunTPxwj6HX7XziujbR1gQ7YtWLF0oBLLHmQRLqG1b8r1PI3BFP
         4/q9KiL9QTgUbBknL6tH++z3McXaq3iWNt+AmRA+FKe8+5o6ljYze+81vGZJ9wf0K3
         +aRSO6e3AuhTg==
Date:   Thu, 29 Sep 2022 08:06:50 -0700
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
Message-ID: <20220929080650.370b5977@kernel.org>
In-Reply-To: <YzWxbrXkvsjnl50R@salvia>
References: <20220929142809.1167546-1-kuba@kernel.org>
        <YzWxbrXkvsjnl50R@salvia>
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

On Thu, 29 Sep 2022 16:53:34 +0200 Pablo Neira Ayuso wrote:
> > +	flags = nlh->nlmsg_flags;
> > +	if ((flags & NLM_F_DUMP) == NLM_F_DUMP) /* DUMP is 2 bits */
> > +		flags &= ~NLM_F_DUMP;  
> 
> no bail out for incorrectly set NLM_F_DUMP flag?

Incorrectly? Special handling is because we want to make sure both bits
are set for DUMP, if they are not we'll not clear them here and the
condition below will fire. Or do you mean some other incorrectness?

> > +	if (flags & ~(NLM_F_REQUEST | NLM_F_ACK | NLM_F_ECHO)) {
> > +		NL_SET_ERR_MSG(extack,
> > +			       "ambiguous or reserved bits set in nlmsg_flags");
> > +		return -EINVAL;  
> 
> While adding new netlink flags is a very rare event, this is going to
> make it harder to add new flags to be added in the future, else
> userspace has to probe for supported flags first.

The only difference in terms of probing is whether the unsupported
case silently ignores the flag or reports a clear error. So I think
I'm only making things better there.

> Regarding error reporting - even if error reporting in netlink is also
> not consistent accross subsystems - I think EINVAL should be used for
> malformed netlink messages, eg. a message that is missing a mandatory
> attribute.
> 
> EOPNOTSUPP might be a better pick?

All current "reserved bits" checking I know of return -EINVAL 
(the strict checks in the ip stack and policy based checks).
