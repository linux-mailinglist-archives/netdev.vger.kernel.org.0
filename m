Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0C0252B41
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 12:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgHZKTB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Aug 2020 06:19:01 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:23116 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727884AbgHZKS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 06:18:59 -0400
X-Greylist: delayed 53829 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2020 06:18:59 EDT
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-axKnq8jwPNyk4FK5q1gRMw-1; Wed, 26 Aug 2020 06:18:54 -0400
X-MC-Unique: axKnq8jwPNyk4FK5q1gRMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BB20807332;
        Wed, 26 Aug 2020 10:18:52 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3960F1992F;
        Wed, 26 Aug 2020 10:18:46 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix open call in trigger_fstat_events
Date:   Wed, 26 Aug 2020 12:18:45 +0200
Message-Id: <20200826101845.747617-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei reported compile breakage on newer systems with
following error:

  In file included from /usr/include/fcntl.h:290:0,
  4814                 from ./test_progs.h:29,
  4815                 from
  .../bpf-next/tools/testing/selftests/bpf/prog_tests/d_path.c:3:
  4816In function ‘open’,
  4817    inlined from ‘trigger_fstat_events’ at
  .../bpf-next/tools/testing/selftests/bpf/prog_tests/d_path.c:50:10,
  4818    inlined from ‘test_d_path’ at
  .../bpf-next/tools/testing/selftests/bpf/prog_tests/d_path.c:119:6:
  4819/usr/include/x86_64-linux-gnu/bits/fcntl2.h:50:4: error: call to
  ‘__open_missing_mode’ declared with attribute error: open with O_CREAT
  or O_TMPFILE in second argument needs 3 arguments
  4820    __open_missing_mode ();
  4821    ^~~~~~~~~~~~~~~~~~~~~~

We're missing permission bits as 3rd argument
for open call with O_CREAT flag specified.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Fixes: e4d1af4b16f8 ("selftests/bpf: Add test for d_path helper")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/d_path.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
index 058765da17e6..43ffbeacd680 100644
--- a/tools/testing/selftests/bpf/prog_tests/d_path.c
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -47,7 +47,7 @@ static int trigger_fstat_events(pid_t pid)
 	devfd = open("/dev/urandom", O_RDONLY);
 	if (CHECK(devfd < 0, "trigger", "open /dev/urandom failed\n"))
 		goto out_close;
-	localfd = open("/tmp/d_path_loadgen.txt", O_CREAT | O_RDONLY);
+	localfd = open("/tmp/d_path_loadgen.txt", O_CREAT | O_RDONLY, 0644);
 	if (CHECK(localfd < 0, "trigger", "open /tmp/d_path_loadgen.txt failed\n"))
 		goto out_close;
 	/* bpf_d_path will return path with (deleted) */
-- 
2.25.4

