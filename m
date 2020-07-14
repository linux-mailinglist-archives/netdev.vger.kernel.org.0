Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B64621F339
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGNN5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgGNN5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 09:57:15 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B66B224D3;
        Tue, 14 Jul 2020 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594735034;
        bh=0CFcyr++U2Vc7lYUhB9yuFkG2h/avB0S5DLeZdlQ4ZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uhg+IVls68Sh87IXKOY92ZRVpCi4gc1396JjmedMFdmj8IbwxzREcPcJPRj53oVkK
         OjC1uJ4zYxH84Fr9s2f1Y7BAk0IupDt+rt5eCcPh0zTKLAQhOMUe8HEujsDXT4nvGM
         JKt4Y4P3FQ5LsLTtHpkbugIJJyOsVCnQBKBcuVWs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v7 bpf-next 3/9] samples/bpf: xdp_redirect_cpu_user: do not update bpf maps in option loop
Date:   Tue, 14 Jul 2020 15:56:36 +0200
Message-Id: <95dc46286fd2c609042948e04bb7ae1f5b425538.1594734381.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594734381.git.lorenzo@kernel.org>
References: <cover.1594734381.git.lorenzo@kernel.org>
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
index f4e755e0dd73..6bb2d95cb26c 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -681,6 +681,7 @@ int main(int argc, char **argv)
 	int add_cpu = -1;
 	int opt, err;
 	int prog_fd;
+	int *cpu, i;
 	__u32 qsize;
 
 	n_cpus = get_nprocs_conf();
@@ -716,6 +717,13 @@ int main(int argc, char **argv)
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
@@ -760,8 +768,7 @@ int main(int argc, char **argv)
 					errno, strerror(errno));
 				goto error;
 			}
-			create_cpu_entry(add_cpu, qsize, added_cpus, true);
-			added_cpus++;
+			cpu[added_cpus++] = add_cpu;
 			break;
 		case 'q':
 			qsize = atoi(optarg);
@@ -772,6 +779,7 @@ int main(int argc, char **argv)
 		case 'h':
 		error:
 		default:
+			free(cpu);
 			usage(argv, obj);
 			return EXIT_FAIL_OPTION;
 		}
@@ -784,16 +792,21 @@ int main(int argc, char **argv)
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
@@ -801,27 +814,32 @@ int main(int argc, char **argv)
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

