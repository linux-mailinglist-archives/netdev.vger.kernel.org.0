Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965F0573534
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiGMLSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbiGMLS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:18:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9180BF5116
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657711106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDuTtgPYXERcYe6YSrw64YmlYChWKjHDpeR4it4TBh0=;
        b=cfYIunHcx/lRCCUjPuBoQ1mDXnmTKFwRtT9S9lV+fUiAUfNr5N3d6XxyiR7wIFNN7vfYI1
        RpDwcIu6kG95FjdOLkXUy2ftJxMKo0MQq4l+YjhO+yWuujxKONc3HIt22KLkXo/tzpDxy4
        pAKmCJxANIzmY5qYwGeZA/3oC3PS8pE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-cGCtARgkM3SO2IOeOwHF1g-1; Wed, 13 Jul 2022 07:18:25 -0400
X-MC-Unique: cGCtARgkM3SO2IOeOwHF1g-1
Received: by mail-ej1-f71.google.com with SMTP id nc23-20020a1709071c1700b0072b94109144so765856ejc.2
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BDuTtgPYXERcYe6YSrw64YmlYChWKjHDpeR4it4TBh0=;
        b=OXqplW+rZubiiWcLlutHKe/CMJmPhEtpO4mIGgTsiOeDLct0Vnf2mbFWwfoqu7g2GM
         kFtvcSR8mHd/8fkJKJfMerw93hVmvQEgjjxh2uQmevLy1TEpLNMnNONjVRAbx/j6vvlK
         AREpk0q8A1iScBNziFC1kp09fQbv8QKqCGsnnQn69Pi8HwKqRmQuMOaVK2cyLHVmnV0Z
         1zKDhsjEdbnWJanWLw0ZtSNdsL1zFFSIA9YPFhGva4VfHQTXuMbCk/O/QakpQp2eCZ3t
         LZ5Xwav+9MVLdYRFiA3sgwwR2gETfIgPi3QGsMt5OxTrTp3HkGOFZLzd1CM5cY36J6d0
         IbGg==
X-Gm-Message-State: AJIora+Rcem/om8F2ao0CNpQec+FfU4xreovOFY5Dchwtjww2ncq/n/X
        VZT0lm33azbaCFTGGAa7d800LnWTrfZoKSVoQZ8bsZpNwSteI6aQlVRMS7+liruQnEnoQ5tNNeG
        lZN3x/lVxUTU+PtJy
X-Received: by 2002:a17:907:7b92:b0:72b:67fb:8985 with SMTP id ne18-20020a1709077b9200b0072b67fb8985mr2760321ejc.569.1657711104138;
        Wed, 13 Jul 2022 04:18:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sXNO5rg/tDHkU+OLM52NxMejHM8BDcFzfxdTh7py1+Z9YBRZeZ/+C2bPXp9t6qVrBQAFx22g==
X-Received: by 2002:a17:907:7b92:b0:72b:67fb:8985 with SMTP id ne18-20020a1709077b9200b0072b67fb8985mr2760280ejc.569.1657711103712;
        Wed, 13 Jul 2022 04:18:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b4-20020a17090630c400b006fe0abb00f0sm4839488ejb.209.2022.07.13.04.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:18:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 210254D9920; Wed, 13 Jul 2022 13:14:41 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC PATCH 17/17] samples/bpf: Add queueing support to xdp_fwd sample
Date:   Wed, 13 Jul 2022 13:14:25 +0200
Message-Id: <20220713111430.134810-18-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for queueing packets before forwarding them to the xdp_fwd
sample. This is meant to serve as an example (for the RFC series) of how
one could add queueing to a forwarding application. It doesn't actually
implement any fancy queueing algorithms, it just uses the queue maps to do
simple FIFO queueing, instantiating one queue map per interface.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 samples/bpf/xdp_fwd_kern.c |  65 +++++++++++-
 samples/bpf/xdp_fwd_user.c | 200 +++++++++++++++++++++++++++----------
 2 files changed, 205 insertions(+), 60 deletions(-)

diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
index 54c099cbd639..125adb02c658 100644
--- a/samples/bpf/xdp_fwd_kern.c
+++ b/samples/bpf/xdp_fwd_kern.c
@@ -23,6 +23,14 @@
 
 #define IPV6_FLOWINFO_MASK              cpu_to_be32(0x0FFFFFFF)
 
+struct pifo_map {
+	__uint(type, BPF_MAP_TYPE_PIFO_XDP);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+	__uint(max_entries, 1024);
+	__uint(map_extra, 8192); /* range */
+} pmap SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
 	__uint(key_size, sizeof(int));
@@ -30,6 +38,13 @@ struct {
 	__uint(max_entries, 64);
 } xdp_tx_ports SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(key_size, sizeof(__u32));
+	__uint(max_entries, 64);
+	__array(values, struct pifo_map);
+} pifo_maps SEC(".maps");
+
 /* from include/net/ip.h */
 static __always_inline int ip_decrease_ttl(struct iphdr *iph)
 {
@@ -40,7 +55,7 @@ static __always_inline int ip_decrease_ttl(struct iphdr *iph)
 	return --iph->ttl;
 }
 
-static __always_inline int xdp_fwd_flags(struct xdp_md *ctx, u32 flags)
+static __always_inline int xdp_fwd_flags(struct xdp_md *ctx, u32 flags, bool queue)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data = (void *)(long)ctx->data;
@@ -137,22 +152,62 @@ static __always_inline int xdp_fwd_flags(struct xdp_md *ctx, u32 flags)
 
 		memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
 		memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
+
+		if (queue) {
+			void *ptr;
+			int ret;
+
+			ptr = bpf_map_lookup_elem(&pifo_maps, &fib_params.ifindex);
+			if (!ptr)
+				return XDP_DROP;
+
+			ret = bpf_redirect_map(ptr, 0, 0);
+			if (ret == XDP_REDIRECT)
+				bpf_schedule_iface_dequeue(ctx, fib_params.ifindex, 0);
+			return ret;
+		}
+
 		return bpf_redirect_map(&xdp_tx_ports, fib_params.ifindex, 0);
 	}
 
 	return XDP_PASS;
 }
 
-SEC("xdp_fwd")
+SEC("xdp")
 int xdp_fwd_prog(struct xdp_md *ctx)
 {
-	return xdp_fwd_flags(ctx, 0);
+	return xdp_fwd_flags(ctx, 0, false);
 }
 
-SEC("xdp_fwd_direct")
+SEC("xdp")
 int xdp_fwd_direct_prog(struct xdp_md *ctx)
 {
-	return xdp_fwd_flags(ctx, BPF_FIB_LOOKUP_DIRECT);
+	return xdp_fwd_flags(ctx, BPF_FIB_LOOKUP_DIRECT, false);
+}
+
+SEC("xdp")
+int xdp_fwd_queue(struct xdp_md *ctx)
+{
+	return xdp_fwd_flags(ctx, 0, true);
+}
+
+SEC("dequeue")
+void *xdp_dequeue(struct dequeue_ctx *ctx)
+{
+	__u32 ifindex = ctx->egress_ifindex;
+	struct xdp_md *pkt;
+	__u64 prio = 0;
+	void *pifo_ptr;
+
+	pifo_ptr = bpf_map_lookup_elem(&pifo_maps, &ifindex);
+	if (!pifo_ptr)
+		return NULL;
+
+	pkt = (void *)bpf_packet_dequeue(ctx, pifo_ptr, 0, &prio);
+	if (!pkt)
+		return NULL;
+
+	return pkt;
 }
 
 char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index 84f57f1209ce..ec3f29d0babe 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -11,6 +11,7 @@
  * General Public License for more details.
  */
 
+#include "linux/if_link.h"
 #include <linux/bpf.h>
 #include <linux/if_link.h>
 #include <linux/limits.h>
@@ -29,66 +30,122 @@
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 
-static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+const char *redir_prog_names[] = {
+	"xdp_fwd_prog",
+	"xdp_fwd_direct_", /* name truncated to BPF_OBJ_NAME_LEN */
+	"xdp_fwd_queue",
+};
+
+const char *dequeue_prog_names[] = {
+	"xdp_dequeue"
+};
+
+static int do_attach(int idx, int redir_prog_fd, int dequeue_prog_fd,
+		     int redir_map_fd, int pifos_map_fd, const char *name)
 {
 	int err;
 
-	err = bpf_xdp_attach(idx, prog_fd, xdp_flags, NULL);
+	if (pifos_map_fd > -1) {
+		LIBBPF_OPTS(bpf_map_create_opts, map_opts, .map_extra = 8192);
+		char map_name[BPF_OBJ_NAME_LEN];
+		int pifo_fd;
+
+		snprintf(map_name, sizeof(map_name), "pifo_%d", idx);
+		map_name[BPF_OBJ_NAME_LEN - 1] = '\0';
+
+		pifo_fd = bpf_map_create(BPF_MAP_TYPE_PIFO_XDP, map_name,
+					 sizeof(__u32), sizeof(__u32), 10240, &map_opts);
+		if (pifo_fd < 0) {
+			err = -errno;
+			printf("ERROR: Couldn't create PIFO map: %s\n", strerror(-err));
+			return err;
+		}
+
+		err = bpf_map_update_elem(pifos_map_fd, &idx, &pifo_fd, 0);
+		if (err)
+			printf("ERROR: failed adding PIFO map for device %s\n", name);
+	}
+
+	if (dequeue_prog_fd > -1) {
+		LIBBPF_OPTS(bpf_xdp_attach_opts, prog_opts, .old_prog_fd = -1);
+
+		err = bpf_xdp_attach(idx, dequeue_prog_fd,
+				     (XDP_FLAGS_DEQUEUE_MODE | XDP_FLAGS_REPLACE),
+				     &prog_opts);
+		if (err < 0) {
+			printf("ERROR: failed to attach dequeue program to %s\n", name);
+			return err;
+		}
+	}
+
+	err = bpf_xdp_attach(idx, redir_prog_fd, xdp_flags, NULL);
 	if (err < 0) {
-		printf("ERROR: failed to attach program to %s\n", name);
+		printf("ERROR: failed to attach redir program to %s\n", name);
 		return err;
 	}
 
 	/* Adding ifindex as a possible egress TX port */
-	err = bpf_map_update_elem(map_fd, &idx, &idx, 0);
+	err = bpf_map_update_elem(redir_map_fd, &idx, &idx, 0);
 	if (err)
 		printf("ERROR: failed using device %s as TX-port\n", name);
 
 	return err;
 }
 
+static bool should_detach(__u32 prog_fd, const char **prog_names, int num_prog_names)
+{
+	struct bpf_prog_info prog_info = {};
+	__u32 info_len = sizeof(prog_info);
+	int err, i;
+
+	err = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &info_len);
+	if (err) {
+		printf("ERROR: bpf_obj_get_info_by_fd failed (%s)\n",
+		       strerror(errno));
+		return false;
+	}
+
+	for (i = 0; i < num_prog_names; i++)
+		if (!strcmp(prog_info.name, prog_names[i]))
+			return true;
+
+	return false;
+}
+
 static int do_detach(int ifindex, const char *ifname, const char *app_name)
 {
 	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
-	struct bpf_prog_info prog_info = {};
-	char prog_name[BPF_OBJ_NAME_LEN];
-	__u32 info_len, curr_prog_id;
-	int prog_fd;
-	int err = 1;
+	LIBBPF_OPTS(bpf_xdp_query_opts, query_opts);
+	int prog_fd, err = 1;
+	__u32 curr_prog_id;
 
-	if (bpf_xdp_query_id(ifindex, xdp_flags, &curr_prog_id)) {
+	if (bpf_xdp_query(ifindex, xdp_flags, &query_opts)) {
 		printf("ERROR: bpf_xdp_query_id failed (%s)\n",
 		       strerror(errno));
 		return err;
 	}
 
+	curr_prog_id = (xdp_flags & XDP_FLAGS_SKB_MODE) ? query_opts.skb_prog_id
+								: query_opts.drv_prog_id;
 	if (!curr_prog_id) {
 		printf("ERROR: flags(0x%x) xdp prog is not attached to %s\n",
 		       xdp_flags, ifname);
 		return err;
 	}
 
-	info_len = sizeof(prog_info);
 	prog_fd = bpf_prog_get_fd_by_id(curr_prog_id);
 	if (prog_fd < 0) {
 		printf("ERROR: bpf_prog_get_fd_by_id failed (%s)\n",
 		       strerror(errno));
-		return prog_fd;
-	}
-
-	err = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &info_len);
-	if (err) {
-		printf("ERROR: bpf_obj_get_info_by_fd failed (%s)\n",
-		       strerror(errno));
-		goto close_out;
+		return err;
 	}
-	snprintf(prog_name, sizeof(prog_name), "%s_prog", app_name);
-	prog_name[BPF_OBJ_NAME_LEN - 1] = '\0';
 
-	if (strcmp(prog_info.name, prog_name)) {
+	if (!should_detach(prog_fd, redir_prog_names, ARRAY_SIZE(redir_prog_names))) {
 		printf("ERROR: %s isn't attached to %s\n", app_name, ifname);
-		err = 1;
-		goto close_out;
+		close(prog_fd);
+		return 1;
 	}
 
 	opts.old_prog_fd = prog_fd;
@@ -96,11 +153,34 @@ static int do_detach(int ifindex, const char *ifname, const char *app_name)
 	if (err < 0)
 		printf("ERROR: failed to detach program from %s (%s)\n",
 		       ifname, strerror(errno));
-	/* TODO: Remember to cleanup map, when adding use of shared map
+
+	close(prog_fd);
+
+	if (query_opts.dequeue_prog_id) {
+		prog_fd = bpf_prog_get_fd_by_id(query_opts.dequeue_prog_id);
+		if (prog_fd < 0) {
+			printf("ERROR: bpf_prog_get_fd_by_id failed (%s)\n",
+			       strerror(errno));
+			return err;
+		}
+
+		if (!should_detach(prog_fd, dequeue_prog_names, ARRAY_SIZE(dequeue_prog_names))) {
+			close(prog_fd);
+			return err;
+		}
+
+		opts.old_prog_fd = prog_fd;
+		err = bpf_xdp_detach(ifindex,
+				     (XDP_FLAGS_DEQUEUE_MODE | XDP_FLAGS_REPLACE),
+				     &opts);
+		if (err < 0)
+			printf("ERROR: failed to detach dequeue program from %s (%s)\n",
+			       ifname, strerror(errno));
+	}
+
+	/* todo: Remember to cleanup map, when adding use of shared map
 	 *  bpf_map_delete_elem((map_fd, &idx);
 	 */
-close_out:
-	close(prog_fd);
 	return err;
 }
 
@@ -112,24 +192,23 @@ static void usage(const char *prog)
 		"    -d    detach program\n"
 		"    -S    use skb-mode\n"
 		"    -F    force loading prog\n"
-		"    -D    direct table lookups (skip fib rules)\n",
+		"    -D    direct table lookups (skip fib rules)\n"
+		"    -Q    direct table lookups (skip fib rules)\n",
 		prog);
 }
 
 int main(int argc, char **argv)
 {
-	const char *prog_name = "xdp_fwd";
-	struct bpf_program *prog = NULL;
-	struct bpf_program *pos;
-	const char *sec_name;
-	int prog_fd = -1, map_fd = -1;
+	int redir_prog_fd = -1, dequeue_prog_fd = -1, redir_map_fd = -1, pifos_map_fd = -1;
+	const char *prog_name = "xdp_fwd_prog";
 	char filename[PATH_MAX];
 	struct bpf_object *obj;
 	int opt, i, idx, err;
+	bool queue = false;
 	int attach = 1;
 	int ret = 0;
 
-	while ((opt = getopt(argc, argv, ":dDSF")) != -1) {
+	while ((opt = getopt(argc, argv, ":dDQSF")) != -1) {
 		switch (opt) {
 		case 'd':
 			attach = 0;
@@ -141,7 +220,11 @@ int main(int argc, char **argv)
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
 		case 'D':
-			prog_name = "xdp_fwd_direct";
+			prog_name = "xdp_fwd_direct_prog";
+			break;
+		case 'Q':
+			prog_name = "xdp_fwd_queue";
+			queue = true;
 			break;
 		default:
 			usage(basename(argv[0]));
@@ -170,9 +253,6 @@ int main(int argc, char **argv)
 		if (libbpf_get_error(obj))
 			return 1;
 
-		prog = bpf_object__next_program(obj, NULL);
-		bpf_program__set_type(prog, BPF_PROG_TYPE_XDP);
-
 		err = bpf_object__load(obj);
 		if (err) {
 			printf("Does kernel support devmap lookup?\n");
@@ -181,25 +261,34 @@ int main(int argc, char **argv)
 			 */
 			return 1;
 		}
-
-		bpf_object__for_each_program(pos, obj) {
-			sec_name = bpf_program__section_name(pos);
-			if (sec_name && !strcmp(sec_name, prog_name)) {
-				prog = pos;
-				break;
-			}
-		}
-		prog_fd = bpf_program__fd(prog);
-		if (prog_fd < 0) {
-			printf("program not found: %s\n", strerror(prog_fd));
+		redir_prog_fd = bpf_program__fd(bpf_object__find_program_by_name(obj,
+										 prog_name));
+		if (redir_prog_fd < 0) {
+			printf("program not found: %s\n", strerror(redir_prog_fd));
 			return 1;
 		}
-		map_fd = bpf_map__fd(bpf_object__find_map_by_name(obj,
-							"xdp_tx_ports"));
-		if (map_fd < 0) {
-			printf("map not found: %s\n", strerror(map_fd));
+
+		redir_map_fd = bpf_map__fd(bpf_object__find_map_by_name(obj,
+									"xdp_tx_ports"));
+		if (redir_map_fd < 0) {
+			printf("map not found: %s\n", strerror(redir_map_fd));
 			return 1;
 		}
+
+		if (queue) {
+			dequeue_prog_fd = bpf_program__fd(bpf_object__find_program_by_name(obj,
+											   "xdp_dequeue"));
+			if (dequeue_prog_fd < 0) {
+				printf("dequeue program not found: %s\n",
+				       strerror(-dequeue_prog_fd));
+				return 1;
+			}
+			pifos_map_fd = bpf_map__fd(bpf_object__find_map_by_name(obj, "pifo_maps"));
+			if (pifos_map_fd < 0) {
+				printf("map not found: %s\n", strerror(-pifos_map_fd));
+				return 1;
+			}
+		}
 	}
 
 	for (i = optind; i < argc; ++i) {
@@ -212,11 +301,12 @@ int main(int argc, char **argv)
 			return 1;
 		}
 		if (!attach) {
-			err = do_detach(idx, argv[i], prog_name);
+			err = do_detach(idx, argv[i], argv[0]);
 			if (err)
 				ret = err;
 		} else {
-			err = do_attach(idx, prog_fd, map_fd, argv[i]);
+			err = do_attach(idx, redir_prog_fd, dequeue_prog_fd,
+					redir_map_fd, pifos_map_fd, argv[i]);
 			if (err)
 				ret = err;
 		}
-- 
2.37.0

