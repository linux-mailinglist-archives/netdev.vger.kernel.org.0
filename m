Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E21752321C
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbiEKLsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237383AbiEKLsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:48:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0859724310B
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 04:48:22 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nokp7-00048f-28; Wed, 11 May 2022 13:48:09 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nokp4-0000Cy-Ci; Wed, 11 May 2022 13:48:06 +0200
Date:   Wed, 11 May 2022 13:48:06 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Cc:     Robin van der Gracht <robin@protonic.nl>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/2] j1939: make sure that sent DAT/CTL frames are
 marked as TX
Message-ID: <20220511114806.GA12398@pengutronix.de>
References: <20220509170746.29893-1-devid.filoni@egluetechnologies.com>
 <20220510043406.GB10669@pengutronix.de>
 <a8ea7199230682f3fd53e0b5975afa7287bd5ac0.camel@egluetechnologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a8ea7199230682f3fd53e0b5975afa7287bd5ac0.camel@egluetechnologies.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:45:31 up 42 days, 15 min, 82 users,  load average: 0.20, 0.23,
 0.20
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Devid,

On Tue, May 10, 2022 at 08:12:32PM +0200, Devid Antonio Filoni wrote:
> Hi Oleksij,
> 
> On Tue, 2022-05-10 at 06:34 +0200, Oleksij Rempel wrote:
> > Hi Devid,
> > 
> > On Mon, May 09, 2022 at 07:07:44PM +0200, Devid Antonio Filoni wrote:
> > > Hello,
> > > 
> > > If candump -x is used to dump CAN bus traffic on an interface while a J1939
> > > socket is sending multi-packet messages, then the DAT and CTL frames
> > > show up as RX instead of TX.
> > > 
> > > This patch series sets to generated struct sk_buff the owning struct sock
> > > pointer so that the MSG_DONTROUTE flag can be set by recv functions.
> > > 
> > > I'm not sure that j1939_session_skb_get is needed, I think that session->sk
> > > could be directly passed as can_skb_set_owner parameter. This patch
> > > is based on j1939_simple_txnext function which uses j1939_session_skb_get.
> > > I can provide an additional patch to remove the calls to
> > > j1939_session_skb_get function if you think they are not needed.
> > 
> > Thank you for your patches. By testing it I noticed that there is a memory
> > leak in current kernel and it seems to be even worse after this patches.
> > Found by this test:
> > https://github.com/linux-can/can-tests/blob/master/j1939/run_all.sh#L13
> > 
> > 
> > Can you please investigate it (or wait until I get time to do it).
> > 
> > Regards,
> > Oleksij
> > 
> 
> I checked the test you linked and I can see that the number of the
> instances of the can_j1939 module increases on each
> j1939_ac_100k_dual_can.sh test execution (then the script exits),
> however this doesn't seem to be worse with my patches, I have the same
> results with the original kernel. Did you execute a particular test to
> verify that the memory leak is worse with my patches?
> I tried to take a look at all code that I changed in my patches but the
> used ref counters seem to be handled correctly in called functions. I
> suspected that the issue may be caused by the ref counter increased
> in can_skb_set_owner() function but, even if I remove that call from the
> j1939_simple_txnext() function in original kernel, I can still reproduce
> the memory leak.
> I think the issue is somewhere else, I'll try to give another look but I
> can't assure nothing.

Suddenly detecting local frames by skb->sk will not work for all control
packets. I'll send different patch solving it for all j1939 and raw
variants.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
