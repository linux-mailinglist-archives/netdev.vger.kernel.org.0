Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E39EC0338
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfI0KPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:57664 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727635AbfI0KPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:15:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C30C2B023;
        Fri, 27 Sep 2019 10:15:34 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/17] staging: qlge: Replace memset with assignment
Date:   Fri, 27 Sep 2019 19:12:08 +0900
Message-Id: <20190927101210.23856-15-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
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
 drivers/staging/qlge/qlge_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 8da596922582..009934bcb515 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2807,11 +2807,10 @@ static int qlge_init_bq(struct qlge_bq *bq)
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
2.23.0

