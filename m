Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35E86B2C14
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjCIRdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCIRc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:32:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264F55FD6;
        Thu,  9 Mar 2023 09:32:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B744061CAE;
        Thu,  9 Mar 2023 17:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9391C433D2;
        Thu,  9 Mar 2023 17:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678383174;
        bh=6QGHCPJ237aCPIO8Oke5wNEgblf5ORBvssHG98cGL4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t17MkOabn8p55mdRni1roeQSrJl0L3OIiwg8thzetOSUKecvw4A/xgdS7a4b+7o5g
         tV0WEAwVBMIczccBWsBQ19Mvd4gEOo1cFd0yGgD1Sn4eMeX9kBgqnat5LWrljOHZZu
         P711mIeyXrFmUrGGIYmwF96uETiQF+slF6/Gp1yzJZ/yjGFIGTideyHHzfkczEhjMX
         oeWLttI5QhaEUTGrgeZnupFOoxCfgJoC55UvMOMWgTmyMxR/zlY29tJ9omRgEoGI0t
         l7J4PUzexEfoactxqHAZNNH+TOskaahTqJ+bhovMaerNxzLfl8OlKeUYrYXkgQ89HZ
         lLwdx5jHo5Akw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        lorenzo.bianconi@redhat.com, daniel@iogearbox.net
Subject: [PATCH bpf-next v2 1/2] selftests/bpf: use ifname instead of ifindex in XDP compliance test tool
Date:   Thu,  9 Mar 2023 18:32:40 +0100
Message-Id: <7dc5a8ff56c252b1a7ae29b059d0b2b1543c8b5d.1678382940.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678382940.git.lorenzo@kernel.org>
References: <cover.1678382940.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on interface name instead of interface index in error messages or
logs from XDP compliance test tool.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/xdp_features.c | 44 +++++++++++++---------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdp_features.c b/tools/testing/selftests/bpf/xdp_features.c
index fce12165213b..b060a0d24e44 100644
--- a/tools/testing/selftests/bpf/xdp_features.c
+++ b/tools/testing/selftests/bpf/xdp_features.c
@@ -25,6 +25,7 @@
 
 static struct env {
 	bool verbosity;
+	char ifname[IF_NAMESIZE];
 	int ifindex;
 	bool is_tester;
 	struct {
@@ -179,7 +180,7 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 		env.ifindex = if_nametoindex(arg);
 		if (!env.ifindex)
 			env.ifindex = strtoul(arg, NULL, 0);
-		if (!env.ifindex) {
+		if (!env.ifindex || !if_indextoname(env.ifindex, env.ifname)) {
 			fprintf(stderr,
 				"Bad interface index or name (%d): %s\n",
 				errno, strerror(errno));
@@ -205,6 +206,7 @@ static void set_env_default(void)
 	env.feature.drv_feature = NETDEV_XDP_ACT_NDO_XMIT;
 	env.feature.action = -EINVAL;
 	env.ifindex = -ENODEV;
+	strcpy(env.ifname, "unknown");
 	make_sockaddr(AF_INET6, "::ffff:127.0.0.1", DUT_CTRL_PORT,
 		      &env.dut_ctrl_addr, NULL);
 	make_sockaddr(AF_INET6, "::ffff:127.0.0.1", DUT_ECHO_PORT,
@@ -248,15 +250,18 @@ static int dut_run_echo_thread(pthread_t *t, int *sockfd)
 	sockfd = start_reuseport_server(AF_INET6, SOCK_DGRAM, NULL,
 					DUT_ECHO_PORT, 0, 1);
 	if (!sockfd) {
-		fprintf(stderr, "Failed to create echo socket\n");
+		fprintf(stderr,
+			"Failed creating data UDP socket on device %s\n",
+			env.ifname);
 		return -errno;
 	}
 
 	/* start echo channel */
 	err = pthread_create(t, NULL, dut_echo_thread, sockfd);
 	if (err) {
-		fprintf(stderr, "Failed creating dut_echo thread: %s\n",
-			strerror(-err));
+		fprintf(stderr,
+			"Failed creating data UDP thread on device %s: %s\n",
+			env.ifname, strerror(-err));
 		free_fds(sockfd, 1);
 		return -EINVAL;
 	}
@@ -320,9 +325,8 @@ static int dut_attach_xdp_prog(struct xdp_features *skel, int flags)
 
 	err = bpf_xdp_attach(env.ifindex, bpf_program__fd(prog), flags, NULL);
 	if (err)
-		fprintf(stderr,
-			"Failed to attach XDP program to ifindex %d\n",
-			env.ifindex);
+		fprintf(stderr, "Failed attaching XDP program to device %s\n",
+			env.ifname);
 	return err;
 }
 
@@ -358,13 +362,16 @@ static int dut_run(struct xdp_features *skel)
 	sockfd = start_reuseport_server(AF_INET6, SOCK_STREAM, NULL,
 					DUT_CTRL_PORT, 0, 1);
 	if (!sockfd) {
-		fprintf(stderr, "Failed to create DUT socket\n");
+		fprintf(stderr,
+			"Failed creating control socket on device %s\n", env.ifname);
 		return -errno;
 	}
 
 	ctrl_sockfd = accept(*sockfd, (struct sockaddr *)&ctrl_addr, &addrlen);
 	if (ctrl_sockfd < 0) {
-		fprintf(stderr, "Failed to accept connection on DUT socket\n");
+		fprintf(stderr,
+			"Failed accepting connections on device %s control socket\n",
+			env.ifname);
 		free_fds(sockfd, 1);
 		return -errno;
 	}
@@ -422,8 +429,8 @@ static int dut_run(struct xdp_features *skel)
 					    &opts);
 			if (err) {
 				fprintf(stderr,
-					"Failed to query XDP cap for ifindex %d\n",
-					env.ifindex);
+					"Failed querying XDP cap for device %s\n",
+					env.ifname);
 				goto end_thread;
 			}
 
@@ -540,7 +547,9 @@ static int send_echo_msg(void)
 
 	sockfd = socket(AF_INET6, SOCK_DGRAM, 0);
 	if (sockfd < 0) {
-		fprintf(stderr, "Failed to create echo socket\n");
+		fprintf(stderr,
+			"Failed creating data UDP socket on device %s\n",
+			env.ifname);
 		return -errno;
 	}
 
@@ -596,8 +605,8 @@ static int tester_run(struct xdp_features *skel)
 
 	err = bpf_xdp_attach(env.ifindex, bpf_program__fd(prog), flags, NULL);
 	if (err) {
-		fprintf(stderr, "Failed to attach XDP program to ifindex %d\n",
-			env.ifindex);
+		fprintf(stderr, "Failed attaching XDP program to device %s\n",
+			env.ifname);
 		goto out;
 	}
 
@@ -653,7 +662,7 @@ int main(int argc, char **argv)
 		return err;
 
 	if (env.ifindex < 0) {
-		fprintf(stderr, "Invalid ifindex\n");
+		fprintf(stderr, "Invalid device name %s\n", env.ifname);
 		return -ENODEV;
 	}
 
@@ -684,11 +693,12 @@ int main(int argc, char **argv)
 
 	if (env.is_tester) {
 		/* Tester */
-		fprintf(stdout, "Starting tester on device %d\n", env.ifindex);
+		fprintf(stdout, "Starting tester service on device %s\n",
+			env.ifname);
 		err = tester_run(skel);
 	} else {
 		/* DUT */
-		fprintf(stdout, "Starting DUT on device %d\n", env.ifindex);
+		fprintf(stdout, "Starting test on device %s\n", env.ifname);
 		err = dut_run(skel);
 	}
 
-- 
2.39.2

