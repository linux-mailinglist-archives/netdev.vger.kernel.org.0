Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236286145C
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfGGICp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:02:45 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39061 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGICp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:02:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0A6C41BEA;
        Sun,  7 Jul 2019 04:02:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:02:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=fxfuOW//LY0ODQ7+OFLGqCvYWi3aOATKs4s/aAOeFZs=; b=WYhMdmzX
        hJlN9Ydtd5w8zYqlrtjwD8EJQNVdPV6xt24o20WgZRJjOrLXcATUZCveJxwhkJLx
        VtlRLaui/lmggHIoEiU2PvGzhZYYGaX0cBOU5r9FP7c6DWRPINRWPoUpQPC1yIuP
        QIoLGnCRRMTh5QthZcxlUv+7ioWLYeMQmBTJYYUnqGhHX6Sk9Xp6C/guy0LQWORi
        9wQZ/R3WTif+kP4eA5urPm2H2l0j3EfJrx+vWXpYJCAnJAgQBNoUladjlIe+TDgT
        Bkfri8/u/NsZ9xPDbEVesARPp4K3Cesd5jPW3Phf3FYim0HfE/PxcbCVfSA/J7tr
        Grpx8VdSamI0kA==
X-ME-Sender: <xms:I6chXf2u3EUonjBbOBt1Sodr8SkBNwRBdS_JkCxAH0pmzmSaY0HHBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:I6chXbyI1TZytfufTAX1mUzdkWNyJuNtLR1PMqELzr613sKotCZwiw>
    <xmx:I6chXaW2bwc4d18QqhTRtHOtJc0tHKI-uvXdFRhGj-731M9e-tQpXA>
    <xmx:I6chXdAjjwheuzrlrg8yXpmsZ70I1SWY4-7UA2qPp6qr5qqyQfOiGQ>
    <xmx:JKchXWeZ8wRd6Ce9yXneWEFpx472ekHVAEL1qCjIuDz1zkfgR6Tv1g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65FE08005C;
        Sun,  7 Jul 2019 04:02:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 5/7] devlink: Set NETLINK_NO_ENOBUFS when monitoring events
Date:   Sun,  7 Jul 2019 11:01:58 +0300
Message-Id: <20190707080200.3699-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707080200.3699-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707080200.3699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

If we lost an event, there is nothing we can do in order to recover it.
Set above mentioned socket option on the netlink socket when monitoring
devlink events, so that `devlink monitor` will not abort in case we are
not draining the receive buffer fast enough.

The number of events we lost can be retrieved using:

# cat /proc/net/netlink | grep `pidof devlink` | awk '{ print $9 }'

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 22 +++++++++++++++++++++-
 devlink/mnlg.c    | 12 ++++++++++++
 devlink/mnlg.h    |  2 ++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index b9fce850ee00..817b74259ec3 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -140,6 +140,19 @@ static int _mnlg_socket_group_add(struct mnlg_socket *nlg,
 	return 0;
 }
 
+static int _mnlg_socket_setsockopt(struct mnlg_socket *nlg, int type,
+				   void *buf, socklen_t len)
+{
+	int err;
+
+	err = mnlg_socket_setsockopt(nlg, type, buf, len);
+	if (err < 0) {
+		pr_err("Failed to call mnlg_socket_setsockopt\n");
+		return -errno;
+	}
+	return 0;
+}
+
 struct ifname_map {
 	struct list_head list;
 	char *bus_name;
@@ -4020,7 +4033,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 
 static int cmd_mon_show(struct dl *dl)
 {
-	int err;
+	int err, one = 1;
 	unsigned int index = 0;
 	const char *cur_obj;
 
@@ -4035,6 +4048,13 @@ static int cmd_mon_show(struct dl *dl)
 			return -EINVAL;
 		}
 	}
+	/* It is possible to lose some events if we are not draining the socket
+	 * receive buffer fast enough. Keep processing events and do not abort.
+	 */
+	err = _mnlg_socket_setsockopt(dl->nlg, NETLINK_NO_ENOBUFS, &one,
+				      sizeof(one));
+	if (err)
+		return err;
 	err = _mnlg_socket_group_add(dl->nlg, DEVLINK_GENL_MCGRP_CONFIG_NAME);
 	if (err)
 		return err;
diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index ee125df042f0..23e6e794b508 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -231,6 +231,18 @@ int mnlg_socket_group_add(struct mnlg_socket *nlg, const char *group_name)
 	return 0;
 }
 
+int mnlg_socket_setsockopt(struct mnlg_socket *nlg, int type, void *buf,
+			   socklen_t len)
+{
+	int err;
+
+	err = mnl_socket_setsockopt(nlg->nl, type, buf, len);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static int get_family_id_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
diff --git a/devlink/mnlg.h b/devlink/mnlg.h
index 4d1babf3b4c2..49154215729e 100644
--- a/devlink/mnlg.h
+++ b/devlink/mnlg.h
@@ -21,6 +21,8 @@ struct nlmsghdr *mnlg_msg_prepare(struct mnlg_socket *nlg, uint8_t cmd,
 int mnlg_socket_send(struct mnlg_socket *nlg, const struct nlmsghdr *nlh);
 int mnlg_socket_recv_run(struct mnlg_socket *nlg, mnl_cb_t data_cb, void *data);
 int mnlg_socket_group_add(struct mnlg_socket *nlg, const char *group_name);
+int mnlg_socket_setsockopt(struct mnlg_socket *nlg, int type, void *buf,
+			   socklen_t len);
 struct mnlg_socket *mnlg_socket_open(const char *family_name, uint8_t version);
 void mnlg_socket_close(struct mnlg_socket *nlg);
 
-- 
2.20.1

