Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852622AD6C5
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 13:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732282AbgKJMrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 07:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbgKJMrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 07:47:24 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1457BC0613CF;
        Tue, 10 Nov 2020 04:47:24 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 10so11345707pfp.5;
        Tue, 10 Nov 2020 04:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wXb3S0NHBW2APUjRFZh4ooHea0Q6od7gHg0qMEvNfbM=;
        b=tglwijZ7+XZuppYbRlzs44d3cKtnW0tyRsQlJFZpll7bNZ9HYc8m7NPVldaxNlEtHe
         jjS+MOOaHyZ4VFmaqPtGYido9Od/fY3PdgK0HUKM8Lq1U+N8JAZluS2ReebBI9clVWom
         vzbXc9uBbmV6Feo/6DmQIrs1kjvO2UVb9h20M8zi4vhJvTON/TEaW+IzRn34MPM62oca
         GMQfgTCiSNajLXma0nUnJENKRq8pxBB9188SHXBTIZLQ7/vfJZBOFYpn4ZJJlwbiEOBU
         2RXvUkWh+TjIRl37DdMJoeBRqmKCMJjnGlrcDvIaW2x8hhCsEYZieoIeNydjupVheZla
         kaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wXb3S0NHBW2APUjRFZh4ooHea0Q6od7gHg0qMEvNfbM=;
        b=Gyr7PhdmPNBBlpPl2tecOInifwl99qXRTw9RR4fKp1ZRBJ29SfJXZXH0IqPlVMiMsy
         VnBrGdP+11UBuZemjKDIXMgynCr8jhb0mnzMdORu/CckrXuzmsrMwK7sFrVZ4ba92U+u
         PokRE6lU+sq1hYDATDgCoE6K5yi3ni30r4kMmLb3yUCfLc1h25e/dZhLzh5olORmaro5
         Crq5HPoHcs5VPwZZm0w50trdsM3vlQ5w4agFcIM8zDj+fEPqza3UYyxyywuPpIBWUeZq
         iq/yp5aApfHUYlqwZyOl95FzneXCT+cpnIHhb4gVj4N9t7/ybZ6pJY1jnppdhuexzuKY
         2IBg==
X-Gm-Message-State: AOAM5335UgX22t7nzblZO26IWCYVsnpJJeVX+hXmt9uv9V/SiPD4+43/
        3yNSLeLe+u4EIXLNcnfcuHnWux4SNREI4g==
X-Google-Smtp-Source: ABdhPJza7GPXinPQQ9oK7TI6hrW+kumvbjrWNjkbZxK6uJUNsq8vA0Enjf1h77gb58ATQsZnNHofRg==
X-Received: by 2002:aa7:8d14:0:b029:18b:8e8d:81e8 with SMTP id j20-20020aa78d140000b029018b8e8d81e8mr17784102pfe.14.1605012443290;
        Tue, 10 Nov 2020 04:47:23 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 17sm14006160pfu.160.2020.11.10.04.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 04:47:21 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next] samples/bpf: add xdp_redirect_map with xdp_prog support
Date:   Tue, 10 Nov 2020 20:46:39 +0800
Message-Id: <20201110124639.1941654-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add running xdp program on egress interface support for
xdp_redirect_map sample. The new prog will change the IP ttl based
on egress ifindex.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 samples/bpf/xdp_redirect_map_kern.c | 74 ++++++++++++++++++++++++++++-
 samples/bpf/xdp_redirect_map_user.c | 21 ++++----
 2 files changed, 86 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
index 6489352ab7a4..e5ebff2271f4 100644
--- a/samples/bpf/xdp_redirect_map_kern.c
+++ b/samples/bpf/xdp_redirect_map_kern.c
@@ -22,7 +22,7 @@
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
 	__uint(key_size, sizeof(int));
-	__uint(value_size, sizeof(int));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
 	__uint(max_entries, 100);
 } tx_port SEC(".maps");
 
@@ -52,6 +52,48 @@ static void swap_src_dst_mac(void *data)
 	p[5] = dst[2];
 }
 
+static __always_inline __u16 csum_fold_helper(__u32 csum)
+{
+	__u32 sum;
+	sum = (csum & 0xffff) + (csum >> 16);
+	sum += (sum >> 16);
+	return ~sum;
+}
+
+static __always_inline __u16 ipv4_csum(__u16 seed, struct iphdr *iphdr_new,
+				       struct iphdr *iphdr_old)
+{
+	__u32 csum, size = sizeof(struct iphdr);
+	csum = bpf_csum_diff((__be32 *)iphdr_old, size,
+			     (__be32 *)iphdr_new, size, seed);
+	return csum_fold_helper(csum);
+}
+
+static void parse_ipv4(void *data, u64 nh_off, void *data_end, u8 ttl)
+{
+	struct iphdr *iph = data + nh_off;
+	struct iphdr iph_old;
+	__u16 csum_old;
+
+	if (iph + 1 > data_end)
+		return;
+
+	iph_old = *iph;
+	csum_old = iph->check;
+	iph->ttl = ttl;
+	iph->check = ipv4_csum(~csum_old, iph, &iph_old);
+}
+
+static void parse_ipv6(void *data, u64 nh_off, void *data_end, u8 hop_limit)
+{
+	struct ipv6hdr *ip6h = data + nh_off;
+
+	if (ip6h + 1 > data_end)
+		return;
+
+	ip6h->hop_limit = hop_limit;
+}
+
 SEC("xdp_redirect_map")
 int xdp_redirect_map_prog(struct xdp_md *ctx)
 {
@@ -82,6 +124,36 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
 	return bpf_redirect_map(&tx_port, vport, 0);
 }
 
+/* This map prog will set new IP ttl based on egress ifindex */
+SEC("xdp_devmap/map_prog")
+int xdp_devmap_prog(struct xdp_md *ctx)
+{
+	char fmt[] = "devmap redirect: egress dev %u with new ttl %u\n";
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	u16 h_proto;
+	u64 nh_off;
+	u8 ttl;
+
+	nh_off = sizeof(struct ethhdr);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	/* set new ttl based on egress ifindex */
+	ttl = ctx->egress_ifindex % 64;
+
+	h_proto = eth->h_proto;
+	if (h_proto == htons(ETH_P_IP))
+		parse_ipv4(data, nh_off, data_end, ttl);
+	else if (h_proto == htons(ETH_P_IPV6))
+		parse_ipv6(data, nh_off, data_end, ttl);
+
+	bpf_trace_printk(fmt, sizeof(fmt), ctx->egress_ifindex, ttl);
+
+	return XDP_PASS;
+}
+
 /* Redirect require an XDP bpf_prog loaded on the TX device */
 SEC("xdp_redirect_dummy")
 int xdp_redirect_dummy_prog(struct xdp_md *ctx)
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index 35e16dee613e..9a95eab629bd 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -98,12 +98,13 @@ int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type	= BPF_PROG_TYPE_XDP,
+		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
-	struct bpf_program *prog, *dummy_prog;
+	struct bpf_program *prog, *dummy_prog, *devmap_prog;
+	int prog_fd, dummy_prog_fd, devmap_prog_fd;
+	struct bpf_devmap_val devmap_val;
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
-	int prog_fd, dummy_prog_fd;
 	const char *optstr = "FSN";
 	struct bpf_object *obj;
 	int ret, opt, key = 0;
@@ -157,16 +158,18 @@ int main(int argc, char **argv)
 		return 1;
 
 	prog = bpf_program__next(NULL, obj);
-	dummy_prog = bpf_program__next(prog, obj);
-	if (!prog || !dummy_prog) {
+	devmap_prog = bpf_object__find_program_by_title(obj, "xdp_devmap/map_prog");
+	dummy_prog = bpf_object__find_program_by_title(obj, "xdp_redirect_dummy");
+	if (!prog || !devmap_prog || !dummy_prog) {
 		printf("finding a prog in obj file failed\n");
 		return 1;
 	}
 	/* bpf_prog_load_xattr gives us the pointer to first prog's fd,
-	 * so we're missing only the fd for dummy prog
+	 * so we're missing the fd for devmap and dummy prog
 	 */
+	devmap_prog_fd = bpf_program__fd(devmap_prog);
 	dummy_prog_fd = bpf_program__fd(dummy_prog);
-	if (prog_fd < 0 || dummy_prog_fd < 0) {
+	if (prog_fd < 0 || devmap_prog_fd < 0 || dummy_prog_fd < 0) {
 		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
 		return 1;
 	}
@@ -209,7 +212,9 @@ int main(int argc, char **argv)
 	signal(SIGTERM, int_exit);
 
 	/* populate virtual to physical port map */
-	ret = bpf_map_update_elem(tx_port_map_fd, &key, &ifindex_out, 0);
+	devmap_val.bpf_prog.fd = devmap_prog_fd;
+	devmap_val.ifindex = ifindex_out;
+	ret = bpf_map_update_elem(tx_port_map_fd, &key, &devmap_val, 0);
 	if (ret) {
 		perror("bpf_update_elem");
 		goto out;
-- 
2.25.4

