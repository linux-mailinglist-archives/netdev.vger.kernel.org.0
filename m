Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E10D4C6BDB
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 13:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiB1MKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 07:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiB1MKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 07:10:48 -0500
Received: from mx.tkos.co.il (guitar.tcltek.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5222763BFB
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 04:10:09 -0800 (PST)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id ED85E44083B;
        Mon, 28 Feb 2022 14:09:26 +0200 (IST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1646050167;
        bh=VaRkIvpFKJPDIJtGvQL86kMl7OjD3aj4SKE+ePTxGdk=;
        h=From:To:Cc:Subject:Date:From;
        b=fTdowWgCNjEtnSCDAk1qqrvCU28HISY/gvxCu+tN40LXch9qQWOPdAW9n5wCcZlcy
         Tbe3Nm9ppqxOJETYNRuGVT7h2D8m7wv9RHUEVRxA7V7hNH0dLZFPg1m0Qgzbn7n2Ik
         33tV9/y/k+iBeMRnMfkZRHSghu6kmM7aW+wL+V7FpOfBSww4LZwzMXyejTCUZf6nbB
         WcHh3/8geKCABR5qu0jn2SneG2BinjNMMjye5kBwutqzh9aDSXrsu2+Ml1Us7lhcLB
         prT4FedbP0BgIcHzlxlEgH+IhwgYbdpJEQUnkQPdPZHiiZ2IpGs6cDZ2bvvGqYQzD5
         ++4mX//+ZYIng==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Baruch Siach <baruch.siach@siklu.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: don't error out cmode set on missing lane
Date:   Mon, 28 Feb 2022 14:10:02 +0200
Message-Id: <cd95cf3422ae8daf297a01fa9ec3931b203cdf45.1646050203.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

When the given cmode has no serdes, mv88e6xxx_serdes_get_lane() returns
-NODEV. Earlier in the same function the code skips serdes handing in
this case. Do the same after cmode set.

Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---
 drivers/net/dsa/mv88e6xxx/port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index d08e3ec2b042..a58997f1fd69 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -610,6 +610,8 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		chip->ports[port].cmode = cmode;
 
 		lane = mv88e6xxx_serdes_get_lane(chip, port);
+		if (lane == -ENODEV)
+			return 0;
 		if (lane < 0)
 			return lane;
 
-- 
2.34.1

