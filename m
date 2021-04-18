Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069DC36355F
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 15:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhDRNCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 09:02:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230501AbhDRNCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 09:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618750891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dqS94jid2Od8hm+8zLcsYwsBBQgtAKW7meYmwudtRQQ=;
        b=hh9/Zl8WV7DxnYKegKYAXcL0x1UtblPtRbPJwLkP7ac+aw8mQ5f+WpwU/nKTQ4W5v4Lq0Z
        s2EtUYrM6P2S/2bMliaUdS8jbszO7gnpSSEYOyIx+lWbqD+5HEXDYml4s5gavJtslznQcL
        BjEjDleTutEmLXQ7a58F0EMTmRtjLLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-nf46U1pGMoirYvO_gBZcUA-1; Sun, 18 Apr 2021 09:01:24 -0400
X-MC-Unique: nf46U1pGMoirYvO_gBZcUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B80410054F6;
        Sun, 18 Apr 2021 13:01:23 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-53.ams2.redhat.com [10.36.112.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 185BD5D74B;
        Sun, 18 Apr 2021 13:01:21 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, leon@kernel.org
Subject: [PATCH iproute2] rdma: stat: fix return code
Date:   Sun, 18 Apr 2021 14:56:30 +0200
Message-Id: <9cc2c9bdb7bf7c235bf2e7a63b9e13b0cdae58c5.1618750205.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libmnl defines MNL_CB_OK as 1 and MNL_CB_ERROR as -1. rdma uses these
return codes, and stat_qp_show_parse_cb() should do the same.

Fixes: 16ce4d23661a ("rdma: stat: initialize ret in stat_qp_show_parse_cb()")
Reported-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 rdma/stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/stat.c b/rdma/stat.c
index 3abedae7..8edf7bf1 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -307,7 +307,7 @@ static int stat_qp_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 	struct rd *rd = data;
 	const char *name;
 	uint32_t idx;
-	int ret = 0;
+	int ret = MNL_CB_OK;
 
 	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
 	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
-- 
2.30.2

