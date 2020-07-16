Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB6E222E5B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 00:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgGPWFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 18:05:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39632 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgGPWFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 18:05:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwC0O-005Vuc-N0; Fri, 17 Jul 2020 00:05:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool] Fix segfault with cable test and ./configure --disable-netlink
Date:   Fri, 17 Jul 2020 00:05:09 +0200
Message-Id: <20200716220509.1314265-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the netlink interface code is disabled, a stub version of
netlink_run_handler() is used. This stub version needs to handle the
case when there is no possibility for a command to fall back to the
IOCTL call. The two cable tests commands have no such fallback, and if
we don't handle this, ethtool tries to jump through a NULL pointer
resulting in a segfault.

Reported-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 netlink/extapi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/netlink/extapi.h b/netlink/extapi.h
index c5bfde9..a35d5f2 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -46,6 +46,12 @@ void nl_monitor_usage(void);
 static inline void netlink_run_handler(struct cmd_context *ctx,
 				       nl_func_t nlfunc, bool no_fallback)
 {
+	if (no_fallback) {
+		fprintf(stderr,
+			"Command requires kernel netlink support which is not "
+			"enabled in this ethtool binary\n");
+		exit(1);
+	}
 }
 
 static inline int nl_monitor(struct cmd_context *ctx)
-- 
2.27.0

