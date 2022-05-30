Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372AA53783E
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiE3Jwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiE3Jwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:52:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0C710FE5
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 02:52:45 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nvc4g-0008P8-Vu; Mon, 30 May 2022 11:52:34 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nvc4e-0007Yd-Tf; Mon, 30 May 2022 11:52:32 +0200
Date:   Mon, 30 May 2022 11:52:32 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 00/10] RTW88: Add support for USB variants
Message-ID: <20220530095232.GI1615@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <87fskrv0cm.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fskrv0cm.fsf@kernel.org>
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

On Mon, May 30, 2022 at 12:25:13PM +0300, Kalle Valo wrote:
> Sascha Hauer <s.hauer@pengutronix.de> writes:
> 
> > Another problem to address is that the driver uses
> > ieee80211_iterate_stations_atomic() and
> > ieee80211_iterate_active_interfaces_atomic() and does register accesses
> > in the iterator. This doesn't work with USB, so iteration is done in two
> > steps now: The ieee80211_iterate_*_atomic() functions are only used to
> > collect the stations/interfaces on a list which is then iterated over
> > non-atomically in the second step. The implementation for this is
> > basically the one suggested by Ping-Ke here:
> >
> > https://lore.kernel.org/lkml/423f474e15c948eda4db5bc9a50fd391@realtek.com/
> 
> Isn't this racy? What guarantees that vifs are not deleted after
> ieee80211_iterate_active_interfaces_atomic() call?

The driver mutex &rtwdev->mutex is acquired during the whole
collection/iteration process. For deleting an interface
ieee80211_ops::remove_interface would have to be called, right?
That would acquire &rtwdev->mutex as well, so I think this should be
safe.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
