Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781DA5704F8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiGKOEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiGKOEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:04:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 267C41BEBC
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657548268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MHDwuZOBumrb0bTeaJpSEvJ+mJYtR/xSjJZhFTAmwho=;
        b=hLEhfxA46qiHgH7cPBsmDIkq6umXp6nztCNuKGZK2/T1e6xU2frqVpcjioawqI4vnxIvtx
        m2NRbMOMk5CRWcXFDhyo++0IB/l0Xn2IMoqVRm62X+6kII74biz2wFjuMk8sOZRv60vmuS
        /WcJcQP3mO3ww1weKsgMuRJJIoxJFfM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-0eFv_hyjPBmNxstG_IyD-Q-1; Mon, 11 Jul 2022 10:04:24 -0400
X-MC-Unique: 0eFv_hyjPBmNxstG_IyD-Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83CA1101E9B0;
        Mon, 11 Jul 2022 14:04:24 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31CF52026D64;
        Mon, 11 Jul 2022 14:04:24 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 03C2130736C78;
        Mon, 11 Jul 2022 16:04:23 +0200 (CEST)
Subject: [bpf-next PATCH] samples/bpf: Fix xdp_redirect_map egress devmap prog
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        tstellar@redhat.com
Date:   Mon, 11 Jul 2022 16:04:22 +0200
Message-ID: <165754826292.575614.5636444052787717159.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LLVM compiler optimized out the memcpy in xdp_redirect_map_egress,
which caused the Ethernet source MAC-addr to always be zero
when enabling the devmap egress prog via cmdline --load-egress.

Issue observed with LLVM version 14.0.0
 - Shipped with Fedora 36 on target: x86_64-redhat-linux-gnu.

In verbose mode print the source MAC-addr in case xdp_devmap_attached
mode is used.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 samples/bpf/xdp_redirect_map.bpf.c  |    6 ++++--
 samples/bpf/xdp_redirect_map_user.c |    9 +++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/xdp_redirect_map.bpf.c b/samples/bpf/xdp_redirect_map.bpf.c
index 415bac1758e3..8557c278df77 100644
--- a/samples/bpf/xdp_redirect_map.bpf.c
+++ b/samples/bpf/xdp_redirect_map.bpf.c
@@ -33,7 +33,7 @@ struct {
 } tx_port_native SEC(".maps");
 
 /* store egress interface mac address */
-const volatile char tx_mac_addr[ETH_ALEN];
+const volatile __u8 tx_mac_addr[ETH_ALEN];
 
 static __always_inline int xdp_redirect_map(struct xdp_md *ctx, void *redirect_map)
 {
@@ -73,6 +73,7 @@ int xdp_redirect_map_egress(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data = (void *)(long)ctx->data;
+	u8 *mac_addr = (u8 *) tx_mac_addr;
 	struct ethhdr *eth = data;
 	u64 nh_off;
 
@@ -80,7 +81,8 @@ int xdp_redirect_map_egress(struct xdp_md *ctx)
 	if (data + nh_off > data_end)
 		return XDP_DROP;
 
-	__builtin_memcpy(eth->h_source, (const char *)tx_mac_addr, ETH_ALEN);
+	barrier_var(mac_addr); /* prevent optimizing out memcpy */
+	__builtin_memcpy(eth->h_source, mac_addr, ETH_ALEN);
 
 	return XDP_PASS;
 }
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index b6e4fc849577..c889a1394dc1 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -40,6 +40,8 @@ static const struct option long_options[] = {
 	{}
 };
 
+static int verbose = 0;
+
 int main(int argc, char **argv)
 {
 	struct bpf_devmap_val devmap_val = {};
@@ -79,6 +81,7 @@ int main(int argc, char **argv)
 			break;
 		case 'v':
 			sample_switch_mode();
+			verbose = 1;
 			break;
 		case 's':
 			mask |= SAMPLE_REDIRECT_MAP_CNT;
@@ -134,6 +137,12 @@ int main(int argc, char **argv)
 			ret = EXIT_FAIL;
 			goto end_destroy;
 		}
+		if (verbose)
+			printf("Egress ifindex:%d using src MAC %02x:%02x:%02x:%02x:%02x:%02x\n",
+			       ifindex_out,
+			       skel->rodata->tx_mac_addr[0], skel->rodata->tx_mac_addr[1],
+			       skel->rodata->tx_mac_addr[2], skel->rodata->tx_mac_addr[3],
+			       skel->rodata->tx_mac_addr[4], skel->rodata->tx_mac_addr[5]);
 	}
 
 	skel->rodata->from_match[0] = ifindex_in;


