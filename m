Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E596B8331
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCMU4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCMU4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:56:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E0A81CD1
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FABB61468
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 20:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9FFC433D2;
        Mon, 13 Mar 2023 20:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678741006;
        bh=eidNKinYLbSYCW/7JBmA+DqDOlj6BxT/8lPP0eclIaA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MtrPfOaXMHTKaVzRMc1nn3R7RKbhMRZlNCWe5Cs2R5e+N+sp8nDPr3cyEr3KZEz/W
         9ISSiyX3XLVtqgwNYuK1ddSH5opblkAKnPMr5BzkIFk5r98Z0li+0+cVWITsvoOKtP
         dwp0B3pJorFbxsA21KXSqLnrhZguKL1VCWCb+Qgatf6pxyR98RNp9Nih7Zq1AmoNtz
         BDjJx8Vq1SzQ5/Y9A67/ftgtK6xpk2n9FgdzjBtiPvRGVzSn7bXEOcDm7tceu/TYuO
         PvUL8X9Yq179eOBbvyDqD+HgGbosZBFAWmiBOEPmYHZyOkYSKpbvxcXgA7D+cVf9cf
         o77Dos+2QvELw==
Date:   Mon, 13 Mar 2023 13:56:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, alexanderduyck@fb.com, roman.gushchin@linux.dev
Subject: Re: [RFC net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230313135640.3a511db0@kernel.org>
In-Reply-To: <20230312184515.5eabc8df@hermes.local>
References: <20230311050130.115138-1-kuba@kernel.org>
        <20230311082826.3d2050c9@hermes.local>
        <640e7e633acec_24c5ed2088c@willemb.c.googlers.com.notmuch>
        <20230312184515.5eabc8df@hermes.local>
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

On Sun, 12 Mar 2023 18:45:15 -0700 Stephen Hemminger wrote:
> > > Could any of these be inline functions instead for type safety?    
> > 
> > I suppose not because of the condition that is evaluated.  
> 
> It is more that the condition needs to evaluated after some other
> pre-conditions.

Right, I think I could slice off individual chunks and wrap them in
static inlines, but I reckon the result is relatively readable now?
