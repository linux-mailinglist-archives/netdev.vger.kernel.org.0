Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8353251A2
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 15:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhBYOkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232557AbhBYOkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 09:40:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2043064EB7;
        Thu, 25 Feb 2021 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614263977;
        bh=STZDJx0qp9i6/i1NooOs3H6OwuabG+VJzumPODCTw5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlkMMQoA8p2tKnGs7/wS/B53kyT6XbPRjaeaJxDr0nBnAdIrFpGNQDzAZkDWnJvA8
         lG/0uWNz9ucSJPKx7jKdRJwSlawk18v0IZ3f/TX1WebMYyFWQ+CSMxqzruPDPBKU24
         Aw3MMbo3qKXMoReXDCwtshYnUxoN9ZRtLm460K/gVkp+Jn1iIJnq0m2N06V90FZzwJ
         nBIJ2ie/ap5TMzlCYeKPkwTuVmwRINYy0LJhzy3wMn4HM80/Ppn3BWsBj1AyImvatt
         E97OvQmuOUte7zPas3z1uFk1O02/KXubHcpByrnAf0Uag1uP4wmRpbiirD9F7Ar3s4
         yI4TCAkxyELAg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] net: dsa: tag_ocelot_8021q: fix driver dependency
Date:   Thu, 25 Feb 2021 15:38:32 +0100
Message-Id: <20210225143910.3964364-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210225143910.3964364-1-arnd@kernel.org>
References: <20210225143910.3964364-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When the ocelot driver code is in a library, the dsa tag
code cannot be built-in:

ld.lld: error: undefined symbol: ocelot_can_inject
>>> referenced by tag_ocelot_8021q.c
>>>               dsa/tag_ocelot_8021q.o:(ocelot_xmit) in archive net/built-in.a

ld.lld: error: undefined symbol: ocelot_port_inject_frame
>>> referenced by tag_ocelot_8021q.c
>>>               dsa/tag_ocelot_8021q.o:(ocelot_xmit) in archive net/built-in.a

Building the tag support only really makes sense for compile-testing
when the driver is available, so add a Kconfig dependency that prevents
the broken configuration while allowing COMPILE_TEST alternative when
MSCC_OCELOT_SWITCH_LIB is disabled entirely.  This case is handled
through the #ifdef check in include/soc/mscc/ocelot.h.

Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/dsa/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 3589224c8da9..58b8fc82cd3c 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -118,6 +118,8 @@ config NET_DSA_TAG_OCELOT
 
 config NET_DSA_TAG_OCELOT_8021Q
 	tristate "Tag driver for Ocelot family of switches, using VLAN"
+	depends on MSCC_OCELOT_SWITCH_LIB || \
+	          (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
 	select NET_DSA_TAG_8021Q
 	help
 	  Say Y or M if you want to enable support for tagging frames with a
-- 
2.29.2

