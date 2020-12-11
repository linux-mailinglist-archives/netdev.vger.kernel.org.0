Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34F52D7EE1
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389597AbgLKSzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:55:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389428AbgLKSyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:54:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607712801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qvLV71yDCCqHXyaS6wZyntv25eF4ZCINFLjbVMSSzrc=;
        b=MLaqgi3p7KaDAE14CQUk76h2i/IEkAagrzOn+mjDqhWe0vN96lHOR2lF9LWiP0IMVX+71r
        6POfssiJB8SKvPKoXrsvJtBf/FthvflbE9mWZePFQRpvnC2WDnCLz59AsEmKhDZ8oTHbQY
        w0a7IrkXBnJ+LoEVciIFg7FZmykALdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-BGWJncqKPyWCHHoLEOaeTg-1; Fri, 11 Dec 2020 13:53:18 -0500
X-MC-Unique: BGWJncqKPyWCHHoLEOaeTg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A29B19251A0;
        Fri, 11 Dec 2020 18:53:17 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-11.ams2.redhat.com [10.36.114.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEE1560BE5;
        Fri, 11 Dec 2020 18:53:16 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 1/2] devlink: fix memory leak in cmd_dev_flash()
Date:   Fri, 11 Dec 2020 19:53:02 +0100
Message-Id: <0552db30b97ec8db87d82ef5d6def490510ce6aa.1607712061.git.aclaudi@redhat.com>
In-Reply-To: <cover.1607712061.git.aclaudi@redhat.com>
References: <cover.1607712061.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nlg_ntf is dinamically allocated in mnlg_socket_open(), and is freed on
the out: return path. However, some error paths do not free it,
resulting in memory leak.

This commit fix this using mnlg_socket_close(), and reporting the
correct error number when required.

Fixes: 9b13cddfe268 ("devlink: implement flash status monitoring")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 devlink/devlink.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ca99732e..43549965 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3371,19 +3371,21 @@ static int cmd_dev_flash(struct dl *dl)
 
 	err = _mnlg_socket_group_add(nlg_ntf, DEVLINK_GENL_MCGRP_CONFIG_NAME);
 	if (err)
-		return err;
+		goto err_socket;
 
 	err = pipe(pipe_fds);
-	if (err == -1)
-		return -errno;
+	if (err == -1) {
+		err = -errno;
+		goto err_socket;
+	}
 	pipe_r = pipe_fds[0];
 	pipe_w = pipe_fds[1];
 
 	pid = fork();
 	if (pid == -1) {
-		close(pipe_r);
 		close(pipe_w);
-		return -errno;
+		err = -errno;
+		goto out;
 	} else if (!pid) {
 		/* In child, just execute the flash and pass returned
 		 * value through pipe once it is done.
@@ -3412,6 +3414,7 @@ static int cmd_dev_flash(struct dl *dl)
 	err = _mnlg_socket_recv_run(dl->nlg, NULL, NULL);
 out:
 	close(pipe_r);
+err_socket:
 	mnlg_socket_close(nlg_ntf);
 	return err;
 }
-- 
2.29.2

