Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F855370818
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 19:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhEARLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 13:11:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhEARLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 13:11:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619889035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s12A3ulndvd9n5b9y5Eg1lK1Mb35rZyB/H5/Q1rlrn8=;
        b=bmBJhtBe6xC51UQzpD8FM4PJi9aTH9SkVnS7rYVRm+5IgcqVP9ljfENzX1rCLCITsI+5Gh
        DbMv/FNYgueyPhyrlMwRG4uhbkLEsRFPy9ZvGLIRFwaKoRrMTKiMbdH+9VVYOjfUjsSjPr
        ulhmSRFHKmBgCCgEpuW2w82Gmz7hmkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-wkoj-Sa-M5uEgzaTXbwIRg-1; Sat, 01 May 2021 13:10:33 -0400
X-MC-Unique: wkoj-Sa-M5uEgzaTXbwIRg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAD1210060C7;
        Sat,  1 May 2021 17:10:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13ED85C1D1;
        Sat,  1 May 2021 17:10:30 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] lib: bpf_legacy: avoid to pass invalid argument to close()
Date:   Sat,  1 May 2021 19:05:45 +0200
Message-Id: <a401273d9c2e965d11c07cab76016d350b4f0b2c.1619887571.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function bpf_obj_open, if bpf_fetch_prog_arg() return an error, we
end up in the out: path with a negative value for fd, and pass it to
close.

Avoid this checking for fd to be positive.

Fixes: 32e93fb7f66d ("{f,m}_bpf: allow for sharing maps")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf_legacy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 7ec9ce9d..d57d2635 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -2992,7 +2992,7 @@ static int bpf_obj_open(const char *pathname, enum bpf_prog_type type,
 out:
 	bpf_elf_ctx_destroy(ctx, ret < 0);
 	if (ret < 0) {
-		if (fd)
+		if (fd >= 0)
 			close(fd);
 		return ret;
 	}
-- 
2.30.2

