Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46CCE12B4B9
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 14:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfL0NCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 08:02:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55333 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfL0NCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 08:02:41 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so6440457wmj.5
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 05:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S1Zpjr9Ch6P6Dd5sTHnhhaojWVPaQFrvyYKRpuZw0Oo=;
        b=g0yfjt1yhXdt92pIAqbjh6nYczHtJvs6mh9gEtFnqGNisQ9+C7mneClIbqbGsyY7hi
         LGIpIjZbAzk++IN5HPHzONLV1IK/oxtjAcO0qGUIqm3ihwhnGWbNv71+ensiLTtLdGv8
         uslC+GNhxhh4sZwsSCS6J2Uu14Ug/zUffN15gRAiwr2Q8abOQMrGC5tWjsbAdK+Q1FKb
         dHzHtLLuU9ymeA7RuDQM4p1pZzZTXxooaf3VJ21Q5GtBalSrBkrBYLAeP163NLifBFi/
         QrEDTFOlKd+sgi+F/4HZXI+yKSITnycde6YvX49upnYKZF3QzHglhlW3OGpOgWKrRYT0
         9knQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S1Zpjr9Ch6P6Dd5sTHnhhaojWVPaQFrvyYKRpuZw0Oo=;
        b=aR+naZV2MIbTROYkZuXbbgFxaXSt6I1j6pidOkeOYoqpwudeyOKqkxzwIEfxxYKdNg
         /rY/3aA+GrBN3ftr8dSIqHl9IPj/EuJEusZX5QFptrsmlZ+iEcw/D3q9RSYFRHfwpmud
         cUofI0Nn13+f7Ad+L3JumD3uHwIU7TILXeq97fY0ELUwQY2t67q7kvMmjmfBmNRmLn0e
         VdIJtZwtAutqRLwiPH3TEfR2kY34Ca6qkBqlVTNpcygpiI3MxXjDocdzAV0tCMgq2X4v
         pi1a6uWYNOpRQFm/P9bLe9xHU5eCAQG5KW2rNdeZCIIGgnDCDIZplsGmihFVYT0B/Bsg
         d2tQ==
X-Gm-Message-State: APjAAAWH0BtsZQFG0iAL3hb8dtQ/tMduVS9QiVIbMiom9hoW45bu3TJP
        HsSIR5MS5nP9TyAIhQn+5OM=
X-Google-Smtp-Source: APXvYqxuJfEMzxb0vYg/Hmr6s13Eb0TktFrMdHCoD5g2pwK5SxGW0vwEgOm+Hi3JdPAmyF4NOmh0+A==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr19054097wmi.35.1577451759965;
        Fri, 27 Dec 2019 05:02:39 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id i5sm34307357wrv.34.2019.12.27.05.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 05:02:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 3/3] net: dsa: sja1105: Empty the RX timestamping queue on PTP settings change
Date:   Fri, 27 Dec 2019 15:02:30 +0200
Message-Id: <20191227130230.21541-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227130230.21541-1-olteanv@gmail.com>
References: <20191227130230.21541-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling PTP timestamping, don't reset the switch with the new
static config until all existing PTP frames have been timestamped on the
RX path or dropped. There's nothing we can do with these afterwards.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Moved "struct sja1105_ptp_data *ptp_data" declaration in
  sja1105_change_rxtstamping here from patch 2/3.

 drivers/net/dsa/sja1105/sja1105_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 93683cbf2062..a16628cd5f66 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -83,6 +83,7 @@ static int sja1105_init_avb_params(struct sja1105_private *priv,
 static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 				      bool on)
 {
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_table *table;
 	int rc;
@@ -101,6 +102,8 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 		kfree_skb(priv->tagger_data.stampable_skb);
 		priv->tagger_data.stampable_skb = NULL;
 	}
+	ptp_cancel_worker_sync(ptp_data->clock);
+	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 
 	return sja1105_static_config_reload(priv, SJA1105_RX_HWTSTAMPING);
 }
-- 
2.17.1

