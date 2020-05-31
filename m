Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863D71E9A97
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 23:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgEaVrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 17:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbgEaVrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 17:47:32 -0400
Received: from lore-desk.lan (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F816206B6;
        Sun, 31 May 2020 21:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590961651;
        bh=r2dz4/6SeaD2r1KcLWTBrGCsEdT32F/buQiaLm3uwsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srMV+6+WFMCr/TW6YHDj+qnmVjiKtzGNhVXeMJC8Ir/pwy0Z4lYzKEfOVTSZ8KIDs
         owx+lmzukSkxv0IBEmAs8pRbjrpavBh4IFHOtvlhnDKL2N0RyldjxiOLcKAwJ9n8Gg
         xkfVLlmfR6wjKAc34GSUzBkBI/t+e20P/zi53g+g=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH bpf-next 2/6] samples/bpf: xdp_redirect_cpu_user: do not update bpf maps in option loop
Date:   Sun, 31 May 2020 23:46:47 +0200
Message-Id: <ed18a6bb5e67f2f74511a320cc9ddb117775e4e5.1590960613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590960613.git.lorenzo@kernel.org>
References: <cover.1590960613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not update xdp_redirect_cpu maps running while option loop but
defer it after all available options have been parsed. This is a
preliminary patch to pass the program name we want to attach to the
map entries as a user option

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 samples/bpf/xdp_redirect_cpu_user.c | 36 +++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index f3468168982e..1a054737c35a 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -684,6 +684,7 @@ int main(int argc, char **argv)
 	int add_cpu = -1;
 	int opt, err;
 	int prog_fd;
+	int *cpu, i;
 	__u32 qsize;
 
 	n_cpus = get_nprocs_conf();
@@ -719,6 +720,13 @@ int main(int argc, char **argv)
 	}
 	mark_cpus_unavailable();
 
+	cpu = malloc(n_cpus * sizeof(int));
+	if (!cpu) {
+		fprintf(stderr, "failed to allocate cpu array\n");
+		return EXIT_FAIL;
+	}
+	memset(cpu, 0, n_cpus * sizeof(int));
+
 	/* Parse commands line args */
 	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzF",
 				  long_options, &longindex)) != -1) {
@@ -763,8 +771,7 @@ int main(int argc, char **argv)
 					errno, strerror(errno));
 				goto error;
 			}
-			create_cpu_entry(add_cpu, qsize, added_cpus, true);
-			added_cpus++;
+			cpu[added_cpus++] = add_cpu;
 			break;
 		case 'q':
 			qsize = atoi(optarg);
@@ -775,6 +782,7 @@ int main(int argc, char **argv)
 		case 'h':
 		error:
 		default:
+			free(cpu);
 			usage(argv, obj);
 			return EXIT_FAIL_OPTION;
 		}
@@ -787,16 +795,21 @@ int main(int argc, char **argv)
 	if (ifindex == -1) {
 		fprintf(stderr, "ERR: required option --dev missing\n");
 		usage(argv, obj);
-		return EXIT_FAIL_OPTION;
+		err = EXIT_FAIL_OPTION;
+		goto out;
 	}
 	/* Required option */
 	if (add_cpu == -1) {
 		fprintf(stderr, "ERR: required option --cpu missing\n");
 		fprintf(stderr, " Specify multiple --cpu option to add more\n");
 		usage(argv, obj);
-		return EXIT_FAIL_OPTION;
+		err = EXIT_FAIL_OPTION;
+		goto out;
 	}
 
+	for (i = 0; i < added_cpus; i++)
+		create_cpu_entry(cpu[i], qsize, i, true);
+
 	/* Remove XDP program when program is interrupted or killed */
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
@@ -804,27 +817,32 @@ int main(int argc, char **argv)
 	prog = bpf_object__find_program_by_title(obj, prog_name);
 	if (!prog) {
 		fprintf(stderr, "bpf_object__find_program_by_title failed\n");
-		return EXIT_FAIL;
+		err = EXIT_FAIL;
+		goto out;
 	}
 
 	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
 		fprintf(stderr, "bpf_program__fd failed\n");
-		return EXIT_FAIL;
+		err = EXIT_FAIL;
+		goto out;
 	}
 
 	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
 		fprintf(stderr, "link set xdp fd failed\n");
-		return EXIT_FAIL_XDP;
+		err = EXIT_FAIL_XDP;
+		goto out;
 	}
 
 	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
 	if (err) {
 		printf("can't get prog info - %s\n", strerror(errno));
-		return err;
+		goto out;
 	}
 	prog_id = info.id;
 
 	stats_poll(interval, use_separators, prog_name, stress_mode);
-	return EXIT_OK;
+out:
+	free(cpu);
+	return err;
 }
-- 
2.26.2

