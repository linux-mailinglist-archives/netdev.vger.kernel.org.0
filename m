Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782405B8B48
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiINPGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiINPGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:06:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9E978212
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DujrTmxkBKsPeevIIxizMFPed0UfSvDnz1uI2PW/UgY=; b=LN8wAK7r2E8wI6f0XTUKGENmCM
        5FLpkm1xVoXhbhbJB00JQmZuBsJrebhZshXsBHst9j2M8WEeY4HOHQYu9Bv9g9xODt7Yr4Y52BFPc
        x7Pgsj7fth6grHY+A5im15lMo5flv4PKCIyk1wj2fWatms/lknpy2mo1pSwU1ufZ9z2hzAShTOGhK
        5Cce3ZDEHVfbb3Ya2vC4ss6vx+gMfbf2JwV6E8H1d9ojm2CSsu3lAqToFc42zKwx+gDo3EYQHrG5j
        9fovN3CyBjvkdiSvMh1A+AoPtdWztK6dG4egzoRfmGKswTdRDiGwrGmuZqhMYYxNpFUzUWboqODhx
        GC2EvFYQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oYTyC-0005AO-LD; Wed, 14 Sep 2022 17:06:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: [RESEND net-next PATCH] net: rtnetlink: Enslave device before bringing it up
Date:   Wed, 14 Sep 2022 17:06:23 +0200
Message-Id: <20220914150623.24152-1-phil@nwl.cc>
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

Unlike with bridges, one can't add an interface to a bond and set it up
at the same time:

| # ip link set dummy0 down
| # ip link set dummy0 master bond0 up
| Error: Device can not be enslaved while up.

Of all drivers with ndo_add_slave callback, bond and team decline if
IFF_UP flag is set, vrf cycles the interface (i.e., sets it down and
immediately up again) and the others just don't care.

Support the common notion of setting the interface up after enslaving it
by sorting the operations accordingly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Resubmitting this after review, concerns uttered in original discussion
three years ago do not apply: Any flag changes happening during
do_set_master() call are preserved, unless user space intended to change
them. I verified that a team device in promisc mode still correctly
propagates the flag to a new slave after applying this patch.
---
 net/core/rtnetlink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ac45328607f77..2e15f744544e5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2776,13 +2776,6 @@ static int do_setlink(const struct sk_buff *skb,
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 	}
 
-	if (ifm->ifi_flags || ifm->ifi_change) {
-		err = dev_change_flags(dev, rtnl_dev_combine_flags(dev, ifm),
-				       extack);
-		if (err < 0)
-			goto errout;
-	}
-
 	if (tb[IFLA_MASTER]) {
 		err = do_set_master(dev, nla_get_u32(tb[IFLA_MASTER]), extack);
 		if (err)
@@ -2790,6 +2783,13 @@ static int do_setlink(const struct sk_buff *skb,
 		status |= DO_SETLINK_MODIFIED;
 	}
 
+	if (ifm->ifi_flags || ifm->ifi_change) {
+		err = dev_change_flags(dev, rtnl_dev_combine_flags(dev, ifm),
+				       extack);
+		if (err < 0)
+			goto errout;
+	}
+
 	if (tb[IFLA_CARRIER]) {
 		err = dev_change_carrier(dev, nla_get_u8(tb[IFLA_CARRIER]));
 		if (err)
-- 
2.34.1

