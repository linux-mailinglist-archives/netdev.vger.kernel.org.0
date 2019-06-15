Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDE247051
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfFOOJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50783 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 87BCB21EAE;
        Sat, 15 Jun 2019 10:09:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=PNjEL9NgRlmRfio2zVd0VgYsZO+aCYvHZKgBOwz5+ok=; b=PCy7wmir
        JfE2jRZDPh4XRI0T1KoZCiLm7sfI6Xv/LcZqHyQcaeiva8AI3HeftpvARv4y7pAq
        KfbPzCG1MMYx/ETuxp0ogtPm32qI8POao9/+aM9R442PvlmUSnbPHdtqNnYXHg9d
        lN+BBDIE4L44zqflL6uswBlqC8Fq5h5JZsONYSHZb40Bu+E9bAhe5G+Tm3qBaRh4
        J4KX6n/uuBmL1DeP27inbUSRBicP0FSN3vTzkSPv4K7vBMU0HrsdhRlDSaGFXFyC
        cUkIzSQ2qrJzW0BmTl+F3xffHf/vqZCIvSH7Leofma4K9NdsS0+vhcc8KeMut91a
        5RM11LQoAlLo/Q==
X-ME-Sender: <xms:HPwEXQlXDNykugTB6aqyi_7bDnUpUW_gEht-Z6hgcBfnghPsAV1bAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepje
X-ME-Proxy: <xmx:HPwEXRFBGU0UL9lNgIefYC_vysFqxDOreevhIv7F4OsBb8_2MCLKug>
    <xmx:HPwEXXH-qcBrwfB40fNKx29V3uPNcRPTjI-3aoUqtNQhjGeQNil6HA>
    <xmx:HPwEXSztl6O_w997-b2VNL1gP7qyHEUx8QDD-GmAzjwB8hrgONWudA>
    <xmx:HPwEXdMpaxUDVCNfOwlig0QlXSPtJVIiBHhpzrePRVCFVeEjM5BLoA>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3675380085;
        Sat, 15 Jun 2019 10:09:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/17] netdevsim: Adjust accounting for IPv6 multipath notifications
Date:   Sat, 15 Jun 2019 17:07:42 +0300
Message-Id: <20190615140751.17661-9-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Prepare the driver to process IPv6 multipath routes.

Increase / decrease the resource usage based on the number of nexthops
notified in an IPv6 multipath notification.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/fib.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 83ba5113210d..6e5498ef3855 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -137,19 +137,20 @@ static int nsim_fib_rule_event(struct nsim_fib_data *data,
 }
 
 static int nsim_fib_account(struct nsim_fib_entry *entry, bool add,
+			    unsigned int num_rt,
 			    struct netlink_ext_ack *extack)
 {
 	int err = 0;
 
 	if (add) {
-		if (entry->num < entry->max) {
-			entry->num++;
+		if (entry->num + num_rt < entry->max) {
+			entry->num += num_rt;
 		} else {
 			err = -ENOSPC;
 			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported fib entries");
 		}
 	} else {
-		entry->num--;
+		entry->num -= num_rt;
 	}
 
 	return err;
@@ -159,14 +160,20 @@ static int nsim_fib_event(struct nsim_fib_data *data,
 			  struct fib_notifier_info *info, bool add)
 {
 	struct netlink_ext_ack *extack = info->extack;
+	struct fib6_entry_notifier_info *fen6_info;
+	unsigned int num_rt = 1;
 	int err = 0;
 
 	switch (info->family) {
 	case AF_INET:
-		err = nsim_fib_account(&data->ipv4.fib, add, extack);
+		err = nsim_fib_account(&data->ipv4.fib, add, num_rt, extack);
 		break;
 	case AF_INET6:
-		err = nsim_fib_account(&data->ipv6.fib, add, extack);
+		fen6_info = container_of(info, struct fib6_entry_notifier_info,
+					 info);
+		if (fen6_info->multipath_rt)
+			num_rt = fen6_info->nsiblings + 1;
+		err = nsim_fib_account(&data->ipv6.fib, add, num_rt, extack);
 		break;
 	}
 
-- 
2.20.1

