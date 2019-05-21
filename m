Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7852584A
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfEUTay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:30:54 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:35451 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfEUTaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:30:52 -0400
Received: by mail-qt1-f182.google.com with SMTP id a39so21972604qtk.2
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I0RFzJ7PTW4DzoSDTFs51KVDvNPekS1Mv43PXPJwjwo=;
        b=GwdTjcfO0HwO3JHseyJtNfZjcihVDAzt4wcoanyt/PNSYHHC6zNZEt6ShCaW+5jQyI
         TUTHDjszIGOxPoKnkrrt7W17uSUwLDiw3GHVJ55G+TLuG7tEAFr7n3VHofkti4ZBwj/q
         CYGl7RKSds07JlhjeRJOYCR4/y8ZawWPer6b35Ei/jJpKBLDwgqK+Xby9N7GZ8x+ylcG
         tLCqHA++A5baQZwXrehhyFTJnw3uY8MOhHB4nAi4Qx2hX5C6YBKE6v3UJW6OoBTpkh9E
         M+gcZ2RSks4Fhjq959K+pjRnpz3se1Gi14DTukXHCeW0uHpSQUndKJOazGK6t/ecRt96
         aCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I0RFzJ7PTW4DzoSDTFs51KVDvNPekS1Mv43PXPJwjwo=;
        b=rpfJUbRoPHQT/9bXifKgXzaJAfqO3TVfsURBBXA7qcc7Mag6NZI3XuvUa1WgnRevad
         Z7hxpmzaIYNbcPXVSHXpPqtukdI9i8H2ysIwn/ePzcW3i90BCtep9gLPqCow5ORcRMia
         8vjMHSS3hBuxkuC4ERrjCYrR4dd2GmEZyjUv+0iJBGR5CByZoscJ+Nhm1OuU94PHsYq9
         w9qDElZeWvFCkgbnGqvGZ0dRwv7YPbXBCJ5TP1nEkTF+PRyh+pxRhKWlD4olUkZ52n+r
         euMPe/Q4BBJNkGOtPG2M5P87BBeMdRAZVGWkM6G5ki5EtM2J/damX6gRPCjKR7QEFv8t
         MaHw==
X-Gm-Message-State: APjAAAUpdOh+qXxFclPFgBi0pn+o7nJARc7Voq8PvJ20cdEVcCbiWH5a
        hbJOmWLYMoikTI/sRuudJUOLzP9O
X-Google-Smtp-Source: APXvYqxKqSu6qnQfI+gekAg2yIqKOkIM84WE2Ltbm7TqbbMr4fc2T74vC7DCOEuAPjs2IRMEb3Xo/w==
X-Received: by 2002:ac8:97b:: with SMTP id z56mr68945840qth.259.1558467051656;
        Tue, 21 May 2019 12:30:51 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f33sm14544526qtf.64.2019.05.21.12.30.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:30:51 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 1/9] net: dsa: introduce dsa_master_find_switch
Date:   Tue, 21 May 2019 15:29:56 -0400
Message-Id: <20190521193004.10767-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521193004.10767-1-vivien.didelot@gmail.com>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a DSA helper to find a dsa_switch structure by ID from a
master interface, that will be useful for frames with a switch ID
but no port ID.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa_priv.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8f1222324646..2a8ee4c6adc5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -103,18 +103,25 @@ int dsa_legacy_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
 void dsa_master_teardown(struct net_device *dev);
 
-static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
-						       int device, int port)
+static inline struct dsa_switch *dsa_master_find_switch(struct net_device *dev,
+							int device)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	struct dsa_switch_tree *dst = cpu_dp->dst;
-	struct dsa_switch *ds;
-	struct dsa_port *slave_port;
 
 	if (device < 0 || device >= DSA_MAX_SWITCHES)
 		return NULL;
 
-	ds = dst->ds[device];
+	return dst->ds[device];
+}
+
+static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
+						       int device, int port)
+{
+	struct dsa_port *slave_port;
+	struct dsa_switch *ds;
+
+	ds = dsa_master_find_switch(dev, device);
 	if (!ds)
 		return NULL;
 
-- 
2.21.0

