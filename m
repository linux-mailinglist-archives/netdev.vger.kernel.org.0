Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55E24F755F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 07:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240919AbiDGFdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 01:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbiDGFdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 01:33:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B606BD894;
        Wed,  6 Apr 2022 22:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD19FB826B8;
        Thu,  7 Apr 2022 05:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75EBC385A4;
        Thu,  7 Apr 2022 05:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649309504;
        bh=kZ4xvxYTVp/AgVCG+LNaH831+XO3cxHf1AnkJUAtjzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PC83kK1orbeSftoJA0VJHG+OwCc0N+NIOQof9rLBNhvUGCrR7tvWROjNDAfFnVBFa
         W1xhU+r+LcFOZsZQSzS0hWqqaF0v+7ALJaLk7iy0AzJd89d4J80XIYJhHN8GR82EyY
         uVwl/ePw+osNn7nEgrPtb7LuEeBZdBiQFyPS8/xJdpCAjJBKXZZFuPZtqniqdvWaAK
         tDWcmn312LH7p/gCHUsOJEY1jgvzw1mSSpl1+SOCsJ9m5tVxF5z6o8T9H04XwrB1/1
         00sSIYN0YfnITvgOcQ2Fgm1xDQwN0BYeTdX6tMpC7gWUnA3v+Hb5Njp9XieKdYzEhR
         aAhqXohnz9uTA==
Date:   Wed, 6 Apr 2022 22:31:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeffrey Ji <jeffreyji@google.com>
Subject: Re: [PATCH net-next] net-core: rx_otherhost_dropped to core_stats
Message-ID: <20220406223141.51881854@kernel.org>
In-Reply-To: <20220406172600.1141083-1-jeffreyjilinux@gmail.com>
References: <20220406172600.1141083-1-jeffreyjilinux@gmail.com>
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

On Wed,  6 Apr 2022 17:26:00 +0000 Jeffrey Ji wrote:
> From: Jeffrey Ji <jeffreyji@google.com>
> 
> Increment rx_otherhost_dropped counter when packet dropped due to
> mismatched dest MAC addr.
> 
> An example when this drop can occur is when manually crafting raw
> packets that will be consumed by a user space application via a tap
> device. For testing purposes local traffic was generated using trafgen
> for the client and netcat to start a server
> 
> Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> with "{eth(daddr=$INCORRECT_MAC...}", verified that iproute2 showed the
> counter was incremented. (Also had to modify iproute2 to show the stat,
> additional patch for that coming next.)
> 
> Signed-off-by: Jeffrey Ji <jeffreyji@google.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
