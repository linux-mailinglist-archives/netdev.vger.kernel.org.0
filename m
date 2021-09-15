Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6501840CD16
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 21:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhIOTTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 15:19:35 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:37308 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhIOTTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 15:19:34 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9BD3A3EB3C;
        Wed, 15 Sep 2021 21:18:05 +0200 (CEST)
Date:   Wed, 15 Sep 2021 21:18:03 +0200
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus =?utf-8?Q?L=C3=BCssing?= <ll@simonwunderlich.de>
Subject: Re: [PATCH 3/3] ath9k: Fix potential hw interrupt resume during reset
Message-ID: <YUJGxZW1a+vlG335@sellars>
References: <20210914192515.9273-1-linus.luessing@c0d3.blue>
 <20210914192515.9273-4-linus.luessing@c0d3.blue>
 <255a49c7-d763-50d9-87e0-da22f4a9b053@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <255a49c7-d763-50d9-87e0-da22f4a9b053@nbd.name>
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 11:48:55AM +0200, Felix Fietkau wrote:
> 
> On 2021-09-14 21:25, Linus Lüssing wrote:
> > From: Linus Lüssing <ll@simonwunderlich.de>
> > 
> > There is a small risk of the ath9k hw interrupts being reenabled in the
> > following way:
> > 
> > 1) ath_reset_internal()
> >    ...
> >    -> disable_irq()
> >       ...
> >       <- returns
> > 
> >                       2) ath9k_tasklet()
> >                          ...
> >                          -> ath9k_hw_resume_interrupts()
> >                          ...
> > 
> > 1) ath_reset_internal() continued:
> >    -> tasklet_disable(&sc->intr_tq); (= ath9k_tasklet() off)
> > 
> > By first disabling the ath9k interrupt there is a small window
> > afterwards which allows ath9k hw interrupts being reenabled through
> > the ath9k_tasklet() before we disable this tasklet in
> > ath_reset_internal(). Leading to having the ath9k hw interrupts enabled
> > during the reset, which we should avoid.
> I don't see a way in which interrupts can be re-enabled through the
> tasklet. disable_irq disables the entire PCI IRQ (not through ath9k hw
> registers), and they will only be re-enabled by the corresponding
> enable_irq call.

Ah, okay, then I think I misunderstood the previous fixes to the
ath9k interrupt shutdown during reset here. I had only tested the
following diff and assumed that it were not okay to have the ath9k
hw interrupt registers enabled within the spinlock'd section:

```
@@ -299,11 +299,23 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 
        __ath_cancel_work(sc);
 
        disable_irq(sc->irq);
+       for (r = 0; r < 200; r++) {
+               msleep(5);
+
+               if (REG_READ(ah, AR_INTR_SYNC_CAUSE) ||
+                   REG_READ(ah, AR_INTR_ASYNC_CAUSE)) {
+                       break;
+               }
+       }
        tasklet_disable(&sc->intr_tq);
        tasklet_disable(&sc->bcon_tasklet);
        spin_lock_bh(&sc->sc_pcu_lock);
 
+       if (REG_READ(ah, AR_INTR_SYNC_CAUSE) ||
+           REG_READ(ah, AR_INTR_ASYNC_CAUSE))
+               ATH_DBG_WARN(1, "%s: interrupts are enabled", __func__);
+
        if (!sc->cur_chan->offchannel) {
                fastcc = false;
                caldata = &sc->cur_chan->caldata;
```

And yes, the general ath9k interrupt should still be disabled. Didn't
test for that but seems like it.


(And now I noticed that actually
 ath_reset_internal()
 -> ath_prepare_reset()
   -> ath9k_hw_disable_interrupts()
     -> ath9k_hw_kill_interrupts()
 disables the ath9k hw interrupt registers before the
 ath_reset_internal()->ath9k_hw_reset() call anyway.)


What would you prefer, should this patch just be dropped or should
I resend it without the "Fixes:" line as a cosmetic change? (e.g. to
have the order in reverse to reenablement at the end of
ath_reset_internal(), to avoid confusion in the future?)

Regards, Linus
