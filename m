Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE82D59C5B7
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiHVSFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbiHVSFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5455D46215;
        Mon, 22 Aug 2022 11:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E59DE612AB;
        Mon, 22 Aug 2022 18:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16567C43148;
        Mon, 22 Aug 2022 18:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661191544;
        bh=ohYEWbUr62i4x7jS4i3d6jDoZV/febzulxOF1DkwCkQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V3D0ZNjllpHNSLdOjlL6+R4E8eqIckK0dXz888PosO8eF+P0F7k9wv8UGmK7qfyEJ
         8/ZC3Slk0QyHGDAvs4fqs9Itxa57hu0Kjft566/Q26U0bcsGchxzxPnVlIlfpXkblu
         pVTm8mONCWVV17PzFOiIQnjKFqTxHz8zodrBrmpwShLisTfGzaJZRG4FVvVLXGqzCt
         doP94Y9EM5gELbesDvz6JtWOhIBQ1NbheKubR0fQoTVUEb6jlPWVwQ3nGynSO7wAsH
         x0DQpOBAKXVM+PgSwUEyeJBK7z+oUflZn/Ryq2/jxxXURjcfcwSf9FbWgPwYHtp94e
         JlxIMat4Jy4YQ==
Date:   Mon, 22 Aug 2022 11:05:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] u64_stat: Remove the obsolete fetch_irq() variants
Message-ID: <20220822110543.4f1a8962@kernel.org>
In-Reply-To: <YwOd7Ex7W21WzQ8N@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
        <20220817162703.728679-10-bigeasy@linutronix.de>
        <20220817112745.4efd8217@kernel.org>
        <Yv5aSquR9S2KxUr2@linutronix.de>
        <20220818090200.4c6889f2@kernel.org>
        <Yv5v1E6mfpcxjnLV@linutronix.de>
        <20220818104505.010ff950@kernel.org>
        <YwOd7Ex7W21WzQ8N@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 17:17:00 +0200 Sebastian Andrzej Siewior wrote:
> Using u64_stats_fetch_begin() is most likely wrong in networking because
> the stats are updated while packets are received which is either in IRQ
> or in BH (except maybe for the SPI/I2C ethernet driver). The _bh()
> version was replaced with _irq() for netpoll reasons.
> u64_stats_fetch_begin() does not disable any of those two (IRQ, BH) on
> 32bit-UP and does not use a seqcount so it is possible that an update
> happens during the read out of stats. Let me look=E2=80=A6
> 	drivers/net/ethernet/cortina/gemini.c
> reads in net_device_ops::ndo_get_stats64(), updates in NAPI.
>=20
> 	drivers/net/ethernet/huawei/hinic/hinic_rx.c
> reads in net_device_ops::ndo_get_stats64() and
> ethtool_ops::get_ethtool_stats(), updates in NAPI. Good.
>=20
> So I guess these want be fixed properly instead of silently via the
> series?

Guess so, but it shouldn't be extra work if we're delaying the driver
conversion till 6.1?
