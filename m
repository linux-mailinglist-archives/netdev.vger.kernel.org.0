Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E6F30D8CA
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 12:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhBCLhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 06:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbhBCLhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 06:37:09 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17D6C061786;
        Wed,  3 Feb 2021 03:36:28 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id l12so23839304wry.2;
        Wed, 03 Feb 2021 03:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piicmRCuLZbTBJlar9FXYLLsqVbbP0x2N6R3KyFMnss=;
        b=AFIeOrcprV4b2fseY/Ehcn6HXdg5fNHAE5F1dXVBj0mrPYZuTS3wu2HFtQadCpAIEk
         3zUk9L6uAztUgPb6sVY/AOJG/2Y1FAqwHzlHPzHsZ3rOnXOFfJM/Dx1ULbPKjfFXaSyz
         OStvspiiiNeyLRMHeDm+bLPHcpZmiqDnHArhEDDzgAoL0IGM270hifvaO/fTQqo2oz/x
         AaHTwzHUO7zgRZRArg5y/WD3yz4rJZveUf/q61Lhqt5EhCu+LxwoStABhFc7xBDrlOiT
         FE2iJolIqd3xWV49mJZOWfv9oQmtgMOIEJFV8FJUola8lDdXlB2tB2GZoWZAQ3+UlmhF
         0wBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piicmRCuLZbTBJlar9FXYLLsqVbbP0x2N6R3KyFMnss=;
        b=UhTPVwcE5qUd3WXv5b9c55zAbZcpPUz1+2ri5iIf0bZON+7PYYNMCLeAZMlSw4V/t1
         PPmrF2rFvVWziIzN0FulmGUNDwoWDScq+nyAeFYfVxSn2DlMEkU8xzalGI2zrX8eE4vd
         /9UnYkCfli0bY1pg+DIN8pe7le9WnmwWU9l+KZviNPSKmHNvnryfnpBMKTnbbpblq4fv
         1dZEKVE5u6kk5jeJulY0A39wN+ciyTUCujZgqikPgmwcokuV+5d7kGipOMdsSgqUgtHM
         Do2ewIUuuhMHjWajmkD5uyrvx6lX8KLrw2hHb/RI2BK3giM+GlyFtniK8k+nmfg8AoT6
         E4vQ==
X-Gm-Message-State: AOAM531XboZizz6iT9r8g59eSBDHei379o3TQ8aFfr9MugX0cWqPD1cj
        sy0Oa0vAxz/MYk5wPNO9f+GhU8bDn2Ko+icC
X-Google-Smtp-Source: ABdhPJz4Ml0T/POwNiVR6M1731jHxpXg8XUbjoRPaUUpU3OSBj5hsY75ssXcEcoIeL9xaWPDD90sjw==
X-Received: by 2002:a5d:6b89:: with SMTP id n9mr2959659wrx.323.1612352187106;
        Wed, 03 Feb 2021 03:36:27 -0800 (PST)
Received: from anparri.mshome.net (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id z1sm3183707wrp.62.2021.02.03.03.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 03:36:26 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net] hv_netvsc: Reset the RSC count if NVSP_STAT_FAIL in netvsc_receive()
Date:   Wed,  3 Feb 2021 12:36:02 +0100
Message-Id: <20210203113602.558916-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 44144185951a0f ("hv_netvsc: Add validation for untrusted Hyper-V
values") added validation to rndis_filter_receive_data() (and
rndis_filter_receive()) which introduced NVSP_STAT_FAIL-scenarios where
the count is not updated/reset.  Fix this omission, and prevent similar
scenarios from occurring in the future.

Reported-by: Juan Vazquez <juvazq@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Fixes: 44144185951a0f ("hv_netvsc: Add validation for untrusted Hyper-V values")
---
 drivers/net/hyperv/netvsc.c       | 5 ++++-
 drivers/net/hyperv/rndis_filter.c | 2 --
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 2350342b961ff..13bd48a75db76 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1262,8 +1262,11 @@ static int netvsc_receive(struct net_device *ndev,
 		ret = rndis_filter_receive(ndev, net_device,
 					   nvchan, data, buflen);
 
-		if (unlikely(ret != NVSP_STAT_SUCCESS))
+		if (unlikely(ret != NVSP_STAT_SUCCESS)) {
+			/* Drop incomplete packet */
+			nvchan->rsc.cnt = 0;
 			status = NVSP_STAT_FAIL;
+		}
 	}
 
 	enq_receive_complete(ndev, net_device, q_idx,
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 598713c0d5a87..3aab2b867fc0d 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -509,8 +509,6 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 	return ret;
 
 drop:
-	/* Drop incomplete packet */
-	nvchan->rsc.cnt = 0;
 	return NVSP_STAT_FAIL;
 }
 
-- 
2.25.1

