Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A67232C4D
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbfFCJMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbfFCJMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 05:12:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4856F245B9;
        Mon,  3 Jun 2019 09:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553166;
        bh=erX6YxDH2r6uXzI9LcRs8ZHxY09bIc1J7b+RmnL8fMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aS91T9+Xmh5q7CpqlkXFGskdaGSaVzQkIHi7J9piv3sQRgupXj1aDCh0CS2xxCMqy
         vKlqJlhRVuGeTaMWIlfaTwGkC1izpru7sfz9fABBamKe4R+fryWzZnwu8wXSdTovyj
         /5pFSu5wDabtuIL5D1/N+JiPpqcH/bSdmUAU2JWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Heesoon Kim <Heesoon.Kim@stratus.com>,
        Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 5.1 01/40] bonding/802.3ad: fix slave link initialization transition states
Date:   Mon,  3 Jun 2019 11:08:54 +0200
Message-Id: <20190603090522.709589250@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
References: <20190603090522.617635820@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>

[ Upstream commit 334031219a84b9994594015aab85ed7754c80176 ]

Once in a while, with just the right timing, 802.3ad slaves will fail to
properly initialize, winding up in a weird state, with a partner system
mac address of 00:00:00:00:00:00. This started happening after a fix to
properly track link_failure_count tracking, where an 802.3ad slave that
reported itself as link up in the miimon code, but wasn't able to get a
valid speed/duplex, started getting set to BOND_LINK_FAIL instead of
BOND_LINK_DOWN. That was the proper thing to do for the general "my link
went down" case, but has created a link initialization race that can put
the interface in this odd state.

The simple fix is to instead set the slave link to BOND_LINK_DOWN again,
if the link has never been up (last_link_up == 0), so the link state
doesn't bounce from BOND_LINK_DOWN to BOND_LINK_FAIL -- it hasn't failed
in this case, it simply hasn't been up yet, and this prevents the
unnecessary state change from DOWN to FAIL and getting stuck in an init
failure w/o a partner mac.

Fixes: ea53abfab960 ("bonding/802.3ad: fix link_failure_count tracking")
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Tested-by: Heesoon Kim <Heesoon.Kim@stratus.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3122,13 +3122,18 @@ static int bond_slave_netdev_event(unsig
 	case NETDEV_CHANGE:
 		/* For 802.3ad mode only:
 		 * Getting invalid Speed/Duplex values here will put slave
-		 * in weird state. So mark it as link-fail for the time
-		 * being and let link-monitoring (miimon) set it right when
-		 * correct speeds/duplex are available.
+		 * in weird state. Mark it as link-fail if the link was
+		 * previously up or link-down if it hasn't yet come up, and
+		 * let link-monitoring (miimon) set it right when correct
+		 * speeds/duplex are available.
 		 */
 		if (bond_update_speed_duplex(slave) &&
-		    BOND_MODE(bond) == BOND_MODE_8023AD)
-			slave->link = BOND_LINK_FAIL;
+		    BOND_MODE(bond) == BOND_MODE_8023AD) {
+			if (slave->last_link_up)
+				slave->link = BOND_LINK_FAIL;
+			else
+				slave->link = BOND_LINK_DOWN;
+		}
 
 		if (BOND_MODE(bond) == BOND_MODE_8023AD)
 			bond_3ad_adapter_speed_duplex_changed(slave);


