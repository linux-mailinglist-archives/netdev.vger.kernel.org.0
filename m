Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A138A1810BA
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 07:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgCKGbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 02:31:17 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:49549 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgCKGbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 02:31:16 -0400
X-Greylist: delayed 2365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2020 02:31:15 EDT
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 02B6TRrY029044;
        Wed, 11 Mar 2020 15:29:28 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 02B6TRrY029044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1583908169;
        bh=LNe3hvgyxkqOgtMP39KHBSlFvsuDIP1M2ZSJ4/uygew=;
        h=From:To:Cc:Subject:Date:From;
        b=pQ78yNELMBLF7QjXDLteBATDFgKPmsdH5/A6TLtLGZgBxh15kdpp2x5o0/Mipr7lR
         PBAbQ59hfEN4wgZyWhPkVc9j3hIp+lP8z/XpV8IFpBmGwcfX9jUb54LUeokw5Tm31M
         D2jn/EYj1oAT/AV/vWs8uzkq1UHPTn3ZItSOcjSod6sh2xSAGgDsOkK9AyUCFUEsU2
         vTt50UXcXyVM9YndjEppLPkyXdx9+nZEwpMzESjz2566oitfaEWtGMHuEUloJXFmUI
         bb4PurPwX7S7uvXM2s17YvvyHhHEnxfGo80C/v+CNRN7pzja1S9mWeX+9MoeggNbL1
         JNg3Zy9d90lfw==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Cc:     Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] net: drop_monitor: use IS_REACHABLE() to guard net_dm_hw_report()
Date:   Wed, 11 Mar 2020 15:29:25 +0900
Message-Id: <20200311062925.5163-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In net/Kconfig, NET_DEVLINK implies NET_DROP_MONITOR.

The original behavior of the 'imply' keyword prevents NET_DROP_MONITOR
from being 'm' when NET_DEVLINK=y.

With the planned Kconfig change that relaxes the 'imply', the
combination of NET_DEVLINK=y and NET_DROP_MONITOR=m would be allowed.

Use IS_REACHABLE() to avoid the vmlinux link error for this case.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

This build error was reported in linux-next.
https://lkml.org/lkml/2020/3/10/1936

If this patch is acceptable,
I'd like to get Ack from the maintainers,
and insert this patch before my Kconfig change.


 include/net/drop_monitor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/drop_monitor.h b/include/net/drop_monitor.h
index 2ab668461463..f68bc373544a 100644
--- a/include/net/drop_monitor.h
+++ b/include/net/drop_monitor.h
@@ -19,7 +19,7 @@ struct net_dm_hw_metadata {
 	struct net_device *input_dev;
 };
 
-#if IS_ENABLED(CONFIG_NET_DROP_MONITOR)
+#if IS_REACHABLE(CONFIG_NET_DROP_MONITOR)
 void net_dm_hw_report(struct sk_buff *skb,
 		      const struct net_dm_hw_metadata *hw_metadata);
 #else
-- 
2.17.1

