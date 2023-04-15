Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468FB6E2DFD
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 02:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjDOAoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 20:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjDOAoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 20:44:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F876EB6
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 17:44:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75B1064AF2
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB12C433D2;
        Sat, 15 Apr 2023 00:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681519467;
        bh=u2VHSkU2qFcse3Z9nMaBC6IagJK0l3YIrAuUFgWEtLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fkYWocNKmdV7qxmBMwAKqVVD+F4cvc6z147I4VISsFElR4FBSD0NZbO8ija3e66n5
         mO+KYfPvfwnSF+dg08Hz4EdJ15fthYQ15ZuLGulg9Anzcgw+12Ys3pGY7x8z+RnM6B
         UViWFVa5EfxUT8HoZWqJesWKK1q8DRMvktiHcNHZ5DFy9+U2qBMx1xmMjQtMqUhVAw
         OAObqFIcfLx0nZY66c5T7yad+/9GzY+1pR8IRUDMU6ELYDdwVTS6JMKxNzq3MsJf+B
         yKyr/v6845luZyu9YqAQCmyJDYiTZeIyKgxTVHUCxEYRP75Z1UeZG3ZPalcCDrbDqa
         CtDaN1qbhS64w==
Date:   Fri, 14 Apr 2023 17:44:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org
Subject: Re: [PATCH net-next 5/5] net: skbuff: hide nf_trace and
 ipvs_property
Message-ID: <20230414174426.3fbf5483@kernel.org>
In-Reply-To: <20230414231139.GD5927@breakpoint.cc>
References: <20230414160105.172125-1-kuba@kernel.org>
        <20230414160105.172125-6-kuba@kernel.org>
        <20230414210950.GC5927@breakpoint.cc>
        <20230414150758.4e6e9d81@kernel.org>
        <20230414231139.GD5927@breakpoint.cc>
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

On Sat, 15 Apr 2023 01:11:39 +0200 Florian Westphal wrote:
> > I copied it from:
> > 
> > static inline void nf_reset_trace(struct sk_buff *skb)
> > {
> > #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
> > 	skb->nf_trace = 0;
> > #endif
> > }
> >
> > I can't quite figure out why this would be intentional.
> > Do the existing conditions need to be fixed?  
> 
> Yes, this is not correct; needs to be "|| IS_ENABLED(CONFIG_NF_TABLES)".
> 
> Fixes: 478b360a47b7 ("netfilter: nf_tables: fix nf_trace always-on with XT_TRACE=n")
> 
> Let me know if you'd like to add the fix to v2 of your patchset
> yourself, otherwise I'll send a fixup patch to netfilter-devel@ on
> monday.

You can take the fix thru netfilter, I reckon. The new condition 
is wider so I should be able to proceed with v2 without waiting.
