Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793886E2E52
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjDOBxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDOBxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74894C0C
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 18:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3816D611BE
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 01:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C00C433EF;
        Sat, 15 Apr 2023 01:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681523610;
        bh=bYkmFmoWH+o/zB7cECv8XEyKs+zzq2AaYEVWQCs6uq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QOuJ3VI/k7DtYQ+KodIvzx/5niPvHpDus9fqXFtP9Vqy8rxGxfEEsCvcgk5Y4x6nI
         /x5SKUJMNQVhx/sFpY7HCRZo65sPhKAqA0anGG0NLwG6Lz5clyOYssMvt7jpl9Dcsc
         3psZWm0Um329jM8I+LViG7qgqD0aGASr1Z6aMTQpJtahGDM0JtW/SBkzCLt0LEROVe
         qtixv7/+XVbleyIhJJlsq/eEUEwA+74IG8foan9PaCJydXSJwrxCdJczREDC0UoRn0
         vyNpQGz5u1p9GMI5bds3evTkcpiDGtQlaJzlf+th2G7l04CgCOdAyPeBpsKuNf6dO3
         8usjrAfAte7+Q==
Date:   Fri, 14 Apr 2023 18:53:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] r8169: use new macro
 netif_subqueue_maybe_stop in rtl8169_start_xmit
Message-ID: <20230414185329.6e8ada34@kernel.org>
In-Reply-To: <ad9be871-92a6-6c72-7485-ebb424f2381d@gmail.com>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
        <ad9be871-92a6-6c72-7485-ebb424f2381d@gmail.com>
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

On Thu, 13 Apr 2023 21:15:37 +0200 Heiner Kallweit wrote:
> +	stop_queue = netif_subqueue_maybe_stop(dev, 0, rtl_tx_slots_avail(tp),
> +					       R8169_TX_STOP_THRS,
> +					       R8169_TX_START_THRS);
> +	if (door_bell || stop_queue < 0)

Macro returns 0 if it did the action. So I'd have expected <= or !
Maybe better to invert the return value at the call site..

	stopped = !netif_subqueue_maybe_stop(...
	if (door_bell || stopped)
		..
