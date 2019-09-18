Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E67FB6400
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 15:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfIRNFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 09:05:52 -0400
Received: from forward102j.mail.yandex.net ([5.45.198.243]:57852 "EHLO
        forward102j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbfIRNFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 09:05:52 -0400
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward102j.mail.yandex.net (Yandex) with ESMTP id 645C9F2016B
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 16:05:50 +0300 (MSK)
Received: from mxback12q.mail.yandex.net (mxback12q.mail.yandex.net [IPv6:2a02:6b8:c0e:1b3:0:640:3818:d096])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 5DD7C61E0013
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 16:05:50 +0300 (MSK)
Received: from vla5-b45cc32a2812.qloud-c.yandex.net (vla5-b45cc32a2812.qloud-c.yandex.net [2a02:6b8:c18:3508:0:640:b45c:c32a])
        by mxback12q.mail.yandex.net (nwsmtp/Yandex) with ESMTP id B24Ss4pkEF-5opiLSEx;
        Wed, 18 Sep 2019 16:05:50 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1568811950;
        bh=wY/RXOWng3m8ygV9MzH4gHBZGXDSgeDF6yaCzxUfoVQ=;
        h=Subject:To:From:Date:Message-ID;
        b=Xtw3I4+KX1XvMv+OvPtgT4Ho7xoz6vLSNDOmWhOTHWRdLnAvTnUKGB/K6pEomUKA8
         MtX32QePnaNJ66w3ooxXDkQXWoWfVsvITMSleMWjQq1R+HV3hf54UYIjT6HGRo0pH2
         LUbhgXAY+EWYBvsyve1wS1LLghcuaKtU2zv5eqpA=
Authentication-Results: mxback12q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-b45cc32a2812.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id w6ktzRrrfw-5nqqVKKI;
        Wed, 18 Sep 2019 16:05:49 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Date:   Wed, 18 Sep 2019 16:05:45 +0300
From:   Aleksei Zakharov <zaharov@selectel.ru>
To:     netdev@vger.kernel.org
Subject: [PATCH] bonding/802.3ad: fix slave initialization states race
Message-ID: <20190918130545.GA11133@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once a while, one of 802.3ad slaves fails to initialize and hangs in
BOND_LINK_FAIL state. Commit 334031219a84 ("bonding/802.3ad: fix slave
link initialization transition states") checks slave->last_link_up. But
link can still hang in weird state.
After physical link comes up it sends first two LACPDU messages and
doesn't work properly after that. It doesn't send or receive LACPDU.
Once it happens, the only message in dmesg is:
bond1: link status up again after 0 ms for interface eth2

This behavior can be reproduced (not every time):
1. Set slave link down
2. Wait for 1-3 seconds
3. Set slave link up

The fix is to check slave->link before setting it to BOND_LINK_FAIL or
BOND_LINK_DOWN state. If got invalid Speed/Dupex values and link is in
BOND_LINK_UP state, mark it as BOND_LINK_FAIL; otherwise mark it as
BOND_LINK_DOWN.

Fixes: 334031219a84 ("bonding/802.3ad: fix slave link initialization
transition states")
Signed-off-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 931d9d935686..a28776d8f33f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3135,7 +3135,7 @@ static int bond_slave_netdev_event(unsigned long event,
 		 */
 		if (bond_update_speed_duplex(slave) &&
 		    BOND_MODE(bond) == BOND_MODE_8023AD) {
-			if (slave->last_link_up)
+			if (slave->link == BOND_LINK_UP)
 				slave->link = BOND_LINK_FAIL;
 			else
 				slave->link = BOND_LINK_DOWN;
-- 
2.17.1

