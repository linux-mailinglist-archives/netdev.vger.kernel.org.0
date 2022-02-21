Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2C54BD7A8
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 09:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346482AbiBUHp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 02:45:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346480AbiBUHp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 02:45:28 -0500
X-Greylist: delayed 908 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Feb 2022 23:45:06 PST
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177452BC7
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 23:45:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645428593; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=cSUHjQiTcSwtx64/5MvdEDCDfwEdsQ8DnI4eT/Ru73rZFhj3B8bRQokV/eO156GLXUpY14xz7kFur4N+P+ilLAwJb1VsPjUiaIq9D9w4U5vLP1RqwgxanPWuOplwqWUNW2i6vMly2q/cf/i9sa8uqBluQ4YWDN2ykCO4+mGnxy0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645428593; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=WpclscLdg4+WAoyb8IIA896IqzboZChEQYLndl0uwSU=; 
        b=X6IdzbtzjnkrYMOjOHip8uOnSZEvNfYbyEVRH9Y1xSEcWUxHa3R/RJDZrDl3VWLWpi+XJ0zXL2+ceHLFStjXPU88IPV9Oei6m7sHDmmQ8Z21FMYIIPra4Lu5xMXondzfQhToaV/Wr2+zsuYMKa0K/PxOTr1rrjZcm36wvXkbADI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645428593;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=WpclscLdg4+WAoyb8IIA896IqzboZChEQYLndl0uwSU=;
        b=ytBYL2yKVzoUkxXCq42rN3Pi+CaM1wgx9quhTwRDHdR+QpSx0iQTzyT53JNfZPHS
        +9tDH2tUZL9myKReTohQmKN46nUe4Lf2R57pNiQu7P5lKzLh8oIBMf1TCuDjYCdcXAe
        bXfdS77iT8fKTdV8imIgYJt9ZOl7VJLAH1u8FfoM=
Received: from localhost.localdomain (49.207.207.8 [49.207.207.8]) by mx.zohomail.com
        with SMTPS id 1645428590793991.2120447421995; Sun, 20 Feb 2022 23:29:50 -0800 (PST)
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     mail@anirudhrb.com,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: handle zero regions in vhost_set_memory
Date:   Mon, 21 Feb 2022 12:58:51 +0530
Message-Id: <20220221072852.31820-1-mail@anirudhrb.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return early when userspace sends zero regions in the VHOST_SET_MEM_TABLE
ioctl.

Otherwise, this causes an erroneous entry to be added to the iotlb. This
entry has a range size of 0 (due to u64 overflow). This then causes
iotlb_access_ok() to loop indefinitely resulting in a hung thread.
Syzbot has reported this here:

https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87

Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
---
 drivers/vhost/vhost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..821aba60eac2 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1428,6 +1428,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 		return -EFAULT;
 	if (mem.padding)
 		return -EOPNOTSUPP;
+	if (mem.nregions == 0)
+		return 0;
 	if (mem.nregions > max_mem_regions)
 		return -E2BIG;
 	newmem = kvzalloc(struct_size(newmem, regions, mem.nregions),
-- 
2.35.1

