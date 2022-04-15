Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A9350261C
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 09:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350971AbiDOHXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 03:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350949AbiDOHWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 03:22:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C204C2FE58
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 00:20:02 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nfGF5-0002Un-O5; Fri, 15 Apr 2022 09:19:43 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nfGF1-0005Kb-US; Fri, 15 Apr 2022 09:19:39 +0200
Date:   Fri, 15 Apr 2022 09:19:39 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        USB <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
Message-ID: <20220415071939.GB27951@pengutronix.de>
References: <20220409120901.267526-1-dzm91@hust.edu.cn>
 <YlQbqnYP/jcYinvz@hovoldconsulting.com>
 <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:17:12 up 15 days, 19:46, 42 users,  load average: 0.02, 0.08,
 0.16
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
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

On Thu, Apr 14, 2022 at 06:01:57PM +0300, Andy Shevchenko wrote:
> On Mon, Apr 11, 2022 at 9:33 PM Johan Hovold <johan@kernel.org> wrote:
> > On Sat, Apr 09, 2022 at 08:09:00PM +0800, Dongliang Mu wrote:
> > > From: Dongliang Mu <mudongliangabcd@gmail.com>
> > >
> > > cdc_ncm_bind calls cdc_ncm_bind_common and sets dev->data[0]
> > > with ctx. However, in the unbind function - cdc_ncm_unbind,
> > > it calls cdc_ncm_free and frees ctx, leaving dev->data[0] as
> > > a dangling pointer. The following ioctl operation will trigger
> > > the UAF in the function cdc_ncm_set_dgram_size.
> > >
> > > Fix this by setting dev->data[0] as zero.
> >
> > This sounds like a poor band-aid. Please explain how this prevent the
> > ioctl() from racing with unbind().
> 
> Good question. Isn't it the commit 2c9d6c2b871d ("usbnet: run unbind()
> before unregister_netdev()") which changed the ordering of the
> interface shutdown and basically makes this race happen? I don't see
> how we can guarantee that IOCTL won't be called until we quiescence
> the network device — my understanding that on device surprise removal
> we have to first shutdown what it created and then unbind the device.
> If I understand the original issue correctly then the problem is in
> usbnet->unbind and it should actually be split to two hooks, otherwise
> it seems every possible IOCTL callback must have some kind of
> reference counting and keep an eye on the surprise removal.
> 
> Johan, can you correct me if my understanding is wrong?

Hi,

the possible fix for this issue is under discussion here:
https://lore.kernel.org/netdev/d13e3a34-7e85-92dd-d0c0-5efb3fb08182@suse.com/T/

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
