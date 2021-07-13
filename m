Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08613C6B03
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 09:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhGMHNE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Jul 2021 03:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhGMHNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 03:13:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE8DC0613DD
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 00:10:12 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m3CYS-0000bm-Qg; Tue, 13 Jul 2021 09:10:08 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m3CYS-0005To-8o; Tue, 13 Jul 2021 09:10:08 +0200
Date:   Tue, 13 Jul 2021 09:10:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Xiaochen Zou <xzou017@ucr.edu>
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Use-after-free access in j1939_session_deactivate
Message-ID: <20210713071008.ci6avvds74q4zdfu@pengutronix.de>
References: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:05:24 up 222 days, 21:11, 46 users,  load average: 0.13, 0.06,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jul 12, 2021 at 03:40:46PM -0700, Xiaochen Zou wrote:
> Hi,
> It looks like there are multiple use-after-free accesses in
> j1939_session_deactivate()
> 
> static bool j1939_session_deactivate(struct j1939_session *session)
> {
> bool active;
> 
> j1939_session_list_lock(session->priv);
> active = j1939_session_deactivate_locked(session); //session can be freed inside
> j1939_session_list_unlock(session->priv); // It causes UAF read and write
> 
> return active;
> }
> 
> session can be freed by
> j1939_session_deactivate_locked->j1939_session_put->__j1939_session_release->j1939_session_destroy->kfree.
> Therefore it makes the unlock function perform UAF access.

Potentially I would agree, but this function takes "session" as
property. Any function which provided session pointer should
care about own ref counting. If described scenarios really happens, then
there is problem on other place. Was you able to reproduce it?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
