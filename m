Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C932B809B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgKRPd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgKRPd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:33:29 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDE7C0613D4;
        Wed, 18 Nov 2020 07:33:28 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id u12so2684130wrt.0;
        Wed, 18 Nov 2020 07:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8wny3kzVC1IR5EcyDuj2RgrjJgW1k6C8oLglaDehiy8=;
        b=c4N9dhSeYwm6VvvieK5qW8KPOFOb1Wz2H51Q7yNynXg8juBv//gERwBeLKzbwe7SYD
         gRYs8sJUqzU4fU1K9rptXIZ3eD4PSiDudVOWVfQazs2IK9r0SIO75oNldS19wvQNsen3
         laZGh20fuAcG5rdpYNSDFevl0ku0DWv72c798Mp5s/GQKTUX2VvPqSLNdwsb2ata6Q4M
         +XIJk9GCoG9MK5W5+eF3WKSy8DK5YZ5r0ARcUYJc1Gn3NZ43JFYwDNKwlIvyY7PlZrzE
         RUYYUPg9YgAQvFDo2PA9GXRNBcD1x0Wv8N9h/5pvuf3DY1Eruu/VL24OEcbIIUCAtlGs
         U1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8wny3kzVC1IR5EcyDuj2RgrjJgW1k6C8oLglaDehiy8=;
        b=Oo0c10BkwxEHXeZRI4XVUxEv6G9PaehkXH/ENVdBmYGLRTa1k6NwWSC2M3r8SMIcSb
         GOu1uqvAYNBFecPHVHYOYGDxS9d1CP894xPyE4DB+r8OFJSODjYPjBNBYgHidLRo01hb
         WzrYmDEXPguopUnXwnSQtsJlO9N13vn0csag/VJPGmiVRRGQ1BW1UuT7847ACUROsuIr
         S5YCGbqDXsYh+bNLTWdcPdoe4E7Qt3KoKVoc7AkETiHlWmg0iFm5XfJW7Gky1c4kjyAN
         C4/iT0aM6xwEww2+AgBeXJwriI/nrsKOnxHp78ApZT2lJ563BGCv3lckhsmJflJ3iHHo
         pBXw==
X-Gm-Message-State: AOAM5309lG8JUDzkQzNHm3mC0hXGi7/TCHIeaS9vR4NQnxcuJvcug7JU
        9pnW3JYMdVNwc2DwvsVO1EpeBXOULzYMIC69
X-Google-Smtp-Source: ABdhPJz/vblUYoZh2K8DlxwaydB+cG/5byw4frw9B7T+IEsnhSzf5xXi92WJfR2i2m98L3GIwyJlQQ==
X-Received: by 2002:a5d:6447:: with SMTP id d7mr5525080wrw.96.1605713607160;
        Wed, 18 Nov 2020 07:33:27 -0800 (PST)
Received: from localhost.localdomain (host-82-51-6-75.retail.telecomitalia.it. [82.51.6.75])
        by smtp.gmail.com with ESMTPSA id v19sm4394146wmj.31.2020.11.18.07.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 07:33:26 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] hv_netvsc: Validate number of allocated sub-channels
Date:   Wed, 18 Nov 2020 16:33:10 +0100
Message-Id: <20201118153310.112404-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lack of validation could lead to out-of-bound reads and information
leaks (cf. usage of nvdev->chan_table[]).  Check that the number of
allocated sub-channels fits into the expected range.

Suggested-by: Saruhan Karademir <skarade@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
Based on hyperv-next.

 drivers/net/hyperv/rndis_filter.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 3835d9bea1005..c5a709f67870f 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1226,6 +1226,11 @@ int rndis_set_subchannel(struct net_device *ndev,
 		return -EIO;
 	}
 
+	/* Check that number of allocated sub channel is within the expected range */
+	if (init_packet->msg.v5_msg.subchn_comp.num_subchannels > nvdev->num_chn - 1) {
+		netdev_err(ndev, "invalid number of allocated sub channel\n");
+		return -EINVAL;
+	}
 	nvdev->num_chn = 1 +
 		init_packet->msg.v5_msg.subchn_comp.num_subchannels;
 
-- 
2.25.1

