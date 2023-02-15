Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DDF697936
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbjBOJnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbjBOJno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:43:44 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C5B4ED3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:43:42 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pSEK4-00030C-W2; Wed, 15 Feb 2023 10:43:33 +0100
Date:   Wed, 15 Feb 2023 10:43:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com, fw@strlen.de
Subject: Re: [RFC] net: skbuff: let struct skb_ext live inside the head
Message-ID: <20230215094332.GB9908@breakpoint.cc>
References: <20230215034444.482178-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215034444.482178-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> This is a bit more crazy than the previous patch. For drivers
> which already use build_skb() it's relatively easy to add more
> space to the shinfo. Use this approach to place skb_ext inside
> the head. No allocation needed.
> 
> This approach is a bit slower in trivial benchmarks than the recycling
> because it requires extra cache line accesses (12.1% loss, ->18.6Gbps).
>
> In-place skb_ext may be shorter than a full skb_ext object.
> The driver only reserves space for exts it may use.
> Any later addition will reallocate the space via CoW,
> abandoning the in-place skb_ext and copying the data to
> a full slab object.

I think the cleaner solution would be to move the new extension ids
into sk_buff itself (at the end, uninitialized data unless used).

Those extensions would always reside there and not in the slab object.

Obviously that only makes sense for extensions where we assume
that typical workload will require them, which might be a hard call to
make.

I concur with Paolo that the napi-caching is nicer/less intrusive,
I think we have to wait and see if it helps with psp (async crypto
needed?) when it lands.
