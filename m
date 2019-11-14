Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462F2FD084
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKNVpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:45:20 -0500
Received: from ns.lynxeye.de ([87.118.118.114]:55733 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726953AbfKNVpU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 16:45:20 -0500
Received: by lynxeye.de (Postfix, from userid 501)
        id D2B85E74222; Thu, 14 Nov 2019 22:45:18 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on lynxeye.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham version=3.3.1
Received: from radon.fritz.box (a89-183-75-168.net-htp.de [89.183.75.168])
        by lynxeye.de (Postfix) with ESMTPSA id BFF50E74217;
        Thu, 14 Nov 2019 22:45:17 +0100 (CET)
Message-ID: <fa7c3b9b24a0d140847f1390fb09bae21477ebd1.camel@lynxeye.de>
Subject: Re: long delays in rtl8723 drivers in irq disabled sections
From:   Lucas Stach <dev@lynxeye.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, wlanfae <wlanfae@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Thu, 14 Nov 2019 22:45:17 +0100
In-Reply-To: <a6d55cfc-9de9-ce6e-1dcf-814372772327@lwfinger.net>
References: <5de65447f1d115f436f764a7ec811c478afbe2e0.camel@lynxeye.de>
         <5B2DA6FDDF928F4E855344EE0A5C39D1D5C9CE47@RTITMBSVM04.realtek.com.tw>
         <e83f5b699c5652cbe2350ac3576215d24b748e03.camel@lynxeye.de>
         <5B2DA6FDDF928F4E855344EE0A5C39D1D5C9D5F6@RTITMBSVM04.realtek.com.tw>
         <a6d55cfc-9de9-ce6e-1dcf-814372772327@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Larry,

Am Donnerstag, den 14.11.2019, 15:25 -0600 schrieb Larry Finger:
[...]
> > > I don't know if this function needs to guard against something running
> > > in the IRQ handler, so depending on the answer to that the solution
> > > might be as simple as not disabling IRQs when taking the spinlock.
> > > 
> > > kworker/-276     4d...    0us : _raw_spin_lock_irqsave
> > > kworker/-276     4d...    0us : rtl8723_phy_rf_serial_read <-rtl8723de_phy_set_rf_reg
> > > kworker/-276     4d...    1us : rtl8723_phy_query_bb_reg <-rtl8723_phy_rf_serial_read
> > > kworker/-276     4d...    3us : rtl8723_phy_set_bb_reg <-rtl8723_phy_rf_serial_read
> > > kworker/-276     4d...    4us : __const_udelay <-rtl8723_phy_rf_serial_read
> > > kworker/-276     4d...    4us!: delay_mwaitx <-rtl8723_phy_rf_serial_read
> > > kworker/-276     4d... 1004us : rtl8723_phy_set_bb_reg <-rtl8723_phy_rf_serial_read
> > > [...]
> > > 
> > 
> > I check TX/RX interrupt handlers, and I don't find one calls RF read function
> > by now. I suspect that old code controls RF to do PS in interrupt context, so
> > _irqsave version is used to ensure read RF isn't interrupted or deadlock.
> > So, I change spin_lock to non-irqsave version, and do some tests on 8723BE
> > that works well.
> > 
> > What do you think about two fixes mentioned above? If they're ok, I can send
> > two patches to resolve this long delays.
> 
> Lucas,
> 
> If the above patch fixes the problem with the 8723de, I will modify the GitHub 
> driver. Although 8723de will be added to rtw88, I will keep the driver in 
> rtlwifi_new.

I'm currently running the rtlwifi_new based modules, modified with the
reduced waits as suggested by PK, as well as removing the IRQ disable
from the spinlocks in both rtl8723de_phy_query_rf_reg() and
rtl8723de_phy_set_rf_reg().

I can confirm that with those changes rtl8723de no longer shows up my
latency traces.

Regards,
Lucas

