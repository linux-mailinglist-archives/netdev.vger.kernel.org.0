Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9515BD5F2
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 22:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiISU5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 16:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiISU5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 16:57:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7454A111;
        Mon, 19 Sep 2022 13:57:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC08C61FF5;
        Mon, 19 Sep 2022 20:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0727FC433C1;
        Mon, 19 Sep 2022 20:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663621037;
        bh=weWA6BAS0U8zRF3PdvRfCbqaKyWpn2lOxSLAPqm0fz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CtRlgV+wAen1dhEOJRkgZLIJ79stC2qtbtHiG2Re8y6RlAAXWqoFO7X4kDhht2LNl
         YF6eXA2WeCbgwT1g/JW5CcXCoTTQMwQbNhos5I6TTu7sF8Wog8q2y3VY3paEumC8yy
         gN/MFpVRUrJJ8nCP3oyYBBgx5pGtxVCEPdqIQOgwyE8+5G1onh7/vxa0Mlv1171EDx
         Iydflz4dg5DRyXcmIiNDkEmU5K02DFocjXYJxB3NgNQ47lAiDI0gIUrglsHIDrfIQq
         HnPufmpUUJiIeuyrvmeBHFIJm9q3MDw2qWUzu0Yca6/PRcqP8eGXb0irrclP6CDriI
         /uBA1qpYnkHqw==
Date:   Mon, 19 Sep 2022 13:57:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Chris Clayton <chris2553@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        regressions@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: removing conntrack helper toggle to enable auto-assignment [was
 Re: b118509076b3 (probably) breaks my firewall]
Message-ID: <20220919135715.6057331d@kernel.org>
In-Reply-To: <20220919202310.GA3498@breakpoint.cc>
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
        <20220908191925.GB16543@breakpoint.cc>
        <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
        <20220908214859.GD16543@breakpoint.cc>
        <YxsTMMFoaNSM9gLN@salvia>
        <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
        <YxvwKlE+nyfUjHx8@salvia>
        <20220919124024.0c341af4@kernel.org>
        <20220919202310.GA3498@breakpoint.cc>
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

On Mon, 19 Sep 2022 22:23:10 +0200 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Sat, 10 Sep 2022 04:02:18 +0200 Pablo Neira Ayuso wrote:  
> > > Disagreed, reverting and waiting for one more release cycle will just
> > > postpone the fact that users must adapt their policies, and that they
> > > rely on a configuration which is not secure.  
> > 
> > What are the chances the firewall actually needs the functionality?  
> 
> Unknown, there is no way to tell.

Chris, is your firewall based on some project or a loose bunch of
scripts you wrote?


I had little exposure to NF/conntrack in my career but I was guessing 
for most users one of the two cases:

 - the system is professionally (i.e. someone is paid) maintained, 
   so they should have noticed the warning and fixed in the last 10 yrs

 - the system is a basic SOHO setup which is highly unlikely to see much
   more than TLS or QUIC these days

IOW the intersection of complex traffic and lack of maintenance is
small.

> In old times, it was enough (not tested, just for illustration):
> 
> iptables -A FORWARD -p tcp -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
> 
> and load nf_conntrack_ftp (or whatever).  Module will auto-snoop traffic
> on tcp port 21 for ftp commands, if it finds some, it auto-installs dynamic
> 'expectation entries', so when data connection comes it will hit RELATED rule
> above.
> 
> This stopped working years ago, unless you did set the (now removed)
> knob back to 1.
> 
> Assuming iptables, users would need to do something like
> iptables -t raw -A PREROUTING -p tcp --dport 21 -d $ftpaddr -j CT --helper "ftp"
> 
> to tell that packets/connections on tcp:21 need to be examined for ftp commands.

Thanks for the explainer! 

> > Perhaps we can add the file back but have it do nothing?  
> 
> I think its even worse, users would think that auto-assign is enabled.

Well, users should do the bare minimum of reading kernel logs :(

I think we should do _something_ because we broke so many things 
in this release if we let this rot until its smell reaches Linus -
someone is getting yelled at...

Now, Linus is usually okay with breaking uAPI if there is no other 
way of preventing a security issue. But (a) we break autoload of
all helpers and we only have security issue in one, and (b) not loading
the module doesn't necessarily mean removing the file (at least IMHO).
We have a bunch of dead files in proc already, although perhaps the 
examples I can think of are tunables.
