Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870ED6A9D7F
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 18:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjCCRWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 12:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjCCRWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 12:22:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D3347412;
        Fri,  3 Mar 2023 09:21:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E2FFB81993;
        Fri,  3 Mar 2023 17:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D510BC4339B;
        Fri,  3 Mar 2023 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677864106;
        bh=FwdDNaPSHqXJd5nXeg5OBo27qa54rumwmJ6W5I7EfMA=;
        h=From:To:Cc:Subject:Date:From;
        b=VgsAVktElwrft4l3ybpwoo+GQtETdd2Rhf8B9ZmO3Z3x4szMKs/7T5QhVDwzLqni0
         fJio8amiPBlt4dOR9QeAfPhwCCor5L4ju/mfgwJ3lhas6/1zIQoGPfYwPkd1CqiMqb
         90u1fllFgjO/eLCJJ4ROuKPikYRLb/o4aiJmghZ0ftl5QbSFbdNrmEYh81j/wqpQEE
         YkIofTt9utRdNffPcxCBnrGqOWwTCU4dYizkDz4FmehuRYYwTl/Mr+d8V07hYzAnOY
         RnAzhdaexlHlwtdNmZXeoPle5mm264LlbmeGVfyP5VnHpuF9khTQBRB12ZENsCbQLx
         oh2zy7KFxM4RQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH bpf-next] selftests/bpf: use ifname instead of ifindex in XDP compliance test tool
Date:   Fri,  3 Mar 2023 18:21:37 +0100
Message-Id: <5d11c9163490126fdc391dacb122480e4c059e62.1677863821.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on interface name instead of interface index in error messages or logs
from XDP compliance test tool.
Improve XDP compliance test tool error messages.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/xdp_features.c | 92 ++++++++++++++--------
 1 file changed, 57 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdp_features.c b/tools/testing/selftests/bpf/xdp_features.c
index fce12165213b..7414801cd7ec 100644
--- a/tools/testing/selftests/bpf/xdp_features.c
+++ b/tools/testing/selftests/bpf/xdp_features.c
@@ -25,6 +25,7 @@
 
 static struct env {
 	bool verbosity;
+	char ifname[IF_NAMESIZE];
 	int ifindex;
 	bool is_tester;
 	struct {
@@ -109,25 +110,25 @@ static int get_xdp_feature(const char *arg)
 	return 0;
 }
 
-static char *get_xdp_feature_str(void)
+static char *get_xdp_feature_str(bool color)
 {
 	switch (env.feature.action) {
 	case XDP_PASS:
-		return YELLOW("XDP_PASS");
+		return color ? YELLOW("XDP_PASS") : "XDP_PASS";
 	case XDP_DROP:
-		return YELLOW("XDP_DROP");
+		return color ? YELLOW("XDP_DROP") : "XDP_DROP";
 	case XDP_ABORTED:
-		return YELLOW("XDP_ABORTED");
+		return color ? YELLOW("XDP_ABORTED") : "XDP_ABORTED";
 	case XDP_TX:
-		return YELLOW("XDP_TX");
+		return color ? YELLOW("XDP_TX") : "XDP_TX";
 	case XDP_REDIRECT:
-		return YELLOW("XDP_REDIRECT");
+		return color ? YELLOW("XDP_REDIRECT") : "XDP_REDIRECT";
 	default:
 		break;
 	}
 
 	if (env.feature.drv_feature == NETDEV_XDP_ACT_NDO_XMIT)
-		return YELLOW("XDP_NDO_XMIT");
+		return color ? YELLOW("XDP_NDO_XMIT") : "XDP_NDO_XMIT";
 
 	return "";
 }
@@ -151,20 +152,26 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 	case 'D':
 		if (make_sockaddr(AF_INET6, arg, DUT_ECHO_PORT,
 				  &env.dut_addr, NULL)) {
-			fprintf(stderr, "Invalid DUT address: %s\n", arg);
+			fprintf(stderr,
+				"Invalid address assigned to the Device Under Test: %s\n",
+				arg);
 			return ARGP_ERR_UNKNOWN;
 		}
 		break;
 	case 'C':
 		if (make_sockaddr(AF_INET6, arg, DUT_CTRL_PORT,
 				  &env.dut_ctrl_addr, NULL)) {
-			fprintf(stderr, "Invalid DUT CTRL address: %s\n", arg);
+			fprintf(stderr,
+				"Invalid address assigned to the Device Under Test: %s\n",
+				arg);
 			return ARGP_ERR_UNKNOWN;
 		}
 		break;
 	case 'T':
 		if (make_sockaddr(AF_INET6, arg, 0, &env.tester_addr, NULL)) {
-			fprintf(stderr, "Invalid Tester address: %s\n", arg);
+			fprintf(stderr,
+				"Invalid address assigned to the Tester device: %s\n",
+				arg);
 			return ARGP_ERR_UNKNOWN;
 		}
 		break;
@@ -179,7 +186,7 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 		env.ifindex = if_nametoindex(arg);
 		if (!env.ifindex)
 			env.ifindex = strtoul(arg, NULL, 0);
-		if (!env.ifindex) {
+		if (!env.ifindex || !if_indextoname(env.ifindex, env.ifname)) {
 			fprintf(stderr,
 				"Bad interface index or name (%d): %s\n",
 				errno, strerror(errno));
@@ -205,6 +212,7 @@ static void set_env_default(void)
 	env.feature.drv_feature = NETDEV_XDP_ACT_NDO_XMIT;
 	env.feature.action = -EINVAL;
 	env.ifindex = -ENODEV;
+	strcpy(env.ifname, "unknown");
 	make_sockaddr(AF_INET6, "::ffff:127.0.0.1", DUT_CTRL_PORT,
 		      &env.dut_ctrl_addr, NULL);
 	make_sockaddr(AF_INET6, "::ffff:127.0.0.1", DUT_ECHO_PORT,
@@ -248,15 +256,18 @@ static int dut_run_echo_thread(pthread_t *t, int *sockfd)
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
@@ -320,9 +331,8 @@ static int dut_attach_xdp_prog(struct xdp_features *skel, int flags)
 
 	err = bpf_xdp_attach(env.ifindex, bpf_program__fd(prog), flags, NULL);
 	if (err)
-		fprintf(stderr,
-			"Failed to attach XDP program to ifindex %d\n",
-			env.ifindex);
+		fprintf(stderr, "Failed attaching XDP program to device %s\n",
+			env.ifname);
 	return err;
 }
 
@@ -355,16 +365,22 @@ static int dut_run(struct xdp_features *skel)
 	pthread_t dut_thread;
 	socklen_t addrlen;
 
+	fprintf(stdout, "Starting test for %s capability on device %s\n",
+		get_xdp_feature_str(false), env.ifname);
+
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
@@ -422,8 +438,8 @@ static int dut_run(struct xdp_features *skel)
 					    &opts);
 			if (err) {
 				fprintf(stderr,
-					"Failed to query XDP cap for ifindex %d\n",
-					env.ifindex);
+					"Failed querying XDP cap for device %s\n",
+					env.ifname);
 				goto end_thread;
 			}
 
@@ -447,7 +463,8 @@ static int dut_run(struct xdp_features *skel)
 						   &key, sizeof(key),
 						   &val, sizeof(val), 0);
 			if (err) {
-				fprintf(stderr, "bpf_map_lookup_elem failed\n");
+				fprintf(stderr,
+					"bpf_map_lookup_elem failed (%d)\n", err);
 				goto end_thread;
 			}
 
@@ -489,7 +506,7 @@ static bool tester_collect_detected_cap(struct xdp_features *skel,
 	err = bpf_map__lookup_elem(skel->maps.stats, &key, sizeof(key),
 				   &val, sizeof(val), 0);
 	if (err) {
-		fprintf(stderr, "bpf_map_lookup_elem failed\n");
+		fprintf(stderr, "bpf_map_lookup_elem failed (%d)\n", err);
 		return false;
 	}
 
@@ -540,7 +557,9 @@ static int send_echo_msg(void)
 
 	sockfd = socket(AF_INET6, SOCK_DGRAM, 0);
 	if (sockfd < 0) {
-		fprintf(stderr, "Failed to create echo socket\n");
+		fprintf(stderr,
+			"Failed creating data UDP socket on device %s\n",
+			env.ifname);
 		return -errno;
 	}
 
@@ -563,9 +582,14 @@ static int tester_run(struct xdp_features *skel)
 	int i, err, sockfd;
 	bool detected_cap;
 
+	fprintf(stdout,
+		"Starting tester service for %s capability on device %s\n",
+		get_xdp_feature_str(false), env.ifname);
+
 	sockfd = socket(AF_INET6, SOCK_STREAM, 0);
 	if (sockfd < 0) {
-		fprintf(stderr, "Failed to create tester socket\n");
+		fprintf(stderr,
+			"Failed creating tester service control socket\n");
 		return -errno;
 	}
 
@@ -575,7 +599,8 @@ static int tester_run(struct xdp_features *skel)
 	err = connect(sockfd, (struct sockaddr *)&env.dut_ctrl_addr,
 		      sizeof(env.dut_ctrl_addr));
 	if (err) {
-		fprintf(stderr, "Failed to connect to the DUT\n");
+		fprintf(stderr,
+			"Failed connecting to the Device Under Test control socket\n");
 		return -errno;
 	}
 
@@ -596,8 +621,8 @@ static int tester_run(struct xdp_features *skel)
 
 	err = bpf_xdp_attach(env.ifindex, bpf_program__fd(prog), flags, NULL);
 	if (err) {
-		fprintf(stderr, "Failed to attach XDP program to ifindex %d\n",
-			env.ifindex);
+		fprintf(stderr, "Failed attaching XDP program to device %s\n",
+			env.ifname);
 		goto out;
 	}
 
@@ -624,7 +649,7 @@ static int tester_run(struct xdp_features *skel)
 
 	detected_cap = tester_collect_detected_cap(skel, ntohl(stats));
 
-	fprintf(stdout, "Feature %s: [%s][%s]\n", get_xdp_feature_str(),
+	fprintf(stdout, "Feature %s: [%s][%s]\n", get_xdp_feature_str(true),
 		detected_cap ? GREEN("DETECTED") : RED("NOT DETECTED"),
 		env.feature.drv_feature & advertised_feature ? GREEN("ADVERTISED")
 							     : RED("NOT ADVERTISED"));
@@ -653,7 +678,7 @@ int main(int argc, char **argv)
 		return err;
 
 	if (env.ifindex < 0) {
-		fprintf(stderr, "Invalid ifindex\n");
+		fprintf(stderr, "Invalid device name %s\n", env.ifname);
 		return -ENODEV;
 	}
 
@@ -682,15 +707,12 @@ int main(int argc, char **argv)
 		goto cleanup;
 	}
 
-	if (env.is_tester) {
+	if (env.is_tester)
 		/* Tester */
-		fprintf(stdout, "Starting tester on device %d\n", env.ifindex);
 		err = tester_run(skel);
-	} else {
+	else
 		/* DUT */
-		fprintf(stdout, "Starting DUT on device %d\n", env.ifindex);
 		err = dut_run(skel);
-	}
 
 cleanup:
 	xdp_features__destroy(skel);
-- 
2.39.2

