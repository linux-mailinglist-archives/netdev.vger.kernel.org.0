Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E21777F2
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 11:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387442AbfG0JlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 05:41:02 -0400
Received: from mx.0dd.nl ([5.2.79.48]:33498 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387400AbfG0JlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jul 2019 05:41:02 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 314ED5FCC5;
        Sat, 27 Jul 2019 11:41:00 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="BCxL4cTx";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id D6CD61D2B7F8;
        Sat, 27 Jul 2019 11:40:59 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com D6CD61D2B7F8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1564220459;
        bh=Po8WG1qBDIYCnjQlWQtEgz+phG5m7K/kvenHfs5fjjk=;
        h=From:To:Cc:Subject:Date:From;
        b=BCxL4cTxie75o/k9XqkiVfHwB60RmuIQLrriLsw8HsNf+Yfty4lDx6SxsIRdGCAhj
         n/cdvVUMBhDeraVG32XU/fmgoSPuIIldmJFov0OgmaWlrIQxbbNqu52USv4XgkkjHJ
         VDgWPjLKfTJvdHPIlHhMlqcEikofCz4kq6m1l37RIu90GFG93XPY6UzvQqlihSAOZ5
         /w5ImhYbu5iwWInUP9nznl9CDSeW8lr8dEsCc+88rGFuNCuFRZCW02lFuBNkIwi9S3
         oCNO1Z5ooAdICcQX75G5iDkBKEyOIl+jjzVg7g+HTePZSGcpJxV+Gimdy80VwTIqW9
         xd5C8BMywzOwA==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net] net: phylink: Fix flow control for fixed-link
Date:   Sat, 27 Jul 2019 11:40:11 +0200
Message-Id: <20190727094011.14024-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In phylink_parse_fixedlink() the pl->link_config.advertising bits are AND
with pl->supported, pl->supported is zeroed and only the speed/duplex
modes and MII bits are set.
So pl->link_config.advertising always loses the flow control/pause bits.

By setting Pause and Asym_Pause bits in pl->supported, the flow control
work again when devicetree "pause" is set in fixes-link node and the MAC
advertise that is supports pause.

Results with this patch.

Legend:
- DT = 'Pause' is set in the fixed-link in devicetree.
- validate() = ‘Yes’ means phylink_set(mask, Pause) is set in the
  validate().
- flow = results reported my link is Up line.

+-----+------------+-------+
| DT  | validate() | flow  |
+-----+------------+-------+
| Yes | Yes        | rx/tx |
| No  | Yes        | off   |
| Yes | No         | off   |
+-----+------------+-------+

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/phy/phylink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5d0af041b8f9..a6aebaa14338 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -216,6 +216,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 			       pl->supported, true);
 	linkmode_zero(pl->supported);
 	phylink_set(pl->supported, MII);
+	phylink_set(pl->supported, Pause);
+	phylink_set(pl->supported, Asym_Pause);
 	if (s) {
 		__set_bit(s->bit, pl->supported);
 	} else {
-- 
2.20.1

