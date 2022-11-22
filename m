Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA55633441
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 04:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiKVDxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 22:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiKVDxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 22:53:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D51F2C658;
        Mon, 21 Nov 2022 19:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8AADB818E6;
        Tue, 22 Nov 2022 03:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C347DC433D6;
        Tue, 22 Nov 2022 03:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669089208;
        bh=XVAxFf7sfqLnakjDAGPZWBqHCkY1BQqClLMw5j03Bdc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JYjtjk+BrDJkD8UCnRzbmM3gemxRQpKqpneguyk/Z/kSH8bdwZTmJzC/14WEpFgAy
         zrp24LVkzKfoCHd3ec5idTz1M71PrU5BDhXCOGYtE4xvpPUhw9bwEexM+I3syXKgVW
         xdnextWa50X5fRfX3+93/LzIO3zoHSDlkjKT8kNapjn3bguPiCg9qFnMbQ9tZLNGY+
         cPEAeDoD1dyuIeGfEURE5cLad/Ic1ALgbj01qPDqla5ryCKlXL0LRB0JJOZt+n0Jps
         AbhOcSaZQVIDWDAf9kgBdK5ujyh9gZYa13rY3bOB37wJn/RbHfXQp459znpojinzoo
         Bi3frjrlvjyZQ==
Date:   Mon, 21 Nov 2022 19:53:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/5] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
Message-ID: <20221121195326.2632f138@kernel.org>
In-Reply-To: <5c899a02-cec1-07c9-1c1a-8747773ece0c@arista.com>
References: <20221115211905.1685426-1-dima@arista.com>
        <20221115211905.1685426-4-dima@arista.com>
        <20221118191809.0174f4da@kernel.org>
        <31efe48a-4c68-f17c-64ee-88d45f56c438@arista.com>
        <20221121124135.4015cc66@kernel.org>
        <5c899a02-cec1-07c9-1c1a-8747773ece0c@arista.com>
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

On Mon, 21 Nov 2022 20:56:18 +0000 Dmitry Safonov wrote:
> > Dunno from memory, too much happens in these files :S
> > 
> > Could you cherry-pick [1] onto net-next and see if 
> > 
> >   git am --no-3way patches/*
> > 
> > goes thru cleanly? If so no objections for the patches to go via tip,
> > we're close enough to the merge window.  
> 
> That did go cleanly for me on today's net-next/main.

Great, feel free to slap my:

Acked-by: Jakub Kicinski <kuba@kernel.org>

on v5. (But we'll still want a proper review from Eric.)
