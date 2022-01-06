Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF1486530
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiAFNV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239490AbiAFNVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 08:21:03 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303EAC061201;
        Thu,  6 Jan 2022 05:21:03 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id i8so2509066pgt.13;
        Thu, 06 Jan 2022 05:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wBc8X4yxTJj0yg0BtDL82zLPBsVK51ncdk64BgH5coI=;
        b=QiLGxWOqHYifHEFc0SNUYeMbxRB9GWQ5GtNsL64uNUb5YuS6lIUGiAcKkoJxR8Znhc
         d1nvRAit0UuRtdmKcu71a0jTeMS5ZaeJi7GyMNVj0iBd31KTpiUXQbVfJTVkE5iQ5kbu
         CWWzddq6Q2KjEZb5ov8r2b5sp+VePdut2MRVHcuYUwHmC4D5TEfkpHuCDRvWkVIsa1//
         TJImByXTSCpdqaO9zNr77nNyvhfFN10EH16bjikwmmzhuxn/DUvFg2rIYuEAOVLiFeDa
         VZ/B8rdbEzHtZzu9sAiim33R7yIH2RXPUNW/eUfkassFIh1k3yleRdOl8rzkn45c3cqs
         wtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wBc8X4yxTJj0yg0BtDL82zLPBsVK51ncdk64BgH5coI=;
        b=q6iaxXYbVXnWpLr1bm7QzsdE75iPJ2JQwo9UohJK2exzjZ0D+jrLckMRckpZZ3cmTv
         hrErJtsq1ZeHb0rE5zkk5M8+eM0h4slyaW+WmvmbLEtN67ASUp8H6+1QUlFOrezH8AC8
         2bLnIEsZiSU0CCVs5DqCrPSypTqj6o31HhexyZsScVV4jPIKJtq061Y4cwNe+8rA5xbx
         WUt99Vhgah8mqriMzi68x9S/8Sq4XtHcppAbFM1FKhxciXGxz4NvTKg2AVJpO46l14WJ
         pZ3UwdE7GxI1Kseg/8LhHeXPAg/fObzG4ATXqbFIiwVUtf15ocHY0CZrgtcx9FDpTVCj
         /Gfw==
X-Gm-Message-State: AOAM530dsnFVaPGds7n5jNeILrHIQb8lbxnd3y0z17oZIBcncg+l4cAD
        qxlR0iE11FHuTxKrvZ/0tig=
X-Google-Smtp-Source: ABdhPJxg9B/5ySTOsaJtZeU3RQPx6A0yzmrw5bP8wMQrYxm4CX3lv6F4kmOuJ7/AwOg/w5c0Vg7d1A==
X-Received: by 2002:a63:354f:: with SMTP id c76mr48132493pga.193.1641475262761;
        Thu, 06 Jan 2022 05:21:02 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id c11sm2777998pfv.85.2022.01.06.05.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:21:02 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, edumazet@google.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v5 net-next 3/3] bpf: selftests: add bind retry for post_bind{4, 6}
Date:   Thu,  6 Jan 2022 21:20:22 +0800
Message-Id: <20220106132022.3470772-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220106132022.3470772-1-imagedong@tencent.com>
References: <20220106132022.3470772-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

With previous patch, kernel is able to 'put_port' after sys_bind()
fails. Add the test for that case: rebind another port after
sys_bind() fails. If the bind success, it means previous bind
operation is already undoed.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 tools/testing/selftests/bpf/test_sock.c | 150 ++++++++++++++++++++----
 1 file changed, 130 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index 94f9b126f5ed..fe10f8134278 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -35,12 +35,15 @@ struct sock_test {
 	/* Endpoint to bind() to */
 	const char *ip;
 	unsigned short port;
+	unsigned short port_retry;
 	/* Expected test result */
 	enum {
 		LOAD_REJECT,
 		ATTACH_REJECT,
 		BIND_REJECT,
 		SUCCESS,
+		RETRY_SUCCESS,
+		RETRY_REJECT
 	} result;
 };
 
@@ -251,6 +254,99 @@ static struct sock_test tests[] = {
 		.port = 4098,
 		.result = SUCCESS,
 	},
+	{
+		.descr = "bind4 deny specific IP & port of TCP, and retry",
+		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+
+			/* if (ip == expected && port == expected) */
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_ip4)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x7F000001), 4),
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_port)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x1002, 2),
+
+			/* return DENY; */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_A(1),
+
+			/* else return ALLOW; */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.ip = "127.0.0.1",
+		.port = 4098,
+		.port_retry = 5000,
+		.result = RETRY_SUCCESS,
+	},
+	{
+		.descr = "bind4 deny specific IP & port of UDP, and retry",
+		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+
+			/* if (ip == expected && port == expected) */
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_ip4)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x7F000001), 4),
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_port)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x1002, 2),
+
+			/* return DENY; */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_A(1),
+
+			/* else return ALLOW; */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.domain = AF_INET,
+		.type = SOCK_DGRAM,
+		.ip = "127.0.0.1",
+		.port = 4098,
+		.port_retry = 5000,
+		.result = RETRY_SUCCESS,
+	},
+	{
+		.descr = "bind6 deny specific IP & port, and retry",
+		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+
+			/* if (ip == expected && port == expected) */
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_ip6[3])),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x00000001), 4),
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_port)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x2001, 2),
+
+			/* return DENY; */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_A(1),
+
+			/* else return ALLOW; */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.expected_attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.ip = "::1",
+		.port = 8193,
+		.port_retry = 9000,
+		.result = RETRY_SUCCESS,
+	},
 	{
 		.descr = "bind4 allow all",
 		.insns = {
@@ -315,14 +411,15 @@ static int attach_sock_prog(int cgfd, int progfd,
 	return bpf_prog_attach(progfd, cgfd, attach_type, BPF_F_ALLOW_OVERRIDE);
 }
 
-static int bind_sock(int domain, int type, const char *ip, unsigned short port)
+static int bind_sock(int domain, int type, const char *ip,
+		     unsigned short port, unsigned short port_retry)
 {
 	struct sockaddr_storage addr;
 	struct sockaddr_in6 *addr6;
 	struct sockaddr_in *addr4;
 	int sockfd = -1;
 	socklen_t len;
-	int err = 0;
+	int res = SUCCESS;
 
 	sockfd = socket(domain, type, 0);
 	if (sockfd < 0)
@@ -348,21 +445,44 @@ static int bind_sock(int domain, int type, const char *ip, unsigned short port)
 		goto err;
 	}
 
-	if (bind(sockfd, (const struct sockaddr *)&addr, len) == -1)
-		goto err;
+	if (bind(sockfd, (const struct sockaddr *)&addr, len) == -1) {
+		/* sys_bind() may fail for different reasons, errno has to be
+		 * checked to confirm that BPF program rejected it.
+		 */
+		if (errno != EPERM)
+			goto err;
+		if (port_retry)
+			goto retry;
+		res = BIND_REJECT;
+		goto out;
+	}
 
+	goto out;
+retry:
+	if (domain == AF_INET)
+		addr4->sin_port = htons(port_retry);
+	else
+		addr6->sin6_port = htons(port_retry);
+	if (bind(sockfd, (const struct sockaddr *)&addr, len) == -1) {
+		if (errno != EPERM)
+			goto err;
+		res = RETRY_REJECT;
+	} else {
+		res = RETRY_SUCCESS;
+	}
 	goto out;
 err:
-	err = -1;
+	res = -1;
 out:
 	close(sockfd);
-	return err;
+	return res;
 }
 
 static int run_test_case(int cgfd, const struct sock_test *test)
 {
 	int progfd = -1;
 	int err = 0;
+	int res;
 
 	printf("Test case: %s .. ", test->descr);
 	progfd = load_sock_prog(test->insns, test->expected_attach_type);
@@ -380,21 +500,11 @@ static int run_test_case(int cgfd, const struct sock_test *test)
 			goto err;
 	}
 
-	if (bind_sock(test->domain, test->type, test->ip, test->port) == -1) {
-		/* sys_bind() may fail for different reasons, errno has to be
-		 * checked to confirm that BPF program rejected it.
-		 */
-		if (test->result == BIND_REJECT && errno == EPERM)
-			goto out;
-		else
-			goto err;
-	}
-
+	res = bind_sock(test->domain, test->type, test->ip, test->port,
+			test->port_retry);
+	if (res > 0 && test->result == res)
+		goto out;
 
-	if (test->result != SUCCESS)
-		goto err;
-
-	goto out;
 err:
 	err = -1;
 out:
-- 
2.30.2

