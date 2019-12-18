Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B12124130
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLRIM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:58 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46137 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRIM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:58 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so617030pll.13
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/mUI1AQBodTW/whqD89bfFNjiWJm4/Lgx7fxoFto6oI=;
        b=NQzKMBPw3pzTYNHTdDY4fARfwM3I/3t+OMA1/VdbIfJYvX0rqvBUjYjE4qxpNRU9zA
         QkYUvcvlPR/qJiICGSvYyf07MBDaDRo+9xhuehOs+4LO5z47ISBF7jbQnb2B4T9RTTkv
         fPGuHJRLDmuE1++J3mDsOGqs5voXQTKMte3uD+5l2nrJxPKxi5LGNc0DlEOR7FkwryGI
         m48+jUnUdoukmqJX6tgh+FPbt/3HfLqhIU24Thp0wRs/C4tBCo0jBJzoQ81XEr7Xnz+k
         zh86Pabd+utDYoX3nqQtz6rcZnP7yidgxP3T3ZWM0Q5ZKsaFFOnTdUJqKbV4Zn2a6F1j
         ONGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/mUI1AQBodTW/whqD89bfFNjiWJm4/Lgx7fxoFto6oI=;
        b=Kx3HphC11jGl45encIU6aqAOJxpVc0L85tohdP8poDWDJ/55AxHl6+6sWED1R6nlpp
         8/0VqPUJfk7y59XJm4NHqnIHJ7Kzru3jvNWq/GO7pnaCNvI4J8a+XwBlvlMSG49MGILT
         NavehXP1VqwxWti/CCW+DisTBPLq6tJuQPPjEqXLn8xPd+wTXI8/jyoYmWWJ9Ck/6mWT
         nlVykTliGyHZfmqukTc6wYUliUBOJtimpfhFZGE6k43NlFvM6UCJxONJotyoJ5adI+Ao
         TnBjBrnO7WoWnRV8AvnRM67Psqj189VPgOdcZtqq2AVVh0n+HuzAnV6VFHK3yGENpROR
         +hdw==
X-Gm-Message-State: APjAAAWQAGpgdkAoQ/8Sn+I397N0sQxP9un2h/Lv6JNfP01LpSSDicCS
        hyKbgiZ5M3EeWMSAx3y5mhgPynHD
X-Google-Smtp-Source: APXvYqxFr7ySbhxIPw9XE1RrFs6/1iClBcQpkwNrqHdgvtj83/2DR5ndxiqAz0C/IkmGRCKacZhRUw==
X-Received: by 2002:a17:902:d893:: with SMTP id b19mr1327708plz.93.1576656777717;
        Wed, 18 Dec 2019 00:12:57 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:57 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC net-next 12/14] tun: add a way to inject tx path packet into Rx path
Date:   Wed, 18 Dec 2019 17:10:48 +0900
Message-Id: <20191218081050.10170-13-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support XDP_TX from tx path XDP program, we need a way
to inject tx path packet into RX path. Let's modify the RX path
function tun_xdp_one() for this purpose.

This patch adds a parameter to pass information whether packet has
virtio_net header.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1afded9252f5..0701a7a80346 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2238,6 +2238,13 @@ static u32 tun_do_xdp_tx_generic(struct tun_struct *tun,
 	return act;
 }
 
+static int tun_xdp_one(struct tun_struct *tun,
+		       struct tun_file *tfile,
+		       struct xdp_buff *xdp, int *flush,
+		       struct tun_page *tpage, int has_hdr);
+
+static void tun_put_page(struct tun_page *tpage);
+
 static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
 			 struct xdp_frame *frame)
 {
@@ -2543,23 +2550,36 @@ static void tun_put_page(struct tun_page *tpage)
 static int tun_xdp_one(struct tun_struct *tun,
 		       struct tun_file *tfile,
 		       struct xdp_buff *xdp, int *flush,
-		       struct tun_page *tpage)
+		       struct tun_page *tpage, int has_hdr)
 {
 	unsigned int datasize = xdp->data_end - xdp->data;
-	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
-	struct virtio_net_hdr *gso = &hdr->gso;
+	struct virtio_net_hdr *gso = NULL;
 	struct tun_pcpu_stats *stats;
-	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
-	u32 rxhash = 0, act;
-	int buflen = hdr->buflen;
-	int err = 0;
+	struct bpf_prog *xdp_prog;
+	struct tun_xdp_hdr *hdr;
+	unsigned int headroom;
 	bool skb_xdp = false;
+	u32 rxhash = 0, act;
 	struct page *page;
+	int err = 0;
+	int buflen;
+
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
 
 	xdp_prog = rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
-		if (gso->gso_type) {
+		if (has_hdr && gso->gso_type) {
 			skb_xdp = true;
 			goto build;
 		}
@@ -2604,7 +2624,8 @@ static int tun_xdp_one(struct tun_struct *tun,
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
 
-	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
+	if (has_hdr &&
+	    virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
 		this_cpu_inc(tun->pcpu_stats->rx_frame_errors);
 		kfree_skb(skb);
 		err = -EINVAL;
@@ -2668,7 +2689,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 
 		for (i = 0; i < n; i++) {
 			xdp = &((struct xdp_buff *)ctl->ptr)[i];
-			tun_xdp_one(tun, tfile, xdp, &flush, &tpage);
+			tun_xdp_one(tun, tfile, xdp, &flush, &tpage, true);
 		}
 
 		if (flush)
-- 
2.21.0

