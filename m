Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544ED4F983
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 04:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfFWCRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 22:17:51 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34649 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFWCRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 22:17:47 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so15988990edb.1
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 19:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=E1nMowP1E26vuJ5z8XmTyXKmU+ywKevwKaI/iOnVIwM=;
        b=QS8yWO8rIP2VgnNeLflPR0Gi++I/RiZpVFApb75D75tAU4gjdJD04BtD6PWPX/5C9Z
         qeL+Kl8guY8lfbdH3GgAQSThPInhsXt5CsEBKDgpZcdj79TvhU/9SrTWwqcQCfqGw6VC
         JtVZhgUOYb7Dw40c+cro0RKaATnf4GeS7/dvYiDN0IkMVoxtCRjo8g8qB6Ig5x3X7300
         shLs5kU1ufA9Ea4qwWauFyPhzfiE4djj2JpcqS2Ozy2YJRz2f6qSUrATtofAcrjTB9k4
         nokyjTQoL7kSpNQt2zO0oEX3G1REBUyNnNE+WWFZKad4TY7Mqvyz84fkeNYNKRAlcGS6
         foyg==
X-Gm-Message-State: APjAAAUFeVxUiJb+WWKM4eAeIC6Q/9SHm7GT8LwC2ypcXV0XevHTOk3a
        1ue22r135DyjEa7wGAlMdDhyU8HHswI=
X-Google-Smtp-Source: APXvYqwbtVJ5QOF1mu4OmD2yCoAW22i+PRG6o2UaWr7Es/0UdUY3ISJuGLQlKRwWhYU31J2KIepD6Q==
X-Received: by 2002:a17:906:5399:: with SMTP id g25mr107240370ejo.247.1561256265344;
        Sat, 22 Jun 2019 19:17:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id g2sm2365619edg.81.2019.06.22.19.17.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 22 Jun 2019 19:17:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8D50D181CEF; Sat, 22 Jun 2019 22:17:41 -0400 (EDT)
Subject: [PATCH bpf-next v5 2/3] bpf_xdp_redirect_map: Perform map lookup in
 eBPF helper
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Sat, 22 Jun 2019 22:17:41 -0400
Message-ID: <156125626136.5209.14349225282974871197.stgit@alrua-x1>
In-Reply-To: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
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
 include/uapi/linux/bpf.h |    7 +++++--
 net/core/filter.c        |   27 +++++++++++++--------------
 3 files changed, 19 insertions(+), 16 deletions(-)

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
index b077507efa3f..59f3fe61b2b0 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1568,8 +1568,11 @@ union bpf_attr {
  * 		but this is only implemented for native XDP (with driver
  * 		support) as of this writing).
  *
- * 		All values for *flags* are reserved for future usage, and must
- * 		be left at zero.
+ * 		The lower two bits of *flags* are used as the return code if
+ * 		the map lookup fails. This is so that the return value can be
+ * 		one of the XDP program return codes up to XDP_TX, as chosen by
+ * 		the caller. Any higher bits in the *flags* argument must be
+ * 		unset.
  *
  * 		When used to redirect packets to net devices, this helper
  * 		provides a high performance increase over **bpf_redirect**\ ().
diff --git a/net/core/filter.c b/net/core/filter.c
index 183bf4d8e301..a6779e1cc1b8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3605,17 +3605,13 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
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
 
@@ -3652,18 +3648,13 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
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
 
@@ -3732,6 +3723,7 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
 
 	ri->ifindex = ifindex;
 	ri->flags = flags;
+	ri->item = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
 	return XDP_REDIRECT;
@@ -3750,9 +3742,16 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
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

