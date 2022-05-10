Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC4520CF8
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 06:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiEJEiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 00:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235645AbiEJEiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 00:38:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3D2C4C
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 21:34:20 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1noHZY-0007q2-KZ; Tue, 10 May 2022 06:34:08 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1noHZW-0007VY-K5; Tue, 10 May 2022 06:34:06 +0200
Date:   Tue, 10 May 2022 06:34:06 +0200
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
Message-ID: <20220510043406.GB10669@pengutronix.de>
References: <20220509170746.29893-1-devid.filoni@egluetechnologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220509170746.29893-1-devid.filoni@egluetechnologies.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:26:17 up 40 days, 16:55, 62 users,  load average: 0.10, 0.09,
 0.09
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

On Mon, May 09, 2022 at 07:07:44PM +0200, Devid Antonio Filoni wrote:
> Hello,
> 
> If candump -x is used to dump CAN bus traffic on an interface while a J1939
> socket is sending multi-packet messages, then the DAT and CTL frames
> show up as RX instead of TX.
> 
> This patch series sets to generated struct sk_buff the owning struct sock
> pointer so that the MSG_DONTROUTE flag can be set by recv functions.
> 
> I'm not sure that j1939_session_skb_get is needed, I think that session->sk
> could be directly passed as can_skb_set_owner parameter. This patch
> is based on j1939_simple_txnext function which uses j1939_session_skb_get.
> I can provide an additional patch to remove the calls to
> j1939_session_skb_get function if you think they are not needed.

Thank you for your patches. By testing it I noticed that there is a memory
leak in current kernel and it seems to be even worse after this patches.
Found by this test:
https://github.com/linux-can/can-tests/blob/master/j1939/run_all.sh#L13

Can you please investigate it (or wait until I get time to do it).

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
