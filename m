Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15831C125D
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 00:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfI1Wn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 18:43:58 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54884 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbfI1Wn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 18:43:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so9462783wmp.4
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 15:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ol2wW5+nyNWwpsEhk6jx2VVV1ORwpC9AcTq888DvDDs=;
        b=J3JyPmKct/aMooDk0E5WtMAUDbYnUgMWyfGRjT5Irp/ZY1nvbH51bcFNfPz/9SiUdT
         j/KXpQ474COmw3vgh9rgsKuwwyIXisommXTUORlMw4DiAgWlIevGraV5BSrwBLhCQShi
         TBfdasTxK173xhaYWaNXlZw5pQdvYI75CRBP9RdzcjuPdAxPaq6i5KmP4VH01DlakZqx
         3uXbgyMNXYkHRLxYNvwVFh+7Olo7uH0qXkejgcuoi8JUdOKbaX59YKCQzfQnzfGGd/5v
         +uLsdus0PXq40AxDUgJoAmo3evq0YKVikiN9YQymprKQJyCEuF/MOyDpaTOk71swvUkO
         pqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ol2wW5+nyNWwpsEhk6jx2VVV1ORwpC9AcTq888DvDDs=;
        b=oIBowDHWaq21S+d9OXw+9hOEluEpWsXHShOym2VgrHLCUMtIBBYnl34HWvvrNAOQDu
         zLwjMu4abKfDJFsIGNJDLEYwvUPPOV4YtD8SOVv/8f+OH50avg+pxXLUMFO+aVaYvJGR
         BOdBTGfCxoPsZr49Vb94p+nZETeZbR4LvmQ20X4gvMscMt/zONADPzMfJq5AWaEcraKj
         sJ7ffInLissP7V7eFGkR70SHD3z2HGdTvAjLvQXt5sCjiZnpmWqp2qVZQ/B8wurgBcdK
         5hkFxJZie/hWKhHegAITectgRwu/Klzqz48QdVD2WJUyi7cZNu9Qm+DQGodiyEvbRw+g
         WgYQ==
X-Gm-Message-State: APjAAAX0TDgSDQ9kkIi65KdcHwLdL9yhXg/xC9MFbWqYZfuGjzrWeNef
        QhSvU+CrDb/gc8w0lhO8W4g=
X-Google-Smtp-Source: APXvYqzda2MLF60FFG8v+8ryPc12+7kWU9aAiuuMf2oW1N6TUPUngz6Y616RqnFODFLrkfhHagLKHA==
X-Received: by 2002:a05:600c:219a:: with SMTP id e26mr12589151wme.86.1569710636193;
        Sat, 28 Sep 2019 15:43:56 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id t13sm12841470wra.70.2019.09.28.15.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 15:43:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: sja1105: Prevent leaking memory
Date:   Sun, 29 Sep 2019 01:43:39 +0300
Message-Id: <20190928224339.31784-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

In sja1105_static_config_upload, in two cases memory is leaked: when
static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
fails. In both cases config_buf should be released.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Fixes: 1a4c69406cc1 ("net: dsa: sja1105: Prevent PHY jabbering during switch reset")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes since v3:

I took over the patch and fixed formatting.

 drivers/net/dsa/sja1105/sja1105_spi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 84dc603138cf..58dd37ecde17 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -409,7 +409,8 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	rc = static_config_buf_prepare_for_upload(priv, config_buf, buf_len);
 	if (rc < 0) {
 		dev_err(dev, "Invalid config, cannot upload\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 	/* Prevent PHY jabbering during switch reset by inhibiting
 	 * Tx on all ports and waiting for current packet to drain.
@@ -418,7 +419,8 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	rc = sja1105_inhibit_tx(priv, port_bitmap, true);
 	if (rc < 0) {
 		dev_err(dev, "Failed to inhibit Tx on ports\n");
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out;
 	}
 	/* Wait for an eventual egress packet to finish transmission
 	 * (reach IFG). It is guaranteed that a second one will not
-- 
2.17.1

