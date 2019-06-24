Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DF2509A4
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbfFXLU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:20:28 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39811 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbfFXLU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 07:20:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so6716646pls.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 04:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SqDLjsemqHZVkEqvzObvOVSVuW+KkPPB4CHniC6UqgU=;
        b=EXGG2msIfL0qlSDzv/JcBU8rILD7Plk5GrxLieXHbzkF0PfXoW0vnCuMA/uoGx2NsK
         WUo0cdaC5QRszQ5KZ5whD7850a3YU2rdOx1IxKHzvl8h6VAVSQgVO1zyyaMJD+rc4gPR
         lbsrLUUR+7AaEIHKLjZJAVGC1PG66p549niP6Ym2OablhtMljOx+wm81KdKh2KEKmDq1
         vPYJIqYVrJMHzF/JOQ5DcoyIIbpUG4q5mNkZdegJmCly1vDnubNLv2rzZFl339TgappQ
         0Whau0n011wT+LXMqu91X8JeYqfD8bTNW42YXvgQWUkGpwoXlrU3a+wQndap675dmqzh
         4q+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SqDLjsemqHZVkEqvzObvOVSVuW+KkPPB4CHniC6UqgU=;
        b=reD/eJWOAPBXOv7TnR/SacO3gmrvKvAaeSqsuOJmwgBbzwB0TOhQN0xBndjvviJvEj
         OQa81l6loBarRbW/09jLUELJqEjGzXNq1tLiLdq8Dx143Tzw8Z36uet4sujK6x9GM3Al
         hzk3gwfJyCeYKygc6SQ3i4FYSwle5z6JEFQ1+Xdxzbr6/Gh69HuPALagZ4AZi5DKLq7G
         /4+jOik7NYGfYN8QErbRz1G9VVg+35sOJtJpz1PzhCjlus1PDL6RZSpkHgDgIYHvCKFM
         yqnp2NfIbPWxjfW25HaeOxTPup4Ie042+14OUb8Xcp2KvQ+DcP/Tzl5RKrAqxULpxEMG
         FFBw==
X-Gm-Message-State: APjAAAVpCyQhkE4cifNpim5HKaItTNFsqi4XdMKHAaRLrq5Nk2G6bd5P
        xcshBlsd/j0AW/5UGu+0dg==
X-Google-Smtp-Source: APXvYqx0rEC6X8lgS4ioxfTM2Whe+i5YwTHEaHve7kP3GE/ViD8WtazHPlpnBNBjZ/qSR9FyrSTMhg==
X-Received: by 2002:a17:902:2bcb:: with SMTP id l69mr40533004plb.155.1561375227529;
        Mon, 24 Jun 2019 04:20:27 -0700 (PDT)
Received: from localhost.localdomain ([111.118.56.180])
        by smtp.gmail.com with ESMTPSA id a13sm10035085pgl.84.2019.06.24.04.20.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 04:20:26 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] samples: bpf: make the use of xdp samples consistent
Date:   Mon, 24 Jun 2019 20:20:09 +0900
Message-Id: <20190624112009.20048-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, each xdp samples are inconsistent in the use.
Most of the samples fetch the interface with it's name.
(ex. xdp1, xdp2skb, xdp_redirect, xdp_sample_pkts, etc.)

But only xdp_adjst_tail and xdp_tx_iptunnel fetch the interface with
ifindex by command argument.

This commit enables those two samples to fetch interface with it's name
without changing the original index interface fetching.
(<ifname|ifindex> fetching in the same way as xdp_sample_pkts_user.c does.)

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/xdp_adjust_tail_user.c | 12 ++++++++++--
 samples/bpf/xdp_tx_iptunnel_user.c | 12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

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

