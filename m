Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E29C51F11
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfFXXVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:21:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45256 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfFXXVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:21:06 -0400
Received: by mail-pg1-f194.google.com with SMTP id z19so4948812pgl.12
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 16:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UJhsSqHcceCqCB359AT1rVmU3aCew4ZtEJVvX9H5JdA=;
        b=BNQz+ngWDYF9u63gBXhmyVE70zC7OV8LlyXTXH+DhkNYStgYBT6MiyZEArWW0PuzvC
         euV/uMZHST13xj8lggExucUZfoIHizi2RIvMrpXQ3FpMyN4V/mn7JlqztgbRCc4dTXV2
         hNZJ+BuyFsaQKuEmP7BAX1BbECUtXTD89RQAb9bPenV1ruUIVDqZ98p35xufDgY4lmCd
         nm4AChP2AkncaizqaDJOS87/Qp82VYHeSvavF80a6FVKnKUDxfPmBfaGu8yVL58Q0xoT
         dfvrQ+hftD59HxRe0gVB5Wcjnyl+qMKqdIQCtAv+rFtRzEerGH/Dk9MuRJjp3bgjzgiN
         ishw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UJhsSqHcceCqCB359AT1rVmU3aCew4ZtEJVvX9H5JdA=;
        b=slMbxUyAiMas8cZuoOMb4kvdTooAjzoRIOwttHWS/Ix+EvB4e1GrmqFWfL4ejp97jm
         3rxXQ3vXQx2t4+CENvJta/0ImFABCLcSYyC4EUrPHBTS7dmN+CxkAAlNqR9Z7VmzNzJa
         Q9aB/+kkqdvYi7cq/gLe1dp8lU2ORw9hXbh4OwENypKvf6f75Q3ve62KkXNDn7jUZr4t
         5v4YR9+XlTXGvYI9+yf6Mw51ziZ9+Av+zPw7v6iy/Eje7u952uQ9zCxJYh9qXB+p3Z0B
         aqxM9NUFktsIjdjMrpMAH8ORZjfSz7iqcMqT8JWkNa00YWeB40SOefmmAwEnqmg39Tum
         m1xw==
X-Gm-Message-State: APjAAAUZ3x2K2o/0d34p1LleFB04iktCoddRhf2APeSFYzVzLSxfRijs
        AabGLlDfPFJS7S59yWAcQw==
X-Google-Smtp-Source: APXvYqxs/fuWiAU64yLuCvLm7yD3I4U2T3EJX0T8UGW6l3d/W90WA9LJ6ATOp4NQglxS5r+/5TuFrw==
X-Received: by 2002:a65:5303:: with SMTP id m3mr13112625pgq.393.1561418465225;
        Mon, 24 Jun 2019 16:21:05 -0700 (PDT)
Received: from localhost.localdomain ([58.76.163.19])
        by smtp.gmail.com with ESMTPSA id i126sm16422730pfb.32.2019.06.24.16.21.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 16:21:04 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] samples: bpf: make the use of xdp samples consistent
Date:   Tue, 25 Jun 2019 08:20:57 +0900
Message-Id: <20190624232057.12305-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, each xdp samples are inconsistent in the use.
Most of the samples fetch the interface with it's name.
(ex. xdp1, xdp2skb, xdp_redirect_cpu, xdp_sample_pkts, etc.)

But some of the xdp samples are fetching the interface with
ifindex by command argument.

This commit enables xdp samples to fetch interface with it's name
without changing the original index interface fetching.
(<ifname|ifindex> fetching in the same way as xdp_sample_pkts_user.c does.)

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes in v2:
  - added xdp_redirect_user.c, xdp_redirect_map_user.c 

 samples/bpf/xdp_adjust_tail_user.c  | 12 ++++++++++--
 samples/bpf/xdp_redirect_map_user.c | 15 +++++++++++----
 samples/bpf/xdp_redirect_user.c     | 15 +++++++++++----
 samples/bpf/xdp_tx_iptunnel_user.c  | 12 ++++++++++--
 4 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
index 586ff751aba9..a3596b617c4c 100644
--- a/samples/bpf/xdp_adjust_tail_user.c
+++ b/samples/bpf/xdp_adjust_tail_user.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <net/if.h>
 #include <sys/resource.h>
 #include <arpa/inet.h>
 #include <netinet/ether.h>
@@ -69,7 +70,7 @@ static void usage(const char *cmd)
 	printf("Start a XDP prog which send ICMP \"packet too big\" \n"
 		"messages if ingress packet is bigger then MAX_SIZE bytes\n");
 	printf("Usage: %s [...]\n", cmd);
-	printf("    -i <ifindex> Interface Index\n");
+	printf("    -i <ifname|ifindex> Interface\n");
 	printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
 	printf("    -S use skb-mode\n");
 	printf("    -N enforce native mode\n");
@@ -102,7 +103,9 @@ int main(int argc, char **argv)
 
 		switch (opt) {
 		case 'i':
-			ifindex = atoi(optarg);
+			ifindex = if_nametoindex(optarg);
+			if (!ifindex)
+				ifindex = atoi(optarg);
 			break;
 		case 'T':
 			kill_after_s = atoi(optarg);
@@ -136,6 +139,11 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
+	if (!ifindex) {
+		fprintf(stderr, "Invalid ifname\n");
+		return 1;
+	}
+
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file = filename;
 
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index 15bb6f67f9c3..f70ee33907fd 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -10,6 +10,7 @@
 #include <stdlib.h>
 #include <stdbool.h>
 #include <string.h>
+#include <net/if.h>
 #include <unistd.h>
 #include <libgen.h>
 #include <sys/resource.h>
@@ -85,7 +86,7 @@ static void poll_stats(int interval, int ifindex)
 static void usage(const char *prog)
 {
 	fprintf(stderr,
-		"usage: %s [OPTS] IFINDEX_IN IFINDEX_OUT\n\n"
+		"usage: %s [OPTS] <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n\n"
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
@@ -127,7 +128,7 @@ int main(int argc, char **argv)
 	}
 
 	if (optind == argc) {
-		printf("usage: %s IFINDEX_IN IFINDEX_OUT\n", argv[0]);
+		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
 		return 1;
 	}
 
@@ -136,8 +137,14 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
-	ifindex_in = strtoul(argv[optind], NULL, 0);
-	ifindex_out = strtoul(argv[optind + 1], NULL, 0);
+	ifindex_in = if_nametoindex(argv[optind]);
+	if (!ifindex_in)
+		ifindex_in = strtoul(argv[optind], NULL, 0);
+
+	ifindex_out = if_nametoindex(argv[optind + 1]);
+	if (!ifindex_out)
+		ifindex_out = strtoul(argv[optind + 1], NULL, 0);
+
 	printf("input: %d output: %d\n", ifindex_in, ifindex_out);
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index ce71be187205..39de06f3ec25 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -10,6 +10,7 @@
 #include <stdlib.h>
 #include <stdbool.h>
 #include <string.h>
+#include <net/if.h>
 #include <unistd.h>
 #include <libgen.h>
 #include <sys/resource.h>
@@ -85,7 +86,7 @@ static void poll_stats(int interval, int ifindex)
 static void usage(const char *prog)
 {
 	fprintf(stderr,
-		"usage: %s [OPTS] IFINDEX_IN IFINDEX_OUT\n\n"
+		"usage: %s [OPTS] <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n\n"
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
@@ -128,7 +129,7 @@ int main(int argc, char **argv)
 	}
 
 	if (optind == argc) {
-		printf("usage: %s IFINDEX_IN IFINDEX_OUT\n", argv[0]);
+		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
 		return 1;
 	}
 
@@ -137,8 +138,14 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
-	ifindex_in = strtoul(argv[optind], NULL, 0);
-	ifindex_out = strtoul(argv[optind + 1], NULL, 0);
+	ifindex_in = if_nametoindex(argv[optind]);
+	if (!ifindex_in)
+		ifindex_in = strtoul(argv[optind], NULL, 0);
+
+	ifindex_out = if_nametoindex(argv[optind + 1]);
+	if (!ifindex_out)
+		ifindex_out = strtoul(argv[optind + 1], NULL, 0);
+
 	printf("input: %d output: %d\n", ifindex_in, ifindex_out);
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
diff --git a/samples/bpf/xdp_tx_iptunnel_user.c b/samples/bpf/xdp_tx_iptunnel_user.c
index 394896430712..dfb68582e243 100644
--- a/samples/bpf/xdp_tx_iptunnel_user.c
+++ b/samples/bpf/xdp_tx_iptunnel_user.c
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <net/if.h>
 #include <sys/resource.h>
 #include <arpa/inet.h>
 #include <netinet/ether.h>
@@ -83,7 +84,7 @@ static void usage(const char *cmd)
 	       "in an IPv4/v6 header and XDP_TX it out.  The dst <VIP:PORT>\n"
 	       "is used to select packets to encapsulate\n\n");
 	printf("Usage: %s [...]\n", cmd);
-	printf("    -i <ifindex> Interface Index\n");
+	printf("    -i <ifname|ifindex> Interface\n");
 	printf("    -a <vip-service-address> IPv4 or IPv6\n");
 	printf("    -p <vip-service-port> A port range (e.g. 433-444) is also allowed\n");
 	printf("    -s <source-ip> Used in the IPTunnel header\n");
@@ -181,7 +182,9 @@ int main(int argc, char **argv)
 
 		switch (opt) {
 		case 'i':
-			ifindex = atoi(optarg);
+			ifindex = if_nametoindex(optarg);
+			if (!ifindex)
+				ifindex = atoi(optarg);
 			break;
 		case 'a':
 			vip.family = parse_ipstr(optarg, vip.daddr.v6);
@@ -253,6 +256,11 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
+	if (!ifindex) {
+		fprintf(stderr, "Invalid ifname\n");
+		return 1;
+	}
+
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file = filename;
 
-- 
2.17.1

