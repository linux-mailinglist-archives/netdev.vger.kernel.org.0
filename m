Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BA1410AAC
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 10:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhISIE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 04:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhISIEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 04:04:55 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7105C061574;
        Sun, 19 Sep 2021 01:03:30 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d18so8997990pll.11;
        Sun, 19 Sep 2021 01:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tzCXSJhKueSdvTuoY9GfM/BXQYUDhFfmDhUEdPBfOds=;
        b=lhKwqctk7geNfJuNF8F4Aw1C6NroErdR8P8QH/G7BMdtD41W3OGx+qqXUaK1X5AbB4
         ddLeRI/NCkxoaooWoUFcicaKtRcupSxMMtduSni1AfbdlTWZFJTi25/3fAjUyVel+aC5
         ErEfnll2mY6JJLC5dU19OprB0VnItSF+iGgj/ljSfLiX/7Q5aCywEEYhqkYvg2o9fSlz
         LHnMGg5UhrlGq5yRHjkgJqAaTkt0L8TOApoxY8jnq2q8XPdG0tJYUrWH2xY1qhh+P+Tn
         7RecWwfR0as29+sB26sfGAeskdpuVl0mnDUL0fJyTXLCQINjEKsPKQDzg7F0ICwMMnKG
         aGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tzCXSJhKueSdvTuoY9GfM/BXQYUDhFfmDhUEdPBfOds=;
        b=ZvbEdgGSuoxF4gbKeVhA52dDi65eXe302YkJ/fVv1xllrFdKgTGQSudXpw0kbTL1RO
         2ysfmSrM6+C/YnZOkC51fEACmbn6/CZ7b7axN50gc9jPOqqshUeUKXYxIiNg4eh4v+fO
         Ilb1MQfOcCiKZMmnU9dg6vY9CBmQ3iJ8tbQBdCNrzFMX5DtH6vBWGt6mpK6KITuvpPKL
         OaMssKzKLwETFeR0wLDsQ3XIF9B+y8SoDRwunkjfFF9BX1NtzMkD4xH3D2PLCq3TlQw3
         h88KcpFuJUoiYFHK0eUDThMbUqt0n8itn6Ont0D+BumahwA+cyf0LoO6JGuH51s03qXc
         EYQQ==
X-Gm-Message-State: AOAM531NhI7tq2mGQ/sLRAnJPV7fSqsDjv0fGipwV1wDMuDLw2YzoFv1
        EzHKv7PFzBhEab/YfjkFgq+WWORpV3E=
X-Google-Smtp-Source: ABdhPJwrgFruSvCqzsaFCb2jBLzSiJqy9JTMxPyGC1vPD/EtrGA7k3XfC6TjeY8i/zjENO9rmtijlQ==
X-Received: by 2002:a17:90b:a4a:: with SMTP id gw10mr15344962pjb.101.1632038609817;
        Sun, 19 Sep 2021 01:03:29 -0700 (PDT)
Received: from localhost.localdomain ([49.206.116.228])
        by smtp.googlemail.com with ESMTPSA id x18sm10593589pfq.130.2021.09.19.01.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 01:03:29 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH bpf-next 1/2] samples: bpf: convert route table network order fields into readable format
Date:   Sun, 19 Sep 2021 13:33:04 +0530
Message-Id: <20210919080305.173588-1-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The route table that is dumped when the xdp_router_ipv4 process is launched
has the "Gateway" field in non-readable network byte order format, also the
alignment is off when printing the table.

Destination             Gateway         Genmask         Metric          Iface
  0.0.0.0               196a8c0         0               0               enp7s0
  0.0.0.0               196a8c0         0               0               wlp6s0
169.254.0.0             196a8c0         16              0               enp7s0
172.17.0.0                0             16              0               docker0
192.168.150.0             0             24              0               enp7s0
192.168.150.0             0             24              0               wlp6s0

Fix this by converting the "Gateway" field from network byte order Hex into
dotted decimal notation IPv4 format and "Genmask" from CIDR notation into
dotted decimal notation IPv4 format. Also fix the aligntment of the fields
in the route table.

Destination     Gateway         Genmask         Metric Iface
0.0.0.0         192.168.150.1   0.0.0.0         0      enp7s0
0.0.0.0         192.168.150.1   0.0.0.0         0      wlp6s0
169.254.0.0     192.168.150.1   255.255.0.0     0      enp7s0
172.17.0.0      0.0.0.0         255.255.0.0     0      docker0
192.168.150.0   0.0.0.0         255.255.255.0   0      enp7s0
192.168.150.0   0.0.0.0         255.255.255.0   0      wlp6s0

Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 samples/bpf/xdp_router_ipv4_user.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index b5f03cb17a3c..3e9db5a8c8c6 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -155,7 +155,7 @@ static void read_route(struct nlmsghdr *nh, int nll)
 		printf("%d\n", nh->nlmsg_type);
 
 	memset(&route, 0, sizeof(route));
-	printf("Destination\t\tGateway\t\tGenmask\t\tMetric\t\tIface\n");
+	printf("Destination     Gateway         Genmask         Metric Iface\n");
 	for (; NLMSG_OK(nh, nll); nh = NLMSG_NEXT(nh, nll)) {
 		rt_msg = (struct rtmsg *)NLMSG_DATA(nh);
 		rtm_family = rt_msg->rtm_family;
@@ -207,6 +207,7 @@ static void read_route(struct nlmsghdr *nh, int nll)
 				int metric;
 				__be32 gw;
 			} *prefix_value;
+			struct in_addr dst_addr, gw_addr, mask_addr;
 
 			prefix_key = alloca(sizeof(*prefix_key) + 3);
 			prefix_value = alloca(sizeof(*prefix_value));
@@ -234,14 +235,17 @@ static void read_route(struct nlmsghdr *nh, int nll)
 			for (i = 0; i < 4; i++)
 				prefix_key->data[i] = (route.dst >> i * 8) & 0xff;
 
-			printf("%3d.%d.%d.%d\t\t%3x\t\t%d\t\t%d\t\t%s\n",
-			       (int)prefix_key->data[0],
-			       (int)prefix_key->data[1],
-			       (int)prefix_key->data[2],
-			       (int)prefix_key->data[3],
-			       route.gw, route.dst_len,
+			dst_addr.s_addr = route.dst;
+			printf("%-16s", inet_ntoa(dst_addr));
+
+			gw_addr.s_addr = route.gw;
+			printf("%-16s", inet_ntoa(gw_addr));
+
+			mask_addr.s_addr = htonl(~(0xffffffffU >> route.dst_len));
+			printf("%-16s%-7d%s\n", inet_ntoa(mask_addr),
 			       route.metric,
 			       route.iface_name);
+
 			if (bpf_map_lookup_elem(lpm_map_fd, prefix_key,
 						prefix_value) < 0) {
 				for (i = 0; i < 4; i++)
@@ -672,7 +676,7 @@ int main(int ac, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
 
-	printf("\n**************loading bpf file*********************\n\n\n");
+	printf("\n******************loading bpf file*********************\n");
 	if (!prog_fd) {
 		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
 		return 1;
@@ -722,7 +726,7 @@ int main(int ac, char **argv)
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	printf("*******************ROUTE TABLE*************************\n\n\n");
+	printf("\n*******************ROUTE TABLE*************************\n");
 	get_route_table(AF_INET);
 	printf("*******************ARP TABLE***************************\n\n\n");
 	get_arp_table(AF_INET);
-- 
2.25.1

