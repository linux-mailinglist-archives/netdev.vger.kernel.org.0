Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CA152E5E4
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346127AbiETHIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345936AbiETHIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:08:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7959614D790
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 00:08:10 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrwjr-0000vr-10; Fri, 20 May 2022 09:07:55 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrwjp-0008KI-GX; Fri, 20 May 2022 09:07:53 +0200
Date:   Fri, 20 May 2022 09:07:53 +0200
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
Subject: Re: [PATCH 05/10] rtw88: Do not access registers while atomic
Message-ID: <20220520070753.GC25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-6-s.hauer@pengutronix.de>
 <e33aaa2ab60e04d3449273e117ca73acb3895ed3.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e33aaa2ab60e04d3449273e117ca73acb3895ed3.camel@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:05:18 up 50 days, 19:34, 45 users,  load average: 0.35, 0.29,
 0.19
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

On Fri, May 20, 2022 at 06:06:05AM +0000, Pkshih wrote:
> On Wed, 2022-05-18 at 10:23 +0200, Sascha Hauer wrote:
> > The driver uses ieee80211_iterate_active_interfaces_atomic()
> > and ieee80211_iterate_stations_atomic() in several places and does
> > register accesses in the iterators. This doesn't cope with upcoming
>                                            ^^^^^^^ does?
> > USB support as registers can only be accessed non-atomically.
> > 
> > Split these into a two stage process: First use the atomic iterator
> > functions to collect all active interfaces or stations on a list, then
> > iterate over the list non-atomically and call the iterator on each
> > entry.
> 
> I think the subject could be "iterate over vif/sta list non-atomically"

Ok.

> > +void rtw_iterate_stas(struct rtw_dev *rtwdev,
> > +		      void (*iterator)(void *data,
> > +				       struct ieee80211_sta *sta),
> > +				       void *data)
> > +{
> > +	struct rtw_iter_stas_data iter_data;
> > +	struct rtw_stas_entry *sta_entry, *tmp;
> 
> lockdep_assert_held(&rtwdev->mutex);
> 
> > +
> > +	iter_data.rtwdev = rtwdev;
> > +	INIT_LIST_HEAD(&iter_data.list);
> > +
> > +	ieee80211_iterate_stations_atomic(rtwdev->hw, rtw_collect_sta_iter,
> > +					  &iter_data);
> > +
> > +	list_for_each_entry_safe(sta_entry, tmp, &iter_data.list,
> > +				 list) {
> > +		list_del_init(&sta_entry->list);
> > +		iterator(data, sta_entry->sta);
> > +		kfree(sta_entry);
> > +	}
> > +}
> > +
> 
> [...]
> 
> > +void rtw_iterate_vifs(struct rtw_dev *rtwdev,
> > +		      void (*iterator)(void *data, u8 *mac,
> > +				       struct ieee80211_vif *vif),
> > +		      void *data)
> > +{
> > +	struct rtw_iter_vifs_data iter_data;
> > +	struct rtw_vifs_entry *vif_entry, *tmp;
> 
> lockdep_assert_held(&rtwdev->mutex);

Ok, will add these. For what it's worth they didn't trigger in a short
test.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
