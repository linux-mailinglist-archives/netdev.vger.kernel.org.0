Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A228D866CC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404099AbfHHQRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:17:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10197 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfHHQRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 12:17:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 083C5772C7;
        Thu,  8 Aug 2019 16:17:41 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-48.brq.redhat.com [10.40.200.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F497608AB;
        Thu,  8 Aug 2019 16:17:38 +0000 (UTC)
Received: from [10.10.10.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id AAC023002D562;
        Thu,  8 Aug 2019 18:17:37 +0200 (CEST)
Subject: [bpf-next v3 PATCH 1/3] samples/bpf: xdp_fwd rename devmap name to
 be xdp_tx_ports
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     a.s.protopopov@gmail.com, dsahern@gmail.com,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        ys114321@gmail.com, Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Thu, 08 Aug 2019 18:17:37 +0200
Message-ID: <156528105763.22124.16079929264188823516.stgit@firesoul>
In-Reply-To: <156528102557.22124.261409336813472418.stgit@firesoul>
References: <156528102557.22124.261409336813472418.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 08 Aug 2019 16:17:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devmap name 'tx_port' came from a copy-paste from xdp_redirect_map
which only have a single TX port. Change name to xdp_tx_ports
to make it more descriptive.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 samples/bpf/xdp_fwd_kern.c |    5 +++--
 samples/bpf/xdp_fwd_user.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
index a7e94e7ff87d..e6ffc4ea06f4 100644
--- a/samples/bpf/xdp_fwd_kern.c
+++ b/samples/bpf/xdp_fwd_kern.c
@@ -23,7 +23,8 @@
 
 #define IPV6_FLOWINFO_MASK              cpu_to_be32(0x0FFFFFFF)
 
-struct bpf_map_def SEC("maps") tx_port = {
+/* For TX-traffic redirect requires net_device ifindex to be in this devmap */
+struct bpf_map_def SEC("maps") xdp_tx_ports = {
 	.type = BPF_MAP_TYPE_DEVMAP,
 	.key_size = sizeof(int),
 	.value_size = sizeof(int),
@@ -117,7 +118,7 @@ static __always_inline int xdp_fwd_flags(struct xdp_md *ctx, u32 flags)
 
 		memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
 		memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
-		return bpf_redirect_map(&tx_port, fib_params.ifindex, 0);
+		return bpf_redirect_map(&xdp_tx_ports, fib_params.ifindex, 0);
 	}
 
 	return XDP_PASS;
diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index 5b46ee12c696..ba012d9f93dd 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -113,7 +113,7 @@ int main(int argc, char **argv)
 			return 1;
 		}
 		map_fd = bpf_map__fd(bpf_object__find_map_by_name(obj,
-								  "tx_port"));
+							"xdp_tx_ports"));
 		if (map_fd < 0) {
 			printf("map not found: %s\n", strerror(map_fd));
 			return 1;

