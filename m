Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4465BEBA4
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiITRLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiITRLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:11:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E1D5B05A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 10:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61E8462A64
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 17:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3993C433D6;
        Tue, 20 Sep 2022 17:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663693872;
        bh=IThEX4It/viywN93wWYSl+wOZqgHmvAu+/EsIiVcpWg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e/P5SwTVo5l3KG1w25oCgTWXX53s5NrYa3sjKw6bma4V2rJRiM/92gqTV1mXw3Pa+
         2AasorLiZ2kyCZDEMiQKFBK0Z8NixSXmB29rJ3sQyH4Jr0sSSzHMmYZ7Jt97z/I/B+
         gnTUFyhKvYokorqczKWHgurfx/eJElpLQum/6Whya0nSRyNhfNp0a7M2Tx9QtlvNZb
         MTyiQJJEdGUobzADOO0MI9iuDBoCDB4jJl2bL8i2It5c9Lj4ZCABS2+Z/iMhgYBAUA
         S5hxIetXMCUVzEQ0M5WBDSQNWJ33xb7ysqadO3LboT5JBbOxe+wIM2OPGnhYB9u2B8
         qU5L+QZKcyPrA==
Date:   Tue, 20 Sep 2022 10:11:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com
Subject: Re: [PATCH ipsec-next 1/7] xfrm: add extack support to
 verify_newsa_info
Message-ID: <20220920101111.74600aee@kernel.org>
In-Reply-To: <YynicFZpq2Z64u86@hog>
References: <cover.1663103634.git.sd@queasysnail.net>
        <b492239e903e8491abfd91178b572b59a48851e3.1663103634.git.sd@queasysnail.net>
        <20220919170038.23b6d58e@kernel.org>
        <YynicFZpq2Z64u86@hog>
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

On Tue, 20 Sep 2022 17:55:28 +0200 Sabrina Dubroca wrote:
> 2022-09-19, 17:00:38 -0700, Jakub Kicinski wrote:
> > On Wed, 14 Sep 2022 19:04:00 +0200 Sabrina Dubroca wrote:  
> > >  	case IPPROTO_COMP:
> > > +		if (!attrs[XFRMA_ALG_COMP]) {
> > > +			NL_SET_ERR_MSG(extack, "Missing required attribute for COMP: COMP");
> > > +			goto out;
> > > +		}  
> > 
> > Did NL_SET_ERR_ATTR_MISS() make it to the xfrm tree?  
> 
> No, it hasn't. Thanks for the note, I hadn't seen those patches.

I figured you may not have seen them. Your call if using the new
constructs makes sense.

> It would only solve part of the problem here, since some cases need
> one of two possible attributes (AH needs AUTH or AUTH_TRUNC, ESP needs
> AEAD or CRYPT).
> 
> In this particular case, it's also a bit confusing because which
> attribute is required (or not allowed) depends on other parts of the
> configuration, so there isn't a way to express most of it outside of
> strings -- short of having netlink policies or extacks that can
> describe logical formulas, I guess.

I was considering adding "required" as part of policy validation, 
it would work in a couple of the simpler GENL cases. But I couldn't
think of a clean way which wouldn't require at least one linear policy
scan per message. Maybe the scan would not be a big deal, IDK.
