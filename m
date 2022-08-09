Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E034358DFDF
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345454AbiHITHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348318AbiHITGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:06:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50773C50;
        Tue,  9 Aug 2022 11:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECAC1B8171E;
        Tue,  9 Aug 2022 18:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223B3C433D6;
        Tue,  9 Aug 2022 18:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660071017;
        bh=iWdOy7xi9yi/F6gSl2aQiz4W6SyS8CyFp0Dq/r4vpBg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mpWvB3UOPu14vXhzcpaMukMtZwo+uT7+iz3zv5o24LdGaDRO1SvZFW4+2kuEkKfyt
         OB1XpZUGnsvFBQ8NEEivIsm3s5mAUW010CMSzYSYUmOczpy9UnhY4EeCVBiM1XVsR3
         nSPu9HzjiUA/BrQvjbJrKNzCraepIC2MBbvSX7htVB7/xQiBFxgi0UXUJVMmngDbDb
         LqpdfAMQo5T5XeqLV+M8YtjEj5R/ez7M6JB3l2ZcmOk6Hbz2PwpuXnBm88Z03fI5gP
         APHwlnUvzt0YJoKnatr+N/sfrOBYSiTgGtxbGvoM0WWqHZe3Dt/TGL42r/naCR8ASB
         3w/3jjP4tRELQ==
Date:   Tue, 9 Aug 2022 11:50:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Sebastian =?UTF-8?B?V8O8cmw=?= <sebastian.wuerl@ororatech.com>
Subject: Re: [PATCH net 4/4] can: mcp251x: Fix race condition on receive
 interrupt
Message-ID: <20220809115016.1db564b3@kernel.org>
In-Reply-To: <20220809075317.1549323-5-mkl@pengutronix.de>
References: <20220809075317.1549323-1-mkl@pengutronix.de>
        <20220809075317.1549323-5-mkl@pengutronix.de>
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

On Tue,  9 Aug 2022 09:53:17 +0200 Marc Kleine-Budde wrote:
> @@ -1082,6 +1079,18 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
>  			if (mcp251x_is_2510(spi))
>  				mcp251x_write_bits(spi, CANINTF,
>  						   CANINTF_RX0IF, 0x00);
> +
> +			/* check if buffer 1 is already known to be full, no need to re-read */
> +			if (!(intf & CANINTF_RX1IF)) {
> +				u8 intf1, eflag1;
> +				

This line is full of trailing whitespace, could you add a fix on top to
remove it and resend?
