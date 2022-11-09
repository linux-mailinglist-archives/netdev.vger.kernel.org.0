Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74475622EFC
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 16:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiKIPZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 10:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiKIPZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 10:25:25 -0500
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Nov 2022 07:25:20 PST
Received: from smtpcmd0872.aruba.it (smtpcmd0872.aruba.it [62.149.156.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DCCB2DDB
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 07:25:20 -0800 (PST)
Received: from polimar.homenet.telecomitalia.it ([79.0.204.227])
        by Aruba Outgoing Smtp  with ESMTPSA
        id smw3oz6zpckLQsmw6o3w6G; Wed, 09 Nov 2022 16:24:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1668007458; bh=nDHEgxtbGujtACptVk5rUWHzAeEKaCb6dE5epWf42gs=;
        h=From:To:Subject:Date:MIME-Version;
        b=P+UvqZHis7upbYna5t1s/9eCDVApOoooI/xTeZLSX/p8yAnW5Zl+go35Q0bIiu+fS
         NWWRRInQztV59xNuSJrNniskayAZVsopSR1CUw1zyhmj+dwseb/ax1T/zCTZWWjhD5
         5BvMfr87Of10RvyFZWNTdnJFM7OScH6THGESJ5EUIRSvptxrqzELmvsoR5jh6MVAEq
         kP4eFavZYT5+5LuYufIOCv/0rd3efRzjcc69SCjHnRA3Cf2wRprToOdxDTJKOWNkd1
         MJFt0vXaMQaNi2kqZQ48TCt6+1MiP75LCZR104pg39eZrXbrEnn9eCg+9FbdNesIxL
         aHPRaJVqY1Wqg==
From:   Rodolfo Giometti <giometti@enneenne.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <shemminger@osdl.org>,
        Flavio Leitner <fbl@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH] net br_netlink.c:y allow non "disabled" state for !netif_oper_up() links
Date:   Wed,  9 Nov 2022 16:24:10 +0100
Message-Id: <20221109152410.3572632-2-giometti@enneenne.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221109152410.3572632-1-giometti@enneenne.com>
References: <20221109152410.3572632-1-giometti@enneenne.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfFDAW6JvYF9/zt5CjygfYlEDES2VH1BmSelsBrMW3TGn9ot2B9nMZj9Q5IF2g1E//8zPOp4hjotFL3mgI/Ojwih1r7vvsaSZppwC2RJ4B1MiTSuEZjc7
 KAS8DcsfpUkNvaZ52f9h63yh4Gc35BZUQEIXYNHjYPSAtpPyI0x7aO784GLhq3J9K+ZeEDe5IKqvC0ULe5lotpSIYM9Qhh4W7NmVvs0nf1JACvwNycZofGFJ
 ywYFQ1pPz+jSpQtZQglsntE2ovuS9+8y1gtirZzFaA72IUbzjah0Wbe3A+AYTX5koMis+OZbWVIPsSgwMHfX7Q6hhZzuafLIEybeGxjolBhor/L9ICXoM6+y
 cWLK+wykxNOSCqM+WVshT6bigAcz1bxaqI7z5mvw1+K2qxzNlIE=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A generic loop-free network protocol (such as STP or MRP and others) may
require that a link not in an operational state be into a non "disabled"
state (such as listening).

For example MRP states that a MRM should set into a "BLOCKED" state (which is
equivalent to the LISTENING state for Linux bridges) one of its ring
connection if it detects that this connection is "DOWN" (that is the
NO-CARRIER status).

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 net/bridge/br_netlink.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5c6c4305ed23..3f9f45c3d274 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -841,11 +841,8 @@ static int br_set_port_state(struct net_bridge_port *p, u8 state)
 	if (p->br->stp_enabled == BR_KERNEL_STP)
 		return -EBUSY;
 
-	/* if device is not up, change is not allowed
-	 * if link is not present, only allowable state is disabled
-	 */
-	if (!netif_running(p->dev) ||
-	    (!netif_oper_up(p->dev) && state != BR_STATE_DISABLED))
+	/* if device is not up, change is not allowed */
+	if (!netif_running(p->dev))
 		return -ENETDOWN;
 
 	br_set_state(p, state);
-- 
2.34.1

