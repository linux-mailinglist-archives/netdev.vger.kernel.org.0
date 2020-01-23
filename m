Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC357146080
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAWBmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729028AbgAWBmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:23 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9793524688;
        Thu, 23 Jan 2020 01:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743742;
        bh=9nCU6ctuCqYQ/KLCGfEmsm2415frtKYhdrhyOwfbSAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbm20jgExYMmotbktGwUokqN0RfHhhSxxxgs1A3D50T/MI7ieiysFu+/9G+LQKy1b
         JM7+X8TTRLplv0fxssMcGTCJ9DDml/fQJAOh3PJ1xw87WtZDtQwv5JLVgerQTTBlSt
         7VCKecVxsHdSu8upeOjtsNk/xKKsg/hBQuzdGvhk=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: [PATCH bpf-next 06/12] tun: move shared functions to if_tun.h
Date:   Wed, 22 Jan 2020 18:42:04 -0700
Message-Id: <20200123014210.38412-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

This patch moves tun_ptr_free and related functions to if_tun.h. We
will use this function in tap.c in further patches. This was need to
avoid a scenario when tap is built into kernel image, tun is module
but not loaded. Below functions are moved to if_tun.h
- tun_ptr_free
- tun_xdp_to_ptr
- tun_ptr_to_xdp
- tun_ptr_free

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c      | 33 ---------------------------------
 include/linux/if_tun.h | 34 ++++++++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index c3155bc3fc7f..6f12c32df346 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -64,7 +64,6 @@
 #include <net/xdp.h>
 #include <linux/seq_file.h>
 #include <linux/uio.h>
-#include <linux/skb_array.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/mutex.h>
@@ -249,24 +248,6 @@ struct veth {
 	__be16 h_vlan_TCI;
 };
 
-bool tun_is_xdp_frame(void *ptr)
-{
-	return (unsigned long)ptr & TUN_XDP_FLAG;
-}
-EXPORT_SYMBOL(tun_is_xdp_frame);
-
-void *tun_xdp_to_ptr(void *ptr)
-{
-	return (void *)((unsigned long)ptr | TUN_XDP_FLAG);
-}
-EXPORT_SYMBOL(tun_xdp_to_ptr);
-
-void *tun_ptr_to_xdp(void *ptr)
-{
-	return (void *)((unsigned long)ptr & ~TUN_XDP_FLAG);
-}
-EXPORT_SYMBOL(tun_ptr_to_xdp);
-
 static int tun_napi_receive(struct napi_struct *napi, int budget)
 {
 	struct tun_file *tfile = container_of(napi, struct tun_file, napi);
@@ -649,20 +630,6 @@ static struct tun_struct *tun_enable_queue(struct tun_file *tfile)
 	return tun;
 }
 
-void tun_ptr_free(void *ptr)
-{
-	if (!ptr)
-		return;
-	if (tun_is_xdp_frame(ptr)) {
-		struct xdp_frame *xdpf = tun_ptr_to_xdp(ptr);
-
-		xdp_return_frame(xdpf);
-	} else {
-		__skb_array_destroy_skb(ptr);
-	}
-}
-EXPORT_SYMBOL_GPL(tun_ptr_free);
-
 static void tun_queue_purge(struct tun_file *tfile)
 {
 	void *ptr;
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 5bda8cf457b6..49ca20063a35 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -6,6 +6,7 @@
 #ifndef __IF_TUN_H
 #define __IF_TUN_H
 
+#include <linux/skb_array.h>
 #include <uapi/linux/if_tun.h>
 #include <uapi/linux/virtio_net.h>
 
@@ -27,10 +28,35 @@ struct tun_xdp_hdr {
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
 struct socket *tun_get_socket(struct file *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
-bool tun_is_xdp_frame(void *ptr);
-void *tun_xdp_to_ptr(void *ptr);
-void *tun_ptr_to_xdp(void *ptr);
-void tun_ptr_free(void *ptr);
+
+static inline bool tun_is_xdp_frame(void *ptr)
+{
+	return (unsigned long)ptr & TUN_XDP_FLAG;
+}
+
+static inline void *tun_xdp_to_ptr(void *ptr)
+{
+	return (void *)((unsigned long)ptr | TUN_XDP_FLAG);
+}
+
+static inline void *tun_ptr_to_xdp(void *ptr)
+{
+	return (void *)((unsigned long)ptr & ~TUN_XDP_FLAG);
+}
+
+static inline void tun_ptr_free(void *ptr)
+{
+	if (!ptr)
+		return;
+	if (tun_is_xdp_frame(ptr)) {
+		struct xdp_frame *xdpf = tun_ptr_to_xdp(ptr);
+
+		xdp_return_frame(xdpf);
+	} else {
+		__skb_array_destroy_skb(ptr);
+	}
+}
+
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
-- 
2.21.1 (Apple Git-122.3)

