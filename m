Return-Path: <netdev+bounces-9027-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A23D47269C9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9E44281521
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C718239234;
	Wed,  7 Jun 2023 19:26:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32DC3AE57;
	Wed,  7 Jun 2023 19:26:42 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A090E1FE5;
	Wed,  7 Jun 2023 12:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=wImN2gNVIaAxBr996GcZPrEDvIGGjR73g61EtbQB69U=; b=LCNOuM4DxTMnT32nkJASTTlz+P
	9YxDZpTbYNdT3lGocJol9k+EG8p5fxcTcjWqNl14fAUZO/13xUtv9Py4r09TQdKr5q+vbNJIhrjcD
	vG+uCHb8QUs7dphlqojp50MbQmFhdChk0Exfnb2hQdnn2awWltfji42bJOwg4nJO2HS15mZfS8kaU
	Tqh57W/Jr3M7UGuv9ZwAnJcoIH+XMkKleHow/9ffinLa23RAG233cZMrDaz4L1lyL2TZGLQTDVI65
	VYfut8Sk5pwmAR3rlH5OdYbcWBiLQmpwm8nljbvgdB3RqkRiII60/9IGyEMUaoWwCxsx0s9oTSCC4
	NuLtavRA==;
Received: from 49.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.49] helo=localhost)
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q6ynl-000CYc-N1; Wed, 07 Jun 2023 21:26:37 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
To: ast@kernel.org
Cc: andrii@kernel.org,
	martin.lau@linux.dev,
	razor@blackwall.org,
	sdf@google.com,
	john.fastabend@gmail.com,
	kuba@kernel.org,
	dxu@dxuuu.xyz,
	joe@cilium.io,
	toke@kernel.org,
	davem@davemloft.net,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 5/7] bpftool: Extend net dump with tcx progs
Date: Wed,  7 Jun 2023 21:26:23 +0200
Message-Id: <20230607192625.22641-6-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230607192625.22641-1-daniel@iogearbox.net>
References: <20230607192625.22641-1-daniel@iogearbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26931/Wed Jun  7 09:23:57 2023)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support to dump fd-based attach types via bpftool. This includes both
the tc BPF link and attach ops programs. Dumped information contain the
attach location, function entry name, program ID and link ID when applicable.

Example with tc BPF link:

  # ./bpftool net
  xdp:

  tc:
  bond0(4) bpf/ingress cil_from_netdev prog id 784 link id 10
  bond0(4) bpf/egress cil_to_netdev prog id 804 link id 11

  flow_dissector:

  netfilter:

Example with tc BPF attach ops:

  # ./bpftool net
  xdp:

  tc:
  bond0(4) bpf/ingress cil_from_netdev prog id 654
  bond0(4) bpf/egress cil_to_netdev prog id 672

  flow_dissector:

  netfilter:

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/bpf/bpftool/net.c | 92 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 26a49965bf71..b23b346b3ae9 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -76,6 +76,11 @@ static const char * const attach_type_strings[] = {
 	[NET_ATTACH_TYPE_XDP_OFFLOAD]	= "xdpoffload",
 };
 
+static const char * const attach_loc_strings[] = {
+	[BPF_TCX_INGRESS]		= "bpf/ingress",
+	[BPF_TCX_EGRESS]		= "bpf/egress",
+};
+
 const size_t net_attach_type_size = ARRAY_SIZE(attach_type_strings);
 
 static enum net_attach_type parse_attach_type(const char *str)
@@ -422,8 +427,86 @@ static int dump_filter_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 			      filter_info->devname, filter_info->ifindex);
 }
 
-static int show_dev_tc_bpf(int sock, unsigned int nl_pid,
-			   struct ip_devname_ifindex *dev)
+static const char *flags_strings(__u32 flags)
+{
+	if (flags == (BPF_F_FIRST | BPF_F_LAST))
+		return json_output ? "first,last" : " first last";
+	if (flags & BPF_F_FIRST)
+		return json_output ? "first" : " first";
+	if (flags & BPF_F_LAST)
+		return json_output ? "last" : " last";
+	return json_output ? "none" : "";
+}
+
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
+	if (info.name[0]) {
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
+	__u32 prog_flags[64] = {}, link_flags[64] = {}, i;
+	__u32 prog_ids[64] = {}, link_ids[64] = {};
+	LIBBPF_OPTS(bpf_prog_query_opts, optq);
+	char prog_name[MAX_PROG_FULL_NAME];
+	int ret;
+
+	optq.prog_ids = prog_ids;
+	optq.prog_attach_flags = prog_flags;
+	optq.link_ids = link_ids;
+	optq.link_attach_flags = link_flags;
+	optq.count = ARRAY_SIZE(prog_ids);
+
+	ret = bpf_prog_query_opts(dev->ifindex, loc, &optq);
+	if (ret)
+		return;
+	for (i = 0; i < optq.count; i++) {
+		NET_START_OBJECT;
+		NET_DUMP_STR("devname", "%s", dev->devname);
+		NET_DUMP_UINT("ifindex", "(%u)", dev->ifindex);
+		NET_DUMP_STR("kind", " %s", attach_loc_strings[loc]);
+		ret = __show_dev_tc_bpf_name(prog_ids[i], prog_name,
+					     sizeof(prog_name));
+		if (!ret)
+			NET_DUMP_STR("name", " %s", prog_name);
+		NET_DUMP_UINT("prog_id", " prog id %u", prog_ids[i]);
+		if (prog_flags[i])
+			NET_DUMP_STR("prog_flags", "%s", flags_strings(prog_flags[i]));
+		if (link_ids[i])
+			NET_DUMP_UINT("link_id", " link id %u",
+				      link_ids[i]);
+		if (link_flags[i])
+			NET_DUMP_STR("link_flags", "%s", flags_strings(link_flags[i]));
+		NET_END_OBJECT_FINAL;
+	}
+}
+
+static void show_dev_tc_bpf(struct ip_devname_ifindex *dev)
+{
+	__show_dev_tc_bpf(dev, BPF_TCX_INGRESS);
+	__show_dev_tc_bpf(dev, BPF_TCX_EGRESS);
+}
+
+static int show_dev_tc_bpf_classic(int sock, unsigned int nl_pid,
+				   struct ip_devname_ifindex *dev)
 {
 	struct bpf_filter_t filter_info;
 	struct bpf_tcinfo_t tcinfo;
@@ -790,8 +873,9 @@ static int do_show(int argc, char **argv)
 	if (!ret) {
 		NET_START_ARRAY("tc", "%s:\n");
 		for (i = 0; i < dev_array.used_len; i++) {
-			ret = show_dev_tc_bpf(sock, nl_pid,
-					      &dev_array.devices[i]);
+			show_dev_tc_bpf(&dev_array.devices[i]);
+			ret = show_dev_tc_bpf_classic(sock, nl_pid,
+						      &dev_array.devices[i]);
 			if (ret)
 				break;
 		}
-- 
2.34.1


