Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64ABC4575F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfFNIUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:20:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43336 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfFNIUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:20:37 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so1107529pgv.10;
        Fri, 14 Jun 2019 01:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8qHhibZPtQ7Gu7/olGLfM6ZKwz0g2uJPETyalb8BGDY=;
        b=PvPXwxHtSi2X+SHN7HOb2h9oiAi3X+dtgGr4LGlL6w/ZoiR3fFc/TTcMUtqmmVqTxv
         M2zHUY9hyPjgtqr16Vn0Mxk/Gx9B3sGiN7NHb8osulGFXGpTm+1DYCVx4u9inWl2/gl0
         DzLE4Atzam/qTVBfWos7rj3rqPolGM8z62qMEpTxM/uOeqsQ6NG1I+nZ0NjJZF/yqcwf
         VghDd/4l1Rq3dVXz6oYuaaOclIP/v1FFJ4kDoUbXxGv+Lm/GWRJCH6lk+08WTsjad5kA
         WizivxzWG1UDdIxJGMyVAea568VWP8Rf9fveM5YBSHjKziqGIwMAZ2naol6FtGGgXLa5
         k/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8qHhibZPtQ7Gu7/olGLfM6ZKwz0g2uJPETyalb8BGDY=;
        b=SdYcvIo4ByupVkQdMvurz9a7+4EZLc5rFu3K5daN5boIuMf6y4nvcs0Mdcim/qCawI
         fOvrfjXWa+iEy+K93kVbnZH/8qcexL2K9F+LCftL25GJMAVGcFy6kB0b/prby1k7OiMB
         +GV2Zup0RG1lg8nkpavUdVUk5IrwXB5/ycjZe/Fhp3T3Tc2QBy8YYJQ4mur2o1Ea0kVw
         Oa5OdVF8DE4H3KrZjqHv26LAi0a4KlV2jlDw+fuxxYbi+ANq+BGenpyDqeTnR8XJBU3N
         NS9B/0wLvsQdFX8L91EpVRfKobD0xwapKA7Yvw3KOdjLKw6+BIcSu6WwfLMaxtg3Xb9k
         3bog==
X-Gm-Message-State: APjAAAVBtvUsrHeqvLMAVXmA9pnhmKsg6F9DRL0pE0Tu68yS3UZfHJ0+
        AYChnYunU+knWBNSNFZApSo=
X-Google-Smtp-Source: APXvYqxa5lSv6MbyuN3w6u8/9qOHc1kXb15XNTlcw6E4F4L/Q3nHEH5n/44xhn17QFtDJ2YPCg5ZOw==
X-Received: by 2002:a17:90a:8d86:: with SMTP id d6mr9387075pjo.127.1560500436830;
        Fri, 14 Jun 2019 01:20:36 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id t18sm3352343pgm.69.2019.06.14.01.20.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 01:20:36 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH bpf 3/3] devmap: Add missing RCU read lock on flush
Date:   Fri, 14 Jun 2019 17:20:15 +0900
Message-Id: <20190614082015.23336-4-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.ndo_xdp_xmit() assumes it is called under RCU. For example virtio_net
uses RCU to detect it has setup the resources for tx. The assumption
accidentally broke when introducing bulk queue in devmap.

Fixes: 5d053f9da431 ("bpf: devmap prepare xdp frames for bulking")
Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 kernel/bpf/devmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a126d95..1defea4 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -282,6 +282,7 @@ void __dev_map_flush(struct bpf_map *map)
 	unsigned long *bitmap = this_cpu_ptr(dtab->flush_needed);
 	u32 bit;
 
+	rcu_read_lock();
 	for_each_set_bit(bit, bitmap, map->max_entries) {
 		struct bpf_dtab_netdev *dev = READ_ONCE(dtab->netdev_map[bit]);
 		struct xdp_bulk_queue *bq;
@@ -297,6 +298,7 @@ void __dev_map_flush(struct bpf_map *map)
 
 		__clear_bit(bit, bitmap);
 	}
+	rcu_read_unlock();
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
@@ -389,6 +391,7 @@ static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
 
 		int cpu;
 
+		rcu_read_lock();
 		for_each_online_cpu(cpu) {
 			bitmap = per_cpu_ptr(dev->dtab->flush_needed, cpu);
 			__clear_bit(dev->bit, bitmap);
@@ -396,6 +399,7 @@ static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
 			bq = per_cpu_ptr(dev->bulkq, cpu);
 			bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, false);
 		}
+		rcu_read_unlock();
 	}
 }
 
-- 
1.8.3.1

