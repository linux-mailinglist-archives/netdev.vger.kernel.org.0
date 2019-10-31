Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955FEEAA08
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 06:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfJaFIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 01:08:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41700 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfJaFIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 01:08:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id t10so2117223plr.8
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 22:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ofDs0JwRlvw65FKNi7UAsbnMfHKxn0XChGZogBd9tig=;
        b=AN/p6HOqr5UPX2MI684tbXpUGkguQx3lWRvs6SlV0mbXZ8dxvaXFjbCEj7w3Ta/EQA
         CF33BXp9VUwULW7KPt7peOJ7dyPA9cehgBH9Sj7oWL3eBEBd0YJSgEmA3HeMQHRGidU9
         O0bavuRctA+GKgVx9La7Q971GJPix8a1Q9YaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ofDs0JwRlvw65FKNi7UAsbnMfHKxn0XChGZogBd9tig=;
        b=Puhg1ABacN/3ZDY+PQVt+mG+AlYPSNAqE/1ydo434lCCDPIiGmPzCF33l6WRxrNkgt
         tylaXKTH4reGnn0Zbh9PcXc6wTd0eC2ti5cW5xSeJbTlEhZ3qOOcEqFf1Ao7ZcqAA40Z
         /fFqvcX/sFYMYo5nrIYeKficpFidB9De9HNLUg75ZoZrlR+++WF03R5aOdIzWQWu4x+g
         tOX8hanN6DMo36ec3Eqj2X1zApTl0PNGr6V6cqaGgFWdE8aQSRUlpAtPxQXtySwECY2O
         j78b77jVY4Rn/+bKY/kF+2axpTP/ga46qcBa87YkhAMvEKPN+V4hYtIyN1HhWYJeY9XY
         N8DQ==
X-Gm-Message-State: APjAAAVL4aFCiIP0n6CwjLbDoZWNtNByDbpoUmOMC/KZKLMnekIbWMNZ
        ld3lU0R6LMMOee8tydqg56OR2A==
X-Google-Smtp-Source: APXvYqxlOsUjUhikTT5Y6hj69F9BD+VJZHFff8X6imWZZScyXsqnwfNYQB/xZ7DY4vloODckDnaXWg==
X-Received: by 2002:a17:902:b781:: with SMTP id e1mr2893800pls.212.1572498495089;
        Wed, 30 Oct 2019 22:08:15 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a8sm1690899pff.5.2019.10.30.22.08.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 22:08:14 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>
Subject: [PATCH net-next v2 2/7] bnxt: Avoid logging an unnecessary message when a flow can't be offloaded
Date:   Thu, 31 Oct 2019 01:07:46 -0400
Message-Id: <1572498471-31550-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
References: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

For every single case where bnxt_tc_can_offload() can fail, we are
logging a user friendly descriptive message anyway, but because of the
path it would take in case of failure, another redundant error message
would get logged. Just freeing the node and returning from the point of
failure should suffice.

Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 80b39ff..c35cde8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1406,7 +1406,8 @@ static int bnxt_tc_add_flow(struct bnxt *bp, u16 src_fid,
 
 	if (!bnxt_tc_can_offload(bp, flow)) {
 		rc = -EOPNOTSUPP;
-		goto free_node;
+		kfree_rcu(new_node, rcu);
+		return rc;
 	}
 
 	/* If a flow exists with the same cookie, delete it */
-- 
2.5.1

