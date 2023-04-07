Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573F26DB5D4
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjDGVkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjDGVkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:40:39 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 07 Apr 2023 14:40:35 PDT
Received: from smtp1.lauterbach.com (smtp1.lauterbach.com [62.154.241.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BE17683
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:40:35 -0700 (PDT)
Received: (qmail 11978 invoked by uid 484); 7 Apr 2023 21:33:51 -0000
X-Qmail-Scanner-Diagnostics: from ingpc2.intern.lauterbach.com by smtp1.lauterbach.com (envelope-from <ingo.rohloff@lauterbach.com>, uid 484) with qmail-scanner-2.11 
 (mhr: 1.0. clamdscan: 0.99/21437. spamassassin: 3.4.0.  
 Clear:RC:1(10.2.10.44):. 
 Processed in 0.070717 secs); 07 Apr 2023 21:33:51 -0000
Received: from ingpc2.intern.lauterbach.com (Authenticated_SSL:irohloff@[10.2.10.44])
          (envelope-sender <ingo.rohloff@lauterbach.com>)
          by smtp1.lauterbach.com (qmail-ldap-1.03) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <robert.hancock@calian.com>; 7 Apr 2023 21:33:48 -0000
From:   Ingo Rohloff <ingo.rohloff@lauterbach.com>
To:     robert.hancock@calian.com
Cc:     Nicolas.Ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tomas.melin@vaisala.com, Ingo Rohloff <ingo.rohloff@lauterbach.com>
Subject: [PATCH 0/1] Alternative, restart tx after tx used bit read
Date:   Fri,  7 Apr 2023 23:33:48 +0200
Message-Id: <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am sorry; this is a long E-Mail.

I am referring to this problem:

Robert Hancock wrote:
> On Wed, 2022-03-23 at 08:43 -0700, Jakub Kicinski wrote:
> > On Wed, 23 Mar 2022 10:08:20 +0200 Tomas Melin wrote:
> > > > From: Claudiu Beznea <claudiu.beznea@microchip.com>
> > > > 
> > > > On some platforms (currently detected only on SAMA5D4) TX might stuck
> > > > even the pachets are still present in DMA memories and TX start was
> > > > issued for them.
> > > > ...
> > > On Xilinx Zynq the above change can cause infinite interrupt loop
> > > leading to CPU stall.  Seems timing/load needs to be appropriate for
> > > this to happen, and currently with 1G ethernet this can be triggered
> > > normally within minutes when running stress tests on the network
> > > interface.
> > > ...
> > Which kernel version are you using?  Robert has been working on macb +
> > Zynq recently, adding him to CC.
> ...
> I haven't looked at the TX ring descriptor and register setup on this core
> in that much detail, but the fact the controller gets into this "TX used
> bit read" state in the first place seems unusual.  I'm wondering if
> something is being done in the wrong order or if we are missing a memory
> barrier etc?

I am developing on a ZynqMP (Ultrascale+) SoC from AMD/Xilinx.
I have seen the same issue before commit 4298388574dae6168 ("net: macb:
restart tx after tx used bit read")

The scenario which sometimes triggers it for me:

I have an application running on the PC.
The application sends a short command (via TCP) to the ZynqMP.
The ZynqMP answers with a long stream of bytes via TCP
(around 230KiB).
The PC knows the amount of data and waits to receive the data completely.
The PC gets stuck, because the last TCP segment of the transfer gets
stuck in the ZynqMP and is not transmitted.
You can re-trigger the TX Ring by pinging the ZynqMP:
The Ping answer will re-trigger the TX ring, which in turn will also
then send the stuck IP/TCP packet.

Unfortunately triggering this problem seems to be hard; at least I am 
not able to reproduce it easily.

So: If anyone has a more reliable way to trigger the problem, 
please tell me.
This is to check if my proposed alternative works under all circumstances.

I have an alternate implementation, which does not require to turn on
the "TX USED BIT READ" (TUBR) interrupt.
The reason why I think this alternative might be better is, because I
believe the TUBR interrupt happens at the wrong time; so I am not sure
that the current implementation works reliably.

Analysis:
Commit 404cd086f29e867f ("net: macb: Allocate valid memory for TX and RX BD
prefetch") mentions:

    GEM version in ZynqMP and most versions greater than r1p07 supports
    TX and RX BD prefetch. The number of BDs that can be prefetched is a
    HW configurable parameter. For ZynqMP, this parameter is 4.

I think what happens is this:
Example Scenario (SW == linux kernel, HW == cadence ethernet IP).
1) SW has written TX descriptors 0..7
2) HW is currently transmitting TX descriptor 6.
   HW has already prefetched TX descriptors 6,7,8,9.
3) SW writes TX descriptor 8 (clearing TX_USED)
4) SW writes the TSTART bit.
   HW ignores this, because it is still transmitting.
5) HW transmits TX descriptor 7.
6) HW reaches descriptor 8; because this descriptor
   has already been prefetched, HW sees a non-active
   descriptor (TX_USED set) and stops transmitting.

From debugging the code it seems that the TUBR interrupt happens, when
a descriptor is prefetched, which has a TX_USED bit set, which is before
it is processed by the rest of the hardware:
When looking at the end of a transfer it seems I get a TUBR interrupt,
followed by some more TX COMPLETE interrupts.

Additionally that means at the time the TUBR interrupt happens, it
is too early to write the TSTART bit again, because the hardware is
still actively transmitting.

The alternative I implemented is to check in macb_tx_complete() if

1) The TX Queue is non-empty (there are pending TX descriptors)
2) The hardware indicates that it is not transmitting any more

If this situation is detected, the TSTART bit will be written to
restart the TX ring.

I know for sure, that I hit the code path, which restarts the 
transmission in macb_tx_complete(); that's why I believe the
"Example Scenario" I described above is correct.

I am still not sure if what I implemented is enough:
macb_tx_complete() should at least see all completed TX descriptors.
I still believe there is a (very short) time window in which there
might be a race:
1) HW completes TX descriptor 7 and sets the TX_USED bit
   in TX descriptor 7.
   TX descriptor 8 was prefetched with a set TX_USED bit.
2) SW sees that TX descriptor 7 is completed
   (TX_USED bit now is set).
3) SW sees that there still is a pending TX descriptor 8.
4) SW checks if the TGO bit is still set, which it is.
   So the SW does nothing at this point.
5) HW processes the prefetched,set TX_USED bit in
   TX descriptor 8 and stops transmission (clearing the TGO bit).

I am not sure if it is guaranteed that 5) cannot happen after 4).  If 5)
happens after 4) as described above, then the controller still gets stuck.
The only idea I can come up with, is to re-check the TGO bit
a second time a little bit later, but I am not sure how to
implement this.

Is there anyone who has access to hardware documentation, which
sheds some light onto the way the descriptor prefetching works?

so long
  Ingo


Ingo Rohloff (1):
  net: macb: A different way to restart a stuck TX descriptor ring.

 drivers/net/ethernet/cadence/macb.h      |  1 -
 drivers/net/ethernet/cadence/macb_main.c | 67 +++++++++---------------
 2 files changed, 24 insertions(+), 44 deletions(-)

-- 
2.17.1

