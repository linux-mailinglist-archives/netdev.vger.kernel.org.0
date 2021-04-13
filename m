Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885A735E942
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348663AbhDMWv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:51:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347665AbhDMWvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618354265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t2yCbZd9a7J+xhCtjAT5W+hNV7TTd8Rh1tZRsO5wbpg=;
        b=MLlB+9+6hJh1aydIoVtsWeygzPGm62w6zH12GsROtEX0xCCxMN+kPkzvfZivVnmF3M8iMG
        xSw5cCIuyI+6mMy1Ke9oNF2bvdAnMyCQPRnFX7248j/Ka63EjAEdIgpklPEc2Jb6HYzi2H
        ba1quVyGEt4jAjGIvrV5s7EGHIMvuWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-FE4XBxjnNCuJGauMDZKzjg-1; Tue, 13 Apr 2021 18:51:03 -0400
X-MC-Unique: FE4XBxjnNCuJGauMDZKzjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A8AE107ACCA;
        Tue, 13 Apr 2021 22:51:02 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-135.ams2.redhat.com [10.36.112.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A34318A69;
        Tue, 13 Apr 2021 22:51:01 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] rdma: stat: initialize ret in stat_qp_show_parse_cb()
Date:   Wed, 14 Apr 2021 00:50:57 +0200
Message-Id: <2b6d2d8c4fdcf53baea43c9fbe9f929d99257809.1618350667.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the unlikely case in which the mnl_attr_for_each_nested() cycle is
not executed, this function return an uninitialized value.

Fix this initializing ret to 0.

Fixes: 5937552b42e4 ("rdma: Add "stat qp show" support")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 rdma/stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/stat.c b/rdma/stat.c
index 75d45288..3abedae7 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -307,7 +307,7 @@ static int stat_qp_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 	struct rd *rd = data;
 	const char *name;
 	uint32_t idx;
-	int ret;
+	int ret = 0;
 
 	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
 	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
-- 
2.30.2

