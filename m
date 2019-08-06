Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7588C829D0
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 04:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730578AbfHFC6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 22:58:54 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39203 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728870AbfHFC6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 22:58:54 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so40745349pgi.6;
        Mon, 05 Aug 2019 19:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OP571MLOJXrBJR5+BZYEU+h3Wt/jQutz4ivmeaED6uU=;
        b=qICSlFRQ4V3wq9jdxCbZc9He72e7ayplvCa0x3Qgsg4rWjCPPCTlOTZQBePitd7HKk
         3OY5ZNCE3BHjCNLMCCp259Q7U2p3mvPntDS0vhRFvIHCey5c83N9UQdHbdsr9teTdTU6
         cLmHfnih1BurvoKbR3aABa0gCMxJYhBC1jKWAy0VuAUQlDKpo39Aeew0zTQ40tOag4Fj
         t4agHKSU1JHsMLDZYa+7C9nFelJ4xa+elcqcRjkQgq10HdpsyAbzI2Q/qQh7C5AbZ+Y4
         w+jclA6sI6RD2C7DGlRzWPv9LatsaJk1rX/dzD217QidV/MQ48w8e3djzBinxWPA5PRH
         K6iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OP571MLOJXrBJR5+BZYEU+h3Wt/jQutz4ivmeaED6uU=;
        b=MVTHEtRYBSqmPEKnet5DpbpMVy0IvZceCfQn4Esf/g7fYgZsX8APkalELpweDUJI4N
         xAH80wALt1auMx+eJeR3vNXe7OTF2iC6N4vp196NmT/Sf5QiIJQSi9zpikYnsB+oD/GU
         HnFcjY6CJvuBWh62Rti9oRcR1Ivn/b+1AAaJ0VMgvoykqPU1FtNy3w+/eUplysVOR6/1
         fl/PSGuYZfh3K6cQucpc9tXM46HpuiHeAmZqCCpFhH9qMhS/9vPxNT4WxMCKjgYIK7SI
         a8xGTPF9QMF3jKBh10z9qNwVVFEprlBtTD+JlAWqCcpQjph0BruOLBsr3BeaOeV8PVku
         Dz8g==
X-Gm-Message-State: APjAAAVKYi/BVCqWXTj8x3D3RQoKXCNpn4AEXMViXuf3Pt/OOdSx+Tv2
        zeHeiBRwsQN/CnJnWl/X4OA=
X-Google-Smtp-Source: APXvYqwTUZe/ZFTZ2G+sdXEIrMnrxz0hjuaD0gqIXtkA99FaP8q77GBvalRJuyGgC103S0ptsfzOcA==
X-Received: by 2002:a17:90a:1b4c:: with SMTP id q70mr790739pjq.69.1565060333242;
        Mon, 05 Aug 2019 19:58:53 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id d2sm17349019pjs.21.2019.08.05.19.58.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 19:58:52 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 1/2] cxgb4: smt: Add lock for atomic_dec_and_test
Date:   Tue,  6 Aug 2019 10:58:46 +0800
Message-Id: <20190806025846.17022-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The atomic_dec_and_test() is not safe because it is
outside of locks.
Move the locks of t4_smte_free() to its caller,
cxgb4_smt_release() to protect the atomic decrement.

Fixes: 3bdb376e6944 ("cxgb4: introduce SMT ops to prepare for SMAC rewrite support")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/smt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.c b/drivers/net/ethernet/chelsio/cxgb4/smt.c
index eaf1fb74689c..d6e84c8b5554 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.c
@@ -97,11 +97,9 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 
 static void t4_smte_free(struct smt_entry *e)
 {
-	spin_lock_bh(&e->lock);
 	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
 		e->state = SMT_STATE_UNUSED;
 	}
-	spin_unlock_bh(&e->lock);
 }
 
 /**
@@ -111,8 +109,10 @@ static void t4_smte_free(struct smt_entry *e)
  */
 void cxgb4_smt_release(struct smt_entry *e)
 {
+	spin_lock_bh(&e->lock);
 	if (atomic_dec_and_test(&e->refcnt))
 		t4_smte_free(e);
+	spin_unlock_bh(&e->lock);
 }
 EXPORT_SYMBOL(cxgb4_smt_release);
 
-- 
2.20.1

