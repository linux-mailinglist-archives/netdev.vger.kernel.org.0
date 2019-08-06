Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B018300D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbfHFKvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 06:51:22 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44120 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730868AbfHFKvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 06:51:22 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so81832430edr.11
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 03:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=wuO6fMcyl9J8ywJSwaAd0qoNTn0a/2M4vioj8AOzVoQ=;
        b=R/pveRg9rFWxLRducfRMP1lFiPdWUosMJnElpVcadUkp+6D/iqJX4xplez3fa2t6mg
         ydck3d0NQsxeQ/W+lZ2CNkbm7Izg+oxbnNt7QrMr97N4p2qXXgJGIa8ldZ8ktAs5UX+b
         M0ePAFreIcRwxl+MtaZDAfJ/BIJf46KG2vOHk8kfX3UQairhyCdVrUrewhhA4mhbekRM
         YJ+M68o11UGkIUxEZO/2vHlTjqUcVW0PgyWuCKq9g1LdtNV7uLOn8F0lgJhDk8Fas8C9
         BxtY0sVEv8yf9XhfiPmObUJok0Yr/TrKlKc95/DoxQ5i2KBrqvGdGepkHyPH1XMZ8l6L
         zjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wuO6fMcyl9J8ywJSwaAd0qoNTn0a/2M4vioj8AOzVoQ=;
        b=dUxSwYbvu1hruXijGCdO5gMrD5K6xRBt1TlzYCYrmjW1jUWT2sFDR3OU0FjShK1TQ0
         NjQhMTPpa3j5CYnYi9iruXBLaGeargBuQm6XZcXLIWX+LWazZ7612ZMRIm10zN4/cxX9
         nPUsGc0FUGb734YNTz9FMFMAUyu3rwjTkZ03x8GsXTF8lGk7qti3Bmj0BigHXo95LCDw
         6av6TTJXFtXUS4GrZX3pDrKSwum2SXs9zkeqt+zHiMFu6OE+RO4MtPPFbbPkR+YNXEi5
         quckgN0XsXVCAY+5Y1kzctx/phM4PnhHpuJ3AHrY8DtjL8J1JTkrB1swh2w7k1lg2+jV
         26Fw==
X-Gm-Message-State: APjAAAXENcV8vx6KH5OxCD79/K1/A1rRosF8dOzp1o7JAczuZLH1Bx0T
        zIF5sAs1qFaePJBMCCylgnDAFKzWqsI=
X-Google-Smtp-Source: APXvYqyYJyY69g1zR0zF4vwgTabSktmhglnAf7tRI/5pJZ6iIcqnXPfSQMOODUJUO9bZNHfIvNourw==
X-Received: by 2002:a50:ed07:: with SMTP id j7mr3096254eds.107.1565088680359;
        Tue, 06 Aug 2019 03:51:20 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id om21sm3092782ejb.32.2019.08.06.03.51.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 03:51:19 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Cc:     netdev@vger.kernel.org, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH v3 net-next] be2net: disable bh with spin_lock in be_process_mcc
Date:   Tue,  6 Aug 2019 12:51:11 +0200
Message-Id: <20190806105111.27058-1-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

be_process_mcc() is invoked in 3 different places and
always with BHs disabled except the be_poll function
but since it's invoked from softirq with BHs
disabled it won't hurt.

v1->v2: added explanation to the patch
v2->v3: add a missing call from be_cmds.c

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 6 ++----
 drivers/net/ethernet/emulex/benet/be_main.c | 2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index ef5d61d57597..323976c811e9 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -550,7 +550,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	int num = 0, status = 0;
 	struct be_mcc_obj *mcc_obj = &adapter->mcc_obj;
 
-	spin_lock(&adapter->mcc_cq_lock);
+	spin_lock_bh(&adapter->mcc_cq_lock);
 
 	while ((compl = be_mcc_compl_get(adapter))) {
 		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
@@ -566,7 +566,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	if (num)
 		be_cq_notify(adapter, mcc_obj->cq.id, mcc_obj->rearm_cq, num);
 
-	spin_unlock(&adapter->mcc_cq_lock);
+	spin_unlock_bh(&adapter->mcc_cq_lock);
 	return status;
 }
 
@@ -581,9 +581,7 @@ static int be_mcc_wait_compl(struct be_adapter *adapter)
 		if (be_check_error(adapter, BE_ERROR_ANY))
 			return -EIO;
 
-		local_bh_disable();
 		status = be_process_mcc(adapter);
-		local_bh_enable();
 
 		if (atomic_read(&mcc_obj->q.used) == 0)
 			break;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 2edb86ec9fe9..4d8e40ac66d2 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5630,9 +5630,7 @@ static void be_worker(struct work_struct *work)
 	 * mcc completions
 	 */
 	if (!netif_running(adapter->netdev)) {
-		local_bh_disable();
 		be_process_mcc(adapter);
-		local_bh_enable();
 		goto reschedule;
 	}
 
-- 
2.12.3

