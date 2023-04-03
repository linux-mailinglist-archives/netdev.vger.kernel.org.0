Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069766D4174
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjDCKA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjDCKAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:00:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C968AC5
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:00:53 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pjGzU-0006Ex-Sr; Mon, 03 Apr 2023 12:00:44 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pjGzT-0001wu-Dc; Mon, 03 Apr 2023 12:00:43 +0200
Date:   Mon, 3 Apr 2023 12:00:43 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, pkshih@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [PATCH v3 1/3] wifi: rtw88: Move register access from
 rtw_bf_assoc() outside the RCU
Message-ID: <20230403100043.GT19113@pengutronix.de>
References: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
 <20230108211324.442823-2-martin.blumenstingl@googlemail.com>
 <20230331125906.GF15436@pengutronix.de>
 <CAFBinCB8B4-oYaFY4p-20_PCWh_6peq75O9JjV6ZusVXPKSaDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFBinCB8B4-oYaFY4p-20_PCWh_6peq75O9JjV6ZusVXPKSaDw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Sat, Apr 01, 2023 at 11:30:40PM +0200, Martin Blumenstingl wrote:
> Hi Sascha,
> 
> On Fri, Mar 31, 2023 at 2:59 PM Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >
> > On Sun, Jan 08, 2023 at 10:13:22PM +0100, Martin Blumenstingl wrote:
> > > USB and (upcoming) SDIO support may sleep in the read/write handlers.
> > > Shrink the RCU critical section so it only cover the call to
> > > ieee80211_find_sta() and finding the ic_vht_cap/vht_cap based on the
> > > found station. This moves the chip's BFEE configuration outside the
> > > rcu_read_lock section and thus prevent "scheduling while atomic" or
> > > "Voluntary context switch within RCU read-side critical section!"
> > > warnings when accessing the registers using an SDIO card (which is
> > > where this issue has been spotted in the real world - but it also
> > > affects USB cards).
> >
> > Unfortunately this introduces a regression on my RTW8821CU chip. With
> > this it constantly looses connection to the AP and reconnects shortly
> > after:
> Sorry to hear this! This is odd and unfortunately I don't understand
> the reason for this.
> rtw_bf_assoc() is only called from
> drivers/net/wireless/realtek/rtw88/mac80211.c with rtwdev->mutex held.
> So I don't think that it's a race condition.
> 
> There's a module parameter which lets you enable/disable BF support:
> $ git grep rtw_bf_support drivers/net/wireless/realtek/rtw88/ | grep param
> drivers/net/wireless/realtek/rtw88/main.c:module_param_named(support_bf,
> rtw_bf_support, bool, 0644);

I was a bit too fast reporting this. Yes, there seems to be a problem
with the RTW8821CU, but it doesn't seem to be related to this patch.

Sorry for the noise.

The chipset seems to have problems with one access point that I have and
I can see these problems with or without the patch. Maybe NetworkManager
decided to connect to another accesspoint without me noticing it, making
it look to me as if this patch was guilty.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
