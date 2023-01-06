Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE08866095D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 23:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbjAFWNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 17:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbjAFWNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 17:13:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D3D3E852
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 14:13:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85D3D61F6D
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 22:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97CDC433D2;
        Fri,  6 Jan 2023 22:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673043227;
        bh=Z9S2PzOgUsYhX5ROyrT7jC+HvkreneKz4aoyD+JPsFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G/xC442Eq1AQZpQ6dRZBpmlaxTYeJ6r2CHj9uLoiPmWk3yYGqFbsvSo48jmpPZqu9
         Sd3Fn9KYIdfhX0QVANvXpuppHJuTihSOF2t/2lG6L/lqpD51MiIRANphO+8us6pUL4
         TgxbDP9rmBdnyWeL+QAyjqBDlC3de5E9keJtTwnOFvXh4c9RAzDQi3lE1ME5g4UjOT
         QMiuPZbM/vEk1H3BX/moS1b5qyQthyE+v5E/WYqlOUkSkRThZqpnkCdXuV25J8mmF0
         w7ORpU4pXXwWh4BzY8uSEHYv+OtJ8rsj3HC1KFuG+NiqnG+704KR3MJcWgFKNsT7XN
         ZywhHp1xyLWcw==
Date:   Fri, 6 Jan 2023 14:13:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/9] tsnep: Add XDP TX support
Message-ID: <20230106141346.73f7c925@kernel.org>
In-Reply-To: <01d5398f-84a1-0fbe-e815-76f9f2c3e022@engleder-embedded.com>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
        <20230104194132.24637-5-gerhard@engleder-embedded.com>
        <0d4b78ab-603d-e39d-f804-4f5d2f8efab8@intel.com>
        <01d5398f-84a1-0fbe-e815-76f9f2c3e022@engleder-embedded.com>
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

On Thu, 5 Jan 2023 22:13:00 +0100 Gerhard Engleder wrote:
> >> -	if (entry->skb) {
> >> +	if (entry->skb || entry->xdpf) {
> >>   		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
> >>   		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
> >> -		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
> >> +		if (entry->type == TSNEP_TX_TYPE_SKB &&
> >> +		    skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)  
> > 
> > Please enclose bitops (& here) hanging around any logical ops (&& here
> > in their own set of braces ().  
> 
> Will be done.

Dunno if that's strictly required in the kernel coding style.
Don't we expect a good understanding of operator precedence
from people reading the code?
