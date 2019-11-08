Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FB9F59F1
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbfKHVdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:33:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732137AbfKHVdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 16:33:11 -0500
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 395764DB1F
        for <netdev@vger.kernel.org>; Fri,  8 Nov 2019 21:33:10 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id w24so1549116lfa.11
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=coY7ll6zI9iYn6/3XVcHoVcsUowxThFI2UGP9S+O/jc=;
        b=c+7O8cOf+Fev7Ao7zoPHNrgaUiEXeM6o1hm1bqTJF9ij3PUHNu8AP0axz1MzRGVd/J
         Q8vDlMe6DeDrWJf9rnszWc055tE/8kk7zU54kE4KL8NGepg/r2Q1t4frlNA3m0cCWSPS
         0a+HdEKYvbVxGuPjwyJZk5bmg1QMmkkDE0T3tVR4laE/CIrHiO4Bo2t4m0SpznqXmcCe
         Et2p2dqz3XZOkc0n+USr8eCOWxk+acnlLunaDhXdMONp8RTS+xQt/vgm7UWFsFsgaAfO
         ZW9vwHILh3qv3hHkTlC9iakDm5Wvy6/+K598Ikahp/2ydla7gBpjCMCY9zJKxO9Q6gpA
         pSww==
X-Gm-Message-State: APjAAAXUpof4F+Yd0X2uCEgOUr6tXeBvtY74yw+uiPFy26KOUDA6cYFw
        RMBJEq7QDQd8o6UZBUksHSF4YGMa1tkeaAf16uza3aR4yeVz1eHd5feEcpXLcthbNJGCi34bzO7
        cSzUe3FLrycYBW3N6
X-Received: by 2002:ac2:51c5:: with SMTP id u5mr8174917lfm.154.1573248788775;
        Fri, 08 Nov 2019 13:33:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqzyvHDP0efgof/jZJ2h6EkcDKkWKmHCdHOUs+1eGf8DMuVoc4vo/yLq0eHMxx+YHrTB9wijNA==
X-Received: by 2002:ac2:51c5:: with SMTP id u5mr8174901lfm.154.1573248788622;
        Fri, 08 Nov 2019 13:33:08 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id c14sm2964566ljd.3.2019.11.08.13.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:33:08 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A7901800BD; Fri,  8 Nov 2019 22:33:07 +0100 (CET)
Subject: [PATCH bpf-next v2 2/6] selftests/bpf: Add tests for automatic map
 unpinning on load failure
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 08 Nov 2019 22:33:07 +0100
Message-ID: <157324878734.910124.13947548477668878554.stgit@toke.dk>
In-Reply-To: <157324878503.910124.12936814523952521484.stgit@toke.dk>
References: <157324878503.910124.12936814523952521484.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This add tests for the different variations of automatic map unpinning on
load failure.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/pinning.c |   20 +++++++++++++++++---
 tools/testing/selftests/bpf/progs/test_pinning.c |    2 +-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testing/selftests/bpf/prog_tests/pinning.c
index 525388971e08..041952524c55 100644
--- a/tools/testing/selftests/bpf/prog_tests/pinning.c
+++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
@@ -163,12 +163,15 @@ void test_pinning(void)
 		goto out;
 	}
 
-	/* swap pin paths of the two maps */
+	/* set pin paths so that nopinmap2 will attempt to reuse the map at
+	 * pinpath (which will fail), but not before pinmap has already been
+	 * reused
+	 */
 	bpf_object__for_each_map(map, obj) {
 		if (!strcmp(bpf_map__name(map), "nopinmap"))
+			err = bpf_map__set_pin_path(map, nopinpath2);
+		else if (!strcmp(bpf_map__name(map), "nopinmap2"))
 			err = bpf_map__set_pin_path(map, pinpath);
-		else if (!strcmp(bpf_map__name(map), "pinmap"))
-			err = bpf_map__set_pin_path(map, NULL);
 		else
 			continue;
 
@@ -181,6 +184,17 @@ void test_pinning(void)
 	if (CHECK(err != -EINVAL, "param mismatch load", "err %d errno %d\n", err, errno))
 		goto out;
 
+	/* nopinmap2 should have been pinned and cleaned up again */
+	err = stat(nopinpath2, &statbuf);
+	if (CHECK(!err || errno != ENOENT, "stat nopinpath2",
+		  "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* pinmap should still be there */
+	err = stat(pinpath, &statbuf);
+	if (CHECK(err, "stat pinpath", "err %d errno %d\n", err, errno))
+		goto out;
+
 	bpf_object__close(obj);
 
 	/* test auto-pinning at custom path with open opt */
diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/testing/selftests/bpf/progs/test_pinning.c
index f69a4a50d056..f20e7e00373f 100644
--- a/tools/testing/selftests/bpf/progs/test_pinning.c
+++ b/tools/testing/selftests/bpf/progs/test_pinning.c
@@ -21,7 +21,7 @@ struct {
 } nopinmap SEC(".maps");
 
 struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(type, BPF_MAP_TYPE_HASH);
 	__uint(max_entries, 1);
 	__type(key, __u32);
 	__type(value, __u64);

