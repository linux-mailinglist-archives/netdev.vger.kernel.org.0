Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440D0364543
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240158AbhDSNvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:51:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233578AbhDSNvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618840231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C0BZdpt0oK5ikaICQVVGtlJo/fuVplTsrY7hRU4hCvY=;
        b=HIO/NORoHoU7Gl/0d6GP9y2XpuJ+nhPptxOufICi9boNHgHKxgdNAN+kR6jH7gX0JgYmKq
        yzqhQuUoafIYy/oouL7gp4rb/LvGyLZN3yxHruIxkNTEeUtOFnK/XD5UqPMLOWxl9sflII
        FJhLuiKwSuLbzCOmvjrpJi6GlpSUiaI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-JjEwq0VbMs2kLxzHQ5mxKA-1; Mon, 19 Apr 2021 09:50:29 -0400
X-MC-Unique: JjEwq0VbMs2kLxzHQ5mxKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF453107ACCD;
        Mon, 19 Apr 2021 13:50:28 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0846339A71;
        Mon, 19 Apr 2021 13:50:27 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 1/2] lib: bpf_legacy: treat 0 as a valid file descriptor
Date:   Mon, 19 Apr 2021 15:49:56 +0200
Message-Id: <687987edcaa38f7b069a922b45e696a929e387b5.1618839527.git.aclaudi@redhat.com>
In-Reply-To: <cover.1618839527.git.aclaudi@redhat.com>
References: <cover.1618839527.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in the man page(), open returns a non-negative integer as a
file descriptor. Hence, when checking for its return value to be ok, we
should include 0 as a valid value.

This fixes a covscan warning about a missing close() in this function.

Fixes: ecb05c0f997d ("bpf: improve error reporting around tail calls")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf_legacy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 8a03b9c2..7ff10e4f 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -2832,7 +2832,7 @@ static void bpf_get_cfg(struct bpf_elf_ctx *ctx)
 	int fd;
 
 	fd = open(path_jit, O_RDONLY);
-	if (fd > 0) {
+	if (fd >= 0) {
 		char tmp[16] = {};
 
 		if (read(fd, tmp, sizeof(tmp)) > 0)
-- 
2.30.2

