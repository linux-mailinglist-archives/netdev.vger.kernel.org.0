Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862514E1AAC
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 08:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244978AbiCTHqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 03:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbiCTHq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 03:46:29 -0400
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA68BB6;
        Sun, 20 Mar 2022 00:45:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1647762300; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=EDNwVrXEK6Oway1Y2ekLuadKuWPFi4I44XhEaZyHQXnMt2h3ridc6vNPri2vgOzOy2Nt50ux/qDYMCtHeDF1KvuSVulYALVnDxUbM+wkC5hw8UtWTCcZ4OWIK+VWp8CLMU48I+hd1gQoxBwcpV6vrvkNEEGaCFFy0EsKhIvzQC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1647762300; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=w5LyUHJofJCyeKMRiw9YiX9jA/Wm8ilUQt322JAg2Fw=; 
        b=SjKBYcx+1k6Nu3WNqwDNuVa8u6nac4CrkGv9HXeOx8H+wPAgvjWM8ikrE8KdIyfFYZzaSZCgn9Ph16Guzv2g+zPjHZuQ87KPrx/CJPa7zGWppowfaoTeoCkbdrstOXFR6rz1tWBk6jfvulaQm5fOBYW4JeCs1f4u7SPnZczRgE4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1647762300;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
        bh=w5LyUHJofJCyeKMRiw9YiX9jA/Wm8ilUQt322JAg2Fw=;
        b=pZaPNAdbrS0juZd3ejmm6jiH3ppZvGIDxtGR9vjxotKMgPYbaQzc6otg5n17GIVn
        jnpyllYpV2Pm/+07mkHsq0G9qH1NutaJWnCKKUj4l3nfuJS9SFHG1L9CJP1RMHPWtN2
        5wNaWm/1DyDXXHQp5p1whUOhe34j7hCaxpIhshCs=
Received: from localhost.localdomain (49.207.204.88 [49.207.204.88]) by mx.zohomail.com
        with SMTPS id 1647762299802751.4615773189689; Sun, 20 Mar 2022 00:44:59 -0700 (PDT)
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] vhost: handle error while adding split ranges to iotlb
Date:   Sun, 20 Mar 2022 13:14:49 +0530
Message-Id: <20220320074449.4909-1-mail@anirudhrb.com>
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

Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
---

v2:
- Add "Fixes:" tag and "Reviewed-by:".

v1:
https://lore.kernel.org/kvm/20220312141121.4981-1-mail@anirudhrb.com/

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

