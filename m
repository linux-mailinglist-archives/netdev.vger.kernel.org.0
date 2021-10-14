Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C65842D599
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 11:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhJNJDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 05:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230112AbhJNJDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 05:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A013F610EA;
        Thu, 14 Oct 2021 09:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634202063;
        bh=DA9RmgfUICfD23hPl0Hw7V7yblFOHR1znsQdqn0zh3U=;
        h=From:To:Cc:Subject:Date:From;
        b=I03N3b6ralmPKnPcU6oARmAtt3AuGjQXXC3p6azCUN51KFlcPs4w6gyGIDIAPpORf
         pfpvidEy7i28IKdEaa8G23pD5QTvdbnlOKzIfjSDm/XzFOOiI1nx3VqSqQmUjE3rpy
         RbodeFDuruErNJj8m1GgiENIV6p1e3k/g9pLWl/wQMJQmp564tQvBxnxK4ZbFCUng6
         UL2FgJn7CiMCP/4CkhHmyR5vc+jLeCmT6x6SApbbnysPI1Ff4FlFh0yCA1JgOOlVoH
         P1m9AxWxHEVuMYe1Eg2sc6bLgImmvas68TfFSqhcZhnehg57jVcR6YE8jFgjONJJK9
         TKhZB6hX6RV6A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: of: fix stub of_net helpers for CONFIG_NET=n
Date:   Thu, 14 Oct 2021 11:00:37 +0200
Message-Id: <20211014090055.2058949-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Moving the of_net code from drivers/of/ to net/core means we
no longer stub out the helpers when networking is disabled,
which leads to a randconfig build failure with at least one
ARM platform that calls this from non-networking code:

arm-linux-gnueabi-ld: arch/arm/mach-mvebu/kirkwood.o: in function `kirkwood_dt_eth_fixup':
kirkwood.c:(.init.text+0x54): undefined reference to `of_get_mac_address'

Restore the way this worked before by changing that #ifdef
check back to testing for both CONFIG_OF and CONFIG_NET.

Fixes: e330fb14590c ("of: net: move of_net under net/")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/of_net.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index 0797e2edb8c2..0484b613ca64 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -8,7 +8,7 @@
 
 #include <linux/phy.h>
 
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && defined(CONFIG_NET)
 #include <linux/of.h>
 
 struct net_device;
-- 
2.29.2

