Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811FFEC298
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbfKAMRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55486 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730602AbfKAMRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id g24so9149725wmh.5;
        Fri, 01 Nov 2019 05:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v2OEhUt1Q5DjWbRY/ukSA2ISzuN5HR8Asj5+S9oagZM=;
        b=TYba00YOKm1UNoOABodWOurGOD9XySUI/ls9tCevPpKRV7+m/5LdsHgok0jXxvBnMa
         cGvdmuq4fuSQgqkNQlDSxk64J/nYtdYGW3o0F8A/416GZbXYKPq1tsg21tnAhjkyZ3Op
         nfnwUKSYU8jA/cuYZO/c0Z/L8edoNsb9knRgANvsQSDcBrVKbwMyfdIwPFQEj+KLWDh1
         9gLXFUdcWRFZWxCtH9H++l8LfStDKp7amRgqExGCfEBNQhh4L1eYFurjZHtuZKj0wmiF
         mYqMNzVYqsPIbupviWGdk4zvcXq+bZBlFNOSKY5Xz7saMtSQttZ33Z30i+nLnz4i+ePN
         uvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v2OEhUt1Q5DjWbRY/ukSA2ISzuN5HR8Asj5+S9oagZM=;
        b=ZmIzkq+fikq7BhPIyWYM7li8duADJ68k6tefCF/PE47G6xXH/arAPeTe7nC1Oha0kG
         jsa2v3TgNcwTs1DwGY7cC8m+BqlnP6c/LrlAyAJEliqpOxMPg8GQsk/gr72BKGwGVJ2+
         Uh4eG2VDWaJmj0+1OqjIlOkYCGeGlHfWpFvJcdVUXPsORhGaQOChAvW06wnvdTLQsMwI
         O6ylP5/5HU1+AwJMBb/UgdXO0J6fDY6hyF0fM8pp1Lnt4bcpyU86U75BrAuFzZqF0lxi
         l90Y3dpuTJ7JyM6SBzjHtstL+BZkaKGnUYrCM28KiieXAgfff03fVfYDR7B9Ey/llc1V
         HnlA==
X-Gm-Message-State: APjAAAUhYaE6FCfdjOOkQYxODPdLTE4YAwZB8yPmgKYjVA9WO43Eb5ab
        9cdxNieFIdOkhyjkUcCIHkE=
X-Google-Smtp-Source: APXvYqxYSyOLx0qkxSJcpJrWWuP4L+Ic7bdIDsG7I7mX0FORQw4tVZXbSlaP34UV0F6JcHml0XOKhg==
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr9874673wmh.102.1572610658879;
        Fri, 01 Nov 2019 05:17:38 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id u21sm6263928wmj.22.2019.11.01.05.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:17:38 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Heiko Stuebner <heiko@sntech.de>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: ethernet: arc: add the missed clk_disable_unprepare
Date:   Fri,  1 Nov 2019 20:17:25 +0800
Message-Id: <20191101121725.13349-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remove misses to disable and unprepare priv->macclk like what is done
when probe fails.
Add the missed call in remove.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/arc/emac_rockchip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/arc/emac_rockchip.c b/drivers/net/ethernet/arc/emac_rockchip.c
index 42d2e1b02c44..664d664e0925 100644
--- a/drivers/net/ethernet/arc/emac_rockchip.c
+++ b/drivers/net/ethernet/arc/emac_rockchip.c
@@ -256,6 +256,9 @@ static int emac_rockchip_remove(struct platform_device *pdev)
 	if (priv->regulator)
 		regulator_disable(priv->regulator);
 
+	if (priv->soc_data->need_div_macclk)
+		clk_disable_unprepare(priv->macclk);
+
 	free_netdev(ndev);
 	return err;
 }
-- 
2.23.0

