Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552B249BE75
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiAYW21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiAYW2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:28:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6009EC061744
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 14:28:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EB43B81B7E
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 22:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BF5C340E0;
        Tue, 25 Jan 2022 22:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643149699;
        bh=JjU8WCk/+P3a4NUBCcn++jQaOrAEzgpcmDcIlK/Z9xM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O5jcCEMrWYOX/TNGBEKJcV7RcSHnbDWs0nstcZ7o+Ojuys1uPdngK7lPY5vPoh3Js
         uq+2TZWQNWmUJ3uhYp2k8QyEeQr9yQXlizfTdI1SF/gsoOi5FGv5axO7zmwB7yP3h6
         5iKUj9KwhOL1pMsFR2WqbuRkqwzKNYiWcMsjvWeS/y2oLI55Bf4lfpC4Lk5uGPFVAD
         YYEvrl7ONVW4yWeUGI1gDoeya0vn8v0480wDaUvrAhXbMsPq+yj3tJupXdtEj2i2In
         l8j3R8b1PRhO4cTVINnk5SE2xY0YIg+qTFusXmpwN9rKRX5X9brfDcCXaQj82Y2LUX
         tX/vQQ9aulvvA==
Date:   Tue, 25 Jan 2022 14:28:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dave@thedillows.org
Subject: Re: [PATCH net 0/3] ethernet: fix some esoteric drivers after
 netdev->dev_addr constification
Message-ID: <20220125142818.16fe1e11@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125222317.1307561-1-kuba@kernel.org>
References: <20220125222317.1307561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 14:23:14 -0800 Jakub Kicinski wrote:
> Looking at recent fixes for drivers which don't get included with
> allmodconfig builds I thought it's worth grepping for more instances of:
> 
>   dev->dev_addr\[.*\] = 
> 
> This set contains the fixes.

Hi Arnd, there's another case in drivers/net/ethernet/i825xx/ether1.c
which will be broken in 5.17, it looks like only RiscPC includes that.
But when I do:

make ARCH=arm CROSS_COMPILE=$cross/arm-linux-gnueabi/bin/arm-linux-gnueabi- O=build_tmp/ rpc_defconfig

The resulting config is not for ARCH_RPC:

$ grep ARM_ETHER1 build_tmp/.config
$ grep RPC build_tmp/.config
# CONFIG_AF_RXRPC is not set
CONFIG_SUNRPC=y
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_XZ_DEC_POWERPC=y
$ grep ACORN build_tmp/.config
# CONFIG_ACORN_PARTITION is not set
CONFIG_FONT_ACORN_8x8=y

Is there an extra smidgen of magic I need to produce a working config
here?  Is RPC dead and can we send it off to Valhalla?
