Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56E52795B8
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgIZA45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbgIZA45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:56:57 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F1B422211;
        Sat, 26 Sep 2020 00:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081816;
        bh=Cg9Si7MgCEn8QKF5o4itCLFhnHeZQZHq5qtC9sNzaas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jI8O+oCmQu1776AYelZm14he0bT2Y1DF17Bc8eRGg7OOqql7XAFbOg8sGaHJO/vtf
         mKX67ahwdTlSlzXCcZAORFjMiF7KyQic0H+rWql5f/ORpZ0mqMywSMC6Ix9ECFZLox
         WrSIVrZaxSF3WHpx7FilFyBjOq0g4hWG2OVfSnkk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 02/10] netdevsim: add warnings on unexpected UDP tunnel port errors
Date:   Fri, 25 Sep 2020 17:56:41 -0700
Message-Id: <20200926005649.3285089-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should never see a removal of a port which is not in the table
or adding a port to an occupied entry in the table. To make sure
such errors don't escape the checks in the test script add a
warning/kernel spat.

Error injection will not trigger those, nor should it ever put
us in a bad state.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/udp_tunnels.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/udp_tunnels.c
index 22c06a76033c..ad65b860bd7b 100644
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -22,11 +22,13 @@ nsim_udp_tunnel_set_port(struct net_device *dev, unsigned int table,
 		msleep(ns->udp_ports.sleep);
 
 	if (!ret) {
-		if (ns->udp_ports.ports[table][entry])
+		if (ns->udp_ports.ports[table][entry]) {
+			WARN(1, "entry already in use\n");
 			ret = -EBUSY;
-		else
+		} else {
 			ns->udp_ports.ports[table][entry] =
 				be16_to_cpu(ti->port) << 16 | ti->type;
+		}
 	}
 
 	netdev_info(dev, "set [%d, %d] type %d family %d port %d - %d\n",
@@ -50,10 +52,13 @@ nsim_udp_tunnel_unset_port(struct net_device *dev, unsigned int table,
 	if (!ret) {
 		u32 val = be16_to_cpu(ti->port) << 16 | ti->type;
 
-		if (val == ns->udp_ports.ports[table][entry])
+		if (val == ns->udp_ports.ports[table][entry]) {
 			ns->udp_ports.ports[table][entry] = 0;
-		else
+		} else {
+			WARN(1, "entry not installed %x vs %x\n",
+			     val, ns->udp_ports.ports[table][entry]);
 			ret = -ENOENT;
+		}
 	}
 
 	netdev_info(dev, "unset [%d, %d] type %d family %d port %d - %d\n",
-- 
2.26.2

