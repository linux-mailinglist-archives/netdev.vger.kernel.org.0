Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6030E52E568
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346069AbiETGyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346054AbiETGyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:54:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D7314E2E8
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 23:54:49 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrwWy-00071N-Bi; Fri, 20 May 2022 08:54:36 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrwWx-0006qD-69; Fri, 20 May 2022 08:54:35 +0200
Date:   Fri, 20 May 2022 08:54:35 +0200
From:   "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 02/10] rtw88: Drop rf_lock
Message-ID: <20220520065435.GB25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-3-s.hauer@pengutronix.de>
 <af80039404cb3eb9dd036ab5734ddea95d31cf49.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af80039404cb3eb9dd036ab5734ddea95d31cf49.camel@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:45:02 up 50 days, 19:14, 44 users,  load average: 0.02, 0.06,
 0.07
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

On Fri, May 20, 2022 at 03:49:06AM +0000, Pkshih wrote:
> On Wed, 2022-05-18 at 10:23 +0200, Sascha Hauer wrote:
> > The rtwdev->rf_lock spinlock protects the rf register accesses in
> > rtw_read_rf() and rtw_write_rf(). Most callers of these functions hold
> > rtwdev->mutex already with the exception of the callsites in the debugfs
> > code. The debugfs code doesn't justify an extra lock, so acquire the mutex
> > there as well before calling rf register accessors and drop the now
> > unnecessary spinlock.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/net/wireless/realtek/rtw88/debug.c | 11 +++++++++++
> >  drivers/net/wireless/realtek/rtw88/hci.h   |  9 +++------
> >  drivers/net/wireless/realtek/rtw88/main.c  |  1 -
> >  drivers/net/wireless/realtek/rtw88/main.h  |  3 ---
> >  4 files changed, 14 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/realtek/rtw88/debug.c
> > b/drivers/net/wireless/realtek/rtw88/debug.c
> > index 1a52ff585fbc7..ba5ba852efb8c 100644
> > --- a/drivers/net/wireless/realtek/rtw88/debug.c
> > +++ b/drivers/net/wireless/realtek/rtw88/debug.c
> > 
> 
> [...]
> 
> > @@ -523,6 +527,8 @@ static int rtw_debug_get_rf_dump(struct seq_file *m, void *v)
> >  	u32 addr, offset, data;
> >  	u8 path;
> >  
> > +	mutex_lock(&rtwdev->mutex);
> > +
> >  	for (path = 0; path < rtwdev->hal.rf_path_num; path++) {
> >  		seq_printf(m, "RF path:%d\n", path);
> >  		for (addr = 0; addr < 0x100; addr += 4) {
> > @@ -537,6 +543,8 @@ static int rtw_debug_get_rf_dump(struct seq_file *m, void *v)
> >  		seq_puts(m, "\n");
> >  	}
> >  
> > +	mutex_unlock(&rtwdev->mutex);
> > +
> >  	return 0;
> >  }
> > 
> 
> This will take time to dump all RF registers for debugging
> purpose. For PCI interface, I think this would be okay.
> Could you try to dump registers via debufs while you are
> using a USB WiFi device, such as play Youtube or download files...

I just did a ping and iperf test while doing a:

while true; do cat /sys/kernel/debug/ieee80211/phy0/rtw88/rf_dump ; done

The register dumping has no influence on neither the throughput or the
latency.

Adding some debugging to the mutex_lock also tells why: rtwdev->mutex
isn't acquired for normal rx/tx. It is only acquired every two seconds
or so.

So I would say adding the mutex_lock around the register dump is not a
problem. If latency is a concern we could still move the mutex_lock()
into the loop.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
