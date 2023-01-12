Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AB66669B3
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 04:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbjALDj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 22:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbjALDjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 22:39:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AF744C4E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 19:39:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AB3861F3D
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 03:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D21C433EF;
        Thu, 12 Jan 2023 03:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673494790;
        bh=O33iQQeypuuWesuw1EA+l+Tg77y4KLGX/D/HNBMhkUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K6w+XRxXTvuxov4T0TXKQnKuHG5JwrPBIwHqxdDb4kewkiA0rLUdE+ldpMXFwHHMU
         IDdqQuCH4LhAizMPyyg+G9cyuz68YQUFWsGQcClQKUywgF6JF0fUEfYXPqBFKBMX8w
         ABmg5jrCSwkrnIRAs2Ay0WRxMiIfXRwA/b0/vDVBtIX0qe1b9n172NTEzhtqjiJU31
         TICBqdVZk8pu9/O3tbqGYUO2RQvcJ2IazgPcKRQ+cUocYKrM2F679zTK4A1Y2rMHB5
         krEreTcVEMtmdWu/CBIEy10/3NzZ8/h6Mia+maSbMVTs/0HYCE0Wj+hCQZfDZ70fE3
         66hOv6D6Ljd/w==
Date:   Wed, 11 Jan 2023 19:39:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Arinzon, David" <darinzon@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        "Schmeilin, Evgeny" <evgenys@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Message-ID: <20230111193948.057d8369@kernel.org>
In-Reply-To: <2ad9b7b544d745aebd5ddd79bf2efa12@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
        <20230110124418.76f4b1f8@kernel.org>
        <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
        <20230111110043.036409d0@kernel.org>
        <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
        <20230111120003.1a2e2357@kernel.org>
        <2ad9b7b544d745aebd5ddd79bf2efa12@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 21:21:16 +0000 Arinzon, David wrote:
> I'll note again that this is not a configurable value, meaning, the only option is
> to have 128B (standard) or 256B (large) LLQ, there's no option to set other values,
> but only choose between the modes, therefore, I don't see how having such an
> option through ethtool, as you suggested (setting the max length) can be
> beneficial in our use-case (might be good overall, as you noted, it's a more
> generic concept). Will put more thought into it.

FWIW you can just return an error via extack if user tries to set an
unsupported value, like:

	NL_SET_ERR_MSG(extack, "only X and Y are supported");

and it will pop up as part of the error in ethtool CLI. Or do some
rounding up - a lot of drivers does that for ring params already.
