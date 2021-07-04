Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849743BAE8F
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhGDTF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhGDTFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:52 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5D7C061762;
        Sun,  4 Jul 2021 12:03:16 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id m18-20020a9d4c920000b029048b4f23a9bcso4041317otf.9;
        Sun, 04 Jul 2021 12:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ckpdrqt13tBSLzVYkB/qaspnR99MziefuE2IP8ZxPfc=;
        b=HbEyUg3N7IQi2dyZH/hX3yxKHiANG6JW7/y0ojGsdEvM7a1YRR80paPTY+f63FWb7S
         s2nGrv4uL0lrbkSFbilRdGZ/gZTVGttBdb0H6t+PzgrCnTkCSQ6fczkJjuumrnbYb1+g
         lqfoNoxNZxqjlD0SmOEF+zwBrgMR4jlaAy9qEYhCFqKNdIbOUsxcgrEZWfKudSKmiMCY
         q63iJraTwUrQ5BhAts37d+5OBpqCJ1UkzPaxcQ1ikUDgtr0h6a9RMauPGSAOnzirTD3k
         zW4Ak/sSYNRSme5NFtMjDNjF2e/+XV5yONNtNgvxnCeP9GuKmMRba8e1XRoL3rVlM6FX
         Y2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ckpdrqt13tBSLzVYkB/qaspnR99MziefuE2IP8ZxPfc=;
        b=jDoJgZhDmSHDnSXkyqLwprWLQgvX4pKYen/NT10SSN2NeOhKDgD4pg/pt2NL+QQLVu
         4Z6m0GIiXMEe4lrlEnBCvpLmCR+1gKUwozwv+JJgVmzcO3YHGYBiCF6yPdOWjq0/6U+7
         dEGkUxzz/b5gs8Bi8pfzPk/2gL/ij/hyy1CDWm4RZJiD/2s9TzPtXPTiShjVoNHR28VT
         4kM4BDvNPxGoF2+zEsoxVuE8UrzhPfuTddRGdg1IEoprwsf/fpwTLRjm6C5Rb+cpGhnQ
         0QA0k9Jrc4vOfTnsxZ7Rj0YsRmdwJ0bDmjQi86+QS5ImrEIpTtXt55lS1U24R2QPggSq
         Rmjw==
X-Gm-Message-State: AOAM531BQO3JojfL3fJHiipHAqzfdwSMBKUG8DZlIs5gXWvd4KbK7+ge
        hcDCxHSSHSFrMQofMHfaHrY7QfLbpW8=
X-Google-Smtp-Source: ABdhPJxfiwfoGhCWF53TjYKm5yafIgwpmbNWGOBDnYIP7OIeuQI4Z8gRW5US9ijUXBEkjU2R4omZwg==
X-Received: by 2002:a9d:77d4:: with SMTP id w20mr3048042otl.84.1625425395414;
        Sun, 04 Jul 2021 12:03:15 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 09/11] selftests/bpf: factor out add_to_sockmap()
Date:   Sun,  4 Jul 2021 12:02:50 -0700
Message-Id: <20210704190252.11866-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Factor out a common helper add_to_sockmap() which adds two
sockets into a sockmap.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 59 +++++++------------
 1 file changed, 21 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 52d11959e05b..a023a824af78 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -921,6 +921,23 @@ static const char *redir_mode_str(enum redir_mode mode)
 	}
 }
 
+static int add_to_sockmap(int sock_mapfd, int fd1, int fd2)
+{
+	u64 value;
+	u32 key;
+	int err;
+
+	key = 0;
+	value = fd1;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		return err;
+
+	key = 1;
+	value = fd2;
+	return xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+}
+
 static void redir_to_connected(int family, int sotype, int sock_mapfd,
 			       int verd_mapfd, enum redir_mode mode)
 {
@@ -930,7 +947,6 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	unsigned int pass;
 	socklen_t len;
 	int err, n;
-	u64 value;
 	u32 key;
 	char b;
 
@@ -967,15 +983,7 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (p1 < 0)
 		goto close_cli1;
 
-	key = 0;
-	value = p0;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-	if (err)
-		goto close_peer1;
-
-	key = 1;
-	value = p1;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	err = add_to_sockmap(sock_mapfd, p0, p1);
 	if (err)
 		goto close_peer1;
 
@@ -1063,7 +1071,6 @@ static void redir_to_listening(int family, int sotype, int sock_mapfd,
 	int s, c, p, err, n;
 	unsigned int drop;
 	socklen_t len;
-	u64 value;
 	u32 key;
 
 	zero_verdict_count(verd_mapfd);
@@ -1088,15 +1095,7 @@ static void redir_to_listening(int family, int sotype, int sock_mapfd,
 	if (p < 0)
 		goto close_cli;
 
-	key = 0;
-	value = s;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-	if (err)
-		goto close_peer;
-
-	key = 1;
-	value = p;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	err = add_to_sockmap(sock_mapfd, s, p);
 	if (err)
 		goto close_peer;
 
@@ -1348,7 +1347,6 @@ static void test_reuseport_mixed_groups(int family, int sotype, int sock_map,
 	int s1, s2, c, err;
 	unsigned int drop;
 	socklen_t len;
-	u64 value;
 	u32 key;
 
 	zero_verdict_count(verd_map);
@@ -1362,16 +1360,10 @@ static void test_reuseport_mixed_groups(int family, int sotype, int sock_map,
 	if (s2 < 0)
 		goto close_srv1;
 
-	key = 0;
-	value = s1;
-	err = xbpf_map_update_elem(sock_map, &key, &value, BPF_NOEXIST);
+	err = add_to_sockmap(sock_map, s1, s2);
 	if (err)
 		goto close_srv2;
 
-	key = 1;
-	value = s2;
-	err = xbpf_map_update_elem(sock_map, &key, &value, BPF_NOEXIST);
-
 	/* Connect to s2, reuseport BPF selects s1 via sock_map[0] */
 	len = sizeof(addr);
 	err = xgetsockname(s2, sockaddr(&addr), &len);
@@ -1655,7 +1647,6 @@ static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
 	unsigned int pass;
 	int retries = 100;
 	int err, n;
-	u64 value;
 	u32 key;
 	char b;
 
@@ -1668,15 +1659,7 @@ static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
 	if (err)
 		goto close_cli0;
 
-	key = 0;
-	value = p0;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-	if (err)
-		goto close_cli1;
-
-	key = 1;
-	value = p1;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	err = add_to_sockmap(sock_mapfd, p0, p1);
 	if (err)
 		goto close_cli1;
 
-- 
2.27.0

