Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AA96E509D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjDQTIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjDQTIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:08:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3036335A2;
        Mon, 17 Apr 2023 12:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB89F6208F;
        Mon, 17 Apr 2023 19:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA970C4339C;
        Mon, 17 Apr 2023 19:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681758519;
        bh=UueH1t+Mv4rXYKAFQryG7yFWxrdjovrCqKet7AaeWsQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lv6vdXCQWpn3i5GhRmjf3RTTVqEhhEmIBvPvjJqpHd5hU++AzyHRON6mVQMUESeBK
         ayPknegXEhSQciGFx9/L5u+a8/Vm9gdiyM+rPpJ+OaxzpZz6i67/KOulj16tExEznO
         1EOL7ZDuv3RemhxRChtrZxrxAge1J+S7inrbFa2zuQ1v6g/0UWp8xRnHZwL6xDo9jm
         9rApAM1eXfBdlM+Tfpcz2/O6STtx0r5UMKK/i+4hiZvp81KdtTMjDn4eBqEhSzTtYU
         U/VHyrwdgsss/LjKi4DObr3/Nja5aBrVKj03kF1yncZWx4wPBEUsTrAhjiKUndXSYd
         t2FbQhoQGxAMg==
Date:   Mon, 17 Apr 2023 12:08:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: Re: issue with inflight pages from page_pool
Message-ID: <20230417120837.6f1e0ef6@kernel.org>
In-Reply-To: <ZD2TH4PsmSNayhfs@lore-desk>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
        <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
        <ZD2NSSYFzNeN68NO@lore-desk>
        <20230417112346.546dbe57@kernel.org>
        <ZD2TH4PsmSNayhfs@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 20:42:39 +0200 Lorenzo Bianconi wrote:
> > Is drgn available for your target? You could try to scan the pages on
> > the system and see if you can find what's still pointing to the page
> > pool (assuming they are indeed leaked and not returned to the page
> > allocator without releasing :()  
> 
> I will test it but since setting sysctl_skb_defer_max to 0 fixes the issue,
> I think the pages are still properly linked to the pool, they are just not
> returned to it. I proved it using the other patch I posted [0] where I can see
> the counter of returned pages incrementing from time to time (in a very long
> time slot..).

If it's that then I'm with Eric. There are many ways to keep the pages
in use, no point working around one of them and not the rest :(

> Unrelated to this issue, but debugging it I think a found a page_pool leak in
> skb_condense() [1] where we can reallocate the skb data using kmalloc for a
> page_pool recycled skb.

I don't see a problem having pp_recycle = 1 and head in slab is legal.
pp_recycle just means that *if* a page is from the page pool we own 
the recycling reference. A page from slab will not be treated as a PP
page cause it doesn't have pp_magic set to the correct pattern.
