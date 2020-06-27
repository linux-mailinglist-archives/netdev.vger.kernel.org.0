Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA60120C0A2
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 12:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgF0KPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 06:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgF0KPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 06:15:09 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8CBC03E979;
        Sat, 27 Jun 2020 03:15:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j12so5750864pfn.10;
        Sat, 27 Jun 2020 03:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0qR0RG0BShcuybjPoqzOObs/AZ3mMbOHHFDCi+AG9hU=;
        b=Ev+JM43d0G4kdO8kGj3ENv21tA2iXVDg860b1ybAD1cCfqHXZqXFOpJ4D22SJYVruq
         g/fhyavk5K7Av/94jSXC334Uhjn2gmHNFPZqcwSJYzDFBKcB0HGojpVbRRZTpiF+Ptl2
         nrJjNmOFhA2eKyymiBqvcB8nA62eSplMMjZPyNaZDwgiMjw9mgvmoO1q2vsW3DiFNzKb
         oOvuqnSkZ3zus+PMTLICx9Mk03j0j7nLGNyVAqINy5SAzJZrld/qw+oAdK/5oU3sEcMn
         Z/wv/RUnLl+Yj+ES96LBIQSeSTub+oF5JtSpCx9y6Ln7ZCA1EeRMQQbk5WIXyD2yuYFx
         hV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0qR0RG0BShcuybjPoqzOObs/AZ3mMbOHHFDCi+AG9hU=;
        b=SdDn7ZB44MZtFqUPKUjuFBLuHYONwsjVC1gn1uAyTt+F5D3TJwb3pAuoD0eJSI8swH
         KikPeAjZkrtZHhpQYO0Q+JPDg6AvOK/pgC4MrY8iFyiggNqYI60y6Enk0dMeXL15uwfl
         bgPvUFajmxBCp8jTF7YS06s8RlcsC0ZP0Gvfji3Hdfuexgp5uJiQIyH2AnGA8hImuENC
         7RykorjRpK3WHXX883MCB/OWsrZTsSYR7DYcpUejaha5szyRtGs8gu9SBX9oRxHIj5Fp
         x2gn+qnX2A8lshQugDc7pG6aXkHd4toTqDnNKkD6GmRfo/SxaI8Hlc3ZUrPA+tX3Yqme
         Gpng==
X-Gm-Message-State: AOAM532/T59Lm8RKTK0SpbQIxqGw/HQgLH38HqC3xrqXFRtJzqruW1Z+
        GcBKIamwkHqDO2d5HYko8cw=
X-Google-Smtp-Source: ABdhPJwxd/MX993W08orF88EtVjv0w325D4ncrT/QVnFsjOuAaruieh18whLktBHBU/EGxmNuiLmUA==
X-Received: by 2002:a62:445:: with SMTP id 66mr6270438pfe.186.1593252909237;
        Sat, 27 Jun 2020 03:15:09 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id j16sm18782577pgb.33.2020.06.27.03.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 03:15:08 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     joe@perches.com, dan.carpenter@oracle.com,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] fix ql_sem_unlock
Date:   Sat, 27 Jun 2020 18:14:46 +0800
Message-Id: <20200627101447.167370-4-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200627101447.167370-1-coiby.xu@gmail.com>
References: <20200627101447.167370-1-coiby.xu@gmail.com>
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

