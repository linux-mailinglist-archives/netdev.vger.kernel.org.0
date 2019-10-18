Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9DDBEA7
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 09:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504655AbfJRHpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 03:45:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:34224 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392304AbfJRHpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 03:45:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C8E74B6D9;
        Fri, 18 Oct 2019 07:45:51 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: [PATCH] xen/netback: fix error path of xenvif_connect_data()
Date:   Fri, 18 Oct 2019 09:45:49 +0200
Message-Id: <20191018074549.4778-1-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xenvif_connect_data() calls module_put() in case of error. This is
wrong as there is no related module_get().

Remove the superfluous module_put().

Fixes: 279f438e36c0a7 ("xen-netback: Don't destroy the netdev until the vif is shut down")
Cc: <stable@vger.kernel.org> # 3.12
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 drivers/net/xen-netback/interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 240f762b3749..103ed00775eb 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -719,7 +719,6 @@ int xenvif_connect_data(struct xenvif_queue *queue,
 	xenvif_unmap_frontend_data_rings(queue);
 	netif_napi_del(&queue->napi);
 err:
-	module_put(THIS_MODULE);
 	return err;
 }
 
-- 
2.16.4

