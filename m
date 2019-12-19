Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B164125B51
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfLSGKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:10:49 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53562 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSGKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:10:49 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so1990808pjc.3;
        Wed, 18 Dec 2019 22:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ppHk/LnD7UWZImTS1yLOWDv3xjb/+s/0HJ+r7eTy/7A=;
        b=cwEO/UhVNXYZ1svCZTRYsQaZod9jZt1uKl/6RLa2F8QlIxam8vg27UFIIkomqYtDp6
         hyZMYBVts6tzIp7UjBcOocSisiCjGri8mCEjqmajyhq3PjsugqlHVV6U2AqU3PaRh2PZ
         sS1Iv1nSNImu083LYq1OUdouTagMhx3ABW55g8fM5QVUP28dQ1EEvgNqqrb7dbKyVV5L
         eC5ATcupO+N1kZ7vrZ2BSFXizvlXc8HxkRkqw59WJwpcNglb2RgdaDDtLgykAQcIe+5w
         GtLtwJchcY8rEawzwbU78HpjdMq8SErVxo7dl0fEKlN/DkWYaDZLd63KUf+7q9hmfmaV
         XaBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ppHk/LnD7UWZImTS1yLOWDv3xjb/+s/0HJ+r7eTy/7A=;
        b=h4n4SjIW3Ty3crAfBtOBNi0D2bPhKzSO/DeiUyhI6JfrwBzLXxhMjgLOJp/tBXzV4C
         5Om9gyzNh9KtxaYwwOOs7wH9n/Aj8h+IgHzkCyc5gBGUEu65mJlSB8JqcF55TPDnwFCE
         HbyCBJQrWJQz5G1gxMG6dlW8I6/q3OwZI3OExYP5djHHUA58ZL8NQ5i5+dSAd0Byab1S
         Fw9qEt9AB12rFAHSQF2+Rk/g5/Biv8jOies84+/hfqO6qfVICkkA45+DX8QhJBaoRvCf
         fww5i7YnRM4OlnfjfcYzLb41T3RLQun6aFQK56cce3dY1QfgwFFOkyP8t7pyZ1DP9j9X
         ZF/A==
X-Gm-Message-State: APjAAAUHd+qZbUPOZGYc7SOB9NVVWxlf6CoAHHwmNBt7e9nuVbYLt8EQ
        WDyn082KrWORwHzTiKpaWSWtXVjLyATgxg==
X-Google-Smtp-Source: APXvYqwhZbIxE90310PqW5qIiOOEy+62HdKwuCcBOfGcccwQVRb2Kgn8tdLUUYhfYX0D+SLRQR85Ng==
X-Received: by 2002:a17:902:6a8c:: with SMTP id n12mr7389101plk.152.1576735848309;
        Wed, 18 Dec 2019 22:10:48 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t23sm6465062pfq.106.2019.12.18.22.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 22:10:47 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 7/8] xdp: remove map_to_flush and map swap detection
Date:   Thu, 19 Dec 2019 07:10:05 +0100
Message-Id: <20191219061006.21980-8-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191219061006.21980-1-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Now that all XDP maps that can be used with bpf_redirect_map() tracks
entries to be flushed in a global fashion, there is not need to track
that the map has changed and flush from xdp_do_generic_map()
anymore. All entries will be flushed in xdp_do_flush_map().

This means that the map_to_flush can be removed, and the corresponding
checks. Moving the flush logic to one place, xdp_do_flush_map(), give
a bulking behavior and performance boost.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/filter.h |  1 -
 net/core/filter.c      | 27 +++------------------------
 2 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 37ac7025031d..69d6706fc889 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -592,7 +592,6 @@ struct bpf_redirect_info {
 	u32 tgt_index;
 	void *tgt_value;
 	struct bpf_map *map;
-	struct bpf_map *map_to_flush;
 	u32 kern_flags;
 };
 
diff --git a/net/core/filter.c b/net/core/filter.c
index c706325b3e66..d9caa3e57ea1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3547,26 +3547,9 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 
 void xdp_do_flush_map(void)
 {
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	struct bpf_map *map = ri->map_to_flush;
-
-	ri->map_to_flush = NULL;
-	if (map) {
-		switch (map->map_type) {
-		case BPF_MAP_TYPE_DEVMAP:
-		case BPF_MAP_TYPE_DEVMAP_HASH:
-			__dev_map_flush();
-			break;
-		case BPF_MAP_TYPE_CPUMAP:
-			__cpu_map_flush();
-			break;
-		case BPF_MAP_TYPE_XSKMAP:
-			__xsk_map_flush();
-			break;
-		default:
-			break;
-		}
-	}
+	__dev_map_flush();
+	__cpu_map_flush();
+	__xsk_map_flush();
 }
 EXPORT_SYMBOL_GPL(xdp_do_flush_map);
 
@@ -3615,14 +3598,10 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
 	ri->tgt_value = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
-	if (ri->map_to_flush && unlikely(ri->map_to_flush != map))
-		xdp_do_flush_map();
-
 	err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
 	if (unlikely(err))
 		goto err;
 
-	ri->map_to_flush = map;
 	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map, index);
 	return 0;
 err:
-- 
2.20.1

