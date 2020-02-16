Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D79160709
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 23:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgBPWsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 17:48:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:34052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbgBPWsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 17:48:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8B940B033;
        Sun, 16 Feb 2020 22:48:06 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3BD0DE03D6; Sun, 16 Feb 2020 23:48:06 +0100 (CET)
Message-Id: <2bac8346b4e02cf1f6ac9d8dc357b003c9600c07.1581892124.git.mkubecek@suse.cz>
In-Reply-To: <cover.1581892124.git.mkubecek@suse.cz>
References: <cover.1581892124.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 19/19] netlink: support tests with netlink enabled
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Sun, 16 Feb 2020 23:48:06 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As there is no netlink implementation of features (-k / -K) yet, we only
need to take care of test-cmdline. With this patch, the full test suite
succeeds with both --enable-netlink and --disable-netlink.

There are two differences between results with netlink enabled and
disabled:

1. The netlink interface allows network device names up to 127 characters
(ALTIFNAMSIZ - 1). While alternative names can be used to identify a device
with ioctl, fixed structure does not allow passing names longer than 15
characters (IFNAMSIZ - 1).

2. Failure with deprecated 'xcvr' parameter for -s / --change is done in
slightly different way so that netlink code will have it interpreted as
a parser failure while ioctl code as (fake) request failure. Another
difference is that no kernel with ethtool netlink support can possibly
allow changing transceiver using ethtool request.

The command line tests affected by these differences have expected return
code depending on ETHTOOL_ENABLE_NETLINK.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/netlink.c |  7 +++++++
 netlink/nlsock.c  |  2 ++
 test-cmdline.c    | 29 ++++++++++++++++++++++++++---
 test-features.c   | 11 +++++++++++
 4 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/netlink/netlink.c b/netlink/netlink.c
index 2e49c6618c53..14f9f29b6135 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -143,6 +143,12 @@ static int family_info_cb(const struct nlmsghdr *nlhdr, void *data)
 	return MNL_CB_OK;
 }
 
+#ifdef TEST_ETHTOOL
+static int get_genl_family(struct nl_socket *nlsk, struct fam_info *info)
+{
+	return 0;
+}
+#else
 static int get_genl_family(struct nl_socket *nlsk, struct fam_info *info)
 {
 	struct nl_msg_buff *msgbuff = &nlsk->msgbuff;
@@ -165,6 +171,7 @@ out:
 	nlsk->nlctx->suppress_nlerr = false;
 	return ret;
 }
+#endif
 
 int netlink_init(struct cmd_context *ctx)
 {
diff --git a/netlink/nlsock.c b/netlink/nlsock.c
index 8cb661e96e30..3ed6baf3afa1 100644
--- a/netlink/nlsock.c
+++ b/netlink/nlsock.c
@@ -218,6 +218,7 @@ int nlsock_prep_get_request(struct nl_socket *nlsk, unsigned int nlcmd,
 	return 0;
 }
 
+#ifndef TEST_ETHTOOL
 ssize_t nlsock_sendmsg(struct nl_socket *nlsk, struct nl_msg_buff *altbuff)
 {
 	struct nl_msg_buff *msgbuff = altbuff ?: &nlsk->msgbuff;
@@ -227,6 +228,7 @@ ssize_t nlsock_sendmsg(struct nl_socket *nlsk, struct nl_msg_buff *altbuff)
 	debug_msg(nlsk, msgbuff->buff, nlhdr->nlmsg_len, true);
 	return mnl_socket_sendto(nlsk->sk, nlhdr, nlhdr->nlmsg_len);
 }
+#endif
 
 int nlsock_send_get_request(struct nl_socket *nlsk, mnl_cb_t cb)
 {
diff --git a/test-cmdline.c b/test-cmdline.c
index b76e2c3e640b..a6c0bd1efc2d 100644
--- a/test-cmdline.c
+++ b/test-cmdline.c
@@ -12,6 +12,12 @@
 #define TEST_NO_WRAPPERS
 #include "internal.h"
 
+#ifdef ETHTOOL_ENABLE_NETLINK
+#define IS_NL 1
+#else
+#define IS_NL 0
+#endif
+
 static struct test_case {
 	int rc;
 	const char *args;
@@ -19,7 +25,10 @@ static struct test_case {
 	{ 1, "" },
 	{ 0, "devname" },
 	{ 0, "15_char_devname" },
-	{ 1, "16_char_devname!" },
+	/* netlink interface allows names up to 127 characters */
+	{ !IS_NL, "16_char_devname!" },
+	{ !IS_NL, "127_char_devname0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcde" },
+	{ 1, "128_char_devname0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef" },
 	/* Argument parsing for -s is specialised */
 	{ 0, "-s devname" },
 	{ 0, "--change devname speed 100 duplex half mdix auto" },
@@ -55,7 +64,8 @@ static struct test_case {
 	{ 0, "-s devname phyad 1" },
 	{ 1, "--change devname phyad foo" },
 	{ 1, "-s devname phyad" },
-	{ 0, "--change devname xcvr external" },
+	/* Deprecated 'xcvr' detected by netlink parser */
+	{ IS_NL, "--change devname xcvr external" },
 	{ 1, "-s devname xcvr foo" },
 	{ 1, "--change devname xcvr" },
 	{ 0, "-s devname wol p" },
@@ -69,7 +79,9 @@ static struct test_case {
 	{ 0, "-s devname msglvl hw on rx_status off" },
 	{ 1, "--change devname msglvl hw foo" },
 	{ 1, "-s devname msglvl hw" },
-	{ 0, "--change devname speed 100 duplex half port tp autoneg on advertise 0x1 phyad 1 xcvr external wol p sopass 01:23:45:67:89:ab msglvl 1" },
+	{ 0, "--change devname speed 100 duplex half port tp autoneg on advertise 0x1 phyad 1 wol p sopass 01:23:45:67:89:ab msglvl 1" },
+	/* Deprecated 'xcvr' detected by netlink parser */
+	{ IS_NL, "--change devname speed 100 duplex half port tp autoneg on advertise 0x1 phyad 1 xcvr external wol p sopass 01:23:45:67:89:ab msglvl 1" },
 	{ 1, "-s devname foo" },
 	{ 1, "-s" },
 	{ 0, "-a devname" },
@@ -294,6 +306,17 @@ int send_ioctl(struct cmd_context *ctx, void *cmd)
 	test_exit(0);
 }
 
+#ifdef ETHTOOL_ENABLE_NETLINK
+struct nl_socket;
+struct nl_msg_buff;
+
+ssize_t nlsock_sendmsg(struct nl_socket *nlsk, struct nl_msg_buff *altbuff)
+{
+	/* If we get this far then parsing succeeded */
+	test_exit(0);
+}
+#endif
+
 int main(void)
 {
 	struct test_case *tc;
diff --git a/test-features.c b/test-features.c
index 6ebb364803a2..b9f80f073d1f 100644
--- a/test-features.c
+++ b/test-features.c
@@ -511,6 +511,17 @@ int send_ioctl(struct cmd_context *ctx, void *cmd)
 	return rc;
 }
 
+#ifdef ETHTOOL_ENABLE_NETLINK
+struct nl_socket;
+struct nl_msg_buff;
+
+ssize_t nlsock_sendmsg(struct nl_socket *nlsk, struct nl_msg_buff *altbuff)
+{
+	/* Should not be called with test-features */
+	exit(1);
+}
+#endif
+
 int main(void)
 {
 	const struct test_case *tc;
-- 
2.25.0

