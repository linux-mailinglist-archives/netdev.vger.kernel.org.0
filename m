Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041B646AFD7
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351758AbhLGBfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245391AbhLGBeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:44 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B48C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:15 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 133so12129612pgc.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YH+RsSde1TM6CkclceNFxgy6FRympODJPqt8rGVl5oo=;
        b=puR/+F8cssQG6twcVT5xwXfnE/j7VmHNgD+oNllHia38ilSEpogJnCg7/BA/InwriR
         OQTg4avqPN5qo3rtWUt4ytWgYt4XWldX8D6/7tZ02/pDeoWICay2inNwcUxCdIf1q9iO
         l1wucbGOIpbOihvhkIouBEtVy1TzRXf+W6Hf6C6e8i8lWd5xQRDrDK6p+l3PPyHLPiDe
         UmnSr7Jd63IFQKRreSKpUKjAUeVL4aFta3xjHpEH1/6tNELhAmm9OvVMRMnRWgasYMsy
         pShVknbRehVEprgBSTsfpV1GMJ2ofy0CZNwILw9jrplqGpN6ZSevFRGMOhQuPWsVt/4L
         xKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YH+RsSde1TM6CkclceNFxgy6FRympODJPqt8rGVl5oo=;
        b=2ccvQOOQjjITaIVwmmqftkoUur2X/xgj7EN3wAAQRTcRVq/7QcbD32wVj7tYGQlmj+
         /vbwOVVbI+jLuzkixZ20KdanSLfrrB5S+Uhlav3IiYWsQzFqlMl7wDLllNPC1IAhH11b
         qWzkWjEkAF9791Hgif0IrvXsaTAUYas96KSL66YA7MzTXzLqvp7/LEpEc1CQ9o/UuXvk
         yYpvs7VDhNfHqSV8MtDgjMi1fpsNRNWu71XjY6cbBeBODqTYua4cjLr1aB/BXjz15qC9
         SMgKCM5RDNg2DMA41uTORz8VzomnvfJq0Cour7gb2dRjY0LKNpkLkU6T8ItD0zhNgM/D
         Hbaw==
X-Gm-Message-State: AOAM533ICNQ0olNnVhK12wX4i1aeXvAavHhJCb1FJh4xX4vqkXx2WjXI
        1WnO7nOZfohfY+KGngxkS4I=
X-Google-Smtp-Source: ABdhPJwql0TauuR5Dfgq384FQJ+BdAuHem6NPrXDnnSimrTfSFXeUex2DCKdWROTNO4GSpRdF/YMjQ==
X-Received: by 2002:a63:33c3:: with SMTP id z186mr13298419pgz.67.1638840674682;
        Mon, 06 Dec 2021 17:31:14 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 09/13] pktgen add net device refcount tracker
Date:   Mon,  6 Dec 2021 17:30:35 -0800
Message-Id: <20211207013039.1868645-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/pktgen.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index a3d74e2704c42e3bec1aa502b911c1b952a56cf1..560a5e712dc32fe4aa2cfaa751c3fe1e462c614f 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -410,6 +410,7 @@ struct pktgen_dev {
 				  * device name (not when the inject is
 				  * started as it used to do.)
 				  */
+	netdevice_tracker dev_tracker;
 	char odevname[32];
 	struct flow_state *flows;
 	unsigned int cflows;	/* Concurrent flows (config) */
@@ -2099,7 +2100,7 @@ static int pktgen_setup_dev(const struct pktgen_net *pn,
 
 	/* Clean old setups */
 	if (pkt_dev->odev) {
-		dev_put(pkt_dev->odev);
+		dev_put_track(pkt_dev->odev, &pkt_dev->dev_tracker);
 		pkt_dev->odev = NULL;
 	}
 
@@ -2117,6 +2118,7 @@ static int pktgen_setup_dev(const struct pktgen_net *pn,
 		err = -ENETDOWN;
 	} else {
 		pkt_dev->odev = odev;
+		netdev_tracker_alloc(odev, &pkt_dev->dev_tracker, GFP_KERNEL);
 		return 0;
 	}
 
@@ -3805,7 +3807,7 @@ static int pktgen_add_device(struct pktgen_thread *t, const char *ifname)
 
 	return add_dev_to_thread(t, pkt_dev);
 out2:
-	dev_put(pkt_dev->odev);
+	dev_put_track(pkt_dev->odev, &pkt_dev->dev_tracker);
 out1:
 #ifdef CONFIG_XFRM
 	free_SAs(pkt_dev);
@@ -3899,7 +3901,7 @@ static int pktgen_remove_device(struct pktgen_thread *t,
 	/* Dis-associate from the interface */
 
 	if (pkt_dev->odev) {
-		dev_put(pkt_dev->odev);
+		dev_put_track(pkt_dev->odev, &pkt_dev->dev_tracker);
 		pkt_dev->odev = NULL;
 	}
 
-- 
2.34.1.400.ga245620fadb-goog

