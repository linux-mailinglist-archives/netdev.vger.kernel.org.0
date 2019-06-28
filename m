Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEB259705
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfF1JMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 05:12:55 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36901 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfF1JMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 05:12:40 -0400
Received: by mail-ed1-f65.google.com with SMTP id w13so10064288eds.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 02:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ySB8y1t45KH4jyt90luiXfVP8mLcfeyb89oxV65gNIk=;
        b=sh5mNSwGyHcX5tjiT/tQHOwn4NFqBwNlMb2MY7wQ8WrUXCl10m7v4xD8HO4PsaqCoK
         y40MtGarIGhjr2s+rFyWW4zohixqEv1a29qs3FEAt9DLg1vz/5PJF/UiveYI/C0/OETK
         s8iDYRBukfTGQGcPpmd2YXs+DaYec0FbuPxwsZXHmZmrAeMXy78iAMrMMkx8oNs/QSi6
         k+7yXL6flPuTqIUbdE86DcwM1X3odDqFXZYt/QO1WKB2R7f0hvWRFr5l5TUneR8u9s8f
         8ZWYiivYirTV4RNPRO1ADF0VcpJW8HXPkT6gdBiZGNqW4Xc4Zgg6APITuydWHpI1mK15
         qiYw==
X-Gm-Message-State: APjAAAXOZRICSuMUa8EuwIyXemwslPbKsnNqQSHfM9LMyUA/dVs42mwk
        Fl5Ru3RRpmLTNpgOMdKl4UUTTQ==
X-Google-Smtp-Source: APXvYqywnBw+gUYirlW6fQXWXhgXN7L81fZG0xzogKPfAayIPtnqtysFCoAVZvQNO5esYI6ipCEvtA==
X-Received: by 2002:a50:b87c:: with SMTP id k57mr9758484ede.226.1561713158790;
        Fri, 28 Jun 2019 02:12:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id j10sm346342ejk.23.2019.06.28.02.12.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:12:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C6C14181CA8; Fri, 28 Jun 2019 11:12:34 +0200 (CEST)
Subject: [PATCH bpf-next v6 1/5] xskmap: Move non-standard list manipulation
 to helper
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Fri, 28 Jun 2019 11:12:34 +0200
Message-ID: <156171315475.9468.14364052329841880391.stgit@alrua-x1>
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

Add a helper in list.h for the non-standard way of clearing a list that is
used in xskmap. This makes it easier to reuse it in the other map types,
and also makes sure this usage is not forgotten in any list refactorings in
the future.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/list.h |   14 ++++++++++++++
 kernel/bpf/xskmap.c  |    3 +--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index e951228db4b2..85c92555e31f 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -106,6 +106,20 @@ static inline void __list_del(struct list_head * prev, struct list_head * next)
 	WRITE_ONCE(prev->next, next);
 }
 
+/*
+ * Delete a list entry and clear the 'prev' pointer.
+ *
+ * This is a special-purpose list clearing method used in the networking code
+ * for lists allocated as per-cpu, where we don't want to incur the extra
+ * WRITE_ONCE() overhead of a regular list_del_init(). The code that uses this
+ * needs to check the node 'prev' pointer instead of calling list_empty().
+ */
+static inline void __list_del_clearprev(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->prev = NULL;
+}
+
 /**
  * list_del - deletes entry from list.
  * @entry: the element to delete from the list.
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index ef7338cebd18..9bb96ace9fa1 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -145,8 +145,7 @@ void __xsk_map_flush(struct bpf_map *map)
 
 	list_for_each_entry_safe(xs, tmp, flush_list, flush_node) {
 		xsk_flush(xs);
-		__list_del(xs->flush_node.prev, xs->flush_node.next);
-		xs->flush_node.prev = NULL;
+		__list_del_clearprev(&xs->flush_node);
 	}
 }
 

