Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6141E1279
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgEYQQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:16:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726514AbgEYQQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 12:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590423381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rT4eP6mLqLtUhR/uGSDEBhfpcmkWKNCZeUPJ402mAyM=;
        b=FFatyFF2A2wTgpGzTjB/T7jnBTjzM1DTm1uHRGMa7BU626oxkGCwIjxbLt93PIQFgLqRc1
        oNmInAii1rqlvUWC4MNxIupLVDcCs9z+fxV+R6S06wicjVeJB3wbPxcmEacTrSePKHwx75
        olkSIuR0g4s/ojubGZqY0oSru8spe58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-zgFduTI5P82EJX1ZKLs6lQ-1; Mon, 25 May 2020 12:16:17 -0400
X-MC-Unique: zgFduTI5P82EJX1ZKLs6lQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC590460;
        Mon, 25 May 2020 16:16:15 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-112-147.ams2.redhat.com [10.36.112.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4CB05C1BB;
        Mon, 25 May 2020 16:16:10 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next] libbpf: add API to consume the perf ring buffer content
Date:   Mon, 25 May 2020 18:15:38 +0200
Message-Id: <159042332675.79900.6845937535091126683.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new API, perf_buffer__consume, can be used as follows:
- When you have a perf ring where wakeup_events is higher than 1,
  and you have remaining data in the rings you would like to pull
  out on exit (or maybe based on a timeout).
- For low latency cases where you burn a CPU that constantly polls
  the queues.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 tools/lib/bpf/libbpf.c   |   23 +++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |    1 +
 tools/lib/bpf/libbpf.map |    1 +
 3 files changed, 25 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fa04cbe547ed..cbef3dac7507 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8456,6 +8456,29 @@ int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)
 	return cnt < 0 ? -errno : cnt;
 }
 
+int perf_buffer__consume(struct perf_buffer *pb)
+{
+	int i;
+
+	if (!pb)
+		return -EINVAL;
+
+	if (!pb->cpu_bufs)
+		return 0;
+
+	for (i = 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) {
+		int err;
+		struct perf_cpu_buf *cpu_buf = pb->cpu_bufs[i];
+
+		err = perf_buffer__process_records(pb, cpu_buf);
+		if (err) {
+			pr_warn("error while processing records: %d\n", err);
+			return err;
+		}
+	}
+	return 0;
+}
+
 struct bpf_prog_info_array_desc {
 	int	array_offset;	/* e.g. offset of jited_prog_insns */
 	int	count_offset;	/* e.g. offset of jited_prog_len */
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 8ea69558f0a8..1e2e399a5f2c 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -533,6 +533,7 @@ perf_buffer__new_raw(int map_fd, size_t page_cnt,
 
 LIBBPF_API void perf_buffer__free(struct perf_buffer *pb);
 LIBBPF_API int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms);
+LIBBPF_API int perf_buffer__consume(struct perf_buffer *pb);
 
 typedef enum bpf_perf_event_ret
 	(*bpf_perf_event_print_t)(struct perf_event_header *hdr,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 0133d469d30b..381a7342ecfc 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -262,4 +262,5 @@ LIBBPF_0.0.9 {
 		bpf_link_get_fd_by_id;
 		bpf_link_get_next_id;
 		bpf_program__attach_iter;
+		perf_buffer__consume;
 } LIBBPF_0.0.8;

