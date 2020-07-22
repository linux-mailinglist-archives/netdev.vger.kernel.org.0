Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66262228D94
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 03:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbgGVB12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 21:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731599AbgGVB10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 21:27:26 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 483BF208E4;
        Wed, 22 Jul 2020 01:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595381245;
        bh=Cg9Si7MgCEn8QKF5o4itCLFhnHeZQZHq5qtC9sNzaas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeKgJ4xZVKZCmesdq1HszLg78Tc3kavW8H/VYODAaOfxDoVx5th6D+zVTY+WAMwCT
         ZHAYPhqQRlE8eq6IWpWmRFN2pUOyI8NJ/vTy6oROQXdsyjdVcnVTWXg3ruBhJ5KrW7
         pw/Q99l6waSTdLWZPT4VDOa3pR11RxrlGH360KOk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v1 2/7] netdevsim: add warnings on unexpected UDP tunnel port errors
Date:   Tue, 21 Jul 2020 18:27:11 -0700
Message-Id: <20200722012716.2814777-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722012716.2814777-1-kuba@kernel.org>
References: <20200722012716.2814777-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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

