Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C654F1F5B
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiDDWvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 18:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbiDDWvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 18:51:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D0D61A0A
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 15:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kpKeRnJLlKYqZBD6VcfJyKUGK1O/DKpsspH64ose7t0=; b=ULsk1qKnN4MuUjjHu6D9lJeq3c
        TRG3XGim3XwbTObOAqXHMZF3+dmULFKfGWWPIf/v63qurM/HzFyExUs9MWoTUHVNpXvyQUPf+h+PM
        h3o8JD/1sceEWRpjde84nUdTfPkczqxTYQ/voOa4q0DKoF3U7reYv99w/G7bm8j8Og8k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbUoI-00E9GV-7u; Tue, 05 Apr 2022 00:04:30 +0200
Date:   Tue, 5 Apr 2022 00:04:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matej Zachar <zachar.matej@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [DSA] fallback PTP to master port when switch does not support it
Message-ID: <YktrbtbSr77bDckl@lunn.ch>
References: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 09:28:08PM +0200, Matej Zachar wrote:
>  Hi,
> 
> in my embedded setup I have CPU (master) port with full PTP support
> connected to the onboard switch (without PTP support) through
> DSA. As the ioctl and ts_info is passed to the switch driver I made
> small change to fallback to the master net_device.

Did you try just running PTP on the master device? I'm wondering if
the DSA headers get in the way?

What i don't like about your proposed fallback is that it gives the
impression the slave ports actually support PTP, when they do not. And
maybe you want to run different ports in different modes, one upstream
towards a grand master and one downstream? I suspect the errors you
get are not obvious. Where as if you just run PTP on the master, the
errors would be more obvious.

> This however requires that the switch which does not support PTP
> must not implement .get_ts_info and .port_hwtstamp_get/set from
> dsa_switch_ops struct.

And this is another advantage of just using master directly. You can
even use master when the switch ports do support PTP.

       Andrew

