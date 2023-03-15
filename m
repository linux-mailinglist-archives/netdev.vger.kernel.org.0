Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF7B6BC0AB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjCOXLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjCOXLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:11:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A208C0DD;
        Wed, 15 Mar 2023 16:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2413FB81F88;
        Wed, 15 Mar 2023 23:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892C1C433EF;
        Wed, 15 Mar 2023 23:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921903;
        bh=WgX41G45vYsJWYY541lPkRVg8AlTR5oFGJx5n2hTA1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jb6y7vbppnpqBBv+PodByRsxOs+l2UxI6bfdkl0eUDDZJT2phxXBqnIyH6gkJsEOs
         4y6I257ZU9zCe0x/5t6CxPxJDI6en87uUM58Ou7OGn9CcNxv87HYhzUDXlNPw3bC00
         hkSd3gPnDJNWyNFGKw5jeRFPKreiGbB895gC5pBl5vq0g/DkIjjmBhe1BQGVL1yR3L
         yoCrTYoq1kaqwTUjng5hHmF5hswaXFzGPvHZF1/htbuRDSRVq4RrFZlJqnPWe7w/rp
         hIfUrINhj71qs8N/Wg69HD4HQKygp5r3DO4KsJjpTeJKBQ+bRDaYjxxVJqJrXx8SDr
         SKo6/d60xk9zw==
Date:   Wed, 15 Mar 2023 16:11:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230315161142.48de9d98@kernel.org>
In-Reply-To: <20230315155202.2bba7e20@hermes.local>
References: <20230315223044.471002-1-kuba@kernel.org>
        <20230315155202.2bba7e20@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 15:52:02 -0700 Stephen Hemminger wrote:
> On Wed, 15 Mar 2023 15:30:44 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > Add basic documentation about NAPI. We can stop linking to the ancient
> > doc on the LF wiki.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > CC: jesse.brandeburg@intel.com
> > CC: anthony.l.nguyen@intel.com
> > CC: corbet@lwn.net
> > CC: linux-doc@vger.kernel.org  
> 
> The one thing missing, is how to handle level vs edge triggered interrupts.
> For level triggered interrupts, the re-enable is inherently not racy.
> I.e re-enabling interrupt when packet is present will cause an interrupt.
> But for devices with edge triggered interrupts, it is often necessary to
> poll and manually schedule again. Older documentation referred to this
> as the "rotten packet" problem.
> 
> Maybe this is no longer a problem for drivers?
> Or maybe all new hardware uses PCI MSI and is level triggered?

It's still a problem depending on the exact design of the interrupt
controller in the chip / tradeoffs the SW wants to make.
I haven't actually read the LF doc, because I wasn't sure about the
licenses (sigh). The rotten packet problem does not come up in reviews
very often, so it wasn't front of mind. I'm not sure I'd be able to
concisely describe it, actually :S There are many races and conditions
which can lead to it.
