Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA0959A9AA
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243229AbiHSXpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiHSXpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:45:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9D010895E;
        Fri, 19 Aug 2022 16:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D19A1B829A6;
        Fri, 19 Aug 2022 23:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F35C433D6;
        Fri, 19 Aug 2022 23:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660952720;
        bh=Xz3ht3567f97hsrzOYKMZlcqCEBw8plIdtn33Lj4zn0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lic9dVpHDpYUmuflIzheV5IKuaHfRdaTSXgS5YO4tkbB3zbTYh9y/XoYnLqwUF1s8
         FigB9dwwaZFEv7n9CepbiP7zmUda3MGaU+ObQWT+Hy24+zlkkimA78JuVEOnSvjTfB
         gA5D7nExDvtod6ygLtWX8dw3FiAiUCzyk/Vq/GQ+XRxFdOI/qjOfQ2+rNxJ1U1afTa
         QaEkSK4H/tGAF45SR1chT4AvSn80+Cei3YlbkKJ/RSlkkDkXBRVJV3teLntaFaeBLS
         xGKxQSF8iBlc9LMdg5izgiEfcQXXMhK50Wgchv2qnuDoNxdG2kz64BYFZRt5srGuO5
         6s5NJBoLNbMxg==
Date:   Fri, 19 Aug 2022 16:45:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] net: phy: Warn if phy is attached when removing
Message-ID: <20220819164519.2c71823e@kernel.org>
In-Reply-To: <20220816163701.1578850-1-sean.anderson@seco.com>
References: <20220816163701.1578850-1-sean.anderson@seco.com>
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

On Tue, 16 Aug 2022 12:37:01 -0400 Sean Anderson wrote:
> netdevs using phylib can be oopsed from userspace in the following
> manner:
> 
> $ ip link set $iface up
> $ echo $(basename $(readlink /sys/class/net/$iface/phydev)) > \
>       /sys/class/net/$iface/phydev/driver/unbind
> $ ip link set $iface down
> 
> However, the traceback provided is a bit too late, since it does not
> capture the root of the problem (unbinding the driver). It's also
> possible that the memory has been reallocated if sufficient time passes
> between when the phy is detached and when the netdev touches the phy
> (which could result in silent memory corruption). Add a warning at the
> source of the problem. A future patch could make this more robust by
> calling dev_close.

FWIW, I think DaveM marked this patch as changes requested.

I don't really know enough to have an opinion.

PHY maintainers, anyone willing to cast a vote?
