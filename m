Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967F259704
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfF1JMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 05:12:40 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43921 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfF1JMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 05:12:40 -0400
Received: by mail-ed1-f66.google.com with SMTP id e3so9999599edr.10
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 02:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3kzeuj6Tp4EQGpg1kdGIS3aefku2NLwCWAmHNUzfs8s=;
        b=ClktfD3jIQTaLN+MVcR/D2aqU+eniSebwK+ylTSDAQt4nYNHea1VMg8z1WA/Y71mBt
         RCg1jL21dloviqLfiGQ/ioeM/NqMlGstoEnsvA4wVRkyZYItHU2iPTMwzS0M/HNe6Ln0
         v/ZO6Covrd3gfqgxbpoyWdAR1ZdMXxsx0X42FpRL430UxRb+HLjzm/CnHCQs84rAFEP/
         a/5j7WSOkTYud82LKEZYlPqUZ+vopZZ1/sMJSThBZWmDnBnpvVHubAeXY8MIzFX0yLPn
         bsH3Pq02ubpBf0e816aZ70vFBFa23M7pVyzINYhYHQXOUyNiS0lLgrJo9wIn+Up7AXOA
         VWJA==
X-Gm-Message-State: APjAAAW8YpMNuF5xxQg/uVqMzHx9unCtdZPhccjLQJfk8kaovrfZ3dGm
        PhWT7uJzqLowTj4qHzwz7oneems4NK0=
X-Google-Smtp-Source: APXvYqzG+d9CuRk+v8GzyfuumedLzOeun1NAl0XxfwlpHwq9HR0QPWKlogYqvKoFVyc/hXLq5JxSBg==
X-Received: by 2002:a50:86dc:: with SMTP id 28mr9920066edu.132.1561713158073;
        Fri, 28 Jun 2019 02:12:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id z16sm341787eji.31.2019.06.28.02.12.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:12:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E6022181CAA; Fri, 28 Jun 2019 11:12:34 +0200 (CEST)
Subject: [PATCH bpf-next v6 3/5] devmap: Rename ifindex member in
 bpf_redirect_info
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Fri, 28 Jun 2019 11:12:34 +0200
Message-ID: <156171315487.9468.3276199934297016197.stgit@alrua-x1>
In-Reply-To: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
References: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The bpf_redirect_info struct has an 'ifindex' member which was named back
when the redirects could only target egress interfaces. Now that we can
also redirect to sockets and CPUs, this is a bit misleading, so rename the
member to tgt_index.

Reorder the struct members so we can have 'tgt_index' and 'tgt_value' next
to each other in a subsequent patch.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/filter.h |    2 +-
 net/core/filter.c      |   26 +++++++++++++-------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 43b45d6db36d..af8601340dae 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -578,8 +578,8 @@ struct bpf_skb_data_end {
 };
 
 struct bpf_redirect_info {
-	u32 ifindex;
 	u32 flags;
+	u32 tgt_index;
 	struct bpf_map *map;
 	struct bpf_map *map_to_flush;
 	u32 kern_flags;
diff --git a/net/core/filter.c b/net/core/filter.c
index 183bf4d8e301..1d7f5f7f32cf 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2158,8 +2158,8 @@ BPF_CALL_2(bpf_redirect, u32, ifindex, u64, flags)
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
 		return TC_ACT_SHOT;
 
-	ri->ifindex = ifindex;
 	ri->flags = flags;
+	ri->tgt_index = ifindex;
 
 	return TC_ACT_REDIRECT;
 }
@@ -2169,8 +2169,8 @@ int skb_do_redirect(struct sk_buff *skb)
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	struct net_device *dev;
 
-	dev = dev_get_by_index_rcu(dev_net(skb->dev), ri->ifindex);
-	ri->ifindex = 0;
+	dev = dev_get_by_index_rcu(dev_net(skb->dev), ri->tgt_index);
+	ri->tgt_index = 0;
 	if (unlikely(!dev)) {
 		kfree_skb(skb);
 		return -EINVAL;
@@ -3488,11 +3488,11 @@ xdp_do_redirect_slow(struct net_device *dev, struct xdp_buff *xdp,
 		     struct bpf_prog *xdp_prog, struct bpf_redirect_info *ri)
 {
 	struct net_device *fwd;
-	u32 index = ri->ifindex;
+	u32 index = ri->tgt_index;
 	int err;
 
 	fwd = dev_get_by_index_rcu(dev_net(dev), index);
-	ri->ifindex = 0;
+	ri->tgt_index = 0;
 	if (unlikely(!fwd)) {
 		err = -EINVAL;
 		goto err;
@@ -3604,11 +3604,11 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
 			       struct bpf_prog *xdp_prog, struct bpf_map *map,
 			       struct bpf_redirect_info *ri)
 {
-	u32 index = ri->ifindex;
+	u32 index = ri->tgt_index;
 	void *fwd = NULL;
 	int err;
 
-	ri->ifindex = 0;
+	ri->tgt_index = 0;
 	WRITE_ONCE(ri->map, NULL);
 
 	fwd = __xdp_map_lookup_elem(map, index);
@@ -3651,11 +3651,11 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct bpf_map *map)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	u32 index = ri->ifindex;
+	u32 index = ri->tgt_index;
 	void *fwd = NULL;
 	int err = 0;
 
-	ri->ifindex = 0;
+	ri->tgt_index = 0;
 	WRITE_ONCE(ri->map, NULL);
 
 	fwd = __xdp_map_lookup_elem(map, index);
@@ -3695,14 +3695,14 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	struct bpf_map *map = READ_ONCE(ri->map);
-	u32 index = ri->ifindex;
+	u32 index = ri->tgt_index;
 	struct net_device *fwd;
 	int err = 0;
 
 	if (map)
 		return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog,
 						   map);
-	ri->ifindex = 0;
+	ri->tgt_index = 0;
 	fwd = dev_get_by_index_rcu(dev_net(dev), index);
 	if (unlikely(!fwd)) {
 		err = -EINVAL;
@@ -3730,8 +3730,8 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
 	if (unlikely(flags))
 		return XDP_ABORTED;
 
-	ri->ifindex = ifindex;
 	ri->flags = flags;
+	ri->tgt_index = ifindex;
 	WRITE_ONCE(ri->map, NULL);
 
 	return XDP_REDIRECT;
@@ -3753,8 +3753,8 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	if (unlikely(flags))
 		return XDP_ABORTED;
 
-	ri->ifindex = ifindex;
 	ri->flags = flags;
+	ri->tgt_index = ifindex;
 	WRITE_ONCE(ri->map, map);
 
 	return XDP_REDIRECT;

