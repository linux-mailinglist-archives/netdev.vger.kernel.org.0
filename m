Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34391F32A3
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 05:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgFIDlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 23:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgFIDlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 23:41:53 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D47C03E969
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 20:41:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id m2so784668pjv.2
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 20:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=5gUZObmFDdjvI5YqGBSgNDCg9hb6hL7IYtn1moZvtuY=;
        b=QA0ilU5tFzFeJC3zhoNjqq6BenfhL91eQ1n5VBKzKp5izEk17cKaFy+FELH77AuiZm
         TaET5jbtZ2edD3MkyOiyZ9lBpnlIcb2/cvURJbSUBIPOxWp6DxCduR6YEHF55qvASEIW
         tvXsAj82lZXcnHeACX6xkQ9V9s446kWFvhN3pN5EShSHn3Q0QO4AWN68vl8oMIAPXFGm
         f7TYfEvB8w7VO4Lnrb+40Rj8udQP2c7Ai5MP+p4blDb5kpqbT6/4D6dwpfyb1zmqFA/4
         X9rgmnTdfY86+PTxFaFRl6N3zl8xakteEUZLiIQCXigCS0DxkzYniBneuxkKX6zHt9gm
         T8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5gUZObmFDdjvI5YqGBSgNDCg9hb6hL7IYtn1moZvtuY=;
        b=GBmNrCIHDpALJcJibLvtOGMh5+LniO/Ls5cV7q/21BsjjaqR4j4B9X4dsbDIla96pS
         dE0tf/8ERYUL93C2DZZuWPS1RyeBzgfBiBUfbc4pgXkMqIxkADXdFYc0kS0SAVuFUsMJ
         MJ6MYGsSdUq18w4NhWEogXXReDBIhG0qfB0CEodPa0Ysf+zd+Ovg41bh4fsvAeF5vZlA
         LI2E61aiZTsqZfdEQNAkxF+AXzYaZ6u/QS4bsuAVK90XfTwHldyxt85TIQwdFi80o/44
         UhOFFv69MmZ4pxEBz0nRt8qLwXdHfhlLrW+oV/b32S61SHvBBXtdTZxiwy0T5gl37mMC
         o11A==
X-Gm-Message-State: AOAM532scagxTa23Doypbn8tWuEdV7Qv0jyGwlHU/aD/gSuhdK7xof40
        4SLLc/tdrhhIg1Zi9z7b9dF1x1Yk1Go=
X-Google-Smtp-Source: ABdhPJwN4yVrGLw1iz2e3eGEZUez9s+L647j/1xP0Q1r5pTNLXkbBJCLNeoHGODQIzgEwz4DVie5pg==
X-Received: by 2002:a17:902:b216:: with SMTP id t22mr1496278plr.181.1591674112013;
        Mon, 08 Jun 2020 20:41:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i34sm869674pje.10.2020.06.08.20.41.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2020 20:41:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/1] ionic: wait on queue start until after IFF_UP
Date:   Mon,  8 Jun 2020 20:41:43 -0700
Message-Id: <20200609034143.7668-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netif_running() test looks at __LINK_STATE_START which
gets set before ndo_open() is called, there is a window of
time between that and when the queues are actually ready to
be run.  If ionic_check_link_status() notices that the link is
up very soon after netif_running() becomes true, it might try
to run the queues before they are ready, causing all manner of
potential issues.  Since the netdev->flags IFF_UP isn't set
until after ndo_open() returns, we can wait for that before
we allow ionic_check_link_status() to start the queues.

On the way back to close, __LINK_STATE_START is cleared before
calling ndo_stop(), and IFF_UP is cleared after.  Both of
these need to be true in order to safely stop the queues
from ionic_check_link_status().

Fixes: 49d3b493673a ("ionic: disable the queues on link down")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7321a92f8395..fbc36e9e4729 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -116,7 +116,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 			netif_carrier_on(netdev);
 		}
 
-		if (netif_running(lif->netdev))
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev))
 			ionic_start_queues(lif);
 	} else {
 		if (netif_carrier_ok(netdev)) {
@@ -124,7 +124,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 			netif_carrier_off(netdev);
 		}
 
-		if (netif_running(lif->netdev))
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev))
 			ionic_stop_queues(lif);
 	}
 
-- 
2.17.1

