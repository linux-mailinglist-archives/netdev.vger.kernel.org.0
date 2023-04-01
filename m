Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E956D335F
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDATOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDATOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:14:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E058CA00
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FEB760C02
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 19:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517E5C433EF;
        Sat,  1 Apr 2023 19:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680376492;
        bh=TCSCTbkOgX2xsUC6EPhOGii5M+VeQgZTWEb8WFspuzI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HB5nHj6qa0dptT/tfuW24xVa7fhpJ29W6ejCZd+4iZTXkmXP6bnHiIL39rPPtLjJP
         JxHkJ8cpFupO+tv9JfvFacVkz5na34ZPnaklAXoCvT322T4vU8FUCc03pSjloFxYUz
         9E+c0aq/8XCv4zdgEdRnFfEbUyt7Tkub1DAnXbx4kGuDwiaEEU3OUPbBVyGVGx+Fz4
         wcUBGUYOHHgGB4JTjpAtFS7OzyXHneBiirpfSubR09sjXkse3T3FwOV24z5GoKPtiZ
         rzFAOK5n/9dNNfozi7QTAmXuXa+H5UKrazB0/vnROPSFcSOP5QG0KTZrUCj8Zn5YRa
         Ut1Urw/ryIpUA==
Date:   Sat, 1 Apr 2023 12:14:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401121451.4457de9c@kernel.org>
In-Reply-To: <20230401182058.zt5qhgjmejm7lnst@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
        <20230330223519.36ce7d23@kernel.org>
        <20230401160829.7tbxnm5l3ke5ggvr@skbuf>
        <20230401105533.240e27aa@kernel.org>
        <20230401182058.zt5qhgjmejm7lnst@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Apr 2023 21:20:58 +0300 Vladimir Oltean wrote:
> > After this patch we'll be passing an in-kernel-space struct to drivers
> > rather than the ifr they have to copy themselves. I'm saying that we
> > should validate that exact copy, rather than copy, validate, copy, pass
> > to drivers, cause user space may change the values between the two
> > copies.
> > 
> > Unlikely to cause serious bugs but seems like a good code hygiene.
> > 
> > This is only for the drivers converted to the NDO, obviously, 
> > the legacy drivers will still have to copy themselves.  
> 
> Could you answer my second paragraph too, please?
> 
> | Perhaps I don't understand what is it that can change the contents
> | of the ifreq structure, which would make this a potential issue for
> | ndo_hwtstamp_set() that isn't an issue for ndo_eth_ioctl()...
> 
> I don't disagree with minimizing the number of copy_to_user() calls, but
> I don't understand the ToCToU argument that you're bringing....

As I said, just code hygiene, I haven't looked at the drivers.
Seems too obvious to invest time trying to come up with an exact
scenario.

Do you see a reason not to code this the right way?
