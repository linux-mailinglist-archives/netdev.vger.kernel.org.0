Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF031B8047
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 22:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgDXUOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 16:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729389AbgDXUOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 16:14:44 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7988217BA;
        Fri, 24 Apr 2020 20:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587759283;
        bh=9apX48VINGAv491PjmlzAkadaPR0qKX9AaYHGtSkxqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXTQh0wjhLOavDCFwbNWHNSBMwVWvI+i3J6ACBQfeoBk/uulVl2PMrFH5aKg8TLlS
         SOeVdTv+DqhVj9fimT2TlQf82acKUFpypGe3iDnEMoWPdQbA6vAN0AJpZtuR54IcoX
         DLpSAihwswkRNAfvrst/uvNapfrxZwOweuKR2G6o=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v3 bpf-next 12/15] bpftool: Add support for XDP egress
Date:   Fri, 24 Apr 2020 14:14:25 -0600
Message-Id: <20200424201428.89514-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424201428.89514-1-dsahern@kernel.org>
References: <20200424201428.89514-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add xdp_egress as a program type since it requires a new attach
type. This follows suit with other program type + attach type
combintations and leverages the SEC name in libbpf.

Add NET_ATTACH_TYPE_XDP_EGRESS and update attach_type_strings to
allow a user to specify 'xdp_egress' as the attach or detach point.

Update do_attach_detach_xdp to set XDP_FLAGS_EGRESS_MODE if egress
is selected.

Update do_xdp_dump_one to show egress program ids.

Update the documentation and help output.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 tools/bpf/bpftool/Documentation/bpftool-net.rst  | 4 +++-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst | 2 +-
 tools/bpf/bpftool/bash-completion/bpftool        | 4 ++--
 tools/bpf/bpftool/net.c                          | 6 +++++-
 tools/bpf/bpftool/netlink_dumper.c               | 5 +++++
 tools/bpf/bpftool/prog.c                         | 2 +-
 6 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index 8651b00b81ea..d7398fb00ec4 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -26,7 +26,8 @@ NET COMMANDS
 |	**bpftool** **net help**
 |
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
-|	*ATTACH_TYPE* := { **xdp** | **xdpgeneric** | **xdpdrv** | **xdpoffload** }
+|	*ATTACH_TYPE* :=
+|       { **xdp** | **xdpgeneric** | **xdpdrv** | **xdpoffload** | **xdp_egress** }
 
 DESCRIPTION
 ===========
@@ -63,6 +64,7 @@ DESCRIPTION
                   **xdpgeneric** - Generic XDP. runs at generic XDP hook when packet already enters receive path as skb;
                   **xdpdrv** - Native XDP. runs earliest point in driver's receive path;
                   **xdpoffload** - Offload XDP. runs directly on NIC on each packet reception;
+                  **xdp_egress** - XDP in egress path. runs at core networking level;
 
 	**bpftool** **net detach** *ATTACH_TYPE* **dev** *NAME*
                   Detach bpf program attached to network interface *NAME* with
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 9f19404f470e..ab0a8846a8e3 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -44,7 +44,7 @@ PROG COMMANDS
 |		**cgroup/connect4** | **cgroup/connect6** | **cgroup/sendmsg4** | **cgroup/sendmsg6** |
 |		**cgroup/recvmsg4** | **cgroup/recvmsg6** | **cgroup/sysctl** |
 |		**cgroup/getsockopt** | **cgroup/setsockopt** |
-|		**struct_ops** | **fentry** | **fexit** | **freplace**
+|		**struct_ops** | **fentry** | **fexit** | **freplace** | **xdp_egress**
 |	}
 |       *ATTACH_TYPE* := {
 |		**msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 45ee99b159e2..ab20696c20c6 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -471,7 +471,7 @@ _bpftool()
                                 cgroup/post_bind4 cgroup/post_bind6 \
                                 cgroup/sysctl cgroup/getsockopt \
                                 cgroup/setsockopt struct_ops \
-                                fentry fexit freplace" -- \
+                                fentry fexit freplace xdp_egress" -- \
                                                    "$cur" ) )
                             return 0
                             ;;
@@ -1003,7 +1003,7 @@ _bpftool()
             ;;
         net)
             local PROG_TYPE='id pinned tag name'
-            local ATTACH_TYPES='xdp xdpgeneric xdpdrv xdpoffload'
+            local ATTACH_TYPES='xdp xdpgeneric xdpdrv xdpoffload xdp_egress'
             case $command in
                 show|list)
                     [[ $prev != "$command" ]] && return 0
diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index c5e3895b7c8b..dbace14e5484 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -61,6 +61,7 @@ enum net_attach_type {
 	NET_ATTACH_TYPE_XDP_GENERIC,
 	NET_ATTACH_TYPE_XDP_DRIVER,
 	NET_ATTACH_TYPE_XDP_OFFLOAD,
+	NET_ATTACH_TYPE_XDP_EGRESS,
 };
 
 static const char * const attach_type_strings[] = {
@@ -68,6 +69,7 @@ static const char * const attach_type_strings[] = {
 	[NET_ATTACH_TYPE_XDP_GENERIC]	= "xdpgeneric",
 	[NET_ATTACH_TYPE_XDP_DRIVER]	= "xdpdrv",
 	[NET_ATTACH_TYPE_XDP_OFFLOAD]	= "xdpoffload",
+	[NET_ATTACH_TYPE_XDP_EGRESS]	= "xdp_egress",
 };
 
 const size_t net_attach_type_size = ARRAY_SIZE(attach_type_strings);
@@ -286,6 +288,8 @@ static int do_attach_detach_xdp(int progfd, enum net_attach_type attach_type,
 		flags |= XDP_FLAGS_DRV_MODE;
 	if (attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
 		flags |= XDP_FLAGS_HW_MODE;
+	if (attach_type == NET_ATTACH_TYPE_XDP_EGRESS)
+		flags |= XDP_FLAGS_EGRESS_MODE;
 
 	return bpf_set_link_xdp_fd(ifindex, progfd, flags);
 }
@@ -464,7 +468,7 @@ static int do_help(int argc, char **argv)
 		"       %s %s help\n"
 		"\n"
 		"       " HELP_SPEC_PROGRAM "\n"
-		"       ATTACH_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
+		"       ATTACH_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload | xdp_egress}\n"
 		"\n"
 		"Note: Only xdp and tc attachments are supported now.\n"
 		"      For progs attached to cgroups, use \"bpftool cgroup\"\n"
diff --git a/tools/bpf/bpftool/netlink_dumper.c b/tools/bpf/bpftool/netlink_dumper.c
index 5f65140b003b..68e4909b6073 100644
--- a/tools/bpf/bpftool/netlink_dumper.c
+++ b/tools/bpf/bpftool/netlink_dumper.c
@@ -55,6 +55,8 @@ static int do_xdp_dump_one(struct nlattr *attr, unsigned int ifindex,
 		xdp_dump_prog_id(tb, IFLA_XDP_SKB_PROG_ID, "generic", true);
 		xdp_dump_prog_id(tb, IFLA_XDP_DRV_PROG_ID, "driver", true);
 		xdp_dump_prog_id(tb, IFLA_XDP_HW_PROG_ID, "offload", true);
+		xdp_dump_prog_id(tb, IFLA_XDP_EGRESS_PROG_ID,
+				 "egress", true);
 		if (json_output)
 			jsonw_end_array(json_wtr);
 	} else if (mode == XDP_ATTACHED_DRV) {
@@ -63,6 +65,9 @@ static int do_xdp_dump_one(struct nlattr *attr, unsigned int ifindex,
 		xdp_dump_prog_id(tb, IFLA_XDP_PROG_ID, "generic", false);
 	} else if (mode == XDP_ATTACHED_HW) {
 		xdp_dump_prog_id(tb, IFLA_XDP_PROG_ID, "offload", false);
+	} else if (mode == XDP_ATTACHED_EGRESS_CORE) {
+		xdp_dump_prog_id(tb, IFLA_XDP_EGRESS_PROG_ID,
+				 "egress", false);
 	}
 
 	NET_END_OBJECT_FINAL;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index f6a5974a7b0a..64695ccdcf9d 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2014,7 +2014,7 @@ static int do_help(int argc, char **argv)
 		"                 cgroup/post_bind6 | cgroup/connect4 | cgroup/connect6 |\n"
 		"                 cgroup/sendmsg4 | cgroup/sendmsg6 | cgroup/recvmsg4 |\n"
 		"                 cgroup/recvmsg6 | cgroup/getsockopt | cgroup/setsockopt |\n"
-		"                 struct_ops | fentry | fexit | freplace }\n"
+		"                 struct_ops | fentry | fexit | freplace | xdp_egress }\n"
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"
 		"       METRIC := { cycles | instructions | l1d_loads | llc_misses }\n"
-- 
2.21.1 (Apple Git-122.3)

