Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A735CFD044
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKNVYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:24:48 -0500
Received: from ns.lynxeye.de ([87.118.118.114]:55150 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726592AbfKNVYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 16:24:48 -0500
Received: by lynxeye.de (Postfix, from userid 501)
        id E72EBE74222; Thu, 14 Nov 2019 22:24:46 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on lynxeye.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham version=3.3.1
Received: from radon.fritz.box (a89-183-75-168.net-htp.de [89.183.75.168])
        by lynxeye.de (Postfix) with ESMTPSA id 2CCB1E74217;
        Thu, 14 Nov 2019 22:24:45 +0100 (CET)
Message-ID: <b82d44f4f9aba24b649f85b3196955ad31124477.camel@lynxeye.de>
Subject: Re: long delays in rtl8723 drivers in irq disabled sections
From:   Lucas Stach <dev@lynxeye.de>
To:     Pkshih <pkshih@realtek.com>, wlanfae <wlanfae@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Thu, 14 Nov 2019 22:24:44 +0100
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D1D5C9D5F6@RTITMBSVM04.realtek.com.tw>
References: <5de65447f1d115f436f764a7ec811c478afbe2e0.camel@lynxeye.de>
         <5B2DA6FDDF928F4E855344EE0A5C39D1D5C9CE47@RTITMBSVM04.realtek.com.tw>
         <e83f5b699c5652cbe2350ac3576215d24b748e03.camel@lynxeye.de>
         <5B2DA6FDDF928F4E855344EE0A5C39D1D5C9D5F6@RTITMBSVM04.realtek.com.tw>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, den 14.11.2019, 01:41 +0000 schrieb Pkshih:
> > -----Original Message-----
> > From: Lucas Stach [mailto:dev@lynxeye.de]
> > Sent: Thursday, November 14, 2019 6:11 AM
> > To: Pkshih; wlanfae
> > Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org
> > Subject: Re: long delays in rtl8723 drivers in irq disabled sections
> > 
> > Hi PK,
> > 
> > Am Mittwoch, den 13.11.2019, 03:43 +0000 schrieb Pkshih:
> > > > -----Original Message-----
> > > > From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On
> > Behalf
> > > > Of Lucas Stach
> > > > Sent: Wednesday, November 13, 2019 5:02 AM
> > > > To: wlanfae; Pkshih
> > > > Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org
> > > > Subject: long delays in rtl8723 drivers in irq disabled sections
> > > > 
> > > > Hi all,
> > > > 
> > > > while investigating some latency issues on my laptop I stumbled across
> > > > quite large delays in the rtl8723 PHY code, which are done in IRQ
> > > > disabled atomic sections, which is blocking IRQ servicing for all
> > > > devices in the system.
> > > > 
> > > > Specifically there are 3 consecutive 1ms delays in
> > > > rtl8723_phy_rf_serial_read(), which is used in an IRQ disabled call
> > > > path. Sadly those delays don't have any comment in the code explaining
> > > > why they are needed. I hope that anyone can tell if those delays are
> > > > strictly neccessary and if so if they really need to be this long.
> > > > 
> > > 
> > > These delays are because read RF register is an indirect access that hardware
> > > needs time to accomplish read action, but there's no ready bit, so delay
> > > is required to guarantee the read value is correct.
> > 
> > Thanks for the confirmation, I suspected something like this.
> > 
> > > It is possible to use smaller delay, but it's exactly required.
> > 
> > 1ms seems like an eternity on modern hardware, even for an indirect
> > read.
> > 
> 
> For 8723be, three 1ms delays can be replaced by one 120us delay, likes
> 
> @@ -89,12 +89,10 @@ u32 rtl8723_phy_rf_serial_read(struct ieee80211_hw *hw,
>             (newoffset << 23) | BLSSIREADEDGE;
>         rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD,
>                       tmplong & (~BLSSIREADEDGE));
> -       mdelay(1);
>         rtl_set_bbreg(hw, pphyreg->rfhssi_para2, MASKDWORD, tmplong2);
> -       mdelay(1);
>         rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD,
>                       tmplong | BLSSIREADEDGE);
> -       mdelay(1);
> +       udelay(120);
>         if (rfpath == RF90_PATH_A)
>                 rfpi_enable = (u8) rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER1,
>                                                  BIT(8));
> 
> I think it'd be better.

Yes, that looks much better. Even better would be a small comment on
how you arrived at 120us. Some internal documentation, or is this
mostly empirical?

> > > An alternative way is to prevent calling this function in IRQ disabled flow.
> > > Could you share the calling trace?
> > 
> > Sure, trimmed callstack below. As you can see the IRQ disabled section
> > is started via a spin_lock_irqsave(). The trace is from a 8723de
> > module, which is still out of tree, but the same code is present in
> > mainline and used by the other 8723 variants.
> 
> By now, 8723DE will be upstream through rtw88 instead of rtlwifi.

I haven't seen any patches for this particular chip yet. Is there any
roadmap on when we can expect this support to be added to the upstream
rtw88 driver?

> > I don't know if this function needs to guard against something running
> > in the IRQ handler, so depending on the answer to that the solution
> > might be as simple as not disabling IRQs when taking the spinlock.
> > 
> > kworker/-276     4d...    0us : _raw_spin_lock_irqsave
> > kworker/-276     4d...    0us : rtl8723_phy_rf_serial_read <-rtl8723de_phy_set_rf_reg
> > kworker/-276     4d...    1us : rtl8723_phy_query_bb_reg <-rtl8723_phy_rf_serial_read
> > kworker/-276     4d...    3us : rtl8723_phy_set_bb_reg <-rtl8723_phy_rf_serial_read
> > kworker/-276     4d...    4us : __const_udelay <-rtl8723_phy_rf_serial_read
> > kworker/-276     4d...    4us!: delay_mwaitx <-rtl8723_phy_rf_serial_read
> > kworker/-276     4d... 1004us : rtl8723_phy_set_bb_reg <-rtl8723_phy_rf_serial_read
> > [...]
> > 
> 
> I check TX/RX interrupt handlers, and I don't find one calls RF read function
> by now. I suspect that old code controls RF to do PS in interrupt context, so
> _irqsave version is used to ensure read RF isn't interrupted or deadlock.
> So, I change spin_lock to non-irqsave version, and do some tests on 8723BE
> that works well. 
> 
> What do you think about two fixes mentioned above? If they're ok, I can send
> two patches to resolve this long delays.

Yes, both changes do make sense to me. If we can avoid an unnecessary
IRQ disable we should do so. Even then shrinking the waits to bare
minimum as required by the hardware seems to be a good thing,
especially since the wait is still done under a spinlock, so can not
use a sleeping wait.

Regards,
Lucas

