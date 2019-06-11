Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550F53D12E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391774AbfFKPoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:44:04 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36599 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391456AbfFKPoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:44:03 -0400
Received: by mail-ed1-f65.google.com with SMTP id k21so17446865edq.3
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 08:44:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jyxSFzyfwPtk/NcoyKB5epTfvzj/WCe70nxcjWrHyn4=;
        b=YO7uwgO221wXPlYldvqD6WlovaoRnzzcq5C9+WHO89jxD7V8ceVmXNY+YSfFYUJEvG
         xIo2L2qlz7MFcaDkj60Oh4WZg7oTt5/7CCJPKTa20Y3lUwUEL41zbo7hchysVm2+Ic1O
         pW6vsZPK+X48atV3x0a/ttG3wwglyD/LypYK133bJs02Qagye/2Lrq5aKUiSSY34qP3+
         Nh60GXMhZeN0aNHcUx9HJUS8HCTk6DQf2E/42sSVuyaIpzRWfAjVxKROiACxMHsrkWga
         OzQ7ZfLV0VIv7/Nzc1R/shBIUd0jkp3q1y98ME4Ch/HVA7eBDHAl8yDk/pKNHUF6mOUn
         m+Eg==
X-Gm-Message-State: APjAAAWjGkcYlxh0aBCmKWIwV0mXJnYkco4tW/2kkE1HEFpD7RtR4sHT
        vJKsM27Ord9YEXjMyR5DUnAaG5ik/l4=
X-Google-Smtp-Source: APXvYqzT06zgv6kRhgpnefXpfaBz6186M854yGqF7Ec6W0yFhRb6ygxzF3AsE8CHz904YVEgMR2/VQ==
X-Received: by 2002:a50:ad0c:: with SMTP id y12mr34581386edc.25.1560267841976;
        Tue, 11 Jun 2019 08:44:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id o19sm3740340edt.87.2019.06.11.08.44.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 08:44:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2C368181CC7; Tue, 11 Jun 2019 17:44:00 +0200 (CEST)
Subject: [PATCH bpf-next v3 2/3] bpf_xdp_redirect_map: Perform map lookup in
 eBPF helper
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Tue, 11 Jun 2019 17:44:00 +0200
Message-ID: <156026784011.26748.7290735899755011809.stgit@alrua-x1>
In-Reply-To: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
References: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The bpf_redirect_map() helper used by XDP programs doesn't return any
indication of whether it can successfully redirect to the map index it was
given. Instead, BPF programs have to track this themselves, leading to
programs using duplicate maps to track which entries are populated in the
devmap.

This patch fixes this by moving the map lookup into the bpf_redirect_map()
helper, which makes it possible to return failure to the eBPF program. The
lower bits of the flags argument is used as the return code, which means
that existing users who pass a '0' flag argument will get XDP_ABORTED.

With this, a BPF program can check the return code from the helper call and
react by, for instance, substituting a different redirect. This works for
any type of map used for redirect.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/filter.h   |    1 +
 include/uapi/linux/bpf.h |    8 ++++++++
 net/core/filter.c        |   26 ++++++++++++--------------
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 43b45d6db36d..f31ae8b9035a 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -580,6 +580,7 @@ struct bpf_skb_data_end {
 struct bpf_redirect_info {
 	u32 ifindex;
 	u32 flags;
+	void *item;
 	struct bpf_map *map;
 	struct bpf_map *map_to_flush;
 	u32 kern_flags;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7c6aef253173..9931cf02de19 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3098,6 +3098,14 @@ enum xdp_action {
 	XDP_REDIRECT,
 };
 
+/* Flags for bpf_xdp_redirect_map helper */
+
+/* The lower flag bits will be the return code of bpf_xdp_redirect_map() helper
+ * if the map lookup fails.
+ */
+#define XDP_REDIRECT_INVALID_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)
+#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_INVALID_MASK
+
 /* user accessible metadata for XDP packet hook
  * new fields must be added to the end of this structure
  */
diff --git a/net/core/filter.c b/net/core/filter.c
index 7a996887c500..dd43be497480 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3608,17 +3608,13 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
 			       struct bpf_redirect_info *ri)
 {
 	u32 index = ri->ifindex;
-	void *fwd = NULL;
+	void *fwd = ri->item;
 	int err;
 
 	ri->ifindex = 0;
+	ri->item = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
-	fwd = __xdp_map_lookup_elem(map, index);
-	if (unlikely(!fwd)) {
-		err = -EINVAL;
-		goto err;
-	}
 	if (ri->map_to_flush && unlikely(ri->map_to_flush != map))
 		xdp_do_flush_map();
 
@@ -3655,18 +3651,13 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	u32 index = ri->ifindex;
-	void *fwd = NULL;
+	void *fwd = ri->item;
 	int err = 0;
 
 	ri->ifindex = 0;
+	ri->item = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
-	fwd = __xdp_map_lookup_elem(map, index);
-	if (unlikely(!fwd)) {
-		err = -EINVAL;
-		goto err;
-	}
-
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		struct bpf_dtab_netdev *dst = fwd;
 
@@ -3735,6 +3726,7 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
 
 	ri->ifindex = ifindex;
 	ri->flags = flags;
+	ri->item = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
 	return XDP_REDIRECT;
@@ -3753,9 +3745,15 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
-	if (unlikely(flags))
+	if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
 		return XDP_ABORTED;
 
+	ri->item = __xdp_map_lookup_elem(map, ifindex);
+	if (unlikely(!ri->item)) {
+		WRITE_ONCE(ri->map, NULL);
+		return (flags & XDP_REDIRECT_INVALID_MASK);
+	}
+
 	ri->ifindex = ifindex;
 	ri->flags = flags;
 	WRITE_ONCE(ri->map, map);

