Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F4B6D5359
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjDCVT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbjDCVTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:19:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4763C14
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 955F562B48
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 21:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE58AC433EF;
        Mon,  3 Apr 2023 21:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680556759;
        bh=+5lWUw2eEpg++zPISo8GyfNw0r3PwsZ3+Nv3qderYcU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z4h6RUHinNKUhHJpK05F8Jl8pdr6eI4uNE3Do8aDXFjLXazEJw78YqHh0QTZ+B+LL
         4UV6+DM9galVecgZuTbXcnaTrkT5v4DeYudHFkulzo0BMe/ei7tkDsrkGg6w+c/0gn
         AI9sg6w9hIwKcwKN3TAz/Usf9NXp7mGjfNTVDhupIrLO7KQeFsEAzv/H5PdVdZ4Tc2
         ITCaNRPU1TeWo4d3vtts/zNS3XKWrsN5wwPxLk0gueKmrGahWVW4h3vlqqHZ/bWeWT
         FJevhiNrkyyd2g+7wKFICyJKRIax6Xa9vbxNpSAaDA2balWjstX6bfrd63a0ctvC0Q
         /mXmfprlo94mg==
Date:   Mon, 3 Apr 2023 14:19:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
Message-ID: <20230403141918.3257a195@kernel.org>
In-Reply-To: <20230403122622.ixpiy2o7irxb3xpp@skbuf>
References: <20230402142435.47105-1-glipus@gmail.com>
        <20230402142435.47105-1-glipus@gmail.com>
        <20230403122622.ixpiy2o7irxb3xpp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 15:26:22 +0300 Vladimir Oltean wrote:
> > @@ -7365,6 +7364,8 @@ static const struct net_device_ops e1000e_netdev_ops = {
> >  	.ndo_set_features = e1000_set_features,
> >  	.ndo_fix_features = e1000_fix_features,
> >  	.ndo_features_check	= passthru_features_check,
> > +	.ndo_hwtstamp_get	= e1000e_hwtstamp_get,
> > +	.ndo_hwtstamp_set	= e1000e_hwtstamp_set,
> >  };  
> 
> The conversion per se looks almost in line with what I was expecting to
> see, except for the comments. I guess you can convert a single driver
> first (e1000 seems fine), to get the API merged, then more people could
> work in parallel?
> 
> Or do you want netdevsim to cover hardware timestamping from the
> beginning too, Jakub?

I'd vote to split netdevsim out, and it needs a selftest which
exercises it under tools/testing/selftests/drivers/net/netdevsim/
to get merged...
