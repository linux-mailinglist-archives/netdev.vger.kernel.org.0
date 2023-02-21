Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B059A69EB2D
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 00:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjBUXYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 18:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBUXYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 18:24:17 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A07B71F4AF;
        Tue, 21 Feb 2023 15:24:16 -0800 (PST)
Date:   Wed, 22 Feb 2023 00:24:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH nf] netfilter: use skb len to match in length_mt6
Message-ID: <Y/VSnV8FFRWU4TzC@salvia>
References: <361acd69270a8c2746da5774644dda9147b407a1.1676676177.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <361acd69270a8c2746da5774644dda9147b407a1.1676676177.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 06:22:57PM -0500, Xin Long wrote:
> For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
> and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
> length for the jumbo packets, it may mismatch.
> 
> To fix this, we can just use skb->len instead of parsing exthdrs, as
> the hbh exthdr parsing has been done before coming to length_mt6 in
> ip6_rcv_core() and br_validate_ipv6() and also the packet has been
> trimmed according to the correct IPv6 (ext)hdr length there, and skb
> len is trustable in length_mt6().
> 
> Note that this patch is especially needed after the IPv6 BIG TCP was
> supported in kernel, which is using IPv6 Jumbo packets. Besides, to
> match the packets greater than 65535 more properly, a v1 revision of
> xt_length may be needed to extend "min, max" to u32 in the future,
> and for now the IPv6 Jumbo packets can be matched by:
> 
>   # ip6tables -m length ! --length 0:65535

Applied, thanks
