Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB8E50E385
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 16:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbiDYOox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241180AbiDYOow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:44:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CF41C925;
        Mon, 25 Apr 2022 07:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7FCC61677;
        Mon, 25 Apr 2022 14:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF37C385A4;
        Mon, 25 Apr 2022 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650897708;
        bh=yNdFolgM9KVEAn96D1w8vouWroP4KcIs2PEb4lnd29k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iU1Ld6X4usl6+rO7oLGaqW98KMN1RGyODRCtxZJ7/78Kh4DG48bFmrAFT0nWoBY4Q
         foBcnFn5jlW3Es7O3fuXRsZ4PmDeJGr2wTho4xl/yHNoktxcQmBN6hPA4wJ33GhgAa
         lgpuW9cINqir9rdvuwVm251DQm9OMdHELMu4MJW9LfS6s0Apn9ke12jjkTtn3+vbW4
         LTH+2GiHc2WbJrK96zfTGaPZg2OTYnRDfrqmDey4WxIWElIgpm2QIfnxI1/bj/wRgI
         2kC23R9KONs7MA6rVMhKRi+VB7D+TVP+hsDRUJ7WW9/uzmnIcfSv7lNxiyvMfSVm1D
         lL7QXz6dPxM5w==
Date:   Mon, 25 Apr 2022 07:41:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Paolo Abeni <pabeni@redhat.com>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
Message-ID: <20220425074146.1fa27d5f@kernel.org>
In-Reply-To: <20220423160723.GA20330@wunner.de>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
        <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
        <20220423160723.GA20330@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Apr 2022 18:07:23 +0200 Lukas Wunner wrote:
> > Looking at the original report it looks like the issue could be
> > resolved with a more usb-specific change: e.g. it looks like
> > usbnet_defer_kevent() is not acquiring a dev reference as it should.
> > 
> > Have you considered that path?  
> 
> First of all, the diffstat of the patch shows this is an opportunity
> to reduce LoC as well as simplify and speed up device teardown.
> 
> Second, the approach you're proposing won't work if a driver calls
> netif_carrier_on/off() after unregister_netdev().
> 
> It seems prudent to prevent such a misbehavior in *any* driver,
> not just usbnet.  usbnet may not be the only one doing it wrong.
> Jann pointed out that there are more syzbot reports related
> to a UAF in linkwatch:
> 
> https://lore.kernel.org/netdev/?q=__linkwatch_run_queue+syzbot
> 
> Third, I think an API which schedules work, invisibly to the driver,
> is dangerous and misguided.  If it is illegal to call
> netif_carrier_on/off() for an unregistered but not yet freed netdev,
> catch that in core networking code and don't expect drivers to respect
> a rule which isn't even documented.

Doesn't mean we should make it legal. We can add a warning to catch
abuses.
