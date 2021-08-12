Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC283EACBE
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 23:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhHLVnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 17:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233480AbhHLVnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 17:43:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2EA56103A;
        Thu, 12 Aug 2021 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628804566;
        bh=U/v7Ga7JuVqs6EDDtd4JuMjNWqfOQY4BRi9N+d+0Clo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhLuySIWzlyYHGMDJlJ4RaGYMKOmBOleOj4KMy+3ZvogBM9lio2Ulgka5xcizyRu0
         M8KDE2AW4p8+qzwh40UT6cJKPOJoAyR9YvFyZ5DyH9r6PtX5CgfXb4Cw7E6SmNpHA8
         HWLRLFCfJPTL4QzgwkHXUzfTPRm7Jjgwn/gvWvc6hL6eOWZ9quzu/sJmOdWwbnFEm4
         yMBMkhLu4fl9SLUv5G2X5KOwtXPTgdZxjSHs7r86HUdh8qt4cn3cBXdz3WVdcz0qbl
         YlXRy6WmrWes9Fv/1o1jHTalXnozYkpMerEer7Xt5ytjnzh80Vgsq9fYRq6Hto7LDJ
         jSnevP3uPJE7Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        prashant@broadcom.com, eddie.wai@broadcom.com,
        huangjw@broadcom.com, gospo@broadcom.com, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 2/4] bnxt: disable napi before canceling DIM
Date:   Thu, 12 Aug 2021 14:42:40 -0700
Message-Id: <20210812214242.578039-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812214242.578039-1-kuba@kernel.org>
References: <20210812214242.578039-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi schedules DIM, napi has to be disabled first,
then DIM canceled.

Noticed while reading the code.

Fixes: 0bc0b97fca73 ("bnxt_en: cleanup DIM work on device shutdown")
Fixes: 6a8788f25625 ("bnxt_en: add support for software dynamic interrupt moderation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 84aa25875050..721b5df36311 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9134,10 +9134,9 @@ static void bnxt_disable_napi(struct bnxt *bp)
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_cp_ring_info *cpr = &bp->bnapi[i]->cp_ring;
 
+		napi_disable(&bp->bnapi[i]->napi);
 		if (bp->bnapi[i]->rx_ring)
 			cancel_work_sync(&cpr->dim.work);
-
-		napi_disable(&bp->bnapi[i]->napi);
 	}
 }
 
-- 
2.31.1

