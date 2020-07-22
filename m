Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6879722A347
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733080AbgGVXsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbgGVXsr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 19:48:47 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F020E22C9E;
        Wed, 22 Jul 2020 23:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595461727;
        bh=m4yEIq0cSS4/p60oRqkTcalzIutZq/Tj4WBsqLGxOpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlqWbv/dGqSLVEIBcjENya3ccwsXEoPUPyIW7qyc+cJWZoqSkRkfLtkrjVukcoZ+w
         RXxiq/xOgH8Zir3Vcxe1eo/kwCWKs5p0w7EUL1YvOr4HCiow5Yv4a5FcR6uDSAuU9y
         hbCaJq8kUAXpZ20v3OfgGUw0tGl1JJZgog4tRpw4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 3/4] netdevsim: support the static IANA VXLAN port flag
Date:   Wed, 22 Jul 2020 16:48:37 -0700
Message-Id: <20200722234838.3200228-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722234838.3200228-1-kuba@kernel.org>
References: <20200722234838.3200228-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
index 4335ab4e5ce0..8a8ba687cc59 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -205,6 +205,7 @@ struct nsim_dev {
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

