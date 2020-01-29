Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2906314D011
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgA2SC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 13:02:28 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:36686 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgA2SC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 13:02:28 -0500
Received: from ramsan ([84.195.182.253])
        by michel.telenet-ops.be with bizsmtp
        id wJ2R2100B5USYZQ06J2Rzn; Wed, 29 Jan 2020 19:02:25 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iwrfV-0005nY-99; Wed, 29 Jan 2020 19:02:25 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iwrfV-0000C1-6p; Wed, 29 Jan 2020 19:02:25 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mptcp: MPTCP_HMAC_TEST should depend on MPTCP
Date:   Wed, 29 Jan 2020 19:02:24 +0100
Message-Id: <20200129180224.700-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the MPTCP HMAC test is integrated into the MPTCP code, it can be
built only when MPTCP is enabled.  Hence when MPTCP is disabled, asking
the user if the test code should be enabled is futile.

Wrap the whole block of MPTCP-specific config options inside a check for
MPTCP.  While at it, drop the "default n" for MPTCP_HMAC_TEST, as that
is the default anyway.

Fixes: 65492c5a6ab5df50 ("mptcp: move from sha1 (v0) to sha256 (v1)")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/mptcp/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index 5db56d2218c518c8..49f6054e7f4ebc15 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -10,17 +10,19 @@ config MPTCP
 	  uses the TCP protocol, and TCP options carry header information for
 	  MPTCP.
 
+if MPTCP
+
 config MPTCP_IPV6
 	bool "MPTCP: IPv6 support for Multipath TCP"
-	depends on MPTCP
 	select IPV6
 	default y
 
 config MPTCP_HMAC_TEST
 	bool "Tests for MPTCP HMAC implementation"
-	default n
 	help
 	  This option enable boot time self-test for the HMAC implementation
 	  used by the MPTCP code
 
 	  Say N if you are unsure.
+
+endif
-- 
2.17.1

