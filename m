Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7212F1E3C4F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388151AbgE0ImQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 04:42:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52986 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387929AbgE0ImP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 04:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590568934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cRnUD5oK5sLVCVcFqnFWAetwGl+ORfvUve2vTyNoLZU=;
        b=iugJLkCLdgmtEK9JYJkt9PEVEKIfQCO9pgbcMXqyBtyyawlFSIZJmnSwIIxo3So6E9jUfk
        YTyjph1n2/JJwE1/a2Ze3kmf6TcIFb6BqIeGi/3Z8a9+CoRt2qOszS5ugHlQeyeFS/dhip
        3ok9fnf98uHMVTIgUSfSeTYuzo5+mZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284--Y7aSUawNriOQ3BKB4PO7g-1; Wed, 27 May 2020 04:42:10 -0400
X-MC-Unique: -Y7aSUawNriOQ3BKB4PO7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 195D8107ACF3;
        Wed, 27 May 2020 08:42:09 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-112-147.ams2.redhat.com [10.36.112.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 615E35D9E5;
        Wed, 27 May 2020 08:42:04 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next] libbpf: fix perf_buffer__free() API for sparse allocs
Date:   Wed, 27 May 2020 10:42:00 +0200
Message-Id: <159056888305.330763.9684536967379110349.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the cpu_bufs are sparsely allocated they are not
all free'ed. These changes will fix this.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 tools/lib/bpf/libbpf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5d60de6fd818..74d967619dcf 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8137,9 +8137,12 @@ void perf_buffer__free(struct perf_buffer *pb)
 	if (!pb)
 		return;
 	if (pb->cpu_bufs) {
-		for (i = 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) {
+		for (i = 0; i < pb->cpu_cnt; i++) {
 			struct perf_cpu_buf *cpu_buf = pb->cpu_bufs[i];
 
+			if (!cpu_buf)
+				continue;
+
 			bpf_map_delete_elem(pb->map_fd, &cpu_buf->map_key);
 			perf_buffer__free_cpu_buf(pb, cpu_buf);
 		}

