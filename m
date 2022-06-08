Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A685E54318B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 15:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240447AbiFHNhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 09:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240446AbiFHNhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 09:37:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCD510636F
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 06:37:11 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nyvrp-0000O2-Dv; Wed, 08 Jun 2022 15:37:01 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nyvro-0000LI-95; Wed, 08 Jun 2022 15:37:00 +0200
Date:   Wed, 8 Jun 2022 15:37:00 +0200
From:   "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>
Subject: Re: [PATCH v2 05/10] rtw88: iterate over vif/sta list non-atomically
Message-ID: <20220608133700.GW1615@pengutronix.de>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
 <20220530135457.1104091-6-s.hauer@pengutronix.de>
 <CAFBinCDgErZzFs5NiDT0JAOhziz5WLiy0+yxF9Z-kXPxD1j8Dw@mail.gmail.com>
 <e0aa1ba4336ab130712e1fcb425e6fd0adca4145.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0aa1ba4336ab130712e1fcb425e6fd0adca4145.camel@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 01:25:34PM +0000, Ping-Ke Shih wrote:
> Hi Martin and Sascha,
> 
> Thank you both.
> 
> On Wed, 2022-06-08 at 00:06 +0200, Martin Blumenstingl wrote:
> > Hi Sascha,
> > 
> > thanks for this patch!
> > 
> > On Mon, May 30, 2022 at 3:55 PM Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > [...]
> > >  drivers/net/wireless/realtek/rtw88/phy.c  |   6 +-
> > >  drivers/net/wireless/realtek/rtw88/ps.c   |   2 +-
> > >  drivers/net/wireless/realtek/rtw88/util.c | 103 ++++++++++++++++++++++
> > >  drivers/net/wireless/realtek/rtw88/util.h |  12 ++-
> > >  4 files changed, 116 insertions(+), 7 deletions(-)
> > I compared the changes from this patch with my earlier work. I would
> > like to highlight a few functions to understand if they were left out
> > on purpose or by accident.
> > 
> > __fw_recovery_work() in main.c (unfortunately I am not sure how to
> > trigger/test this "firmware recovery" logic):
> 
> This can be triggered by 'echo 1 > /sys/kernel/debug/ieee80211/rtw88/fw_crash',
> but only the latest firmware of 8822c can support this.
> 
> > - this is already called with &rtwdev->mutex held
> > - it uses rtw_iterate_keys_rcu() (which internally uses rtw_write32
> > from rtw_sec_clear_cam). feel free to either add [0] to your series or
> > even squash it into an existing patch
> 
> ieee80211_iter_keys() check lockdep_assert_wiphy(hw->wiphy), but we don't
> hold the lock in this work; it also do mutex_lock(&local->key_mtx) that 
> I'm afraid it could cause deadlock.
>  
> So, I think we can use _rcu version to collect key list like sta and vif.
> 
> > - it uses rtw_iterate_stas_atomic() (which internally uses
> > rtw_fw_send_h2c_command from rtw_fw_media_status_report)
> > - it uses rtw_iterate_vifs_atomic() (which internally can read/write
> > registers from rtw_chip_config_bfee)
> > - in my previous series I simply replaced the
> > rtw_iterate_stas_atomic() and rtw_iterate_vifs_atomic() calls with the
> > non-atomic variants (for the rtw_iterate_keys_rcu() call I did some
> > extra cleanup, see [0])
> > 
> > rtw_wow_fw_media_status() in wow.c (unfortunately I am also not sure
> > how to test WoWLAN):
> > - I am not sure if &rtwdev->mutex is held when this function is called
> > - it uses rtw_iterate_stas_atomic() (which internally uses
> > rtw_fw_send_h2c_command from rtw_fw_media_status_report)
> > - in my previous series I simply replaced rtw_iterate_stas_atomic()
> > with it's non-atomic variant
> > 
> > Additionally I rebased my SDIO work on top of your USB series.
> > This makes SDIO support a lot easier - so thank you for your work!
> > I found that three of my previous patches (in addition to [0] which I
> > already mentioned earlier) are still needed to get rid of some
> > warnings when using the SDIO interface (the same warnings may or may
> > not be there with the USB interface - it just depends on whether your
> > AP makes rtw88 hit that specific code-path):
> > - [1]: rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
> 
> I think we need this.
> 
> > - [2]: rtw88: Move rtw_chip_cfg_csi_rate() out of rtw_vif_watch_dog_iter()
> 
> I think we don't need this, but just use rtw_iterate_vifs() to
> iterate rtw_vif_watch_dog_iter.
> 
> > - [3]: rtw88: Move rtw_update_sta_info() out of rtw_ra_mask_info_update_iter()
> 
> Need partial -- hold rtwdev->mutex before entering rtw_ra_mask_info_update().
> 
> Then, use rtw_iterate_stas() to iterate rtw_ra_mask_info_update_iter. 
> No need others.
> 
> 
> Sascha, could you squash Martin's patches into your patchset?
> And, then I can do more tests on PCI cards.

Yes, will do and send a v3 with it.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
