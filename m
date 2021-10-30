Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D49440A84
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhJ3RVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 13:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhJ3RVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 13:21:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6081E60FC3;
        Sat, 30 Oct 2021 17:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635614333;
        bh=p46eIFq6HKnyMSsWUTbgjKLtvp+4VBdj642xvaUlp+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7IIntXipYp6Su2pu/V4zN+3OKS8oZ9BheS9R4dbhUpuMZ/5b/1OQepnM+yG2qSkW
         dxmRK7OlqV42D+YoBBwCXrO81/SALHoO90+MP4NWucOm52aH8hh2JtOj2rGIj0gy50
         /sW9Me1lYPOoWWn09Evli2Tm7KEP0dAjAlrwWeYZM+sUlZTZv9cT3Vus2wgNt7qw1V
         1GXd4e+cr0l0110QrS693K1koPION3bVPbDgqnPQvrz3tdIOtOHOSzA0LEt3flm89/
         4V9Xrj6v+Fd9nSdqVfvObGylE3LVuHCU29VZUK9pprKlJQ7U5nM6qrHifkR/USDYcl
         cYLPCI3x1MIyw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leon@kernel.org,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/4] ethtool: push the rtnl_lock into dev_ethtool()
Date:   Sat, 30 Oct 2021 10:18:48 -0700
Message-Id: <20211030171851.1822583-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030171851.1822583-1-kuba@kernel.org>
References: <20211030171851.1822583-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't take the lock in net/core/dev_ioctl.c,
we'll have things to do outside rtnl_lock soon.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev_ioctl.c |  2 --
 net/ethtool/ioctl.c  | 14 +++++++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 0e87237fd871..cbab5fec64b1 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -518,9 +518,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 
 	case SIOCETHTOOL:
 		dev_load(net, ifr->ifr_name);
-		rtnl_lock();
 		ret = dev_ethtool(net, ifr, data);
-		rtnl_unlock();
 		if (colon)
 			*colon = ':';
 		return ret;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 44430b6ab843..52bfc5b82ec3 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2700,7 +2700,8 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
 
-int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
+static int
+__dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 {
 	struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
 	u32 ethcmd, sub_cmd;
@@ -3000,6 +3001,17 @@ int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 	return rc;
 }
 
+int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
+{
+	int rc;
+
+	rtnl_lock();
+	rc = __dev_ethtool(net, ifr, useraddr);
+	rtnl_unlock();
+
+	return rc;
+}
+
 struct ethtool_rx_flow_key {
 	struct flow_dissector_key_basic			basic;
 	union {
-- 
2.31.1

