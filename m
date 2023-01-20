Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDC6674910
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 02:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjATBxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 20:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjATBxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 20:53:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C22174961;
        Thu, 19 Jan 2023 17:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB92361DD2;
        Fri, 20 Jan 2023 01:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AFCC433D2;
        Fri, 20 Jan 2023 01:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674179584;
        bh=lehARF5Jyz6pCpRqHY5HtN/8xxJ/fvtM+SkhBiquzMM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mB+m4ib7w11UOsmsVZi/YDeUWoLb3WLKtV6hWIAoxxC+/XeNKrny5pT6tdFleINO9
         W/epE4w3W0Jo+fH9vBg/rZyjlJ8OAszIxVI+aZCeIA5WecHVtTVuoTAldgmQ/zOByY
         bvcmC0+06dqI/nucy6HuRE0zPIgzWtZdRgF0h3G+Vwt600yoYq3Trbqz5P2p3SLQwp
         vCVZAT+OnYZ9+ZXtdfv1y9XfumTpL2s1hE/Q8+o/hQEYByBc9CPkq7C3URF65rua+V
         y92K/6royO3C4yDnq1jM7ts++uGqo7y0qYcZTwC8q4rIR3XfTZVMM8Fvc/vCHcKBUe
         ZPWC+SaIVTSuQ==
Date:   Thu, 19 Jan 2023 17:53:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v3 3/8] net: add basic C code generators for
 Netlink
Message-ID: <20230119175302.3a592798@kernel.org>
In-Reply-To: <ddcea8b3cb8c2d218a2747a1e2f566dbaaee8f01.camel@sipsolutions.net>
References: <20230119003613.111778-1-kuba@kernel.org>
        <20230119003613.111778-4-kuba@kernel.org>
        <ddcea8b3cb8c2d218a2747a1e2f566dbaaee8f01.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan 2023 21:53:12 +0100 Johannes Berg wrote:
> > +    def _attr_policy(self, policy):
> > +        mem = '{ '
> > +        if len(self.checks) == 1 and 'min-len' in self.checks:
> > +            mem += '.len = ' + str(self.checks['min-len'])  
> 
> Why does the len(self.checks) matter?

Trying to throw an exception if someone starts using checks I haven't
gotten to implementing yet.

> > +    def free_needs_iter(self):
> > +        return 'type' not in self.attr or self.attr['type'] == 'nest'
> > +
> > +    def free(self, ri, var, ref):
> > +        if 'type' not in self.attr or self.attr['type'] == 'nest':  
> 
> two more places that could use the .get trick
> 
> but it's really up to you. Just that the line like that seems rather
> long to me :-)

Better question is why attr would not have a type :S
Let me leave it be for now, I'll revisit when exercising this code 
in the future.

> > +            if has_ntf:
> > +                cw.p('// --------------- Common notification parsing --------------- //')  
>
> You said you were using /* */ comments now but this is still there.

Ugh, now I'm worried I lost something in a rebase :S

> > +                print_ntf_parse_prototype(parsed, cw)
> > +            cw.nl()
> > +        else:
> > +            cw.p('// Policies')  
>
> and here too, etc.
> 
> Whew. I think I skipped some bits ;-)

Thanks for looking!! :)

> Doesn't look that bad overall, IMHO. :)

I hope we can avoid over-focusing on the python tools :P
I'm no python expert and the code would use a lot of refactoring.
But there's only so many hours in the day and the alternative
seems that it will bit rot in my tree forever :(
