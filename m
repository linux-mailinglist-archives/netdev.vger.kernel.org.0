Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876F82323C4
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 19:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgG2Rw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 13:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgG2Rw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 13:52:26 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C78C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 10:52:26 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k1so2221224pjt.5
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 10:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=o7mqmo5pyBFDAYuPYe4sR4YSCjorkJSrKxYBGqiSEIY=;
        b=SUP3Rpsy2UUX3bv8EwXJrCeIbNm5p3XEj4DEv8jywsm4VqtCYXwQAYcXXZFFGJiV74
         OjJ/hI+eu9SzwZFhMhHM5mGdCRoU/CC3SbetJ4CwHwS6gRVtqbvC9ErSKCGVpnWKfIjB
         nJRCsdlLG1/QMfoUcL3G7ylWdH0C1bewl0mK/KLVS1TiRxevMs8fwFKsUFrP3tBCVhPx
         bjbPU05FhzoJGzLQ/iZb+YtpGubia7ENRhKGkaEBdSxoFwMLflUqS6Tqa0hYZ53LFzz2
         5PTtbom59fHHFwlnqedoIt4G56wlKqOfCnsLX4rLPR+b8ymXjzRVFmkAt35yTzVCTTq3
         kwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=o7mqmo5pyBFDAYuPYe4sR4YSCjorkJSrKxYBGqiSEIY=;
        b=YuFz6iNXwV4anZabgtGYKFlTTIrBw73oFg4VVnCJajFKFCw6ZQuwmJJhJJTW1WWA59
         R14rdiug77MqBk9Rd0lw8bPwEgszgsP3npzltHaQvEDqQH+azHfHM0zrsM1y7o+UFUH8
         pYyEQWzu/xUA7IYwQBvZL6hZe24tzRuZ7XklzkJMk0PONhU523Wi0kBuKlAnYYZP65sT
         Z8SS2ihSIfYveWOnWbMSXJFW8UFeboEulG2BtzfFOiOYKvA8CjPC46V/kMBn4hO/3bRx
         VoMRkq0s7tSCgUKbVKohAXe2X7XlK6nAPoPNSC9tLkBo4YHm4/LsPzK8H5/d4r5g8b42
         xpGQ==
X-Gm-Message-State: AOAM5330CGiYYYw5I4Q8iDiGEXNwezIT0REfCCF1DERCdQAy3CWxW5Od
        s/Ine8MXQhmcOBLTuAI6auprKSQY14I=
X-Google-Smtp-Source: ABdhPJw6mYwfxHbc9ELs4o+565v2XTEluUd1VlbEueblakpp1V6Kh16xYlcWvajTcpJXhxwJ1PMJTw==
X-Received: by 2002:a17:902:a506:: with SMTP id s6mr29705206plq.214.1596045145564;
        Wed, 29 Jul 2020 10:52:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id b185sm3020872pfa.148.2020.07.29.10.52.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2020 10:52:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: unlock queue mutex in error path
Date:   Wed, 29 Jul 2020 10:52:17 -0700
Message-Id: <20200729175217.31852-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On an error return, jump to the unlock at the end to be sure
to unlock the queue_lock mutex.

Fixes: 0925e9db4dc8 ("ionic: use mutex to protect queue operations")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5fd31ba56937..e55d41546cff 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2001,7 +2001,7 @@ int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 		netif_device_detach(lif->netdev);
 		err = ionic_stop(lif->netdev);
 		if (err)
-			return err;
+			goto reset_out;
 	}
 
 	if (cb)
@@ -2011,6 +2011,8 @@ int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 		err = ionic_open(lif->netdev);
 		netif_device_attach(lif->netdev);
 	}
+
+reset_out:
 	mutex_unlock(&lif->queue_lock);
 
 	return err;
-- 
2.17.1

