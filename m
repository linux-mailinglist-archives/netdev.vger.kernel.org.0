Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A55912B0AA
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfL0CiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:38:15 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55557 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfL0CiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:38:13 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so5514664wmj.5
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 18:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g+CS7ZXyUgN99YahbIIYYdoO80T73CqxJq5ZAiUW+DQ=;
        b=Pf1i4a2oolQyx3YC5m0wc1Z2i8AiDTVXD0Rwb2EiUfB7dq1Z4fQV8QydG8MZ0zf3CA
         OdoocqqSu65Z61nwcH/YJhT9ATWJeerIARB5S4kjD4/Z46pqO4RXK8zMF4NAyfd7HbaU
         8N7lMmv9S5X3UXOusjkgc0e1IOV/tKKqScunKV7c2N+2ZZB90KXBz2toxqUjfHq4CGg6
         yKrcn4WFJ/4GTcQt11oSJq5fRWiegsbMN0nJ5/yVWssXCnZ+csPTtalF00sLndAdyj43
         ud+Z3jn69pTmxplo0TAUbWYvU8HvgjpziRW0gPIXom6pmsW99ZmB42NgahAN9W332GMZ
         RFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g+CS7ZXyUgN99YahbIIYYdoO80T73CqxJq5ZAiUW+DQ=;
        b=EmFCDIpF2rIdknZ26JSFidPouptb9pIFn2wUxIROqjv122kU9W9SFVa9i1iM70Jkw0
         X74bs3nOfH7gaqo4JZiNZ850c7Sr+KXNIE8cNp1RKjRocS77R+Xrd/6JBOvLg0IMzsb5
         LpLX3D8bPQL1Fp8MlncL3vGfpk3MKNW4f6GrFFXEo8ARdt0mHXKOk7mKfeCvDKpT7Riy
         8EakOOOqHji4Sty7RfoYOzMwLMWWzL22dF+Eji1tb5IR/x2qC42DtVPwvD9bo7DoEIZQ
         4OWV6maiLQ0Eg9sV+RpudyZGx4HoUqB80XA5OtqsmXRkwkFzD4p4CSpL1vDgFulcC7eg
         TxNA==
X-Gm-Message-State: APjAAAUKp413VGAXwttm/qIWRzrCwyMbOk6BfhviIvzSDqfMU771jaLN
        KCcQfH+NKZS40QrH5IUI6L8=
X-Google-Smtp-Source: APXvYqziiIPfGif1F7qaXzVe9+xFkl3d0ng5nVW0gwkayAuxSuXfmX6MlEZNh34zRNMKJkstHkXwwA==
X-Received: by 2002:a1c:6a07:: with SMTP id f7mr17082143wmc.171.1577414291937;
        Thu, 26 Dec 2019 18:38:11 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id k7sm9718714wmi.19.2019.12.26.18.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 18:38:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: sja1105: Empty the RX timestamping queue on PTP settings change
Date:   Fri, 27 Dec 2019 04:37:50 +0200
Message-Id: <20191227023750.12559-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227023750.12559-1-olteanv@gmail.com>
References: <20191227023750.12559-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling PTP timestamping, don't reset the switch with the new
static config until all existing PTP frames have been timestamped on the
RX path or dropped. There's nothing we can do with these afterwards.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index d843c6395e52..a16628cd5f66 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -102,6 +102,8 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 		kfree_skb(priv->tagger_data.stampable_skb);
 		priv->tagger_data.stampable_skb = NULL;
 	}
+	ptp_cancel_worker_sync(ptp_data->clock);
+	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 
 	return sja1105_static_config_reload(priv, SJA1105_RX_HWTSTAMPING);
 }
-- 
2.17.1

