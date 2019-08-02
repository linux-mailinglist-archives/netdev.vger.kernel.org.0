Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF047EF6B
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404306AbfHBIfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:35:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41416 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730316AbfHBIfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:35:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so35673276pff.8;
        Fri, 02 Aug 2019 01:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JAVzy6uxJGD5NKAU23oaWBpBeprdEwqZQPaxMvijZAw=;
        b=VpmcWgho0hLUVRQPXjtitgsz69EpeXpq+ZNaEQ3clnds9anR1Imz9FwVmdj09m4SJs
         mbLGsTRJwKkICD4GD+AOysTN9CK5X0AbCqm+U+Iehl0BNpRkx4F1obUTz0U5QiejmXbL
         LIrUpQnSLL5bT6NGuVNVLhAoI5XiF1+UwvCcyFNyLq233Smqjbb5feikYMfiWzMEZA6o
         ZLlpkapsg+yp9Yb0KH3pOs8xSJZxtVwYMD7kgPulWxa96BVbVlKGCJkJn4V5/jNDQSWy
         FgMej3+OkJEAMrqx4lanhAObEUxOzA/Mp97OpKluAzcGPs9Hy4ItBYkUYOAwo7unhNTA
         fmlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JAVzy6uxJGD5NKAU23oaWBpBeprdEwqZQPaxMvijZAw=;
        b=jWoynM+mSwPGH4ocZTOVf11adZmE3sV99qRRbSPGk2sL3g3Oe+KQM80gG41e0b7Dmh
         lTRe67C6Mfe+Dors3IJRXR6dqptT+LjDd2+GQwOaffJYKodkX1/EqdNt4UENJDvb6TxD
         CyjDcvFtsFuuL2BbgLTUja3CD2ZTmcNm5trDI6/Sf/QFFFQj1a3N6Q8gBfNUSMtakwr0
         gjOkfSjiNSpCuISYJ+iE1FD1SDmDTfLeeB0kraKidM7QEaotIZN+QjR69RVWbetnQHbU
         HIEuHhaPok2RwdAfiA69gEc98LTAIvKe5yYmBm2MZUZ/VPCe5gxbW02jpj8HjyytE1Me
         JrSQ==
X-Gm-Message-State: APjAAAWPJ9DexCk1czCmN1HOahCFcrRp9l/WP2u/R57wW1Gi29rJmtSW
        qyy2lbWJxyXRobiea3pn30M=
X-Google-Smtp-Source: APXvYqyOIOSmtv4+2oKCqoUt46lNtHZP38aP18g+c8nGP2pVhgj4kt6G+4fnd6qzwGlp+ZcvtLYEBw==
X-Received: by 2002:a63:5a4d:: with SMTP id k13mr119736342pgm.174.1564734952316;
        Fri, 02 Aug 2019 01:35:52 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id r27sm80843268pgn.25.2019.08.02.01.35.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:35:51 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 2/2] cxgb4: smt: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 16:35:47 +0800
Message-Id: <20190802083547.12657-1-hslester96@gmail.com>
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
Changes in v2:
  - Convert refcount from 0-base to 1-base.

 drivers/net/ethernet/chelsio/cxgb4/smt.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.c b/drivers/net/ethernet/chelsio/cxgb4/smt.c
index eaf1fb74689c..343887fa52aa 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.c
@@ -57,7 +57,7 @@ struct smt_data *t4_init_smt(void)
 		s->smtab[i].state = SMT_STATE_UNUSED;
 		memset(&s->smtab[i].src_mac, 0, ETH_ALEN);
 		spin_lock_init(&s->smtab[i].lock);
-		atomic_set(&s->smtab[i].refcnt, 0);
+		refcount_set(&s->smtab[i].refcnt, 1);
 	}
 	return s;
 }
@@ -68,7 +68,7 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 	struct smt_entry *e, *end;
 
 	for (e = &s->smtab[0], end = &s->smtab[s->smt_size]; e != end; ++e) {
-		if (atomic_read(&e->refcnt) == 0) {
+		if (refcount_read(&e->refcnt) == 1) {
 			if (!first_free)
 				first_free = e;
 		} else {
@@ -98,7 +98,7 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 static void t4_smte_free(struct smt_entry *e)
 {
 	spin_lock_bh(&e->lock);
-	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
+	if (refcount_read(&e->refcnt) == 1) {  /* hasn't been recycled */
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
+		if (refcount_read(&e->refcnt) == 1) {
+			refcount_set(&e->refcnt, 2);
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
-- 
2.20.1

