Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C6B30D292
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhBCEVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhBCETA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:19:00 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FD3C061354;
        Tue,  2 Feb 2021 20:17:23 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id m13so25343114oig.8;
        Tue, 02 Feb 2021 20:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5XzKRAnIzM4OkR+o5IUQ3F91LoQlv8ZVaHR4VoSR6KY=;
        b=hBXMpXnvsYlkaXFEnxrF05njhzROvSlnxq9SXuaAGIBTF6MzOCO3s5MO6O+kE2ZUgF
         9I1+dAVFnrbcWOU51fPWZJCP6k7/0/rHdRKcrcXH9Jla9R2/aMq0h8xK5jPOC/vBfHl8
         hY+rZF0z+as5mpUFdC37Y+jThj18GAPmUoWsCkrmq099JJj/GjKCbfemXfPR72p2eiGQ
         hxgpXV4W5CPYiFfl3ePsBi1PWW8BWivxxC0H3GiHayBB+ByaJtiyUmi7w7TqRzm/0DO1
         j39ajrceRln0M1sLYlStpqH4nYNtqtaOI3PcToapMycWIY59DfixzZbtxYKlXvtwRX5+
         00pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5XzKRAnIzM4OkR+o5IUQ3F91LoQlv8ZVaHR4VoSR6KY=;
        b=kQHtVsk75MeRahB//o8JDBlOkkSEsdB+gD0xFfs6IcVlWac5rFmQCq2CxEnZa/95Yp
         SfcSiwQu3Pfgt6wpglOpHTnFXe5RGUPzL7WbyYpZCDdNIBBbP33xFmMJbsIbV2yiBJIM
         ug+w/eh/4a8sJtK1EyWqe6US5BJfAFG6fuhUZ74cS9iJ2211ylzaOURSrmwmuGjj/e+0
         6l1DIkYpaK99YMSOYIQpQZMAQdCC/nGVBtgzVw2Crk1pM0Y1PSXNOo6Iq75INJOlN0zg
         NcGJKHRfrSMNbD+jTTSiZqETwUH/qeA9EdmmLf59QHQqBP3z54U9b6api2E4dAWFv/vI
         nrKg==
X-Gm-Message-State: AOAM532WuAPIH46bwjsOyNJQGhKFnb4sP7znwoRrTMu5pknIjyqr9iNT
        bF2WG3RuePYHcU2WjK5Mx2IIV93xBOfMJw==
X-Google-Smtp-Source: ABdhPJyaRgC/aLw9LT04IH7XGkVKTm3z5bI3W8j/Kb/iT/+aZf4GyQ7Ku9pYAs5jGioUuzXujVgUJQ==
X-Received: by 2002:aca:b655:: with SMTP id g82mr785226oif.91.1612325842490;
        Tue, 02 Feb 2021 20:17:22 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:21 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 19/19] selftests/bpf: add test case for redirection between udp and unix
Date:   Tue,  2 Feb 2021 20:16:36 -0800
Message-Id: <20210203041636.38555-20-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 226 ++++++++++++++++++
 1 file changed, 226 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 8f52302165a6..e0c2a0a4f501 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1798,6 +1798,228 @@ static void test_unix_redir(struct test_sockmap_listen *skel, struct bpf_map *ma
 	unix_skb_redir_to_connected(skel, map, sotype);
 }
 
+static void udp_unix_redir_to_connected(int family, int sock_mapfd,
+					int verd_mapfd, enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	struct sockaddr_storage addr;
+	int c0, c1, p0, p1;
+	unsigned int pass;
+	socklen_t len;
+	int err, n;
+	int sfd[2];
+	u64 value;
+	u32 key;
+	char b;
+
+	zero_verdict_count(verd_mapfd);
+
+	if (socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, sfd))
+		return;
+	c0 = sfd[0], p0 = sfd[1];
+
+	p1 = socket_loopback(family, SOCK_DGRAM | SOCK_NONBLOCK);
+	if (p0 < 0)
+		goto close;
+	len = sizeof(addr);
+	err = xgetsockname(p1, sockaddr(&addr), &len);
+	if (err)
+		goto close_peer1;
+
+	c1 = xsocket(family, SOCK_DGRAM | SOCK_NONBLOCK, 0);
+	if (c1 < 0)
+		goto close_peer1;
+	err = xconnect(c1, sockaddr(&addr), len);
+	if (err)
+		goto close_cli1;
+	err = xgetsockname(c1, sockaddr(&addr), &len);
+	if (err)
+		goto close_cli1;
+	err = xconnect(p1, sockaddr(&addr), len);
+	if (err)
+		goto close_cli1;
+
+	key = 0;
+	value = p0;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_cli1;
+
+	key = 1;
+	value = p1;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_cli1;
+
+	n = write(c1, "a", 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: write", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete write", log_prefix);
+	if (n < 1)
+		goto close_cli1;
+
+	key = SK_PASS;
+	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
+	if (err)
+		goto close_cli1;
+	if (pass != 1)
+		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
+
+	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: read", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete read", log_prefix);
+
+close_cli1:
+	xclose(c1);
+close_peer1:
+	xclose(p1);
+close:
+	xclose(c0);
+	xclose(p0);
+}
+
+static void udp_unix_skb_redir_to_connected(struct test_sockmap_listen *skel,
+					    struct bpf_map *inner_map, int family)
+{
+	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
+	int sock_map = bpf_map__fd(inner_map);
+	int err;
+
+	err = xbpf_prog_attach(verdict, sock_map, BPF_SK_SKB_VERDICT, 0);
+	if (err)
+		return;
+
+	skel->bss->test_ingress = false;
+	udp_unix_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
+	skel->bss->test_ingress = true;
+	udp_unix_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
+}
+
+static void unix_udp_redir_to_connected(int family, int sock_mapfd,
+					int verd_mapfd, enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	struct sockaddr_storage addr;
+	int c0, c1, p0, p1;
+	unsigned int pass;
+	socklen_t len;
+	int err, n;
+	int sfd[2];
+	u64 value;
+	u32 key;
+	char b;
+
+	zero_verdict_count(verd_mapfd);
+
+	p0 = socket_loopback(family, SOCK_DGRAM | SOCK_NONBLOCK);
+	if (p0 < 0)
+		return;
+	len = sizeof(addr);
+	err = xgetsockname(p0, sockaddr(&addr), &len);
+	if (err)
+		goto close_peer0;
+
+	c0 = xsocket(family, SOCK_DGRAM | SOCK_NONBLOCK, 0);
+	if (c0 < 0)
+		goto close_peer0;
+	err = xconnect(c0, sockaddr(&addr), len);
+	if (err)
+		goto close_cli0;
+	err = xgetsockname(c0, sockaddr(&addr), &len);
+	if (err)
+		goto close_cli0;
+	err = xconnect(p0, sockaddr(&addr), len);
+	if (err)
+		goto close_cli0;
+
+	if (socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, sfd))
+		goto close_cli0;
+	c1 = sfd[0], p1 = sfd[1];
+
+	key = 0;
+	value = p0;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close;
+
+	key = 1;
+	value = p1;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close;
+
+	n = write(c1, "a", 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: write", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete write", log_prefix);
+	if (n < 1)
+		goto close;
+
+	key = SK_PASS;
+	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
+	if (err)
+		goto close;
+	if (pass != 1)
+		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
+
+	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: read", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete read", log_prefix);
+
+close:
+	xclose(c1);
+	xclose(p1);
+close_cli0:
+	xclose(c0);
+close_peer0:
+	xclose(p0);
+
+}
+
+static void unix_udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
+					    struct bpf_map *inner_map, int family)
+{
+	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
+	int sock_map = bpf_map__fd(inner_map);
+	int err;
+
+	err = xbpf_prog_attach(verdict, sock_map, BPF_SK_SKB_VERDICT, 0);
+	if (err)
+		return;
+
+	skel->bss->test_ingress = false;
+	unix_udp_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
+	skel->bss->test_ingress = true;
+	unix_udp_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
+}
+
+static void test_udp_unix_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
+				int family)
+{
+	const char *family_name, *map_name;
+	char s[MAX_TEST_NAME];
+
+	family_name = family_str(family);
+	map_name = map_type_str(map);
+	snprintf(s, sizeof(s), "%s %s %s", map_name, family_name, __func__);
+	if (!test__start_subtest(s))
+		return;
+	udp_unix_skb_redir_to_connected(skel, map, family);
+	unix_udp_skb_redir_to_connected(skel, map, family);
+}
+
 static void test_reuseport(struct test_sockmap_listen *skel,
 			   struct bpf_map *map, int family, int sotype)
 {
@@ -1864,6 +2086,8 @@ void test_sockmap_listen(void)
 	test_udp_redir(skel, skel->maps.sock_map, AF_INET);
 	test_udp_redir(skel, skel->maps.sock_map, AF_INET6);
 	test_unix_redir(skel, skel->maps.sock_map, SOCK_DGRAM);
+	test_udp_unix_redir(skel, skel->maps.sock_map, AF_INET);
+	test_udp_unix_redir(skel, skel->maps.sock_map, AF_INET6);
 
 	skel->bss->test_sockmap = false;
 	run_tests(skel, skel->maps.sock_hash, AF_INET);
@@ -1871,6 +2095,8 @@ void test_sockmap_listen(void)
 	test_udp_redir(skel, skel->maps.sock_hash, AF_INET);
 	test_udp_redir(skel, skel->maps.sock_hash, AF_INET6);
 	test_unix_redir(skel, skel->maps.sock_hash, SOCK_DGRAM);
+	test_udp_unix_redir(skel, skel->maps.sock_hash, AF_INET);
+	test_udp_unix_redir(skel, skel->maps.sock_hash, AF_INET6);
 
 	test_sockmap_listen__destroy(skel);
 }
-- 
2.25.1

