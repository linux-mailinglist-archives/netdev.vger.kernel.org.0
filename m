Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8446EAB22
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbjDUNA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjDUNA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:00:26 -0400
Received: from smtp1.lauterbach.com (smtp1.lauterbach.com [62.154.241.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926AE1A8
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 06:00:23 -0700 (PDT)
Received: (qmail 5752 invoked by uid 484); 21 Apr 2023 13:00:21 -0000
X-Qmail-Scanner-Diagnostics: from ingpc2.intern.lauterbach.com by smtp1.lauterbach.com (envelope-from <ingo.rohloff@lauterbach.com>, uid 484) with qmail-scanner-2.11 
 (mhr: 1.0. clamdscan: 0.99/21437. spamassassin: 3.4.0.  
 Clear:RC:1(10.2.10.44):. 
 Processed in 0.071332 secs); 21 Apr 2023 13:00:21 -0000
Received: from ingpc2.intern.lauterbach.com (Authenticated_SSL:irohloff@[10.2.10.44])
          (envelope-sender <ingo.rohloff@lauterbach.com>)
          by smtp1.lauterbach.com (qmail-ldap-1.03) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <kuba@kernel.org>; 21 Apr 2023 13:00:20 -0000
From:   Ingo Rohloff <ingo.rohloff@lauterbach.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Lars-Peter Clausen <lars@metafoo.de>,
        robert.hancock@calian.com, Nicolas.Ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, tomas.melin@vaisala.com,
        Ingo Rohloff <ingo.rohloff@lauterbach.com>
Subject: [PATCH v2 0/1] net: macb: Avoid erroneously stopped TX ring.
Date:   Fri, 21 Apr 2023 15:00:34 +0200
Message-Id: <20230421130035.14346-1-ingo.rohloff@lauterbach.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230411190715.6eefb4fa@kernel.org>
References: <20230411190715.6eefb4fa@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 19:07:15 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri,  7 Apr 2023 23:33:48 +0200 Ingo Rohloff wrote:
> > Analysis:
> > Commit 404cd086f29e867f ("net: macb: Allocate valid memory for TX and RX BD
> > prefetch") mentions:
> >
> >     GEM version in ZynqMP and most versions greater than r1p07 supports
> >     TX and RX BD prefetch. The number of BDs that can be prefetched is a
> >     HW configurable parameter. For ZynqMP, this parameter is 4.
> >
> > I think what happens is this:
> > Example Scenario (SW == linux kernel, HW == cadence ethernet IP).
> > 1) SW has written TX descriptors 0..7
> > 2) HW is currently transmitting TX descriptor 6.
> >    HW has already prefetched TX descriptors 6,7,8,9.
> > 3) SW writes TX descriptor 8 (clearing TX_USED)
> > 4) SW writes the TSTART bit.
> >    HW ignores this, because it is still transmitting.
> > 5) HW transmits TX descriptor 7.
> > 6) HW reaches descriptor 8; because this descriptor
> >    has already been prefetched, HW sees a non-active
> >    descriptor (TX_USED set) and stops transmitting.
>
> This sounds broken, any idea if this is how the IP is supposed to work
> or it may be an integration issue in Zynq?  The other side of this
> question is how expensive the workaround is - a spin lock and two extra
> register reads on completion seems like a lot.
>
> Roman, Lars, have you seen Tx stalls on your macb setups?

I think I finally was able to hunt down the exact conditions.
It seems to be simpler than I thought.
This also results in a completely modified patch and work-around.

As far as I can tell there is a race condition between HW and SW.
(TX descriptor 4 is just used as an example here):

1) HW has just read TX descriptor 4 (with set TX_USED bit).
   "Just read" means: The read data of the read transfer is
   in flight to the HW module.
   SW clears TX_USED bit of TX descriptor 4.

2) SW writes TSTART bit in NCR register.
   HW is still processing TX descriptor 4 (TGO bit in TSR still set)
   and thus ignores the TSTART trigger.

3) HW stops TX processing (TGO bit in TSR is cleared), because it
   sees the set TX_USED bit of the (previous) TX descriptor 4.

We now have got an active pending TX descriptor 4, but HW will not
restart transmission, because it ignored the corresponding
TSTART trigger.

I encountered the stuck TX descriptor state, when before:
1) TBQP register indicated HW reached the TX descriptor,
   where the TX_USED bit is just cleared by SW.
2) HW had a set TGO bit in the TSR register,
   which indicates HW is still processing the TX ring.

The patch I propose tries to ensure that the TSTART trigger
is not ignored.
The idea is if we have this condition

* The TGO bit is set in TSR
* The TBQP register points to the TX descriptor,
  where the TX_USED bit was just cleared.

then I assume we are in an unknown state:

* HW could either see the cleared TX_USED bit and continue, or
* HW could ignore the TSTART trigger and stop.

The patch tries to detect this condition in the new function
macb_fix_tstart_race().
If this unknown state is detected, the HW is rechecked until either
* The TBQP register points to a different descriptor (meaning
  the hardware is still actively processing the TX ring)
* The hardware indicates it has stopped processing via a
  cleared TGO bit in the TSR register.
  In this case the TSTART bit is written again.


Note: Cadence might be able to clear up under which circumstances
this race condition might happen.
On the Xilinx ZynqMP Ultrascale+ device I have here,
I for sure reach the line

    /* Controller stopped... write TSTART again.

in the patch; which indicates the code of the patch at least covers
a condition which happens in reality on this particular SoC.


regards
  Ingo


Ingo Rohloff (1):
  net: macb: Avoid erroneously stopped TX ring.

 drivers/net/ethernet/cadence/macb.h      |  1 -
 drivers/net/ethernet/cadence/macb_main.c | 94 +++++++++++++-----------
 2 files changed, 50 insertions(+), 45 deletions(-)

--
2.17.1

