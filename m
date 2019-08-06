Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE77829D2
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 04:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbfHFC7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 22:59:01 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40526 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728870AbfHFC7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 22:59:01 -0400
Received: by mail-pl1-f193.google.com with SMTP id a93so37164499pla.7;
        Mon, 05 Aug 2019 19:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a4Ub+sv1k1e8nsgh66la+6tG6yPygg10HKO3z6Kulf8=;
        b=WHN5rfgBqk16eNjZkhFHQ7ySxBkrv4oo0C1U4UR12Z3MJG3WVsRY856VOKl72aygO8
         Hu4ZjRWlzceL40MjxAYvPFswixkpGlWILzBT6HTOxAewfYVYsGNNInhK0nWGjs2NdzQH
         SC8xAdlm8qNTkGSsobxV5PzkxEH5GHOBMYHI9Cit3nbiEKrCaPStlT4pOXD6ahUTWs06
         Wr0vIFd27Q6lQdTGRdS7ko5y8Au5L+HRX6WyQoZVHVZgIadFJ9gD2hVIL++8E3AAZN9n
         hK7O8RgnTM1pAHb95pomOr8lGCySOCCmXdWIxUKmPlbZy6wVZlRqitsCIWF7M3ZZPvXP
         9QJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a4Ub+sv1k1e8nsgh66la+6tG6yPygg10HKO3z6Kulf8=;
        b=O1TbSGEEmv6wCnWWc1mks4vFXRH5y2UV0Wh2EqOGZo+B/fHEHavWkTnQwxeUMzaDzq
         0Jiegjbgpigsad2cGYRY6eUPZzbQFBA+pFtKLYJaulDVFjEet4J4GF9/fMFq2eRdfLkc
         1zmjaMAYUilnoEGWAq4k63VIlxWdmP+MBsq0UuYnXtJHUY5BJLuOXlkvybtptbqQz7Qp
         G0G1g2jUnZEcBcBDKpkLfLtPzmLNUNT4E5PuKQJo2vnYsOE+OmDA/DWsE5Vx0XY7gXa5
         izYprAMp0GJ1OxaJe8QV8c7rHLVjcKdRhYur6CKEELMoi3HUtWsyIVf3FsPqZtAUlNKT
         wjdw==
X-Gm-Message-State: APjAAAUfmaReDwsTsZ48oiXLaz0IwGMh8l0XAIcHpKzJ4ohw5j8P2kuv
        kUbzCBhIPR3x++8+vV2Lu5E=
X-Google-Smtp-Source: APXvYqzZf8fM+1aEIUQxGGaPBdMFTxp6ZvswfiPWM17x6tGZzrhVFt+qMfFX9pAqis1lkaWrRiaxPw==
X-Received: by 2002:a17:902:1e9:: with SMTP id b96mr843699plb.277.1565060340386;
        Mon, 05 Aug 2019 19:59:00 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id l189sm103166522pfl.7.2019.08.05.19.58.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 19:58:59 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 2/2] cxgb4: smt: Use normal int for refcount
Date:   Tue,  6 Aug 2019 10:58:54 +0800
Message-Id: <20190806025854.17076-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All refcount operations are protected by spinlocks now.
Then the atomic counter can be replaced by a normal int.

This patch depends on PATCH 1/2.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/smt.c | 14 +++++++-------
 drivers/net/ethernet/chelsio/cxgb4/smt.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.c b/drivers/net/ethernet/chelsio/cxgb4/smt.c
index d6e84c8b5554..01c65d13fc0e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.c
@@ -57,7 +57,7 @@ struct smt_data *t4_init_smt(void)
 		s->smtab[i].state = SMT_STATE_UNUSED;
 		memset(&s->smtab[i].src_mac, 0, ETH_ALEN);
 		spin_lock_init(&s->smtab[i].lock);
-		atomic_set(&s->smtab[i].refcnt, 0);
+		s->smtab[i].refcnt = 0;
 	}
 	return s;
 }
@@ -68,7 +68,7 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 	struct smt_entry *e, *end;
 
 	for (e = &s->smtab[0], end = &s->smtab[s->smt_size]; e != end; ++e) {
-		if (atomic_read(&e->refcnt) == 0) {
+		if (e->refcnt == 0) {
 			if (!first_free)
 				first_free = e;
 		} else {
@@ -97,7 +97,7 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 
 static void t4_smte_free(struct smt_entry *e)
 {
-	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
+	if (e->refcnt == 0) {  /* hasn't been recycled */
 		e->state = SMT_STATE_UNUSED;
 	}
 }
@@ -110,7 +110,7 @@ static void t4_smte_free(struct smt_entry *e)
 void cxgb4_smt_release(struct smt_entry *e)
 {
 	spin_lock_bh(&e->lock);
-	if (atomic_dec_and_test(&e->refcnt))
+	if ((--e->refcnt) == 0)
 		t4_smte_free(e);
 	spin_unlock_bh(&e->lock);
 }
@@ -215,14 +215,14 @@ static struct smt_entry *t4_smt_alloc_switching(struct adapter *adap, u16 pfvf,
 	e = find_or_alloc_smte(s, smac);
 	if (e) {
 		spin_lock(&e->lock);
-		if (!atomic_read(&e->refcnt)) {
-			atomic_set(&e->refcnt, 1);
+		if (!e->refcnt) {
+			e->refcnt = 1;
 			e->state = SMT_STATE_SWITCHING;
 			e->pfvf = pfvf;
 			memcpy(e->src_mac, smac, ETH_ALEN);
 			write_smt_entry(adap, e);
 		} else {
-			atomic_inc(&e->refcnt);
+			++e->refcnt;
 		}
 		spin_unlock(&e->lock);
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.h b/drivers/net/ethernet/chelsio/cxgb4/smt.h
index d6c2cc271398..1268d6e93a47 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.h
@@ -59,7 +59,7 @@ struct smt_entry {
 	u16 idx;
 	u16 pfvf;
 	u8 src_mac[ETH_ALEN];
-	atomic_t refcnt;
+	int refcnt;
 	spinlock_t lock;	/* protect smt entry add,removal */
 };
 
-- 
2.20.1

