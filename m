Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848E15F4C88
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 01:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJDXM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 19:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiJDXMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 19:12:13 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B1C543DE;
        Tue,  4 Oct 2022 16:12:12 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ofr59-000AKB-8d; Wed, 05 Oct 2022 01:12:11 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 09/10] bpftool: Add support for tc fd-based attach types
Date:   Wed,  5 Oct 2022 01:11:42 +0200
Message-Id: <20221004231143.19190-10-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221004231143.19190-1-daniel@iogearbox.net>
References: <20221004231143.19190-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26679/Tue Oct  4 09:56:50 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to dump fd-based attach types via bpftool. This includes both
the tc BPF link and attach ops programs. Dumped information contain the
attach location, function entry name, program ID, link ID when applicable
as well as the attach priority.

Example with tc BPF link:

  # ./bpftool net
  xdp:

  tc:
  lo(1) bpf/ingress tc_handler_in id 189 link 40 prio 1
  lo(1) bpf/egress tc_handler_eg id 190 link 39 prio 1

  flow_dissector:

Example with tc BPF attach ops and also one instance of old-style cls_bpf:

  # ./bpftool net
  xdp:

  tc:
  lo(1) bpf/ingress tc_handler_in id 201 prio 1
  lo(1) clsact/ingress tc_handler_old:[203] id 203

  flow_dissector:

Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/bpf/bpftool/net.c | 76 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 526a332c48e6..06658978b092 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -74,6 +74,11 @@ static const char * const attach_type_strings[] = {
 	[NET_ATTACH_TYPE_XDP_OFFLOAD]	= "xdpoffload",
 };
 
+static const char * const attach_loc_strings[] = {
+	[BPF_NET_INGRESS]		= "bpf/ingress",
+	[BPF_NET_EGRESS]		= "bpf/egress",
+};
+
 const size_t net_attach_type_size = ARRAY_SIZE(attach_type_strings);
 
 static enum net_attach_type parse_attach_type(const char *str)
@@ -420,8 +425,69 @@ static int dump_filter_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 			      filter_info->devname, filter_info->ifindex);
 }
 
-static int show_dev_tc_bpf(int sock, unsigned int nl_pid,
-			   struct ip_devname_ifindex *dev)
+static int __show_dev_tc_bpf_name(__u32 id, char *name, size_t len)
+{
+	struct bpf_prog_info info = {};
+	__u32 ilen = sizeof(info);
+	int fd, ret;
+
+	fd = bpf_prog_get_fd_by_id(id);
+	if (fd < 0)
+		return fd;
+	ret = bpf_obj_get_info_by_fd(fd, &info, &ilen);
+	if (ret < 0)
+		goto out;
+	ret = -ENOENT;
+	if (info.name) {
+		get_prog_full_name(&info, fd, name, len);
+		ret = 0;
+	}
+out:
+	close(fd);
+	return ret;
+}
+
+static void __show_dev_tc_bpf(const struct ip_devname_ifindex *dev,
+			      const enum bpf_attach_type loc)
+{
+	__u32 i, prog_cnt, attach_flags = 0;
+	char prog_name[MAX_PROG_FULL_NAME];
+	struct bpf_query_info progs[64];
+	int ret;
+
+	memset(progs, 0, sizeof(progs));
+	prog_cnt = ARRAY_SIZE(progs);
+	ret = bpf_prog_query(dev->ifindex, loc, 0, &attach_flags,
+			     progs, &prog_cnt);
+	if (ret)
+		return;
+	for (i = 0; i < prog_cnt; i++) {
+		NET_START_OBJECT;
+		NET_DUMP_STR("devname", "%s", dev->devname);
+		NET_DUMP_UINT("ifindex", "(%u)", dev->ifindex);
+		NET_DUMP_STR("kind", " %s", attach_loc_strings[loc]);
+		ret = __show_dev_tc_bpf_name(progs[i].prog_id,
+					     prog_name,
+					     sizeof(prog_name));
+		if (!ret)
+			NET_DUMP_STR("name", " %s", prog_name);
+		NET_DUMP_UINT("id", " id %u", progs[i].prog_id);
+		if (progs[i].link_id)
+			NET_DUMP_UINT("link", " link %u",
+				      progs[i].link_id);
+		NET_DUMP_UINT("prio", " prio %u", progs[i].prio);
+		NET_END_OBJECT_FINAL;
+	}
+}
+
+static void show_dev_tc_bpf(struct ip_devname_ifindex *dev)
+{
+	__show_dev_tc_bpf(dev, BPF_NET_INGRESS);
+	__show_dev_tc_bpf(dev, BPF_NET_EGRESS);
+}
+
+static int show_dev_tc_bpf_legacy(int sock, unsigned int nl_pid,
+				  struct ip_devname_ifindex *dev)
 {
 	struct bpf_filter_t filter_info;
 	struct bpf_tcinfo_t tcinfo;
@@ -686,8 +752,10 @@ static int do_show(int argc, char **argv)
 	if (!ret) {
 		NET_START_ARRAY("tc", "%s:\n");
 		for (i = 0; i < dev_array.used_len; i++) {
-			ret = show_dev_tc_bpf(sock, nl_pid,
-					      &dev_array.devices[i]);
+			show_dev_tc_bpf(&dev_array.devices[i]);
+
+			ret = show_dev_tc_bpf_legacy(sock, nl_pid,
+						     &dev_array.devices[i]);
 			if (ret)
 				break;
 		}
-- 
2.34.1

