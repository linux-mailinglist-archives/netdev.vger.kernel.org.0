Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDA5109BDD
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfKZKJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:33 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38164 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfKZKJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:33 -0500
Received: by mail-pf1-f194.google.com with SMTP id c13so8942511pfp.5;
        Tue, 26 Nov 2019 02:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zx5Ey469MhuUUqEJoZa/8N8K8LFzbIEk0ZZ64tnsKp0=;
        b=tLp6iRQl3sTOSSAx/gYoWpZG6XJZLoT8Zsh4xTn5YujxIAIlwEJMfJD/rbDLDKunxB
         PPLhWNxdNgkLYho5QUCo4jvD2cNjRkGWG6TUcgyp8JAnzvNAS/wBqESuBabVuZ58ZXMA
         CjvxUg68D5TAnjrU3ucmi0vThEn2NdeL2t0OCC+t1mzws0+Uo2GF7nK9INOfwKCC+uvF
         8tn+hq13m8b2koupUYky/h2w8ql+9nXEVhJybe8LqphIjRZMW5HRezUzTCS/F9spcCWo
         ReC2AEI2NuSoPd4v59sHgkAEbAfWOp9Mdh5J9/gpiK41Xs5JEe0O3S4M624X2enKwNJd
         lrrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zx5Ey469MhuUUqEJoZa/8N8K8LFzbIEk0ZZ64tnsKp0=;
        b=Xyn05KXHuGDZPa6IURd56s1C5eaPAbbjXfs1vmSAI8+VLzPLNKow4BhntED7Fy5tEn
         5OkCH9TSMy6ka6NFhaak63Sn4nrzOHnhy/SYiX7yF6HOWGPppNduUZ92BwzEo6suTzRm
         8pN1CeWD/Kw1fwz7QdriT4TSv5rxu9olgzYR8/XiQmKYGxabHIRZVm1ftHBK3ghVmmF4
         WajGlVM7ZaddoNOfjup0joY2dwKQ6WRNSfsdYzz99xlM1R5QSBLmCQOtDUXXg6BsvFxO
         Zx7RjG9fNir27mnPyIHXVwpaBkHktGVNL0CWTvzFyOyVOzk6hVPmQXLQdNr+KLbDT/sA
         cnrA==
X-Gm-Message-State: APjAAAW6roiPrPwApyyR2ktolOJ+R77qbT4pekbeZoe7YgKIAdpzQQXq
        83ZPQWOm+k5pr/vPSbOrwGk=
X-Google-Smtp-Source: APXvYqy5nSGYMuA9W/Y541xqtiKlrCKtpPV27lN87wYp1YRIe1p9W24OXy6SRFejVlg/PWYn3qdtdA==
X-Received: by 2002:a63:6b46:: with SMTP id g67mr37703871pgc.371.1574762972460;
        Tue, 26 Nov 2019 02:09:32 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:32 -0800 (PST)
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
Subject: [RFC net-next 13/18] virtio_net: use XDP attachment helpers
Date:   Tue, 26 Nov 2019 19:07:39 +0900
Message-Id: <20191126100744.5083-14-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Next patches will introduce virtio_net XDP offloading. In that case
we need to manage offloaded and non-offload program. In order to make
it consistent this patch introduces use of XDP attachment helpers.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/virtio_net.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c8bbb1b90c1c..cee5c2b15c62 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -229,6 +229,8 @@ struct virtnet_info {
 	struct failover *failover;
 
 	struct bpf_prog __rcu *xdp_prog;
+
+	struct xdp_attachment_info xdp;
 };
 
 struct padded_vnet_hdr {
@@ -2398,15 +2400,19 @@ static int virtnet_restore_guest_offloads(struct virtnet_info *vi)
 	return virtnet_set_guest_offloads(vi, offloads);
 }
 
-static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
-			   struct netlink_ext_ack *extack)
+static int virtnet_xdp_set(struct net_device *dev, struct netdev_bpf *bpf)
 {
 	unsigned long int max_sz = PAGE_SIZE - sizeof(struct padded_vnet_hdr);
+	struct netlink_ext_ack *extack = bpf->extack;
 	struct virtnet_info *vi = netdev_priv(dev);
+	struct bpf_prog *prog = bpf->prog;
 	struct bpf_prog *old_prog;
 	u16 xdp_qp = 0, curr_qp;
 	int i, err;
 
+	if (!xdp_attachment_flags_ok(&vi->xdp, bpf))
+		return -EBUSY;
+
 	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)
 	    && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
@@ -2478,8 +2484,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		}
 	}
 
-	if (old_prog)
-		bpf_prog_put(old_prog);
+	xdp_attachment_setup(&vi->xdp, bpf);
 
 	return 0;
 
@@ -2501,26 +2506,13 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return err;
 }
 
-static u32 virtnet_xdp_query(struct net_device *dev)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-
-	xdp_prog = rtnl_dereference(vi->xdp_prog);
-	if (xdp_prog)
-		return xdp_prog->aux->id;
-
-	return 0;
-}
-
 static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
+		return virtnet_xdp_set(dev, xdp);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = virtnet_xdp_query(dev);
-		return 0;
+		return xdp_attachment_query(&vi->xdp, xdp);
 	default:
 		return -EINVAL;
 	}
-- 
2.20.1

