Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2375847BA5
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfFQHuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:50:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:40386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfFQHuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 03:50:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 243EEAFE3;
        Mon, 17 Jun 2019 07:50:17 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 13/16] qlge: Replace memset with assignment
Date:   Mon, 17 Jun 2019 16:48:55 +0900
Message-Id: <20190617074858.32467-13-bpoirier@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of clearing the structure wholesale, it is sufficient to initialize
the skb member which is used to manage sbq instances. lbq instances are
managed according to curr_idx and clean_idx.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index b6e948caf2aa..4502bb4758b4 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -2809,11 +2809,10 @@ static int qlge_init_bq(struct qlge_bq *bq)
 	if (!bq->queue)
 		return -ENOMEM;
 
-	memset(bq->queue, 0, QLGE_BQ_LEN * sizeof(struct qlge_bq_desc));
-
 	buf_ptr = bq->base;
 	bq_desc = &bq->queue[0];
 	for (i = 0; i < QLGE_BQ_LEN; i++, buf_ptr++, bq_desc++) {
+		bq_desc->p.skb = NULL;
 		bq_desc->index = i;
 		bq_desc->buf_ptr = buf_ptr;
 	}
-- 
2.21.0

