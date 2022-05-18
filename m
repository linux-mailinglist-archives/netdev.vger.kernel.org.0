Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242CC52B1C6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 07:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiERFGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 01:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiERFGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 01:06:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DDA6163E;
        Tue, 17 May 2022 22:06:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 367DEB81D9D;
        Wed, 18 May 2022 05:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66319C385A9;
        Wed, 18 May 2022 05:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652850364;
        bh=N4r7WJWhhRNnKb59gLRfEn6OU/D10G4MYLVP2WxWL7o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pupY0Aq6EYpZAWIpEigrfJF4MbHVFy3akCBPaxHWwS9Lc+5gHfsGTNkxnBGX31wWA
         H4NVKPU8/fEK+QRHViiuBnZ0U938JJDNH0QLGLJOuvfcz8gDxpkrCp3gBpk/OpCvM9
         4TbHMTSAUs8eJ3SUiUFia9YAUC56zlcc+yQc/XehB8NMjOz3N8CWNDfwrwzFlTHaeu
         f43fjUCWi+Rr09VV3eor6ZPnGpXBcjAd1YRArI6v4H+a+ZTm5m+eeI38AfrIhRMjbu
         Pw3mLQDycb0N8kmDrRk7KZsSb6cNyqbP0l9lwfSVSyM0RfT0OmqxCmgDCTy42qQmGA
         +0EAY3uXYqdcg==
Date:   Tue, 17 May 2022 22:06:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harini Katakam <harinik@xilinx.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH 1/3] net: macb: Fix PTP one step sync support
Message-ID: <20220517220603.36eec66e@kernel.org>
In-Reply-To: <CAFcVEC+qdouQ+tJdBG_Vv8QsaUX99uFtjKnB5WwQawA1fxmgEQ@mail.gmail.com>
References: <20220517073259.23476-1-harini.katakam@xilinx.com>
        <20220517073259.23476-2-harini.katakam@xilinx.com>
        <20220517194254.015e87f3@kernel.org>
        <CAFcVEC+qdouQ+tJdBG_Vv8QsaUX99uFtjKnB5WwQawA1fxmgEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 09:53:29 +0530 Harini Katakam wrote:
> On Wed, May 18, 2022 at 8:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 17 May 2022 13:02:57 +0530 Harini Katakam wrote:  
> > > PTP one step sync packets cannot have CSUM padding and insertion in
> > > SW since time stamp is inserted on the fly by HW.
> > > In addition, ptp4l version 3.0 and above report an error when skb
> > > timestamps are reported for packets that not processed for TX TS
> > > after transmission.
> > > Add a helper to identify PTP one step sync and fix the above two
> > > errors.
> > > Also reset ptp OSS bit when one step is not selected.
> > >
> > > Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
> > > Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")  
> >
> > Please make sure to CC authors of the patches under fixes.
> > ./scripts/get_maintainer should point them out.  
> 
> Thanks for the review.
> Rafal Ozieblo <rafalo@cadence.com> is the author of the first Fixes
> patch but that
> address hasn't worked in the last ~4 yrs.
> I have cced Claudiu and everyone else from the maintainers
> (Eric Dumazet <edumazet@google.com> also doesn't work)

I see, thanks, added Rafal's email to the ignore list, 
I'm quite sure Eric's email address works.

> > > @@ -1158,13 +1192,14 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
> > >
> > >                       /* First, update TX stats if needed */
> > >                       if (skb) {
> > > -                             if (unlikely(skb_shinfo(skb)->tx_flags &
> > > -                                          SKBTX_HW_TSTAMP) &&
> > > -                                 gem_ptp_do_txstamp(queue, skb, desc) == 0) {
> > > -                                     /* skb now belongs to timestamp buffer
> > > -                                      * and will be removed later
> > > -                                      */
> > > -                                     tx_skb->skb = NULL;
> > > +                             if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&  
> >
> > ptp_oss already checks if HW_TSTAMP is set.  
> 
> The check for SKBTX_HW_TSTAMP is required here universally and not
> just inside ptp_oss.
> I will remove the redundant check in ptp_oss instead. Please see the
> reply below.

But then you need to add this check in the padding/fcs call site and
the place where NOCRC is set. If you wrap the check for SKBTX_HW_TSTAMP
in the helper with likely() and remove the inline - will the compiler
not split the function and inline just that check? And leave the rest
as a functionname.part... thing?
