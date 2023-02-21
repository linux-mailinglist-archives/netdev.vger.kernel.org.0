Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B241E69EB34
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 00:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjBUXZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 18:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBUXZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 18:25:44 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C07A030291;
        Tue, 21 Feb 2023 15:25:37 -0800 (PST)
Date:   Wed, 22 Feb 2023 00:25:34 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH] netfilter: fix percpu counter block leak on error path
 when creating new netns
Message-ID: <Y/VS7okXF1c6rN/I@salvia>
References: <20230213042505.334898-1-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230213042505.334898-1-ptikhomirov@virtuozzo.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 13, 2023 at 12:25:05PM +0800, Pavel Tikhomirov wrote:
> Here is the stack where we allocate percpu counter block:
> 
>   +-< __alloc_percpu
>     +-< xt_percpu_counter_alloc
>       +-< find_check_entry # {arp,ip,ip6}_tables.c
>         +-< translate_table
> 
> And it can be leaked on this code path:
> 
>   +-> ip6t_register_table
>     +-> translate_table # allocates percpu counter block
>     +-> xt_register_table # fails
> 
> there is no freeing of the counter block on xt_register_table fail.
> Note: xt_percpu_counter_free should be called to free it like we do in
> do_replace through cleanup_entry helper (or in __ip6t_unregister_table).
> 
> Probability of hitting this error path is low AFAICS (xt_register_table
> can only return ENOMEM here, as it is not replacing anything, as we are
> creating new netns, and it is hard to imagine that all previous
> allocations succeeded and after that one in xt_register_table failed).
> But it's worth fixing even the rare leak.

Any suggestion as Fixes: tag here? This issue seems to be rather old?
