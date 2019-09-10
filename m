Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82716AE1F6
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 03:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392392AbfIJBfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 21:35:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36654 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392380AbfIJBfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 21:35:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id y19so16740941wrd.3
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 18:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ear9UHT0guTtaQI0aSXA2Gvj0rxBp0cGN6kLpFUjvLs=;
        b=BQmzW99gu+KmJxByrTOa0/GgCA3bB7tcA/jE1amPMRzbsHz9IPPcOzJrE5P7nBIl9W
         qP4IQbrn/fteItUewT2c4e++Xao0KBiVXVG2dwdY0Ah804/jcRjvyCcwpp9mWPyBzi+S
         mVthZL0VgOIQB7FX5W9k/SbFh5z1AW2jXaF15StXXKvOCqRCAMYvQN7iVsm9GJZYn8to
         M3uydCTnIbml0NEc8V8sTFcxYFOddzsHrV3m6uwgc8NvMqu4YCEEoLDesZmdbBPPx62M
         88qcURtDFazxM0bA8M8SSJUookTxzck1gZDTzqevdWCHKqqaBDc9LQnudNKeT3cg8sGA
         zw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ear9UHT0guTtaQI0aSXA2Gvj0rxBp0cGN6kLpFUjvLs=;
        b=P5QeRVELrsCjxB76Yti9IjqqAF9z7mhaFPS7Aams7EcgmOmM06Vs4bAWUNAlwXDRUP
         zLBvXzC4wcFaX2AE8AUkQk0584RJGz2BLmVfhTZdkmuCody+yaL8+ZlKLTYvHQCo7Yb9
         oOCWllcYLsqjkXxvvJRnfrWci5gCZ/7jIrUgKFbGrUEcnDubGZEuggPdVN6dbWHa+K5p
         vs9tzcbpNjIC1CHkLhr2TeppHbnk513tLG0ZlXVcRLTS2oownQ21yzn0T5TQytC8nRgu
         q3yUanwFUHj9tUaEJNZeRLfSQKFpXC+fCSSgTN+IKtsIHXaoFS97BZZPYLFpaJ5I+Pqj
         9lxg==
X-Gm-Message-State: APjAAAWaXofIQI/mQCnORMaAKUf8YJiXtyHrHNhexILlm87WjAPXnlZX
        5Lr6jVnU/kL4zYF3LPaahQM=
X-Google-Smtp-Source: APXvYqybmNq+n4uQZPuQaPQRZc+BVYUWkSA6kHUG4r1Ki9oJnUoIz4Na4fAy4yAdV6BWddipuM/HLw==
X-Received: by 2002:a5d:4ac5:: with SMTP id y5mr16759589wrs.179.1568079343906;
        Mon, 09 Sep 2019 18:35:43 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id b1sm1254597wmj.4.2019.09.09.18.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 18:35:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 6/7] net: dsa: sja1105: Disallow management xmit during switch reset
Date:   Tue, 10 Sep 2019 04:35:00 +0300
Message-Id: <20190910013501.3262-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190910013501.3262-1-olteanv@gmail.com>
References: <20190910013501.3262-1-olteanv@gmail.com>
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
index 5a110b40f5f3..68b09ef7aeb2 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1393,6 +1393,8 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 	s64 t12, t34;
 	int rc, i;
 
+	mutex_lock(&priv->mgmt_lock);
+
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
 	/* Back up the dynamic link speed changed by sja1105_adjust_port_config
@@ -1449,6 +1451,8 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 			goto out;
 	}
 out:
+	mutex_unlock(&priv->mgmt_lock);
+
 	return rc;
 }
 
-- 
2.17.1

