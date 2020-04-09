Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56381A3680
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgDIPCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:02:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44463 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgDIPCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:02:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id n13so3661561pgp.11
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 08:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dvyI036P6l3pT4bwTfgpCwEd0qlAqIVfCnEFYrQjFgY=;
        b=f4PZ9Bp7DWyP45o1+1dY6OVR9t/Zn2U4t5xNaMLvMds4J0mo8zf/NBp6vUIk9mngXh
         Y/A5NFrZtyE6uz8iwlOW5p/92lllpK6egMiWRFzyA+Ba9vXeCKQMG+IHqkdKSwo5rgGa
         OEFxEe6JIVdZf8iaj0THuN4IQubcC6Di5dUeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dvyI036P6l3pT4bwTfgpCwEd0qlAqIVfCnEFYrQjFgY=;
        b=VlQGcqSnMOeflINI+awEvibOFs1pjxTP1h2FKAlLUmZGao76KTGMR50tw62y/kz9XX
         hhSa0xEBvfvdQ/OfOo4tOcwQuoE261rtsGQJllY0QmkEdNGGf5lAOA3Ybz0j5mO0OyGl
         9waknRaqMpD/lA9Quinpjw/m1i3IvP8ZjqIZhd/h73SCId/udjOR/VouWzfEeEctVP1Z
         QpfOSLqHpMS7xdpPPMYz5wCR5ZJad6w8x/IimQF97QWcOhfc4/JZlqtubDfNqU1GFKJ1
         ReQr9IVrwboneI2PDKnLcDfyNVmw0WEE4i6APmZU4rNmrMj0N/B9q4aj9x5qRlAwQkqo
         Z8Lw==
X-Gm-Message-State: AGi0PuZYI0yO65DmdlyOU2tfspd59usaCdO/y1hPaagS8sXNPpwGyglk
        7aypPb8MSO50wjzbijs/4ygsBA==
X-Google-Smtp-Source: APiQypJTXJxBJ9WbxJJfFI/qBsLnEp2Iq0pi46An/bRVCiraAMsH8JrHzqke9DjnO90Z7gNY5xGcAw==
X-Received: by 2002:a63:6cc5:: with SMTP id h188mr12079390pgc.337.1586444557551;
        Thu, 09 Apr 2020 08:02:37 -0700 (PDT)
Received: from brooklyn.i.sslab.ics.keio.ac.jp (sslab-relay.ics.keio.ac.jp. [131.113.126.173])
        by smtp.googlemail.com with ESMTPSA id a3sm2823068pfi.60.2020.04.09.08.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 08:02:36 -0700 (PDT)
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     keitasuzuki.park@sslab.ics.keio.ac.jp,
        takafumi.kubota1012@sslab.ics.keio.ac.jp,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        oss-drivers@netronome.com (open list:NETRONOME ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] nfp: Fix memory leak in nfp_resource_acquire()
Date:   Thu,  9 Apr 2020 15:02:07 +0000
Message-Id: <20200409150210.15488-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a memory leak in nfp_resource_acquire(). res->mutex is
alllocated in nfp_resource_try_acquire(). However, when
msleep_interruptible() or time_is_before_eq_jiffies() fails, it falls
into err_fails path where res is freed, but res->mutex is not.

Fix this by changing call to free to nfp_resource_release().

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c
index ce7492a6a98f..95e7bdc95652 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c
@@ -200,7 +200,7 @@ nfp_resource_acquire(struct nfp_cpp *cpp, const char *name)
 
 err_free:
 	nfp_cpp_mutex_free(dev_mutex);
-	kfree(res);
+	nfp_resource_relase(res);
 	return ERR_PTR(err);
 }
 
-- 
2.17.1

