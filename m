Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57564A5B56
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 18:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfIBQ0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 12:26:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47082 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfIBQ0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 12:26:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id h7so13268268wrt.13
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 09:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zuhNbqcAAipaFMRxEVB1dgnmmQ+99i5ifCiDROYQJTM=;
        b=dBvRevMdBhmO9Q5P5HdLWExL5NknanwcL54c3TvoParT4B8ahhMQ/GkDiXDssG/FZv
         +ZNWkunzPh35SkHBUSXhqrGOJDaDUutL91kzhXVW4u7qcm7ICIgG6XiL/BTvgz0HwhV9
         QJTHwpsnfhdqLTXj8Gs+SnO+ySfJSQGdUzcLHr+q9g68u/8FqO9arXdC4VlWzyap0UoD
         zr7aXH+vhWanZ6V9IvQZu7d0Wagj/9X3y+hfnY6Jaa7A10DES5YFZU+QfpPClnJuUkhN
         jeye1c3WAUMZQ2tFGBG81NhZ4wlaT5/OuOAkDQFCxzSoY1gLzHkbYdF5a293ZoebO9K1
         DB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zuhNbqcAAipaFMRxEVB1dgnmmQ+99i5ifCiDROYQJTM=;
        b=V4PNWxy/xLjX5XRBF+S+6/IIpu440VB3cbl+UaX/vOYSyTx7Zd8n+8pD/8+OjJhJE1
         BGzV54SmksQMhhZiyu5nDMmjbBPzmnjPMqWRIdkqfruD05joZCYT+t1D0wBdIIBWWrz7
         IEzTMnpmLGaYqh67CPkybqSgihFy5avAVHiMlTd1ZDQHHv9fXzgjG4zB2fKWCZnykRKt
         g3Dl/MlTxFNdm9QNeQGAII+Dc/NaAgaK36fH3Kn80xPXEcKQG7dtHuuZQJleaLWK74bm
         M3G0gFCtk+jZmtMCbP0DMvlokpMvsab8E2Dk3uOWJIszwLhOGf0o9NvS4aUlZvmOuEbq
         f5Bg==
X-Gm-Message-State: APjAAAV7pSr98JZrS94rp8vpbNNC4udUAFs+ixuaJkYcp9ulBI7JzwkN
        1wGNSz0AOSsCeoGJMgGkMuA=
X-Google-Smtp-Source: APXvYqwugkCNSkf8KgDlZEDdJLdWm4kttFedvu9oQlMG5kbqcI3f0ein5xQmIKT+nU+9Ik6OP/Q4IA==
X-Received: by 2002:a05:6000:1284:: with SMTP id f4mr38919330wrx.89.1567441571902;
        Mon, 02 Sep 2019 09:26:11 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id z187sm2879994wmb.0.2019.09.02.09.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 09:26:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 net-next 06/15] net: dsa: sja1105: Disallow management xmit during switch reset
Date:   Mon,  2 Sep 2019 19:25:35 +0300
Message-Id: <20190902162544.24613-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190902162544.24613-1-olteanv@gmail.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose here is to avoid ptp4l fail due to this condition:

  timed out while polling for tx timestamp
  increasing tx_timestamp_timeout may correct this issue, but it is likely caused by a driver bug
  port 1: send peer delay request failed

So either reset the switch before the management frame was sent, or
after it was timestamped as well, but not in the middle.

The condition may arise either due to a true timeout (i.e. because
re-uploading the static config takes time), or due to the TX timestamp
actually getting lost due to reset. For the former we can increase
tx_timestamp_timeout in userspace, for the latter we need this patch.

Locking all traffic during switch reset does not make sense at all,
though. Forcing all CPU-originated traffic to potentially block waiting
for a sleepable context to send > 800 bytes over SPI is not a good idea.
Flows that are autonomously forwarded by the switch will get dropped
anyway during switch reset no matter what. So just let all other
CPU-originated traffic be dropped as well.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes since RFC:
- None.

 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index abb22f0a9884..d92f15b3aea9 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1391,6 +1391,8 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 	s64 t12, t34;
 	int rc, i;
 
+	mutex_lock(&priv->mgmt_lock);
+
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
 	/* Back up the dynamic link speed changed by sja1105_adjust_port_config
@@ -1447,6 +1449,8 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 			goto out;
 	}
 out:
+	mutex_unlock(&priv->mgmt_lock);
+
 	return rc;
 }
 
-- 
2.17.1

