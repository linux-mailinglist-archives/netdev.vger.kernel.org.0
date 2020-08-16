Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C612824564D
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 09:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgHPHIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 03:08:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:58280 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730164AbgHPHIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 03:08:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B4F58B182;
        Sun, 16 Aug 2020 07:08:58 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH v5 3/3] drbd: code cleanup by using sendpage_ok() to check page for kernel_sendpage()
Date:   Sun, 16 Aug 2020 15:08:14 +0800
Message-Id: <20200816070814.6806-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200816070814.6806-1-colyli@suse.de>
References: <20200816070814.6806-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In _drbd_send_page() a page is checked by following code before sending
it by kernel_sendpage(),
        (page_count(page) < 1) || PageSlab(page)
If the check is true, this page won't be send by kernel_sendpage() and
handled by sock_no_sendpage().

This kind of check is exactly what macro sendpage_ok() does, which is
introduced into include/linux/net.h to solve a similar send page issue
in nvme-tcp code.

This patch uses macro sendpage_ok() to replace the open coded checks to
page type and refcount in _drbd_send_page(), as a code cleanup.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index cb687ccdbd96..55dc0c91781e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1553,7 +1553,7 @@ static int _drbd_send_page(struct drbd_peer_device *peer_device, struct page *pa
 	 * put_page(); and would cause either a VM_BUG directly, or
 	 * __page_cache_release a page that would actually still be referenced
 	 * by someone, leading to some obscure delayed Oops somewhere else. */
-	if (drbd_disable_sendpage || (page_count(page) < 1) || PageSlab(page))
+	if (drbd_disable_sendpage || !sendpage_ok(page))
 		return _drbd_no_send_page(peer_device, page, offset, size, msg_flags);
 
 	msg_flags |= MSG_NOSIGNAL;
-- 
2.26.2

