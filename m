Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5080C20777F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404531AbgFXPek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404107AbgFXPej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 11:34:39 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8385B2077D;
        Wed, 24 Jun 2020 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593012878;
        bh=nF7w7BPdIjrotp3E5FNU08T/yU79GDOsojLS+C2DUCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuEcJpl3ybr3ZnZjy8MPl8tOEncO0H8RPfSQEwpFQ0m6AAtVTyUZQ1Tw8YUG/ZQzx
         iPQWUl2RM+w9M8iPZgc0ybRy1ZI+yF3wIWa9w2zgy2XTmjJ3FN12IQJDwIPmKVUWft
         234D5P8Te2fm0H8+VvPSqcIfR7DPVuSrea+jvPVs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v4 bpf-next 3/9] samples/bpf: xdp_redirect_cpu_user: do not update bpf maps in option loop
Date:   Wed, 24 Jun 2020 17:33:52 +0200
Message-Id: <b314637baed005dd7b5a23fbc23444dae281cd80.1593012598.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593012598.git.lorenzo@kernel.org>
References: <cover.1593012598.git.lorenzo@kernel.org>
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

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
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

