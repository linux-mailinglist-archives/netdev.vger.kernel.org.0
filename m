Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D05C43B8C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbfFMPaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:30:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38699 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbfFMLRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 07:17:24 -0400
Received: by mail-ed1-f68.google.com with SMTP id g13so30651983edu.5
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 04:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GHlkqM/XQzstZCoC0NFCkjg0Zsjh22ckk61fEw4KSz4=;
        b=UPBmBYiicrJ7vc5IM72tpcdnWx4BgsvMRgFSHnWmZZ+DSgyHJ7xve7bSA10UNiP5mn
         hlV88+IbTQRDPzfF1TymW32OIJHbqiB3lxEuPOJdtYYn9CtjDj8xPAu82onZEjgaD4DG
         mKBXmr02upwuV7SG36t6paEiIRXmT8SNI128i0AHEIEehjF5a6hKyGjEKQOBTkgUjuG3
         jOT3VezIA0QXrrXqDnP6x79v9vjau2CCoxV8FpzGxgrK5LnL4L8mDo32aZYq2VOZ4La6
         jTajHs3HagVeOMpiFXSp8ZyG0wFpxZaNWEM4CKx74uBBCIMMxXzQLkRxLrKQajtxO0Ju
         FyNw==
X-Gm-Message-State: APjAAAU4Dt3e5tz9vXGxj/plg0T1p8uU/E7ioC9Jxgk2iIZ9mLjTBm2B
        wkpK9Vv33/KUgz4Jhrcf/g0caw==
X-Google-Smtp-Source: APXvYqzUM41GKsSEJS2S1ru85u7Il/wjzDW7ByFzdhr61/4pcMU61FwRwDBsFv0aQPDGWubbgkRxSw==
X-Received: by 2002:a17:906:1806:: with SMTP id v6mr11130578eje.134.1560424643178;
        Thu, 13 Jun 2019 04:17:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id j3sm798871edh.82.2019.06.13.04.17.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 04:17:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9D35C181CC7; Thu, 13 Jun 2019 13:17:21 +0200 (CEST)
Subject: [PATCH bpf-next v4 2/3] bpf_xdp_redirect_map: Perform map lookup in
 eBPF helper
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Thu, 13 Jun 2019 13:17:21 +0200
Message-ID: <156042464155.25684.9001494922674130772.stgit@alrua-x1>
In-Reply-To: <156042464138.25684.15061870566905680617.stgit@alrua-x1>
References: <156042464138.25684.15061870566905680617.stgit@alrua-x1>
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
 include/linux/filter.h |    1 +
 net/core/filter.c      |   27 +++++++++++++--------------
 2 files changed, 14 insertions(+), 14 deletions(-)

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
diff --git a/net/core/filter.c b/net/core/filter.c
index 7a996887c500..7d742ea61e2d 100644
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
@@ -3753,9 +3745,16 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
-	if (unlikely(flags))
+	/* Lower bits of the flags are used as return code on lookup failure */
+	if (unlikely(flags > XDP_TX))
 		return XDP_ABORTED;
 
+	ri->item = __xdp_map_lookup_elem(map, ifindex);
+	if (unlikely(!ri->item)) {
+		WRITE_ONCE(ri->map, NULL);
+		return flags;
+	}
+
 	ri->ifindex = ifindex;
 	ri->flags = flags;
 	WRITE_ONCE(ri->map, map);

