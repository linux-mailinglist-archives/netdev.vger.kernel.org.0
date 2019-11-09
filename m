Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A82F5C21
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfKIABC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:01:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727731AbfKIABB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:01:01 -0500
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6726F811BD
        for <netdev@vger.kernel.org>; Sat,  9 Nov 2019 00:01:00 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id p25so1590330lji.23
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 16:01:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nbp3QfN0TQNkDe9Q9+yAlcUGzwTWjk7ZLS5MnwIXPgY=;
        b=MCz12p+aQ4v0UWUVUue1fifQMg61i9go7COkM93NjxbfEEclRZI58+BJszDbq7mNry
         9i9Nwj5qP5zbo+a6zK2ta1ow+x4bZC0o93Vagi/Fq1uJqykHNj/GNTI6/aj8OwmJ0sL6
         cpEahmHGlkT6nnSTbEF+8Df2+95SrlR25pHhM1MFXiTM569b5CkEU3PVS0o/mXqZiWg2
         M+tgdxfWM2tkdKVBvE5a8i7guWNmmUak97FNPYqZ5khGKiNGoXCGJwmIL6hk5QoW0SfP
         rv8pwgHwvANMXn5T4Lw9ZiY7Stp+kVqP4JUwTNyzkAo1PzhHzUSGZAQeEDgwZyXJAd12
         HeFg==
X-Gm-Message-State: APjAAAXxNv9M6GTqve9tmWm6B2LtIwC48BgSA8RGU7ffRpm/yhuh6Wsl
        6p5NDQ/vy9cr8bbRX/gMjCEh2vWZRjjZa+9kRTvJdAeu0SrPTaJ4q1/69m96pUDoC/E71PxyKT8
        P7OqU8ROKzi0ly0WS
X-Received: by 2002:a19:c18d:: with SMTP id r135mr860548lff.75.1573257658962;
        Fri, 08 Nov 2019 16:00:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqxDf1KmgoRL4yrpm3DCosTJB86HPeyRGvRNRw2V6JURy8FvjCLASOTjEdpnFwJ84ef+XrJa9A==
X-Received: by 2002:a19:c18d:: with SMTP id r135mr860537lff.75.1573257658807;
        Fri, 08 Nov 2019 16:00:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id l82sm5216038lfd.81.2019.11.08.16.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 16:00:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E98D01800CC; Sat,  9 Nov 2019 01:00:56 +0100 (CET)
Subject: [PATCH bpf-next v3 2/6] selftests/bpf: Add tests for automatic map
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
Date:   Sat, 09 Nov 2019 01:00:56 +0100
Message-ID: <157325765687.27401.1792577441648065280.stgit@toke.dk>
In-Reply-To: <157325765467.27401.1930972466188738545.stgit@toke.dk>
References: <157325765467.27401.1930972466188738545.stgit@toke.dk>
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Song Liu <songliubraving@fb.com>
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

