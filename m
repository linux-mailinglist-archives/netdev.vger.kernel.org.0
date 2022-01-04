Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031C448465F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbiADREo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiADREn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 12:04:43 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD1FC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 09:04:43 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 8so32753343pfo.4
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 09:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5HhzASYaMNVCHHe67DcY2ixOmuGCPm3vAGRQiVCEUVs=;
        b=CbhgEkuxgMjfJAyPNAFSqqN3okCyGaFS7sAfxKKK1s8Ge0L2OsKDINOxVRIcVpkYn/
         eE8NZxReuIEA5LqSQZa2+47C3jDtNk9P2LOpdOXft8UlCInJvvFx1lXk7xv4wjjX6AVb
         76UPN4sXBi9u1KJ9GP2GZrbSK4sbg3gdpWLpfyJxHWxFM28db6+fTQJyUF7vKF1xulKS
         dkl2F11g6Y+3jbut+7z8WZSaHMiUKbvBOMr+L74amuX1iDVM7XLB3lNO+1tNZXRS48C/
         l/6276aV8zEkeYN5CT30VmQHyIj2eleY+DRBltMfP/GvFwPjQywk39QqOoipYUvsf6H0
         pMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5HhzASYaMNVCHHe67DcY2ixOmuGCPm3vAGRQiVCEUVs=;
        b=k/PsgyrUnSthG8DCQZP0rOTtwNiCA/VgRm/YXsE68yrdCimMIm/JrhoQILh2IOY816
         HqQ7B6x+ubYC6KoT8YsBvOIGAz8r4t2XLwfmtTMieCeD/jsENQBZWUVjCZ2Hr3uF3wVt
         6gQTNI/LSMfigQFBfZqEnUyq3Yte4BfSLojf21SOYA3upH/HXKn6JqOD305whNJ0EpOa
         yLhtN0P7LyNao67WNt4eL12kE5xKvAxt2QTYapxV2hwTr1eSbZCwT/jQ0s7qtmOcxcjo
         FQBrWM4yRWu3z81cSAXLpHUwVTOxkKa10m01UigM+HGFHhjlz35P1dp1B8av4rzLxjvz
         HYTw==
X-Gm-Message-State: AOAM531zyOE/vGeT4KtXQ8rTeGOuodFK/LihVwdMXDSfoMFn6K2Zub5k
        OzmjLvxgWfrzlhERJgNpBv4=
X-Google-Smtp-Source: ABdhPJyglM7zbqvzTI6EwUvr7toXYsHXNRZroPybux/AoVPoIS7SKgdgYwFjxROWWv0JT3yGOfDKWA==
X-Received: by 2002:a63:43c5:: with SMTP id q188mr44132867pga.304.1641315883215;
        Tue, 04 Jan 2022 09:04:43 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:af04:a4cf:7c72:9c40])
        by smtp.gmail.com with ESMTPSA id hk13sm43316019pjb.35.2022.01.04.09.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 09:04:42 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net/sched: add missing tracker information in qdisc_create()
Date:   Tue,  4 Jan 2022 09:04:39 -0800
Message-Id: <20220104170439.3790052-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

qdisc_create() error path needs to use dev_put_track()
because qdisc_alloc() allocated the tracker.

Fixes: 606509f27f67 ("net/sched: add net device refcount tracker to struct Qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index efcd0b5e9a323bfc19a0ac09e8e4c357170029fb..c9c6f49f9c284f57b2f3e637160e37af2b125dbb 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1292,7 +1292,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 	if (ops->destroy)
 		ops->destroy(sch);
 err_out3:
-	dev_put(dev);
+	dev_put_track(dev, &sch->dev_tracker);
 	qdisc_free(sch);
 err_out2:
 	module_put(ops->owner);
-- 
2.34.1.448.ga2b2bfdf31-goog

