Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C1950E3E7
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242585AbiDYPEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242679AbiDYPEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F2232980;
        Mon, 25 Apr 2022 08:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D05AF616A4;
        Mon, 25 Apr 2022 15:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3255C385A4;
        Mon, 25 Apr 2022 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650898859;
        bh=jRjIdAQhCa9XN1YfObjM3zVQ4hxJigbGjIXQD7ioE+c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SjVAKvW2WDgG2qdSn0lEu106PLJLtpftHvHmhJbLto51um4Zlf+vjYg381TWKZPXk
         Drn9+MCF7+cqxMx+rMy3i+htbvkKlxSLSUQlGZrH9ylF5LZ/rcWTPIMEFt4R9y0LO4
         j9TA7wfYF9LFjDXR9IIGrdyaDG46+3I5utqxQXq4Ba8NdKEzloRB83c0fmiRNON/2i
         MBisJlXJrOivhqFgaD2EUmy2uJ3cZCk7dFtALODAk/96v2ZYMIxqOECORs0JoiU36M
         jb3enPLc+WamAsTcGLzrnSm1bXuhg5mTegkBmnaO/ZZB0higHjtt3JuNPHAPuu+39P
         +kfj1xEUFbeYg==
Date:   Mon, 25 Apr 2022 08:00:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jann Horn <jannh@google.com>
Cc:     Lukas Wunner <lukas@wunner.de>, Paolo Abeni <pabeni@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
Message-ID: <20220425080057.0fc4ef66@kernel.org>
In-Reply-To: <CAG48ez3ibQjhs9Qxb0AAKE4-UZiZ5UdXG1JWcPWHAWBoO-1fVw@mail.gmail.com>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
        <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
        <20220423160723.GA20330@wunner.de>
        <20220425074146.1fa27d5f@kernel.org>
        <CAG48ez3ibQjhs9Qxb0AAKE4-UZiZ5UdXG1JWcPWHAWBoO-1fVw@mail.gmail.com>
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

On Mon, 25 Apr 2022 16:49:34 +0200 Jann Horn wrote:
> > Doesn't mean we should make it legal. We can add a warning to catch
> > abuses.  
> 
> That was the idea with
> https://lore.kernel.org/netdev/20220128014303.2334568-1-jannh@google.com/,
> but I didn't get any replies when I asked what the precise semantics
> of dev_hold() are supposed to be
> (https://lore.kernel.org/netdev/CAG48ez1-OyZETvrYAfaHicYW1LbrQUVp=C0EukSWqZrYMej73w@mail.gmail.com/),
> so I don't know how to proceed...

Yeah, I think after you pointed out that the netdev per cpu refcounting
is fundamentally broken everybody decided to hit themselves with the
obliviate spell :S
