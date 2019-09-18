Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4065B6637
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 16:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfIROeg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Sep 2019 10:34:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54531 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfIROeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 10:34:36 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iAb2Q-0000C8-TO; Wed, 18 Sep 2019 14:34:34 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id A32D8240CB2; Wed, 18 Sep 2019 16:34:34 +0200 (CEST)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 9EFB8289C50;
        Wed, 18 Sep 2019 16:34:34 +0200 (CEST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Aleksei Zakharov <zaharov@selectel.ru>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] bonding/802.3ad: fix slave initialization states race
In-reply-to: <20190918130545.GA11133@yandex.ru>
References: <20190918130545.GA11133@yandex.ru>
Comments: In-reply-to Aleksei Zakharov <zaharov@selectel.ru>
   message dated "Wed, 18 Sep 2019 16:05:45 +0300."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31892.1568817274.1@nyx>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 18 Sep 2019 16:34:34 +0200
Message-ID: <31893.1568817274@nyx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aleksei Zakharov <zaharov@selectel.ru> wrote:

>Once a while, one of 802.3ad slaves fails to initialize and hangs in
>BOND_LINK_FAIL state. Commit 334031219a84 ("bonding/802.3ad: fix slave
>link initialization transition states") checks slave->last_link_up. But
>link can still hang in weird state.
>After physical link comes up it sends first two LACPDU messages and
>doesn't work properly after that. It doesn't send or receive LACPDU.
>Once it happens, the only message in dmesg is:
>bond1: link status up again after 0 ms for interface eth2

	I believe this message indicates that the slave entered
BOND_LINK_FAIL state, but downdelay was not set.  The _FAIL state is
really for managing the downdelay expiration, and a slave should not be
in that state (outside of a brief transition entirely within
bond_miimon_inspect) if downdelay is 0.

>This behavior can be reproduced (not every time):
>1. Set slave link down
>2. Wait for 1-3 seconds
>3. Set slave link up
>
>The fix is to check slave->link before setting it to BOND_LINK_FAIL or
>BOND_LINK_DOWN state. If got invalid Speed/Dupex values and link is in
>BOND_LINK_UP state, mark it as BOND_LINK_FAIL; otherwise mark it as
>BOND_LINK_DOWN.
>
>Fixes: 334031219a84 ("bonding/802.3ad: fix slave link initialization
>transition states")
>Signed-off-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
>---
> drivers/net/bonding/bond_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 931d9d935686..a28776d8f33f 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3135,7 +3135,7 @@ static int bond_slave_netdev_event(unsigned long event,
> 		 */
> 		if (bond_update_speed_duplex(slave) &&
> 		    BOND_MODE(bond) == BOND_MODE_8023AD) {
>-			if (slave->last_link_up)
>+			if (slave->link == BOND_LINK_UP)
> 				slave->link = BOND_LINK_FAIL;
> 			else
> 				slave->link = BOND_LINK_DOWN;

	Is the core problem here that slaves are reporting link up, but
returning invalid values for speed and/or duplex?  If so, what network
device are you testing with that is exhibiting this behavior?

	If I'm not mistaken, there have been several iterations of
hackery on this block of code to work around this same problem, and each
time there's some corner case that still doesn't work.

	As Davem asked last time around, is the real problem that device
drivers report carrier up but supply invalid speed and duplex state?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
