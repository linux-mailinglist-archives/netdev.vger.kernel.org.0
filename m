Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775C06F29D0
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjD3RJr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 30 Apr 2023 13:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjD3RJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:09:46 -0400
Received: from synguard (unknown [212.29.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD8E1726;
        Sun, 30 Apr 2023 10:09:44 -0700 (PDT)
Received: from [192.168.42.187] (T14.siklu.local [192.168.42.187])
        by synguard (Postfix) with ESMTP id ECF5C4E4DF;
        Sun, 30 Apr 2023 20:09:42 +0300 (IDT)
Message-ID: <311d3b9816d40311acdbc4bb1c793ff75972923a.camel@siklu.com>
Subject: Re: [PATCH v3 1/3] net: mvpp2: tai: add refcount for ptp worker
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Date:   Sun, 30 Apr 2023 20:09:42 +0300
In-Reply-To: <20230420202003.1e9af9e0@kernel.org>
References: <20230419151457.22411-1-shmuel.h@siklu.com>
         <20230419151457.22411-2-shmuel.h@siklu.com>
         <20230420202003.1e9af9e0@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,RDNS_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-20 at 20:20 -0700, Jakub Kicinski wrote:
> > Caution: This is an external email. Please take care when clicking
> > links or opening attachments.
> > 
> > 
> > On Wed, 19 Apr 2023 18:14:55 +0300 Shmuel Hazan wrote:
> > > > +static void mvpp22_tai_stop_unlocked(struct mvpp2_tai *tai)
> > > > +{
> > > > +     tai->poll_worker_refcount--;
> > > > +     if (tai->poll_worker_refcount)
> > > > +             return;
> > > > +     ptp_cancel_worker_sync(tai->ptp_clock);
> > 
> > How can you cancel it _sync() when the work takes the same
> > lock you're already holding?
> > 
> > https://elixir.bootlin.com/linux/v6.3-rc7/source/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c#L246


Hi Jakub,

Thanks for finding that. Strange that I have not encountered any
deadlocks while testing; I will apply a fix and resend after testing
it.  

> > 
> > > >  void mvpp22_tai_stop(struct mvpp2_tai *tai)
> > > >  {
> > > > -     ptp_cancel_worker_sync(tai->ptp_clock);
> > > > +     unsigned long flags;
> > > > +
> > > > +     spin_lock_irqsave(&tai->lock, flags);
> > > > +     mvpp22_tai_stop_unlocked(tai);
> > 
> > --
> > pw-bot: cr



