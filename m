Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21569C511
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfHYR0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:26:04 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40774 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbfHYR0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:26:04 -0400
Received: by mail-qk1-f195.google.com with SMTP id s145so12342776qke.7
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 10:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HVb8LPXVcr6s5j83x4sRZAcVJykmQyYLJ4iZL3GY+3I=;
        b=LOr8RCjSPyq5rkY7+Bm5/S67Yyt7x/Vr7s3xG5on4Zc0b6d3V0h7FLj5+AQuLnPooS
         MpSp2pUWbLjLydFscQlumdxX5xu68YcpeOSynCiFFyYd/wifvbzc/3QEeGwaPUcBAErz
         asxQC5go5tukDwVbHQzy1kuMKCdpuWZCbkrYP6RIYK2Z6xmrjig1irv/u61rkUJZmX9N
         p20A0D9trUZXiXjjlgPpz7v1rrPhHAhMjDWiovQac9ED8su2CKyc6oc9eT4q9oEeHtMF
         myevw2Gp6kksn2sWQgXLVmvled00tuQ3sD8bpuYLiQn1SD9PBBGcTYu8tsMiOdHT+bTe
         XYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVb8LPXVcr6s5j83x4sRZAcVJykmQyYLJ4iZL3GY+3I=;
        b=Ymy6rzhi2NzGLmD4aPdn7zaBaD2tL7KWR6Me5xtejbjxzH90yaQAFpjqK8Q5y7KYIg
         otrq+wDkQ7Jc3dAKhTsVQgEnDioSxfuFZAdvLhbdYvDcY9TGAjNmKaqs1qW1WNVvV+a1
         7qokiXaoLIkw2HoOrhYTOg9nkd4u80LYChPf6Hvbbs1TBS9FIV5wxeQtqnR+gI1mFwe4
         wLJJNHx3EUchhacu/zn+fT8RrdN6RkZSEoDbAsTPRQMfKik6VIXJUdBpi4G2tUY+jZ6b
         jt+72YJXfar2xckHKZcG7Cr/PxF+i8RZqIDmMettac+qMXm6jOOFW/bxl3UOU/yPK9KI
         JJ4A==
X-Gm-Message-State: APjAAAUYZgvxuYpIvk2jlB9DW6isCRgFawSiMKAB9EFFm8C+olpW1fLC
        LO43taZCvy+e0B9Kjm5nnKstd84w
X-Google-Smtp-Source: APXvYqwZJA3vXtEfaVTEMXvUA6XjXlLfLFIu2B25rwSR9KhTZMMe775mliqc9n8+yy0h2l9mKKrKJA==
X-Received: by 2002:a05:620a:705:: with SMTP id 5mr13302695qkc.330.1566753962728;
        Sun, 25 Aug 2019 10:26:02 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id m10sm4560848qka.43.2019.08.25.10.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 10:26:02 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 5/6] net: dsa: program VLAN on CPU port from slave
Date:   Sun, 25 Aug 2019 13:25:19 -0400
Message-Id: <20190825172520.22798-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190825172520.22798-1-vivien.didelot@gmail.com>
References: <20190825172520.22798-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA currently programs a VLAN on the CPU port implicitly after the
related notifier is received by a switch.

While we still need to do this transparent programmation of the DSA
links in the fabric, programming the CPU port this way may cause
problems in some corners such as the tag_8021q driver.

Because the dedicated CPU port is specific to a slave, make their
programmation explicit a few layers up, in the slave code.

Note that technically, DSA links have a dedicated CPU port as well,
but since they are only used as conduit between interconnected switches
of a fabric, programming them transparently this way is what we want.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/slave.c  | 14 ++++++++++++++
 net/dsa/switch.c |  5 ++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 82e48d247b81..8267c156a51a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -332,6 +332,10 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (err)
 		return err;
 
+	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -383,6 +387,9 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
+	/* Do not deprogram the CPU port as it may be shared with other user
+	 * ports which can be members of this VLAN as well.
+	 */
 	return dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
 }
 
@@ -1121,6 +1128,10 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	if (ret && ret != -EOPNOTSUPP)
 		return ret;
 
+	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+
 	return 0;
 }
 
@@ -1151,6 +1162,9 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	if (ret == -EOPNOTSUPP)
 		ret = 0;
 
+	/* Do not deprogram the CPU port as it may be shared with other user
+	 * ports which can be members of this VLAN as well.
+	 */
 	return ret;
 }
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 489eb7b430a4..6a9607518823 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -232,7 +232,7 @@ static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
 	if (ds->index == info->sw_index && port == info->port)
 		return true;
 
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+	if (dsa_is_dsa_port(ds, port))
 		return true;
 
 	return false;
@@ -288,6 +288,9 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
 	if (ds->index == info->sw_index)
 		return ds->ops->port_vlan_del(ds, info->port, info->vlan);
 
+	/* Do not deprogram the DSA links as they may be used as conduit
+	 * for other VLAN members in the fabric.
+	 */
 	return 0;
 }
 
-- 
2.23.0

