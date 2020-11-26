Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC982C50B3
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 09:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388873AbgKZInm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 03:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgKZInm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 03:43:42 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C47C0613D4;
        Thu, 26 Nov 2020 00:43:40 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 131so1023052pfb.9;
        Thu, 26 Nov 2020 00:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+Z3pSePklJXcs5IMElgRcq2FF0BDegclv5eVyDKRL8=;
        b=uzMIVb7Sy/IRfutNT+hp2RqRRSS5HY1p4sHmKRKAhknILN+5YB/vaoQIex0qubuhD1
         wIcjuGiDJjpp+fP3895K8B9pzLYUH7HSfWFYIpxAjND0v4kgl4gIhDvdGrkVSsfkao00
         E5gIe4jD7VpcfRkqRlIdF4QXrrR/SJVKKl+ATEgxNK7n4rbQmAAoOolZT31TpOWKEdn+
         dY8WB+8BEBYTcOzUt0x65h2yo3m2uKS2K0zvbQ5YZV1RsdsP2WDBIOZ9NZupe4CJg7ol
         ppbDAE459IO2oU9kvWz4/GyR5JsNq7GxsfIOSdxxIb54gDrmTeQ8r7oJw+Y1CyGwc5Ba
         BfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+Z3pSePklJXcs5IMElgRcq2FF0BDegclv5eVyDKRL8=;
        b=gQ9YWSrahfGbDwrPnbdoInVctUAA9dzSqaxHNhvOZqtwgHtV2/exowJZYZmapR9pV7
         eS3HAyZdtdk+ZBHyVBtaMoruWvhNkpuKAh3ggxFFIdZsuLgITqPJ7HnlZ1b94C2Rayjd
         46g10NnLpEdHkHvHcfoc7HpbAfwjdAKNG/enB+bqQUob1RLsjr4BYqdSXlEgL2GmqB9r
         c0JDkm9Okh+gk2eQ9bQmK58K4gg1Sm1hn2VbYkck5YTn8e/pEoWZ+hqHYBFlmpVLqqlE
         F6MaE/++Jpmu2NRcswx0cbW34wTNCSKPwbLrr15Zj5apJbFMLFHQwPIfoufajeco9SNl
         rKSA==
X-Gm-Message-State: AOAM533Dagx0hhx31HeMdBsMDzzZP7anjGH37MUI5CYdRRjCIAxf8OdH
        Vfee3Cbiwp8V3jd+evdTYNEHBmIOU7vjfl8Q
X-Google-Smtp-Source: ABdhPJw5Vo5zEVEP3dhq+uhZ8roLREz/sarybS27oTvJSHEJcV+m7mi3vJ+YqZBQgdPWYHKZZ1LWsg==
X-Received: by 2002:a17:90a:902:: with SMTP id n2mr2546233pjn.126.1606380219784;
        Thu, 26 Nov 2020 00:43:39 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q23sm4135298pfg.18.2020.11.26.00.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 00:43:39 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf-next] samples/bpf: add xdp program on egress for xdp_redirect_map
Date:   Thu, 26 Nov 2020 16:43:25 +0800
Message-Id: <20201126084325.477470-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110124639.1941654-1-liuhangbin@gmail.com>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current sample test xdp_redirect_map only count pkts on ingress. But we
can't know whether the pkts are redirected or dropped. So add a counter
on egress interface so we could know how many pkts are redirect in fact.

sample result:

$ ./xdp_redirect_map -X veth1 veth2
input: 5 output: 6
libbpf: elf: skipping unrecognized data section(9) .rodata.str1.16
libbpf: elf: skipping unrecognized data section(23) .eh_frame
libbpf: elf: skipping relo section(24) .rel.eh_frame for section(23) .eh_frame
in ifindex 5:          1 pkt/s, out ifindex 6:          1 pkt/s
in ifindex 5:          1 pkt/s, out ifindex 6:          1 pkt/s
in ifindex 5:          0 pkt/s, out ifindex 6:          0 pkt/s
in ifindex 5:         68 pkt/s, out ifindex 6:         68 pkt/s
in ifindex 5:         91 pkt/s, out ifindex 6:         91 pkt/s
in ifindex 5:         91 pkt/s, out ifindex 6:         91 pkt/s
in ifindex 5:         66 pkt/s, out ifindex 6:         66 pkt/s

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2:
a) use pkt counter instead of IP ttl modification on egress program
b) make the egress program selectable by option -X

---
 samples/bpf/xdp_redirect_map_kern.c |  26 +++--
 samples/bpf/xdp_redirect_map_user.c | 142 ++++++++++++++++++----------
 2 files changed, 113 insertions(+), 55 deletions(-)

diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
index 6489352ab7a4..fd6704a4f7e2 100644
--- a/samples/bpf/xdp_redirect_map_kern.c
+++ b/samples/bpf/xdp_redirect_map_kern.c
@@ -22,19 +22,19 @@
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
 	__uint(key_size, sizeof(int));
-	__uint(value_size, sizeof(int));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
 	__uint(max_entries, 100);
 } tx_port SEC(".maps");
 
-/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
- * feedback.  Redirect TX errors can be caught via a tracepoint.
+/* Count RX/TX packets, use key 0 for rx pkt count, key 1 for tx
+ * pkt count.
  */
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__type(key, u32);
 	__type(value, long);
-	__uint(max_entries, 1);
-} rxcnt SEC(".maps");
+	__uint(max_entries, 2);
+} pktcnt SEC(".maps");
 
 static void swap_src_dst_mac(void *data)
 {
@@ -72,7 +72,7 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
 	vport = 0;
 
 	/* count packet in global counter */
-	value = bpf_map_lookup_elem(&rxcnt, &key);
+	value = bpf_map_lookup_elem(&pktcnt, &key);
 	if (value)
 		*value += 1;
 
@@ -82,6 +82,20 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
 	return bpf_redirect_map(&tx_port, vport, 0);
 }
 
+SEC("xdp_devmap/map_prog")
+int xdp_devmap_prog(struct xdp_md *ctx)
+{
+	long *value;
+	u32 key = 1;
+
+	/* count packet in global counter */
+	value = bpf_map_lookup_elem(&pktcnt, &key);
+	if (value)
+		*value += 1;
+
+	return XDP_PASS;
+}
+
 /* Redirect require an XDP bpf_prog loaded on the TX device */
 SEC("xdp_redirect_dummy")
 int xdp_redirect_dummy_prog(struct xdp_md *ctx)
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index 35e16dee613e..8bdec0865e1d 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -21,12 +21,13 @@
 
 static int ifindex_in;
 static int ifindex_out;
-static bool ifindex_out_xdp_dummy_attached = true;
+static bool ifindex_out_xdp_dummy_attached = false;
+static bool xdp_prog_attached = false;
 static __u32 prog_id;
 static __u32 dummy_prog_id;
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
-static int rxcnt_map_fd;
+static int pktcnt_map_fd;
 
 static void int_exit(int sig)
 {
@@ -60,26 +61,46 @@ static void int_exit(int sig)
 	exit(0);
 }
 
-static void poll_stats(int interval, int ifindex)
+static void poll_stats(int interval, int if_ingress, int if_egress)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
-	__u64 values[nr_cpus], prev[nr_cpus];
+	__u64 values[nr_cpus], in_prev[nr_cpus], e_prev[nr_cpus];
+	__u64 sum;
+	__u32 key;
+	int i;
 
-	memset(prev, 0, sizeof(prev));
+	memset(in_prev, 0, sizeof(in_prev));
+	memset(e_prev, 0, sizeof(e_prev));
 
 	while (1) {
-		__u64 sum = 0;
-		__u32 key = 0;
-		int i;
+		sum = 0;
+		key = 0;
 
 		sleep(interval);
-		assert(bpf_map_lookup_elem(rxcnt_map_fd, &key, values) == 0);
-		for (i = 0; i < nr_cpus; i++)
-			sum += (values[i] - prev[i]);
-		if (sum)
-			printf("ifindex %i: %10llu pkt/s\n",
-			       ifindex, sum / interval);
-		memcpy(prev, values, sizeof(values));
+		if (bpf_map_lookup_elem(pktcnt_map_fd, &key, values) == 0) {
+			for (i = 0; i < nr_cpus; i++)
+				sum += (values[i] - in_prev[i]);
+			if (sum)
+				printf("in ifindex %i: %10llu pkt/s",
+				       if_ingress, sum / interval);
+			memcpy(in_prev, values, sizeof(values));
+		}
+
+		if (!xdp_prog_attached) {
+			printf("\n");
+			continue;
+		}
+
+		sum = 0;
+		key = 1;
+		if (bpf_map_lookup_elem(pktcnt_map_fd, &key, values) == 0) {
+			for (i = 0; i < nr_cpus; i++)
+				sum += (values[i] - e_prev[i]);
+			if (sum)
+				printf(", out ifindex %i: %10llu pkt/s\n",
+				       if_egress, sum / interval);
+			memcpy(e_prev, values, sizeof(values));
+		}
 	}
 }
 
@@ -90,7 +111,8 @@ static void usage(const char *prog)
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n",
+		"    -F    force loading prog\n"
+		"    -X    load xdp program on egress\n",
 		prog);
 }
 
@@ -98,13 +120,14 @@ int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type	= BPF_PROG_TYPE_XDP,
+		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
-	struct bpf_program *prog, *dummy_prog;
+	struct bpf_program *prog, *dummy_prog, *devmap_prog;
+	int prog_fd, dummy_prog_fd, devmap_prog_fd = -1;
+	struct bpf_devmap_val devmap_val;
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
-	int prog_fd, dummy_prog_fd;
-	const char *optstr = "FSN";
+	const char *optstr = "FSNX";
 	struct bpf_object *obj;
 	int ret, opt, key = 0;
 	char filename[256];
@@ -121,6 +144,9 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'X':
+			xdp_prog_attached = true;
+			break;
 		default:
 			usage(basename(argv[0]));
 			return 1;
@@ -157,23 +183,14 @@ int main(int argc, char **argv)
 		return 1;
 
 	prog = bpf_program__next(NULL, obj);
-	dummy_prog = bpf_program__next(prog, obj);
-	if (!prog || !dummy_prog) {
-		printf("finding a prog in obj file failed\n");
-		return 1;
-	}
-	/* bpf_prog_load_xattr gives us the pointer to first prog's fd,
-	 * so we're missing only the fd for dummy prog
-	 */
-	dummy_prog_fd = bpf_program__fd(dummy_prog);
-	if (prog_fd < 0 || dummy_prog_fd < 0) {
-		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
+	if (!prog || prog_fd <0) {
+		printf("finding prog in obj file failed\n");
 		return 1;
 	}
 
 	tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port");
-	rxcnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rxcnt");
-	if (tx_port_map_fd < 0 || rxcnt_map_fd < 0) {
+	pktcnt_map_fd = bpf_object__find_map_fd_by_name(obj, "pktcnt");
+	if (tx_port_map_fd < 0 || pktcnt_map_fd < 0) {
 		printf("bpf_object__find_map_fd_by_name failed\n");
 		return 1;
 	}
@@ -190,32 +207,59 @@ int main(int argc, char **argv)
 	}
 	prog_id = info.id;
 
-	/* Loading dummy XDP prog on out-device */
-	if (bpf_set_link_xdp_fd(ifindex_out, dummy_prog_fd,
-			    (xdp_flags | XDP_FLAGS_UPDATE_IF_NOEXIST)) < 0) {
-		printf("WARN: link set xdp fd failed on %d\n", ifindex_out);
-		ifindex_out_xdp_dummy_attached = false;
-	}
+	/* Loading dummy XDP prog on out-device if no xdp_prog_attached*/
+	if (xdp_prog_attached) {
+		devmap_prog = bpf_object__find_program_by_title(obj, "xdp_devmap/map_prog");
+		if (!devmap_prog) {
+			printf("finding devmap_prog in obj file failed\n");
+			return 1;
+		}
+		devmap_prog_fd = bpf_program__fd(devmap_prog);
+		if (devmap_prog_fd < 0) {
+			printf("find devmap_prog fd: %s\n", strerror(errno));
+			return 1;
+		}
+	} else {
+		dummy_prog = bpf_object__find_program_by_title(obj, "xdp_redirect_dummy");
+		if (!dummy_prog) {
+			printf("finding dummy_prog in obj file failed\n");
+			return 1;
+		}
 
-	memset(&info, 0, sizeof(info));
-	ret = bpf_obj_get_info_by_fd(dummy_prog_fd, &info, &info_len);
-	if (ret) {
-		printf("can't get prog info - %s\n", strerror(errno));
-		return ret;
+		dummy_prog_fd = bpf_program__fd(dummy_prog);
+		if (dummy_prog_fd < 0) {
+			printf("find dummy_prog fd: %s\n", strerror(errno));
+			return 1;
+		}
+
+		if (bpf_set_link_xdp_fd(ifindex_out, dummy_prog_fd,
+				    (xdp_flags | XDP_FLAGS_UPDATE_IF_NOEXIST)) == 0) {
+			ifindex_out_xdp_dummy_attached = true;
+		} else {
+			printf("WARN: link set xdp fd failed on %d\n", ifindex_out);
+		}
+
+		memset(&info, 0, sizeof(info));
+		ret = bpf_obj_get_info_by_fd(dummy_prog_fd, &info, &info_len);
+		if (ret) {
+			printf("can't get prog info - %s\n", strerror(errno));
+			return ret;
+		}
+		dummy_prog_id = info.id;
 	}
-	dummy_prog_id = info.id;
 
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	/* populate virtual to physical port map */
-	ret = bpf_map_update_elem(tx_port_map_fd, &key, &ifindex_out, 0);
+	devmap_val.ifindex = ifindex_out;
+	devmap_val.bpf_prog.fd = devmap_prog_fd;
+	ret = bpf_map_update_elem(tx_port_map_fd, &key, &devmap_val, 0);
 	if (ret) {
-		perror("bpf_update_elem");
+		perror("bpf_update_elem tx_port_map_fd");
 		goto out;
 	}
 
-	poll_stats(2, ifindex_out);
+	poll_stats(2, ifindex_in, ifindex_out);
 
 out:
 	return 0;
-- 
2.26.2

