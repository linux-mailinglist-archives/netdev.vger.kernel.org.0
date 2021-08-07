Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767393E3660
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 18:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhHGQ7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 12:59:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229437AbhHGQ6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 12:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628355478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Hk7Q60Xv+3Mi+jpEFJB0CZjZJXKw/yGbpka2EoiVBVA=;
        b=PkYVRtgzCwlMguHhBuj4vYD2WViV8dk4dfWStcwR/7UEN8xiP9zg5n09hAwXRlj/4G6wYt
        uZd+Nmfk4eFa/r7iRQSNyjLH4Vw3mG/WUNUB2yvOMtIMJldr4eb5ewUgbzyiS0QW7bSgEu
        CWMq6ZjrOIhIXUpIYrAucKBZJPGurO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-Joq3p6GdMLegJR6qVEqCSQ-1; Sat, 07 Aug 2021 12:57:56 -0400
X-MC-Unique: Joq3p6GdMLegJR6qVEqCSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FFAC80196C;
        Sat,  7 Aug 2021 16:57:55 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEB795D9FC;
        Sat,  7 Aug 2021 16:57:53 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, haliu@redhat.com
Subject: [PATCH iproute2] lib: bpf_legacy: fix potential NULL-pointer dereference
Date:   Sat,  7 Aug 2021 18:57:38 +0200
Message-Id: <4dda3f4c193e1da7ac77ee50860111243cd63065.1628352013.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bpf_map_fetch_name() returns NULL, strlen() hits a NULL-pointer
dereference on outer_map_name.

Fix this checking outer_map_name value, and returning false when NULL,
as already done for inner_map_name before.

Fixes: 6d61a2b55799 ("lib: add libbpf support")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf_legacy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index d57d2635..372bcecc 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -3298,6 +3298,9 @@ bool iproute2_is_map_in_map(const char *libbpf_map_name, struct bpf_elf_map *ima
 
 			*omap = ctx->maps[j];
 			outer_map_name = bpf_map_fetch_name(ctx, j);
+			if (!outer_map_name)
+				return false;
+
 			memcpy(omap_name, outer_map_name, strlen(outer_map_name) + 1);
 
 			return true;
-- 
2.31.1

