Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4754C4D6F76
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 15:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiCLOM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 09:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiCLOM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 09:12:58 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E075122BEAE;
        Sat, 12 Mar 2022 06:11:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1647094302; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=YT82GrjPQMQs+ToHEYuexgatOtG6lfHiB49oTAG/iN8lyyS9i3D/rvX6QvPevViSrw+8h4yz8qOKLnugD9K0tC4u8Cs1FXKkO4UFa0tqd4xpH6K7oxNClFYD8G2VpLRmrOdvzyKff17J5eO2UdJixfxP77TLTJi4geXmbneoqjk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1647094302; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=foRf6Q34ruu4G2J7eYwRD7qWJ4EOw8UdfJG2RUNajsQ=; 
        b=ZWwbNLVgy2DQcdGej3EeyyBHCT+eYGZRe76PR6BYNf1YQuERdgUiaJ+G5TF6DVM55m3usMGRFkpnx7Ss2S06T4SAa/wrEbrWFaZbP7hXxUJorkZAYneS/yq4JGj2fHUaly7TP8N5trG4+ksJH5U6LnqFpovp6+KRWZ4ITZdrc9Y=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1647094302;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
        bh=foRf6Q34ruu4G2J7eYwRD7qWJ4EOw8UdfJG2RUNajsQ=;
        b=G9wg7mrIog2Y6w/Rzd9UBWSdUXO1BtFFX6PanTUHhPSCviZo5IWrjfm55pCuVw7v
        DtjSsTYCOC3kicgv+awicpYnD+fBDtJGiBemGZYM9XitwuB6uZCLReznkB6Ih4mimEp
        cL5I61HDIh1/78bXirDLoQrJQJyMM43cQRwK0RRY=
Received: from localhost.localdomain (49.207.201.99 [49.207.201.99]) by mx.zohomail.com
        with SMTPS id 1647094300679390.33919287193373; Sat, 12 Mar 2022 06:11:40 -0800 (PST)
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     mail@anirudhrb.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: handle error while adding split ranges to iotlb
Date:   Sat, 12 Mar 2022 19:41:21 +0530
Message-Id: <20220312141121.4981-1-mail@anirudhrb.com>
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

vhost_iotlb_add_range_ctx() handles the range [0, ULONG_MAX] by
splitting it into two ranges and adding them separately. The return
value of adding the first range to the iotlb is currently ignored.
Check the return value and bail out in case of an error.

Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
---
 drivers/vhost/iotlb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 40b098320b2a..5829cf2d0552 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -62,8 +62,12 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
 	 */
 	if (start == 0 && last == ULONG_MAX) {
 		u64 mid = last / 2;
+		int err = vhost_iotlb_add_range_ctx(iotlb, start, mid, addr,
+				perm, opaque);
+
+		if (err)
+			return err;
 
-		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
 		addr += mid + 1;
 		start = mid + 1;
 	}
-- 
2.35.1

