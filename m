Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CE317D6DA
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgCHWqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:46:11 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37478 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHWqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:46:11 -0400
Received: by mail-pg1-f196.google.com with SMTP id z12so3835945pgl.4
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y6gVghtGNjdVLr5pgPhyE3CqNNv8gXHxWee8OqqZHuk=;
        b=Y+fqY08rcvMhyeDYQwJYnyAf3cU62DRYXUdRzQcJq65nBv4JWH5a6a2gawD4xXzxcg
         7g9fUiPgErNatkqhnqNdQrzW77oyUIO7XAfdxsrY7m8PX9XjIO+M9n0LrVnhGl4ADezj
         dGyzCQbjKNAVf8+3WyUzXvjT2jfbXp/520Ffc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y6gVghtGNjdVLr5pgPhyE3CqNNv8gXHxWee8OqqZHuk=;
        b=cYX7jXIppOjDbFWt4vsA3h2Bw+IKzZ49lZoG3tOY5Td3JKncRpQH5ouGd9EcXDo3ze
         yNueitnEcRlx6/HV++j8ee0zj/G7GCwyHcWhyRoldppkzymG4m8SMkjev4SGWBdA48kK
         wOno4IVWTKmDjh6Du9n2SyjouYS03TmESOMf7Y9K0U9cY2Ehb9uPTcZ6BYB2UnwxYSLA
         KDwRWbLNKE7sJF6cPSOuERORhIaKI1b3MJrH3l6djKZTuCTMP+VjFbiX7lr3fDzbeNQ3
         LBURgK5JBPndmorGiTIcCNeHAHnf3GKaayavY+0zMyDXjPtKtUQdGnZVycbiCKn250Lw
         EM3A==
X-Gm-Message-State: ANhLgQ3MY+aFo8hUfkVmw+BY0/VReg3jkV40v/0u9D4kj/vl7WKMc12K
        REH61wg1gJZgd3fiPUYn/5YTHj2Uq+o=
X-Google-Smtp-Source: ADFU+vsO6mi4PM0KKXmdhgVq6kcXt0MB9HdD1vXyMOEbiBofIAQXbJLpQHdGHjfKhAIfIkJ9b7KeXQ==
X-Received: by 2002:a63:770d:: with SMTP id s13mr13418651pgc.7.1583707570336;
        Sun, 08 Mar 2020 15:46:10 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x66sm31241397pgb.9.2020.03.08.15.46.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 15:46:09 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/8] bnxt_en: Handle all NQ notifications in bnxt_poll_p5().
Date:   Sun,  8 Mar 2020 18:45:47 -0400
Message-Id: <1583707554-1163-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
References: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bnxt_poll_p5(), the logic polls for up to 2 completion rings (RX and
TX) for work.  In the current code, if we reach budget polling the
first completion ring, we will stop.  If the other completion ring
has work to do, we will handle it when NAPI calls us back.

This is not optimal.  We potentially leave an unproceesed entry in
the NQ.  When we are finally done with NAPI polling and re-enable
interrupt, the remaining entry in the NQ will cause interrupt to
be triggered immediately for no reason.

Modify the code in bnxt_poll_p5() to keep looping until all NQ
entries are handled even if the first completion ring has reached
budget.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dee13ee..0b1af02 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2438,6 +2438,9 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 		nqcmp = &cpr->nq_desc_ring[CP_RING(cons)][CP_IDX(cons)];
 
 		if (!NQ_CMP_VALID(nqcmp, raw_cons)) {
+			if (cpr->has_more_work)
+				break;
+
 			__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ_ARMALL,
 					     false);
 			cpr->cp_raw_cons = raw_cons;
@@ -2459,13 +2462,11 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 			cpr2 = cpr->cp_ring_arr[idx];
 			work_done += __bnxt_poll_work(bp, cpr2,
 						      budget - work_done);
-			cpr->has_more_work = cpr2->has_more_work;
+			cpr->has_more_work |= cpr2->has_more_work;
 		} else {
 			bnxt_hwrm_handler(bp, (struct tx_cmp *)nqcmp);
 		}
 		raw_cons = NEXT_RAW_CMP(raw_cons);
-		if (cpr->has_more_work)
-			break;
 	}
 	__bnxt_poll_cqs_done(bp, bnapi, DBR_TYPE_CQ, true);
 	cpr->cp_raw_cons = raw_cons;
-- 
2.5.1

