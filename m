Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1303E135E
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbhHELBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234312AbhHELBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 07:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDAFC61102;
        Thu,  5 Aug 2021 11:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628161253;
        bh=yH8H68IN0uHhEueXzY2e7BwneC0HdJ9wrBTXuosSek8=;
        h=From:To:Cc:Subject:Date:From;
        b=S/eppfAb1ZyhU/hZSNTRkgxhXy32G++cHHA3tWAw/DTKW4F8w8JgmONIXqj9KBd7F
         lC19RqX8JJLPmnMqtGIZYvd7Wn7qL6RqVzS6oYApWF9Vz1kx1v8DE+cy2KP9kwCA0Z
         vObDPpEbi1eH80fkzOh6a1Gxc/HYDV7B0WW53t9elZYmVX5QBmo4la7lNVIQXWEFAB
         oaYjEFGT32DweGO+4YzixJQ/l6KPlVxBpyfNMcY83Iqy/a0JbG/9s7AmJhP8Ac2t1E
         J99gsXAklsWPpOWcyeYDS9/guQzlCCYsu7bsPBipXcpPGGR/n7W6FMWBgfhMTWnmLF
         Dg0Mae3taVmyg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] dsa: sja1105: fix reverse dependency
Date:   Thu,  5 Aug 2021 13:00:28 +0200
Message-Id: <20210805110048.1696362-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The DSA driver and the tag driver for sja1105 are closely linked,
and recently the dependency started becoming visible in the form
of the sja1110_process_meta_tstamp() that gets exported by one
and used by the other.

This causes a rare build failure with CONFIG_NET_DSA_TAG_SJA1105=y
and CONFIG_NET_DSA_SJA1105=m, as the 'select' statement only
prevents the opposite configuration:

aarch64-linux-ld: net/dsa/tag_sja1105.o: in function `sja1110_rcv':
tag_sja1105.c:(.text.sja1110_rcv+0x164): undefined reference to `sja1110_process_meta_tstamp'

Add a stricter dependency for the CONFIG_NET_DSA_TAG_SJA110y to
prevent it from being built-in when the other one is not.

Fixes: 566b18c8b752 ("net: dsa: sja1105: implement TX timestamping for SJA1110")
Fixes: 227d07a07ef1 ("net: dsa: sja1105: Add support for traffic through standalone ports")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Not sure if there is a more logical way to deal with this,
but the added dependency does help avoid the build failure.

I found this one while verifying the PTP dependency patch, but
it's really a separate issue.
---
 net/dsa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index bca1b5d66df2..548285539752 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -138,6 +138,7 @@ config NET_DSA_TAG_LAN9303
 
 config NET_DSA_TAG_SJA1105
 	tristate "Tag driver for NXP SJA1105 switches"
+	depends on NET_DSA_SJA1105 || !NET_DSA_SJA1105
 	select PACKING
 	help
 	  Say Y or M if you want to enable support for tagging frames with the
-- 
2.29.2

