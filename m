Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24EC23467C
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 15:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbgGaNDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 09:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgGaNDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 09:03:55 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5A1D21D95;
        Fri, 31 Jul 2020 13:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596200634;
        bh=3z0qF9qVE0qMd2L89zNrwubrAsbrLLrHWz5YA2+PmZo=;
        h=Date:From:To:Cc:Subject:From;
        b=LCVS5cKyn0gb2v85D8I4SsXgThLyDlXiihq++wxzuNKEZu5SsShm33El1sAdVopy0
         V4sJPlc+gp6YUZDVY3R3o94ibmJg32pdmD/scQem0JSsuTRI3ZnCrrC9pmgc7jxjku
         qIk6bxcOyEvpQSWwrDXxwWj9F05XkgE7dxrN5mL0=
Date:   Fri, 31 Jul 2020 08:09:56 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] vhost: Use flex_array_size() helper in copy_from_user()
Message-ID: <20200731130956.GA30525@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the flex_array_size() helper to calculate the size of a
flexible array member within an enclosing structure.

This helper offers defense-in-depth against potential integer
overflows, while at the same time makes it explicitly clear that
we are dealing with a flexible array member.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 74d135ee7e26..1a22a254abe4 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1405,7 +1405,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 
 	memcpy(newmem, &mem, size);
 	if (copy_from_user(newmem->regions, m->regions,
-			   mem.nregions * sizeof *m->regions)) {
+			   flex_array_size(newmem, regions, mem.nregions))) {
 		kvfree(newmem);
 		return -EFAULT;
 	}
-- 
2.27.0

