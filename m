Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35565109BD3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfKZKJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:18 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46241 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfKZKJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:17 -0500
Received: by mail-pg1-f193.google.com with SMTP id k1so385521pga.13;
        Tue, 26 Nov 2019 02:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A+zZHbHPcf2+kZRFz8qYInOcnfbpxMipg8cRARobJQk=;
        b=ajEYLyOj6rPflxN/F4j7gzmTTfjkzFiOUEnj4x/mlPjwT6HScKGEYBOt5supKzMBi7
         YBKGt62f0nlaJKL+4zEw20xBeu1qYjK6d3SjEQUAl982WY7KJ01zVqk8DP3SnV/E/4fE
         CvaL6nj6eGp7V+momNglWpxUiWUrQvkycbmynW0f+hE5TfdRhAIloHm1ZaWraGj06zkS
         pbNZdnR7LBGBbDTgO7C2YbNJOL1telar0aLkM/XV6T7hkE7/6YBVYNdFfy3Jeey0Oa37
         By6HHXTNu/fbLWGSKnYoHiZtOXRdndYXg/KtDhSuf3L0sVTRKHyC/x4qHts5RUV3kdo8
         txrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A+zZHbHPcf2+kZRFz8qYInOcnfbpxMipg8cRARobJQk=;
        b=Z0MAh/IRdgjbiwNIKT+0/KZtQ3z/fxJyiaRV3jo2FkUPhO3FUQTq33A73L8YSfqIRZ
         uu0l5OW5Qtt523uviBiNy2hjr3gqiBsgCCWMkvQWb9RDxIP6d1MWu29tavP4WgjyHtEg
         SdBQ6KRM1kyzbPk6gmxCf23q5d+qNcYh1K9O50QoZaKLmdgF+Nl2KTys3UNS9v5t6JJ4
         S0BbHJz+DakpDW2Qp5VCEbHa9OaJjKFxKmYMmwNhGRgkABwqEEHMVsOePhNN8QULD6Rh
         +NX9c/6jsG7rf9Cfi2fuEF7RTbPtA2CQjk5FWAaGsVhuY2KCBpSU2mUKSCZ5Rn5ofzN8
         6utQ==
X-Gm-Message-State: APjAAAW0kNftyHVD71KFGJQDKl5sx4Lx7h6U2jc1E5okZKW7qmA0RgSn
        uET5mbneGKHK3yfO9BZTgxA=
X-Google-Smtp-Source: APXvYqza/1KXHr4vy/bIqcXkAf21DPD3YjEsUIsSGZ5/9H4FB/QXnB77j4wEUyEgpjV4ork9q/KtvA==
X-Received: by 2002:a63:b40d:: with SMTP id s13mr38800406pgf.215.1574762957081;
        Tue, 26 Nov 2019 02:09:17 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:16 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC net-next 09/18] tun: add a way to inject Tx path packet into Rx path
Date:   Tue, 26 Nov 2019 19:07:35 +0900
Message-Id: <20191126100744.5083-10-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support XDP_TX from offloaded XDP program, we need a way
to inject Tx path packet into Rx path. Let's modify the Rx path
function tun_xdp_one() for this purpose.

This patch adds a parameter to pass information whether packet has
virtio_net header. When header isn't present, it is considered as
XDP_TX'ed packet from offloaded program.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 466ea69f00ee..8d6cdd3e5139 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2221,6 +2221,13 @@ static u32 tun_do_xdp_offload_generic(struct tun_struct *tun,
 	return act;
 }
 
+static int tun_xdp_one(struct tun_struct *tun,
+		       struct tun_file *tfile,
+		       struct xdp_buff *xdp, int *flush,
+		       struct tun_page *tpage, int has_hdr);
+
+static void tun_put_page(struct tun_page *tpage);
+
 static u32 tun_do_xdp_offload(struct tun_struct *tun, struct tun_file *tfile,
 			      struct xdp_frame *frame)
 {
@@ -2527,23 +2534,36 @@ static void tun_put_page(struct tun_page *tpage)
 static int tun_xdp_one(struct tun_struct *tun,
 		       struct tun_file *tfile,
 		       struct xdp_buff *xdp, int *flush,
-		       struct tun_page *tpage)
+		       struct tun_page *tpage, int has_hdr)
 {
 	unsigned int datasize = xdp->data_end - xdp->data;
-	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
-	struct virtio_net_hdr *gso = &hdr->gso;
+	struct tun_xdp_hdr *hdr;
+	struct virtio_net_hdr *gso;
 	struct tun_pcpu_stats *stats;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
+	unsigned int headroom;
 	u32 rxhash = 0, act;
-	int buflen = hdr->buflen;
+	int buflen;
 	int err = 0;
 	bool skb_xdp = false;
 	struct page *page;
 
+	if (has_hdr) {
+		hdr = xdp->data_hard_start;
+		gso = &hdr->gso;
+		buflen = hdr->buflen;
+	} else {
+		/* came here from tun tx path */
+		xdp->data_hard_start -= sizeof(struct xdp_frame);
+		headroom = xdp->data - xdp->data_hard_start;
+		buflen = datasize + headroom +
+			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	}
+
 	xdp_prog = rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
-		if (gso->gso_type) {
+		if (has_hdr && gso->gso_type) {
 			skb_xdp = true;
 			goto build;
 		}
@@ -2588,7 +2608,8 @@ static int tun_xdp_one(struct tun_struct *tun,
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
 
-	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
+	if (has_hdr &&
+	    virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
 		this_cpu_inc(tun->pcpu_stats->rx_frame_errors);
 		kfree_skb(skb);
 		err = -EINVAL;
@@ -2652,7 +2673,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 
 		for (i = 0; i < n; i++) {
 			xdp = &((struct xdp_buff *)ctl->ptr)[i];
-			tun_xdp_one(tun, tfile, xdp, &flush, &tpage);
+			tun_xdp_one(tun, tfile, xdp, &flush, &tpage, true);
 		}
 
 		if (flush)
-- 
2.20.1

