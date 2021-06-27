Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DBD3B53A7
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhF0ONN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhF0ONE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:13:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94999C0617A6
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:39 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id o11so11270507ejd.4
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eqjTrbP8WLdm2CiHqRr8RY8N7+TrvxKyRWH+kkJBIzY=;
        b=prYv8boBImsZO3XgQQYhT8bIJ6AnkHY9B04FjWLXefNXlGhKGjmaz4Ei7HsbkuIoxv
         VRidw6jpgIlYdld03b+8tLJjEYDF33kUISZMvUMPB2xSBeq6xPaHmh5H3Mz09fkbnzR4
         BinXyejE539Rgv0CRqNlAwfTdSiMKp1F7hv6c+fAVUHQwC8tqqyiMCAfxNS+RfYkNbLt
         LPW4MC9IbvRt8tm+fZfUtBecsmBWgVJ4A4Fv/aQ5GobITh0NM+jtbMNdjGJXh/AYg03u
         Nimy9blVRNOaJxMrrvBngt1cK2itx4EFlMNRkALPi/7LY3YaMBWTWr4wQjBWKIQxjvhd
         OsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eqjTrbP8WLdm2CiHqRr8RY8N7+TrvxKyRWH+kkJBIzY=;
        b=H5WO74C+ACMASmBn/OMcJFJ0qPglzTrWm0IHpduc/qhgqdJts7KInd5j+2vBov4cfZ
         2T0/Zp9ifA4rbJMLzvUAqO1M8dR2BFD8cgokpJmgiUtPjteUnVXO781p4OFRzpnrIWOX
         CtiUA3CfW3b0hgoSGtMA7A1wJMs36zL01kEwLCTfzDH5qxknt4Ru4lN7zDaQ/vPw3oQs
         ddBCPcvra0OhN92H0jlgTCABqBOjHKJ3MiG+K4H1tG+UM5WSYDxI425b+M39ZRg/xcGn
         7hS4Qkp6aCvdm1hGiOhAdZWOLzFxC/ZjfhAcNraFuAvUw/uU4liXVnknhHF646VF1u4D
         CKzA==
X-Gm-Message-State: AOAM532xdEZ//9RJWLjCUnAuA0XxTkxwWlkG6uwcZXiRChDMdBvYH2sr
        UWIjMfE09jtesrNydJ4TPGFL6VmLaKU=
X-Google-Smtp-Source: ABdhPJydZbS+5vlvMb+Eaaa/H15g1P6tRQrBcg3iYmDRwKYK+4H4WFfPi8RGEkDkLRZGKYU7/v6zOA==
X-Received: by 2002:a17:906:c10f:: with SMTP id do15mr17136408ejc.475.1624803038021;
        Sun, 27 Jun 2021 07:10:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v3 net-next 15/15] net: dsa: replay the local bridge FDB entries pointing to the bridge dev too
Date:   Sun, 27 Jun 2021 17:10:13 +0300
Message-Id: <20210627141013.1273942-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When we join a bridge that already has some local addresses pointing to
itself, we do not get those notifications. Similarly, when we leave that
bridge, we do not get notifications for the deletion of those entries.
The only switchdev notifications we get are those of entries added while
the DSA port is enslaved to the bridge.

This makes use cases such as the following work properly (with the
number of additions and removals properly balanced):

ip link add br0 type bridge
ip link add br1 type bridge
ip link set br0 address 00:01:02:03:04:05
ip link set br1 address 00:01:02:03:04:05
ip link set swp0 up
ip link set swp1 up
ip link set swp0 master br0
ip link set swp1 master br1
ip link set br0 up
ip link set br1 up
ip link del br1 # 00:01:02:03:04:05 still installed on the CPU port
ip link del br0 # 00:01:02:03:04:05 finally removed from the CPU port

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 255172a8599a..a833684349cb 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -199,11 +199,17 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	/* Forwarding and termination FDB entries on the port */
 	err = br_fdb_replay(br, brport_dev, dp, true,
 			    &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	/* Termination FDB entries on the bridge itself */
+	err = br_fdb_replay(br, br, dp, true, &dsa_slave_switchdev_notifier);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	err = br_vlan_replay(br, brport_dev, dp, true,
 			     &dsa_slave_switchdev_blocking_notifier, extack);
 	if (err && err != -EOPNOTSUPP)
@@ -225,11 +231,17 @@ static int dsa_port_switchdev_unsync_objs(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	/* Forwarding and termination FDB entries on the port */
 	err = br_fdb_replay(br, brport_dev, dp, false,
 			    &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	/* Termination FDB entries on the bridge itself */
+	err = br_fdb_replay(br, br, dp, false, &dsa_slave_switchdev_notifier);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	err = br_vlan_replay(br, brport_dev, dp, false,
 			     &dsa_slave_switchdev_blocking_notifier, extack);
 	if (err && err != -EOPNOTSUPP)
-- 
2.25.1

