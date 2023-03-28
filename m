Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586E76CCDBD
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjC1W6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjC1W63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C271172B;
        Tue, 28 Mar 2023 15:58:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 126236198E;
        Tue, 28 Mar 2023 22:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9F9C433EF;
        Tue, 28 Mar 2023 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680044307;
        bh=zLi38Xt9VsJj/nJhVMCROcthOPxshVt41T5fETfR7sc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J9GsfARBLOIO/j8qiK8ifgUVWcC9pgbha5FW5g4295bEv1isJRFE+fOktowrYJScz
         di5S0UMxYo4GLGOhL7XOvok9tZ+OLrkEsDDwpIfrV3VG+07fBgzCyndQTMaGt3LULt
         IGQs18SvDGOie0q5h7Hut9RQU7OLJZm8B3WJcqd6upSRIrfyQSWZXB1TK1mrkZqLQ2
         aWewjKi0IUVmqmpnPocm4YR6sUFKJIsj35t8RwF3CaXwThne8dFHdNFZCaYkXg6xNZ
         JNAVgmdSmhwMkDoc2QNYzNtcMpkZbClLy1ap41yJWA6IyiTJFDZe00huYQpRlHdRpF
         LEYE0XbPcHTVg==
Date:   Tue, 28 Mar 2023 15:58:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: traceability of wifi packet drops
Message-ID: <20230328155826.38e9e077@kernel.org>
In-Reply-To: <abcf4b9aed8adad05841234dad103ced15f9bfb2.camel@sipsolutions.net>
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
        <20230327180950.79e064da@kernel.org>
        <abcf4b9aed8adad05841234dad103ced15f9bfb2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 09:37:43 +0200 Johannes Berg wrote:
> > My knee jerk idea would be to either use the top 8 bits of the
> > skb reason enum to denote the space. And then we'd say 0 is core
> > 1 is wifi (enum ieee80211_rx_result) etc. Within the WiFi space 
> > you can use whatever encoding you like.  
> 
> Right. That's not _that_ far from what I proposed above, except you pull
> the core out 

Thinking about it again, maybe yours is actually cleaner.
Having the subsystem reason on the top bits, I mean.
That way after masking the specific bits out the lower bits
can still provide a valid "global" drop reason.

The UNUSABLE vs MONITOR bits I'd be tempted to put in the "global"
reason, but maybe that's not a great idea given Eric's concern :)

> > On a quick look nothing is indexed by the reason directly, so no
> > problems with using the high bits.  
> 
> I think you missed he drop_reasons[] array in skbuff.c, but I guess we
> could just not add these to the DEFINE_DROP_REASON() macro (and couldn't
> really add them anyway).
> 
> The only user seems to be drop_monitor, which anyway checks the array
> bounds (in the trace hit function.)
> 
> Or we change the design of this to actually have each subsystem provide
> an array/a callback for their namespace, if the strings are important?
> Some registration/unregistration might be needed for modules, but that
> could be done.

Right, drop monitor is good ol' kernel code, we can make it do whatever
we want. I was worried that tracing / BPF may tie our hands but they
support sparse enums just fine.
