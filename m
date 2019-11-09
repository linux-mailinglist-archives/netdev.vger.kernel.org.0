Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A58F5EBE
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 12:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfKILdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 06:33:03 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50789 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfKILdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 06:33:02 -0500
Received: by mail-wm1-f66.google.com with SMTP id l17so7891369wmh.0
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 03:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bjevR+W+7GyBNoKvB7ywYEXTZgBACvSScPkFXeTiERE=;
        b=k8gpY5CnqbHURAZqTX7nB3hPN9k95Obsv4DsaK8iK1Ooa7g9rxfpYH6lLKhjvgNS98
         PvwBf+2T603zOQoQP4YE4dcmZIQ4DzHsE3+LCOidYCsUTZJCc+NRob5NQdxv2NbXu+I2
         un4VHVnEhgSXQQYZow/qM22a1dF+q2rqZQSLEcim0lBKewaUkiaGIdOt2DgHueMfglYJ
         5dJHKGXWq9iBOKdcGe8smHMqn5Jn5jvJ/AsZLHjJnWYKCMkIKeo0/sWDBtcBATFN0yr+
         tD5HbIBF+aNbxwcOJLcJlcWTVIaDTyGnvVUgWgthOu5b1v847BlvRWTlDXhzZfFGvrRF
         cNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bjevR+W+7GyBNoKvB7ywYEXTZgBACvSScPkFXeTiERE=;
        b=jssOpS63LfRGRZwiNk8yQQ4UKCzYMTXnQ3ShYLjPG7rq1OMWAcZyaa0uKrKRxW4lWN
         wSLL56nbI/OlMj2UimdaQsiXiX8jOb2omhrBxise+OpVXNaeJGDo12RP+XHVtSoE6Zqo
         Bemg3lZDt2DO4TI5T/XNHnzkVBSkELuU+v//8xLA3xObeM8Up97REJBJ0F5STM1+CnLG
         5GBn0XulOaaJOy0UGUCsi9JeDfE0JwJ6QvSJGbrMTO6CnI2bhNZzOmpFwIVcAywk9Z5K
         33p3cvk+FU/Wqhyxm8ij7Di7UG2k9JVsmPvalQ29+z5/bAOX42WPkOWjy67xys8uoLPz
         fXOw==
X-Gm-Message-State: APjAAAXDjACq0y5R52z+NwrwMCKcM2Ckqyj9v+/CxokZVH43fJEne/Ak
        yg8gq9E8HJifuc4Hmn4aBfg=
X-Google-Smtp-Source: APXvYqz00WDeePWRWDxUkoS3NV5ToYub8VJsal/G/9VvYruz6o2Svl4QPOrehrADpk5VWcb8cBEOgw==
X-Received: by 2002:a05:600c:218e:: with SMTP id e14mr11616443wme.22.1573299180775;
        Sat, 09 Nov 2019 03:33:00 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id w13sm8353512wrm.8.2019.11.09.03.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 03:33:00 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: sja1105: Disallow management xmit during switch reset
Date:   Sat,  9 Nov 2019 13:32:24 +0200
Message-Id: <20191109113224.6495-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109113224.6495-1-olteanv@gmail.com>
References: <20191109113224.6495-1-olteanv@gmail.com>
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
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2b8919a25392..475cc2d8b0e8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1359,6 +1359,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv)
 	int rc, i;
 	s64 now;
 
+	mutex_lock(&priv->mgmt_lock);
+
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
 	/* Back up the dynamic link speed changed by sja1105_adjust_port_config
@@ -1417,6 +1419,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv)
 			goto out;
 	}
 out:
+	mutex_unlock(&priv->mgmt_lock);
+
 	return rc;
 }
 
-- 
2.17.1

