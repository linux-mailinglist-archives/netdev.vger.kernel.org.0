Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8F94BEB5F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiBUTyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 14:54:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiBUTyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 14:54:05 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2AC22524;
        Mon, 21 Feb 2022 11:53:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645473215; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=i2uxqd3xtw87X6NBDSyiknPYREgcadgmHHcvji5NiI51MdzLmnNQuJxqe+p3hZzhfuDnEwkvhdOgRhs8h4JbzFJ6u9ghjc+rgiJhW9kjUJKwCSafCTZrL+UFPmyYTWDJYDvXtwixlZFxxqnSVEp+wNvF5BbagMDSQ7loxhY4bWk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645473215; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=lFSFFVL8SLXIR92mrUZhGNoAuPBtxVKbdikVGl3YKfU=; 
        b=AJfibCvjpootW3Jg3FkLeRCUBiUeUo9v1fK6V4oN9M89UAeaLcwOg2d2FIlXSNW3EFW3X348dk6+QH3vybcEs7GNKOT4pb2e5ce88Pc3Sl9XY+rg1qBltLlhEg/FzAX5onq+RMAClFvSPOHk+6qRKscArYXwwgAB/mi4byZL8Ds=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645473215;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=lFSFFVL8SLXIR92mrUZhGNoAuPBtxVKbdikVGl3YKfU=;
        b=Pb+srzCXy3pqA07A15JtrS78oNWR4jww/U59XcDfN1f9jmiWGiL14x1yE4S98Zhq
        Aox0SFA7iDTB9YmUg4GO1nt6DAt2SVOZJlwukN2AhCFrpmTXNcRTihbP/Rb/9G+efLF
        Gn1XC1OSQm/Z5/AbYR9NWEVGW8NXoajLO0ien9ak=
Received: from localhost.localdomain (49.207.206.107 [49.207.206.107]) by mx.zohomail.com
        with SMTPS id 1645473211133178.11898385621953; Mon, 21 Feb 2022 11:53:31 -0800 (PST)
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     mail@anirudhrb.com,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: validate range size before adding to iotlb
Date:   Tue, 22 Feb 2022 01:23:03 +0530
Message-Id: <20220221195303.13560-1-mail@anirudhrb.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_iotlb_add_range_ctx(), validate the range size is non-zero
before proceeding with adding it to the iotlb.

Range size can overflow to 0 when start is 0 and last is (2^64 - 1).
One instance where it can happen is when userspace sends an IOTLB
message with iova=size=uaddr=0 (vhost_process_iotlb_msg). So, an
entry with size = 0, start = 0, last = (2^64 - 1) ends up in the
iotlb. Next time a packet is sent, iotlb_access_ok() loops
indefinitely due to that erroneous entry:

	Call Trace:
	 <TASK>
	 iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
	 vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
	 vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
	 vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
	 kthread+0x2e9/0x3a0 kernel/kthread.c:377
	 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
	 </TASK>

Reported by syzbot at:
	https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87

Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
---
 drivers/vhost/iotlb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 670d56c879e5..b9de74bd2f9c 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -53,8 +53,10 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
 			      void *opaque)
 {
 	struct vhost_iotlb_map *map;
+	u64 size = last - start + 1;
 
-	if (last < start)
+	// size can overflow to 0 when start is 0 and last is (2^64 - 1).
+	if (last < start || size == 0)
 		return -EFAULT;
 
 	if (iotlb->limit &&
@@ -69,7 +71,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
 		return -ENOMEM;
 
 	map->start = start;
-	map->size = last - start + 1;
+	map->size = size;
 	map->last = last;
 	map->addr = addr;
 	map->perm = perm;
-- 
2.35.1

