Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579E354E677
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377984AbiFPP5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378019AbiFPP5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:57:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4984B0C;
        Thu, 16 Jun 2022 08:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90BDCB82497;
        Thu, 16 Jun 2022 15:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F75C34114;
        Thu, 16 Jun 2022 15:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655395054;
        bh=aqS2dz4O//iR1Vr0NtpXde5TYZF+050+yENkyO3WUu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m8tvtkJLsS/ugQn516qNZWTnQY8dHCyKOTGgP0oJi7Yk9+twCEFaIV663ybl30euo
         ojM7S0QgTEqok47JvzzH0GBwoean8N8QwLkobrSQZqyv0QVOjyhIsZT4O15IUK3VQ8
         MqliFW/8Hhuy3+kKfp1HKyBVYAJnpRfuXzrqlz18DZ0bBzaWBwM8ePty1LOP8ILrB7
         GMHUrTZCyDkKNYBWy0iMW1X1eoItNv/DFjMiVYczaMxcHlNDZFl3pdouG2y6Dfc0qM
         wnN1E0dsx+if2F1G6xxI/nnuDP1gqBRnvbysKZN/85jNmP6vH14ydM5B32ehxMXvxv
         oX2KJM2RAARtQ==
Date:   Thu, 16 Jun 2022 08:57:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <20220616085732.7bc7ef30@kernel.org>
In-Reply-To: <20220616093451.GA28995@pengutronix.de>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
        <YqS+zYHf6eHMWJlD@lunn.ch>
        <20220613125552.GA4536@pengutronix.de>
        <YqdQJepq3Klvr5n5@lunn.ch>
        <20220614185221.79983e9b@kernel.org>
        <YqlUCtJhR1Iw3o3F@lunn.ch>
        <20220614220948.5f0b4827@kernel.org>
        <Yqo8BuxL+XKw8U+a@lunn.ch>
        <20220616093451.GA28995@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 11:34:51 +0200 Oleksij Rempel wrote:
> > It is also a bit unclear, but at the moment, i think user
> > space. However, i can see the kernel making use of maybe RF TEST to
> > ask the link peer to go quiet in order to perform a cable test.
> > 
> > Oleksij, what are your use cases?  
> 
> Currently I was thinking only about diagnostic:
> - request transmit pause for cable testing
> - request remote loopback for selftest. In this case I will need to use
>   vendor specific NextPage to request something like this.

Both of those are performed by the kernel, so perhaps we should focus
the interface on opting into the remote fault support but have the
kernel trigger setting and clearing the bits?
