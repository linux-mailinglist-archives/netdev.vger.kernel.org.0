Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347BF2E7DD3
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 04:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgLaDAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 22:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgLaDAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 22:00:07 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2003EC061575;
        Wed, 30 Dec 2020 18:59:42 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id z21so12382203pgj.4;
        Wed, 30 Dec 2020 18:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mIbBu5oerFY8oojdjY4H3fodNxd3UBrAe//XF172Q2U=;
        b=PjJQpR/g7gNVNgz0zU42o4JzpwTUUVxuVc7Aa/jKd6/5Wb/Xt26UNZZw5Y46KO37er
         4a7xdqTuQlChEf2WY0J94ZvkovV1AgHFdw7kXNhkGSVU7eyqyy2AWEqDLfhKUlSkcT9q
         1kgaVkVRp9cukQToCQoO7ZoPNt6/looPtGs8LqBlMDfMahYVnWLTFqptEDVeFhQIO+Du
         7hbCXzSBTMGk1K/clPEHsSG3ApyNTjutkm9BrmLUhMOKJQcKFfXu1+zxZ1fKF2/Hck7y
         1no1ocw995UnWJXTGt1Py7ts/aYsw3McnWXRI8pPAWQ5oCuEAtgFTdanD7AxuitmGPQt
         BGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mIbBu5oerFY8oojdjY4H3fodNxd3UBrAe//XF172Q2U=;
        b=qcKNWT/6BOgYz/E/fyEVFXzmudL1yW0jNjYEsB1tDxFN7fipNrL4wrKaNwKj1h+zJh
         gvrTCgOprrBtu/2DAyPOkiTkGQFsawRxYy9ubNmEHw5GcVZ8y+WUFIcJkK3tN3X/UTaT
         0UWPy/NA0xWXIF4qPUCF5fN/JdDnOqL5okySIGK9Dz8kNX5p0jHmAnarrSaPHmVy0SES
         6qZeKisGpvaUZmpZ1420ZcXlzm8x+lZy2tYXuXV4O3ELilE1Nofv5KLrUQxB5KGdY+0E
         ekHneylxzpyQw3uGQXXFuOvw+/lVmDQMO+sfMpYlMystROriNylz1U3pbD2z4t5G3cLH
         +obg==
X-Gm-Message-State: AOAM533teVwkIqrIHYfjzf3Sq8TERPNMmAi6k9QPJt0QxwXQYM99Wuv6
        IArQEO+XPXQguhDOGaNhjyM=
X-Google-Smtp-Source: ABdhPJx0ge96w+D+4B6R2ghpq/z3f+0RNeOtatEh7iILDHxSWqYYpNp/gFmvp+7+tCVKmdb465AL/g==
X-Received: by 2002:a63:c009:: with SMTP id h9mr27776538pgg.119.1609383581687;
        Wed, 30 Dec 2020 18:59:41 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id b72sm43524740pfb.129.2020.12.30.18.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 18:59:40 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next v2] net: nfc: nci: Change the NCI close sequence
Date:   Thu, 31 Dec 2020 11:59:26 +0900
Message-Id: <20201231025926.2889-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

If there is a NCI command in work queue after closing the NCI device at 
nci_unregister_device, The NCI command timer starts at flush_workqueue
function and then NCI command timeout handler would be called 5 second 
after flushing the NCI command work queue and destroying the queue.
At that time, the timeout handler would try to use NCI command work queue
that is destroyed already. it will causes the problem. To avoid this 
abnormal situation, change the sequence to prevent the NCI command timeout
handler from being called after destroying the NCI command work queue.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---

Changes in v2:
 - Change the commit message.

 net/nfc/nci/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index e64727e1a72f..79bebf4b0796 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -579,11 +579,11 @@ static int nci_close_device(struct nci_dev *ndev)
 
 	clear_bit(NCI_INIT, &ndev->flags);
 
-	del_timer_sync(&ndev->cmd_timer);
-
 	/* Flush cmd wq */
 	flush_workqueue(ndev->cmd_wq);
 
+	del_timer_sync(&ndev->cmd_timer);
+
 	/* Clear flags */
 	ndev->flags = 0;
 
-- 
2.17.1

