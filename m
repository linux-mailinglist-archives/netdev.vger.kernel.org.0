Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A940239F92
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfFHMHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:07:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40167 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbfFHMFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so4195879wmj.5;
        Sat, 08 Jun 2019 05:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wq1Amz+Mcow3G+/1LhQjKmJXq0zDBepnb7Tx+gzIh2w=;
        b=BhpgLnE7d+2uGYZ2Fj6jZGn/7xzCpXS2hJpCFkYiqTRYmmnLYUJAyMDI4p/1KMZbIZ
         TLWPpTv3GDyV41+EINy5k/OHemlj8drjstIbtaC06xu5DZo2iecYybhdYK06HCiFaHwB
         D6pfzMUB7OKd/zn+fkPI1mgyh0wJEGwDYr2bfnju65rB1R2WxBlPBzW+whyQCDh9TbrQ
         t9vaZrAVLLqm4iwIZoknETmbn1q6sxi5mfK2VyDi/qrWYB8pxDUBgfK7G+juMZcUPwrF
         qc8tL31Wd1+yTIXx0gP92COBpmSmKPb3qTftFG7u3wqywSr+9YMkYpsUu4OSvA3byB2o
         Kc3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wq1Amz+Mcow3G+/1LhQjKmJXq0zDBepnb7Tx+gzIh2w=;
        b=qWXlq6UXWtBTfwbvfXNEqq50TBVJUVEJhgPudXNtTNvYf2ByzuhaQNIqMtjeMqIyvK
         7Ft2AVpV620P2hJQVjnrZu09M5ekUAhBSinc+nU6rRbGEbHEIZgldfap1dTwuTuNbJ70
         LO17seAwQUKdrSCfwmj8L/vyw/ht7ljnn7C86VknWne/LQwJbdo3pr228g/RS66xkh1j
         5b/ozStvS+PrMM2IHOu8q+eDzfCRODg5E2yT6uenVJDFeAXOhVaTRudOiHWtSrdSy7Mu
         /OmZS5dACGivuHDRw6nwGolDT+s1R30ut38p55Ojz4ArQsGWACTyhX+XmMmtiBxeaaDh
         TUQw==
X-Gm-Message-State: APjAAAXMrk/PnZokKFsVs40SRutDvzh2sZDTrzjGCeZFJQlF02UB4cCh
        hf9CcYBC6tq63P/cC1xlblc=
X-Google-Smtp-Source: APXvYqyFEw3ZguGOzAv9Rt+lLZunwOMboNxtD5evsVMsmjIuGi9YuSjhgAK3Fs+8dYUEYsmLU839Rg==
X-Received: by 2002:a1c:a545:: with SMTP id o66mr7304644wme.138.1559995536517;
        Sat, 08 Jun 2019 05:05:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 02/17] net: dsa: Add teardown callback for drivers
Date:   Sat,  8 Jun 2019 15:04:28 +0300
Message-Id: <20190608120443.21889-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is helpful for e.g. draining per-driver (not per-port) tagger
queues.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:

None.

Changes in v3:

Moved after dsa_switch_unregister_notifier, which is symmetrical to
where the setup callback is.

Changes in v2:

Patch is new.

 include/net/dsa.h | 1 +
 net/dsa/dsa2.c    | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1131d9fac20b..82a2baa2dc48 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -357,6 +357,7 @@ struct dsa_switch_ops {
 						  int port);
 
 	int	(*setup)(struct dsa_switch *ds);
+	void	(*teardown)(struct dsa_switch *ds);
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
 
 	/*
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 38d11c863b57..3abd173ebacb 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -408,6 +408,9 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 
 	dsa_switch_unregister_notifier(ds);
 
+	if (ds->ops->teardown)
+		ds->ops->teardown(ds);
+
 	if (ds->devlink) {
 		devlink_unregister(ds->devlink);
 		devlink_free(ds->devlink);
-- 
2.17.1

