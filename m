Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6314D3C48
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237386AbiCIVoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiCIVon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:44:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4569843EF0
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:43:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A290261B0A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5843C340EE;
        Wed,  9 Mar 2022 21:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646862223;
        bh=IHHv7PTWwDiDgZcDNEZ6S6mSRGznIZCFaJcXFDx9564=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XpZJ5zSWkCYA6zjlhV1zvIUIjrBIf+Hfvc+GtvpaHoGpJg0Fu11hU7mA5KSfTK9hv
         mbmnDp87+wB8HTHIIca9hbAPufArPMs3qXnX2v/w8My6NDRJNwbacO8d9f0h3jsyNi
         zImVoxUsrPaweBi3yLVTBTCM8yO8YrV77GxS7LEfisRaWCWw0FJMlH8LLyQsZnj05t
         pRzHJQuCQnQ6CPE+d07oHfNCglaY4lUrXZF5Sq/aB/PO/HCwpQVBzperA4ygIat4M7
         hNJgcqnpQiCgxUfmJCRq+5Zm+aqO8c5jYbcCwmarweaTl3x95mzbx5Xh6HgFLwinKb
         Ewq8ILVx0ehUg==
Date:   Wed, 9 Mar 2022 13:43:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>
Subject: Re: [PATCH net-next] net: add per-cpu storage and net->core_stats
Message-ID: <20220309134341.6037bb1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309211808.114307-1-eric.dumazet@gmail.com>
References: <20220309211808.114307-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Mar 2022 13:18:08 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Before adding yet another possibly contended atomic_long_t,
> it is time to add per-cpu storage for existing ones:
>  dev->tx_dropped, dev->rx_dropped, and dev->rx_nohandler
> 
> Because many devices do not have to increment such counters,
> allocate the per-cpu storage on demand, so that dev_get_stats()
> does not have to spend considerable time folding zero counters.
> 
> Note that some drivers have abused these counters which
> were supposed to be only used by core networking stack.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: jeffreyji <jeffreyji@google.com>
> Cc: Brian Vazquez <brianvv@google.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Things to mention in passing, in case there is a v2:
 - we could use a different header for this, netdevice.h is a monster
 - netdev_core_stats_alloc() could have the last if inverted to keep
   success path unindented
