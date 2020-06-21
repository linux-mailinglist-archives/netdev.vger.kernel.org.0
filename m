Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52506202A5E
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 13:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgFULqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 07:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729945AbgFULqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 07:46:21 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0870C061795
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:20 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ga4so1466010ejb.11
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6f2ClDULnOQ1Mg79ztlYA9K8ODmXmfOUPj+uACSUjIE=;
        b=VQmujBJF8J5DlkL9ZTjWILmvGY6H0bmkNuRB1XqVWaPwt21l+sulkuAdbPBa/Ix19V
         obMrvsovgy3y63dT1ah0Y++l7BtIm5JpWRLupo1ZBtoYWI1b5//bEOoAjHCpbmYoA41F
         n4y3VT90id16utFbw00Pj3NjWxVinzYDD/hqPSkv6uoKpjwPAwGx9Y5RYXOOeMhnoCS0
         kxX2Dt3etxUAfDqi60N9Qc3Z+uTjEy8gRyIKdrnkeQhTQOXSlonMa6++fZ2UwDCuBW2w
         5tI+TrT04Pdn4AnxXgJ7nC9PvstlHkMmBUPglSXgGGbMDnt/cO6MrnPdvNQAuhKy4Gl8
         BVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6f2ClDULnOQ1Mg79ztlYA9K8ODmXmfOUPj+uACSUjIE=;
        b=bQhLhbuOc/xq1+hXQYwFZmpLgok4s7zO/ti4pKKFh9ohIL69J1JMIFi3Uxn0Ej6IfS
         IBa9b+Uj9CNHI8++0yKHlFUZqkox6KcGFdBdLSZLc+rnQfg7ysCoPtzriREKR6nRYjCh
         4ePgCn4JIJV0ZULXnGOfegdZwpG5pbWLVCjYm+iUcCpL36aH9adHonyQy44806+FDP7u
         Q09mdhsKF6wXctAu3Fwab55+ofazij7qoD8fMj5qfUf3wVF7F/2yDljPDx8zIcjSS8vt
         BIAZvRbwJGm1VVm51hGWmkJByeCAII0KKoKhvHlBWPHOd3n6a8q51RuRopaF21KE5pae
         5hHA==
X-Gm-Message-State: AOAM533VqP9IZOijw140wzbCGL6YVIxeTb9FE3S75FQogKkegAExmdE1
        3Ld3ugYabfMuRtwEPPxlHbL9xCDN
X-Google-Smtp-Source: ABdhPJxEawy7Rmm5Zk4I21YLPWTeCdX6bPBwzKOu1JVJoo4TA2PxMV4LLVbMN62mWokm0i34+isHQA==
X-Received: by 2002:a17:906:cc58:: with SMTP id mm24mr12211006ejb.134.1592739979307;
        Sun, 21 Jun 2020 04:46:19 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id k23sm9155508ejg.89.2020.06.21.04.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 04:46:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: [PATCH net-next 1/5] net: mscc: ocelot: fix encoding destination ports into multicast IPv4 address
Date:   Sun, 21 Jun 2020 14:45:59 +0300
Message-Id: <20200621114603.119608-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200621114603.119608-1-olteanv@gmail.com>
References: <20200621114603.119608-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot hardware designers have made some hacks to support multicast
IPv4 and IPv6 addresses. Normally, the MAC table matches on MAC
addresses and the destination ports are selected through the DEST_IDX
field of the respective MAC table entry. The DEST_IDX points to a Port
Group ID (PGID) which contains the bit mask of ports that frames should
be forwarded to. But there aren't a lot of PGIDs (only 80 or so) and
there are clearly many more IP multicast addresses than that, so it
doesn't scale to use this PGID mechanism, so something else was done.
Since the first portion of the MAC address is known, the hack they did
was to use a single PGID for _flooding_ unknown IPv4 multicast
(PGID_MCIPV4 == 62), but for known IP multicast, embed the destination
ports into the first 3 bytes of the MAC address recorded in the MAC
table.

The VSC7514 datasheet explains it like this:

    3.9.1.5 IPv4 Multicast Entries

    MAC table entries with the ENTRY_TYPE = 2 settings are interpreted
    as IPv4 multicast entries.
    IPv4 multicasts entries match IPv4 frames, which are classified to
    the specified VID, and which have DMAC = 0x01005Exxxxxx, where
    xxxxxx is the lower 24 bits of the MAC address in the entry.
    Instead of a lookup in the destination mask table (PGID), the
    destination set is programmed as part of the entry MAC address. This
    is shown in the following table.

    Table 78: IPv4 Multicast Destination Mask

        Destination Ports            Record Bit Field
        ---------------------------------------------
        Ports 10-0                   MAC[34-24]

    Example: All IPv4 multicast frames in VLAN 12 with MAC 01005E112233 are
    to be forwarded to ports 3, 8, and 9. This is done by inserting the
    following entry in the MAC table entry:
    VALID = 1
    VID = 12
    MAC = 0x000308112233
    ENTRY_TYPE = 2
    DEST_IDX = 0

But this procedure is not at all what's going on in the driver. In fact,
the code that embeds the ports into the MAC address looks like it hasn't
actually been tested. This patch applies the procedure described in the
datasheet.

Since there are many other fixes to be made around multicast forwarding
until it works properly, there is no real reason for this patch to be
backported to stable trees, or considered a real fix of something that
should have worked.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 52b180280d2f..922c3e855c3a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -973,14 +973,14 @@ int ocelot_port_obj_add_mdb(struct net_device *dev,
 	addr[0] = 0;
 
 	if (!new) {
-		addr[2] = mc->ports << 0;
-		addr[1] = mc->ports << 8;
+		addr[1] = mc->ports >> 8;
+		addr[2] = mc->ports & 0xff;
 		ocelot_mact_forget(ocelot, addr, vid);
 	}
 
 	mc->ports |= BIT(port);
-	addr[2] = mc->ports << 0;
-	addr[1] = mc->ports << 8;
+	addr[1] = mc->ports >> 8;
+	addr[2] = mc->ports & 0xff;
 
 	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
 }
@@ -1005,9 +1005,9 @@ int ocelot_port_obj_del_mdb(struct net_device *dev,
 		return -ENOENT;
 
 	memcpy(addr, mc->addr, ETH_ALEN);
-	addr[2] = mc->ports << 0;
-	addr[1] = mc->ports << 8;
 	addr[0] = 0;
+	addr[1] = mc->ports >> 8;
+	addr[2] = mc->ports & 0xff;
 	ocelot_mact_forget(ocelot, addr, vid);
 
 	mc->ports &= ~BIT(port);
@@ -1017,8 +1017,8 @@ int ocelot_port_obj_del_mdb(struct net_device *dev,
 		return 0;
 	}
 
-	addr[2] = mc->ports << 0;
-	addr[1] = mc->ports << 8;
+	addr[1] = mc->ports >> 8;
+	addr[2] = mc->ports & 0xff;
 
 	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
 }
-- 
2.25.1

