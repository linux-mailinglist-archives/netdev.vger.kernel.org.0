Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FB83ACCB2
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhFRNue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbhFRNue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:50:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8273C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:48:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id nb6so15932403ejc.10
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4khq88CoLvnES4xhsAW2Lr0qZSOmbfj72MOUjXDthuY=;
        b=dT3IhPGAgER/ia7lS4IU9E8WCRjArnuYnJqCS5zhNJWDKKpxs/JZJM9OSPREAKZkEI
         W+xqLYFUSxjAX+7tOvx7ddL5OD9utXhlzy40jk97k7AkbtFfbixGyknXxCUc1SXDVHrP
         mbOawmtenFwKixiOSZJ6iM9Oa2X6zLKrCzjQ+IH7nm0y/rOmtJgG1LrUPEAEdZrIwzth
         Q0JetHnLNY8Rd2GTrvQYqi5dDLinAz5Zi9QtijSTRkx7MzyarRwH/aVR/aiWC7f3cHfp
         P0jCirPwtGBMG5tzLJEcVFYzQkTBY0LvhAQ/5Oqur+cwEP1tb/yViTplUkZ8Z6118WdZ
         6f4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4khq88CoLvnES4xhsAW2Lr0qZSOmbfj72MOUjXDthuY=;
        b=nabB+lzfsMd1IABsN7Rumg4qHKX96TZWX0H5fBDAdBHW8ektv/2ujPJ50avEOoDd13
         qXfYsalYvYgGsqWE+TfVGVbA3VgpIZY9m5v5612bd1pD5k6S3DZccyGOkhx0eWkuTQ/J
         VY7IayN/Q/0N2rdTjUIfpUUbBfvSgfyS6RYwa2k59A7KeqRWK9cQBNMJx4U7+hTGMmB9
         KJ0Zx5SKEflJ4eXSvVSIcFYIB4OIpUxzU9ezCpisS5BDJYdd1O4IORMSPfEibp4bahzw
         5us4g/lB1RB+VqkcQRKRRvhZrlIwTvC02uQBwXidk9g4zY5nf0wJInvA3+1F3Hjat2yG
         WYFg==
X-Gm-Message-State: AOAM531gAiFFEcGuasCMnytEupnSBz8AqomHFf2oWspswYbOhoKZxo3U
        xXgockJ4EM51SAS1wRI43RpdkowZ85g=
X-Google-Smtp-Source: ABdhPJzELOqjBrLHgXrr69J6Qf3eemHerGVuTfYorkGVGnR1Z6osUK+E9TBqFI5xYLr+pvcz0maBFg==
X-Received: by 2002:a17:906:15d5:: with SMTP id l21mr9458655ejd.429.1624024102309;
        Fri, 18 Jun 2021 06:48:22 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id q16sm6374410edt.26.2021.06.18.06.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 06:48:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: sja1105: completely error out in sja1105_static_config_reload if something fails
Date:   Fri, 18 Jun 2021 16:48:12 +0300
Message-Id: <20210618134812.2973050-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If reloading the static config fails for whatever reason, for example if
sja1105_static_config_check_valid() fails, then we "goto out_unlock_ptp"
but we print anyway that "Reset switch and programmed static config.",
which is confusing because we didn't. We also do a bunch of other stuff
like reprogram the XPCS and reload the credit-based shapers, as if a
switch reset took place, which didn't.

So just unlock the PTP lock and goto out, skipping all of that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 57ccd4548911..a9777eb564c6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1886,17 +1886,23 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	mutex_lock(&priv->ptp_data.lock);
 
 	rc = __sja1105_ptp_gettimex(ds, &now, &ptp_sts_before);
-	if (rc < 0)
-		goto out_unlock_ptp;
+	if (rc < 0) {
+		mutex_unlock(&priv->ptp_data.lock);
+		goto out;
+	}
 
 	/* Reset switch and send updated static configuration */
 	rc = sja1105_static_config_upload(priv);
-	if (rc < 0)
-		goto out_unlock_ptp;
+	if (rc < 0) {
+		mutex_unlock(&priv->ptp_data.lock);
+		goto out;
+	}
 
 	rc = __sja1105_ptp_settime(ds, 0, &ptp_sts_after);
-	if (rc < 0)
-		goto out_unlock_ptp;
+	if (rc < 0) {
+		mutex_unlock(&priv->ptp_data.lock);
+		goto out;
+	}
 
 	t1 = timespec64_to_ns(&ptp_sts_before.pre_ts);
 	t2 = timespec64_to_ns(&ptp_sts_before.post_ts);
@@ -1911,7 +1917,6 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 
 	__sja1105_ptp_adjtime(ds, now);
 
-out_unlock_ptp:
 	mutex_unlock(&priv->ptp_data.lock);
 
 	dev_info(priv->ds->dev,
-- 
2.25.1

