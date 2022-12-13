Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57E464B3D8
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbiLMLKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiLMLKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:10:03 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04058193D8;
        Tue, 13 Dec 2022 03:09:31 -0800 (PST)
Date:   Tue, 13 Dec 2022 12:09:28 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, horms@verge.net.au, ja@ssi.bg,
        kadlec@netfilter.org, fw@strlen.de, jwiesner@suse.de,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net-next] ipvs: fix type warning in do_div() on 32 bit
Message-ID: <Y5hdaLpctttoNTLx@salvia>
References: <20221213032037.844517-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221213032037.844517-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Dec 12, 2022 at 07:20:37PM -0800, Jakub Kicinski wrote:
> 32 bit platforms without 64bit div generate the following warning:
> 
> net/netfilter/ipvs/ip_vs_est.c: In function 'ip_vs_est_calc_limits':
> include/asm-generic/div64.h:222:35: warning: comparison of distinct pointer types lacks a cast
>   222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
>       |                                   ^~
> net/netfilter/ipvs/ip_vs_est.c:694:17: note: in expansion of macro 'do_div'
>   694 |                 do_div(val, loops);
>       |                 ^~~~~~
> include/asm-generic/div64.h:222:35: warning: comparison of distinct pointer types lacks a cast
>   222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
>       |                                   ^~
> net/netfilter/ipvs/ip_vs_est.c:700:33: note: in expansion of macro 'do_div'
>   700 |                                 do_div(val, min_est);
>       |                                 ^~~~~~
> 
> first argument of do_div() should be unsigned. We can't just cast
> as do_div() updates it as well, so we need an lval.
> Make val unsigned in the first place, all paths check that the value
> they assign to this variables are non-negative already.

Your patch is very similar to what Julian posted:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20221212195845.101844-1-ja@ssi.bg/

Thanks.
