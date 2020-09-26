Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08852795BB
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbgIZA5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgIZA47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:56:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A967A23899;
        Sat, 26 Sep 2020 00:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081818;
        bh=TsrjE9mnyr583VorfqMaJgfyDAVmFGbxth0jeTvekAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESCYF/XUYXaDmrgFZ0b5LJ7k3rGHtxgKK8Sm0Ywui7M8v9ezGLRnb7XvgKnNNTqtI
         ERxOh5x2EGB3gh4FwImw1w29Rffk/ajwlgGa2yz6jTeSq267B1sJVhK77jEPw3qNCn
         jk9/Z04gd0KodavIRr/hvuB7eTe6rt77UfNJkbiM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 08/10] netdevsim: support the static IANA VXLAN port flag
Date:   Fri, 25 Sep 2020 17:56:47 -0700
Message-Id: <20200926005649.3285089-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow setting UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/netdevsim.h   | 1 +
 drivers/net/netdevsim/udp_tunnels.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 11c840835517..a39f7f28b263 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -216,6 +216,7 @@ struct nsim_dev {
 		bool open_only;
 		bool ipv4_only;
 		bool shared;
+		bool static_iana_vxlan;
 		u32 sleep;
 	} udp_ports;
 };
diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/udp_tunnels.c
index 6b98e6d1188f..6ab023acefd6 100644
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -186,6 +186,8 @@ int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
 		info->flags |= UDP_TUNNEL_NIC_INFO_IPV4_ONLY;
 	if (nsim_dev->udp_ports.shared)
 		info->shared = &nsim_dev->udp_ports.utn_shared;
+	if (nsim_dev->udp_ports.static_iana_vxlan)
+		info->flags |= UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN;
 
 	dev->udp_tunnel_nic_info = info;
 	return 0;
@@ -207,6 +209,8 @@ void nsim_udp_tunnels_debugfs_create(struct nsim_dev *nsim_dev)
 			    &nsim_dev->udp_ports.ipv4_only);
 	debugfs_create_bool("udp_ports_shared", 0600, nsim_dev->ddir,
 			    &nsim_dev->udp_ports.shared);
+	debugfs_create_bool("udp_ports_static_iana_vxlan", 0600, nsim_dev->ddir,
+			    &nsim_dev->udp_ports.static_iana_vxlan);
 	debugfs_create_u32("udp_ports_sleep", 0600, nsim_dev->ddir,
 			   &nsim_dev->udp_ports.sleep);
 }
-- 
2.26.2

