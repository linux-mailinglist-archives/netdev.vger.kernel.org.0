Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D90F6DC826
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 17:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjDJPC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjDJPC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:02:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A884EF2
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 08:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681138902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jvoKw5fddC6ImxYUVWRQGjUNBYWemWpfZTmvE3MZouI=;
        b=jTGiSHrb1Wucrdt8wQ59Ozj5C6fnwcessiL1MDMOzsXnQAYoDkwW62LIFVBrE3pO7J6gvj
        IWBMP7muBjCLGfj03e/oyoRQQdwtO3lxFyapjysFitfD7RPrpkxg6/2ycgYk6DKWRDP9ex
        VpIz+wNuvOkB+2bMyfjXkBY5JxgzDgA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-6Lhfy9nhOkqSBmrUFiGbxQ-1; Mon, 10 Apr 2023 11:01:41 -0400
X-MC-Unique: 6Lhfy9nhOkqSBmrUFiGbxQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3379E1C0513F;
        Mon, 10 Apr 2023 15:01:41 +0000 (UTC)
Received: from server.redhat.com (ovpn-12-107.pek2.redhat.com [10.72.12.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D646314171B7;
        Mon, 10 Apr 2023 15:01:37 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vhost_vdpa: fix unmap process in no-batch mode
Date:   Mon, 10 Apr 2023 23:01:30 +0800
Message-Id: <20230410150130.837691-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While using the no-batch mode, the process will not begin with
VHOST_IOTLB_BATCH_BEGIN, so we need to add the
VHOST_IOTLB_INVALIDATE to get vhost_vdpa_as, the process is the
same as VHOST_IOTLB_UPDATE

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7be9d9d8f01c..32636a02a0ab 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1074,6 +1074,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 		goto unlock;
 
 	if (msg->type == VHOST_IOTLB_UPDATE ||
+	    msg->type == VHOST_IOTLB_INVALIDATE ||
 	    msg->type == VHOST_IOTLB_BATCH_BEGIN) {
 		as = vhost_vdpa_find_alloc_as(v, asid);
 		if (!as) {
-- 
2.34.3

