Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655472CE0E2
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389414AbgLCVhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:37:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389408AbgLCVg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:36:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607031333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OspxR8nxroXzKoAByQKtvrhTzOZb9bKKpD2rIyWg0Bw=;
        b=BByMk8AfHOInUmpC98evpOS21m1Gm5sIyTkYlpO2ufHhNeHWwvsN+QKrOTZ5wfzUfHmgR8
        +XpCQoDv2AtSoNJx+QG3WsOJMJZOjDPBNy9tallrCB6GnM0giqlUBM6/pvc4JcwPAVTxNL
        vKihrvGZHLzKVgSAg6XFvdU3gVkRgss=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-JNpeVbGrOf-aAmMi0mzD1g-1; Thu, 03 Dec 2020 16:35:29 -0500
X-MC-Unique: JNpeVbGrOf-aAmMi0mzD1g-1
Received: by mail-qv1-f72.google.com with SMTP id b15so2817471qvm.10
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 13:35:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OspxR8nxroXzKoAByQKtvrhTzOZb9bKKpD2rIyWg0Bw=;
        b=YWsbPogBhli+3gqNJjHuL07sfgqYIkWkAIScmvcfbSqLRXNYnAPClc4yzkYEyJFITR
         z/TLHKF4B86o5cG3eLvM6lfhmiXWFsDTE6rxRjwmrHvIUYt8EuRWUy0XAayoDgm4Sg17
         /zBX5MeAruHe2mfWI+Ixz9fxmBaFXr+LpQPpAsyEhPzvDSzqjWifwVwrgHDYKy4MRb6i
         XsA9DkQfyWM4w6RwhVFZIeraR+E+AqQelZZnWeRIGKblUPZ1e40xAiVfh2GyO058TIVw
         I5pj/ayVeKFiJ6mdw4nzrmM4y7DKrLahAnYvPnl9WEqqVSS0a5e61PAuk39GACG7uZuA
         yfhw==
X-Gm-Message-State: AOAM531nryuqgmy7tDt/TC+z75uJOzz0vILuOvIfV1drWHsH3jdWH2SM
        PSD07WeJcg+MaTlADtUVUqgBrV3ko7mHoWqVYpOVKdeYPi1Ei/iKcmQ8NEsfRnzb8BgMqR8Ti+E
        sqprEUOAnsRlF8XHI
X-Received: by 2002:a37:4854:: with SMTP id v81mr5204183qka.20.1607031328686;
        Thu, 03 Dec 2020 13:35:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/SJA9fM5UcB2THmOJfZjkHU1sPRMmEkRZN3cfIodhNnsPMKTfttELv6baAorjBowVQySTyw==
X-Received: by 2002:a37:4854:: with SMTP id v81mr5204152qka.20.1607031328232;
        Thu, 03 Dec 2020 13:35:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i3sm2468015qtv.23.2020.12.03.13.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 13:35:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8744B1843EB; Thu,  3 Dec 2020 22:35:21 +0100 (CET)
Subject: [PATCH bpf 4/7] selftests/bpf/test_offload.py: only check verifier
 log on verification fails
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 03 Dec 2020 22:35:21 +0100
Message-ID: <160703132146.162669.15903502405321937636.stgit@toke.dk>
In-Reply-To: <160703131710.162669.9632344967082582016.stgit@toke.dk>
References: <160703131710.162669.9632344967082582016.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Since 6f8a57ccf85 ("bpf: Make verifier log more relevant by default"), the
verifier discards log messages for successfully-verified programs. This
broke test_offload.py which is looking for a verification message from the
driver callback. Change test_offload.py to use the toggle in netdevsim to
make the verification fail before looking for the verification message.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/test_offload.py |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 7afe259c785f..6f8ff2f27027 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -905,11 +905,18 @@ try:
 
     sim.tc_flush_filters()
 
+    start_test("Test TC offloads failure...")
+    sim.dfs["dev/bpf_bind_verifier_accept"] = 0
+    ret, _, err = sim.cls_bpf_add_filter(obj, verbose=True, skip_sw=True,
+                                         fail=False, include_stderr=True)
+    fail(ret == 0, "TC filter did not reject with TC offloads enabled")
+    check_verifier_log(err, "[netdevsim] Hello from netdevsim!")
+    sim.dfs["dev/bpf_bind_verifier_accept"] = 1
+
     start_test("Test TC offloads work...")
     ret, _, err = sim.cls_bpf_add_filter(obj, verbose=True, skip_sw=True,
                                          fail=False, include_stderr=True)
     fail(ret != 0, "TC filter did not load with TC offloads enabled")
-    check_verifier_log(err, "[netdevsim] Hello from netdevsim!")
 
     start_test("Test TC offload basics...")
     dfs = simdev.dfs_get_bound_progs(expected=1)
@@ -1026,6 +1033,15 @@ try:
     rm("/sys/fs/bpf/offload")
     sim.wait_for_flush()
 
+    start_test("Test XDP load failure...")
+    sim.dfs["dev/bpf_bind_verifier_accept"] = 0
+    ret, _, err = bpftool_prog_load("sample_ret0.o", "/sys/fs/bpf/offload",
+                                 dev=sim['ifname'], fail=False, include_stderr=True)
+    fail(ret == 0, "verifier should fail on load")
+    check_verifier_log(err, "[netdevsim] Hello from netdevsim!")
+    sim.dfs["dev/bpf_bind_verifier_accept"] = 1
+    sim.wait_for_flush()
+
     start_test("Test XDP offload...")
     _, _, err = sim.set_xdp(obj, "offload", verbose=True, include_stderr=True)
     ipl = sim.ip_link_show(xdp=True)
@@ -1033,7 +1049,6 @@ try:
     progs = bpftool_prog_list(expected=1)
     prog = progs[0]
     fail(link_xdp["id"] != prog["id"], "Loaded program has wrong ID")
-    check_verifier_log(err, "[netdevsim] Hello from netdevsim!")
 
     start_test("Test XDP offload is device bound...")
     dfs = simdev.dfs_get_bound_progs(expected=1)

