Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31457C423
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbfGaNzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:55:18 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44478 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfGaNzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:55:18 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so30504422plr.11;
        Wed, 31 Jul 2019 06:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lFAIGzV10LEoaV8zPcDa2iuScMXM15QaJrhqDBTpF4Q=;
        b=eCVu+3MGo8MCl+SrwWj5FD8afjA9+HbwDwdkpLU47VDtfj6dLsFylyFKCWu40vC6Gd
         f3V0IAHB1PGE44KN1vliiTQfb3+r2TOqbvV7QgSKUKhAu7nK4JskcDk51OfkkW38Cfm3
         kaixvUoXAd0H4qP+gjschwBo3fCHLU+/6qWXRdn+wpbNFC6X8iUi61NiNYRKhBllRt3N
         n69DObmcfrnRUZbNmfjeHgaKaio6D8Y37eKUCrm5pkdqbHmwkKWWGeP0HgMaejkqiOiV
         A2dWv0Df8VmRc+sewOHAwXclJ714NscdLd/OJcTk4TqCar+7rEQpr8/hEbo81dJdrm6c
         pdvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lFAIGzV10LEoaV8zPcDa2iuScMXM15QaJrhqDBTpF4Q=;
        b=hnPDBicqvxKI05XMmMc8Ej3floLcJ9AwY25ikTZkLLLs7fQy/hc9SuL0EHLZwETYiq
         Gw3jijShM0UxfadrBzVz+JPEkaiJcOGmyJXSj5qr0RqDbr/6lmZwDSNoJyhsBuzWbSQ8
         jFejtNlqlwLqxrmJgM2AdUs9J3OPjahzmxPwTOOZycCK79XmINUmIRyMunlzT3GlV8cX
         jFhBbZ5ROmYT3DR9NQsSAR032vvNlu4Z8OYqjN77RwubGCojtqst3uB9DMwWI+6v/1XQ
         23LVxSRE9Ie49K/2GqkBbGrQEH2h6i6PGvtwvle2AoaQQJDbnA96/h23U638CytqCvUq
         Grkg==
X-Gm-Message-State: APjAAAXibKn1WZjoboy1Lrk7wk+dDgheTp9dNBRmxIfrffWlVFXbTHK5
        vGn0Fq1fYqN6akslxoNLT/CRLXXxiT4=
X-Google-Smtp-Source: APXvYqxsbZ4eOAcAle1lMFoiWX5ogIYrKjb5j2hjV4wuXa+3F0WuWeY7hQfaDakxyRL9QSrR8BjCzg==
X-Received: by 2002:a17:902:8ec3:: with SMTP id x3mr9295626plo.313.1564581317757;
        Wed, 31 Jul 2019 06:55:17 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id h70sm63609101pgc.36.2019.07.31.06.55.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 06:55:17 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 2/2] cxgb4: smt: Use refcount_t for refcount
Date:   Wed, 31 Jul 2019 21:55:12 +0800
Message-Id: <20190731135512.26539-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/smt.c | 14 +++++++-------
 drivers/net/ethernet/chelsio/cxgb4/smt.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.c b/drivers/net/ethernet/chelsio/cxgb4/smt.c
index eaf1fb74689c..b008d522bef6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.c
@@ -57,7 +57,7 @@ struct smt_data *t4_init_smt(void)
 		s->smtab[i].state = SMT_STATE_UNUSED;
 		memset(&s->smtab[i].src_mac, 0, ETH_ALEN);
 		spin_lock_init(&s->smtab[i].lock);
-		atomic_set(&s->smtab[i].refcnt, 0);
+		refcount_set(&s->smtab[i].refcnt, 0);
 	}
 	return s;
 }
@@ -68,7 +68,7 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 	struct smt_entry *e, *end;
 
 	for (e = &s->smtab[0], end = &s->smtab[s->smt_size]; e != end; ++e) {
-		if (atomic_read(&e->refcnt) == 0) {
+		if (refcount_read(&e->refcnt) == 0) {
 			if (!first_free)
 				first_free = e;
 		} else {
@@ -98,7 +98,7 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 static void t4_smte_free(struct smt_entry *e)
 {
 	spin_lock_bh(&e->lock);
-	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
+	if (refcount_read(&e->refcnt) == 0) {  /* hasn't been recycled */
 		e->state = SMT_STATE_UNUSED;
 	}
 	spin_unlock_bh(&e->lock);
@@ -111,7 +111,7 @@ static void t4_smte_free(struct smt_entry *e)
  */
 void cxgb4_smt_release(struct smt_entry *e)
 {
-	if (atomic_dec_and_test(&e->refcnt))
+	if (refcount_dec_and_test(&e->refcnt))
 		t4_smte_free(e);
 }
 EXPORT_SYMBOL(cxgb4_smt_release);
@@ -215,14 +215,14 @@ static struct smt_entry *t4_smt_alloc_switching(struct adapter *adap, u16 pfvf,
 	e = find_or_alloc_smte(s, smac);
 	if (e) {
 		spin_lock(&e->lock);
-		if (!atomic_read(&e->refcnt)) {
-			atomic_set(&e->refcnt, 1);
+		if (!refcount_read(&e->refcnt)) {
+			refcount_set(&e->refcnt, 1);
 			e->state = SMT_STATE_SWITCHING;
 			e->pfvf = pfvf;
 			memcpy(e->src_mac, smac, ETH_ALEN);
 			write_smt_entry(adap, e);
 		} else {
-			atomic_inc(&e->refcnt);
+			refcount_inc(&e->refcnt);
 		}
 		spin_unlock(&e->lock);
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.h b/drivers/net/ethernet/chelsio/cxgb4/smt.h
index d6c2cc271398..4774606a0101 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.h
@@ -59,7 +59,7 @@ struct smt_entry {
 	u16 idx;
 	u16 pfvf;
 	u8 src_mac[ETH_ALEN];
-	atomic_t refcnt;
+	refcount_t refcnt;
 	spinlock_t lock;	/* protect smt entry add,removal */
 };
 
-- 
2.20.1

