Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8006A6995C5
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjBPN2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBPN2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:28:43 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E61C564AB
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:28:42 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pSeJP-0004du-GY; Thu, 16 Feb 2023 14:28:35 +0100
Date:   Thu, 16 Feb 2023 14:28:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com
Subject: Re: [RFC] net: skbuff: let struct skb_ext live inside the head
Message-ID: <20230216132835.GA14032@breakpoint.cc>
References: <20230215034444.482178-1-kuba@kernel.org>
 <20230215094332.GB9908@breakpoint.cc>
 <20230215101356.3b86c451@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215101356.3b86c451@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 15 Feb 2023 10:43:32 +0100 Florian Westphal wrote:
> > I think the cleaner solution would be to move the new extension ids
> > into sk_buff itself (at the end, uninitialized data unless used).
> > 
> > Those extensions would always reside there and not in the slab object.
> 
> Do you mean the entire extension? 8B of metadata + (possibly) 32B 
> of the key?

32B is too much if its for something esoteric, but see below.

> > Obviously that only makes sense for extensions where we assume
> > that typical workload will require them, which might be a hard call to
> > make.
> 
> I'm guessing that's the reason why Google is okay with putting the key
> in the skb - they know they will use it most of the time. But an
> average RHEL user may appreciate the skb growth for an esoteric protocol
> to a much smaller extent :(

Absolutely, I agree that its a non-starter to place this in sk_buff
itself.  TX side is less of a problem here because of superpackets.

For RX I think your simpler napi-recycle patch is a good start.
I feel its better to wait before doing anything further in this
direction (e.g. array-of-cached extensions or whatever) until we've
a better test case/more realistic workload(s).

If we need to look at further allocation avoidances one thing that
could be evaluated would be placing an extension struct into
sk_buff_fclones (unioned with the fclone skb).
Fclone skb is marked busy, extension release clears it again.

Just something to keep in mind for later. Only downside I see is that
we can't release the extension area anymore before the skb gets queued.
