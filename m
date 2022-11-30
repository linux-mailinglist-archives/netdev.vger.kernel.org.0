Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1248B63D158
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiK3JDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiK3JDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:03:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C144A201A5
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CA4C61A8B
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A967C433C1;
        Wed, 30 Nov 2022 09:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669799017;
        bh=gcbXmQ3tohNsJPCOPldzh2ZOid5hwflmWITxev76d4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kMr3guVICpV80RJl7WN2NAaCqCz9dG2pWERtpVdnXctV9EPUcZGP8izWPQ7TJiaO1
         QPJg2eydze+nCwqNzMu0l80oH11KK/iYJY8e/vcDqKaRMn4ckZt9vKUZCKOjvZEG6i
         OiY5mW4M5BV3f4zZuGjUKxYeHoVbrUXVz+ycgd82B2yKLNrfCokMqdSQ4FqWolcl12
         WzPnJyTrxFPj/Ks7rxSVCPmwgs7ALXOauo1BKdQs1rxNkomNdM2plOU0GkpjLHeSSx
         cV18p4/TnQtY3DOKTO4nhpnisHjGjZE4xtUFtNpVuOZxSCflWpmzZ81osbdtPIJkbf
         jJp/nuNdwLVqA==
Date:   Wed, 30 Nov 2022 11:03:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com
Subject: Re: [patch net-next v2] net: devlink: convert port_list into xarray
Message-ID: <Y4ccZTvED7mxW88Z@unreal>
References: <20221128110803.1992340-1-jiri@resnulli.us>
 <20221129212736.60d3bb4b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129212736.60d3bb4b@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 09:27:36PM -0800, Jakub Kicinski wrote:
> On Mon, 28 Nov 2022 12:08:03 +0100 Jiri Pirko wrote:
> > @@ -9903,9 +9896,9 @@ void devlink_free(struct devlink *devlink)
> >  	WARN_ON(!list_empty(&devlink->sb_list));
> >  	WARN_ON(!list_empty(&devlink->rate_list));
> >  	WARN_ON(!list_empty(&devlink->linecard_list));
> > -	WARN_ON(!list_empty(&devlink->port_list));
> >  
> >  	xa_destroy(&devlink->snapshot_ids);
> > +	xa_destroy(&devlink->ports);
> 
> Will it warn if not empty?

No, it won't warn. It will simply reinitialize the XArray.
