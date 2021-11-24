Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4175E45B644
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbhKXIOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:14:25 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60998
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241169AbhKXIOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:14:23 -0500
Received: from frode-threadripper.. (1.general.frode.uk.vpn [10.172.193.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 881073F1E5;
        Wed, 24 Nov 2021 08:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637741467;
        bh=6uwZSc13NYl54gnD6MDLgGTIOPwR6g8Qr5+4s5wkrtg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=j9cd5O+zHiClir+DQoHsWWTP5B7vGAIOu1nKbw4DdSUfEd1KWNLhg+khSydhrRQx5
         GOoArbP/dQbLYWk6P9cylClsfRQ0QeI0WkBjYF7stHh+Cry3QaIdyc4HC7P0nwyfa6
         /uXGXAV9QTrN9VvIOhG51Yxz00ecy4Z1eao5wetkHlZJqxwOxzf8p/Nka//6JjL9sd
         ECrb5vDyv4mO+r15X+viYxiKDiKiYD81H0FDFzW5NLaLAV+hW+wpmpAA25cwQWtnYF
         sl5hEg9wj5gXJa+xAoQ1O9Kvk7LR4bxLVM+jlIBPqwJlcDAESyO13t0+5x1ThBKwTs
         zAedi+rRKRb+w==
From:   Frode Nordahl <frode.nordahl@canonical.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net] netdevsim: Fix physical port index
Date:   Wed, 24 Nov 2021 09:11:06 +0100
Message-Id: <20211124081106.1768660-1-frode.nordahl@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present when a netdevsim device is added, the first physical
port will have an index of 1.  This behavior differ from what any
real hardware driver would do, which would start the index at 0.

When using netdevsim to test the devlink-port interface this
behavior becomes a problem because the provided data is incorrect.

Example:
$ sudo modprobe netdevsim
$ sudo sh -c 'echo "10 1" > /sys/bus/netdevsim/new_device'
$ sudo sh -c 'echo 4 > /sys/class/net/eni10np1/device/sriov_numvfs'
$ sudo devlink dev eswitch set netdevsim/netdevsim10 mode switchdev
$ devlink port show
netdevsim/netdevsim10/0: type eth netdev eni10np1 flavour physical port 1
netdevsim/netdevsim10/128: type eth netdev eni10npf0vf0 flavour pcivf pfnum 0 vfnum 0
netdevsim/netdevsim10/129: type eth netdev eni10npf0vf1 flavour pcivf pfnum 0 vfnum 1
netdevsim/netdevsim10/130: type eth netdev eni10npf0vf2 flavour pcivf pfnum 0 vfnum 2
netdevsim/netdevsim10/131: type eth netdev eni10npf0vf3 flavour pcivf pfnum 0 vfnum 3

With this patch applied you would instead get:
$ sudo modprobe netdevsim
$ sudo sh -c 'echo "10 1" > /sys/bus/netdevsim/new_device'
$ sudo sh -c 'echo 4 > /sys/class/net/eni10np0/device/sriov_numvfs'
$ sudo devlink dev eswitch set netdevsim/netdevsim10 mode switchdev
$ devlink port show
netdevsim/netdevsim10/0: type eth netdev eni10np0 flavour physical port 0
netdevsim/netdevsim10/128: type eth netdev eni10npf0vf0 flavour pcivf pfnum 0 vfnum 0
netdevsim/netdevsim10/129: type eth netdev eni10npf0vf1 flavour pcivf pfnum 0 vfnum 1
netdevsim/netdevsim10/130: type eth netdev eni10npf0vf2 flavour pcivf pfnum 0 vfnum 2
netdevsim/netdevsim10/131: type eth netdev eni10npf0vf3 flavour pcivf pfnum 0 vfnum 3

The above more accurately resembles what a real system would look
like.

Fixes: 8320d1459127 ("netdevsim: implement dev probe/remove skeleton with port initialization")
Signed-off-by: Frode Nordahl <frode.nordahl@canonical.com>
---
 drivers/net/netdevsim/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 54345c096a16..8045852cf0fe 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1371,7 +1371,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	devlink_port = &nsim_dev_port->devlink_port;
 	if (nsim_dev_port_is_pf(nsim_dev_port)) {
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-		attrs.phys.port_number = port_index + 1;
+		attrs.phys.port_number = port_index;
 	} else {
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_PCI_VF;
 		attrs.pci_vf.pf = 0;
-- 
2.32.0

