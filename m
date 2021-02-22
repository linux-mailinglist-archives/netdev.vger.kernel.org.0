Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D092321F16
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 19:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhBVSWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 13:22:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232362AbhBVSV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 13:21:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614018002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=18wy2qx4bycUMsn6BjZIIZfFYeIEKj+LojFrwoZ5MnE=;
        b=XSF1VyhvEe9c5QhbyfVvMRjZf4F07h7WizlBiYmij17sDHAVj0tn3ihRkfiMQolzMg1HwU
        0eFNYbviRfH3kblPa39d7DT/r+Vk1TXRfCATYjEW53PvhGADuoflh12N6gaMul5VsE4T1u
        gF/LKW3vtMXd/oFSnZnOmv/Olhc9SzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-ARPGZkogMu-VoFgihiu5CA-1; Mon, 22 Feb 2021 13:20:00 -0500
X-MC-Unique: ARPGZkogMu-VoFgihiu5CA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 434F66D4F2;
        Mon, 22 Feb 2021 18:19:58 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-141.ams2.redhat.com [10.36.115.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69CF610016FA;
        Mon, 22 Feb 2021 18:19:57 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 v2 1/2] lib/fs: avoid double call to mkdir on make_path()
Date:   Mon, 22 Feb 2021 19:14:31 +0100
Message-Id: <a25b924220a1a30348f995a4a7eaa8bcea20f862.1614016514.git.aclaudi@redhat.com>
In-Reply-To: <cover.1614016514.git.aclaudi@redhat.com>
References: <cover.1614016514.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make_path() function calls mkdir two times in a row. The first one it
stores mkdir return code, and then it calls it again to check for errno.

This seems unnecessary, as we can use the return code from the first
call and check for errno if not 0.

Fixes: ac3415f5c1b1d ("lib/fs: Fix and simplify make_path()")
Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/fs.c b/lib/fs.c
index 4b90a704..2ae506ec 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -253,7 +253,7 @@ int make_path(const char *path, mode_t mode)
 			*delim = '\0';
 
 		rc = mkdir(dir, mode);
-		if (mkdir(dir, mode) != 0 && errno != EEXIST) {
+		if (rc && errno != EEXIST) {
 			fprintf(stderr, "mkdir failed for %s: %s\n",
 				dir, strerror(errno));
 			goto out;
-- 
2.29.2

