Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0457E642F07
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiLERoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLERoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:44:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AD26463;
        Mon,  5 Dec 2022 09:44:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA156123F;
        Mon,  5 Dec 2022 17:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA95CC433D6;
        Mon,  5 Dec 2022 17:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670262256;
        bh=bZ7oYcMvN8YJz90xiw4nysNVJMVD60z0jrEhI741PtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i+Hsfxpjh4ZEW1hey5bH70N/euUo0LNh7qnTlCDF91851KpCsP8N5Xodjmqz1ErHr
         tDOEuFphn2LmgSDzMdukasFCdrqbHf5L/MCPJby/o8GfCL3SU8LUgnvvm83dbjsAIF
         nvnsnmCvSBsneIANxUL47Pu5Uj8dlV8zf1QLZNQPvB3VHFfFhFdxhWZ/ug0rzclG9h
         UK8VZOC7/jBu8l0mKauQPmsFDqb7heDY6ZChOE9nkLusk0fOUINAmuAKqmBG/CcKQA
         YNIBKG2+uJDxA0a40f0xMSFqmAidh9N9lZn4ZDekuZ4Yz+Gdq1JIAK11xvJsW3nMJf
         FmCyUCEq1WOyQ==
Date:   Mon, 5 Dec 2022 19:44:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: mvneta: Prevent out of bounds read in
 mvneta_config_rss()
Message-ID: <Y44t7OczM/wrbowu@unreal>
References: <Y4nMQuEtuVO+rlQy@kili>
 <Y4yW0fhKuoG3i7w3@unreal>
 <Y42z8kv8ehkk6YKf@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y42z8kv8ehkk6YKf@kadam>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 12:03:46PM +0300, Dan Carpenter wrote:
> On Sun, Dec 04, 2022 at 02:47:13PM +0200, Leon Romanovsky wrote:
> > On Fri, Dec 02, 2022 at 12:58:26PM +0300, Dan Carpenter wrote:
> > > The pp->indir[0] value comes from the user.  It is passed to:
> > > 
> > > 	if (cpu_online(pp->rxq_def))
> > > 
> > > inside the mvneta_percpu_elect() function.  It needs bounds checkeding
> > > to ensure that it is not beyond the end of the cpu bitmap.
> > > 
> > > Fixes: cad5d847a093 ("net: mvneta: Fix the CPU choice in mvneta_percpu_elect")
> > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > ---
> > >  drivers/net/ethernet/marvell/mvneta.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > 
> > I would expect that ethtool_copy_validate_indir() will prevent this.
> > 
> 
> Huh...  Sort of, but in the strictest sense, no.  mvneta_ethtool_get_rxnfc()
> sets the cap at 8 by default or an unvalidated module parameter.

And is this solely mvnet issue? Do other drivers safe for this input?

Thanks

> 
> regards,
> dan carpenter
> 
