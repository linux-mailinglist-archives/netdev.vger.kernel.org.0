Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CEC3A2F5B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 17:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhFJPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 11:32:39 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:42697 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbhFJPcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 11:32:36 -0400
Received: by mail-wm1-f51.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso6692733wms.1;
        Thu, 10 Jun 2021 08:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oaRjenhc1WwiDGK8u6oFfetNiLL2rVHkSL9XAdr5Dbw=;
        b=mEqyHv3MzfHQY3IEH7s9P82X1gstWrwozu0jwlEbye2p47KkY8Z7Ansypatb3ZQaQr
         et+BAW0A0lOLVnBOw8NAC58S/IUpzAMdiHgItE2Qly7Qf04OhnBUn7jzLckO7cd3h+HP
         99IK1H6JTJn732RAxP6LmOjxCLzvEQ0ui0JQzLc+lwfi8Nwp1zRhMKrf27Grz3pRImQX
         NE8LeM+s2KqT2GlkuQMVynZc8RaZ6Kta3dksuzPNVAm7/zGD1oxpVMJO9eKpPoUT/M8K
         BxGoVpd0w5tUp2GSNrOW6pzL2SOBMcW6Y77qAsMVcOD67kVHHaUqUu5K5BunQq6CCuyw
         XOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oaRjenhc1WwiDGK8u6oFfetNiLL2rVHkSL9XAdr5Dbw=;
        b=uak3ZCDPegpCRUfh/vB/t29fMpkuPBs87dGxa+sHdCe4SrA7HU0jJnVHH+oPnMmKdT
         EP+o69QXaYsNKvdN3/ddeNdRzm/vS8zEz6Ycg2ewBqe3N2w2FosP0Bnsp53/1q7wADVA
         9aN5ogLBsOGflAyMLFPYvc+MoU9aQQh9+G5wCD9oynYeBx/NLeOhc+ftvpuFi2Qouj/x
         JCVnHsLo0208JlTTW53nhPQ9tKeHiVjIQ/fUj8JZ+i5UF2CyezKtXf/4FwqviqOhMFq7
         WakcJUiN3okxdUnHxOz8L8oyqKy5OCx3l+uBTwJdVEbpI250ETL7icOzET+jphKU5q6O
         /fyQ==
X-Gm-Message-State: AOAM530wDmbrCBCUQAM6fsbefENsoz44o1mjBnfdTpRFqyfTP31PYtjA
        X7PBJeh8Qxi+HgXqGMuihts=
X-Google-Smtp-Source: ABdhPJxKAGPcfo/suMMBuNxkPEEps4X4SvaC2vR2JcINz7wzqUUgEOPjX8FGdrDDODkZ7MECDlmrvg==
X-Received: by 2002:a1c:f30a:: with SMTP id q10mr5650158wmq.138.1623338967558;
        Thu, 10 Jun 2021 08:29:27 -0700 (PDT)
Received: from localhost.localdomain (190.1.93.209.dyn.plus.net. [209.93.1.190])
        by smtp.gmail.com with ESMTPSA id b22sm3309802wmj.22.2021.06.10.08.29.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 08:29:27 -0700 (PDT)
From:   Dhiraj Shah <find.dhiraj@gmail.com>
Cc:     find.dhiraj@gmail.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] function mana_hwc_create_wq leaks memory
Date:   Thu, 10 Jun 2021 16:29:17 +0100
Message-Id: <20210610152925.18145-1-find.dhiraj@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memory space allocated for the queue in function
mana_gd_create_hwc_queue is not freed during error condition.

Signed-off-by: Dhiraj Shah <find.dhiraj@gmail.com>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 1a923fd99990..4aa4bda518fb 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -501,8 +501,10 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	*hwc_wq_ptr = hwc_wq;
 	return 0;
 out:
-	if (err)
+	if (err) {
+		kfree(queue);
 		mana_hwc_destroy_wq(hwc, hwc_wq);
+	}
 	return err;
 }
 
-- 
2.30.1 (Apple Git-130)

