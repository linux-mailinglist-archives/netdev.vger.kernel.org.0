Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B804130C4
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 11:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhIUJfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 05:35:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229894AbhIUJfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 05:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632216811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nIXica0wGY2gM8wMYByd+RKPWrF91LuVNWciBUEYPUs=;
        b=R4MwkniBaNawZg4XDhLyBTQ1j7JuKaM6KMjspgLqEu7M1z9JiVLTx//z3ThcP912c0ChqX
        gdnYQenFpCWUL5GTp+SrLW2cqlf4Y7EPzYnMlvfUcAB5b3lekZGp9QP+yWPTOcs5YS6MqL
        4RFoBY0R6eNfy1u2H4Afyc3Klr7U49M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-lCqYx6eiM1qYWHmhOlVVnA-1; Tue, 21 Sep 2021 05:33:30 -0400
X-MC-Unique: lCqYx6eiM1qYWHmhOlVVnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3F1CA40C2;
        Tue, 21 Sep 2021 09:33:28 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.193.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6156E10074E5;
        Tue, 21 Sep 2021 09:33:27 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] lib: bpf_legacy: fix bpffs mount when /sys/fs/bpf exists
Date:   Tue, 21 Sep 2021 11:33:24 +0200
Message-Id: <617d61727a8c73fd28a1eb4136f8159f7f6779d9.1632216695.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf selftests using iproute2 fails with:

$ ip link set dev veth0 xdp object ../bpf/xdp_dummy.o section xdp_dummy
Continuing without mounted eBPF fs. Too old kernel?
mkdir (null)/globals failed: No such file or directory
Unable to load program

This happens when the /sys/fs/bpf directory exists. In this case, mkdir
in bpf_mnt_check_target() fails with errno == EEXIST, and the function
returns -1. Thus bpf_get_work_dir() does not call bpf_mnt_fs() and the
bpffs is not mounted.

Fix this in bpf_mnt_check_target(), returning 0 when the mountpoint
exists.

Fixes: d4fcdbbec9df ("lib/bpf: Fix and simplify bpf_mnt_check_target()")
Reported-by: Mingyu Shi <mshi@redhat.com>
Reported-by: Jiri Benc <jbenc@redhat.com>
Suggested-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf_legacy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 91086aa2..275941dd 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -513,9 +513,12 @@ static int bpf_mnt_check_target(const char *target)
 	int ret;
 
 	ret = mkdir(target, S_IRWXU);
-	if (ret && errno != EEXIST)
+	if (ret) {
+		if (errno == EEXIST)
+			return 0;
 		fprintf(stderr, "mkdir %s failed: %s\n", target,
 			strerror(errno));
+	}
 
 	return ret;
 }
-- 
2.31.1

