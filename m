Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A32695210
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbfHTAAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:00:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39668 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbfHTAAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:00:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id i63so1000424wmg.4
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 17:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GPFUyFS+jWxWApicUeRc6xCKGl96d1tW08U0ZTQLvpw=;
        b=M7D2OsgIvcT021nSxSGk6vw2iol87qI62NqIt3S5zrEhKrFl6EavHG6q4M9i50EAIY
         8NDSx7Ag6W2/iIMq6e5JJw/IQI9daEmjIBPTzoRSSR6TIXtPw5TD3UH8DG1IWZwnUtMp
         iXJFeob2/luFLVy9ovCm38jwiplR/CxT4y5nXvVV+ssq/i9Q0fbeInnjeU3G4f55RM4M
         OdZpPpep0TSCLCtN2w6ui8WSUV6epehGse68IYP1c/10mV1u3DeZ9S2QFMQ7QCjQpG/t
         w4qyqjcRfJZqab0Xz4xB8YvvRwPd47haN++ByJuOhkpue+Dm7EhMsHekERXENE8plwQF
         e7Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GPFUyFS+jWxWApicUeRc6xCKGl96d1tW08U0ZTQLvpw=;
        b=BgmXIrCZ5VCDI2PH9ftytTvbJ0CGYj3UdFIvp9bvEcAAF7fmz9tWmWMZMKpVMxVywr
         9VjiWsIw0xlmAS1+MPy++iPfCZQ3NoFhLtTEPCPZlrbYjEm7/iSxC5vNreIC+HhQMKQO
         VzY/hXN4LCXNO8QzrI56PKkYvLadcN6cIYA11/Yw80ciyzKCLlso0xL2tkHOJQYYPiqJ
         tJGEUS86tG60LKGm1WUjXIozpUX1wLMoCHs6cJdG1N5WuLsAXYOY8iiHPUzPSdnCWzKQ
         n8VCvimAZuQDq7yk8hdbSLEqOb2rgi1wnSqkDDr+truPse1XTFYtGWYdinPL/KuFLSDW
         37AQ==
X-Gm-Message-State: APjAAAXnECLciMOH2OSbKjcTgbRd/2J/IqG1G+mPe/Y0tv2M6zEUqITe
        VKj4NcWrFuitYTzcR4Kxvos=
X-Google-Smtp-Source: APXvYqx4EIeEWxvx0KOKvBiNd0PiW51FuV1hVaMX9RjEdM9M5AGImBJnPhbknuyJOJOiPT3hk/34NA==
X-Received: by 2002:a7b:c5c3:: with SMTP id n3mr22762914wmk.101.1566259213648;
        Mon, 19 Aug 2019 17:00:13 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id c9sm3814064wrv.40.2019.08.19.17.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 17:00:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 6/6] net: dsa: tag_8021q: Restore bridge pvid when enabling vlan_filtering
Date:   Tue, 20 Aug 2019 03:00:02 +0300
Message-Id: <20190820000002.9776-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820000002.9776-1-olteanv@gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge core assumes that enabling/disabling vlan_filtering will
translate into the simple toggling of a flag for switchdev drivers.

That is clearly not the case for sja1105, which alters the VLAN table
and the pvids in order to obtain port separation in standalone mode.

So, since the bridge will not call any vlan operation through switchdev
after enabling vlan_filtering, we need to ensure we're in a functional
state ourselves.

Hence read the pvid that the bridge is aware of, and program that into
our ports.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/tag_8021q.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 67a1bc635a7b..6423beb1efcd 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -93,6 +93,33 @@ int dsa_8021q_rx_source_port(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 
+static int dsa_port_restore_pvid(struct dsa_switch *ds, int port)
+{
+	struct bridge_vlan_info vinfo;
+	struct net_device *slave;
+	u16 pvid;
+	int err;
+
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	slave = ds->ports[port].slave;
+
+	err = br_vlan_get_pvid(slave, &pvid);
+	if (err < 0) {
+		dev_err(ds->dev, "Couldn't determine bridge PVID\n");
+		return err;
+	}
+
+	err = br_vlan_get_info(slave, pvid, &vinfo);
+	if (err < 0) {
+		dev_err(ds->dev, "Couldn't determine PVID attributes\n");
+		return err;
+	}
+
+	return dsa_port_vid_add(&ds->ports[port], pvid, vinfo.flags);
+}
+
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
  * front-panel switch port (here swp0).
  *
@@ -223,7 +250,10 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 		return err;
 	}
 
-	return 0;
+	if (!enabled)
+		err = dsa_port_restore_pvid(ds, port);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
 
-- 
2.17.1

