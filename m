Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD7E84BC0
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbfHGMgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 08:36:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387598AbfHGMg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 08:36:29 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 617843174654;
        Wed,  7 Aug 2019 12:36:29 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-48.brq.redhat.com [10.40.200.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BCE15C258;
        Wed,  7 Aug 2019 12:36:29 +0000 (UTC)
Received: from [10.10.10.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 3A6DC3002D560;
        Wed,  7 Aug 2019 14:36:28 +0200 (CEST)
Subject: [bpf-next PATCH 3/3] samples/bpf: xdp_fwd explain bpf_fib_lookup
 return codes
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     xdp-newbies@vger.kernel.org, a.s.protopopov@gmail.com,
        dsahern@gmail.com, Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Wed, 07 Aug 2019 14:36:28 +0200
Message-ID: <156518138817.5636.3626699603179533211.stgit@firesoul>
In-Reply-To: <156518133219.5636.728822418668658886.stgit@firesoul>
References: <156518133219.5636.728822418668658886.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 07 Aug 2019 12:36:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it clear that this XDP program depend on the network
stack to do the ARP resolution.  This is connected with the
BPF_FIB_LKUP_RET_NO_NEIGH return code from bpf_fib_lookup().

Another common mistake (seen via XDP-tutorial) is that users
don't realize that sysctl net.ipv{4,6}.conf.all.forwarding
setting is honored by bpf_fib_lookup.

Reported-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 samples/bpf/xdp_fwd_kern.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
index 4a5ad381ed2a..df11163454e7 100644
--- a/samples/bpf/xdp_fwd_kern.c
+++ b/samples/bpf/xdp_fwd_kern.c
@@ -103,8 +103,23 @@ static __always_inline int xdp_fwd_flags(struct xdp_md *ctx, u32 flags)
 	fib_params.ifindex = ctx->ingress_ifindex;
 
 	rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params), flags);
-
-	if (rc == 0) {
+	/*
+	 * Some rc (return codes) from bpf_fib_lookup() are important,
+	 * to understand how this XDP-prog interacts with network stack.
+	 *
+	 * BPF_FIB_LKUP_RET_NO_NEIGH:
+	 *  Even if route lookup was a success, then the MAC-addresses are also
+	 *  needed.  This is obtained from arp/neighbour table, but if table is
+	 *  (still) empty then BPF_FIB_LKUP_RET_NO_NEIGH is returned.  To avoid
+	 *  doing ARP lookup directly from XDP, then send packet to normal
+	 *  network stack via XDP_PASS and expect it will do ARP resolution.
+	 *
+	 * BPF_FIB_LKUP_RET_FWD_DISABLED:
+	 *  The bpf_fib_lookup respect sysctl net.ipv{4,6}.conf.all.forwarding
+	 *  setting, and will return BPF_FIB_LKUP_RET_FWD_DISABLED if not
+	 *  enabled this on ingress device.
+	 */
+	if (rc == BPF_FIB_LKUP_RET_SUCCESS) {
 		int *val;
 
 		/* Verify egress index has been configured as TX-port.

