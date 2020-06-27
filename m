Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F7520C294
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgF0O7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 10:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgF0O7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 10:59:22 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F989C061794;
        Sat, 27 Jun 2020 07:59:22 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b16so5938272pfi.13;
        Sat, 27 Jun 2020 07:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0qR0RG0BShcuybjPoqzOObs/AZ3mMbOHHFDCi+AG9hU=;
        b=JIzl1bFGzPXLZs/LfcvL+9bnAWcEJm+rlpqcyraoV4oZuOgYbmMWro3O3lMmArgFqy
         t4x83r7ekeWaxcuyUPR1TnxXeHzSOeJcHuwI4COnVSy+58knhcSm/RUpLPSi2jX9BFd8
         ivb0NT/RY9Wk7zyOH+tWVw0sP7c6AdeEFeb3J5QNQCi1pZ5cbcSWzcwp5a214XVKMzIX
         OHLZZPBP2m2FT55adr0de8Wkn0eswymbQrfilLdqtoAxyM3oPyceg8P6LLteu49kd+UW
         xFqJKOUqHQQDG2I3d/QeYL/YyJ2EDkfs2YUigUTLQMOmr+VxbwKoflEkYKv80cHJY5ar
         nkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0qR0RG0BShcuybjPoqzOObs/AZ3mMbOHHFDCi+AG9hU=;
        b=Md6WEMZre9rB/iyBFixNntz0niIIExFsRcfGd8tpW/DqqSUyYZSO4k/sIuNarNQRaL
         NdKURvJSMe3Yy3z9ayIXVkDFba/6NEOiGBL7PZnUpwranc6ehv1BXGxVxVRpYuLF7s1I
         8/lgKfRpakUU0lUTlje6u1P10NZQUcXtUrf7s3Ozrbzk/KS6OVKBzU7uLQePC0bGzSax
         5bfvFEJ5D3hLiqXuFd5LB5p6Yhzxrdbgmc3lfcjvjtbBubUD4Sm82EgG4hwMyOtFF7V+
         GVSLD++MtJ2Wd36H01e9m7jd6AKUdKg/v7v6YYhaBbbLZXezNwRrQJEW/gr/vQ7ELDn+
         18cA==
X-Gm-Message-State: AOAM530/kVQQmOIu655ORhlD0N70bFpnf5uGGrRGoNIUccpebnqgHf6U
        o6o3QqrRUIxwiaRkP5P8jv1sZPFsKh2G1rOF
X-Google-Smtp-Source: ABdhPJwu6164TH5jDahppCWddCLzUTPUirpFQvFstRNJw+fyVWy0V9edHEGdGfr2Ei70TcW5iPz+ZQ==
X-Received: by 2002:a62:382:: with SMTP id 124mr7410521pfd.190.1593269962023;
        Sat, 27 Jun 2020 07:59:22 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id nk22sm3053187pjb.51.2020.06.27.07.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 07:59:21 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     joe@perches.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER),
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/4] staging: qlge: fix ql_sem_unlock
Date:   Sat, 27 Jun 2020 22:58:56 +0800
Message-Id: <20200627145857.15926-4-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200627145857.15926-1-coiby.xu@gmail.com>
References: <20200627145857.15926-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some functions return without releasing the lock. Replace return with
break.

Suggested-by Dan Carpenter <dan.carpenter@oracle.com>.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 87433510a224..63e965966ced 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1390,7 +1390,7 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
 		if (ql_get_mac_addr_reg(qdev, MAC_ADDR_TYPE_CAM_MAC, i, value)) {
 			pr_err("%s: Failed read of mac index register\n",
 			       __func__);
-			return;
+			break;
 		}
 		if (value[0])
 			pr_err("%s: CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
@@ -1402,7 +1402,7 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
 		    (qdev, MAC_ADDR_TYPE_MULTI_MAC, i, value)) {
 			pr_err("%s: Failed read of mac index register\n",
 			       __func__);
-			return;
+			break;
 		}
 		if (value[0])
 			pr_err("%s: MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
@@ -1424,7 +1424,7 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
 		if (ql_get_routing_reg(qdev, i, &value)) {
 			pr_err("%s: Failed read of routing index register\n",
 			       __func__);
-			return;
+			break;
 		}
 		if (value)
 			pr_err("%s: Routing Mask %d = 0x%.08x\n",
--
2.27.0

