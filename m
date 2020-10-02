Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B808280EE7
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgJBI2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:28:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:50386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387739AbgJBI2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 04:28:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E8BF0AF1A;
        Fri,  2 Oct 2020 08:28:34 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     davem@davemloft.net, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        ceph-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <amwang@redhat.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Chris Leech <cleech@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v10 6/7] scsi: libiscsi: use sendpage_ok() in iscsi_tcp_segment_map()
Date:   Fri,  2 Oct 2020 16:27:33 +0800
Message-Id: <20201002082734.13925-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002082734.13925-1-colyli@suse.de>
References: <20201002082734.13925-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In iscsci driver, iscsi_tcp_segment_map() uses the following code to
check whether the page should or not be handled by sendpage:
    if (!recv && page_count(sg_page(sg)) >= 1 && !PageSlab(sg_page(sg)))

The "page_count(sg_page(sg)) >= 1 && !PageSlab(sg_page(sg)" part is to
make sure the page can be sent to network layer's zero copy path. This
part is exactly what sendpage_ok() does.

This patch uses  use sendpage_ok() in iscsi_tcp_segment_map() to replace
the original open coded checks.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Chris Leech <cleech@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libiscsi_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 37e5d4e48c2f..83f14b2c8804 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -128,7 +128,7 @@ static void iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
 	 * coalescing neighboring slab objects into a single frag which
 	 * triggers one of hardened usercopy checks.
 	 */
-	if (!recv && page_count(sg_page(sg)) >= 1 && !PageSlab(sg_page(sg)))
+	if (!recv && sendpage_ok(sg_page(sg)))
 		return;
 
 	if (recv) {
-- 
2.26.2

