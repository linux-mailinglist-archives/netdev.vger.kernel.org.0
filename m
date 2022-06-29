Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAA15608E8
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 20:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiF2ST0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 14:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiF2STZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 14:19:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ED115FD0;
        Wed, 29 Jun 2022 11:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4991B8263E;
        Wed, 29 Jun 2022 18:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F78CC341CB;
        Wed, 29 Jun 2022 18:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656526762;
        bh=kdIIeLDqIgnTKNaxiCRQDtXvxu7axxS0vPuav/LvePc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1bP6T47Z66h/zCqd0ZL8QMzWGnBrqmk/r+TlSHyMbuFFb2w+XI8s8fpf/kooO5O5
         4HDeAwA41HbyIFa7m48F4vefcu7t/ug9DVUZF68eKBVMl+21NXRBQGTumtCYyawErI
         xB9YTKyayPK4+OOIpqnZjpK/tg5oVQ85SW8IhDbXGtAm63YWA0WByxh9Ic00VWcrjx
         gt0i1zesb2+mKcwNsrMKMm6mnLOpMfQ6+ABuwmdTJjfFL7/bFsnSHL33taNDfBRYg1
         niJJL+4QLxj63nkp1OuUud8mx9aOoVPhe9DGmR3GfV8EOvJ+eA6BwzZN/pE6xWWSfu
         24DLLMoexrvQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net 2/2] selftest: tun: add test for NAPI dismantle
Date:   Wed, 29 Jun 2022 11:19:11 -0700
Message-Id: <20220629181911.372047-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629181911.372047-1-kuba@kernel.org>
References: <20220629181911.372047-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Being lazy does not pay, add the test for various
ordering of tun queue close / detach / destroy.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: shuah@kernel.org
CC: linux-kselftest@vger.kernel.org
---
 tools/testing/selftests/net/Makefile |   2 +-
 tools/testing/selftests/net/tun.c    | 162 +++++++++++++++++++++++++++
 2 files changed, 163 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/tun.c

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 7ea54af55490..ddad703ace34 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -54,7 +54,7 @@ TEST_GEN_FILES += ipsec
 TEST_GEN_FILES += ioam6_parser
 TEST_GEN_FILES += gro
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
-TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
+TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls tun
 TEST_GEN_FILES += toeplitz
 TEST_GEN_FILES += cmsg_sender
 TEST_GEN_FILES += stress_reuseport_listen
diff --git a/tools/testing/selftests/net/tun.c b/tools/testing/selftests/net/tun.c
new file mode 100644
index 000000000000..fa83918b62d1
--- /dev/null
+++ b/tools/testing/selftests/net/tun.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/if.h>
+#include <linux/if_tun.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+#include <sys/ioctl.h>
+#include <sys/socket.h>
+
+#include "../kselftest_harness.h"
+
+static int tun_attach(int fd, char *dev)
+{
+	struct ifreq ifr;
+
+	memset(&ifr, 0, sizeof(ifr));
+	strcpy(ifr.ifr_name, dev);
+	ifr.ifr_flags = IFF_ATTACH_QUEUE;
+
+	return ioctl(fd, TUNSETQUEUE, (void *) &ifr);
+}
+
+static int tun_detach(int fd, char *dev)
+{
+	struct ifreq ifr;
+
+	memset(&ifr, 0, sizeof(ifr));
+	strcpy(ifr.ifr_name, dev);
+	ifr.ifr_flags = IFF_DETACH_QUEUE;
+
+	return ioctl(fd, TUNSETQUEUE, (void *) &ifr);
+}
+
+static int tun_alloc(char *dev)
+{
+	struct ifreq ifr;
+	int fd, err;
+
+	fd = open("/dev/net/tun", O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "can't open tun: %s\n", strerror(errno));
+		return fd;
+	}
+
+	memset(&ifr, 0, sizeof(ifr));
+	strcpy(ifr.ifr_name, dev);
+	ifr.ifr_flags = IFF_TAP | IFF_NAPI | IFF_MULTI_QUEUE;
+
+	err = ioctl(fd, TUNSETIFF, (void *) &ifr);
+	if (err < 0) {
+		fprintf(stderr, "can't TUNSETIFF: %s\n", strerror(errno));
+		close(fd);
+		return err;
+	}
+	strcpy(dev, ifr.ifr_name);
+	return fd;
+}
+
+static int tun_delete(char *dev)
+{
+	struct {
+		struct nlmsghdr  nh;
+		struct ifinfomsg ifm;
+		unsigned char    data[64];
+	} req;
+	struct rtattr *rta;
+	int ret, rtnl;
+
+	rtnl = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_ROUTE);
+	if (rtnl < 0) {
+		fprintf(stderr, "can't open rtnl: %s\n", strerror(errno));
+		return 1;
+	}
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_ALIGN(NLMSG_LENGTH(sizeof(req.ifm)));
+	req.nh.nlmsg_flags = NLM_F_REQUEST;
+	req.nh.nlmsg_type = RTM_DELLINK;
+
+	req.ifm.ifi_family = AF_UNSPEC;
+
+	rta = (struct rtattr *)(((char *)&req) + NLMSG_ALIGN(req.nh.nlmsg_len));
+	rta->rta_type = IFLA_IFNAME;
+	rta->rta_len = RTA_LENGTH(IFNAMSIZ);
+	req.nh.nlmsg_len += rta->rta_len;
+	memcpy(RTA_DATA(rta), dev, IFNAMSIZ);
+
+	ret = send(rtnl, &req, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		fprintf(stderr, "can't send: %s\n", strerror(errno));
+	ret = (unsigned int)ret != req.nh.nlmsg_len;
+
+	close(rtnl);
+	return ret;
+}
+
+FIXTURE(tun)
+{
+	char ifname[IFNAMSIZ];
+	int fd, fd2;
+};
+
+FIXTURE_SETUP(tun)
+{
+	memset(self->ifname, 0, sizeof(self->ifname));
+
+	self->fd = tun_alloc(self->ifname);
+	ASSERT_GE(self->fd, 0);
+
+	self->fd2 = tun_alloc(self->ifname);
+	ASSERT_GE(self->fd2, 0);
+}
+
+FIXTURE_TEARDOWN(tun)
+{
+	if (self->fd >= 0)
+		close(self->fd);
+	if (self->fd2 >= 0)
+		close(self->fd2);
+}
+
+TEST_F(tun, delete_detach_close) {
+	EXPECT_EQ(tun_delete(self->ifname), 0);
+	EXPECT_EQ(tun_detach(self->fd, self->ifname), -1);
+	EXPECT_EQ(errno, 22);
+}
+
+TEST_F(tun, detach_delete_close) {
+	EXPECT_EQ(tun_detach(self->fd, self->ifname), 0);
+	EXPECT_EQ(tun_delete(self->ifname), 0);
+}
+
+TEST_F(tun, detach_close_delete) {
+	EXPECT_EQ(tun_detach(self->fd, self->ifname), 0);
+	close(self->fd);
+	self->fd = -1;
+	EXPECT_EQ(tun_delete(self->ifname), 0);
+}
+
+TEST_F(tun, reattach_delete_close) {
+	EXPECT_EQ(tun_detach(self->fd, self->ifname), 0);
+	EXPECT_EQ(tun_attach(self->fd, self->ifname), 0);
+	EXPECT_EQ(tun_delete(self->ifname), 0);
+}
+
+TEST_F(tun, reattach_close_delete) {
+	EXPECT_EQ(tun_detach(self->fd, self->ifname), 0);
+	EXPECT_EQ(tun_attach(self->fd, self->ifname), 0);
+	close(self->fd);
+	self->fd = -1;
+	EXPECT_EQ(tun_delete(self->ifname), 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.36.1

