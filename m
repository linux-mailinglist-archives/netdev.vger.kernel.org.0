Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B306146EC0D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbhLIPsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbhLIPsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:48:32 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1CBC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 07:44:58 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so7196967pjb.5
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 07:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttatkzq/auLd15/xOL1U3hIadbx2nKJ8jwLAXBvnMwI=;
        b=nvVPqIsvReihUzZEHK08tJ39SOQmiKdadqOzxocZgthnmews7XC7SGHqTV68TTZbPG
         vMKVlK3RoRmsnOVh/S9lelWVLZMuyBjIUNU+qMSUfX368SBuRv4fS4RAiyOn7atPPDJv
         r/ZKSzjynAla4FgrdcysdeJvVWER1LCeHOUSlBM2oxqup+DhHYxPICQDIhJiDNAUMzPc
         4fKZaghWRypYcRXERdri3wJXRSLkgqcEusSr0HlbuVLEQweBTGqVbmhZjmnKyqPi47tw
         K0TWRyP7uRPVjUZ0xHmbR2fFSa/IHrnn08fAJ8izSfhA5tWaY9IFxoX5/5bRHSP39Onq
         4W0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttatkzq/auLd15/xOL1U3hIadbx2nKJ8jwLAXBvnMwI=;
        b=hXi+BDSWQlBjciK8DJcPYe+rjduPL1oK6FK6h0K53GTLYCKmL2C8/TNC+p7vFcvf1Y
         r5fIlF5icm220ohmbLR4FtMsXz4saVgAS9iN4EwzOs8Q6jJw00zseV4Fx4iBoH4N5Sof
         y029fGsqu/ZfyfxgkTcjhks5PEvfm4picV68MlaVnvZD7tqMeJcG7DuORxVVD1ToiVBN
         WOKyKMWUZR9h7DFzje45ceaDd0n4320sKnvad2j6+QzWPVFFNoqojNEZqSSGuHHYbG0A
         ioK4yEzxaZi+SDHThKVBtgvqFnkgU80TuF/N4hMCFEDjYSIo+g038zDmkmAw3joKJNvh
         0SmQ==
X-Gm-Message-State: AOAM532+uVZ3H4ix3tvnPDEkatzjAbI7bQoy/T6QtSho8CNgtmEESJM2
        UOIlePLosRu7J+ljVj3tTTtn46/gR58=
X-Google-Smtp-Source: ABdhPJwItNceTl2sHQm0eZGRdEHr07qs0Lh4KoATM+P+RQzYiWNwurlXpy8YxcbN4/OouSYKEccjHw==
X-Received: by 2002:a17:90b:3a89:: with SMTP id om9mr16429087pjb.99.1639064698496;
        Thu, 09 Dec 2021 07:44:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:903c:510c:9a29:125b])
        by smtp.gmail.com with ESMTPSA id s21sm133823pfk.3.2021.12.09.07.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 07:44:58 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next] xfrm: add net device refcount tracker to struct xfrm_state_offload
Date:   Thu,  9 Dec 2021 07:44:51 -0800
Message-Id: <20211209154451.4184050-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     | 3 ++-
 net/xfrm/xfrm_device.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2308210793a016b82803ef0c6143a5725ea9f7ea..83b46da8873da5c238035dbcf93d83926eefffcc 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -128,6 +128,7 @@ struct xfrm_state_walk {
 
 struct xfrm_state_offload {
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
 	unsigned int		num_exthdrs;
@@ -1913,7 +1914,7 @@ static inline void xfrm_dev_state_free(struct xfrm_state *x)
 		if (dev->xfrmdev_ops->xdo_dev_state_free)
 			dev->xfrmdev_ops->xdo_dev_state_free(x);
 		xso->dev = NULL;
-		dev_put(dev);
+		dev_put_track(dev, &xso->dev_tracker);
 	}
 }
 #else
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index e843b0d9e2a61c16551be51f69bc441ccad4f921..3fa066419d379a2aeb0747d3615cecd3d24b9172 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -259,6 +259,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	}
 
 	xso->dev = dev;
+	netdev_tracker_alloc(dev, &xso->dev_tracker, GFP_ATOMIC);
 	xso->real_dev = dev;
 	xso->num_exthdrs = 1;
 	xso->flags = xuo->flags;
@@ -269,7 +270,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		xso->flags = 0;
 		xso->dev = NULL;
 		xso->real_dev = NULL;
-		dev_put(dev);
+		dev_put_track(dev, &xso->dev_tracker);
 
 		if (err != -EOPNOTSUPP)
 			return err;
-- 
2.34.1.400.ga245620fadb-goog

