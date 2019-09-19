Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876F8B8791
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 00:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404355AbfISWqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 18:46:18 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39354 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389023AbfISWqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 18:46:18 -0400
Received: by mail-oi1-f194.google.com with SMTP id w144so146326oia.6;
        Thu, 19 Sep 2019 15:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=bzP3Biuj6YMBoK/rJ9D8S2zv1/uWFhRasQpVD97IPUw=;
        b=UhRNQkwt5DL9Xj/+S1o2nq+qrUj2+djgXxuF7wHbjyP3E9gG94FnLoNChsZ9KO36FH
         0WJh8xE0kCelKDPT6ANxYLKDrvQAPHmBH0+jMwpaoTzIy6vUo/FEX5V/a0Alt42kxu0h
         ZbI9m5i327XrJxTgfQ8UspnaIyOsp7Gei8E4JBnoMT36HZmLLUGksUlWRKYFgWsVHYWF
         VeSDmbN7Hw06gyQJqIAAGfKH/HjlulCWmPlvI3Hs42j1LwqDKZ6SPcekGpvNRosnp2Fm
         kcdy6aQuAN3MZ7pGP4tplx15vj50Vp+xLp2cQtA1dJjANfKUCmRsxWIcBdT3gy7YMRAY
         CHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=bzP3Biuj6YMBoK/rJ9D8S2zv1/uWFhRasQpVD97IPUw=;
        b=CoejB6c1h5rY4JjVK/jKGuWUxRUJ/lSxVeOPOQ63Xl8qqyiViQrqaNCsDZozXRJ7ws
         JK1XU58TdH9F3mFp788irl8706XIhu/Umnnfk6wcLHca92ldoer7+8GdfYwudGCOSGVJ
         LDQYkrB4bTlrM0fO6nTUKWjhJLLUVfuElDzxrzrvz5/ZLE84GSgqHkZk9mIP1i0Izlpx
         erv6IO5hXXqgd6p9BzYcZr4YBRFPigAEVRoTIbNf2hLHf+qROGRB9ocda+cQAY4xGygE
         El4pOfaXe+oN+/KxwNbB6cgdVhGdAjO0TDdP4i6Y1UF3pT+llQXiFN7+yk2q4iwCJTAK
         8ttg==
X-Gm-Message-State: APjAAAXrGDFifcFsgHgFUSrYEM97Oafsofl/PKJ08XTpecgGG8XIjIzO
        6rwy9AObr8054QwTaVxant8=
X-Google-Smtp-Source: APXvYqxKjHwidWKCd3/SYzZ6w6BZJfKbTiYiZOszlYao/L0Ih4KDf/CQjTAGAyWgOBqypGqG3kM0qg==
X-Received: by 2002:aca:3c0b:: with SMTP id j11mr225963oia.143.1568933175752;
        Thu, 19 Sep 2019 15:46:15 -0700 (PDT)
Received: from localhost.localdomain (ip24-56-44-135.ph.ph.cox.net. [24.56.44.135])
        by smtp.gmail.com with ESMTPSA id 8sm89059oti.41.2019.09.19.15.46.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 15:46:15 -0700 (PDT)
From:   Matthew Cover <werekraken@gmail.com>
X-Google-Original-From: Matthew Cover <matthew.cover@stackpath.com>
To:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        nikolay@cumulusnetworks.com, sd@queasysnail.net,
        sbrivio@redhat.com, vincent@bernat.ch, kda@linux-powerpc.org,
        matthew.cover@stackpath.com, jiri@mellanox.com,
        edumazet@google.com, pabeni@redhat.com, idosch@mellanox.com,
        petrm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, dsahern@gmail.com,
        christian@brauner.io, jakub.kicinski@netronome.com,
        roopa@cumulusnetworks.com, johannes.berg@intel.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [RFC iproute2-next 2/2] Introduce an eBPF hookpoint for tx queue selection in the XPS (Transmit Packet Steering) code.
Date:   Thu, 19 Sep 2019 15:46:05 -0700
Message-Id: <20190919224605.91550-1-matthew.cover@stackpath.com>
X-Mailer: git-send-email 2.15.2 (Apple Git-101.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WORK IN PROGRESS:
  * bpf program loading works!
  * txq steering via bpf program return code works!
  * bpf program unloading not working.
  * bpf program attached query not working.
---
 include/bpf_api.h            |  5 +++
 include/uapi/linux/if_link.h | 12 ++++++
 ip/Makefile                  |  2 +-
 ip/ip_common.h               |  4 ++
 ip/iplink.c                  |  7 ++++
 ip/iplink_xps.c              | 88 ++++++++++++++++++++++++++++++++++++++++++++
 lib/bpf.c                    |  6 +++
 7 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 ip/iplink_xps.c

diff --git a/include/bpf_api.h b/include/bpf_api.h
index 89d3488..d1a2d90 100644
--- a/include/bpf_api.h
+++ b/include/bpf_api.h
@@ -78,6 +78,11 @@
 	__section(ELF_SECTION_PROG)
 #endif
 
+#ifndef __section_xps_entry
+# define __section_xps_entry						\
+	__section(ELF_SECTION_PROG)
+#endif
+
 #ifndef __section_cls_entry
 # define __section_cls_entry						\
 	__section(ELF_SECTION_CLASSIFIER)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d36919f..9efd686 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -167,6 +167,7 @@ enum {
 	IFLA_NEW_IFINDEX,
 	IFLA_MIN_MTU,
 	IFLA_MAX_MTU,
+	IFLA_XPS,
 	__IFLA_MAX
 };
 
@@ -977,6 +978,17 @@ enum {
 
 #define IFLA_XDP_MAX (__IFLA_XDP_MAX - 1)
 
+/* XPS section */
+
+enum {
+	IFLA_XPS_UNSPEC,
+	IFLA_XPS_FD,
+	IFLA_XPS_ATTACHED,
+	__IFLA_XPS_MAX,
+};
+
+#define IFLA_XPS_MAX (__IFLA_XPS_MAX - 1)
+
 enum {
 	IFLA_EVENT_NONE,
 	IFLA_EVENT_REBOOT,		/* internal reset / reboot */
diff --git a/ip/Makefile b/ip/Makefile
index 5ab78d7..9ad1c53 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -5,7 +5,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     ipxfrm.o xfrm_state.o xfrm_policy.o xfrm_monitor.o iplink_dummy.o \
     iplink_ifb.o iplink_nlmon.o iplink_team.o iplink_vcan.o iplink_vxcan.o \
     iplink_vlan.o link_veth.o link_gre.o iplink_can.o iplink_xdp.o \
-    iplink_macvlan.o ipl2tp.o link_vti.o link_vti6.o link_xfrm.o \
+    iplink_macvlan.o ipl2tp.o link_vti.o link_vti6.o link_xfrm.o iplink_xps.o \
     iplink_vxlan.o tcp_metrics.o iplink_ipoib.o ipnetconf.o link_ip6tnl.o \
     link_iptnl.o link_gre6.o iplink_bond.o iplink_bond_slave.o iplink_hsr.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
diff --git a/ip/ip_common.h b/ip/ip_common.h
index cd916ec..805d7d2 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -145,6 +145,10 @@ int xdp_parse(int *argc, char ***argv, struct iplink_req *req, const char *ifnam
 	      bool generic, bool drv, bool offload);
 void xdp_dump(FILE *fp, struct rtattr *tb, bool link, bool details);
 
+/* iplink_xps.c */
+int xps_parse(int *argc, char ***argv, struct iplink_req *req);
+void xps_dump(FILE *fp, struct rtattr *tb);
+
 /* iplink_vrf.c */
 __u32 ipvrf_get_table(const char *name);
 int name_is_vrf(const char *name);
diff --git a/ip/iplink.c b/ip/iplink.c
index 212a088..4d6d557 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -101,6 +101,9 @@ void iplink_usage(void)
 		"			[ { xdp | xdpgeneric | xdpdrv | xdpoffload } { off |\n"
 		"				  object FILE [ section NAME ] [ verbose ] |\n"
 		"				  pinned FILE } ]\n"
+		"			[ xps { off |\n"
+		"				  object FILE [ section NAME ] [ verbose ] |\n"
+		"				  pinned FILE } ]\n"
 		"			[ master DEVICE ][ vrf NAME ]\n"
 		"			[ nomaster ]\n"
 		"			[ addrgenmode { eui64 | none | stable_secret | random } ]\n"
@@ -668,6 +671,10 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 
 			if (offload && name == dev)
 				dev = NULL;
+		} else if (strcmp(*argv, "xps") == 0) {
+			NEXT_ARG();
+			if (xps_parse(&argc, &argv, req))
+				exit(-1);
 		} else if (strcmp(*argv, "netns") == 0) {
 			NEXT_ARG();
 			if (netns != -1)
diff --git a/ip/iplink_xps.c b/ip/iplink_xps.c
new file mode 100644
index 0000000..7e94164
--- /dev/null
+++ b/ip/iplink_xps.c
@@ -0,0 +1,88 @@
+/*
+ * iplink_xps.c XPS program loader
+ *
+ *              This program is free software; you can redistribute it and/or
+ *              modify it under the terms of the GNU General Public License
+ *              as published by the Free Software Foundation; either version
+ *              2 of the License, or (at your option) any later version.
+ *
+ * Authors:     Matthew Cover <matthew.cover@stackpath.com>
+ *
+ *              Based on iplink_xdp.c by Daniel Borkmann <daniel@iogearbox.net>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <linux/bpf.h>
+
+#include "bpf_util.h"
+#include "ip_common.h"
+
+extern int force;
+
+struct xps_req {
+	struct iplink_req *req;
+	__u32 flags;
+};
+
+static void xps_ebpf_cb(void *raw, int fd, const char *annotation)
+{
+        struct xps_req *xps = raw;
+        struct iplink_req *req = xps->req;
+        struct rtattr *xps_attr;
+
+        xps_attr = addattr_nest(&req->n, sizeof(*req), IFLA_XPS);
+        addattr32(&req->n, sizeof(*req), IFLA_XPS_FD, fd);
+        addattr_nest_end(&req->n, xps_attr);
+}
+
+static const struct bpf_cfg_ops bpf_cb_ops = {
+	.ebpf_cb = xps_ebpf_cb,
+};
+
+static int xps_delete(struct iplink_req *req)
+{
+	xps_ebpf_cb(req, -1, NULL);
+	return 0;
+}
+
+int xps_parse(int *argc, char ***argv, struct iplink_req *req)
+{
+
+	struct bpf_cfg_in cfg = {
+		.type = BPF_PROG_TYPE_SOCKET_FILTER,
+		.argc = *argc,
+		.argv = *argv,
+	};
+
+	struct xps_req xps = {
+		.req = req,
+	};
+
+	if (*argc == 1) {
+		if (strcmp(**argv, "none") == 0 ||
+		    strcmp(**argv, "off") == 0)
+			return xps_delete(req);
+	}
+
+	if (bpf_parse_and_load_common(&cfg, &bpf_cb_ops, &xps))
+		return -1;
+
+	*argc = cfg.argc;
+	*argv = cfg.argv;
+	return 0;
+}
+
+void xps_dump(FILE *fp, struct rtattr *xps)
+{
+	struct rtattr *tb[IFLA_XPS_MAX + 1];
+
+	parse_rtattr_nested(tb, IFLA_XPS_MAX, xps);
+	if (!tb[IFLA_XPS_ATTACHED] ||
+	    !rta_getattr_u8(tb[IFLA_XPS_ATTACHED]))
+		return;
+
+	fprintf(fp, "xps ");
+	/* More to come here in future for 'ip -d link' (digest, etc) ... */
+}
diff --git a/lib/bpf.c b/lib/bpf.c
index 7d2a322..e883afb 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -60,6 +60,7 @@ static const enum bpf_prog_type __bpf_types[] = {
 	BPF_PROG_TYPE_LWT_IN,
 	BPF_PROG_TYPE_LWT_OUT,
 	BPF_PROG_TYPE_LWT_XMIT,
+	BPF_PROG_TYPE_SOCKET_FILTER,
 };
 
 static const struct bpf_prog_meta __bpf_prog_meta[] = {
@@ -100,6 +101,11 @@ static const struct bpf_prog_meta __bpf_prog_meta[] = {
 		.subdir		= "ip",
 		.section	= ELF_SECTION_PROG,
 	},
+	[BPF_PROG_TYPE_SOCKET_FILTER] = {
+		.type		= "xps",
+		.subdir		= "xps",
+		.section	= ELF_SECTION_PROG,
+	},
 };
 
 static const char *bpf_prog_to_subdir(enum bpf_prog_type type)
-- 
1.8.3.1

