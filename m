Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B68A2BA1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfH3ArF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:47:05 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51363 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbfH3ArC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:47:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id k1so5496827wmi.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DoxoK+E7bV8EyL0Za1CahweAzSzRuPAoZfR/YFCzTo4=;
        b=uSNj2ZfhTWPs/Wx9NI9fx9UoOTcInR18tJuBYO3nv/SvG/rXHlU/SaHBAn+TubDH2v
         uNvjz9Tk+I1s0C0HGXjA8Nbc0qKGAn6rJ42wCu3DzHEi0AHV6Y3iNC6D9emmlIHOlDb9
         jPn9xC2NCEPm+ncKyaJ+unv52bOw+JQsG5r8Y+NAgvrnOc4G6Ol43I1lzwrbZtE70N5O
         xel76YP8vxnNPCGM2jaVVNtG+ZlgHv/eZlnyq5tvhjGhhZdQ+gDUO50eu5J6BPunlIUI
         /1hEnJAt6iB5vosRMzf4Dau5fQhuVBlnAvhK1agsS3w1NcTedFnj4qhJMQAcO8JMRmfZ
         IjRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DoxoK+E7bV8EyL0Za1CahweAzSzRuPAoZfR/YFCzTo4=;
        b=agmHU1m9Db3IjxdPgnGka91qGq4sbYIA0YdyK0Ban8EV9MAZM81hMOmA4RmeOoqazg
         e8QOmM5w97FPma/5y6TIJ4n20e/wKhLOO9ePtwmWBYARWZVWHsy1wm8p9WLdE3qmBJOZ
         pNbJqLbs4YV5ndiBzZbGTVYQ/ilp1Xor7iQnGvgzjDsLvFW9BEv7zQ0nWWiiHrzJvf0C
         gbB6c0WbtmiMztaROV4WkDFy6U9lRKpAAx7zdxwIV6ZZHlgVAUqiS46BoKJZ/jEjdS2L
         yyn3RjhGj0cJBkbQLHii5xwe3WTFurs8Q99+fZEFybpB8DKyeydje4HocMeZaohmwsPD
         IMbg==
X-Gm-Message-State: APjAAAWfFUk+x1b5UG24RCZ58eGTuAKf7XdoweRC3+1v9Mb2nnUtq9QZ
        0e0ZhnKHXK9vzk9DMlFpypjvAswz+Hw=
X-Google-Smtp-Source: APXvYqyH10Duyyx8/U7ZfCBXMSWXBQ67M3hfjtcedBdZxe7wsIKgweGMfMkEGemJL/2iSdKQTGQ8jg==
X-Received: by 2002:a7b:c019:: with SMTP id c25mr15284369wmb.116.1567126021118;
        Thu, 29 Aug 2019 17:47:01 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:47:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 10/15] net: dsa: Pass ndo_setup_tc slave callback to drivers
Date:   Fri, 30 Aug 2019 03:46:30 +0300
Message-Id: <20190830004635.24863-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA currently handles shared block filters (for the classifier-action
qdisc) in the core due to what I believe are simply pragmatic reasons -
hiding the complexity from drivers and offerring a simple API for port
mirroring.

Extend the dsa_slave_setup_tc function by passing all other qdisc
offloads to the driver layer, where the driver may choose what it
implements and how. DSA is simply a pass-through in this case.

There is an open question related to the drivers potentially needing to
do work in process context, but .ndo_setup_tc is called in atomic
context. At the moment the drivers are left to handle this on their own.
The risk is that once accepting the offload callback right away in the
DSA core, then the driver would have no way to signal an error back. So
right now the driver has to do as much error checking as possible in the
atomic context and only defer (probably) the actual configuring of the
offload.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h |  3 +++
 net/dsa/slave.c   | 12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 96acb14ec1a8..232b5d36815d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -154,6 +154,7 @@ struct dsa_mall_tc_entry {
 	};
 };
 
+struct tc_taprio_qopt_offload;
 
 struct dsa_port {
 	/* A CPU port is physically connected to a master device.
@@ -515,6 +516,8 @@ struct dsa_switch_ops {
 				   bool ingress);
 	void	(*port_mirror_del)(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror);
+	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
+				 enum tc_setup_type type, void *type_data);
 
 	/*
 	 * Cross-chip operations
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9a88035517a6..75d58229a4bd 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1035,12 +1035,16 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
-	switch (type) {
-	case TC_SETUP_BLOCK:
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (type == TC_SETUP_BLOCK)
 		return dsa_slave_setup_tc_block(dev, type_data);
-	default:
+
+	if (!ds->ops->port_setup_tc)
 		return -EOPNOTSUPP;
-	}
+
+	return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
 }
 
 static void dsa_slave_get_stats64(struct net_device *dev,
-- 
2.17.1

