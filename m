Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AD31E7045
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437521AbgE1XV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:21:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:49300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437506AbgE1XVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:21:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A64D3AFED;
        Thu, 28 May 2020 23:21:37 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C6732E32D2; Fri, 29 May 2020 01:21:37 +0200 (CEST)
Message-Id: <6c672d7a5d3b598cb8c8de5b624db87ab67a0176.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 06/21] selftest: omit test-features if netlink is
 enabled
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:37 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test-features selftest is checking data structures passed to ioctl()
syscall. Therefore a complete rework of the test framework will be needed
to be able to perform an equivalent selftest for netlink interface. Until
such framework is implemented, disable test-features when building ethtool
with netlink support.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 0f8465f7ada9..b3ffae52f1e9 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -40,12 +40,16 @@ AM_CPPFLAGS += @MNL_CFLAGS@
 LDADD += @MNL_LIBS@
 endif
 
-TESTS = test-cmdline test-features
-check_PROGRAMS = test-cmdline test-features
+TESTS = test-cmdline
+check_PROGRAMS = test-cmdline
 test_cmdline_SOURCES = test-cmdline.c test-common.c $(ethtool_SOURCES) 
 test_cmdline_CFLAGS = -DTEST_ETHTOOL
+if !ETHTOOL_ENABLE_NETLINK
+TESTS += test-features
+check_PROGRAMS += test-features
 test_features_SOURCES = test-features.c test-common.c $(ethtool_SOURCES) 
 test_features_CFLAGS = -DTEST_ETHTOOL
+endif
 
 dist-hook:
 	cp $(top_srcdir)/ethtool.spec $(distdir)
-- 
2.26.2

