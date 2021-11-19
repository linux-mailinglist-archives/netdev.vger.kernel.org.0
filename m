Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B72457690
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbhKSSot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:44:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234697AbhKSSos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 13:44:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D943C6138D;
        Fri, 19 Nov 2021 18:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637347306;
        bh=VDecXgh+gqvqzCSucgweelQi68hZPxtxs57AziUhTGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XGKJLsInYofTjadHspqU2HMfhVAxZ0KFwOgGw3bOS+PJxQb+ntU4Jsq1bKfRCn64c
         jKMUrAvj/VPf+4a09Sbbk2AIlSG6+vJ1yF8CnG45d00dtnM3SWJnLqx4UaImWZh59E
         CddibKZFfXfs0Zq0T517uzJiFW44XZvct8zA/awaC3bPcipPhpecHeCwo6Zr9zfwKS
         tx+uW5t+z+fwteKFx/qOeKGsVjcwrb6uyfwCn0k6w7FMfDBjJKJCtQ29LQoqOC0pp4
         Ua3mRa7JwTDQ1ERiy8D0WCG+BEOjsg2BSDfk++IVcUV+TeNgEaYpmlD49gicMuI24I
         e3T0V+QclMpgg==
Date:   Fri, 19 Nov 2021 10:41:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] skbuff: Switch structure bounds to struct_group()
Message-ID: <20211119104144.7cb1eac6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <202111191015.509A0BD@keescook>
References: <20211118183615.1281978-1-keescook@chromium.org>
        <20211118231355.7a39d22f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <202111191015.509A0BD@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 10:26:19 -0800 Kees Cook wrote:
> On Thu, Nov 18, 2021 at 11:13:55PM -0800, Jakub Kicinski wrote:
> > On Thu, 18 Nov 2021 10:36:15 -0800 Kees Cook wrote:  
> > > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > > field bounds checking for memcpy(), memmove(), and memset(), avoid
> > > intentionally writing across neighboring fields.
> > > 
> > > Replace the existing empty member position markers "headers_start" and
> > > "headers_end" with a struct_group(). This will allow memcpy() and sizeof()
> > > to more easily reason about sizes, and improve readability.
> > > 
> > > "pahole" shows no size nor member offset changes to struct sk_buff.
> > > "objdump -d" shows no object code changes (outside of WARNs affected by
> > > source line number changes).  
> > 
> > This adds ~27k of these warnings to W=1 gcc builds:
> > 
> > include/linux/skbuff.h:851:1: warning: directive in macro's argument list  
> 
> Hrm, I can't reproduce this, using several GCC versions and net-next. What
> compiler version[1] and base commit[2] were used here?

gcc version 11.2.1 20210728 (Red Hat 11.2.1-1) (GCC) 

HEAD was at: 3b1abcf12894 Merge tag 'regmap-no-bus-update-bits' of git://...

> [1] https://github.com/kuba-moo/nipa/pull/10
> [2] https://github.com/kuba-moo/nipa/pull/11

Thanks for these! Will pull in as soon as the bot finishes with what
it's chewing on right now.
