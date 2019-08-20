Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AE09520E
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfHTAAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:00:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41163 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbfHTAAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:00:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id j16so10430701wrr.8
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 17:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SZLNyhG6INWdA77K3Kyo3n7WZ3Uw5y/CFYqnFxfVp70=;
        b=onDf4R3779Sm2s1rw7LiPmZVUeZqJvvEklSgcTZfZiaS5s1X40/hFrs1RsrwqTQhSn
         WWyItT47VJteDSJk6ihnOOWaHBcIlVdtDO9VoSXircnqD0bby86ANo63dzT2C9dRB6l+
         Lgo3kLWELA++6F3lLLJptVRwsAGTrPHF8ENvh+Ler35KWeuFSVkFmuMxqYzUSsV0e1n7
         DEfAcPyimQtB7aQT0FtrN14VbjRm3fN0ldkL5cA+WyuudPdXgThKviYbf9HU3a327g2D
         NLE8Fawq3t3lubGPx1Wv89vkTVTbly/5Zp0+Nl4+iX7HeSuA1/fY3YXB07rr9sMpexbz
         /arw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SZLNyhG6INWdA77K3Kyo3n7WZ3Uw5y/CFYqnFxfVp70=;
        b=E7kJVErmzCM+F7jaKMiVoC5ZiCNSqMrNaN3WFoODYOXTBXKSiELlYMq2lN0Gan37v0
         2CjgBY2/LjcFPFXPyaxE1JqEetitWVo1vE46eWk3HU1IYtSJygArT1EXbTIU98rwKZQc
         qBYPhoENs+BOKZw3NsctWTshWDWJV41MqgzKtoLoGbRc9U7Lt2+OHLpFJbZ262/fy4f7
         2Na5BG6ny2AAdqB/vd3MwWhnP+qUeq427xofXI7O5B/vPHRiMjGmbWeGJoR8wfSq+aKm
         BGEzetjv570BkMz9rM5Sel1psNvhQMYCfIogX5okJoUU0yAWwW0+/ZUQc6pUYSyP8PpN
         qa3Q==
X-Gm-Message-State: APjAAAV+iEqh/aJtK0o9qhHXJRK6CpdFEJbMv1vNl4gBQrbUvZs/crTl
        JFawnec5sKi8wsUqIrfP+ko=
X-Google-Smtp-Source: APXvYqzugH7IU4xtHR9LDSA8EZA727x8DoW77F1HmNXVKvC7fWoEobPkNnCtooHmCv7Jhoa2AGsiKg==
X-Received: by 2002:a5d:66c5:: with SMTP id k5mr31303560wrw.304.1566259211624;
        Mon, 19 Aug 2019 17:00:11 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id c9sm3814064wrv.40.2019.08.19.17.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 17:00:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 4/6] net: dsa: Don't program the VLAN as pvid on the upstream port
Date:   Tue, 20 Aug 2019 03:00:00 +0300
Message-Id: <20190820000002.9776-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820000002.9776-1-olteanv@gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b2f81d304cee ("net: dsa: add CPU and DSA ports as VLAN members")
programs the VLAN from the bridge into the specified port as well as the
upstream port, with the same set of flags.

Consider the typical case of installing pvid 1 on user port 1, pvid 2 on
user port 2, etc. The upstream port would end up having a pvid equal to
the last user port whose pvid was programmed from the bridge. Less than
useful.

So just don't change the pvid of the upstream port and let it be
whatever the driver set it internally to be.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/switch.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 84ab2336131e..02ccc53f1926 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -239,17 +239,21 @@ dsa_switch_vlan_prepare_bitmap(struct dsa_switch *ds,
 			       const struct switchdev_obj_port_vlan *vlan,
 			       const unsigned long *bitmap)
 {
+	struct switchdev_obj_port_vlan v = *vlan;
 	int port, err;
 
 	if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
 		return -EOPNOTSUPP;
 
 	for_each_set_bit(port, bitmap, ds->num_ports) {
-		err = dsa_port_vlan_check(ds, port, vlan);
+		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+			v.flags &= ~BRIDGE_VLAN_INFO_PVID;
+
+		err = dsa_port_vlan_check(ds, port, &v);
 		if (err)
 			return err;
 
-		err = ds->ops->port_vlan_prepare(ds, port, vlan);
+		err = ds->ops->port_vlan_prepare(ds, port, &v);
 		if (err)
 			return err;
 	}
@@ -262,10 +266,14 @@ dsa_switch_vlan_add_bitmap(struct dsa_switch *ds,
 			   const struct switchdev_obj_port_vlan *vlan,
 			   const unsigned long *bitmap)
 {
+	struct switchdev_obj_port_vlan v = *vlan;
 	int port;
 
-	for_each_set_bit(port, bitmap, ds->num_ports)
-		ds->ops->port_vlan_add(ds, port, vlan);
+	for_each_set_bit(port, bitmap, ds->num_ports) {
+		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+			v.flags &= ~BRIDGE_VLAN_INFO_PVID;
+		ds->ops->port_vlan_add(ds, port, &v);
+	}
 }
 
 static int dsa_switch_vlan_add(struct dsa_switch *ds,
-- 
2.17.1

