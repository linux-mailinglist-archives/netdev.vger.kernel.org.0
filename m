Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C0F9C50E
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfHYR0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:26:00 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39734 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728634AbfHYRZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:25:59 -0400
Received: by mail-qt1-f195.google.com with SMTP id l9so15831266qtu.6
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 10:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OQBQV+56l3dMpNr75FvhBT66cS1jMo+PnG0C5SOikqc=;
        b=lKOu1AMN36QKLjjdj9qTHnXLdh5NKXd211ekmc5XO+ThNnpbJn8dtWHC7bQwJXtNHS
         bLSx/gAJLxYIpoOEglX9MrFFgAjLxc4GIGwVZm2LHfbUtMYjJ9JUe2sHV/wMcucmXBwk
         oPGTgibG0pPEs5sY/75YXN4Jbl0e8APqPctHAn3yNoM6kVMjaG6F1XlK2yWm1t5r0HC8
         ZtgsNUgy4FW9qM64snT623/EQ/ty8XCgu1bCD/5b+dUvJI1XoVzVt4dX6D2eVq+7Tsw5
         UgUzoAegVOp6nrH4PX13b3rF3fDq6G+rAXKxi+88nIl+2hoRxBpqyVAnMqsfnJzVqIE0
         yJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OQBQV+56l3dMpNr75FvhBT66cS1jMo+PnG0C5SOikqc=;
        b=pPD09W6vQe8kl6bn5LceMLWxVzVoWuhyLJxwX3HX1lsGGCIsytQien4QJJlMyygGy9
         r3FVdjDg8JsME+GX28OiLvZ0qEb0za3rC1j2X/auWAmGl+hIHw1OZV9hmgm94Ev9pwyC
         PSlsgyoYyBALWQx6AzWz+L6CwiY3ykQ1ibQChwSZ78gNGcuXWCzENvyRpOT5RoOITvuV
         ruaj4WtcLKdUWq9BmWepf2ce9/CudlLGmTkG6jJbr0L/vgSWjfZAW1ocBdTJ89JJBFXH
         6+W1SouNAKaJe7tsSxRE2iM53Z6KuxEkyPzpKgn+1vQ8GUyUhVvS9fuSnphgBTP1tYMJ
         UZ6Q==
X-Gm-Message-State: APjAAAWuWLP/IZFaPM7s4cKbYf8HfdLPpRt2sV3OhWBcYuoMP6mK1RXu
        Jo9/EKLHlq7stywgyFEh5L4d08Fr
X-Google-Smtp-Source: APXvYqxGSQWu0EFFkuopl4uR6p453CMV+Uy4Umm91iqilGhC8YVxkXhp1yM3Wuq6yl8hOQOH4tdYAw==
X-Received: by 2002:ac8:25f2:: with SMTP id f47mr13843653qtf.195.1566753958138;
        Sun, 25 Aug 2019 10:25:58 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id k16sm5022164qki.119.2019.08.25.10.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 10:25:57 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 2/6] net: dsa: do not skip -EOPNOTSUPP in dsa_port_vid_add
Date:   Sun, 25 Aug 2019 13:25:16 -0400
Message-Id: <20190825172520.22798-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190825172520.22798-1-vivien.didelot@gmail.com>
References: <20190825172520.22798-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently dsa_port_vid_add returns 0 if the switch returns -EOPNOTSUPP.

This function is used in the tag_8021q.c code to offload the PVID of
ports, which would simply not work if .port_vlan_add is not supported
by the underlying switch.

Do not skip -EOPNOTSUPP in dsa_port_vid_add but only when necessary,
that is to say in dsa_slave_vlan_rx_add_vid.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/port.c  | 4 ++--
 net/dsa/slave.c | 7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index f75301456430..ef28df7ecbde 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -382,8 +382,8 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
 
 	trans.ph_prepare = true;
 	err = dsa_port_vlan_add(dp, &vlan, &trans);
-	if (err == -EOPNOTSUPP)
-		return 0;
+	if (err)
+		return err;
 
 	trans.ph_prepare = false;
 	return dsa_port_vlan_add(dp, &vlan, &trans);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 33f41178afcc..9d61d9dbf001 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1082,8 +1082,11 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 			return -EBUSY;
 	}
 
-	/* This API only allows programming tagged, non-PVID VIDs */
-	return dsa_port_vid_add(dp, vid, 0);
+	ret = dsa_port_vid_add(dp, vid, 0);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+
+	return 0;
 }
 
 static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
-- 
2.23.0

