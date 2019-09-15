Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4D0B2DA2
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 03:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfIOBxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 21:53:44 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40659 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfIOBxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 21:53:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id m3so6440979wmc.5
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 18:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k4pTuk1Ik9ESG6xQtUNgwpvP1VxXUJ0GF4+U9B6CQtY=;
        b=XY9iM5VG4EUrIp9MVq//vo8IORFZM1Vpm1UMFjKvhrFdVNfl8mxGVGLp8SPAE3m52R
         R+/yYGjSeJfCrh4aZPi6xOkMviD7DVbgfW4Fg4JMOXfAwyAxm+QY48AIkhL3n0jidKYW
         ieFHKWM0ZxT41olihuteALmXR5cgumCfoWZH8YQof9YLFRx2XjDAHLOHxTzZlA6PUM4S
         gVzs2LaHl1lDY+MWarKdzeOaoL2fFhYZayM0RnYlGTJs4znz71oeKknU2ONOYyKJFlBr
         9Wdk0R5kgr63oK3uR44rJpINEJyyTrfHC8BVrpMXh8k/enjYE5peo0/Izvc0/S5GBkf9
         7YiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k4pTuk1Ik9ESG6xQtUNgwpvP1VxXUJ0GF4+U9B6CQtY=;
        b=CLwmh250A4vDC8fL63dHtwgKryD88cem0x1YBZDlT2JjLuRt0bPL9cgpjm3KslOIFy
         W33cH0f8Dnrj3D5Pa93FN2+ap+Ser+CeyNmJwTxOBlxIsNAXiaGL1jACTr8TIKdC9lPn
         v/tSVD2o8tDhliS0pXfLDDrtanUPeIlBz6VofEAn0tJpMqqxgEJa6GHIP0CAdPh1muWH
         HJBT1KMjCmt8iflI2iKFiw17GYCoaTQSwpUGJjcbn+VdL1UrDzKjzmdB89uOpJZGearu
         6pa1uSBednHhIltzZSCqNAhupwMZZbrjbyA2TqvPIcFvTsG0rNIScYVEonO+MKzCDFsf
         Pz2g==
X-Gm-Message-State: APjAAAVJKrinQUns2oB26JObDw4VPv1YkaeHHyBotY7mk4SaSi51hF9G
        H2RsTtqeRfTtMqPMwUkduLU=
X-Google-Smtp-Source: APXvYqx6oHiH4ZGJgvozqDa4U4NLnz7Oln92RbZ53dbrwghe4ZgCrAwti0+5Mbns4QHSY88gGml+Dg==
X-Received: by 2002:a1c:60c1:: with SMTP id u184mr8487601wmb.32.1568512421907;
        Sat, 14 Sep 2019 18:53:41 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id p19sm5627044wmg.31.2019.09.14.18.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 18:53:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 2/7] net: dsa: Pass ndo_setup_tc slave callback to drivers
Date:   Sun, 15 Sep 2019 04:53:09 +0300
Message-Id: <20190915015314.26605-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915015314.26605-1-olteanv@gmail.com>
References: <20190915015314.26605-1-olteanv@gmail.com>
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

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h |  2 ++
 net/dsa/slave.c   | 12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 96acb14ec1a8..541fb514e31d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -515,6 +515,8 @@ struct dsa_switch_ops {
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

